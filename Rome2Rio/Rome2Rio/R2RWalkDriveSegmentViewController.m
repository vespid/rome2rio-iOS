//
//  R2RWalkDriveSegmentViewController.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 30/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "R2RWalkDriveSegmentViewController.h"
#import "R2RStringFormatter.h"
#import "R2RConstants.h"

#import "R2RWalkDriveSegmentCell.h"
#import "R2RSegmentHelper.h"
#import "R2RMapHelper.h"
#import "R2RAnnotation.h"
#import "R2RPressAnnotationView.h"

#import "R2RResultsViewController.h"

@interface R2RWalkDriveSegmentViewController ()

@property (strong, nonatomic) R2RAnnotation *pressAnnotation;
@property CLLocationDegrees zoomLevel;
@property (nonatomic) BOOL isMapZoomedToAnnotation;

@end

@implementation R2RWalkDriveSegmentViewController

@synthesize searchManager, searchStore, route, walkDriveSegment;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = [R2RStringFormatter capitaliseFirstLetter:walkDriveSegment.kind];
    
    [self.view setBackgroundColor:[R2RConstants getBackgroundColor]];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundColor:[R2RConstants getBackgroundColor]];
    
    [self.view sendSubviewToBack:self.mapView];
    
    // set default to show grabBar in footer
    [self setTableFooterWithGrabBar];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showPressAnnotation:)];
    [self.mapView addGestureRecognizer:longPressGesture];
    
    [self configureMap];
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
    
    R2RSegmentHelper *segmentHandler = [[R2RSegmentHelper alloc] init];
    
    R2RSprite *sprite = [segmentHandler getRouteSprite:self.walkDriveSegment.kind];
    [self.searchStore.spriteStore setSpriteInView:sprite :cell.kindIcon];
    
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
    
    [cell.distanceLabel setText:[R2RStringFormatter formatDistance:self.walkDriveSegment.distance]];
    [cell.durationLabel setText:[R2RStringFormatter formatDuration:self.walkDriveSegment.duration]];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;//default height for walkDrive segment cell
}

-(void)reloadDataDidFinish
{
    [self setMapFrame];
    
    //adjust table to correct size
    [self.tableView sizeToFit];
    
    //draw table shadow
    self.tableView.layer.shadowOffset = CGSizeMake(0,5);
    self.tableView.layer.shadowRadius = 5;
    self.tableView.layer.shadowOpacity = 0.5;
    self.tableView.layer.masksToBounds = NO;
    self.tableView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.tableView.bounds].CGPath;
    
    // adjust scrollview content size
    CGSize scrollviewSize = self.view.frame.size;
    scrollviewSize.height = self.tableView.frame.size.height + self.mapView.frame.size.height;
    UIScrollView *tempScrollView=(UIScrollView *)self.view;
    tempScrollView.contentSize=scrollviewSize;
}

-(void) setMapFrame
{
    //get the frame of the table section
    CGRect sectionFrame = [self.tableView rectForSection:0];
    
    CGRect viewFrame = self.view.frame;
    CGRect mapFrame = self.mapView.frame;
    
    if (sectionFrame.size.height < (viewFrame.size.height/3))
    {
        //set map to fill remaining screen space
        int height = (viewFrame.size.height - sectionFrame.size.height);
        mapFrame.size.height = height;
        
        //set the table footer to 0
        UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
        self.tableView.tableFooterView = footer;
        
        //set map position to below section
        mapFrame.origin.y = sectionFrame.size.height;
    }
    else
    {
        //set map to default height
        mapFrame.size.height = viewFrame.size.height*2/3;
        
        //set table footer
        [self setTableFooterWithGrabBar];
        
        //set map position to below footer
        mapFrame.origin.y = sectionFrame.size.height + self.tableView.tableFooterView.frame.size.height;
    }
    
    //set map frame to new size and position
    [self.mapView setFrame:mapFrame];
}

-(void) setTableFooterWithGrabBar
{
    if (self.tableView.tableFooterView.frame.size.height != 0) return;
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 17)];
    [footer setBackgroundColor:[R2RConstants getExpandedCellColor]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(150, 5, 27, 7)];
    [imageView setImage:[UIImage imageNamed:@"GrabTransparent1"]];
    imageView.userInteractionEnabled = YES;
    imageView.alpha = 0.6;
    
    [footer addSubview:imageView];
    
    self.tableView.tableFooterView = footer;
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
    MKMapRect bounds = [mapHelper getSegmentBounds:self.walkDriveSegment];
    
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
        [self showSearchButton];
        view.canShowCallout = NO;
        if (newState == MKAnnotationViewDragStateEnding)
        {
            [self.mapView deselectAnnotation:view.annotation animated:YES];
        }
    }
}

-(void) showSearchButton
{
    CGRect buttonFrame = self.searchButton.frame;
    
    buttonFrame.origin.y = self.mapView.frame.origin.y + self.mapView.frame.size.height - 70;
    [self.searchButton setFrame:buttonFrame];
    self.searchButton.hidden = NO;
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
            [self.mapView removeAnnotation:self.pressAnnotation];
            self.pressAnnotation = nil;
            [self showSearchButton];
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
            [self.mapView removeAnnotation:self.pressAnnotation];
            self.pressAnnotation = nil;
            [self showSearchButton];
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

@end