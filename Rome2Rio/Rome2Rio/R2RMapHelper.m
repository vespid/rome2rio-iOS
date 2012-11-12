//
//  R2RMapHelper.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 17/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RMapHelper.h"
#import "R2RSegmentHandler.h"
#import "R2RFlightSegment.h"
#import "R2RFlightItinerary.h"
#import "R2RFlightLeg.h"
#import "R2RFlightHop.h"
#import "R2RTransitSegment.h"
#import "R2RWalkDriveSegment.h"

#import "R2RConstants.h"
#import "R2RPath.h"
#import "R2RPathEncoder.h"


@interface R2RMapHelper()

@property (strong, nonatomic) R2RDataStore *dataStore;

@end

@implementation R2RMapHelper

-(id)initWithData:(R2RDataStore *)dataStore
{
    self = [super init];
    if (self)
    {
        self.dataStore = dataStore;
    }
    return self;
}

-(MKMapRect)getSegmentZoomRect:(id)segment
{
    MKMapRect rect = MKMapRectNull;
    
    R2RSegmentHandler *segmentHandler = [[R2RSegmentHandler alloc] initWithData:self.dataStore];
    
    NSString *pathString = [segmentHandler getSegmentPath:segment];
    
    if (!pathString)
    {
        MKMapRect rect = MKMapRectNull;
 
        R2RPosition *pos = [segmentHandler getSegmentSPos:segment];
        CLLocationCoordinate2D sPos;
        sPos.latitude = pos.lat;
        sPos.longitude = pos.lng;
        
        pos = [segmentHandler getSegmentTPos:segment];
        CLLocationCoordinate2D tPos;
        tPos.latitude = pos.lat;
        tPos.longitude = pos.lng;
        
        MKMapPoint sMapPoint = MKMapPointForCoordinate(sPos);
        MKMapPoint tMapPoint = MKMapPointForCoordinate(tPos);
        
        //making a union between two 0 size point rects means the map can not be out of bounds
        MKMapRect sPointRect = MKMapRectMake(sMapPoint.x, sMapPoint.y, 0, 0);
        MKMapRect tPointRect = MKMapRectMake(tMapPoint.x, tMapPoint.y, 0, 0);
        
        rect = MKMapRectUnion(sPointRect, tPointRect);
        return rect;
    }
    
    R2RPath *path = [R2RPathEncoder decode:pathString];
    
    for (R2RPosition *r2rPos in path.positions)
    {
        CLLocationCoordinate2D pos;
        pos.latitude = r2rPos.lat;
        pos.longitude = r2rPos.lng;
        MKMapPoint mapPoint = MKMapPointForCoordinate(pos);
        MKMapRect pointRect = MKMapRectMake(mapPoint.x, mapPoint.y, 0, 0);
        if (MKMapRectIsNull(rect))
        {
            rect = pointRect;
        }
        else
        {
            rect = MKMapRectUnion(rect, pointRect);
        }
    }
    
    return rect;
}

//return an array containing a polyline for each hop
-(NSArray *) getPolylines:(id) segment;
{
    R2RSegmentHandler *segmentHandler = [[R2RSegmentHandler alloc] init];
    NSString *kind = [segmentHandler getSegmentKind:segment];
    if ([kind isEqualToString:@"flight"])
    {
        return  [self getFlightPolylines:segment];// [R2RFlightPolyline polylineWithPoints:points count:count];
    }
    else if ([kind isEqualToString:@"train"])
    {
        return [self getTrainPolylines:segment];
    }
    else if ([kind isEqualToString:@"bus"])
    {
        return [self getBusPolylines:segment];
    }
    else if ([kind isEqualToString:@"ferry"])
    {
        return [self getFerryPolylines:segment];
    }
    else if ([kind isEqualToString:@"car"] || [kind isEqualToString:@"walk"])
    {
        return [self getWalkDrivePolylines:segment];
    }
    else
    {
        return nil;// [self getMKPolyline:segment];
    }
}

-(NSArray *) getFlightPolylines: (R2RFlightSegment *) segment
{
    //    R2RSegmentHandler *segmentHandler = [[R2RSegmentHandler alloc] init];
    R2RFlightItinerary *itinerary = [segment.itineraries objectAtIndex:0];
    R2RFlightLeg *leg = [itinerary.legs objectAtIndex:0];
    
    //TODO add geodesic Interpolation to flight path
    // for now there is just straight lines between stops
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (R2RFlightHop *hop in leg.hops)
    {
        int count = 2;

        NSMutableData *data = [NSMutableData dataWithLength:(sizeof(CLLocationCoordinate2D)*count)];
        MKMapPoint *points = [data mutableBytes];
        
        CLLocationCoordinate2D sPos = {};
        CLLocationCoordinate2D tPos = {};
        CLLocationCoordinate2D mPos = {};
        
        for (R2RAirport *airport in self.dataStore.searchResponse.airports)
        {
            if ([airport.code isEqualToString:hop.sCode])
            {
                sPos.latitude = airport.pos.lat;
                sPos.longitude = airport.pos.lng;
            }
            if ([airport.code isEqualToString:hop.tCode])
            {
                tPos.latitude = airport.pos.lat;
                tPos.longitude = airport.pos.lng;
            }
        }
        
        if ((tPos.longitude - sPos.longitude) > 180 || (tPos.longitude - sPos.longitude) < -180)
        {
            MKMapPoint mapPoint = MKMapPointForCoordinate(sPos);
            points[0] = mapPoint;
            mPos.latitude = (tPos.latitude + sPos.latitude)/2;
            mPos.longitude = (sPos.longitude < 0) ? -180.0f :180.0f;
            mapPoint = MKMapPointForCoordinate(mPos);
            points[1] = mapPoint;
            
            R2RFlightPolyline *polyline = (R2RFlightPolyline *)[R2RFlightPolyline polylineWithPoints:points count:count];
            [array addObject:polyline];
            
            data = [NSMutableData dataWithLength:(sizeof(CLLocationCoordinate2D)*count)];
            points = [data mutableBytes];
            mPos.longitude = -mPos.longitude;
            mapPoint = MKMapPointForCoordinate(mPos);
            points[0] = mapPoint;
            mapPoint = MKMapPointForCoordinate(tPos);
            points[1] = mapPoint;
            
            polyline = (R2RFlightPolyline *)[R2RFlightPolyline polylineWithPoints:points count:count];
            [array addObject:polyline];
        }
        else
        {
            MKMapPoint mapPoint = MKMapPointForCoordinate(sPos);
            points[0] = mapPoint;
            mapPoint = MKMapPointForCoordinate(tPos);
            points[1] = mapPoint;
            
            R2RFlightPolyline *polyline = (R2RFlightPolyline *)[R2RFlightPolyline polylineWithPoints:points count:count];
            [array addObject:polyline];
        }
    }
    return array;
}

-(NSArray *) getTrainPolylines: (R2RTransitSegment *) segment
{
    R2RPath *path = [R2RPathEncoder decode:segment.path];
    
    NSMutableData *data = [NSMutableData dataWithLength:(sizeof(CLLocationCoordinate2D)*[path.positions count])];
    MKMapPoint *points = [data mutableBytes];
    int count = 0;
    
    //TODO: refactor out for all transitsegments but need count;
    for (R2RPosition *r2rPos in path.positions)
    {
        CLLocationCoordinate2D pos;
        pos.latitude = r2rPos.lat;
        pos.longitude = r2rPos.lng;
        MKMapPoint mapPoint = MKMapPointForCoordinate(pos);
        points[count++] = mapPoint;
        //        R2RLog(@"%@", r2rPos);
    }
    
    R2RTrainPolyline *polyline = (R2RTrainPolyline *)[R2RTrainPolyline polylineWithPoints:points count:count];
    NSArray *array = [[NSArray alloc] initWithObjects:polyline, nil];
    return array;
}

-(NSArray *) getBusPolylines: (R2RTransitSegment *) segment
{
    R2RPath *path = [R2RPathEncoder decode:segment.path];
    
    NSMutableData *data = [NSMutableData dataWithLength:(sizeof(CLLocationCoordinate2D)*[path.positions count])];
    MKMapPoint *points = [data mutableBytes];
    int count = 0;
    
    //TODO: refactor out for all transitsegments but need count;
    for (R2RPosition *r2rPos in path.positions)
    {
        CLLocationCoordinate2D pos;
        pos.latitude = r2rPos.lat;
        pos.longitude = r2rPos.lng;
        MKMapPoint mapPoint = MKMapPointForCoordinate(pos);
        points[count++] = mapPoint;
    }
    
    R2RBusPolyline *polyline = (R2RBusPolyline *)[R2RBusPolyline polylineWithPoints:points count:count];
    NSArray *array = [[NSArray alloc] initWithObjects:polyline, nil];
    return array;
}

-(NSArray *) getFerryPolylines: (R2RTransitSegment *) segment
{
    
    R2RPath *path = [R2RPathEncoder decode:segment.path];
    
    NSMutableData *data = [NSMutableData dataWithLength:(sizeof(CLLocationCoordinate2D)*[path.positions count])];
    MKMapPoint *points = [data mutableBytes];
    int count = 0;
    
    //TODO: refactor out for all transitsegments but need count;
    for (R2RPosition *r2rPos in path.positions)
    {
        CLLocationCoordinate2D pos;
        pos.latitude = r2rPos.lat;
        pos.longitude = r2rPos.lng;
        MKMapPoint mapPoint = MKMapPointForCoordinate(pos);
        points[count++] = mapPoint;
    }
    
    R2RFerryPolyline *polyline = (R2RFerryPolyline *)[R2RFerryPolyline polylineWithPoints:points count:count];
    NSArray *array = [[NSArray alloc] initWithObjects:polyline, nil];
    return array;
}

-(NSArray *) getWalkDrivePolylines: (R2RWalkDriveSegment *) segment
{
    
    R2RPath *path = [R2RPathEncoder decode:segment.path];
    
    NSMutableData *data = [NSMutableData dataWithLength:(sizeof(CLLocationCoordinate2D)*[path.positions count])];
    MKMapPoint *points = [data mutableBytes];
    int count = 0;
    
    //TODO: refactor out for all transitsegments but need count;
    for (R2RPosition *r2rPos in path.positions)
    {
        CLLocationCoordinate2D pos;
        pos.latitude = r2rPos.lat;
        pos.longitude = r2rPos.lng;
        MKMapPoint mapPoint = MKMapPointForCoordinate(pos);
        points[count++] = mapPoint;
        //        R2RLog(@"%@", r2rPos);
    }
    
    R2RWalkDrivePolyline *polyline = (R2RWalkDrivePolyline *)[R2RWalkDrivePolyline polylineWithPoints:points count:count];
    NSArray *array = [[NSArray alloc] initWithObjects:polyline, nil];
    return array;
}

-(id)getPolylineView:(id)polyline
{
    if ([polyline isKindOfClass:[R2RFlightPolyline class]])
    {
        return [[R2RFlightPolylineView alloc] initWithPolyline:polyline];
    }
    else if ([polyline isKindOfClass:[R2RBusPolyline class]])
    {
        return [[R2RBusPolylineView alloc] initWithPolyline:polyline];
    }
    else if ([polyline isKindOfClass:[R2RTrainPolyline class]])
    {
        return [[R2RTrainPolylineView alloc] initWithPolyline:polyline];
    }
    else if ([polyline isKindOfClass:[R2RFerryPolyline class]])
    {
        return [[R2RFerryPolylineView alloc] initWithPolyline:polyline];
    }
    else if ([polyline isKindOfClass:[R2RWalkDrivePolyline class]])
    {
        return [[R2RWalkDrivePolylineView alloc] initWithPolyline:polyline];
    }
    else
    {
        return [[MKPolylineView alloc] initWithPolyline:polyline];
    }
        
}

-(id)getAnnotationView:(MKMapView *)mapView :(id<MKAnnotation>)annotation
{
    static NSString *identifier = @"R2RhopAnnotation";
    if ([annotation isKindOfClass:[R2RHopAnnotation class]])
    {
        MKAnnotationView *annotationView = (MKAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil)
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            CGPoint iconOffset = CGPointMake(267, 46);
            CGSize iconSize = CGSizeMake (12, 12);
            
            R2RSprite *sprite = [[R2RSprite alloc] initWithPath:nil :iconOffset :iconSize ];
            
            UIImage *image = [sprite getSprite:[UIImage imageNamed:@"sprites6"]];
            UIImage *smallerImage = [UIImage imageWithCGImage:image.CGImage scale:1.5 orientation:image.imageOrientation];
            annotationView.image = smallerImage;
            
        }
        else
        {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

-(NSArray *) getRouteHopAnnotations:(R2RRoute *) route
{
    NSMutableArray *hopAnnotations = [[NSMutableArray alloc] init];
    
    for (id segment in route.segments)
    {
        if([segment isKindOfClass:[R2RWalkDriveSegment class]])
        {
            [self getWalkDriveHopAnnotations:hopAnnotations :segment];
        }
        else if([segment isKindOfClass:[R2RTransitSegment class]])
        {
            [self getTransitHopAnnotations:hopAnnotations :segment];
        }
        else if([segment isKindOfClass:[R2RFlightSegment class]])
        {
            [self getFlightHopAnnotations:hopAnnotations :segment];
        }
    }
    
    return hopAnnotations;
}

-(void) getWalkDriveHopAnnotations:(NSMutableArray *) hopAnnotations:(R2RTransitSegment *)segment
{
//    if (![hops containsObject:segment.sPos])
//    {
//        [hops addObject:segment.sPos];
//    }
//    if (![hops containsObject:segment.tPos])
//    {
//        [hops addObject:segment.tPos];
//    }
}


-(void) getTransitHopAnnotations:(NSMutableArray *)hopAnnotations:(R2RTransitSegment *)segment
{
    R2RTransitItinerary *itinerary = [segment.itineraries objectAtIndex:0];
    for (R2RTransitLeg *leg in itinerary.legs)
    {
        for (R2RTransitHop *hop in leg.hops)
        {
            if (!(leg == [itinerary.legs lastObject] && hop == [leg.hops lastObject]))
            {
                CLLocationCoordinate2D pos;
                pos.latitude = hop.tPos.lat;
                pos.longitude = hop.tPos.lng;
                R2RHopAnnotation *annotation = [[R2RHopAnnotation alloc] initWithName:hop.tName coordinate:pos];
                
                [hopAnnotations addObject:annotation];
            }
        }
    }
}


-(void) getFlightHopAnnotations:(NSMutableArray *) hopAnnotations:(R2RTransitSegment *)segment
{
    R2RFlightItinerary *itinerary = [segment.itineraries objectAtIndex:0];
    R2RFlightLeg *leg = [itinerary.legs objectAtIndex:0];
    
    for (R2RFlightHop *hop in leg.hops)
    {
        if ( hop != [leg.hops lastObject])
        {
            for (R2RAirport *airport in self.dataStore.searchResponse.airports)
            {
                if ([airport.code isEqualToString:hop.tCode])
                {
                    CLLocationCoordinate2D pos;
                    pos.latitude = airport.pos.lat;
                    pos.longitude = airport.pos.lng;
                    R2RHopAnnotation *annotation = [[R2RHopAnnotation alloc] initWithName:airport.name coordinate:pos];
                    
                    [hopAnnotations addObject:annotation];
                }
            }
        }
    }
}

-(void)filterAnnotations:(NSArray *)stops:(NSArray *)hops:(MKMapView *) mapView
{
    NSArray *placesToFilter = hops;
    
    float latDelta=mapView.region.span.latitudeDelta/20.0;
    float longDelta=mapView.region.span.longitudeDelta/20.0;
    
    NSMutableArray *placesToShow=[[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i=0; i<[placesToFilter count]; i++)
    {
        R2RHopAnnotation *checkingLocation=[placesToFilter objectAtIndex:i];
        CLLocationDegrees latitude = checkingLocation.coordinate.latitude;
        CLLocationDegrees longitude = checkingLocation.coordinate.longitude;
        
        bool found=FALSE;
        
        for (R2RMKAnnotation *stopAnnotation in stops)
        {
            if(fabs(stopAnnotation.coordinate.latitude-latitude) < latDelta &&
               fabs(stopAnnotation.coordinate.longitude-longitude) <longDelta )
            {
                [mapView removeAnnotation:checkingLocation];
                found=TRUE;
                break;
            }
        }
        for (R2RHopAnnotation *hopAnnotation in placesToShow)
        {
            if(fabs(hopAnnotation.coordinate.latitude-latitude) < latDelta &&
               fabs(hopAnnotation.coordinate.longitude-longitude) <longDelta )
            {
                [mapView removeAnnotation:checkingLocation];
                found=TRUE;
                break;
            }
        }
        if (!found)
        {
            [placesToShow addObject:checkingLocation];
            [mapView addAnnotation:checkingLocation];
        }
    }
}

@end

@implementation R2RFlightPolyline

@end

@implementation R2RBusPolyline

@end

@implementation R2RTrainPolyline

@end

@implementation R2RFerryPolyline

@end

@implementation R2RWalkDrivePolyline

@end


@implementation R2RFlightPolylineView

-(id) initWithPolyline:(MKPolyline *)polyline
{
    self = [super initWithPolyline:polyline];
    if (self)
    {
        self.strokeColor = [R2RConstants getFlightLineColor];
        self.lineWidth = 4;
    }
    return self;
}

@end

@implementation R2RBusPolylineView

-(id) initWithPolyline:(MKPolyline *)polyline
{
    self = [super initWithPolyline:polyline];
    if (self)
    {
        self.strokeColor = [R2RConstants getBusLineColor];
        self.lineWidth = 4;
    }
    return self;
}

@end

@implementation R2RTrainPolylineView

-(id) initWithPolyline:(MKPolyline *)polyline
{
    self = [super initWithPolyline:polyline];
    if (self)
    {
        self.strokeColor = [R2RConstants getTrainLineColor];
        self.lineWidth = 4;
    }
    return self;
}

@end

@implementation R2RFerryPolylineView

-(id) initWithPolyline:(MKPolyline *)polyline
{
    self = [super initWithPolyline:polyline];
    if (self)
    {
        self.strokeColor = [R2RConstants getFerryLineColor];
        self.lineWidth = 4;
    }
    return self;
}

@end

@implementation R2RWalkDrivePolylineView

-(id) initWithPolyline:(MKPolyline *)polyline
{
    self = [super initWithPolyline:polyline];
    if (self)
    {
        self.strokeColor = [R2RConstants getWalkDriveLineColor];
        self.lineWidth = 4;
    }
    return self;
}

@end
