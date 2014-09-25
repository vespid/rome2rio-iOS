//
//  R2RResultSectionHeader.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 1/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RResultSectionHeader.h"
#import "R2RConstants.h"

@implementation R2RResultSectionHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[R2RConstants getBackgroundColor]];
        
        NSString *joiner = @" to ";
        CGSize joinerSize = [joiner sizeWithFont:[UIFont systemFontOfSize:17.0]];
        
        joinerSize.width += 2; //make slightly wider
        CGRect rect = CGRectMake((self.bounds.size.width/2)-(joinerSize.width/2), 5, joinerSize.width, 25);
        
        self.joinerLabel = [[UILabel alloc] initWithFrame:rect];
        [self.joinerLabel setTextAlignment:NSTextAlignmentCenter];
        [self.joinerLabel setBackgroundColor:[UIColor clearColor]];
        [self.joinerLabel setText:joiner];
        [self.joinerLabel setTextColor:[R2RConstants getLightTextColor]];
        [self addSubview:self.joinerLabel];
        
        rect = CGRectMake(0, 5, (self.bounds.size.width/2)-(joinerSize.width/2), 25);
        self.fromLabel = [[UILabel alloc] initWithFrame:rect];
        [self.fromLabel setTextAlignment:NSTextAlignmentRight];
        [self.fromLabel setBackgroundColor:[UIColor clearColor]];
        [self.fromLabel setTextColor:[R2RConstants getButtonHighlightColor]];
        [self.fromLabel setMinimumFontSize:10.0];
        [self.fromLabel setAdjustsFontSizeToFitWidth:YES];
        [self addSubview:self.fromLabel];
        
        rect = CGRectMake((self.bounds.size.width/2)+(joinerSize.width/2), 5, (self.bounds.size.width/2)-(joinerSize.width/2), 25);
        self.toLabel = [[UILabel alloc] initWithFrame:rect];
        [self.toLabel setTextAlignment:NSTextAlignmentLeft];
        [self.toLabel setBackgroundColor:[UIColor clearColor]];
        [self.toLabel setTextColor:[R2RConstants getButtonHighlightColor]];
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
