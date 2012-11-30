//
//  R2RMapViewController.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 21/11/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RMapViewController.h"
#import "R2RAnnotation.h"
#import "R2RStatusButton.h"
#import "R2RMapHelper.h"

#import "R2RPressAnnotationView.h"

@interface R2RMapViewController ()

@property (strong, nonatomic) R2RStatusButton *statusButton;

@property (strong, nonatomic) R2RAnnotation *fromAnnotation;
@property (strong, nonatomic) R2RAnnotation *toAnnotation;
@property (strong, nonatomic) R2RAnnotation *pressAnnotation;

@end

@implementation R2RMapViewController

@synthesize searchManager, fieldName, mapView = _mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.statusButton = [[R2RStatusButton alloc] initWithFrame:CGRectMake(0.0, (self.view.bounds.size.height- self.navigationController.navigationBar.bounds.size.height-30), self.view.bounds.size.width, 30.0)];
    [self.statusButton addTarget:self action:@selector(statusButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.statusButton];
    
//    //temp area for Melbourne zoom
//    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(-37.816022 ,144.96151);
//    MKCoordinateSpan span = MKCoordinateSpanMake(0.2, 0.2);
//    MKCoordinateRegion region = MKCoordinateRegionMake(coord, span);

    MKCoordinateRegion region = MKCoordinateRegionForMapRect(MKMapRectWorld);
    
    if ([self.fieldName isEqualToString:@"to"] && self.searchManager.searchStore.fromPlace)
    {
        CLLocationCoordinate2D fromCoord = CLLocationCoordinate2DMake(self.searchManager.searchStore.fromPlace.lat , self.searchManager.searchStore.fromPlace.lng);
        [self setFromLocation:fromCoord];
        region = MKCoordinateRegionMakeWithDistance(fromCoord , 50000, 50000);
    }
        
    [self.mapView setRegion:region];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setAnnotationForTap:)];
    [self.mapView addGestureRecognizer:tapGesture];
    tapGesture.delegate = self;
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showPressAnnotation:)];
    [self.mapView addGestureRecognizer:longPressGesture];
    longPressGesture.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [super viewDidUnload];
}

- (IBAction)resolveLocation:(id)sender
{
    //if no location is currently selected display instructions
    if ([self.fieldName isEqualToString:@"from"] && !self.fromAnnotation)
    {
        [self.statusButton setTitle:@"Select origin" forState:UIControlStateNormal];
        return;
    }
    else if ([self.fieldName isEqualToString:@"to"] && !self.toAnnotation)
    {
        [self.statusButton setTitle:@"Select destination" forState:UIControlStateNormal];
        return;
    }
    
    if (self.fromAnnotation)
    {
        //mapcale. Used as horizontal accuracy
        float mapScale = self.mapView.region.span.longitudeDelta*500;

        [self.searchManager setFromWithMapLocation:self.fromAnnotation.coordinate mapScale:mapScale];
    }
    
    if (self.toAnnotation)
    {
        //mapcale. Used as horizontal accuracy
        float mapScale = self.mapView.region.span.longitudeDelta*500;
        
        [self.searchManager setToWithMapLocation:self.toAnnotation.coordinate mapScale:mapScale];
    }

    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)returnToSearch:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)showPressAnnotation:(UILongPressGestureRecognizer *)gestureRecognizer
{
    [self.statusButton setTitle:nil forState:UIControlStateNormal];
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];

    if (!self.pressAnnotation)
    {
        self.pressAnnotation = [[R2RAnnotation alloc] initWithName:@" " kind:nil coordinate:touchMapCoordinate annotationType:r2rAnnotationTypePress];
        [self.mapView addAnnotation:self.pressAnnotation];
    }
    else
    {
        [self.pressAnnotation setCoordinate:touchMapCoordinate];
    }
    
    [self.mapView selectAnnotation:self.pressAnnotation animated:YES];
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
        if (newState == MKAnnotationViewDragStateEnding)
        {
            [self.mapView deselectAnnotation:view.annotation animated:YES];
        }
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    R2RMapHelper *mapHelper = [[R2RMapHelper alloc] init];
	
    R2RAnnotation *r2rAnnotation = (R2RAnnotation *)annotation;
    
    MKAnnotationView *annotationView = [mapHelper getAnnotationView:mapView annotation:r2rAnnotation];
    
    if (r2rAnnotation.annotationType == r2rAnnotationTypePress)
    {
        R2RPressAnnotationView *pressAnnotationView = (R2RPressAnnotationView *)annotationView;
        [pressAnnotationView.fromButton addTarget:self
                                         action:@selector(setFromLocationFromLongPress:)
                               forControlEvents:UIControlEventTouchUpInside];
        
        [pressAnnotationView.toButton addTarget:self
                                       action:@selector(setToLocationFromLongPress:)
                             forControlEvents:UIControlEventTouchUpInside];
        
        return pressAnnotationView;
    }
    
    //this makes the annotations draggable without a title
    annotationView.canShowCallout = NO;
    
    return annotationView;
}

- (void)setAnnotationForTap :(UITapGestureRecognizer *)gestureRecognizer
{
    if (self.pressAnnotation)
    {
        [self.mapView deselectAnnotation:self.pressAnnotation animated:YES];
    }
    
    [self.statusButton setTitle:nil forState:UIControlStateNormal];
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    if ([self.fieldName isEqualToString:@"from"])
    {
        [self setFromLocation:touchMapCoordinate];
    }
    if ([self.fieldName isEqualToString:@"to"])
    {
        [self setToLocation:touchMapCoordinate];
    }
}

-(void) setFromLocationFromLongPress:(id) sender
{
    [self setFromLocation:self.pressAnnotation.coordinate];
    
    [self.mapView removeAnnotation:self.pressAnnotation];
    self.pressAnnotation = nil;
}

-(void) setToLocationFromLongPress:(id) sender
{
    [self setToLocation:self.pressAnnotation.coordinate];
    
    [self.mapView removeAnnotation:self.pressAnnotation];
    self.pressAnnotation = nil;
}

-(void) setFromLocation:(CLLocationCoordinate2D) coord
{
    if (!self.fromAnnotation)
    {
        //TODO maybe add a name here so magnifying glass is shown and then set it to zoom to different levels
        self.fromAnnotation = [[R2RAnnotation alloc] initWithName:nil kind:nil coordinate:coord annotationType:r2rAnnotationTypeFrom];
        [self.mapView addAnnotation:self.fromAnnotation];
    }
    else
    {
        [self.fromAnnotation setCoordinate:coord];
    }
}

-(void) setToLocation:(CLLocationCoordinate2D) coord
{
    if (!self.toAnnotation)
    {
        self.toAnnotation = [[R2RAnnotation alloc] initWithName:nil kind:nil coordinate:coord annotationType:r2rAnnotationTypeTo];
        [self.mapView addAnnotation:self.toAnnotation];
    }
    else
    {
        [self.toAnnotation setCoordinate:coord];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return ![touch.view isKindOfClass:[UIButton class]];
}

@end
