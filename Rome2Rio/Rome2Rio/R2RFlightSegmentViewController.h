//
//  R2RFlightSegmentViewController.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 14/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "R2RFlightSegment.h"
#import "R2RAirlineIconLoader.h"

@interface R2RFlightSegmentViewController : UITableViewController <R2RAirlineIconLoaderDelegate>

@property (strong, nonatomic) R2RFlightSegment *flightSegment;
@property (strong, nonatomic) NSArray *airlines;
@property (strong, nonatomic) NSArray *airports;

@property (nonatomic, retain) NSMutableDictionary *iconDownloadsInProgress;

//- (void)iconDidLoad:(NSIndexPath *)indexPath;

- (IBAction)ReturnToSearch:(id)sender;
-(void) sortFlightSegment;

@end

