//
//  R2RMapViewController.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 21/11/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RMapViewController.h"
#import "R2RStopAnnotation.h"
#import "R2RAnnotation.h"
#import "R2RStatusButton.h"

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

//- (void) nothing
//{
//    R2RLog(@"do nothing");
//}

//- (void)moveAnnotation:(UILongPressGestureRecognizer *)gestureRecognizer
//{
////    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
////    {
//    
//    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
//    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
//    
//    if (self.fromAnnotation.coordinate.latitude == touchMapCoordinate.latitude && self.fromAnnotation.coordinate.longitude == touchMapCoordinate.longitude) return;
//
//    [self.fromAnnotation setCoordinate:touchMapCoordinate];
//
//}

- (void)showPressAnnotation:(UILongPressGestureRecognizer *)gestureRecognizer
{
    [self.statusButton setTitle:nil forState:UIControlStateNormal];
    
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
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = nil;
    
    R2RAnnotation *r2rAnnotation = (R2RAnnotation *)annotation;
    
    if (r2rAnnotation.annotationType == r2rAnnotationTypeStop)
    {
        NSString *identifier = @"R2RStopAnnotation";
        
        annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil)
        {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:r2rAnnotation reuseIdentifier:identifier];
            
            annotationView.enabled = YES;
            annotationView.canShowCallout = NO;
            
            [annotationView setDraggable:YES];
        }
        else
        {
            annotationView.annotation = annotation;
        }
    }
    else
    if (r2rAnnotation.annotationType == r2rAnnotationTypeFrom)
    {
        NSString *identifier = @"R2RFromAnnotation";
        
        MKPinAnnotationView *newAnnotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (newAnnotationView == nil)
        {
            newAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:r2rAnnotation reuseIdentifier:identifier];
            
            newAnnotationView.pinColor = MKPinAnnotationColorGreen;
            newAnnotationView.canShowCallout = NO;
            //TODO maybe add callout with remove button?
            
            [newAnnotationView setDraggable:YES];
        }
        
        annotationView = newAnnotationView;
    }
    else if (r2rAnnotation.annotationType == r2rAnnotationTypeTo)
    {
        NSString *identifier = @"R2RTOAnnotation";
        
        MKPinAnnotationView *newAnnotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (newAnnotationView == nil)
        {
            newAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:r2rAnnotation reuseIdentifier:identifier];
            
            newAnnotationView.pinColor = MKPinAnnotationColorRed;
            newAnnotationView.canShowCallout = NO;
            //TODO maybe add callout with remove button?
            
            [newAnnotationView setDraggable:YES];
        }
        
        annotationView = newAnnotationView;
    }
    else if (r2rAnnotation.annotationType == r2rAnnotationTypePress)
    {
        NSString *identifier = @"R2RPressAnnotation";
        
        R2RPressAnnotationView *newAnnotationView = (R2RPressAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (!newAnnotationView)
        {
            newAnnotationView = [[R2RPressAnnotationView alloc] initWithAnnotation:r2rAnnotation reuseIdentifier:identifier];
            
            [newAnnotationView.fromButton addTarget:self
                                           action:@selector(setFromLocation:)
                                 forControlEvents:UIControlEventTouchUpInside];
            
            [newAnnotationView.toButton addTarget:self
                                           action:@selector(setToLocation:)
                                 forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        annotationView = newAnnotationView;
    }

    
    
    return annotationView;
}

-(void) setFromLocation:(id) sender
{
    R2RLog(@"%@", sender);
    
    if (!self.fromAnnotation)
    {
        self.fromAnnotation = [[R2RAnnotation alloc] initWithName:@"from" kind:nil coordinate:self.pressAnnotation.coordinate annotationType:r2rAnnotationTypeFrom];
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
        self.toAnnotation = [[R2RAnnotation alloc] initWithName:@"to" kind:nil coordinate:self.pressAnnotation.coordinate annotationType:r2rAnnotationTypeTo];
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
