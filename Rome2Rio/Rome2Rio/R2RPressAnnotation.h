//
//  R2RPressAnnotation.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 23/11/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface R2RPressAnnotation : NSObject

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSString *kind;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithName:(NSString*)name kind:(NSString*)kind coordinate:(CLLocationCoordinate2D)coordinate;

@end
