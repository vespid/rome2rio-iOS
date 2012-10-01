//
//  R2RDetailViewController.h
//  R2RApp
//
//  Created by Ash Verdoorn on 6/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "R2RRoute.h"

@interface R2RDetailViewController : UITableViewController

@property (strong, nonatomic) R2RRoute *route;
@property (strong, nonatomic) NSArray *airlines;
@property (strong, nonatomic) NSArray *airports;

- (IBAction)ReturnToSearch:(id)sender;

@end
