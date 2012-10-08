//
//  R2RTransitSegmentSectionHeader.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 1/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "R2RTitleLabel.h"

@interface R2RFlightSegmentSectionHeader : UIView

@property (strong, nonatomic) R2RTitleLabel *titleLabel;
@property (strong, nonatomic) UILabel *joinerLabel;
@property (strong, nonatomic) UILabel *fromLabel;
@property (strong, nonatomic) UILabel *toLabel;

@end
