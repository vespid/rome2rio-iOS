//
//  R2RResultSectionHeader.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 1/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RResultSectionHeader.h"

@implementation R2RResultSectionHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor colorWithRed:234.0/256.0 green:228.0/256.0 blue:224.0/256.0 alpha:1.0]];
        
        NSString *joiner = @" to ";
        CGSize joinerSize = [joiner sizeWithFont:[UIFont fontWithName:@"Helvetica" size:17.0]];
//        CGSize joinerSize = [joiner sizeWithFont:self.titleLabel.font]; //change to font of choice
        
        joinerSize.width += 2; //make slightly wider
        CGRect rect = CGRectMake((self.bounds.size.width/2)-(joinerSize.width/2), 5, joinerSize.width, 25);
        
        self.joinerLabel = [[UILabel alloc] initWithFrame:rect];
        [self.joinerLabel setTextAlignment:UITextAlignmentCenter];
        [self.joinerLabel setBackgroundColor:[UIColor clearColor]];
//        [self.joinerLabel setBackgroundColor:[UIColor colorWithRed:234.0/256.0 green:228.0/256.0 blue:224.0/256.0 alpha:1.0]];
        [self.joinerLabel setText:joiner];
        [self.joinerLabel setTextColor:[UIColor lightGrayColor]];
        [self addSubview:self.joinerLabel];
        
        rect = CGRectMake(0, 5, (self.bounds.size.width/2)-(joinerSize.width/2), 25);
        self.fromLabel = [[UILabel alloc] initWithFrame:rect];
        [self.fromLabel setTextAlignment:UITextAlignmentRight];
        [self.fromLabel setBackgroundColor:[UIColor clearColor]];
//        [self.fromLabel setBackgroundColor:[UIColor colorWithRed:234.0/256.0 green:228.0/256.0 blue:224.0/256.0 alpha:1.0]];
        [self.fromLabel setMinimumFontSize:10.0];
        [self.fromLabel setAdjustsFontSizeToFitWidth:YES];
        [self addSubview:self.fromLabel];
        
        rect = CGRectMake((self.bounds.size.width/2)+(joinerSize.width/2), 5, (self.bounds.size.width/2)-(joinerSize.width/2), 25);
        self.toLabel = [[UILabel alloc] initWithFrame:rect];
        [self.toLabel setTextAlignment:UITextAlignmentLeft];
        [self.toLabel setBackgroundColor:[UIColor clearColor]];
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
