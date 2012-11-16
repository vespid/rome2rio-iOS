//
//  R2RLocationContext.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 16/11/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface R2RLocationContext : NSObject

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSDate *locationManagerStartTime;
@property (strong, nonatomic) CLLocation *bestLocation;

@end
