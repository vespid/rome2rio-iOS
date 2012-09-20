//
//  R2RGeoCoder.m
//  HttpRequest
//
//  Created by Ash Verdoorn on 30/08/12.
//  Copyright (c) 2012 Ash Verdoorn. All rights reserved.
//

#import "R2RGeoCoder.h"
#import "R2RConnection.h"

@interface R2RGeoCoder() <R2RConnectionDelegate>

@property (strong, nonatomic) R2RConnection *r2rConnection;

@property (strong, nonatomic) NSString *query;
@property (strong, nonatomic) NSString *countryCode;
@property (strong, nonatomic) NSString *language;

@property (nonatomic) NSInteger retryCount;

enum {
    stateEmpty = 0,
    stateEditingDidBegin,
    stateEditingDidEnd,
    stateResolved,
    stateLocationNotFound,
    stateError,
    stateResolving
};

@end

@implementation R2RGeoCoder

@synthesize geoCodeResponse, responseCompletionState, searchString, responseMessage;
@synthesize delegate;

-(id) initWithSearch:(NSString *)query :(NSString *)countryCode :(NSString *)language delegate:(id<R2RGeoCoderDelegate>)r2rGeoCoderDelegate
{
    self = [super init];
    
    if (self != nil)
    {
        self.retryCount = 0;
        self.delegate = r2rGeoCoderDelegate;
        self.query = query;
        self.countryCode = countryCode;
        self.language = language;
    }
    
    return self;
}

-(id) initWithSearchString:(NSString *)initSearchString delegate:(id<R2RGeoCoderDelegate>)r2rGeoCoderDelegate
{
    self = [super init];
    
    if (self != nil)
    {
        self.retryCount = 0;
        self.delegate = r2rGeoCoderDelegate;
        //self.searchString = initSearchString;
        self.query = initSearchString;
    }
    
    return self;
    
}

-(void) sendAsynchronousRequest
{
    //NSString *geoCoderString = [NSString stringWithFormat:@"http://prototype.rome2rio.com/api/1.2/json/GeoCode?key=wOAPMlcG&query=%@", self.query];
    
    NSMutableString *geoCoderString = [NSString stringWithFormat:@"http://prototype.rome2rio.com/api/1.2/json/GeoCode?key=wOAPMlcG&query=%@", self.query];
    
    if ([self.countryCode length] > 0)
    {
        [geoCoderString appendFormat:@"&country=%@", self.countryCode];
    }
    
    if ([self.language length] > 0)
    {
        [geoCoderString appendFormat:@"&language=%@", self.language];
    }
    
    NSString *geoCoderEncoded = [geoCoderString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    NSURL *getCoderUrl =  [NSURL URLWithString:geoCoderEncoded];
    
    self.r2rConnection = [[R2RConnection alloc] initWithConnectionUrl:getCoderUrl delegate:self];
    
    //self.responseCompletionState = stateEditingDidEnd;
    self.responseCompletionState = stateResolving;
    
    
    [self performSelector:@selector(connectionTimeout:) withObject:[NSNumber numberWithInt:self.retryCount] afterDelay:5.0];
    
}

-(void) parseJson
{
    NSLog(@"Succeeded! Received %d bytes of data from Geocoder",[self.r2rConnection.responseData length]);
    
    NSError *error = nil;
    
    NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:self.r2rConnection.responseData options:kNilOptions error:&error];
    
    // show all values/////////////////////////////
//    for(id key in responseData) {
//        
//        id value = [responseData objectForKey:key];
//        
//        NSString *keyAsString = (NSString *)key;
//        NSString *valueAsString = (NSString *)value;
//        
//        NSLog(@"key: %@", keyAsString);
//        NSLog(@"value: %@", valueAsString);
//    }/////////////////////////////////////////////
    
    
    self.geoCodeResponse = [self parseData:responseData];
    
}

-(R2RGeoCodeResponse*) parseData:(NSDictionary* )responseData
{
    R2RGeoCodeResponse  *geoCode = [R2RGeoCodeResponse alloc];
    
    geoCode.name = [responseData objectForKey:@"name"];
    geoCode.country = [responseData objectForKey:@"country"];
    geoCode.language = [responseData objectForKey:@"language"];
    
    NSMutableArray *places = [self parsePlaces:[responseData objectForKey:@"places"]];
    if ([places count] > 0)
    {
        geoCode.place = [places objectAtIndex:0];
        self.responseCompletionState = stateResolved;
    }
    else
    {
        //sendStatusNotification
        self.responseCompletionState = stateError;
        self.responseMessage = @"Location not found ";
    }
    
    
    return geoCode;
}

-(NSMutableArray*) parsePlaces:( NSArray *) placesResponse
{
    
    NSMutableArray *places = [[NSMutableArray alloc] initWithCapacity:[placesResponse count]] ;
    
    for (id placeResponse in placesResponse)
    {
        
        R2RPlace *place = [self parsePlace:placeResponse];
        
        [places addObject:place];
        
    }
    
    return places;
}

-(R2RPlace*) parsePlace:(id) placeResonse
{
    R2RPlace *place = [R2RPlace alloc];
    
    place.longName = [placeResonse objectForKey:@"longName"];
    place.shortName = [placeResonse objectForKey:@"shortName"];
    place.countryCode = [placeResonse objectForKey:@"countryCode"];
    place.countryName = [placeResonse objectForKey:@"countryName"];
    place.kind = [placeResonse objectForKey:@"kind"];
    place.lat = [[placeResonse objectForKey:@"lat"] floatValue];
    place.lng = [[placeResonse objectForKey:@"lng"] floatValue];
    place.rad = [placeResonse objectForKey:@"rad"];
    place.regionCode = [placeResonse objectForKey:@"regionCode"];
    place.regionName = [placeResonse objectForKey:@"regionName"];
    
    return place;
}

- (void) R2RConnectionProcessData:(R2RConnection *) delegateConnection
{
    
    //delay before parsing data
    [self performSelector:@selector(parseJson) withObject:nil afterDelay:4.0];
    //[self parseJson];
    
    ////set status to complete/resolved
    ////then call delegate for R2RViewController to set text box to place.Name;
    
    //delay testing
    //[[self delegate] R2RGeoCoderResolved:self];
    
      
    
    [self performSelector:@selector(GeoCoderDelegateDelayTest) withObject:nil afterDelay:4.0];
    
    //self.responseCompletionState = stateResolved;
    
}

- (void) R2RConnectionError:(R2RConnection *)delegateConnection
{
    if (self.retryCount < 5)
    {
        //on error resend request after 1 second
        NSLog(@"%@ %d", @"Retrying Connection", self.retryCount);
        [self performSelector:@selector(sendAsynchronousRequest) withObject:nil afterDelay:1.0];
        self.retryCount++;
    }
    else
    {
        NSLog(@"%@", @"Connection Failed, too many retries");
        self.responseCompletionState = stateError;
        self.responseMessage = @"Unable to resolve ";
        //self.
    }
}

- (void) connectionTimeout: (NSNumber *) retryNumber
{
    if (self.responseCompletionState == stateResolving)
    {
        if (self.retryCount >= 5)
        {
            NSLog(@"%@", @"Connection Failed, too many retries (timeout)");
            self.responseCompletionState = stateError;
            self.responseMessage = @"Unable to resolve ";
        }
        
        else if (self.retryCount == [retryNumber integerValue])
        {
            NSLog(@"%@ %@ %d", @"Timeout, Retrying Connection", retryNumber, [retryNumber integerValue]);
            [self sendAsynchronousRequest];
            self.retryCount++;
        }
    }
}

- (void) GeoCoderDelegateDelayTest
{
    
    [[self delegate] R2RGeoCoderResolved:self];
   
}


@end
