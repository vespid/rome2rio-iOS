//
//  R2RTransitSegmentViewController.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 29/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "R2RTransitSegmentViewController.h"
#import "R2RStringFormatter.h"
#import "R2RConstants.h"

#import "R2RTransitSegmentHeader.h"
#import "R2RTransitSegmentCell.h"
#import "R2RSegmentHelper.h"
#import "R2RMapHelper.h"
#import "R2RAnnotation.h"
#import "R2RPressAnnotationView.h"

@interface R2RTransitSegmentViewController ()

@property (strong, nonatomic) R2RAnnotation *pressAnnotation;
@property (strong, nonatomic) NSMutableArray *legs;
@property CLLocationDegrees zoomLevel;
@property (nonatomic) BOOL isMapZoomedToAnnotation;

@end

@implementation R2RTransitSegmentViewController

@synthesize searchManager, searchStore, route, transitSegment;

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
    
    NSString *navigationTitle = [R2RStringFormatter capitaliseFirstLetter:transitSegment.kind];
    self.navigationItem.title = navigationTitle;
    
    self.legs = [NSMutableArray array];
    [self sortLegs];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showPressAnnotation:)];
    [self.mapView addGestureRecognizer:longPressGesture];
    
    [self configureMap];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.searchButton.hidden = YES;
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setMapView:nil];
    [self setSearchButton:nil];
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, 35);
    
    R2RTransitSegmentHeader *header = [[R2RTransitSegmentHeader alloc] initWithFrame:rect];
    
    if ([self.transitSegment.itineraries count] == 0)
    {
        return header;
    }
    
    R2RTransitLeg *transitLeg = [self.legs objectAtIndex:section];
    R2RTransitHop *transitHop = [transitLeg.hops objectAtIndex:0];
    
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
    
    R2RAgency *agency  = [self.searchStore getAgency:transitLine.agency];
    
    NSString *agencyName = agency.name;
    if ([agencyName length] == 0)
    {
        agencyName = [R2RStringFormatter capitaliseFirstLetter:transitLine.vehicle];
    }
    
    if ([agency.iconPath length] == 0)
    {
        //allow for smaller icon
        iconSize = CGSizeMake(18, 18);
        iconPadding = 9;
        startX = 19;
        rect = CGRectMake(startX, 11, iconSize.width, iconSize.height);
        
        [header.agencyIconView setFrame:rect];
        R2RSegmentHelper *segmentHandler = [[R2RSegmentHelper alloc] init];
        
        R2RSprite *sprite = [segmentHandler getRouteSprite:transitSegment.kind];
        [self.searchStore.spriteStore setSpriteInView:sprite :header.agencyIconView];
    }
    else
    {
        R2RSprite *sprite = [[R2RSprite alloc] initWithPath:agency.iconPath :agency.iconOffset :agency.iconSize];
        [self.searchStore.spriteStore setSpriteInView:sprite :header.agencyIconView];
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
                tName = [NSString stringWithFormat:@"%@ (%@)", stop.name, stop.code];
            }
        }
    }
    
    [cell.fromLabel setText:sName];
    [cell.toLabel setText:tName];
    
    NSString *duration = [R2RStringFormatter formatDuration:transitHop.duration];
    NSString *frequency = [R2RStringFormatter formatFrequency:transitHop.frequency];
    NSString *description = [NSString stringWithFormat:@"%@, %@", duration, frequency];
    CGSize durationSize = [description sizeWithFont:[UIFont systemFontOfSize:17.0]];
    
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
        rect = CGRectMake(20, 80, cell.toLabel.frame.size.width, 25);
        [cell.toLabel setFrame:rect];
    }
    else
    {
        [cell.lineLabel setHidden:YES];
        rect = CGRectMake(20, 55, cell.toLabel.frame.size.width, 25);
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
            if ([transitHop.lines count] == 0) continue;
            
            R2RTransitLine *hopLine = [transitHop.lines objectAtIndex:0];
            
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
    
    R2RMapHelper *mapHelper = [[R2RMapHelper alloc] initWithData:self.searchStore];
    
    NSArray *stopAnnotations = [mapHelper getRouteStopAnnotations:self.route];
    NSArray *hopAnnotations = [mapHelper getRouteHopAnnotations:self.route];
    
    hopAnnotations = [mapHelper filterHopAnnotations:hopAnnotations stopAnnotations:stopAnnotations regionSpan:self.mapView.region.span];
    
    for (R2RAnnotation *annotation in stopAnnotations)
    {
        [self.mapView addAnnotation:annotation];
    }
    
    for (R2RAnnotation *annotation in hopAnnotations)
    {
        [self.mapView addAnnotation:annotation];
    }
    
    for (id segment in self.route.segments)
    {
        NSArray *paths = [mapHelper getPolylines:segment];
        for (id path in paths)
        {
            [self.mapView addOverlay:path];
        }
    }
    
    [self setMapRegionDefault];
}

- (void)setMapRegionDefault
{
    R2RMapHelper *mapHelper = [[R2RMapHelper alloc] init];
    MKMapRect bounds = [mapHelper getSegmentBounds:self.transitSegment];
    
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(bounds);
    region.span.latitudeDelta *= 1.1;
    region.span.longitudeDelta *= 1.1;
    
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
	
    R2RAnnotation *r2rAnnotation = (R2RAnnotation *)annotation;
    
    MKAnnotationView *annotationView = [mapHelper getAnnotationView:mapView annotation:r2rAnnotation];
    
    if (r2rAnnotation.annotationType == r2rAnnotationTypePress)
    {
        R2RPressAnnotationView *pressAnnotationView = (R2RPressAnnotationView *)annotationView;
        [pressAnnotationView.fromButton addTarget:self
                                           action:@selector(setFromLocation:)
                                 forControlEvents:UIControlEventTouchUpInside];
        
        [pressAnnotationView.toButton addTarget:self
                                         action:@selector(setToLocation:)
                               forControlEvents:UIControlEventTouchUpInside];
        
        return pressAnnotationView;
    }
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView calloutAccessoryControlTapped:(UIControl *)control
{
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

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    //hide press annotation when not selected
    if (view.annotation == self.pressAnnotation)
    {
        [self.mapView removeAnnotation:self.pressAnnotation];
        self.pressAnnotation = nil;
    }
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    if (view.annotation != self.pressAnnotation)
    {
        self.searchButton.hidden = NO;
        view.canShowCallout = NO;
        if (newState == MKAnnotationViewDragStateEnding)
        {
            [self.mapView deselectAnnotation:view.annotation animated:YES];
        }
    }
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    self.isMapZoomedToAnnotation = NO;
    if (self.zoomLevel!=mapView.region.span.longitudeDelta)
    {
        R2RMapHelper *mapHelper = [[R2RMapHelper alloc] initWithData:self.searchStore];
        
        NSArray *stopAnnotations = [mapHelper getRouteStopAnnotations:self.route];
        NSArray *hopAnnotations = [mapHelper getRouteHopAnnotations:self.route];
        
        hopAnnotations = [mapHelper filterHopAnnotations:hopAnnotations stopAnnotations:stopAnnotations regionSpan:self.mapView.region.span];
        
        //just get existing hopAnnotations
        NSMutableArray *existingHopAnnotations = [[NSMutableArray alloc] init];
        
        for (R2RAnnotation *annotation in mapView.annotations)
        {
            if (annotation.annotationType == r2rAnnotationTypeHop)
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

- (void)showPressAnnotation:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    if (!self.pressAnnotation)
    {
        self.pressAnnotation = [[R2RAnnotation alloc] initWithName:@"Press" kind:nil coordinate:touchMapCoordinate annotationType:r2rAnnotationTypePress];
        [self.mapView addAnnotation:self.pressAnnotation];
    }
    else
    {
        [self.pressAnnotation setCoordinate:touchMapCoordinate];
    }
    [self.mapView selectAnnotation:self.pressAnnotation animated:YES];
}

-(void) setFromLocation:(id) sender
{
    for (R2RAnnotation *annotation in self.mapView.annotations)
    {
        if (annotation.annotationType == r2rAnnotationTypeFrom)
        {
            [annotation setCoordinate:self.pressAnnotation.coordinate];
            [self.mapView viewForAnnotation:annotation].canShowCallout = NO;
            [self.mapView removeAnnotation:self.pressAnnotation];
            self.pressAnnotation = nil;
            self.searchButton.hidden = NO;
            break;
        }
    }
}

-(void) setToLocation:(id) sender
{
    for (R2RAnnotation *annotation in self.mapView.annotations)
    {
        if (annotation.annotationType == r2rAnnotationTypeTo)
        {
            [annotation setCoordinate:self.pressAnnotation.coordinate];
            [self.mapView viewForAnnotation:annotation].canShowCallout = NO;
            [self.mapView removeAnnotation:self.pressAnnotation];
            self.pressAnnotation = nil;
            self.searchButton.hidden = NO;
            break;
        }
    }
}

- (IBAction)returnToSearch:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)resolveLocation:(id)sender
{
    for (R2RAnnotation *annotation in self.mapView.annotations)
    {
        if (annotation.annotationType == r2rAnnotationTypeFrom)
        {
            //mapcale. Used as horizontal accuracy
            float mapScale = self.mapView.region.span.longitudeDelta*500;
            
            [self.searchManager setFromWithMapLocation:annotation.coordinate mapScale:mapScale];
        }
        if (annotation.annotationType == r2rAnnotationTypeTo)
        {
            //mapcale. Used as horizontal accuracy
            float mapScale = self.mapView.region.span.longitudeDelta*500;
            
            [self.searchManager setToWithMapLocation:annotation.coordinate mapScale:mapScale];
        }
    }

    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
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
