//
//  R2RDataManager.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 2/11/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "R2RDataStore.h"

@interface R2RDataManager : NSObject <R2RSearchDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) R2RSearch *search;

@property (strong, nonatomic) R2RDataStore *dataStore;

@property (strong, nonatomic) CLLocationManager *fromLocationManager;
@property (strong, nonatomic) CLLocationManager *toLocationManager;

-(void) setFromPlace:(R2RPlace *)fromPlace;
-(void) setToPlace:(R2RPlace *)toPlace;

-(void) setFromWithCurrentLocation;
-(void) setToWithCurrentLocation;

-(void) refreshSearchIfNoResponse;




@end