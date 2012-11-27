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
    
    [self.mapView setRegion:MKCoordinateRegionForMapRect(MKMapRectWorld)];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showPressAnnotation:)];
    [self.mapView addGestureRecognizer:longPressGesture];
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
    if (!self.fromAnnotation && !self.toAnnotation)
    {
        [self.statusButton setTitle:@"Press and hold to select location" forState:UIControlStateNormal];
        return;
    }
    
    if (self.fromAnnotation)
    {
        [self.searchManager setFromWithMapLocation:self.fromAnnotation.coordinate]; 
    }
    
    if (self.toAnnotation)
    {
        [self.searchManager setToWithMapLocation:self.toAnnotation.coordinate];
    }

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
                                         action:@selector(setFromLocation:)
                               forControlEvents:UIControlEventTouchUpInside];
        
        [pressAnnotationView.toButton addTarget:self
                                       action:@selector(setToLocation:)
                             forControlEvents:UIControlEventTouchUpInside];
        
        return pressAnnotationView;
    }
    
    //this makes the annotations draggable without a title
    annotationView.canShowCallout = NO;
    
    return annotationView;
}

-(void) setFromLocation:(id) sender
{
    R2RLog(@"%@", sender);
    
    if (!self.fromAnnotation)
    {
        //TODO maybe add a name here so magnifying glass is shown and then set it to zoom to different levels
        self.fromAnnotation = [[R2RAnnotation alloc] initWithName:nil kind:nil coordinate:self.pressAnnotation.coordinate annotationType:r2rAnnotationTypeFrom];
        [self.mapView addAnnotation:self.fromAnnotation];
    }
    else
    {
        [self.fromAnnotation setCoordinate:self.pressAnnotation.coordinate];
    }

    [self.mapView removeAnnotation:self.pressAnnotation];
    self.pressAnnotation = nil;
}

-(void) setToLocation:(id) sender
{
    R2RLog(@"%@", sender);
    
    if (!self.toAnnotation)
    {
        self.toAnnotation = [[R2RAnnotation alloc] initWithName:nil kind:nil coordinate:self.pressAnnotation.coordinate annotationType:r2rAnnotationTypeTo];
        [self.mapView addAnnotation:self.toAnnotation];
    }
    else
    {
        [self.toAnnotation setCoordinate:self.pressAnnotation.coordinate];
    }
    
    [self.mapView removeAnnotation:self.pressAnnotation];
    self.pressAnnotation = nil;
}

@end
