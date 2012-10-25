//
//  R2RTransitSegmentHeader.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 1/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "R2RButtonWithUrl.h"

@interface R2RTransitSegmentHeader : UIView

//@property (strong, nonatomic) R2RButtonWithUrl *agencyIconView;
//@property (strong, nonatomic) R2RButtonWithUrl *agencyNameLabel;
@property (strong, nonatomic) UIImageView *agencyIconView;
@property (strong, nonatomic) UILabel *agencyNameLabel;
@property (strong, nonatomic) UIButton *linkButton;

@end
