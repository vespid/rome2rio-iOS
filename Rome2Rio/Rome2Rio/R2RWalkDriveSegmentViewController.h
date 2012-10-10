//
//  R2RWalkDriveSegmentViewController.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 14/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "R2RWalkDriveSegment.h"

@interface R2RWalkDriveSegmentViewController : UITableViewController

@property (strong, nonatomic) R2RWalkDriveSegment *walkDriveSegment;
- (IBAction)ReturnToSearch:(id)sender;

@end
