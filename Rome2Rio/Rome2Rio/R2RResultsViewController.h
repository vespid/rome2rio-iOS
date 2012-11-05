//
//  R2RResultsViewController.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 6/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "R2RDataController.h"

#import "R2RDataManager.h"

@interface R2RResultsViewController : UITableViewController

//@property (strong, nonatomic) R2RDataController *dataController;

@property (strong, nonatomic) R2RDataManager *dataManager;
@property (strong, nonatomic) R2RDataStore *dataStore;

- (IBAction)returnToSearch:(id)sender;

@end
