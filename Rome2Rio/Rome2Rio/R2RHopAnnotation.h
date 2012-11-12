//
//  R2RHopAnnotation.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 9/11/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface R2RHopAnnotation : NSObject <MKAnnotation>

@property (copy) NSString *name;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithName:(NSString*)name coordinate:(CLLocationCoordinate2D)coordinate;

@end
