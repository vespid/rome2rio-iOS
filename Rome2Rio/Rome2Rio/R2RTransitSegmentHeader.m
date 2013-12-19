//
//  R2RTransitSegmentHeader.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 1/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RTransitSegmentHeader.h"
#import "R2RConstants.h"

@implementation R2RTransitSegmentHeader

@synthesize agencyIconView, agencyNameLabel;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
       [self initSubviews];
    }
    return self;
}


-(void) initSubviews
{
    CGRect rect = CGRectMake(20, 5, 20, 20);
    
    self.agencyIconView = [[UIImageView alloc] initWithFrame:rect];
    [self addSubview:self.agencyIconView];
    
    rect = CGRectMake(50, 8, 200, 25);
    
    self.agencyNameLabel = [[UILabel alloc] initWithFrame:rect];
    [self.agencyNameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.agencyNameLabel setMinimumFontSize:10.0];
    [self.agencyNameLabel setAdjustsFontSizeToFitWidth:YES];
    [self.agencyNameLabel setBackgroundColor:[UIColor clearColor]];
    [self.agencyNameLabel setTextColor:[R2RConstants getDarkTextColor]];
    [self addSubview:self.agencyNameLabel];

    rect = CGRectMake(280, 8, 27, 23);
    self.linkButton = [[UIButton alloc] initWithFrame:rect];
    [self addSubview:self.linkButton];
    
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
