//
//  R2RWalkDriveSegmentViewController.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 30/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "R2RDataStore.h"
#import "R2RTableView.h"

@interface R2RWalkDriveSegmentViewController : UIViewController <UIScrollViewDelegate, R2RTableViewDelegate, UITableViewDataSource, MKMapViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) R2RDataStore *dataStore;
@property (strong, nonatomic) R2RRoute *route;
@property (strong, nonatomic) R2RWalkDriveSegment *walkDriveSegment;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)returnToSearch:(id)sender;

@end
