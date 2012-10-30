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
#import "R2RImageView.h"

#import "R2RNameCell.h"
#import "R2RFlightHopCell.h"
#import "R2RTransitHopCell.h"
#import "R2RWalkDriveHopCell.h"

#import "R2RStringFormatters.h"
#import "R2RSegmentHandler.h"
#import "R2RSprite.h"
#import "R2RMKAnnotation.h"
#import "R2RMapHelper.h"
#import "R2RConstants.h"

@interface R2RDetailViewController ()

@end

@implementation R2RDetailViewController

@synthesize route, dataController;

#pragma mark - Managing the detail item

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor purpleColor]]; //[R2RConstants getBackgroundColor]];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundColor:[R2RConstants getBackgroundColor]];
    
    self.tableView.layer.shadowOffset = CGSizeMake(0,5);
    self.tableView.layer.shadowRadius = 5;
    self.tableView.layer.shadowOpacity = 0.5;
    self.tableView.layer.masksToBounds = NO;
    [self.view sendSubviewToBack:self.mapView];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footer;
    
    [self configureMap];
}

- (void) viewWillAppear:(BOOL)animated {
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
    [cell setBackgroundColor:[UIColor colorWithRed:254.0/256.0 green:248.0/256.0 blue:244.0/256.0 alpha:1.0]];
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
    
    R2RSprite *sprite = [[R2RSprite alloc] initWithPath:@"sprites6" :iconOffset :iconSize ];
    
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

-(void)reloadDataDidFinish
{
    [self.tableView sizeToFit];
    
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
    
    for (R2RStop *stop in self.route.stops)
    {
        CLLocationCoordinate2D pos;
        pos.latitude = stop.pos.lat;
        pos.longitude = stop.pos.lng;
        
        R2RMKAnnotation *annotation = [[R2RMKAnnotation alloc] initWithName:stop.name address:stop.kind coordinate:pos];
        [self.mapView addAnnotation:annotation];
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
    
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(zoomRect);
    
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
    
    [self.mapView setRegion:region];
    
    for (id segment in self.route.segments)
    {
        NSArray *paths = [mapHelper getPolylines:segment];
        for (id path in paths)
        {
            [self.mapView addOverlay:path];
        }
    }
}

#pragma mark MKMapViewDelegate
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id) overlay// (id <MKOverlay>)overlay
{
    R2RMapHelper *mapHelper = [[R2RMapHelper alloc] init];
	
    return [mapHelper getPolylineView:overlay];
}

@end
