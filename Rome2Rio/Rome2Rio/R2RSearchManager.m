//
//  R2RDataManager.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 2/11/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RSearchManager.h"
#import "R2RCompletionState.h"

@interface R2RSearchManager()

typedef enum
{
    r2rSearchManagerStateIdle = 0,
    r2rSearchManagerStateResolvingFrom,
    r2rSearchManagerStateResolvingTo,
    r2rSearchManagerStateResolvingFromAndTo,
    r2rSearchManagerStateSearching,
} R2RSearchManagerState;

@property R2RSearchManagerState state;

@property (strong, nonatomic) R2RSearch *search;
@property (strong, nonatomic) CLLocationManager *fromLocationManager;
@property (strong, nonatomic) CLLocationManager *toLocationManager;

@end

@implementation R2RSearchManager

@synthesize fromText, toText;

-(void) setFromPlace:(R2RPlace *)fromPlace
{
    self.fromLocationManager = nil;
    
    self.dataStore.fromPlace = fromPlace;
    self.dataStore.searchResponse = nil;
    
    if ([self canStartSearch]) [self startSearch];
}

-(void) setToPlace:(R2RPlace *)toPlace
{
    self.toLocationManager = nil;
    
    self.dataStore.toPlace = toPlace;
    self.dataStore.searchResponse = nil;
    
    if ([self canStartSearch]) [self startSearch];
}

-(void) setFromWithCurrentLocation
{
    [self setFromPlace:nil];
    
    if (self.state == r2rSearchManagerStateResolvingTo || self.state == r2rSearchManagerStateResolvingFromAndTo)
    {
        self.state = r2rSearchManagerStateResolvingFromAndTo;
    }
    else
    {
        self.state = r2rSearchManagerStateResolvingFrom;
    }
    
    [self setStatusMessage:@"Finding Current Location"];
    
    self.fromLocationManager = [self createLocationManager];
}

-(void) setToWithCurrentLocation
{
    [self setToPlace:nil];

    if (self.state == r2rSearchManagerStateResolvingFrom || self.state == r2rSearchManagerStateResolvingFromAndTo)
    {
        self.state = r2rSearchManagerStateResolvingFromAndTo;
    }
    else
    {
        self.state = r2rSearchManagerStateResolvingTo;
    }
    
    [self setStatusMessage:@"Finding Current Location"];
    
    self.toLocationManager = [self createLocationManager];
}

-(void) setStatusMessage:(NSString *) statusMessage
{
    self.dataStore.statusMessage = statusMessage;
}

-(void) setSearchMessage:(NSString *)searchMessage
{
    self.dataStore.searchMessage = searchMessage;
}

-(void) restartSearchIfNoResponse
{
    if (!self.dataStore.searchResponse)
    {
        if ([self canStartSearch]) [self startSearch];
    }
}

-(BOOL) isSearching
{
    return (self.state == r2rSearchManagerStateSearching);
}

-(BOOL) canStartSearch
{
    return ((self.state == r2rSearchManagerStateIdle) && self.dataStore.fromPlace && self.dataStore.toPlace);
}

-(BOOL) canShowSearchResults
{
    if (!self.dataStore.fromPlace && self.state == r2rSearchManagerStateIdle)
    {
        [self setStatusMessage:@"Enter Origin"];
        
        return NO;
    }
    
    if (!self.dataStore.toPlace && self.state == r2rSearchManagerStateIdle)
    {
        [self setStatusMessage:@"Enter Destination"];
        
        return NO;
    }
    
    return YES;
}

- (void) startSearch
{
    self.dataStore.searchResponse = nil;
    
    NSString *oName = self.dataStore.fromPlace.shortName;
    NSString *dName = self.dataStore.toPlace.shortName;
    NSString *oPos = [NSString stringWithFormat:@"%f,%f", self.dataStore.fromPlace.lat, self.dataStore.fromPlace.lng];
    NSString *dPos = [NSString stringWithFormat:@"%f,%f", self.dataStore.toPlace.lat, self.dataStore.toPlace.lng];
    NSString *oKind = self.dataStore.fromPlace.kind;
    NSString *dKind = self.dataStore.toPlace.kind;
    NSString *oCode = self.dataStore.fromPlace.code;
    NSString *dCode = self.dataStore.toPlace.code;
    
    self.search = [[R2RSearch alloc] initWithSearch:oName :dName :oPos :dPos :oKind :dKind: oCode: dCode delegate:self];
    
    self.state = r2rSearchManagerStateSearching;
}

- (void) searchDidFinish:(R2RSearch *)search;
{
    if (search == self.search)
    {
        if (self.search.responseCompletionState == r2rCompletionStateResolved)
        {
            self.dataStore.searchResponse = search.searchResponse;
            [self setSearchMessage:@""];
        }
        else
        {
            self.dataStore.searchResponse = nil;
            [self setSearchMessage:search.responseMessage];
        }
        
        [self loadAirlineImages];
        [self loadAgencyImages];
        
        self.state = r2rSearchManagerStateIdle;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshResults" object:nil];
    }
}

- (CLLocationManager *)createLocationManager
{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    
    //if location services are disabled we sometime do not get a didFailWithError callback.
    //Calling it twice seems to fix that
    [locationManager startUpdatingLocation];
    
    return locationManager;
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    R2RLog(@"locationManager fail");
    
    [manager stopUpdatingLocation];
    
    if (manager == self.fromLocationManager)
    {
        if (self.state == r2rSearchManagerStateResolvingFromAndTo)
            self.state = r2rSearchManagerStateResolvingTo;
        else
            self.state = r2rSearchManagerStateIdle;
    }
    else if (manager == self.toLocationManager)
    {
        if (self.state == r2rSearchManagerStateResolvingFromAndTo)
            self.state = r2rSearchManagerStateResolvingFrom;
        else
            self.state = r2rSearchManagerStateIdle;
    }

    if (!CLLocationManager.locationServicesEnabled)
    {
        [self setStatusMessage:@"Location services are off"];
    }
    else if (error.code == kCLErrorDenied)
    {
        [self setStatusMessage:@"Location services are off"];
    }
    else // TODO: Better error messages
    {
        [self setStatusMessage:@"Unable to find location"];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [manager stopUpdatingLocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error)
    {
        if ([placemarks count] > 0)
        {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            
            [self didFindPlacemark:placemark location:newLocation manager:manager];
        }
        else
        {
            if (manager == self.fromLocationManager || manager == self.toLocationManager)
            {
                [self setStatusMessage:@"Unable to find current location"];
            }

        }
    }];
}

- (void)didFindPlacemark:(CLPlacemark *)placemark location:(CLLocation *)location manager:(CLLocationManager *)manager
{
    R2RPlace *place = [[R2RPlace alloc] init];
    
    NSString *longName = [NSString stringWithFormat:@"%@, %@, %@", placemark.name, placemark.locality, placemark.country];
    place.longName = longName;
    place.shortName = placemark.name;
    place.lat = location.coordinate.latitude;
    place.lng = location.coordinate.longitude;
    place.kind = @":veryspecific";
    
    if (manager == self.fromLocationManager)
    {
        if (self.state == r2rSearchManagerStateResolvingFromAndTo)
        {
            self.state = r2rSearchManagerStateResolvingTo;
        }
        else
        {
            self.state = r2rSearchManagerStateIdle;
        }
        
        [self setFromPlace:place];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTitle" object:nil];
    }
    else if (manager == self.toLocationManager)
    {
        if (self.state == r2rSearchManagerStateResolvingFromAndTo)
        {
            self.state = r2rSearchManagerStateResolvingFrom;
        }
        else
        {
            self.state = r2rSearchManagerStateIdle;
        }
        
        [self setToPlace:place];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTitle" object:nil];
    }
}

-(void) loadAirlineImages
{
    for (R2RAirline *airline in self.search.searchResponse.airlines)
    {
        [self.dataStore.spriteStore loadImage:airline.iconPath]; //pre cache airline images.
    }
}

-(void) loadAgencyImages
{
    for (R2RAgency *agency in self.search.searchResponse.agencies)
    {
        [self.dataStore.spriteStore loadImage:agency.iconPath];
    }
}

@end
