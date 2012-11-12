//
//  R2RMapHelper.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 17/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#import "R2RSearchStore.h"
#import "R2RHopAnnotation.h"
#import "R2RMKAnnotation.h"

@interface R2RMapHelper : NSObject

-(id) initWithData: (R2RSearchStore *) dataStore;

-(NSArray *) getPolylines: (id) segment;
-(id) getPolylineView:(id) polyline;

-(MKMapRect) getSegmentZoomRect: (id) segment;

-(NSArray *) getRouteHopAnnotations:(R2RRoute *) route;
//returns annotations for hop changeovers that are not counted as route stops

-(id)getAnnotationView:(MKMapView *)mapView :(id<MKAnnotation>)annotation;

-(void)filterAnnotations:(NSArray *)stops:(NSArray *)hops:(MKMapView *) mapView;

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
