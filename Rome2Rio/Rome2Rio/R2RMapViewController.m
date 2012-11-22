//
//  R2RMapViewController.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 21/11/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RMapViewController.h"
#import "R2RStopAnnotation.h"

@interface R2RMapViewController ()

@property (strong, nonatomic) R2RStopAnnotation *location;

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
    
    //set pin start location to melbourne
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(-37.81425, 144.96315);
    self.location = [[R2RStopAnnotation alloc] initWithName:@"Location" kind:nil coordinate:coord];
        
    [self.mapView addAnnotation:self.location];
    
    [self.mapView setRegion:MKCoordinateRegionForMapRect(MKMapRectWorld)];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveAnnotation:)];
    [self.mapView addGestureRecognizer:longPressGesture];
    
	// Do any additional setup after loading the view.
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
    if ([self.fieldName isEqualToString:@"from"])
    {
        [self.searchManager setFromWithMapLocation:self.location.coordinate];
    }
    if ([self.fieldName isEqualToString:@"to"])
    {
        [self.searchManager setToWithMapLocation:self.location.coordinate];
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void) nothing
{
    R2RLog(@"do nothing");
}

- (void)moveAnnotation:(UILongPressGestureRecognizer *)gestureRecognizer
{
//    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
//    {
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    if (self.location.coordinate.latitude == touchMapCoordinate.latitude && self.location.coordinate.longitude == touchMapCoordinate.longitude) return;

    [self.location setCoordinate:touchMapCoordinate];

}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    NSString *identifier = @"R2RStopAnnotation";
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (annotationView == nil)
    {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = NO;
        
        [annotationView setDraggable:YES];
    }
    else
    {
        annotationView.annotation = annotation;
    }
    
    return annotationView;
}

@end
