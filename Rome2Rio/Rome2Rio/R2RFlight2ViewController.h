//
//  R2RFlight2ViewController.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 23/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "R2RDataController.h"

@interface R2RFlight2ViewController : UIViewController <UITableViewDelegate>

@property (strong, nonatomic) R2RDataController *dataController;
@property (strong, nonatomic) R2RRoute *route;
@property (strong, nonatomic) R2RFlightSegment *flightSegment;

@property (weak, nonatomic) IBOutlet UITableView *flightsTable;
@property (weak, nonatomic) IBOutlet UIView *linkMenu;

//- (IBAction)ReturnToSearch:(id)sender;

-(void) sortFlightSegment;

@end
