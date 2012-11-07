//
//  R2RAutocomplete.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 31/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RAutocomplete.h"

@interface R2RAutocomplete() <R2RConnectionDelegate>

@property (strong, nonatomic) R2RConnection *r2rConnection;

@property (strong, nonatomic) NSString *query;
@property (strong, nonatomic) NSString *countryCode;
@property (strong, nonatomic) NSString *language;

@property (nonatomic) NSInteger retryCount;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

@end

@implementation R2RAutocomplete

@synthesize geoCodeResponse, responseCompletionState, searchString, responseMessage;
@synthesize delegate;

-(id) initWithSearch:(NSString *)query :(NSString *)countryCode :(NSString *)language delegate:(id<R2RAutocompleteDelegate>)autocompleteDelegate
{
    self = [super init];
    
    if (self != nil)
    {
        self.retryCount = 0;
        self.delegate = autocompleteDelegate;
        self.query = query;
        self.countryCode = countryCode;
        self.language = language;
    }
    
    return self;
}

-(id) initWithSearchString:(NSString *)initSearchString delegate:(id<R2RAutocompleteDelegate>)autocompleteDelegate
{
    self = [super init];
    
    if (self != nil)
    {
        self.retryCount = 0;
        self.delegate = autocompleteDelegate;
        self.query = initSearchString;
    }
    return self;
}


-(void) sendAsynchronousRequest
{
    NSMutableString *geoCoderString = [[NSMutableString alloc] init];
    
#if DEBUG
    [geoCoderString appendFormat:@"http://prototype.rome2rio.com/api/1.2/json/Autocomplete?key=wOAPMlcG&query=%@", self.query];
#else
    [geoCoderString appendFormat:@"http://ios.rome2rio.com/api/1.2/json/utocomplete?key=wOAPMlcG&query=%@", self.query];
#endif
    
    if ([self.countryCode length] > 0)
    {
        [geoCoderString appendFormat:@"&countryCode=%@", self.countryCode];
    }
    
    if ([self.language length] > 0)
    {
        [geoCoderString appendFormat:@"&language=%@", self.language];
    }
    
    NSString *geoCoderEncoded = [geoCoderString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *getCoderUrl =  [NSURL URLWithString:geoCoderEncoded];
    
    self.r2rConnection = [[R2RConnection alloc] initWithConnectionUrl:getCoderUrl delegate:self];
    
    self.responseCompletionState = stateResolving;
    
    [self performSelector:@selector(connectionTimeout:) withObject:[NSNumber numberWithInt:self.retryCount] afterDelay:5.0];
}

-(void) parseJson
{
    NSError *error = nil;
    
    NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:self.r2rConnection.responseData options:kNilOptions error:&error];
    
    self.geoCodeResponse = [self parseData:responseData];
}

-(R2RGeoCodeResponse*) parseData:(NSDictionary* )responseData
{
    R2RGeoCodeResponse  *geoCode = [R2RGeoCodeResponse alloc];
    
    geoCode.name = [responseData objectForKey:@"name"];
    geoCode.country = [responseData objectForKey:@"countryCode"];
    geoCode.language = [responseData objectForKey:@"language"];
    
    geoCode.places = [self parsePlaces:[responseData objectForKey:@"places"]];

    self.responseCompletionState = stateResolved;
    self.responseMessage = @"";
    
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
    place.code = [placeResonse objectForKey:@"code"];
    
    return place;
}

- (void) R2RConnectionProcessData:(R2RConnection *) delegateConnection
{
    if (self.r2rConnection == delegateConnection)
    {
        [self parseJson];
        if ( self.responseCompletionState == stateResolved)
        {
            [[self delegate] autocompleteResolved:self];
        }
    }
}

- (void) R2RConnectionError:(R2RConnection *)delegateConnection
{
    if (self.retryCount < 5)
    {
        [self performSelector:@selector(sendAsynchronousRequest) withObject:nil afterDelay:1.0];
        self.retryCount++;
    }
    else
    {
        self.responseCompletionState = stateError;
        self.responseMessage = @"Unable to find location";
        R2RLog(@"Error");
        
        [[self delegate] autocompleteResolved:self];
    }
}

- (void) connectionTimeout: (NSNumber *) retryNumber
{
    if (self.responseCompletionState == stateResolving)
    {
        if (self.retryCount >= 5)
        {
            self.responseCompletionState = stateError;
            self.responseMessage = @"Unable to find location";
            R2RLog(@"Timeout");
            [[self delegate] autocompleteResolved:self];
        }
        
        else if (self.retryCount == [retryNumber integerValue])
        {
            self.retryCount++;
            [self sendAsynchronousRequest];
            
        }
    }
}

-(void)geocodeFallback:(NSString *)query
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:query completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if ([placemarks count] > 0)
         {
             if (!self.geoCodeResponse)
             {
                 self.geoCodeResponse = [[R2RGeoCodeResponse alloc] init];
             }
             if (!self.geoCodeResponse.places)
             {
                 self.geoCodeResponse.places = [[NSMutableArray alloc] init];
             }
             
             for (CLPlacemark *placemark in placemarks)
             {
                 R2RPlace *place = [[R2RPlace alloc] init];
                 
                 NSMutableString *longName = [[NSMutableString alloc] init];
                 NSMutableString *shortName = [[NSMutableString alloc] init];
                 if ([placemark.subThoroughfare length] > 0)
                 {
                     [longName appendFormat:@"%@ ", placemark.subThoroughfare];
                     [shortName appendFormat:@"%@ ", placemark.subThoroughfare];
                 }
                 
                 if ([placemark.thoroughfare length] > 0)
                 {
                     [longName appendFormat:@"%@, ", placemark.thoroughfare];
                     [shortName appendFormat:@"%@", placemark.thoroughfare];
                     place.kind = @":veryspecific";
                 }
                 
                 if ([placemark.subLocality length] > 0)
                     [longName appendFormat:@"%@, ", placemark.subLocality];
                 
                 if ([placemark.locality length] > 0)
                 {
                     [longName appendFormat:@"%@, ", placemark.locality];
                     if ([place.kind length] == 0)
                         place.kind = @"city";
                     if ([shortName length] == 0)
                         [shortName appendString:placemark.locality];
                 }
                 
                 if ([placemark.country length] > 0)
                 {
                     [longName appendFormat:@"%@", placemark.country];
                     if ([place.kind length] == 0)
                         place.kind = @"country";
                     if ([shortName length] == 0)
                         [shortName appendString:placemark.country];
                 }
                 
                 place.longName = [NSString stringWithString:longName];
                 place.shortName = [NSString stringWithString:shortName];
                 place.lat = placemark.region.center.latitude;
                 place.lng = placemark.region.center.longitude;
             
                 [self.geoCodeResponse.places addObject:place];
                 
             }
             
             self.geoCodeResponse.place = [self.geoCodeResponse.places objectAtIndex:0];
             self.responseCompletionState = stateResolved;
             R2RLog(@"Autocomplete: Geocode Fallback: %@", self.geoCodeResponse.place.shortName);
             [[self delegate] autocompleteResolved:self];
             
         }
         else
         {
             R2RLog(@"Autocomplete: Geocode fallback: Unable to find location");
             self.responseMessage = @"Unable to find location";
             if (!self.geoCodeResponse)
             {
                 self.geoCodeResponse = [[R2RGeoCodeResponse alloc] init];
             }
             self.geoCodeResponse.places = nil;
             self.responseCompletionState = stateError;
             
             [[self delegate] autocompleteResolved:self];
         }
     }];
    
}

@end
