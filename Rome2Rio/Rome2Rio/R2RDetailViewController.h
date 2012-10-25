//
//  R2RDetailViewController.h
//  R2RApp
//
//  Created by Ash Verdoorn on 6/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "R2RRoute.h"
#import "R2RDataController.h"

@interface R2RDetailViewController : UITableViewController <MKMapViewDelegate>

@property (strong, nonatomic) R2RDataController *dataController;
@property (strong, nonatomic) R2RRoute *route;

//@property (weak, nonatomic) IBOutlet MKMapView *routeMap;
//@property (strong, nonatomic) MKMapView *routeMap;

- (IBAction)ReturnToSearch:(id)sender;

@end
