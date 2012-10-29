//
//  R2RTSViewController.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 29/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "R2RDataController.h"
#import "R2RTableView.h"

@interface R2RTSViewController : UIViewController <UIScrollViewDelegate, R2RTableViewDelegate, UITableViewDataSource, MKMapViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) R2RDataController *dataController;
@property (strong, nonatomic) R2RRoute *route;
@property (strong, nonatomic) R2RTransitSegment *transitSegment;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)ReturnToSearch:(id)sender;

@end
