//
//  R2RWalkDriveSegmentCell.m
//  R2RApp
//
//  Created by Ash Verdoorn on 13/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RWalkDriveSegmentCell.h"

@implementation R2RWalkDriveSegmentCell

@synthesize kindIcon, distanceLabel, durationLabel, fromLabel, toLabel;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setBackgroundColor:[UIColor colorWithRed:254.0/256.0 green:248.0/256.0 blue:244.0/256.0 alpha:1.0]];
        [self initSubviews];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) initSubviews
{
    NSInteger paddingX = 20;
    
    CGRect rect = CGRectMake(paddingX, 5, self.bounds.size.width - (2*paddingX), 25);
    self.fromLabel = [[UILabel alloc] initWithFrame:rect];
    [self.fromLabel setTextAlignment:UITextAlignmentLeft];
    [self.fromLabel setMinimumFontSize:10.0];
    [self.fromLabel setAdjustsFontSizeToFitWidth:YES];
    [self.fromLabel setBackgroundColor:[UIColor colorWithRed:254.0/256.0 green:248.0/256.0 blue:244.0/256.0 alpha:1.0]];
    [self addSubview:self.fromLabel];
    
    rect = CGRectMake(paddingX, 55, self.bounds.size.width - (2*paddingX), 25);
    self.toLabel = [[UILabel alloc] initWithFrame:rect];
    [self.toLabel setTextAlignment:UITextAlignmentLeft];
    [self.toLabel setMinimumFontSize:10.0];
    [self.toLabel setAdjustsFontSizeToFitWidth:YES];
    [self.toLabel setBackgroundColor:[UIColor colorWithRed:254.0/256.0 green:248.0/256.0 blue:244.0/256.0 alpha:1.0]];
    [self addSubview:self.toLabel];
    
    rect = CGRectMake(paddingX+20, 34, 18, 18);
    self.kindIcon = [[UIImageView alloc] initWithFrame:rect];
    [self addSubview:self.kindIcon];
    
    rect = CGRectMake(paddingX+20+25, 30, self.bounds.size.width - 75, 25);
    self.distanceLabel = [[UILabel alloc] initWithFrame:rect];
    [self.distanceLabel setTextAlignment:UITextAlignmentLeft];
    [self.distanceLabel setTextColor:[UIColor lightGrayColor]];
    [self.distanceLabel setBackgroundColor:[UIColor colorWithRed:254.0/256.0 green:248.0/256.0 blue:244.0/256.0 alpha:1.0]];
    [self addSubview:self.distanceLabel];
    
    rect = CGRectMake(self.bounds.size.width-75, 30, 60.0, 25);
    self.durationLabel = [[UILabel alloc] initWithFrame:rect];
    [self.durationLabel setTextAlignment:UITextAlignmentLeft];
    [self.durationLabel setMinimumFontSize:10.0];
    [self.durationLabel setAdjustsFontSizeToFitWidth:YES];
    [self.durationLabel setTextColor:[UIColor lightGrayColor]];
    [self.durationLabel setBackgroundColor:[UIColor colorWithRed:254.0/256.0 green:248.0/256.0 blue:244.0/256.0 alpha:1.0]];
    [self addSubview:self.durationLabel];
}

@end
