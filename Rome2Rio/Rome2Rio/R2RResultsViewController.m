//
//  R2RResultsViewController.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 6/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "R2RResultsViewController.h"
#import "R2RDetailViewController.h"
#import "R2RTransitSegmentViewController.h"
#import "R2RWalkDriveSegmentViewController.h"

#import "R2RStatusButton.h"
#import "R2RResultSectionHeader.h"
#import "R2RResultsCell.h"

#import "R2RStringFormatter.h"
#import "R2RSegmentHelper.h"
#import "R2RMapHelper.h"
#import "R2RConstants.h"
#import "R2RSprite.h"
#import "R2RAnnotation.h"
#import "R2RPressAnnotationView.h"

@interface R2RResultsViewController ()

@property (strong, nonatomic) R2RResultSectionHeader *header;
@property (strong, nonatomic) R2RStatusButton *statusButton;

@property (strong, nonatomic) R2RAnnotation *pressAnnotation;
@property (nonatomic) CLLocationDegrees zoomLevel;
@property (nonatomic) BOOL isMapZoomedToAnnotation;

@property (nonatomic) bool fromAnnotationDidMove;
@property (nonatomic) bool toAnnotationDidMove;

@end

@implementation R2RResultsViewController

@synthesize searchManager, searchStore;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = NSLocalizedString(@"Results", nil);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTitle:) name:@"refreshTitle" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshResults:) name:@"refreshResults" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshStatusMessage:) name:@"refreshStatusMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSearchMessage:) name:@"refreshSearchMessage" object:nil];
    
    [self.view setBackgroundColor:[R2RConstants getBackgroundColor]];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundColor:[R2RConstants getBackgroundColor]];
    
    [self.tableView setSectionHeaderHeight:37.0];
    CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, self.tableView.sectionHeaderHeight);
    
    self.header = [[R2RResultSectionHeader alloc] initWithFrame:rect];
    
    [self refreshResultsViewTitle];
    
    [self.view setBackgroundColor:[R2RConstants getBackgroundColor]];
    
    self.statusButton = [[R2RStatusButton alloc] initWithFrame:CGRectMake(0.0, (self.view.bounds.size.height- self.navigationController.navigationBar.bounds.size.height-30), self.view.bounds.size.width, 30.0)];
    [self.statusButton addTarget:self action:@selector(statusButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.statusButton];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footer;
    
    [self.view sendSubviewToBack:self.mapView];
    
    // set default to show grabBar in footer
    [self setTableFooterWithGrabBar];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showPressAnnotation:)];
    [self.mapView addGestureRecognizer:longPressGesture];
    
    //    [self configureMap];
    
    //after annotations are initially placed set DidMove to NO so we don't resolve again unless it changes
    self.fromAnnotationDidMove = NO;
    self.toAnnotationDidMove = NO;
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshTitle" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshResults" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshStatusMessage" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshSearchMessage" object:nil];
    
    [self setTableView:nil];
    [self setMapView:nil];
    [self setSearchButton:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //if there is a status message show it otherwise show search message
    if ([self.searchStore.statusMessage length] > 0)
    {
        [self setStatusMessage:self.searchStore.statusMessage];
    }
    else
    {
        [self setStatusMessage:self.searchStore.searchMessage];
        if ([self.searchManager isSearching]) [self.searchManager setSearchMessage:NSLocalizedString(@"Searching", nil)];
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    if ([self.searchManager isSearching]) [self.searchManager setSearchMessage:@""];
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchStore.searchResponse.routes count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[R2RConstants getCellColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    R2RRoute *route = [self.searchStore.searchResponse.routes objectAtIndex:indexPath.row];
    R2RSegmentHelper *segmentHandler  = [[R2RSegmentHelper alloc] init];
    NSString *CellIdentifier = @"ResultsCell";
    
    if ([route.segments count] == 1)
    {
        NSString *kind = [segmentHandler getSegmentKind:[route.segments objectAtIndex:0]];
        if ([kind isEqualToString:@"bus"] || [kind isEqualToString:@"train"] || [kind isEqualToString:@"ferry"])
        {
            CellIdentifier = @"ResultsCellTransit";
        }
        else if ([kind isEqualToString:@"car"] || [kind isEqualToString:@"walk"])
        {
            CellIdentifier = @"ResultsCellWalkDrive";
        }
    }
    
    R2RResultsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [cell.resultDescripionLabel setText:route.name];
    [cell.resultDurationLabel setText:[R2RStringFormatter formatDuration:route.duration]];
    
    NSInteger iconCount = 0;
    float xOffset = 0;
    for (id segment in route.segments)
    {
        if (iconCount >= MAX_ICONS) break;
        
        if ([segmentHandler getSegmentIsMajor:segment])
        {
            UIImageView *iconView = [cell.icons objectAtIndex:iconCount];
            
            if (xOffset == 0)
            {
                xOffset = iconView.frame.origin.x;
            }
            
            R2RSprite *sprite = [segmentHandler getSegmentResultSprite:segment];
            
            CGRect iconFrame = CGRectMake(xOffset, iconView.frame.origin.y, sprite.size.width/2, sprite.size.height/2);
            [iconView setFrame:iconFrame];
            
            [self.searchStore.spriteStore setSpriteInView:sprite :iconView];
            
            xOffset = iconView.frame.origin.x + iconView.frame.size.width + 7; //xPos of next icon
            
            iconCount++;
        }
    }
    
    cell.iconCount = iconCount;
    
    return cell;
}

#pragma mark - Table view delegate

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showRouteDetails"])
    {
        R2RDetailViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.searchManager = self.searchManager;
        detailsViewController.searchStore = self.searchStore;
        detailsViewController.route = [self.searchStore.searchResponse.routes objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
    if ([[segue identifier] isEqualToString:@"showTransitSegment"])
    {
        R2RTransitSegmentViewController *segmentViewController = [segue destinationViewController];
        R2RRoute *route = [self.searchStore.searchResponse.routes objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        segmentViewController.searchManager = self.searchManager;
        segmentViewController.searchStore = self.searchStore;
        segmentViewController.route = route;
        segmentViewController.transitSegment = [route.segments objectAtIndex:0];
    }
    if ([[segue identifier] isEqualToString:@"showWalkDriveSegment"])
    {
        R2RWalkDriveSegmentViewController *segmentViewController = [segue destinationViewController];
        R2RRoute *route = [self.searchStore.searchResponse.routes objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        segmentViewController.searchManager = self.searchManager;
        segmentViewController.searchStore = self.searchStore;
        segmentViewController.route = route;
        segmentViewController.walkDriveSegment = [route.segments objectAtIndex:0];
    }
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
}

//-(void) statusButtonClicked
//{
//    [self.navigationController popViewControllerAnimated:true];
//}

-(void) refreshResultsViewTitle
{
    
    NSString *from;
    if (self.searchStore.fromPlace)
    {
        from = self.searchStore.fromPlace.shortName;
    }
    else
    {
        from = NSLocalizedString(@"finding", nil);
    }
    NSString *to;
    if (self.searchStore.toPlace)
    {
        to = self.searchStore.toPlace.shortName;
    }
    else
    {
        to = NSLocalizedString(@"finding", nil);
    }
    
    NSString *joiner = NSLocalizedString(@" to ", nil);
    CGSize joinerSize = [joiner sizeWithFont:[UIFont systemFontOfSize:17.0]];
    joinerSize.width += 2;
    CGSize fromSize = [from sizeWithFont:[UIFont systemFontOfSize:17.0]];
    CGSize toSize = [to sizeWithFont:[UIFont systemFontOfSize:17.0]];
    
    NSInteger viewWidth = self.view.bounds.size.width;
    NSInteger fromWidth = fromSize.width;
    NSInteger toWidth = toSize.width;
    
    if (fromSize.width+joinerSize.width+toSize.width > viewWidth)
    {
        fromWidth = (fromSize.width/(fromSize.width+toSize.width))*(viewWidth-joinerSize.width);
        toWidth = (toSize.width/(fromSize.width+toSize.width))*(viewWidth-joinerSize.width);
    }
    
    CGRect fromFrame = self.header.fromLabel.frame;
    fromFrame.size.width = fromWidth;
    fromFrame.origin.x = (viewWidth-(fromWidth+joinerSize.width+toWidth))/2;
    [self.header.fromLabel setFrame:fromFrame];
    
    CGRect joinerFrame = self.header.joinerLabel.frame;
    joinerFrame.size.width = joinerSize.width;
    joinerFrame.origin.x = fromFrame.origin.x + fromFrame.size.width;
    [self.header.joinerLabel setFrame:joinerFrame];
    
    CGRect toFrame = self.header.toLabel.frame;
    toFrame.size.width = toWidth;
    toFrame.origin.x = joinerFrame.origin.x + joinerFrame.size.width;
    [self.header.toLabel setFrame:toFrame];
    
    [self.header.fromLabel setText:from];
    [self.header.toLabel setText:to];
    [self.header.joinerLabel setText:joiner];
    
}

-(void) refreshTitle:(NSNotification *) notification
{
    [self refreshResultsViewTitle];
}

-(void) refreshResults:(NSNotification *) notification
{
    //resize table view frame back to max
    CGRect frame = self.tableView.frame;
    frame.size.height = 10088;
    self.tableView.frame = frame;
    
    //remove all map annotaions and overlays
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    
    //reload table. triggers redrawing of map as well
    [self.tableView reloadData];
}

-(void) refreshStatusMessage:(NSNotification *) notification
{
    [self setStatusMessage:self.searchStore.statusMessage];
}

-(void) refreshSearchMessage:(NSNotification *) notification
{
    [self setStatusMessage:self.searchStore.searchMessage];
}

-(void) setStatusMessage: (NSString *) message
{
    [self.statusButton setTitle:message forState:UIControlStateNormal];
}

- (void)showPressAnnotation:(UILongPressGestureRecognizer *)gestureRecognizer
{
    // only allow the changing of to/from on the results after the search has completed
    if (self.searchManager.searchStore.searchResponse == nil) return;
    
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
            self.fromAnnotationDidMove = YES;
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
            [self.mapView viewForAnnotation:annotation].canShowCallout = NO;
            self.toAnnotationDidMove = YES;
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
        if (annotation.annotationType == r2rAnnotationTypeFrom && self.fromAnnotationDidMove)
        {
            //mapscale. Used as horizontal accuracy
            float mapScale = self.mapView.region.span.longitudeDelta*500;
            
            [self.searchManager setFromWithMapLocation:annotation.coordinate mapScale:mapScale];
        }
        if (annotation.annotationType == r2rAnnotationTypeTo && self.toAnnotationDidMove)
        {
            //mapcsale. Used as horizontal accuracy
            float mapScale = self.mapView.region.span.longitudeDelta*500;
            
            [self.searchManager setToWithMapLocation:annotation.coordinate mapScale:mapScale];
        }
    }
    
    self.searchButton.hidden = YES;
    
    //    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

-(void)reloadDataDidFinish
{
    [self configureMap];
    
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
    
    //unique footer configuration for resultsView
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    [footer setBackgroundColor:[R2RConstants getBackgroundColor]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(150, 1, 27, 7)];
    [imageView setImage:[UIImage imageNamed:@"GrabTransparent1"]];
    imageView.userInteractionEnabled = YES;
    imageView.alpha = 0.2;
    
    [footer addSubview:imageView];
    
    self.tableView.tableFooterView = footer;
}

-(void) configureMap
{
    [self.mapView setDelegate:self];
    
    R2RMapHelper *mapHelper = [[R2RMapHelper alloc] initWithData:self.searchStore];
    
    [self setMapRegionDefault];
    
    //return if search is not complete or route not found
    if ([self.searchStore.searchResponse.routes count] == 0)
        return;
    
    R2RRoute *route = [self.searchStore.searchResponse.routes objectAtIndex:0];
    
    NSArray *stopAnnotations = [mapHelper getRouteStopAnnotations:route];
    NSArray *hopAnnotations = [mapHelper getRouteHopAnnotations:route];
    
    hopAnnotations = [mapHelper filterHopAnnotations:hopAnnotations stopAnnotations:stopAnnotations regionSpan:self.mapView.region.span];
    
    for (R2RAnnotation *annotation in stopAnnotations)
    {
        [self.mapView addAnnotation:annotation];
    }
    
    for (R2RAnnotation *annotation in hopAnnotations)
    {
        [self.mapView addAnnotation:annotation];
    }
    
    for (id segment in route.segments)
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
    if ([self.searchStore.searchResponse.routes count] == 0)
    {
        MKCoordinateRegion region = [R2RConstants getStartMapRegion];
        [self.mapView setRegion:region];
        return;
    }
    
    R2RRoute *route = [self.searchStore.searchResponse.routes objectAtIndex:0];
    
    R2RMapHelper *mapHelper = [[R2RMapHelper alloc] initWithData:self.searchStore];
    MKMapRect bounds = MKMapRectNull;
    
    for (id segment in route.segments)
    {
        MKMapRect segmentRect = [mapHelper getSegmentBounds:segment];
        bounds = MKMapRectUnion(bounds, segmentRect);
    }
    
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(bounds);
    
    if (region.span.longitudeDelta > 180) //if span is too large to fit on map just focus on destination
    {
        R2RStop *lastStop = [route.stops lastObject];
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
    
    //    [self.mapView setRegion:region];
    [self.mapView setRegion:region animated:YES];
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
        
        [self.mapView deselectAnnotation:annotationView.annotation animated:NO];
        
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
        R2RAnnotation *annotation = (R2RAnnotation *)view.annotation;
        if (annotation.annotationType == r2rAnnotationTypeFrom)
            self.fromAnnotationDidMove = YES;
        if (annotation.annotationType == r2rAnnotationTypeTo)
            self.toAnnotationDidMove = YES;
        
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
        
        //return if search is not complete or route not found
        if ([self.searchStore.searchResponse.routes count] == 0)
            return;
        
        R2RRoute *route = [self.searchStore.searchResponse.routes objectAtIndex:0];
        
        NSArray *stopAnnotations = [mapHelper getRouteStopAnnotations:route];
        NSArray *hopAnnotations = [mapHelper getRouteHopAnnotations:route];
        
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

@end
