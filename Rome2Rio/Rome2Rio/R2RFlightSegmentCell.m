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

@synthesize flightLeg, firstAirlineIcon, secondAirlineIcon, sTimeLabel, tTimeLabel, durationLabel, frequencyLabel, linkButton;
@synthesize airlineIcons, airlineNameLabels, flightNameLabels, hopDurationLabels, layoverDurationLabels, layoverNameLabels;

#define MAX_FLIGHT_STOPS 5

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
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

-(void)initSubviews
{
    [self setClipsToBounds:YES];
    
    CGRect rect = CGRectMake(8, 4, 27, 23);
    self.firstAirlineIcon = [[UIImageView alloc] initWithFrame:rect];
    [self addSubview:self.firstAirlineIcon];
    
    rect = CGRectMake(38, 4, 27, 23);
    self.secondAirlineIcon = [[UIImageView alloc] initWithFrame:rect];
    [self addSubview:self.secondAirlineIcon];
    
    rect = CGRectMake((self.bounds.size.width/2)-10-50, 3, 50, 25);
    self.sTimeLabel = [[UILabel alloc] initWithFrame:rect];
    [self.sTimeLabel setTextAlignment:UITextAlignmentCenter];
    [self.sTimeLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.sTimeLabel];
    
    rect = CGRectMake((self.bounds.size.width/2)+10, 3, 50, 25);
    self.tTimeLabel = [[UILabel alloc] initWithFrame:rect];
    [self.tTimeLabel setTextAlignment:UITextAlignmentCenter];
    [self.tTimeLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.tTimeLabel];
    
    rect = CGRectMake(self.bounds.size.width-70, 3, 60.0, 25);
    self.durationLabel = [[UILabel alloc] initWithFrame:rect];
    [self.durationLabel setTextAlignment:UITextAlignmentLeft];
    [self.durationLabel setBackgroundColor:[UIColor clearColor]];
    [self.durationLabel setMinimumFontSize:10.0];
    [self.durationLabel setAdjustsFontSizeToFitWidth:YES];
    [self.durationLabel setTextColor:[UIColor lightGrayColor]];
    [self addSubview:self.durationLabel];
    
    self.layoverNameLabels = [[NSMutableArray alloc] initWithCapacity:MAX_FLIGHT_STOPS-1];
    self.layoverDurationLabels = [[NSMutableArray alloc] initWithCapacity:MAX_FLIGHT_STOPS-1];


    for (int i = 0; i < MAX_FLIGHT_STOPS-1; i++)
    {
        int y = 30 + (i*25);
        
        rect = CGRectMake(38, y, 210, 25);
        UILabel *label = [[UILabel alloc] initWithFrame:rect];
        [label setTextAlignment:UITextAlignmentLeft];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setMinimumFontSize:10.0];
        [label setAdjustsFontSizeToFitWidth:YES];
        [self.layoverNameLabels addObject:label];
        [self addSubview:[self.layoverNameLabels objectAtIndex:i]];
        
        rect = CGRectMake(self.bounds.size.width-20, y, 20, 25);
        label = [[UILabel alloc] initWithFrame:rect];
        [label setTextAlignment:UITextAlignmentLeft];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setMinimumFontSize:10.0];
        [label setAdjustsFontSizeToFitWidth:YES];
        [self.layoverDurationLabels addObject:label];
        [self addSubview:[self.layoverDurationLabels objectAtIndex:i]];
    }

    rect = CGRectMake(50, 155, 200, 25);
    self.frequencyLabel = [[UILabel alloc] initWithFrame:rect];
    [self.frequencyLabel setTextAlignment:UITextAlignmentCenter];
    [self.frequencyLabel setBackgroundColor:[UIColor clearColor]];
    [self.frequencyLabel setTextColor:[UIColor lightGrayColor]];
    [self addSubview:self.frequencyLabel];
    
    rect = CGRectMake(280, 155, 27, 23);
    self.linkButton = [[UIButton alloc] initWithFrame:rect];
    [self addSubview:self.linkButton];
    
//    self.airlineIcons = [[NSMutableArray alloc] initWithCapacity:MAX_FLIGHT_STOPS];
//    self.airlineNameLabels = [[NSMutableArray alloc] initWithCapacity:MAX_FLIGHT_STOPS];
//    self.flightNameLabels = [[NSMutableArray alloc] initWithCapacity:MAX_FLIGHT_STOPS];
//    self.hopDurationLabels = [[NSMutableArray alloc] initWithCapacity:MAX_FLIGHT_STOPS];
    
//    for (int i = 0; i < MAX_FLIGHT_STOPS; i++)
//    {
//        int y = 60 + (i*50);
//        
//        CGRect rect = CGRectMake(8, y, 27, 23);
//        UIImageView *icon = [[UIImageView alloc] initWithFrame:rect];
//        [self.airlineIcons addObject:icon];
//        [self addSubview:[self.airlineIcons objectAtIndex:i]];
//        
//        rect = CGRectMake(38, y, 158, 25);
//        UILabel *label = [[UILabel alloc] initWithFrame:rect];
//        [label setTextAlignment:UITextAlignmentLeft];
//        [label setBackgroundColor:[UIColor clearColor]];
//        [label setMinimumFontSize:10.0];
//        [label setAdjustsFontSizeToFitWidth:YES];
//        [self.airlineNameLabels addObject:label];
//        [self addSubview:[self.airlineNameLabels objectAtIndex:i]];
// 
//        rect = CGRectMake(193, y, 55, 25);
//        label = [[UILabel alloc] initWithFrame:rect];
//        [label setTextAlignment:UITextAlignmentLeft];
//        [label setBackgroundColor:[UIColor clearColor]];
//        [label setMinimumFontSize:10.0];
//        [label setAdjustsFontSizeToFitWidth:YES];
//        [self.flightNameLabels addObject:label];
//        [self addSubview:[self.flightNameLabels objectAtIndex:i]];
//     
//        rect = CGRectMake(self.bounds.size.width-70, y, 60, 25);
//        label = [[UILabel alloc] initWithFrame:rect];
//        [label setTextAlignment:UITextAlignmentLeft];
//        [label setBackgroundColor:[UIColor clearColor]];
//        [label setMinimumFontSize:10.0];
//        [label setAdjustsFontSizeToFitWidth:YES];
//        [label setTextColor:[UIColor lightGrayColor]];
//        [self.hopDurationLabels addObject:label];
//        [self addSubview:[self.hopDurationLabels objectAtIndex:i]];
//    }
//    
//    self.layoverNameLabels = [[NSMutableArray alloc] initWithCapacity:MAX_FLIGHT_STOPS-1];
//    self.layoverDurationLabels = [[NSMutableArray alloc] initWithCapacity:MAX_FLIGHT_STOPS-1];
//
//    for (int i = 0; i < MAX_FLIGHT_STOPS-1; i++)
//    {
//        int y = 85 + (i*50);
//
//        rect = CGRectMake(38, y, 210, 25);
//        UILabel *label = [[UILabel alloc] initWithFrame:rect];
//        [label setTextAlignment:UITextAlignmentLeft];
//        [label setBackgroundColor:[UIColor clearColor]];
//        [label setMinimumFontSize:10.0];
//        [label setAdjustsFontSizeToFitWidth:YES];
//        [label setTextColor:[UIColor lightGrayColor]];
//        [self.layoverNameLabels addObject:label];
//        [self addSubview:[self.layoverNameLabels objectAtIndex:i]];
//        
//        rect = CGRectMake(self.bounds.size.width-70, y, 60, 25);
//        label = [[UILabel alloc] initWithFrame:rect];
//        [label setTextAlignment:UITextAlignmentLeft];
//        [label setBackgroundColor:[UIColor clearColor]];
//        [label setMinimumFontSize:10.0];
//        [label setAdjustsFontSizeToFitWidth:YES];
//        [label setTextColor:[UIColor lightGrayColor]];
//        [self.layoverDurationLabels addObject:label];
//        [self addSubview:[self.layoverDurationLabels objectAtIndex:i]];
//    }
}

-(void)setDisplaySingleIcon
{
//    CGRect rect = CGRectMake((65-27)/2, (self.bounds.size.height-23)/2, 27, 23);
//    CGRect rect = CGRectMake(8, 4, 27, 23);
//    [self.firstAirlineIcon setFrame:rect];
    [self.secondAirlineIcon setHidden:YES];
    
}

-(void)setDisplayDoubleIcon
{
    CGRect rect = CGRectMake(8, 4, 27, 23);
    [self.firstAirlineIcon setFrame:rect];
    
//    rect = CGRectMake(38, 4, 27, 23);
//    [self.secondAirlineIcon setFrame:rect];
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
