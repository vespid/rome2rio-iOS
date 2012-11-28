//
//  R2RDataManager.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 2/11/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RSearchManager.h"
#import "R2RCompletionState.h"
#import "R2RMapHelper.h"

@interface R2RSearchManager()

typedef enum
{
    r2rSearchManagerStateIdle = 0,
    r2rSearchManagerStateResolvingLocation, //not used currently
    r2rSearchManagerStateSearching,
} R2RSearchManagerState;

@property R2RSearchManagerState state;

@property (strong, nonatomic) R2RSearch *search;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *bestLocation;

@property (nonatomic) BOOL isLocationManagerResolving;
@property (nonatomic) BOOL fromWantsCurrentLocation;
@property (nonatomic) BOOL toWantsCurrentLocation;
@property (nonatomic) BOOL fromWantsMapLocation;
@property (nonatomic) BOOL toWantsMapLocation;


@end

@implementation R2RSearchManager

@synthesize fromText, toText;

-(void) setFromPlace:(R2RPlace *)fromPlace
{
    self.fromWantsCurrentLocation = NO;
    
    self.dataStore.fromPlace = fromPlace;
    self.dataStore.searchResponse = nil;
    
    if ([self canStartSearch]) [self startSearch];
}

-(void) setToPlace:(R2RPlace *)toPlace
{
    self.toWantsCurrentLocation = NO;
    
    self.dataStore.toPlace = toPlace;
    self.dataStore.searchResponse = nil;
    
    if ([self canStartSearch]) [self startSearch];
}

-(void) setFromWithCurrentLocation
{
    [self setFromPlace:nil];
    
    self.fromWantsCurrentLocation = YES;
    self.fromWantsMapLocation = NO;
    [self setStatusMessage:@"Finding Current Location"];
    
    [self startLocationManager];
}

-(void) setToWithCurrentLocation
{
    [self setToPlace:nil];
    
    self.toWantsCurrentLocation = YES;
    self.toWantsMapLocation = NO;
    [self setStatusMessage:@"Finding Current Location"];
    
    [self startLocationManager];
}

-(void) setFromWithMapLocation:(CLLocationCoordinate2D) coord mapScale:(float) mapScale
{
    [self setFromPlace:nil];
    
    self.fromWantsCurrentLocation = NO;
    self.fromWantsMapLocation = YES;
    [self setStatusMessage:@"Finding Map Location"];
    
    CLLocation *location = [[CLLocation alloc] initWithCoordinate:coord altitude:0 horizontalAccuracy:mapScale verticalAccuracy:100 timestamp:[NSDate date]];
    [self reverseGeocodeLocation:location fieldType:@"mapFrom"];
}

-(void) setToWithMapLocation:(CLLocationCoordinate2D) coord mapScale:(float) mapScale
{
    [self setToPlace:nil];
    
    self.toWantsCurrentLocation = NO;
    self.toWantsMapLocation = YES;
    [self setStatusMessage:@"Finding Map Location"];
    
    CLLocation *location = [[CLLocation alloc] initWithCoordinate:coord altitude:0 horizontalAccuracy:mapScale verticalAccuracy:100 timestamp:[NSDate date]];
    [self reverseGeocodeLocation:location fieldType:@"mapTo"];
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
        
    }
}

- (void) startLocationManager
{
    //return if already resolving
    if (self.isLocationManagerResolving) return;

    R2RLog(@"locationManager started");

    self.bestLocation = nil;
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    // If location services are disabled we sometimes do not get a didFailWithError callback.
    // Calling it twice seems to fix that
    [self.locationManager startUpdatingLocation];
    
    [self performSelector:@selector(locationManagerTimeout:) withObject:self.locationManager afterDelay:30.0];
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    R2RLog(@"locationManager fail\t%@", error);
    
    // Stop location manager
    [manager stopUpdatingLocation];
    
    // Ignore orphaned callback
    if (manager != self.locationManager) return;
    
    [self locationError:error];
}

- (void)locationManagerTimeout:(CLLocationManager *)manager
{
    // Stop location manager
    [manager stopUpdatingLocation];
    
    // Ignore orphaned callback
    if (manager != self.locationManager) return;
    
    // Fallback bestLocation if available
    if (self.bestLocation)
    {
        [self reverseGeocodeLocationWithManager:manager location:self.bestLocation];
    }
    else
    {
        [self locationError:nil];
    }
}

- (void) locationError:(NSError *) error
{
    R2RLog(@"error code %d", error.code);
    // Set error status
    switch (error.code)
    {
        case kCLErrorDenied:
            [self setStatusMessage:@"Location services are off"];
            break;
            
        case kCLErrorNetwork:
            [self setStatusMessage:@"Internet appears to be offline"];
            break;
            
        default:
            [self setStatusMessage:@"Unable to find location"];
            break;
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    R2RLog(@"%f\t%f\t%f\t%f\t%f\t%f\t", -[newLocation.timestamp timeIntervalSinceNow], manager.desiredAccuracy, newLocation.horizontalAccuracy, newLocation.verticalAccuracy, newLocation.coordinate.latitude, newLocation.coordinate.longitude);

    if (manager != self.locationManager)
    {
        [manager stopUpdatingLocation];
        return;
    }
    
    [self updateLocation:newLocation];
}

-(void) updateLocation:(CLLocation *) newLocation;
{
    // Initialize bestLocation
    if (!self.bestLocation) self.bestLocation = newLocation;
    
    // Discard locations more than a minute old
    if (-[newLocation.timestamp timeIntervalSinceNow] > 60.0) return;
    
    // Discard location that is less accurate than bestLocation
    if (newLocation.horizontalAccuracy > self.bestLocation.horizontalAccuracy) return;
    
    // Update bestLocation
    self.bestLocation = newLocation;
    
    // If location accuracy within desired limit start reverseGeocode
    if (self.bestLocation.horizontalAccuracy <= 100.0)
    {
        [self.locationManager stopUpdatingLocation];
        
        [self reverseGeocodeLocationWithManager:self.locationManager location:self.bestLocation];
    }
}

- (void)reverseGeocodeLocation:(CLLocation *)location fieldType:(NSString *)fieldType
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if ([placemarks count] > 0)
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             
             [self didFindPlacemark:placemark location:location fieldType:fieldType];
         }
         else
         {
             [self locationError:error];
         }
     }];
}

- (void)reverseGeocodeLocationWithManager:(CLLocationManager *)manager location:(CLLocation *)location
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         // Discard orphaned callback
         if (manager != self.locationManager) return;
         
         if ([placemarks count] > 0)
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             
             [self didFindPlacemark:placemark location:location fieldType:@"currentLocation"];
             self.locationManager = nil;
         }
         else
         {
             [self locationError:error];
         }
     }];
}

- (void)didFindPlacemark:(CLPlacemark *)placemark location:(CLLocation *)location fieldType:(NSString *) fieldType
{
    R2RPlace *place = [[R2RPlace alloc] init];
    
    NSMutableArray *names = [[NSMutableArray alloc] init];
    if (placemark.name) [names addObject:placemark.name];
    if (placemark.locality) [names addObject:placemark.locality];
    if (placemark.country) [names addObject:placemark.country];
    
    NSMutableString *longName = [[NSMutableString alloc] init];
    
    for (NSString *name in names)
    {
        [longName appendString:name];
        if (name != [names lastObject])
        {
            [longName appendString:@", "];
        }
    }
    
//    NSString *longName = [NSString stringWithFormat:@"%@, %@, %@", placemark.name, placemark.locality, placemark.country];
//    R2RLog(@"%@\t%@", longName, [NSString stringWithFormat:@"%@, %@, %@", placemark.name, placemark.locality, placemark.country]);
    
    R2RLog(@"%@\t:%.2f\t\t%@\t%@\t%@\t%@\t%@\t%@\t%@\t", placemark.name, location.horizontalAccuracy, placemark.subThoroughfare, placemark.thoroughfare, placemark.subLocality, placemark.locality, placemark.subAdministrativeArea, placemark.administrativeArea, placemark.country);
    place.longName = longName;
    place.shortName = placemark.name;
    place.lat = location.coordinate.latitude;
    place.lng = location.coordinate.longitude;
    
    R2RMapHelper *mapHelper = [[R2RMapHelper alloc] init];
    
    if (location.horizontalAccuracy <= 100)
    {
        place.kind = @":veryspecific";
        place.shortName = [mapHelper getVerySpecificShortName:placemark];
        place.longName = [mapHelper getVerySpecificLongName:placemark];
    }
    else if (location.horizontalAccuracy <= 1000)
    {
        place.kind = @":specific";
        place.shortName = [mapHelper getSpecificShortName:placemark];
        place.longName = [mapHelper getSpecificLongName:placemark];
    }
    else if (location.horizontalAccuracy <= 20000)
    {
        place.kind = @"city";
        place.shortName = [mapHelper getCityShortName:placemark];
        place.longName = [mapHelper getCityLongName:placemark];
    }
    else
    {
        place.kind = @"country";
        place.shortName = [mapHelper getCountryName:placemark];
        place.longName = [mapHelper getCountryName:placemark];
    }
    
    
    if (self.fromWantsMapLocation && [fieldType isEqualToString:@"mapFrom"])
    {
        [self setFromPlace:place];
        self.fromWantsMapLocation = NO;
    }
    if (self.toWantsMapLocation && [fieldType isEqualToString:@"mapTo"])
    {
        [self setToPlace:place];
        self.toWantsCurrentLocation = NO;
    }
    
    if (self.fromWantsCurrentLocation && [fieldType isEqualToString:@"currentLocation"])
    {
        [self setFromPlace:place];
        self.fromWantsCurrentLocation = NO;
    }
    if (self.toWantsCurrentLocation && [fieldType isEqualToString:@"currentLocation"])
    {
        [self setToPlace:place];
        self.toWantsCurrentLocation = NO;
    }

}

-(void) loadAirlineImages
{
    for (R2RAirline *airline in self.search.searchResponse.airlines)
    {
        //pre cache airline images.
        [self.dataStore.spriteStore loadImage:airline.iconPath];
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
