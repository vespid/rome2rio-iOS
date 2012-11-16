//
//  R2RDataManager.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 2/11/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RSearchManager.h"
#import "R2RCompletionState.h"
#import "R2RLocationContext.h"

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

@property (strong, nonatomic) R2RLocationContext *from;
@property (strong, nonatomic) R2RLocationContext *to;


//@property (strong, nonatomic) CLLocationManager *fromLocationManager;
//@property (strong, nonatomic) CLLocationManager *toLocationManager;
//@property (strong, nonatomic) NSDate *fromLocationStartTime;
//@property (strong, nonatomic) NSDate *toLocationStartTime;
//@property (strong, nonatomic) CLLocation *bestFromLocation;
//@property (strong, nonatomic) CLLocation *bestToLocation;

@end

@implementation R2RSearchManager

@synthesize fromText, toText;

-(void) setFromPlace:(R2RPlace *)fromPlace
{
    self.from.locationManager = nil;
    
    self.dataStore.fromPlace = fromPlace;
    self.dataStore.searchResponse = nil;
    
    if ([self canStartSearch]) [self startSearch];
}

-(void) setToPlace:(R2RPlace *)toPlace
{
    self.to.locationManager = nil;
    
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
    
    self.from = [[R2RLocationContext alloc] init];
    self.from.locationManager = [self createLocationManager];
//    self.from.locationManagerStartTime = [NSDate date];
    [self performSelector:@selector(locationManagerTimeout:) withObject:self.from afterDelay:30.0];
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
    
    self.to = [[R2RLocationContext alloc] init];
    self.to.locationManager = [self createLocationManager];
//    self.to.locationManagerStartTime = [NSDate date];
    [self performSelector:@selector(locationManagerTimeout:) withObject:self.to afterDelay:30.0];
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

- (CLLocationManager *)createLocationManager
{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    //if location services are disabled we sometime do not get a didFailWithError callback.
    //Calling it twice seems to fix that
    [locationManager startUpdatingLocation];
    
    return locationManager;
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    R2RLog(@"locationManager fail\t%@", error);
    
    [manager stopUpdatingLocation];
    
    if (manager == self.from.locationManager)
    {
        self.from.locationManager = nil;
        if (self.state == r2rSearchManagerStateResolvingFromAndTo)
            self.state = r2rSearchManagerStateResolvingTo;
        else
            self.state = r2rSearchManagerStateIdle;
    }
    else if (manager == self.to.locationManager)
    {
        self.to.locationManager = nil;
        if (self.state == r2rSearchManagerStateResolvingFromAndTo)
            self.state = r2rSearchManagerStateResolvingFrom;
        else
            self.state = r2rSearchManagerStateIdle;
    }

    if (!CLLocationManager.locationServicesEnabled)
    {
        [self setStatusMessage:@"Location services are off"];
    }
    else
    {
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
    // TODO: Better error messages
}



- (void)locationManagerTimeout:(R2RLocationContext *)locationContext
{
    if (locationContext.locationManager && (locationContext.locationManager == self.from.locationManager || locationContext.locationManager == self.to.locationManager))
    {
        [locationContext.locationManager stopUpdatingLocation];
        
        if (locationContext.bestLocation)
        {
            [self reverseGeocodeLocation:locationContext.locationManager location:locationContext.bestLocation];
        }
        else
        {
            [self setStatusMessage:@"Unable to find location"];
            locationContext.locationManager = nil;
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    R2RLog(@"%f\t%f\t%f\t%f\t%f\t%f\t", -[newLocation.timestamp timeIntervalSinceNow], manager.desiredAccuracy, newLocation.horizontalAccuracy, newLocation.verticalAccuracy, newLocation.coordinate.latitude, newLocation.coordinate.longitude);

    if (manager == self.from.locationManager)
    {
        [self updateLocationContext:self.from:newLocation];
    }
    
    if (manager == self.to.locationManager)
    {
        [self updateLocationContext:self.to:newLocation];
    }
    
}

-(void) updateLocationContext :(R2RLocationContext *) locationContext :(CLLocation *) newLocation;
{
    // Initialize bestLocation
    if (!locationContext.bestLocation) locationContext.bestLocation = newLocation;
    
    // Discard locations more than a minute old
    if (-[newLocation.timestamp timeIntervalSinceNow] > 60.0) return;
    
    // Discard location that is less accurate than bestLocation
    if (newLocation.horizontalAccuracy > locationContext.bestLocation.horizontalAccuracy) return;
    
    // Update bestLocation
    locationContext.bestLocation = newLocation;
    
    // If Location Accuracy within desired limit start reverseGeocode
    if (locationContext.bestLocation.horizontalAccuracy <= 100.0)
    {
        [locationContext.locationManager stopUpdatingLocation];
        
        [self reverseGeocodeLocation:locationContext.locationManager location:locationContext.bestLocation];
    }
}

- (void)reverseGeocodeLocation:(CLLocationManager *)manager location:(CLLocation *)location
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if ([placemarks count] > 0)
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             
             [self didFindPlacemark:placemark location:location manager:manager];
         }
         else
         {
             if (manager == self.from.locationManager || manager == self.to.locationManager) //TODO check this. The comparison is done in earlier in didUpdate to location... can it change before it reaches this point. 
             {
                 R2RLog(@"error code %d", error.code);
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
             
         }
     }];
}

- (void)didFindPlacemark:(CLPlacemark *)placemark location:(CLLocation *)location manager:(CLLocationManager *)manager
{
    R2RPlace *place = [[R2RPlace alloc] init];
    
    NSString *longName = [NSString stringWithFormat:@"%@, %@, %@", placemark.name, placemark.locality, placemark.country];
    R2RLog(@"%@", longName);
    place.longName = longName;
    place.shortName = placemark.name;
    place.lat = location.coordinate.latitude;
    place.lng = location.coordinate.longitude;
    place.kind = @":veryspecific";
    
    if (manager == self.from.locationManager)
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
        self.from.locationManager = nil;
        
    }
    else if (manager == self.to.locationManager)
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
        self.to.locationManager = nil;
        
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
