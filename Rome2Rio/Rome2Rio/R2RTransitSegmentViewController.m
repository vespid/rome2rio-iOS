//
//  R2RTransitSegmentViewController.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 29/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "R2RTransitSegmentViewController.h"
#import "R2RStringFormatters.h"
#import "R2RConstants.h"

#import "R2RTransitSegmentHeader.h"
#import "R2RTransitSegmentCell.h"
#import "R2RSegmentHandler.h"
#import "R2RMapHelper.h"
#import "R2RMKAnnotation.h"

@interface R2RTransitSegmentViewController ()

@property (strong, nonatomic) NSMutableArray *legs;

@end

@implementation R2RTransitSegmentViewController

@synthesize dataController, route, transitSegment;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
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
    
    R2RStringFormatters *stringFormatter = [[R2RStringFormatters alloc] init];
    NSString *navigationTitle = [stringFormatter capitaliseFirstLetter:transitSegment.kind];
    self.navigationItem.title = navigationTitle;
    
    self.legs = [NSMutableArray array];
    [self sortLegs];
    
    [self configureMap];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setMapView:nil];
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, 35);
    
    R2RTransitSegmentHeader *header = [[R2RTransitSegmentHeader alloc] initWithFrame:rect];
    
    if ([self.transitSegment.itineraries count] == 0)
    {
        return header;
    }
    
    R2RTransitLeg *transitLeg = [self.legs objectAtIndex:section];
    R2RTransitHop *transitHop = [transitLeg.hops objectAtIndex:0];
    
    NSString *agencyName = nil;

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
    NSInteger startX = 15;
    
    rect = CGRectMake(startX, 9, iconSize.width, iconSize.height);
    [header.agencyIconView setFrame:rect];
    
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
            }
            else
            {
                R2RSprite *sprite = [[R2RSprite alloc] initWithPath:agency.iconPath :agency.iconOffset :agency.iconSize];
                [self.dataController.spriteStore setSpriteInView:sprite : header.agencyIconView];
            }
        }
    }
    
    if ([agencyName length] == 0)
    {
        R2RStringFormatters *formatter = [[R2RStringFormatters alloc] init];
        agencyName = [formatter capitaliseFirstLetter:transitLine.vehicle];
    }
    
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

    return ([self.legs count]);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if ([self.transitSegment.itineraries count] == 0) return 0;
    
    R2RTransitLeg *transitLeg = [self.legs objectAtIndex:section];
    
    return [transitLeg.hops count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TransitSegmentCell";
    R2RTransitSegmentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
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
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

-(void) sortLegs
{
    R2RTransitItinerary *transitItinerary = [self.transitSegment.itineraries objectAtIndex:0];
    
    NSInteger count = 0;
    
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
    
    for (id segment in self.route.segments)
    {
        NSArray *paths = [mapHelper getPolylines:segment];
        for (id path in paths)
        {
            [self.mapView addOverlay:path];
        }
    }
    
    MKMapRect zoomRect = [mapHelper getSegmentZoomRect:self.transitSegment];
    
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
