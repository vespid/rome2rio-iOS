//
//  R2RMapHelper.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 17/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "R2RDataStore.h"

@interface R2RMapHelper : NSObject

-(id) initWithData: (R2RDataStore *) dataStore;

-(id) getPolyline: (id) segment;
-(NSArray *) getPolylines: (id) segment;
//-(id) getPolyline: (NSString *) kind: (MKMapPoint *) points: (NSInteger) count;
-(id) getPolylineView:(id) polyline;

-(MKMapRect) getSegmentZoomRect: (id) segment;

@end



@interface R2RFlightPolyline : MKPolyline

@end

@interface R2RTrainPolyline : MKPolyline

@end

@interface R2RBusPolyline : MKPolyline

@end

@interface R2RFerryPolyline : MKPolyline

@end

@interface R2RWalkDrivePolyline : MKPolyline

@end

@interface R2RFlightPolylineView : MKPolylineView
-(id) initWithPolyline:(MKPolyline *)polyline;
@end

@interface R2RTrainPolylineView : MKPolylineView
-(id) initWithPolyline:(MKPolyline *)polyline;
@end

@interface R2RBusPolylineView : MKPolylineView
-(id) initWithPolyline:(MKPolyline *)polyline;
@end

@interface R2RFerryPolylineView : MKPolylineView
-(id) initWithPolyline:(MKPolyline *)polyline;
@end

@interface R2RWalkDrivePolylineView : MKPolylineView
-(id) initWithPolyline:(MKPolyline *)polyline;
@end
