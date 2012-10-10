//
//  R2RTransitSegmentViewController.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 14/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "R2RTransitSegment.h"

@interface R2RTransitSegmentViewController : UITableViewController

@property (strong, nonatomic) R2RTransitSegment *transitSegment;
@property (strong, nonatomic) NSArray *agencies;
//@property (strong, nonatomic) NSMutableDictionary *agencyIcons;
- (IBAction)ReturnToSearch:(id)sender;

@end
