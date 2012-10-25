//
//  R2RFlightSegmentCell.h
//  R2RApp
//
//  Created by Ash Verdoorn on 13/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "R2RFlightLeg.h"

@interface R2RFlightSegmentCell : UITableViewCell

@property (strong, nonatomic) R2RFlightLeg *flightLeg;

@property (strong, nonatomic) UIImageView *firstAirlineIcon;
@property (strong, nonatomic) UIImageView *secondAirlineIcon;
@property (strong, nonatomic) UILabel *sTimeLabel;
@property (strong, nonatomic) UILabel *tTimeLabel;
@property (strong, nonatomic) UILabel *durationLabel;

@property (strong, nonatomic) UILabel *frequencyLabel;
@property (strong, nonatomic) UIButton *linkButton;
// for expanded cell view
@property (strong, nonatomic) NSMutableArray *airlineIcons;
@property (strong, nonatomic) NSMutableArray *airlineNameLabels;
@property (strong, nonatomic) NSMutableArray *flightNameLabels;
@property (strong, nonatomic) NSMutableArray *layoverNameLabels;
@property (strong, nonatomic) NSMutableArray *hopDurationLabels;
@property (strong, nonatomic) NSMutableArray *layoverDurationLabels;


-(void) setDisplaySingleIcon;
-(void) setDisplayDoubleIcon;

//-(void) initSingleIconView: (float) rowHeight;
//-(void) initDoubleIconView: (float) rowHeight;
//
//-(void) loadFirstAirlineIcon: (NSString *) iconPath: (CGPoint) iconOffset;
//-(void) loadSecondAirlineIcon: (NSString *) iconPath: (CGPoint) iconOffset;

@end
