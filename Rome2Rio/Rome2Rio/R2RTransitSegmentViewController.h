//
//  R2RTransitSegmentViewController.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 14/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "R2RTransitSegment.h"
#import "R2RSpriteStore.h"
#import "R2RDataController.h"

@interface R2RTransitSegmentViewController : UITableViewController <MKMapViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) R2RDataController *dataController;
@property (strong, nonatomic) R2RRoute *route;
@property (strong, nonatomic) R2RTransitSegment *transitSegment;

- (IBAction)ReturnToSearch:(id)sender;

@end
