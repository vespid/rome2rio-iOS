//
//  R2RResultsCell.m
//  R2RApp
//
//  Created by Ash Verdoorn on 7/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RResultsCell.h"
#import "R2RConstants.h"

@interface R2RResultsCell()

@property (nonatomic) NSInteger maxIcons;

@end


@implementation R2RResultsCell

@synthesize resultDescripionLabel, resultDurationLabel, iconCount, icons;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.maxIcons = 5;
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

- (void) initSubviews
{
    
    CGRect rect = CGRectMake(15, 5, self.bounds.size.width-45, 25);
    self.resultDescripionLabel = [[UILabel alloc] initWithFrame:rect];
    [self.resultDescripionLabel setMinimumFontSize:10.0];
    [self.resultDescripionLabel setAdjustsFontSizeToFitWidth:YES];
    [self.resultDescripionLabel setBackgroundColor:[UIColor clearColor]];
    [self.resultDescripionLabel setTextColor:[R2RConstants getDarkTextColor]];
    [self addSubview:self.resultDescripionLabel];
    
    rect = CGRectMake(self.bounds.size.width-100-30, 30, 100.0, 20);
    self.resultDurationLabel = [[UILabel alloc] initWithFrame:rect];
    [self.resultDurationLabel setTextAlignment:NSTextAlignmentRight];
    [self.resultDurationLabel setFont:[UIFont systemFontOfSize:17.0]];
    [self.resultDurationLabel setBackgroundColor:[UIColor clearColor]];
    [self.resultDurationLabel setMinimumFontSize:10.0];
    [self.resultDurationLabel setAdjustsFontSizeToFitWidth:YES];
    [self.resultDurationLabel setTextColor:[R2RConstants getLightTextColor]];
    [self addSubview:self.resultDurationLabel];
    
    self.icons = [[NSMutableArray alloc] initWithCapacity:5];
    
    for (int i = 0; i <self.maxIcons; i++)
    {
        CGRect rect = CGRectMake(15+(25*i), 35, 18, 18);
        UIImageView *icon = [[UIImageView alloc] initWithFrame:rect];
        [self.icons addObject:icon];
        
        [self addSubview:[self.icons objectAtIndex:i]];
    }
    
    self.iconCount = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)setIconCount:(NSInteger)count
{
    iconCount = count;
    
    for (int i = 0; i <self.maxIcons; i++)
    {
        UIImageView *icon = [self.icons objectAtIndex:i];
        if (i < count)
        {
            [icon setHidden:NO];
        }
        else
        {
            [icon setHidden:YES];
        }
    }
}

@end
