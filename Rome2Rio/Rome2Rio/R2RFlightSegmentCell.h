//
//  R2RFlightSegmentCell.h
//  R2RApp
//
//  Created by Ash Verdoorn on 13/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface R2RFlightSegmentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *airlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *departureTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivalTimeLabel;

@end
