//
//  R2RTransitSegmentViewController.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 14/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "R2RTransitSegmentViewController.h"
#import "R2RTransitSegmentCell.h"
#import "R2RTitleLabel.h"
#import "R2RTransitSegmentHeader.h"
#import "R2RAgency.h"

#import "R2RStringFormatters.h"
#import "R2RSegmentHandler.h"
#import "R2RButtonWithUrl.h"
#import "R2RTransitLine.h"
#import "R2RMapCell.h"
#import "R2RMKAnnotation.h"
#import "R2RMapHelper.h"

@interface R2RTransitSegmentViewController ()

@property (strong, nonatomic) NSMutableArray *legs;

@end

@implementation R2RTransitSegmentViewController

@synthesize dataController, route, transitSegment;

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
    
    [self.tableView setBackgroundColor:[UIColor colorWithRed:234.0/256.0 green:228.0/256.0 blue:224.0/256.0 alpha:1.0]];
    
//    [self.tableView setSectionFooterHeight:10.0];
//    [self.tableView setSectionHeaderHeight:40];
//    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footer;
    
    R2RStringFormatters *stringFormatter = [[R2RStringFormatters alloc] init];
    NSString *navigationTitle = [stringFormatter capitaliseFirstLetter:transitSegment.kind];
    self.navigationItem.title = navigationTitle;
    
    self.legs = [NSMutableArray array];
    [self sortLegs];
    
    
    CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, 30);
    UIView *view = [[UIView alloc] initWithFrame:rect];
//    [view setBackgroundColor:[UIColor colorWithRed:234.0/256.0 green:228.0/256.0 blue:224.0/256.0 alpha:1.0]];
    [view setBackgroundColor:[UIColor purpleColor]];
    view.layer.shadowOffset = CGSizeMake(0,5);
    view.layer.shadowRadius = 5;
    view.layer.shadowOpacity = 0.5;
    
    [self.view.superview addSubview:view];

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

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == [self.legs count])
    {
//        CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, 30);
//        UIView *view = [[UIView alloc] initWithFrame:rect];
//        [view setBackgroundColor:[UIColor colorWithRed:234.0/256.0 green:228.0/256.0 blue:224.0/256.0 alpha:1.0]];
//        //        [view setBackgroundColor:[UIColor purpleColor]];
//        view.layer.shadowOffset = CGSizeMake(0,5);
//        view.layer.shadowRadius = 5;
//        view.layer.shadowOpacity = 0.5;
//        
//        return view;
        return nil;
    }
    CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, 35);
    
    R2RTransitSegmentHeader *header = [[R2RTransitSegmentHeader alloc] initWithFrame:rect];
    
    if ([self.transitSegment.itineraries count] == 0)
    {
        // if no itinerary return blank header
        return header;
    }
    
//    R2RTransitItinerary *transitItinerary = [self.transitSegment.itineraries objectAtIndex:0];
//    R2RTransitLeg *transitLeg = [transitItinerary.legs objectAtIndex:section];
    
    R2RTransitLeg *transitLeg = [self.legs objectAtIndex:section];
    R2RTransitHop *transitHop = [transitLeg.hops objectAtIndex:0];
    
//    [header.agencyIconView addTarget:self action:@selector(agencyClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [header.agencyNameLabel addTarget:self action:@selector(agencyClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [header.agencyIconView setUrl:transitLeg.url];
//    [header.agencyNameLabel setUrl:transitLeg.url];

    NSString *agencyName = nil;
    
//    for (R2RTransitLine *line in transitHop.lines)
//    just using first agency (most frequent) for now
    R2RTransitLine *transitLine = nil;
    if ([transitHop.lines count] > 0)
    {
        transitLine = [transitHop.lines objectAtIndex:0];
    }
    else
    {
        transitLine = [[R2RTransitLine alloc] init];
    }
        
    CGSize iconSize = CGSizeMake(27, 23);
    NSInteger iconPadding = 5;
    NSInteger startX = 15;// (header.bounds.size.width-(agencyNameLabelSize.width + iconSize.width + iconPadding))/2;
    
    rect = CGRectMake(startX, 9, iconSize.width, iconSize.height);
    [header.agencyIconView setFrame:rect];
//    UIImage *agencyIcon = nil;
    
    for (R2RAgency *agency in self.dataController.search.searchResponse.agencies)
    {
        if ([agency.code isEqualToString:transitLine.agency])
        {
            agencyName = agency.name;
            if ([agency.iconPath length] == 0)
            {
                //allow for smaller icon
                iconSize = CGSizeMake(18, 18);
                iconPadding = 9;
                startX = 19;
                rect = CGRectMake(startX, 11, iconSize.width, iconSize.height);
                
                [header.agencyIconView setFrame:rect];
                R2RSegmentHandler *segmentHandler = [[R2RSegmentHandler alloc] init];
                
                R2RSprite *sprite = [segmentHandler getRouteSprite:transitSegment.kind];
                [self.dataController.spriteStore setSpriteInView:sprite :header.agencyIconView];
//                [self.dataController.spriteStore setSpriteInButton:sprite : header.agencyIconView];
            }
            else
            {
                R2RSprite *sprite = [[R2RSprite alloc] initWithPath:agency.iconPath :agency.iconOffset :agency.iconSize];
                [self.dataController.spriteStore setSpriteInView:sprite : header.agencyIconView];
//                [self.dataController.spriteStore setSpriteInButton:sprite : header.agencyIconView];
            }
        }
    }

    if ([agencyName length] == 0)
    {
        R2RStringFormatters *formatter = [[R2RStringFormatters alloc] init];
        agencyName = [formatter capitaliseFirstLetter:transitLine.vehicle];
    }
    
//    CGSize agencyNameLabelSize = [agencyName sizeWithFont:[UIFont systemFontOfSize:17.0]];
    
    rect = CGRectMake(startX + iconSize.width + iconPadding, 8, 280-(startX + iconSize.width + iconPadding), 25);
    
    [header.agencyNameLabel setFrame:rect];
    [header.agencyNameLabel setText:agencyName];
    
    [header.linkButton setImage:[UIImage imageNamed:@"externalLinkIconGray"] forState:UIControlStateNormal];
    [header.linkButton addTarget:self action:@selector(showLinkMenu) forControlEvents:UIControlEventTouchUpInside];
        
    return header;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return ([self.legs count] + 1);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == [self.legs count])//map cell
    {
        return 1;
    }
    
    // Return the number of rows in the section.
    
    if ([self.transitSegment.itineraries count] == 0) return 0;
    
    R2RTransitLeg *transitLeg = [self.legs objectAtIndex:section];
    
    return [transitLeg.hops count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == [self.legs count])//map cell
    {
        NSString *CellIdentifier = @"MapCell";
        R2RMapCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [self configureMapCell:cell];
        return cell;
    }
    
    static NSString *CellIdentifier = @"TransitSegmentCell";	
    R2RTransitSegmentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ([self.transitSegment.itineraries count] == 0)
    {
        // if no itinerary return blank cell
        return cell; 
    }
    
    R2RTransitLeg *transitLeg = [self.legs objectAtIndex:indexPath.section];
    R2RTransitHop *transitHop = [transitLeg.hops objectAtIndex:indexPath.row];
    
    R2RStringFormatters *stringFormatter = [[R2RStringFormatters alloc] init];
    
    NSString *sName = transitHop.sName;
    NSString *tName = transitHop.tName;
    
    for (R2RStop *stop in self.route.stops)
    {
        if ([transitHop.sName isEqualToString:stop.name])
        {
            if ( [stop.kind isEqualToString:@"airport"])
            {
                sName = [NSString stringWithFormat:@"%@ (%@)", stop.name, stop.code];
            }
        }
        if ([transitHop.tName isEqualToString:stop.name])
        {
            if ( [stop.kind isEqualToString:@"airport"])
            {
                [cell.toLabel setText:[NSString stringWithFormat:@"%@ (%@)", stop.name, stop.code]];
            }
        }
    }
    
    [cell.fromLabel setText:sName];
    [cell.toLabel setText:tName];
    
    NSString *duration = [stringFormatter formatDuration:transitHop.duration];
    NSString *frequency = [stringFormatter formatFrequency:transitHop.frequency];
    NSString *description = [NSString stringWithFormat:@"%@, %@", duration, frequency];
    CGSize durationSize = [description sizeWithFont:[UIFont fontWithName:@"Helvetica" size:17.0]];
    
    NSInteger startX = 40;
    
    CGRect rect = CGRectMake(startX, 30, durationSize.width, 25);
    [cell.durationLabel setFrame:rect];
    [cell.durationLabel setText:description];
   
    NSMutableString *lineLabel = [[NSMutableString alloc] init];
    
    for (R2RTransitLine *line in transitHop.lines)
    {
        if ([line.name length] > 0)
        {
            [lineLabel appendString:line.name];
            if (line != [transitHop.lines lastObject])
            {
                [lineLabel appendString:@", "];
            }
        }
    }
    
    if ([lineLabel length] > 0)
    {
        [cell.lineLabel setHidden:NO];
        NSString *line = [NSString stringWithFormat:@"Line: %@", lineLabel];
        [cell.lineLabel setText:line];
        rect = CGRectMake(20, 80, cell.toLabel.bounds.size.width, 25);
        [cell.toLabel setFrame:rect];
    }
    else
    {
        [cell.lineLabel setHidden:YES];
        rect = CGRectMake(20, 55, cell.toLabel.bounds.size.width, 25);
        [cell.toLabel setFrame:rect];
    }
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == [self.legs count])
    {
        return 1;
    }
    
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == [self.legs count])
    {
        return 1;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == [self.legs count])
    {
        return [self calculateMapHeight];//-61;//make cell smaller so map covers header and footer areas
    }
    
    R2RTransitLeg *transitLeg = [self.legs objectAtIndex:indexPath.section];
    R2RTransitHop *transitHop = [transitLeg.hops objectAtIndex:indexPath.row];
    
    NSMutableString *lineLabel = [[NSMutableString alloc] init];
    
    for (R2RTransitLine *line in transitHop.lines)
    {
        [lineLabel appendString:line.name];
    }
    
    if ([lineLabel length] == 0)
    {
        return 85;
    }
    else
    {
        return 115;
    }
}

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

-(void) sortLegs
{
    R2RTransitItinerary *transitItinerary = [self.transitSegment.itineraries objectAtIndex:0];
    
    NSInteger count = 0;
//    R2RTransitHop *prevHop = nil;
    
    R2RTransitLine *prevHopLine = nil;   
    
    for (R2RTransitLeg *transitLeg in transitItinerary.legs)
    {
        for (R2RTransitHop *transitHop in transitLeg.hops)
        {
            R2RTransitLine *hopLine = nil;
            
            if ([transitHop.lines count] > 0)
            {
                hopLine = [transitHop.lines objectAtIndex:0];
            }
            else
            {
                 continue;
            }
            
            if (![hopLine.agency isEqualToString:prevHopLine.agency])
            {
                R2RTransitLeg *newLeg = [[R2RTransitLeg alloc] init];
                newLeg.host = transitLeg.host;
                newLeg.url = transitLeg.url;
                
                newLeg.hops = [NSMutableArray array];
                [newLeg.hops addObject:transitHop];
                
                [self.legs addObject:newLeg];
                
                prevHopLine = hopLine;
                
                count++;
            }
            else
            {
                R2RTransitLeg *currentLeg = [self.legs objectAtIndex:count-1];
                [currentLeg.hops addObject:transitHop];
            }
            
        }
    }
}


-(float) calculateMapHeight
{
    CGRect viewRect = self.view.bounds;
    return viewRect.size.height*2/3;
}

-(void) configureMapCell:(R2RMapCell *) cell
{
    [cell.mapView setDelegate:self];
    
    CGRect mapFrame = cell.mapView.frame;
    
    mapFrame.origin.x = -10;
    mapFrame.origin.y = 0;//-30; //to cover header area
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
    
    MKMapRect zoomRect = [mapHelper getSegmentZoomRect:self.transitSegment];
    
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

//-(void)agencyClicked
//{
//    [self.view setBackgroundColor:[UIColor yellowColor]];
//}

-(void)agencyClicked:(R2RButtonWithUrl *) agencyButton
{
    NSString *urlString = [agencyButton.url absoluteString];
    if ([urlString length] > 0)
    {
        [[UIApplication sharedApplication] openURL:agencyButton.url];
    }
//    NSLog(@"%@", agencyButton);
}

- (IBAction)ReturnToSearch:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) showLinkMenu
{
    UIActionSheet *linkMenuSheet = [[UIActionSheet alloc] initWithTitle:@"Schedules"
                                                     delegate:self
                                            cancelButtonTitle:nil
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:nil];
    
    for (R2RTransitLeg *leg in self.legs)
    {
        [linkMenuSheet addButtonWithTitle:leg.host];
    }
    
    [linkMenuSheet addButtonWithTitle:@"cancel"];
    [linkMenuSheet setCancelButtonIndex:[self.legs count]];

    [linkMenuSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [self.legs count])
        return;
    
    R2RLog(@"Button %d", buttonIndex);
    
    R2RTransitLeg *leg = [self.legs objectAtIndex:buttonIndex];
    if ([[leg.url absoluteString] length] > 0)
    {
        [[UIApplication sharedApplication] openURL:leg.url];
    }
}

@end
