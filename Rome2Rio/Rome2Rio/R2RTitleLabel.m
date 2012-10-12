//
//  R2RTitleLabel.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 26/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RTitleLabel.h"

@implementation R2RTitleLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setTextAlignment:UITextAlignmentRight];
        [self setTextColor:[UIColor orangeColor]];
        [self setMinimumFontSize:5.0];
        [self setAdjustsFontSizeToFitWidth:YES];
        [self setBackgroundColor:[UIColor clearColor]];
//        [self setBackgroundColor:[UIColor colorWithRed:254.0/256.0 green:248.0/256.0 blue:244.0/256.0 alpha:1.0]];
       
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
