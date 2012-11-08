//
//  R2RTransitSegmentCell.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 13/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RTransitSegmentCell.h"
#import "R2RConstants.h"

@implementation R2RTransitSegmentCell

@synthesize fromLabel, durationLabel, frequencyLabel, toLabel, transitVehicleIcon, lineLabel;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setBackgroundColor:[R2RConstants getCellColor]];
        [self initSubviews];
    }
    return self;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {

    }
    return self;
}

-(void) initSubviews
{
    NSInteger paddingX = 20;
    NSInteger indent = 20;
    
    CGRect rect = CGRectMake(paddingX, 5, self.bounds.size.width - (2*paddingX), 25);
    self.fromLabel = [[UILabel alloc] initWithFrame:rect];
    [self.fromLabel setTextAlignment:UITextAlignmentLeft];
    [self.fromLabel setMinimumFontSize:10.0];
    [self.fromLabel setAdjustsFontSizeToFitWidth:YES];
    [self.fromLabel setBackgroundColor:[UIColor clearColor]];
    [self.fromLabel setTextColor:[R2RConstants getDarkTextColor]];
    [self addSubview:self.fromLabel];
    
    rect = CGRectMake(paddingX, 55, self.bounds.size.width - (2*paddingX), 25);
    self.toLabel = [[UILabel alloc] initWithFrame:rect];
    [self.toLabel setTextAlignment:UITextAlignmentLeft];
    [self.toLabel setMinimumFontSize:10.0];
    [self.toLabel setAdjustsFontSizeToFitWidth:YES];
    [self.toLabel setBackgroundColor:[UIColor clearColor]];
    [self.toLabel setTextColor:[R2RConstants getDarkTextColor]];
    [self addSubview:self.toLabel];
    
    rect = CGRectMake(paddingX, 30, 18, 18);
    self.transitVehicleIcon = [[UIImageView alloc] initWithFrame:rect];
    [self addSubview:self.transitVehicleIcon];
    
    rect = CGRectMake(paddingX, 30, self.bounds.size.width - (paddingX + 5), 25);
    self.durationLabel = [[UILabel alloc] initWithFrame:rect];
    [self.durationLabel setTextAlignment:UITextAlignmentCenter];
    [self.durationLabel setTextColor:[R2RConstants getLightTextColor]];
    [self.durationLabel setMinimumFontSize:10.0];
    [self.durationLabel setAdjustsFontSizeToFitWidth:YES];
    [self.durationLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.durationLabel];
    
    rect = CGRectMake(paddingX+indent, 55, self.bounds.size.width - (2*paddingX)-indent, 25);
    self.lineLabel = [[UILabel alloc] initWithFrame:rect];
    [self.lineLabel setTextAlignment:UITextAlignmentLeft];
    [self.lineLabel setMinimumFontSize:10.0];
    [self.lineLabel setAdjustsFontSizeToFitWidth:YES];
    [self.lineLabel setBackgroundColor:[UIColor clearColor]];
    [self.lineLabel setTextColor:[R2RConstants getLightTextColor]];
    [self.lineLabel setHidden:YES];
    [self addSubview:self.lineLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
