//
//  R2RDetailViewController.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 30/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "R2RDetailViewController.h"

#import "R2RFlightSegmentViewController.h"
#import "R2RTransitSegmentViewController.h"
#import "R2RWalkDriveSegmentViewController.h"

#import "R2RNameCell.h"
#import "R2RFlightHopCell.h"
#import "R2RTransitHopCell.h"
#import "R2RWalkDriveHopCell.h"

#import "R2RStringFormatter.h"
#import "R2RSegmentHelper.h"
#import "R2RSprite.h"
#import "R2RStopAnnotation.h"
#import "R2RMapHelper.h"
#import "R2RConstants.h"

@interface R2RDetailViewController ()

@property (nonatomic) CLLocationDegrees zoomLevel;
@property (nonatomic) BOOL isMapZoomedToAnnotation;

@end

@implementation R2RDetailViewController

@synthesize route, dataStore;

#pragma mark - Managing the detail item

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[R2RConstants getBackgroundColor]];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundColor:[R2RConstants getBackgroundColor]];
    
    [self.view sendSubviewToBack:self.mapView];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footer;
    
    [self configureMap];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
   
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setMapView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[R2RConstants getCellColor]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (([self.route.segments count] * 2)+1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0)
    {
        int routeIndex = floor(indexPath.row/2);
        
        NSString *CellIdentifier = @"NameCell";
        
        R2RNameCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        [self configureNameCell:cell :routeIndex];
        
        return cell;
    }
    else
    {
        int routeIndex = floor((indexPath.row%(([self.route.segments count] * 2)+1))/2);
        
        NSString *CellIdentifier = [self getCellIdentifier:[self.route.segments objectAtIndex:routeIndex]];
        
        id cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell = [self configureHopCell:cell :[self.route.segments objectAtIndex:routeIndex]];
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        [cell.nameLabel setText: [NSString stringWithFormat:@"%@ (%@)", stop.name, stop.code]];
    }
    else
    {
        [cell.nameLabel setText:stop.name];
    }
    
    R2RSegmentHelper *segmentHandler = [[R2RSegmentHelper alloc] init];
    
    if (routeIndex == 0)
    {
        [cell.connectTop setHidden:YES];
    }
    else
    {
        [cell.connectTop setHidden:NO];
        R2RSprite *sprite = [segmentHandler getConnectionSprite:[self.route.segments objectAtIndex:routeIndex-1]];
        [self.dataStore.spriteStore setSpriteInView:sprite :cell.connectTop];
    }
    
    if (routeIndex == [self.route.segments count])
    {
        [cell.connectBottom setHidden:YES];
    }
    else
    {
        [cell.connectBottom setHidden:NO];
        R2RSprite *sprite = [segmentHandler getConnectionSprite:[self.route.segments objectAtIndex:routeIndex]];
        [self.dataStore.spriteStore setSpriteInView:sprite :cell.connectBottom];
    }
    
    CGPoint iconOffset = CGPointMake(267, 46);
    CGSize iconSize = CGSizeMake (12, 12);
    
    R2RSprite *sprite = [[R2RSprite alloc] initWithPath:@"sprites6" :iconOffset :iconSize ];
    
    [self.dataStore.spriteStore setSpriteInView:sprite :cell.icon];
    
    [cell.contentView setBackgroundColor:[R2RConstants getBackgroundColor]];
    
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

-(R2RFlightHopCell *) configureFlightHopCell:(R2RFlightHopCell *) cell:(R2RFlightSegment *) segment
{
    R2RSegmentHelper *segmentHandler = [[R2RSegmentHelper alloc] init];
    
    NSInteger changes = [segmentHandler getFlightChangeCount:segment];
    
    NSString *hopDescription = [R2RStringFormatter formatFlightHopCellDescription:segment.duration :changes];
    [cell.hopLabel setText:hopDescription];
    
    R2RSprite *sprite = [segmentHandler getConnectionSprite:segment];
    [self.dataStore.spriteStore setSpriteInView:sprite :cell.connectTop];
    [self.dataStore.spriteStore setSpriteInView:sprite :cell.connectBottom];
    
    sprite = [segmentHandler getRouteSprite:segment.kind];
    [self.dataStore.spriteStore setSpriteInView:sprite :cell.icon];
    
    return cell;
}

-(R2RTransitHopCell *) configureTransitHopCell:(R2RTransitHopCell *) cell:(R2RTransitSegment *) segment
{
    R2RSegmentHelper *segmentHandler = [[R2RSegmentHelper alloc] init];
    
    NSInteger changes = [segmentHandler getTransitChangeCount:segment];
    NSString *vehicle = segment.vehicle;
    NSInteger frequency = [segmentHandler getTransitFrequency:segment];
    NSString *hopDescription = [R2RStringFormatter formatTransitHopDescription:segment.duration :changes :frequency :vehicle];
    [cell.hopLabel setText:hopDescription];
    
    R2RSprite *sprite = [segmentHandler getConnectionSprite:segment];
    [self.dataStore.spriteStore setSpriteInView:sprite :cell.connectTop];
    [self.dataStore.spriteStore setSpriteInView:sprite :cell.connectBottom];
    
    sprite = [segmentHandler getRouteSprite:segment.kind];
    [self.dataStore.spriteStore setSpriteInView:sprite :cell.icon];
    
    return cell;
}

-(R2RWalkDriveHopCell *) configureWalkDriveHopCell:(R2RWalkDriveHopCell *) cell:(R2RWalkDriveSegment *) segment
{
    NSString *hopDescription = [R2RStringFormatter formatWalkDriveHopCellDescription:segment.duration :segment.distance: segment.kind];
    [cell.hopLabel setText:hopDescription];
    
    R2RSegmentHelper *segmentHandler = [[R2RSegmentHelper alloc] init];
    
    R2RSprite *sprite = [segmentHandler getConnectionSprite:segment];
    [self.dataStore.spriteStore setSpriteInView:sprite :cell.connectTop];
    [self.dataStore.spriteStore setSpriteInView:sprite :cell.connectBottom];
    
    sprite = [segmentHandler getRouteSprite:segment.kind];
    [self.dataStore.spriteStore setSpriteInView:sprite :cell.icon];
    
    
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
        segmentViewController.dataStore = self.dataStore;
        segmentViewController.route = self.route;
        segmentViewController.flightSegment = [self.route.segments objectAtIndex:([self.tableView indexPathForSelectedRow].row)/2];
        
        [segmentViewController sortFlightSegment];
    }
    if ([[segue identifier] isEqualToString:@"showTransitSegment"])
    {
        R2RTransitSegmentViewController *segmentViewController = [segue destinationViewController];
        segmentViewController.dataStore = self.dataStore;
        segmentViewController.route = self.route;
        segmentViewController.transitSegment = [self.route.segments objectAtIndex:([self.tableView indexPathForSelectedRow].row)/2];
    }
    if ([[segue identifier] isEqualToString:@"showWalkDriveSegment"])
    {
        R2RWalkDriveSegmentViewController *segmentViewController = [segue destinationViewController];
        segmentViewController.dataStore = self.dataStore;
        segmentViewController.route = self.route;
        segmentViewController.walkDriveSegment = [self.route.segments objectAtIndex:([self.tableView indexPathForSelectedRow].row)/2];
    }
}

- (IBAction)returnToSearch:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)reloadDataDidFinish
{
    [self.tableView sizeToFit];
    
    self.tableView.layer.shadowOffset = CGSizeMake(0,5);
    self.tableView.layer.shadowRadius = 5;
    self.tableView.layer.shadowOpacity = 0.5;
    self.tableView.layer.masksToBounds = NO;
    self.tableView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.tableView.bounds].CGPath;
    
    CGRect mapFrame = self.mapView.frame;
    mapFrame.origin.y = self.tableView.frame.size.height;
    mapFrame.size.height = [self calculateMapHeight];
    
    [self.mapView setFrame:mapFrame];
    
    CGSize scrollviewSize = self.view.frame.size;
    scrollviewSize.height = self.tableView.frame.size.height + mapFrame.size.height;
    UIScrollView *tempScrollView=(UIScrollView *)self.view;
    tempScrollView.contentSize=scrollviewSize;
}

-(float) calculateMapHeight
{
    CGRect viewRect = self.view.frame;
    CGRect tableRect = self.tableView.frame;
    
    if (tableRect.size.height < (viewRect.size.height/3))
    {
        int height = (viewRect.size.height - tableRect.size.height);
        return height;
    }
    else
    {
        return viewRect.size.height*2/3;
    }
}

-(void) configureMap
{
    [self.mapView setDelegate:self];
    
    R2RMapHelper *mapHelper = [[R2RMapHelper alloc] initWithData:self.dataStore];
    
    NSArray *stopAnnotations = [mapHelper getRouteStopAnnotations:self.route];
    NSArray *hopAnnotations = [mapHelper getRouteHopAnnotations:self.route];
    
    hopAnnotations = [mapHelper filterHopAnnotations:hopAnnotations stopAnnotations:stopAnnotations regionSpan:self.mapView.region.span];
    
    for (R2RStopAnnotation *annotation in stopAnnotations)
    {
        [self.mapView addAnnotation:annotation];
    }
    
    for (R2RHopAnnotation *annotation in hopAnnotations)
    {
        [self.mapView addAnnotation:annotation];
    }
    
    [self setMapRegionDefault];
    
    for (id segment in self.route.segments)
    {
        NSArray *paths = [mapHelper getPolylines:segment];
        for (id path in paths)
        {
            [self.mapView addOverlay:path];
        }
    }
}

//set map to display main region for route
- (void)setMapRegionDefault
{
    R2RMapHelper *mapHelper = [[R2RMapHelper alloc] init];
    MKMapRect bounds = MKMapRectNull;
    
    for (id segment in self.route.segments)
    {
        MKMapRect segmentRect = [mapHelper getSegmentBounds:segment];
        bounds = MKMapRectUnion(bounds, segmentRect);
    }
    
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(bounds);
    
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
    
    self.zoomLevel = region.span.longitudeDelta;
    
    [self.mapView setRegion:region];
}

#pragma mark MKMapViewDelegate
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id) overlay
{
    R2RMapHelper *mapHelper = [[R2RMapHelper alloc] init];
	
    return [mapHelper getPolylineView:overlay];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    R2RMapHelper *mapHelper = [[R2RMapHelper alloc] init];
	
    MKAnnotationView *annotationView = [mapHelper getAnnotationView:mapView :annotation];
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView calloutAccessoryControlTapped:(UIControl *)control
{
//    R2RLog(@"%@\t%f\t%f", annotationView.annotation.title, annotationView.annotation.coordinate.latitude, annotationView.annotation.coordinate.longitude);

    if (self.isMapZoomedToAnnotation)
    {
        [self setMapRegionDefault];
        
        self.isMapZoomedToAnnotation = NO;
    }
    else
    {
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annotationView.annotation.coordinate , 1000, 1000);
        
        self.zoomLevel = region.span.longitudeDelta;
        
        [self.mapView setRegion:region];
        
        [self.mapView deselectAnnotation:annotationView.annotation animated:NO];
        
        //must be after setRegion because isMapZoomedToAnnotation is set to NO when region changes
        self.isMapZoomedToAnnotation = YES;
    }
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    self.isMapZoomedToAnnotation = NO;
    if (self.zoomLevel!=mapView.region.span.longitudeDelta)
    {
        R2RMapHelper *mapHelper = [[R2RMapHelper alloc] initWithData:self.dataStore];
        
        NSArray *stopAnnotations = [mapHelper getRouteStopAnnotations:self.route];
        NSArray *hopAnnotations = [mapHelper getRouteHopAnnotations:self.route];
        
        hopAnnotations = [mapHelper filterHopAnnotations:hopAnnotations stopAnnotations:stopAnnotations regionSpan:self.mapView.region.span];
        
        //just get existing hopAnnotations
        NSMutableArray *existingHopAnnotations = [[NSMutableArray alloc] init];
        
        
        for (id annotation in mapView.annotations)
        {
            if ([annotation isKindOfClass:[R2RHopAnnotation class]])
            {
                [existingHopAnnotations addObject:annotation];
            }
        }
        
        NSArray *annotationsToAdd = [mapHelper removeAnnotations:hopAnnotations :existingHopAnnotations];
        [self.mapView addAnnotations:annotationsToAdd];
        
        NSArray *annotationsToRemove = [mapHelper removeAnnotations:existingHopAnnotations :hopAnnotations];
        [self.mapView removeAnnotations:annotationsToRemove];
            
        self.zoomLevel=mapView.region.span.longitudeDelta;
    }
}




@end
