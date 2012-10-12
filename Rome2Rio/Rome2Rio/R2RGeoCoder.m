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
    NSMutableString *geoCoderString = [[NSMutableString alloc] init];
    
#if DEBUG
    [geoCoderString appendFormat:@"http://prototype.rome2rio.com/api/1.2/json/GeoCode?key=wOAPMlcG&query=%@", self.query];
#else
    [geoCoderString appendFormat:@"http://ios.rome2rio.com/api/1.2/json/GeoCode?key=wOAPMlcG&query=%@", self.query];
    NSLog(@"This will only print in debug!");
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
    
//    NSLog(@"%@ %d %@", @"Geocode Started", self.retryCount, self.query);
    

    self.r2rConnection = [[R2RConnection alloc] initWithConnectionUrl:getCoderUrl delegate:self];

    
    //self.responseCompletionState = stateEditingDidEnd;
    self.responseCompletionState = stateResolving;
    
    
    [self performSelector:@selector(connectionTimeout:) withObject:[NSNumber numberWithInt:self.retryCount] afterDelay:5.0];
    
}

-(void) parseJson
{
//    NSLog(@"Succeeded! Received %d bytes of data from Geocoder",[self.r2rConnection.responseData length]);
    
    NSError *error = nil;
    
    NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:self.r2rConnection.responseData options:kNilOptions error:&error];
    
    
//    NSLog(@"%@", @"values");
//    // show all values/////////////////////////////
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
    geoCode.country = [responseData objectForKey:@"countryCode"];
    geoCode.language = [responseData objectForKey:@"language"];
    
    NSMutableArray *places = [self parsePlaces:[responseData objectForKey:@"places"]];
    if ([places count] > 0)
    {
        geoCode.place = [places objectAtIndex:0];
        self.responseCompletionState = stateResolved;
    }
    else
    {
        [self geocodeFallback:self.query];
        //sendStatusNotification
//        self.responseCompletionState = stateError;
//        self.responseMessage = @"Location not found ";
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
    if (self.r2rConnection == delegateConnection)
    {
        [self parseJson];
        if ( self.responseCompletionState == stateResolved)
        {
//            NSLog(@"%s", "Geocode Parsed");
            [[self delegate] R2RGeoCoderResolved:self];
        }
    }
    
//    if (self.responseCompletionState != stateResolved)
//    {
//        [self parseJson];
//        
////        self.responseCompletionState = stateResolved;
//        
//        NSLog(@"%s", "Geocode Parsed");
//        
//        [[self delegate] R2RGeoCoderResolved:self];
//        //        [self performSelector:@selector(delayTest) withObject:nil afterDelay:0.0];
//    }
//    else
//    {
//        NSLog(@"%s", "Ignore Response, state already resolved");
//    }
    
    //delay before parsing data
//    [self performSelector:@selector(parseJson) withObject:nil afterDelay:0.0];
//    [self parseJson];
    
    ////set status to complete/resolved
    ////then call delegate for R2RViewController to set text box to place.Name;
    
    //delay testing
//    [self performSelector:@selector(GeoCoderDelegateDelayTest) withObject:nil afterDelay:0.0];
//    [[self delegate] R2RGeoCoderResolved:self];
    
//    [self GeoCoderDelegateDelayTest];
    
    //self.responseCompletionState = stateResolved;
    
}

- (void) R2RConnectionError:(R2RConnection *)delegateConnection
{
    if (self.retryCount < 5)
    {
        //on error resend request after 1 second
//        NSLog(@"%@ %d", @"Retrying Connection", self.retryCount);
        [self performSelector:@selector(sendAsynchronousRequest) withObject:nil afterDelay:1.0];
        self.retryCount++;
    }
    else
    {
//        NSLog(@"%@", @"Connection Failed, too many retries");
        self.responseCompletionState = stateError;
        self.responseMessage = @"Unable to find location";
        
        [[self delegate] R2RGeoCoderResolved:self];
//        [self performSelector:@selector(GeoCoderDelegateDelayTest) withObject:nil afterDelay:0.0];
    }
}

- (void) connectionTimeout: (NSNumber *) retryNumber
{
    if (self.responseCompletionState == stateResolving)
    {
        if (self.retryCount >= 5)
        {
//            NSLog(@"%@", @"Connection Failed, too many retries (timeout)");
            self.responseCompletionState = stateError;
            self.responseMessage = @"Unable to find location";
            
            [[self delegate] R2RGeoCoderResolved:self];
//            [self performSelector:@selector(GeoCoderDelegateDelayTest) withObject:nil afterDelay:0.0];
        }
        
        else if (self.retryCount == [retryNumber integerValue])
        {
            self.retryCount++;
//            NSLog(@"%@ %@ %d", @"Timeout, Retrying Connection", retryNumber, [retryNumber integerValue]);
            [self sendAsynchronousRequest];

        }
    }
}

//- (void) GeoCoderDelegateDelayTest
//{
//    
//    [[self delegate] R2RGeoCoderResolved:self];
//   
//}

-(void)geocodeFallback:(NSString *)query
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:query completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if ([placemarks count] > 0)
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             //            self.myLocation = placemark.name;
             
//             NSString *a = placemark.country;
//             NSString *b = placemark.inlandWater;
//             NSString *c = placemark.ISOcountryCode;
//             NSString *d = placemark.locality;
//             NSString *e = placemark.name;
//             NSString *f = placemark.ocean;
//             NSString *g = placemark.postalCode;
//             NSString *h = @"";// [placemark.region description];
//             NSString *i = placemark.subAdministrativeArea;
//             NSString *j = placemark.subLocality;
//             NSString *k = placemark.subThoroughfare;
//             NSString *l = placemark.thoroughfare;
//              
//             CLRegion *region = placemark.region;
//             float lat = region.center.latitude;
//             float lng = region.center.longitude;
//             float rad = region.radius;
             
//             NSLog(@"Forward\tcountry %@, inlandWater %@, ISOcountryCode %@, locality %@, name %@, ocean %@, postalCode %@, region %@, subAdministrativeArea %@, subLocality %@, subThoroughfare %@, thoroughfare %@, lat %f, lng %f, rad %f", a, b, c, d, e, f, g, h, i, j, k, l, lat, lng, rad);
             
             if (!self.geoCodeResponse)
             {
                 self.geoCodeResponse = [[R2RGeoCodeResponse alloc] init];
             }
             
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
                 [longName appendFormat:@"%@ ", placemark.subLocality];
             
             if ([placemark.locality length] > 0)
             {
                 [longName appendFormat:@"%@, ", placemark.locality];
                 if ([place.kind length] == 0)
                     place.kind = @"city";
                 if ([shortName length] == 0)
                     [shortName appendString:query];
             }
             
             if ([placemark.country length] > 0)
             {
                 [longName appendFormat:@"%@", placemark.country];
                 if ([place.kind length] == 0)
                     place.kind = @"country";
                 if ([shortName length] == 0)
                     [shortName appendString:query];
             }
             
             place.longName = [NSString stringWithString:longName];
             place.shortName = [NSString stringWithString:shortName];
             place.lat = placemark.region.center.latitude;
             place.lng = placemark.region.center.longitude;
             
             self.geoCodeResponse.place = place;
             self.responseCompletionState = stateResolved;
             
//             NSLog(@"%s", "Geocode Falback");
             [[self delegate] R2RGeoCoderResolved:self];
       
         }
         else
         {
             self.responseMessage = @"Unable to find location";
             self.responseCompletionState = stateError;
             
//             NSLog(@"%s", "Geocode Failed");
             [[self delegate] R2RGeoCoderResolved:self];
         }
     }];
    
}


@end
