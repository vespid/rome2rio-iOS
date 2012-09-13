//
//  R2RResultsViewController.h
//  R2RApp
//
//  Created by Ash Verdoorn on 6/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "R2RDataController.h"
//#import "R2RSearchResponse.h"
//#import "R2RPlace.h"

@interface R2RResultsViewController : UITableViewController

@property (strong, nonatomic) R2RDataController *dataController;
//@property (strong, nonatomic) R2RPlace *fromSearchPlace;
//@property (strong, nonatomic) R2RPlace *toSearchPlace;
//@property (strong, nonatomic) R2RSearchResponse *searchResponse;

//-(void) UpdateResults;

@end
