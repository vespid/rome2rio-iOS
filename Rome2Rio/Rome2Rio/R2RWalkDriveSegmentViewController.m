//
//  R2RWalkDriveSegmentViewController.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 14/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RWalkDriveSegmentViewController.h"
#import "R2RWalkDriveSegmentCell.h"

#import "R2RSegmentHandler.h"
#import "R2RStringFormatters.h"
#import "R2RMapCell.h"
#import "R2RMKAnnotation.h"
#import "R2RMapHelper.h"

@interface R2RWalkDriveSegmentViewController ()

@end

@implementation R2RWalkDriveSegmentViewController

@synthesize dataController, route, walkDriveSegment;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    R2RStringFormatters *stringFormatter = [[R2RStringFormatters alloc] init];
    
    self.navigationItem.title = [stringFormatter capitaliseFirstLetter:walkDriveSegment.kind];
    
    [self.tableView setBackgroundColor:[UIColor colorWithRed:234.0/256.0 green:228.0/256.0 blue:224.0/256.0 alpha:1.0]];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footer;
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        NSString *CellIdentifier = @"MapCell";
        
        R2RMapCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        [self configureMapCell:cell];
        
//        cell.mapView.autoresizingMask =  UIViewAutoresizingFlexibleWidth;

        return cell;
    }
    
    static NSString *CellIdentifier = @"WalkDriveSegmentCell";
    R2RWalkDriveSegmentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    R2RSegmentHandler *segmentHandler = [[R2RSegmentHandler alloc] init];
    
    R2RSprite *sprite = [segmentHandler getRouteSprite:self.walkDriveSegment.kind];
    [self.dataController.spriteStore setSpriteInView:sprite :cell.kindIcon];
    
//    [cell.kindIcon setImage:[segmentHandler getRouteIcon:self.walkDriveSegment.kind]];

    R2RStringFormatters *stringFormatter = [[R2RStringFormatters alloc] init];
    [cell.fromLabel setText:self.walkDriveSegment.sName];
    [cell.toLabel setText:self.walkDriveSegment.tName];
    
    [cell.distanceLabel setText:[stringFormatter formatDistance:self.walkDriveSegment.distance]];
    [cell.durationLabel setText:[stringFormatter formatDuration:self.walkDriveSegment.duration]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1)
    {
        return [self calculateMapHeight]-16;//-5 for top padding, -10 for map to cover footer
    }
    
    return 85;//default height for walkDrive segment cell
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
    
    mapFrame.origin.x = -10;
    mapFrame.origin.y = -5;
    mapFrame.size.height = [self calculateMapHeight];
    
    //    [self.routeMap setFrame:mapFrame];
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
    
    MKMapRect zoomRect = [mapHelper getSegmentZoomRect:self.walkDriveSegment];
    
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(zoomRect);
    region.span.latitudeDelta *=1.1;
    region.span.longitudeDelta *=1.1;
    
    [cell.mapView setRegion:region];
   
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    cell.backgroundView = view;
    
}

#pragma mark MKMapViewDelegate
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id) overlay// (id <MKOverlay>)overlay
{
    R2RMapHelper *mapHelper = [[R2RMapHelper alloc] init];
	
    return [mapHelper getPolylineView:overlay];
}

- (IBAction)ReturnToSearch:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
