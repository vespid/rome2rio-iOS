//
//  R2RFlightSegmentCell.m
//  R2RApp
//
//  Created by Ash Verdoorn on 13/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RFlightSegmentCell.h"
#import "R2RFlightLeg.h"

@interface R2RFlightSegmentCell()

//@property (strong, nonatomic) R2RIconLoader *firstIconLoader;
//@property (strong, nonatomic) R2RIconLoader *secondIconLoader;
//@property (nonatomic) CGRect firstIconCropRect;
//@property (nonatomic) CGRect secondIconCropRect;

@end

@implementation R2RFlightSegmentCell

@synthesize flightLeg, firstAirlineIcon, secondAirlineIcon, sTimeLabel, tTimeLabel, durationLabel;

//@synthesize airlineLabel;
//@synthesize durationLabel;
//@synthesize departureTimeLabel;
//@synthesize arrivalTimeLabel;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initSubViews];
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

-(void)initSubViews
{
    
    CGRect rect = CGRectMake(3, (self.bounds.size.height-23)/2, 27, 23);
    self.firstAirlineIcon = [[UIImageView alloc] initWithFrame:rect];
    [self addSubview:self.firstAirlineIcon];
    
    rect = CGRectMake(33, (self.bounds.size.height-23)/2, 27, 23);
    self.secondAirlineIcon = [[UIImageView alloc] initWithFrame:rect];
    [self addSubview:self.secondAirlineIcon];
    
    rect = CGRectMake((self.bounds.size.width/2)-10-50, 3, 50, 25);
    sTimeLabel = [[UILabel alloc] initWithFrame:rect];
    [sTimeLabel setTextAlignment:UITextAlignmentCenter];
//        [sTimeLabel setBackgroundColor:[UIColor colorWithRed:234.0/256.0 green:228.0/256.0 blue:224.0/256.0 alpha:1.0]];
//        [sTimeLabel setText:@"sTime"];
    [self addSubview:sTimeLabel];
    
    rect = CGRectMake((self.bounds.size.width/2)+10, 3, 50, 25);
    tTimeLabel = [[UILabel alloc] initWithFrame:rect];
    [tTimeLabel setTextAlignment:UITextAlignmentCenter];
//        [tTimeLabel setBackgroundColor:[UIColor colorWithRed:234.0/256.0 green:228.0/256.0 blue:224.0/256.0 alpha:1.0]];
//        [tTimeLabel setText:@"tTime"];
    [self addSubview:tTimeLabel];
    
    rect = CGRectMake(self.bounds.size.width-70, 3, 60.0, 25);
    durationLabel = [[UILabel alloc] initWithFrame:rect];
    [durationLabel setTextAlignment:UITextAlignmentLeft];
//        [durationLabel setBackgroundColor:[UIColor colorWithRed:234.0/256.0 green:228.0/256.0 blue:224.0/256.0 alpha:1.0]];
//        [durationLabel setText:@"duration"];
    [durationLabel setMinimumFontSize:10.0];
    [durationLabel setAdjustsFontSizeToFitWidth:YES];
    [durationLabel setTextColor:[UIColor lightGrayColor]];
    [self addSubview:durationLabel];
}

-(void)setDisplaySingleIcon
{
    CGRect rect = CGRectMake((65-27)/2, (self.bounds.size.height-23)/2, 27, 23);
    [self.firstAirlineIcon setFrame:rect];
    [self.secondAirlineIcon setHidden:YES];
    
}

-(void)setDisplayDoubleIcon
{
    CGRect rect = CGRectMake(3, (self.bounds.size.height-23)/2, 27, 23);
    [self.firstAirlineIcon setFrame:rect];
    
    rect = CGRectMake(33, (self.bounds.size.height-23)/2, 27, 23);
    [self.secondAirlineIcon setFrame:rect];
    [self.secondAirlineIcon setHidden:NO];
}

//-(void)initSingleIconView:(float)rowHeight
//{
//    CGRect rect = CGRectMake((65-27)/2, (rowHeight-23)/2, 27, 23);
//    self.firstAirlineIcon = [[R2RImageView alloc] initWithFrame:rect];
//    [self addSubview:self.firstAirlineIcon];
//}

//-(void)initDoubleIconView:(float)rowHeight
//{
//    CGRect rect = CGRectMake(3, (rowHeight-23)/2, 27, 23);
//    self.firstAirlineIcon = [[R2RImageView alloc] initWithFrame:rect];
//    [self addSubview:self.firstAirlineIcon];
//    
//    rect = CGRectMake(33, (rowHeight-23)/2, 27, 23);
//    self.secondAirlineIcon = [[R2RImageView alloc] initWithFrame:rect];
//    [self addSubview:self.secondAirlineIcon];
//}

//-(void)loadFirstAirlineIcon:(NSString *)iconPath :(CGPoint)iconOffset
//{
//    self.firstIconCropRect = CGRectMake(iconOffset.x, iconOffset.y, 27, 23);
//    self.firstIconLoader = [[R2RIconLoader alloc] initWithIconPath:iconPath delegate:self];
//}
//
//-(void)loadSecondAirlineIcon:(NSString *)iconPath :(CGPoint)iconOffset
//{
//    self.secondIconCropRect = CGRectMake(iconOffset.x, iconOffset.y, 27, 23);
//    self.secondIconLoader = [[R2RIconLoader alloc] initWithIconPath:iconPath delegate:self];
//}

//-(void) R2RIconLoaded:(R2RIconLoader *)delegateIconLoader
//{
//    if (delegateIconLoader == self.firstIconLoader)
//    {
//        [self.firstAirlineIcon setCroppedImage:delegateIconLoader.icon :self.firstIconCropRect];
////        [self.firstAirlineIcon setImage:delegateIconLoader.icon];
//    }
//    if (delegateIconLoader == self.secondIconLoader)
//    {
//        [self.secondAirlineIcon setCroppedImage:delegateIconLoader.icon :self.secondIconCropRect];
//    }
//}

@end
