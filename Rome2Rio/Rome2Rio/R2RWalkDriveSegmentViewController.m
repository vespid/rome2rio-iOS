//
//  R2RWalkDriveSegmentViewController.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 30/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "R2RWalkDriveSegmentViewController.h"
#import "R2RStringFormatters.h"
#import "R2RConstants.h"

#import "R2RWalkDriveSegmentCell.h"
#import "R2RSegmentHandler.h"
#import "R2RMapHelper.h"
#import "R2RMKAnnotation.h"

@interface R2RWalkDriveSegmentViewController ()

@end

@implementation R2RWalkDriveSegmentViewController

@synthesize dataStore, route, walkDriveSegment;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = [R2RStringFormatters capitaliseFirstLetter:walkDriveSegment.kind];
    
    [self.view setBackgroundColor:[R2RConstants getBackgroundColor]];
    
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WalkDriveSegmentCell";
    R2RWalkDriveSegmentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    R2RSegmentHandler *segmentHandler = [[R2RSegmentHandler alloc] init];
    
    R2RSprite *sprite = [segmentHandler getRouteSprite:self.walkDriveSegment.kind];
    [self.dataStore.spriteStore setSpriteInView:sprite :cell.kindIcon];
    
    NSString *sName = self.walkDriveSegment.sName;
    NSString *tName = self.walkDriveSegment.tName;
    
    for (R2RStop *stop in self.route.stops)
    {
        if ([self.walkDriveSegment.sName isEqualToString:stop.name])
        {
            if ( [stop.kind isEqualToString:@"airport"])
            {
                sName = [NSString stringWithFormat:@"%@ (%@)", stop.name, stop.code];
            }
        }
        if ([self.walkDriveSegment.tName isEqualToString:stop.name])
        {
            if ( [stop.kind isEqualToString:@"airport"])
            {
                tName = [NSString stringWithFormat:@"%@ (%@)", stop.name, stop.code];
            }
        }
    }
    
    [cell.fromLabel setText:sName];
    [cell.toLabel setText:tName];
    
    [cell.distanceLabel setText:[R2RStringFormatters formatDistance:self.walkDriveSegment.distance]];
    [cell.durationLabel setText:[R2RStringFormatters formatDuration:self.walkDriveSegment.duration]];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;//default height for walkDrive segment cell
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
    
    R2RMapHelper *mapHelper = [[R2RMapHelper alloc] initWithData:self.dataStore];
    
    for (id segment in self.route.segments)
    {
        NSArray *paths = [mapHelper getPolylines:segment];
        for (id path in paths)
        {
            [self.mapView addOverlay:path];
        }
    }
    
    MKMapRect zoomRect = [mapHelper getSegmentZoomRect:self.walkDriveSegment];
    
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(zoomRect);
    region.span.latitudeDelta *=1.1;
    region.span.longitudeDelta *=1.1;
    
    [self.mapView setRegion:region];
}

#pragma mark MKMapViewDelegate
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id) overlay// (id <MKOverlay>)overlay
{
    R2RMapHelper *mapHelper = [[R2RMapHelper alloc] init];
	
    return [mapHelper getPolylineView:overlay];
}

- (IBAction)returnToSearch:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end