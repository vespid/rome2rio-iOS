//
//  R2RDetailViewController.m
//  R2RApp
//
//  Created by Ash Verdoorn on 6/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "R2RDetailViewController.h"
#import "R2RFlightSegmentViewController.h"

//TODO
#import "R2RFlight2ViewController.h"

#import "R2RTransitSegmentViewController.h"
#import "R2RWalkDriveSegmentViewController.h"
#import "R2RImageView.h"

#import "R2RNameCell.h"
#import "R2RMapCell.h"
#import "R2RFlightHopCell.h"
#import "R2RTransitHopCell.h"
#import "R2RWalkDriveHopCell.h"
//#import "R2RHopCell.h"
#import "R2RStringFormatters.h"
#import "R2RSegmentHandler.h"
#import "R2RSprite.h"
//#import "R2RMapFunctions.h"
#import "R2RMKAnnotation.h"
#import "R2RMapHelper.h"

#import "R2RAirport.h"
#import "R2RAirline.h"
#import "R2RRoute.h"
#import "R2RWalkDriveSegment.h"
#import "R2RTransitSegment.h"
#import "R2RTransitItinerary.h"
#import "R2RTransitLeg.h"
#import "R2RTransitLine.h"
#import "R2RTransitHop.h"
#import "R2RFlightSegment.h"
#import "R2RFlightItinerary.h"
#import "R2RFlightLeg.h"
#import "R2RFlightHop.h"
#import "R2RFlightTicketSet.h"
#import "R2RFlightTicket.h"
#import "R2RPosition.h"
#import "R2RStop.h"


@implementation R2RDetailViewController

@synthesize route, dataController;
//@synthesize routeMap;

#pragma mark - Managing the detail item

//- (void)setDetailItem:(id)newDetailItem
//{
//    if (_detailItem != newDetailItem) {
//        _detailItem = newDetailItem;
//        
//        // Update the view.
//        [self configureView];
//    }
//}

//- (void)configureView
//{
//    // Update the user interface for the detail item.
//
////    if (self.detailItem) {
////        self.detailDescriptionLabel.text = [self.detailItem description];
////    }
//}

//- (void)viewWillAppear:(BOOL)animated
//{
////    [self annotateStops];
////    
////    [self zoomToMapAnnotations];
//    
//    
////    self.routeMap.centerCoordinate = CLLocationCoordinate2DMake(144, -30);
//
//    
//    
////    CLLocationCoordinate2D center = self.routeMap.centerCoordinate;
////    [self.routeMap set]
////    [self.routeMap setCenterCoordinate:center zoomLevel:0 animated:YES];
//    
////    [self.routeMap setZoomEnabled:YES];
//    
//    
//    
//////    R2RStop *firstStop = [route.stops objectAtIndex:0];
//////    R2RStop *lastStop = [route.stops lastObject];
//////    
//////    R2RMapFunctions *mapfunctions = [[R2RMapFunctions alloc] init];
//////    CLLocationCoordinate2D zoomLocation = [mapfunctions midPoint:firstStop.pos.lat :firstStop.pos.lng :lastStop.pos.lat :lastStop.pos.lng];
////    CLLocationCoordinate2D zoomLocation = CLLocationCoordinate2DMake(0, 0);
////    
//////    zoomLocation.latitude = firstStop.pos.lat;
//////    zoomLocation.longitude= firstStop.pos.lng;
////    // 2
//////    double distance = [mapfunctions haversine_km:firstStop.pos.lat :firstStop.pos.lng :lastStop.pos.lat :lastStop.pos.lng];
////    
////    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 40000000, 4000000);
////    // 3
////    
////    
////    MKCoordinateRegion adjustedRegion = [routeMap regionThatFits:viewRegion];
////    // 4
////    [routeMap setRegion:adjustedRegion animated:YES];
//    
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:234.0/256.0 green:228.0/256.0 blue:224.0/256.0 alpha:1.0]];
 
//    self.routeMap = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
//    self.routeMap.delegate = self;
    
	// Do any additional setup after loading the view, typically from a nib.
//    [self configureView];
}

- (void)viewDidUnload
{
//    [self setRouteMap:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor colorWithRed:254.0/256.0 green:248.0/256.0 blue:244.0/256.0 alpha:1.0]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return (([self.route.segments count] * 2)+1)*2;
    
    if (section == 1) return 1; //map section
    
    return (([self.route.segments count] * 2)+1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1)
    {
        NSString *CellIdentifier = @"MapCell";
        
        R2RMapCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        [self configureMapCell:cell];
        
        return cell;
    }
    
//    int aCount = (([self.route.segments count] * 2)+1);
//    if ((indexPath.row%aCount) % 2 == 0)
    if (indexPath.row % 2 == 0)
    {
//        int row = indexPath.row;
//        int routeIndex = floor((row%aCount)/2.0);//  floor((indexPath.row%(([self.route.segments count] * 2)+1))/2);
        int routeIndex = floor(indexPath.row/2);
        
        NSString *CellIdentifier = @"NameCell";
        
        R2RNameCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        [self configureNameCell:cell :routeIndex];
        
        if (indexPath.row == ([self.route.segments count] * 2))
        {
            cell.layer.shadowOffset = CGSizeMake(0,5);
            cell.layer.shadowRadius = 5;
            cell.layer.shadowOpacity = 0.5;

        }
        
        return cell;
    }
    else
    {
        int routeIndex = floor((indexPath.row%(([self.route.segments count] * 2)+1))/2);
        //int routeIndex = floor(indexPath.row/2);
        
        NSString *CellIdentifier = [self getCellIdentifier:[self.route.segments objectAtIndex:routeIndex]];
        
        id cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell = [self configureHopCell:cell :[self.route.segments objectAtIndex:routeIndex]];
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section == 1)
    {
        return [self calculateMapHeight];
    }
    
    return 37;//default height for route cell
}

-(NSString*) getCellIdentifier:(id) segment
{
    
    if([segment isKindOfClass:[R2RWalkDriveSegment class]])
    {
        return @"WalkDriveHopCell";
    }
    else if([segment isKindOfClass:[R2RTransitSegment class]])
    {
        return @"TransitHopCell";
    }
    else if([segment isKindOfClass:[R2RFlightSegment class]])
    {
        return @"FlightHopCell";
    }
    
    return nil;
}

-(void) configureNameCell:(R2RNameCell *) cell: (NSInteger) routeIndex
{
    R2RStop *stop = [self.route.stops objectAtIndex:routeIndex];
    
    if ([stop.kind isEqualToString:@"airport"])
    {
#warning stop names change between transit and flight segments
        [cell.nameLabel setText: [NSString stringWithFormat:@"%@ (%@)", stop.name, stop.code]];
//        [cell.nameLabel setText: [NSString stringWithFormat:@"%@", stop.name]];
    }
    else
    {
        [cell.nameLabel setText:stop.name];
    }
    
    R2RSegmentHandler *segmentHandler = [[R2RSegmentHandler alloc] init];
    
    if (routeIndex == 0)
    {
        [cell.connectTop setHidden:YES];
    }
    else
    {
        [cell.connectTop setHidden:NO];
        R2RSprite *sprite = [segmentHandler getConnectionSprite:[self.route.segments objectAtIndex:routeIndex-1]];
        [self.dataController.spriteStore setSpriteInView:sprite :cell.connectTop];
    }
    
    if (routeIndex == [self.route.segments count])
    {
        [cell.connectBottom setHidden:YES];
    }
    else
    {
        [cell.connectBottom setHidden:NO];
        R2RSprite *sprite = [segmentHandler getConnectionSprite:[self.route.segments objectAtIndex:routeIndex]];
        [self.dataController.spriteStore setSpriteInView:sprite :cell.connectBottom];
    }
    
    CGPoint iconOffset = CGPointMake(267, 46);
    CGSize iconSize = CGSizeMake (12, 12);
    
    R2RSprite *sprite = [[R2RSprite alloc] initWithPath:@"sprites6.png" :iconOffset :iconSize ];
    
    [self.dataController.spriteStore setSpriteInView:sprite :cell.icon];
    
    [cell.contentView setBackgroundColor:[UIColor colorWithRed:234.0/256.0 green:228.0/256.0 blue:224.0/256.0 alpha:1.0]];
    
    return;
}

-(id) configureHopCell:(id) cell:(id) segment
{
    if([cell isKindOfClass:[R2RWalkDriveHopCell class]])
    {
        return [self configureWalkDriveHopCell:cell:segment];
    }
    else if([cell isKindOfClass:[R2RTransitHopCell class]])
    {
        return [self configureTransitHopCell:cell:segment];
    }
    else if([cell isKindOfClass:[R2RFlightHopCell class]])
    {
        return [self configureFlightHopCell:cell:segment];
    }
    return nil;
}

//Hop cells are now very similar so could be refactored to a single cell type
//CODECHECK: current each cell type has a different segue
//           we would need to do the segue programmatically to go to the correct segment view

-(R2RFlightHopCell *) configureFlightHopCell:(R2RFlightHopCell *) cell:(R2RFlightSegment *) segment
{
    R2RStringFormatters *formatter = [[R2RStringFormatters alloc] init];
    R2RSegmentHandler *segmentHandler = [[R2RSegmentHandler alloc] init];
    
    NSInteger changes = [segmentHandler getFlightChanges:segment];
    
    NSString *hopDescription = [formatter formatFlightHopCellDescription:segment.duration :changes];
    [cell.hopLabel setText:hopDescription];
    
    R2RSprite *sprite = [segmentHandler getConnectionSprite:segment];
    [self.dataController.spriteStore setSpriteInView:sprite :cell.connectTop];
    [self.dataController.spriteStore setSpriteInView:sprite :cell.connectBottom];
    
    sprite = [segmentHandler getRouteSprite:segment.kind];
    [self.dataController.spriteStore setSpriteInView:sprite :cell.icon];

    return cell;
}

-(R2RTransitHopCell *) configureTransitHopCell:(R2RTransitHopCell *) cell:(R2RTransitSegment *) segment
{    
    R2RStringFormatters *formatter = [[R2RStringFormatters alloc] init];
    R2RSegmentHandler *segmentHandler = [[R2RSegmentHandler alloc] init];
    
    NSInteger changes = [segmentHandler getTransitChanges:segment]; 
    NSString *vehicle = segment.vehicle;
    NSInteger frequency = [segmentHandler getTransitFrequency:segment];
    NSString *hopDescription = [formatter formatTransitHopDescription:segment.duration :changes :frequency :vehicle];
    [cell.hopLabel setText:hopDescription];
    
    R2RSprite *sprite = [segmentHandler getConnectionSprite:segment];
    [self.dataController.spriteStore setSpriteInView:sprite :cell.connectTop];
    [self.dataController.spriteStore setSpriteInView:sprite :cell.connectBottom];
    
    sprite = [segmentHandler getRouteSprite:segment.kind];
    [self.dataController.spriteStore setSpriteInView:sprite :cell.icon];
   
    return cell;
}

-(R2RWalkDriveHopCell *) configureWalkDriveHopCell:(R2RWalkDriveHopCell *) cell:(R2RWalkDriveSegment *) segment
{
    R2RStringFormatters *formatter = [[R2RStringFormatters alloc] init];
    
    NSString *hopDescription = [formatter formatWalkDriveHopCellDescription:segment.duration :segment.distance: segment.kind];
    [cell.hopLabel setText:hopDescription];
    
    R2RSegmentHandler *segmentHandler = [[R2RSegmentHandler alloc] init];
    
    R2RSprite *sprite = [segmentHandler getConnectionSprite:segment];
    [self.dataController.spriteStore setSpriteInView:sprite :cell.connectTop];
    [self.dataController.spriteStore setSpriteInView:sprite :cell.connectBottom];
    
    sprite = [segmentHandler getRouteSprite:segment.kind];
    [self.dataController.spriteStore setSpriteInView:sprite :cell.icon];

    
    return cell;
}


-(NSString*) getSegmentKind:(id) segment
{
    if([segment isKindOfClass:[R2RWalkDriveSegment class]])
    {
        R2RWalkDriveSegment *currentSegment = segment;
        return currentSegment.kind;
    }
    else if([segment isKindOfClass:[R2RTransitSegment class]])
    {
        R2RTransitSegment *currentSegment = segment;
        return currentSegment.kind;
    }
    else if([segment isKindOfClass:[R2RFlightSegment class]])
    {
        R2RFlightSegment *currentSegment = segment;
        return currentSegment.kind;
    }
    return nil;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showFlightSegment"])
    {
        R2RFlightSegmentViewController *segmentViewController = [segue destinationViewController];
        segmentViewController.dataController = self.dataController;
        segmentViewController.route = self.route;
        segmentViewController.flightSegment = [self.route.segments objectAtIndex:([self.tableView indexPathForSelectedRow].row)/2];
        
        [segmentViewController sortFlightSegment];
        
    }
//    if ([[segue identifier] isEqualToString:@"Flights2"])
//    {
//        R2RFlight2ViewController *segmentViewController = [segue destinationViewController];
//        segmentViewController.dataController = self.dataController;
//        segmentViewController.route = self.route;
//        segmentViewController.flightSegment = [self.route.segments objectAtIndex:([self.tableView indexPathForSelectedRow].row)/2];
//        [segmentViewController sortFlightSegment];
//        
//    }
    if ([[segue identifier] isEqualToString:@"showTransitSegment"])
    {
        R2RTransitSegmentViewController *segmentViewController = [segue destinationViewController];
        segmentViewController.dataController = self.dataController;
        segmentViewController.route = self.route;
        segmentViewController.transitSegment = [self.route.segments objectAtIndex:([self.tableView indexPathForSelectedRow].row)/2];
    }
    if ([[segue identifier] isEqualToString:@"showWalkDriveSegment"])
    {
        R2RWalkDriveSegmentViewController *segmentViewController = [segue destinationViewController];
        segmentViewController.dataController = self.dataController;
        segmentViewController.route = self.route;
        segmentViewController.walkDriveSegment = [self.route.segments objectAtIndex:([self.tableView indexPathForSelectedRow].row)/2];
    }

}


- (IBAction)ReturnToSearch:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];

}

-(float) calculateMapHeight
{
    CGRect viewRect = self.view.bounds;
    CGRect sectRect = [self.tableView rectForSection:0]; //route section;
    
    if (sectRect.size.height < (viewRect.size.height/3))
    {
        int height = (viewRect.size.height - sectRect.size.height);
        return height;
    }
    else
    {
        return viewRect.size.height*2/3;
    }
}

-(void) configureMapCell:(R2RMapCell *) cell
{
    [cell.mapView setDelegate:self];
    
    CGRect mapFrame = cell.mapView.frame;
    mapFrame.size.height = [self calculateMapHeight];
    
    [cell.mapView setFrame:mapFrame];
    
    for (R2RStop *stop in self.route.stops)
    {
        CLLocationCoordinate2D pos;
        pos.latitude = stop.pos.lat;
        pos.longitude = stop.pos.lng;

        R2RMKAnnotation *annotation = [[R2RMKAnnotation alloc] initWithName:stop.name address:stop.kind coordinate:pos];
        [cell.mapView addAnnotation:annotation];
    }
    
    R2RMapHelper *mapHelper = [[R2RMapHelper alloc] initWithData:self.dataController];
    
    MKMapRect zoomRect = MKMapRectNull;
    for (id segment in self.route.segments)
    {
        MKMapRect segmentRect = [mapHelper getSegmentZoomRect:segment];
        if (MKMapRectIsNull(zoomRect))
        {
            zoomRect = segmentRect;
        }
        else
        {
            zoomRect = MKMapRectUnion(zoomRect, segmentRect);
        }
    }
    
    R2RLog(@"%.3f\t%.3f\t%.3f\t%.3f\t", zoomRect.origin.x, zoomRect.origin.y, zoomRect.size.width, zoomRect.size.height);
    
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(zoomRect);
    
    R2RLog(@"%.3f\t%.3f\t%.3f\t%.3f\t", region.center.latitude, region.center.longitude, region.span.longitudeDelta, region.span.latitudeDelta);
    
    if (region.span.longitudeDelta > 180) //if span is too large to fit on map just focus on destination
    {
        R2RStop *lastStop = [self.route.stops lastObject];
        region.center.latitude = lastStop.pos.lat;
        region.center.longitude = lastStop.pos.lng;
        region.span.longitudeDelta = 180.0f;
        
    }
    else
    {
        region.span.latitudeDelta *=1.1;
        region.span.longitudeDelta *=1.1;
    }
    
    [cell.mapView setRegion:region];

    for (id segment in self.route.segments)
    {
        NSArray *paths = [mapHelper getPolylines:segment];
        for (id path in paths)
        {
            [cell.mapView addOverlay:path];
        }
//        id path = [mapHelper getPolyline:segment];//] :points :count ];
//        if (path)
//        {
//            [cell.mapView addOverlay:path];
//        }
    }
    
//    
//    cell.layer.shadowOffset = CGSizeMake(-15,20);
//    cell.layer.shadowRadius = 5;
//    cell.layer.shadowOpacity = 0.5;
//    
//    
//    CGRect rect = CGRectMake(50, 50, 100, 100);
//    
//    UIView *view = [[UIView alloc] initWithFrame:rect];
//    
//    view.layer.shadowOffset = CGSizeMake(-15,20);
//    view.layer.shadowRadius = 5;
//    view.layer.shadowOpacity = 0.5;
//    [view setBackgroundColor:[UIColor greenColor]];
//    
//    [cell.mapView addSubview:view];
//
//    

}

#pragma mark MKMapViewDelegate
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id) overlay// (id <MKOverlay>)overlay
{
//	MKOverlayView* overlayView = nil;
    
    R2RMapHelper *mapHelper = [[R2RMapHelper alloc] init];
	
    return [mapHelper getPolylineView:overlay];
    
}


//-(void) annotateStops
//{
//    for (R2RStop *stop in self.route.stops)
//    {
//        CLLocationCoordinate2D pos;
//        pos.latitude = stop.pos.lat;
//        pos.longitude = stop.pos.lng;
//        
//        R2RMKAnnotation *annotation = [[R2RMKAnnotation alloc] initWithName:stop.name address:stop.kind coordinate:pos];
//        [routeMap addAnnotation:annotation];
//    }
//}
//
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
//    
//    static NSString *identifier = @"R2RMKAnnotation";
//    if ([annotation isKindOfClass:[R2RMKAnnotation class]]) {
//        
//        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.routeMap dequeueReusableAnnotationViewWithIdentifier:identifier];
//        if (annotationView == nil) {
//            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
//        } else {
//            annotationView.annotation = annotation;
//        }
//        
//        annotationView.enabled = YES;
//        annotationView.canShowCallout = YES;
////        annotationView.image=[UIImage imageNamed:@"arrest.png"];//here we use a nice image instead of the default pins
//        
//        return annotationView;
//    }
//    
//    return nil;
//}
//
//- (void) zoomToMapAnnotations
//{
//    MKMapRect zoomRect = MKMapRectNull;
//    NSArray *annotations = [self.routeMap annotations];
//    for (R2RMKAnnotation *annotation in annotations) {
//        
//        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
//        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
//        if (MKMapRectIsNull(zoomRect)) {
//            zoomRect = pointRect;
//        } else {
//            zoomRect = MKMapRectUnion(zoomRect, pointRect);
//        }
//        
//    }
//    
//    [self.routeMap setVisibleMapRect:zoomRect animated:YES];
//}

@end
