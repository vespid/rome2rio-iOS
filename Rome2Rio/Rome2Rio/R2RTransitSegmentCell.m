//
//  R2RTransitSegmentCell.m
//  R2RApp
//
//  Created by Ash Verdoorn on 13/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RTransitSegmentCell.h"

@interface R2RTransitSegmentCell()

@property (strong, nonatomic) R2RIconLoader *iconLoader;

@end

@implementation R2RTransitSegmentCell

//@synthesize agencyIconView;

@synthesize fromLabel, durationLabel, frequencyLabel, toLabel, transitVehicleIcon, lineLabel;


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
    [self.fromLabel setBackgroundColor:[UIColor colorWithRed:254.0/256.0 green:248.0/256.0 blue:244.0/256.0 alpha:1.0]];
    [self addSubview:self.fromLabel];
    
    rect = CGRectMake(paddingX, 55, self.bounds.size.width - (2*paddingX), 25);
    self.toLabel = [[UILabel alloc] initWithFrame:rect];
    [self.toLabel setTextAlignment:UITextAlignmentLeft];
    [self.toLabel setMinimumFontSize:10.0];
    [self.toLabel setAdjustsFontSizeToFitWidth:YES];
    [self.toLabel setBackgroundColor:[UIColor colorWithRed:254.0/256.0 green:248.0/256.0 blue:244.0/256.0 alpha:1.0]];
    [self addSubview:self.toLabel];
    
    rect = CGRectMake(paddingX, 30, 18, 18);
    self.transitVehicleIcon = [[UIImageView alloc] initWithFrame:rect];
    [self addSubview:self.transitVehicleIcon];
    
    rect = CGRectMake(paddingX, 30, self.bounds.size.width - (2*paddingX), 25);
    self.durationLabel = [[UILabel alloc] initWithFrame:rect];
    [self.durationLabel setTextAlignment:UITextAlignmentCenter];
    [self.durationLabel setTextColor:[UIColor lightGrayColor]];
    [self.durationLabel setBackgroundColor:[UIColor colorWithRed:254.0/256.0 green:248.0/256.0 blue:244.0/256.0 alpha:1.0]];
    [self addSubview:self.durationLabel];
    
    rect = CGRectMake(paddingX+indent, 55, self.bounds.size.width - (2*paddingX)-indent, 25);
    self.lineLabel = [[UILabel alloc] initWithFrame:rect];
    [self.lineLabel setTextAlignment:UITextAlignmentLeft];
    [self.lineLabel setMinimumFontSize:10.0];
    [self.lineLabel setAdjustsFontSizeToFitWidth:YES];
    [self.lineLabel setBackgroundColor:[UIColor colorWithRed:254.0/256.0 green:248.0/256.0 blue:244.0/256.0 alpha:1.0]];
    [self.lineLabel setTextColor:[UIColor lightGrayColor]];
    [self.lineLabel setHidden:YES];
    [self addSubview:self.lineLabel];
//    rect = CGRectMake(paddingX, 55, self.bounds.size.width - (2*paddingX), 25);
//    self.frequencyLabel = [[UILabel alloc] initWithFrame:rect];
//    [self.frequencyLabel setTextAlignment:UITextAlignmentCenter];
//    [self.frequencyLabel setTextColor:[UIColor lightGrayColor]];
//    [self addSubview:self.frequencyLabel];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//-(void)loadAgencyIcon:(NSString *)iconPath
//{
//    
//    self.iconLoader = [[R2RIconLoader alloc] initWithIconPath:iconPath delegate:self];
//    
//}
//
//-(void) R2RIconLoaded:(R2RIconLoader *)delegateIconLoader
//{
//
//    [self.agencyIconView setImage:delegateIconLoader.icon];
//
//}
//
//-(void) initAgencyIconView: (CGRect) rect
//{
//    self.agencyIconView = [[UIImageView alloc] initWithFrame:rect];
//    [self addSubview:self.agencyIconView];
//}

@end
