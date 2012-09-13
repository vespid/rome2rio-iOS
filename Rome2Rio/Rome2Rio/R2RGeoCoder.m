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

@property(strong, nonatomic) R2RConnection *r2rConnection;

enum {
    stateEmpty = 0,
    stateEditingDidBegin,
    stateEditingDidEnd,
    stateResolved,
    stateLocationNotFound
};

@end

@implementation R2RGeoCoder

@synthesize geoCodeResponse, responseCompletionState, searchString;
@synthesize delegate;

-(id) initWithSearchString:(NSString *)initSearchString delegate:(id<R2RGeoCoderDelegate>)r2rGeoCoderDelegate
{
    self = [super init];
    
    if (self != nil)
    {
        self.delegate = r2rGeoCoderDelegate;
        self.searchString = initSearchString;
    }
    
    return self;
    
}

-(void) sendAsynchronousRequest
{
    NSString *geoCoderString = [NSString stringWithFormat:@"http://prototype.rome2rio.com/api/1.2/json/GeoCode?key=wOAPMlcG&query=%@", self.searchString];
    
    NSString *geoCoderEncoded = [geoCoderString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    NSURL *getCoderUrl =  [NSURL URLWithString:geoCoderEncoded];
    
    self.r2rConnection = [[R2RConnection alloc] initWithConnectionUrl:getCoderUrl delegate:self];
    
    self.responseCompletionState = stateEditingDidEnd;
    
}

-(void) parseJson
{
    NSLog(@"Succeeded! Received %d bytes of data from Geocoder",[self.r2rConnection.responseData length]);
    
    NSError *error = nil;
    
    NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:self.r2rConnection.responseData options:kNilOptions error:&error];
    
    // show all values/////////////////////////////
    for(id key in responseData) {
        
        id value = [responseData objectForKey:key];
        
        NSString *keyAsString = (NSString *)key;
        NSString *valueAsString = (NSString *)value;
        
        NSLog(@"key: %@", keyAsString);
        NSLog(@"value: %@", valueAsString);
    }/////////////////////////////////////////////
    
    
    self.geoCodeResponse = [self parseData:responseData];
    
//    for(R2RPlace* place in self.geoCodeResponse.places)
//    {
//        NSLog(@"stored\t%@\t%@\t%@\t%@\t", place.shortName, place.longName, place.kind, place.regionCode);
//    }
}

-(R2RGeoCodeResponse*) parseData:(NSDictionary* )responseData
{
    R2RGeoCodeResponse  *geoCode = [R2RGeoCodeResponse alloc];
    
    geoCode.name = [responseData objectForKey:@"name"];
    geoCode.country = [responseData objectForKey:@"country"];
    geoCode.language = [responseData objectForKey:@"language"];
    
    NSMutableArray *places = [self parsePlaces:[responseData objectForKey:@"places"]];
    if (places != nil)
    {
        geoCode.place = [places objectAtIndex:0];
    }
    else
    {
        //sendStatusNotification
        self.responseCompletionState = stateLocationNotFound;
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
    
    [self parseJson];
    
    ////set status to complete/resolved
    ////then call delegate for R2RViewController to set text box to place.Name;
    
    //delay testing
    //[[self delegate] R2RGeoCoderResolved:self];
    //self.responseCompletionState = stateResolved;
    [self performSelector:@selector(GeoCoderDelegateDelayTest) withObject:nil afterDelay:3.0];
    
    //self.responseCompletionState = stateResolved;
    
}

- (void) GeoCoderDelegateDelayTest
{
    self.responseCompletionState = stateResolved;
    [[self delegate] R2RGeoCoderResolved:self];
   
}


@end
