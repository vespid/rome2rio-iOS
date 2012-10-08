//
//  R2RTransitSegmentCell.h
//  R2RApp
//
//  Created by Ash Verdoorn on 13/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "R2RIconLoader.h"

@interface R2RTransitSegmentCell : UITableViewCell //<R2RIconLoaderDelegate>

//@property (strong, nonatomic) UIImageView *agencyIconView;

@property (strong, nonatomic) UIImageView *transitVehicleIcon;
@property (strong, nonatomic) UILabel *fromLabel;
@property (strong, nonatomic) UILabel *toLabel;
@property (strong, nonatomic) UILabel *durationLabel;
@property (strong, nonatomic) UILabel *frequencyLabel;
@property (strong, nonatomic) UILabel *lineLabel;


//
//-(void) initAgencyIconView: (CGRect) rect;
//-(void) loadAgencyIcon: (NSString *) iconPath;

@end
