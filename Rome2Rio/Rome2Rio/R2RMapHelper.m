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
//
//    MKCoordinateRegion region = MKCoordinateRegionForMapRect(rect);
//    region.span.latitudeDelta *=1.1;
//    region.span.longitudeDelta *=1.1;
//
//    return region;
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
    
    //CODECHECK: refactor out for all transitsegments but need count;
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
    
    //CODECHECK: refactor out for all transitsegments but need count;
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
    
    //CODECHECK: refactor out for all transitsegments but need count;
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
    
    //CODECHECK: refactor out for all transitsegments but need count;
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

//-(id)getPolyline:(id)segment :(MKMapPoint *)points :(NSInteger) count
-(id)getPolyline:(id)segment;
{
    R2RSegmentHandler *segmentHandler = [[R2RSegmentHandler alloc] init];
    NSString *kind = [segmentHandler getSegmentKind:segment];
    if ([kind isEqualToString:@"flight"])
    {
        return  [self getFlightPolyline:segment];// [R2RFlightPolyline polylineWithPoints:points count:count];
    }
    else if ([kind isEqualToString:@"train"])
    {
        return [self getTrainPolyline:segment];
    }
    else if ([kind isEqualToString:@"bus"])
    {
        return [self getBusPolyline:segment];
    }
    else if ([kind isEqualToString:@"ferry"])
    {
        return [self getFerryPolyline:segment];
    }
    else if ([kind isEqualToString:@"car"] || [kind isEqualToString:@"walk"])
    {
        return [self getWalkDrivePolyline:segment];
    }
    else
    {
        return nil;// [self getMKPolyline:segment];
    }
}

-(R2RFlightPolyline *) getFlightPolyline: (R2RFlightSegment *) segment
{
//    R2RSegmentHandler *segmentHandler = [[R2RSegmentHandler alloc] init];
    R2RFlightItinerary *itinerary = [segment.itineraries objectAtIndex:0];
    R2RFlightLeg *leg = [itinerary.legs objectAtIndex:0];
    
//TODO add geodesic Interpolation to flight path
// for now there is just straight lines between stops
    
    NSMutableData *data = [NSMutableData dataWithLength:(sizeof(CLLocationCoordinate2D)*([leg.hops count]+1))];
    MKMapPoint *points = [data mutableBytes];
    
    int count = 0;
    
    for (R2RFlightHop *hop in leg.hops)
    {
        for (R2RAirport *airport in self.dataStore.searchResponse.airports)
        {
            if ([airport.code isEqualToString:hop.sCode])
            {
                CLLocationCoordinate2D pos;
                pos.latitude = airport.pos.lat;
                pos.longitude = airport.pos.lng;
                MKMapPoint mapPoint = MKMapPointForCoordinate(pos);
                points[count++] = mapPoint;
                break;
            }
        }
        if (hop == [leg.hops lastObject])
        {
            for (R2RAirport *airport in self.dataStore.searchResponse.airports)
            {
                if ([airport.code isEqualToString:hop.tCode])
                {
                    CLLocationCoordinate2D pos;
                    pos.latitude = airport.pos.lat;
                    pos.longitude = airport.pos.lng;
                    MKMapPoint mapPoint = MKMapPointForCoordinate(pos);
                    points[count++] = mapPoint;
                    break;
                }
            }
        }
    }
    
    return (R2RFlightPolyline *)[R2RFlightPolyline polylineWithPoints:points count:count];
}

-(R2RTrainPolyline *) getTrainPolyline: (R2RTransitSegment *) segment
{
    
    R2RPath *path = [R2RPathEncoder decode:segment.path];
    
    NSMutableData *data = [NSMutableData dataWithLength:(sizeof(CLLocationCoordinate2D)*[path.positions count])];
    MKMapPoint *points = [data mutableBytes];
    int count = 0;
    
    for (R2RPosition *r2rPos in path.positions)
    {
        CLLocationCoordinate2D pos;
        pos.latitude = r2rPos.lat;
        pos.longitude = r2rPos.lng;
        MKMapPoint mapPoint = MKMapPointForCoordinate(pos);
        points[count++] = mapPoint;
    }
    
    return (R2RTrainPolyline *)[R2RTrainPolyline polylineWithPoints:points count:count];
}

-(R2RBusPolyline *) getBusPolyline: (R2RTransitSegment *) segment
{
    
    R2RPath *path = [R2RPathEncoder decode:segment.path];
    
    NSMutableData *data = [NSMutableData dataWithLength:(sizeof(CLLocationCoordinate2D)*[path.positions count])];
    MKMapPoint *points = [data mutableBytes];
    int count = 0;
    
    for (R2RPosition *r2rPos in path.positions)
    {
        CLLocationCoordinate2D pos;
        pos.latitude = r2rPos.lat;
        pos.longitude = r2rPos.lng;
        MKMapPoint mapPoint = MKMapPointForCoordinate(pos);
        points[count++] = mapPoint;
    }
    
    return (R2RBusPolyline *)[R2RBusPolyline polylineWithPoints:points count:count];
}

-(R2RFerryPolyline *) getFerryPolyline: (R2RTransitSegment *) segment
{
    
    R2RPath *path = [R2RPathEncoder decode:segment.path];
    
    NSMutableData *data = [NSMutableData dataWithLength:(sizeof(CLLocationCoordinate2D)*[path.positions count])];
    MKMapPoint *points = [data mutableBytes];
    int count = 0;
    
    for (R2RPosition *r2rPos in path.positions)
    {
        CLLocationCoordinate2D pos;
        pos.latitude = r2rPos.lat;
        pos.longitude = r2rPos.lng;
        MKMapPoint mapPoint = MKMapPointForCoordinate(pos);
        points[count++] = mapPoint;
    }
    
    return (R2RFerryPolyline *)[R2RFerryPolyline polylineWithPoints:points count:count];
}

-(R2RWalkDrivePolyline *) getWalkDrivePolyline: (R2RWalkDriveSegment *) segment
{
    
    R2RPath *path = [R2RPathEncoder decode:segment.path];
    
    NSMutableData *data = [NSMutableData dataWithLength:(sizeof(CLLocationCoordinate2D)*[path.positions count])];
    MKMapPoint *points = [data mutableBytes];
    int count = 0;
    
    for (R2RPosition *r2rPos in path.positions)
    {
        CLLocationCoordinate2D pos;
        pos.latitude = r2rPos.lat;
        pos.longitude = r2rPos.lng;
        MKMapPoint mapPoint = MKMapPointForCoordinate(pos);
        points[count++] = mapPoint;
    }
    
    return (R2RWalkDrivePolyline *)[R2RWalkDrivePolyline polylineWithPoints:points count:count];
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
        self.strokeColor = [UIColor colorWithRed:241/255.0 green:96/255.0 blue:36/255.0 alpha:1.0];
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
        self.strokeColor = [UIColor colorWithRed:98/255.0 green:144/255.0 blue:46/255.0 alpha:1.0];
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
        self.strokeColor = [UIColor colorWithRed:48/255.0 green:124/255.0 blue:192/255.0 alpha:1.0];
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
        self.strokeColor = [UIColor colorWithRed:64/255.0 green:170/255.0 blue:196/255.0 alpha:1.0];
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
        self.strokeColor = [UIColor blackColor];
        self.lineWidth = 4;
    }
    return self;
}

@end
