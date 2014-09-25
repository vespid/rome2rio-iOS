//
//  R2RTransitSegmentSectionHeader.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 1/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RFlightSegmentSectionHeader.h"
#import "R2RConstants.h"

@implementation R2RFlightSegmentSectionHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[R2RConstants getBackgroundColor]];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.bounds.size.width-10, 25)];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.titleLabel];
     
        CGRect rect = CGRectMake(10, 30, self.bounds.size.width - 10, 25);
        self.routeLabel = [[UILabel alloc] initWithFrame:rect];
        [self.routeLabel setTextAlignment:NSTextAlignmentCenter];
        [self.routeLabel setTextColor:[R2RConstants getLightTextColor]];
        [self.routeLabel setBackgroundColor:[UIColor clearColor]];
        [self.routeLabel setMinimumScaleFactor:0.6];
        [self.routeLabel setAdjustsFontSizeToFitWidth:YES];
        [self addSubview:self.routeLabel];
    
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
