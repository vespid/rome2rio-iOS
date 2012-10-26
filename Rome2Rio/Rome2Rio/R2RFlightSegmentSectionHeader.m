//
//  R2RTransitSegmentSectionHeader.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 1/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RFlightSegmentSectionHeader.h"

@implementation R2RFlightSegmentSectionHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor colorWithRed:234.0/256.0 green:228.0/256.0 blue:224.0/256.0 alpha:1.0]];
        
        self.titleLabel = [[R2RTitleLabel alloc] initWithFrame:CGRectMake(0, 5, self.bounds.size.width, 25)];
        [self.titleLabel setTextAlignment:UITextAlignmentCenter];
        
        [self.titleLabel setBackgroundColor:[UIColor colorWithRed:234.0/256.0 green:228.0/256.0 blue:224.0/256.0 alpha:1.0]];
        [self addSubview:self.titleLabel];
        
        int joinerWidth = 26; //make slightly wider

        CGRect rect = CGRectMake((self.bounds.size.width/2)-(joinerWidth/2), 30, joinerWidth, 25);
        
        self.joinerLabel = [[UILabel alloc] initWithFrame:rect];
        [self.joinerLabel setTextAlignment:UITextAlignmentCenter];
        [self.joinerLabel setBackgroundColor:[UIColor clearColor]];
//        [self.joinerLabel setBackgroundColor:[UIColor colorWithRed:234.0/256.0 green:228.0/256.0 blue:224.0/256.0 alpha:1.0]];
        [self.joinerLabel setText:@" to "];
//        [self.joinerLabel setTextColor:[UIColor lightGrayColor]];
        [self.joinerLabel setTextColor:[UIColor colorWithWhite:0.5 alpha:1.0]];
        [self addSubview:self.joinerLabel];
        
        rect = CGRectMake(0, 30, (self.bounds.size.width/2)-(joinerWidth/2), 25);
        self.fromLabel = [[UILabel alloc] initWithFrame:rect];
        [self.fromLabel setTextAlignment:UITextAlignmentRight];
        [self.fromLabel setBackgroundColor:[UIColor clearColor]];
//        [self.fromLabel setBackgroundColor:[UIColor colorWithRed:234.0/256.0 green:228.0/256.0 blue:224.0/256.0 alpha:1.0]];
        [self.fromLabel setMinimumFontSize:10.0];
        [self.fromLabel setAdjustsFontSizeToFitWidth:YES];
        [self.fromLabel setTextColor:[UIColor colorWithWhite:0.2 alpha:1.0]];
        [self addSubview:self.fromLabel];
        
        rect = CGRectMake((self.bounds.size.width/2)+(joinerWidth/2), 30, (self.bounds.size.width/2)-(joinerWidth/2), 25);
        self.toLabel = [[UILabel alloc] initWithFrame:rect];
        [self.toLabel setTextAlignment:UITextAlignmentLeft];
        [self.toLabel setBackgroundColor:[UIColor clearColor]];
        [self.toLabel setTextColor:[UIColor colorWithWhite:0.2 alpha:1.0]];
//        [self.toLabel setBackgroundColor:[UIColor colorWithRed:234.0/256.0 green:228.0/256.0 blue:224.0/256.0 alpha:1.0]];
        [self.toLabel setMinimumFontSize:10.0];
        [self.toLabel setAdjustsFontSizeToFitWidth:YES];
        [self addSubview:self.toLabel];
    
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
