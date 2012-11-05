//
//  R2RDataController.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 12/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RDataController.h"

@interface R2RDataController ()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

enum R2RState
{
    IDLE = 0,
    RESOLVING_FROM,
    RESOLVING_TO,
    SEARCHING,
};

//enum R2REvent
//{
//    EDIT_FROM_BEGIN = 0,
//    EDIT_FROM_END,
//    EDIT_TO_BEGIN,
//    EDIT_TO_END,
//    FINISHED,
//    ERROR,
//    TIMEOUT,
//    STATUS    
//};


enum {
    stateEmpty = 0,
    stateEditingDidBegin,
    stateEditingDidEnd,
    stateResolved,
    stateLocationNotFound,
    stateError
};

@end


@implementation R2RDataController

@synthesize search = _search;
@synthesize geoCoderFrom, geoCoderTo, statusMessage, state;
@synthesize fromGeocodeResponse, toGeocodeResponse;

-(id) init
{
    self = [super init];
    
    if (self != nil)
    {
        self.spriteStore = [[R2RSpriteStore alloc] init];
        self.state = IDLE;
    }
    
    return self;
}

-(void) geoCodeFromQuery:(NSString *)query
{
//    self.statusMessage = @"";
//    [self refreshStatusMessage:self.geoCoderFrom];
//    
//    self.geoCoderFrom = [[R2RGeoCoder alloc] initWithSearchString:query delegate:self];
//    
//    [self.geoCoderFrom sendAsynchronousRequest];
//    self.state = RESOLVING_FROM;
//    
//    self.statusMessage = @"Finding Origin";
//    
//    [self performSelector:@selector(refreshStatusMessage:) withObject:self.geoCoderFrom afterDelay:2.0];
}

-(void) geoCodeToQuery:(NSString *)query
{
//    self.statusMessage = @"";
//    [self refreshStatusMessage:self.geoCoderTo];
//    
//    if (self.geoCoderFrom.geoCodeResponse)
//    {
//        self.geoCoderTo = [[R2RGeoCoder alloc] initWithSearch:query :self.geoCoderFrom.geoCodeResponse.place.countryCode :nil delegate:self];
//    }
//    else
//    {
//        self.geoCoderTo = [[R2RGeoCoder alloc] initWithSearchString:query delegate:self];
//    }
//    
//    [self.geoCoderTo sendAsynchronousRequest];
//    self.state = RESOLVING_TO;
//    
//    self.statusMessage = @"Finding Destination";
//    
//    [self performSelector:@selector(refreshStatusMessage:) withObject:self.geoCoderTo afterDelay:2.0];
}

-(void) R2RGeoCoderResolved:(R2RGeoCoder *)delegateGeoCoder
{
    
    [self refreshStatusMessage:nil];
     
    if (delegateGeoCoder == self.geoCoderFrom & self.state == RESOLVING_FROM)
    {

        if (self.geoCoderFrom.responseCompletionState == stateResolved)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFromTextField" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTitle" object:nil];
        }
       
        if (self.geoCoderTo == nil && [self.toText length] > 0)
        {
            [self geoCodeToQuery:self.toText];
            return;
        }
        
    }
    else if (delegateGeoCoder == self.geoCoderTo & self.state == RESOLVING_TO)
    {
        
        if (self.geoCoderTo.responseCompletionState == stateResolved)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshToTextField" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTitle" object:nil];
        }
      
        if (self.geoCoderFrom !=  nil && [self.fromText length] > 0)
        {
            [self geoCodeFromQuery:self.fromText];
            return;
        }
    }
    
    self.state = IDLE;
    
    [self resolvedStateChanged];
    
}

- (void) resolvedStateChanged
{
//    if (self.geoCoderFrom == nil || self.geoCoderTo == nil)
//    {
//        return;
//    }
//    if (self.geoCoderFrom.responseCompletionState == stateResolved && self.geoCoderTo.responseCompletionState == stateResolved)
//    {
//        [self initSearch];
//    }
    if (self.fromGeocodeResponse && self.toGeocodeResponse)
    {
        [self initSearch];
    }

}

- (void) initSearch
{
    self.statusMessage = @"";
    [self refreshStatusMessage:self.search];
    
    NSString *oName = self.geoCoderFrom.geoCodeResponse.place.shortName;
    NSString *dName = self.geoCoderTo.geoCodeResponse.place.shortName;
    NSString *oPos = [NSString stringWithFormat:@"%f,%f", self.geoCoderFrom.geoCodeResponse.place.lat, self.geoCoderFrom.geoCodeResponse.place.lng];
    NSString *dPos = [NSString stringWithFormat:@"%f,%f", self.geoCoderTo.geoCodeResponse.place.lat, self.geoCoderTo.geoCodeResponse.place.lng];
    NSString *oKind = self.geoCoderFrom.geoCodeResponse.place.kind;
    NSString *dKind = self.geoCoderTo.geoCodeResponse.place.kind;
    NSString *oCode = self.geoCoderFrom.geoCodeResponse.place.code;
    NSString *dCode = self.geoCoderTo.geoCodeResponse.place.code;
    
    self.search = [[R2RSearch alloc] initWithSearch:oName :dName :oPos :dPos :oKind :dKind: oCode: dCode delegate:self];
    
    self.state = SEARCHING;
    [self performSelector:@selector(refreshStatusMessage:) withObject:self.search afterDelay:2.0];
}

- (void) searchDidFinish:(R2RSearch *)search;
{
    
    if (self.search == search && self.state == SEARCHING)
    {
        if (self.search.responseCompletionState == stateResolved)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshResults" object:nil];
        }
        
        [self loadAirlineImages];
        [self loadAgencyImages];
        
        self.state = IDLE;
        
        [self refreshStatusMessage:self.search];
    }
}


- (void) refreshStatusMessage: (id) sender
{
    
    if (self.geoCoderFrom != nil && self.geoCoderFrom.responseCompletionState == stateError)
    {
        self.statusMessage = [NSString stringWithFormat:@"%@: %@", @"Origin", self.geoCoderFrom.responseMessage];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshStatusMessage" object:nil];
        return;
    }
    
    if (self.geoCoderTo != nil && self.geoCoderTo.responseCompletionState == stateError)
    {
        self.statusMessage = [NSString stringWithFormat:@"%@: %@", @"Destination", self.geoCoderTo.responseMessage];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshStatusMessage" object:nil];
        return;
    }
    
    switch (self.state) {
        case IDLE:
            
            if (self.search != nil && self.search.responseCompletionState == stateError)
            {
                self.statusMessage = [NSString stringWithFormat:@"%@: %@", @"Search", self.search.responseMessage];
            }
            else
            {
                self.statusMessage = @"";
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshStatusMessage" object:nil];
            return;
            break;
            
        case RESOLVING_FROM:
            
            if (self.geoCoderFrom != nil && self.geoCoderFrom == sender)
            {
                self.statusMessage = [NSString stringWithFormat:@"%@: %@", @"Origin", @"Finding location"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshStatusMessage" object:nil];
            }
            break;
            
        case RESOLVING_TO:
            
            if (self.geoCoderTo != nil && self.geoCoderTo == sender)
            {
                self.statusMessage = [NSString stringWithFormat:@"%@: %@", @"Destination", @"Finding location"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshStatusMessage" object:nil];
            }
            break;
            
        case SEARCHING:
            
            if (self.search != nil && self.search == sender)
            {
                self.statusMessage = [NSString stringWithFormat:@"%@", @"Searching"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSearchMessage" object:nil];
            }
            break;
            
        default:
            break;
    }
}

-(void)refreshSearchIfNoResponse
{
//    if (self.state == IDLE && self.search.responseCompletionState != stateResolved)
//    {
//        if (self.geoCoderFrom && self.geoCoderFrom.responseCompletionState != stateResolved)
//        {
//            if (self.geoCoderTo && self.geoCoderTo.responseCompletionState != stateResolved)
//            {
//                self.geoCoderTo = nil;
//            }
//            [self geoCodeFromQuery:self.fromText];
//            return;
//        }
//        if (self.geoCoderTo && self.geoCoderTo.responseCompletionState != stateResolved)
//        {
//            [self geoCodeToQuery:self.toText];
//            return;
//        }
//        [self initSearch];
//    }
//    
    [self initSearch];
}

- (void) fromEditingDidBegin
{
    self.fromText = @"";
//    self.geoCoderFrom = nil;
//    self.search = nil;
//    
//    if (self.state != RESOLVING_TO)
//    {
//        self.state = IDLE;
//    }
}

- (void) fromEditingDidEnd:(NSString *)query
{
    self.fromText = query;

//    if (self.state == IDLE || self.state == RESOLVING_FROM)
//    {
//        [self geoCodeFromQuery:query];
//    }
    [self resolvedStateChanged];
}

- (void) toEditingDidBegin
{
    self.toText = @"";
//    self.geoCoderTo = nil;
//    self.search = nil;
//    
//    if (self.state != RESOLVING_FROM)
//    {
//        self.state = IDLE;
//    }
}

- (void) toEditingDidEnd:(NSString *)query
{
    self.toText = query;
//    
//    if (self.state == IDLE || self.state == RESOLVING_TO)
//    {
//        [self geoCodeToQuery:query];
//    }
    [self resolvedStateChanged];
}

-(BOOL) isGeocoderResolved:(R2RGeoCoder *)geocoder
{
    if (geocoder.responseCompletionState == stateResolved)
    {
        return YES;
    }
    
    return NO;
}

- (void) currentLocationTouchUpInside
{
    self.fromText = @"";
    self.geoCoderFrom = nil;
    self.search = nil;
    
    [self refreshStatusMessage:nil];
        
    if (nil == self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [self.locationManager startUpdatingLocation];
    
    //if location services are disabled we sometime do not get a didFailWithError callback.
    //Calling it twice seems to fix that
    [self.locationManager startUpdatingLocation];
    
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.locationManager stopUpdatingLocation];

    if (!self.geoCoderFrom)
    {
        self.geoCoderFrom = [[R2RGeoCoder alloc] init];
    }
    self.geoCoderFrom.geoCodeResponse = nil;
    self.geoCoderFrom.responseMessage = @"Unable to find location";
    if (!CLLocationManager.locationServicesEnabled)
    {
        self.geoCoderFrom.responseMessage = @"Location services are off";
    }
    else if (error.code == kCLErrorDenied)
    {
        self.geoCoderFrom.responseMessage = @"Location services are off";
    }
    
    self.geoCoderFrom.responseCompletionState = stateError;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFromTextField" object:nil];
    [self refreshStatusMessage:self];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.location = newLocation;
    [self.locationManager stopUpdatingLocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:self.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0)
        {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
           
            R2RPlace *newPlace = [[R2RPlace alloc] init];
//            NSString *a = placemark.country;
//            NSString *b = placemark.inlandWater;
//            NSString *c = placemark.ISOcountryCode;
//            NSString *d = placemark.locality;
//            NSString *e = placemark.name;
//            NSString *f = placemark.ocean;
//            NSString *g = placemark.postalCode;
//            NSString *h = [placemark.region description];
//            NSString *i = placemark.subAdministrativeArea;
//            NSString *j = placemark.subLocality;
//            NSString *k = placemark.subThoroughfare;
//            NSString *l = placemark.thoroughfare;
//            
//            NSLog(@"%@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@,", a, b, c, d, e, f, g, h, i, j, k, l);
            
            NSString *longName = [NSString stringWithFormat:@"%@, %@, %@", placemark.name, placemark.locality, placemark.country];
            newPlace.longName = longName;
            newPlace.shortName = placemark.name;
            newPlace.lat = newLocation.coordinate.latitude;
            newPlace.lng = newLocation.coordinate.longitude;
            newPlace.kind = @":veryspecific";
            
            
            if (!self.geoCoderFrom)
            {
                self.geoCoderFrom = [[R2RGeoCoder alloc] init];
                self.geoCoderFrom.geoCodeResponse = [[R2RGeoCodeResponse alloc] init];
            }
            
            self.geoCoderFrom.geoCodeResponse.place = newPlace;
            self.geoCoderFrom.responseCompletionState = stateResolved;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFromTextField" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTitle" object:nil];
            
            [self refreshStatusMessage:self];
            [self resolvedStateChanged];
            
        }
        else
        {
            if (!self.geoCoderFrom)
            {
                self.geoCoderFrom = [[R2RGeoCoder alloc] init];
            }
            self.geoCoderFrom.geoCodeResponse = nil;
            self.geoCoderFrom.responseMessage = @"Unable to find location";
            self.geoCoderFrom.responseCompletionState = stateError;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFromTextField" object:nil];
            [self refreshStatusMessage:self];
        }
    }];
}

-(void) loadAirlineImages
{
    for (R2RAirline *airline in self.search.searchResponse.airlines)
    {
        [self.spriteStore loadImage:airline.iconPath]; //pre cache airline images.
    }
}

-(void) loadAgencyImages
{
    for (R2RAgency *agency in self.search.searchResponse.agencies)
    {
        [self.spriteStore loadImage:agency.iconPath];
    }
}

@end
