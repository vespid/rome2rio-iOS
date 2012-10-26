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
@synthesize airlineIcons, airlineNameLabels, flightNameLabels, hopDurationLabels, layoverDurationLabels, layoverNameLabels, sAirportLabels, tAirportLabels, joinerLabels;

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
    [self.sTimeLabel setTextColor:[UIColor colorWithWhite:0.2 alpha:1.0]];
    [self addSubview:self.sTimeLabel];
    
    rect = CGRectMake((self.bounds.size.width/2)+10, 3, 50, 25);
    self.tTimeLabel = [[UILabel alloc] initWithFrame:rect];
    [self.tTimeLabel setTextAlignment:UITextAlignmentCenter];
    [self.tTimeLabel setBackgroundColor:[UIColor clearColor]];
    [self.tTimeLabel setTextColor:[UIColor colorWithWhite:0.2 alpha:1.0]];
    [self addSubview:self.tTimeLabel];
    
    rect = CGRectMake(self.bounds.size.width-80, 3, 70, 25);
    self.durationLabel = [[UILabel alloc] initWithFrame:rect];
    [self.durationLabel setTextAlignment:UITextAlignmentRight];
    [self.durationLabel setBackgroundColor:[UIColor clearColor]];
    [self.durationLabel setFont:[UIFont systemFontOfSize:11]];
//    [self.durationLabel setMinimumFontSize:10.0];
//    [self.durationLabel setAdjustsFontSizeToFitWidth:YES];
//    [self.durationLabel setTextColor:[UIColor lightGrayColor]];
    [self.durationLabel setTextColor:[UIColor colorWithWhite:0.2 alpha:1.0]];
    [self addSubview:self.durationLabel];
    
//    self.layoverNameLabels = [[NSMutableArray alloc] initWithCapacity:MAX_FLIGHT_STOPS-1];
//    self.layoverDurationLabels = [[NSMutableArray alloc] initWithCapacity:MAX_FLIGHT_STOPS-1];
//
//
//    for (int i = 0; i < MAX_FLIGHT_STOPS-1; i++)
//    {
//        int y = 30 + (i*25);
//        
//        rect = CGRectMake(38, y, 210, 25);
//        UILabel *label = [[UILabel alloc] initWithFrame:rect];
//        [label setTextAlignment:UITextAlignmentLeft];
//        [label setBackgroundColor:[UIColor clearColor]];
//        [label setMinimumFontSize:10.0];
//        [label setAdjustsFontSizeToFitWidth:YES];
//        [self.layoverNameLabels addObject:label];
//        [self addSubview:[self.layoverNameLabels objectAtIndex:i]];
//        
//        rect = CGRectMake(self.bounds.size.width-20, y, 20, 25);
//        label = [[UILabel alloc] initWithFrame:rect];
//        [label setTextAlignment:UITextAlignmentLeft];
//        [label setBackgroundColor:[UIColor clearColor]];
//        [label setMinimumFontSize:10.0];
//        [label setAdjustsFontSizeToFitWidth:YES];
//        [self.layoverDurationLabels addObject:label];
//        [self addSubview:[self.layoverDurationLabels objectAtIndex:i]];
//    }

    rect = CGRectMake(60, 155, 200, 25);
    self.frequencyLabel = [[UILabel alloc] initWithFrame:rect];
    [self.frequencyLabel setTextAlignment:UITextAlignmentCenter];
    [self.frequencyLabel setBackgroundColor:[UIColor clearColor]];
//    [self.frequencyLabel setTextColor:[UIColor lightGrayColor]];
    [self.frequencyLabel setTextColor:[UIColor colorWithWhite:0.5 alpha:1.0]];
    [self addSubview:self.frequencyLabel];
    
    rect = CGRectMake(280, 155, 27, 23);
    self.linkButton = [[UIButton alloc] initWithFrame:rect];
    [self addSubview:self.linkButton];
    
    self.airlineIcons = [[NSMutableArray alloc] initWithCapacity:MAX_FLIGHT_STOPS];
    self.airlineNameLabels = [[NSMutableArray alloc] initWithCapacity:MAX_FLIGHT_STOPS];
    self.flightNameLabels = [[NSMutableArray alloc] initWithCapacity:MAX_FLIGHT_STOPS];
    self.hopDurationLabels = [[NSMutableArray alloc] initWithCapacity:MAX_FLIGHT_STOPS];
    self.sAirportLabels = [[NSMutableArray alloc] initWithCapacity:MAX_FLIGHT_STOPS];
    self.tAirportLabels = [[NSMutableArray alloc] initWithCapacity:MAX_FLIGHT_STOPS];
    self.joinerLabels = [[NSMutableArray alloc] initWithCapacity:MAX_FLIGHT_STOPS];

    for (int i = 0; i < MAX_FLIGHT_STOPS; i++)
    {
        int y = 40 + (i*50);
        
        CGRect rect = CGRectMake(38, y, 27, 23);
        UIImageView *icon = [[UIImageView alloc] initWithFrame:rect];
        [self.airlineIcons addObject:icon];
        [self addSubview:[self.airlineIcons objectAtIndex:i]];
        
        UILabel *label = nil;
 
        rect = CGRectMake(38, y, 55, 25);
        label = [[UILabel alloc] initWithFrame:rect];
        [label setTextAlignment:UITextAlignmentLeft];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor colorWithWhite:0.5 alpha:1.0]];
        [label setFont:[UIFont systemFontOfSize:15]];
        [self.flightNameLabels addObject:label];
        [self addSubview:[self.flightNameLabels objectAtIndex:i]];
        
        rect = CGRectMake((160-13-50), y, 50, 25);
        label = [[UILabel alloc] initWithFrame:rect];
        [label setTextAlignment:UITextAlignmentRight];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor colorWithWhite:0.2 alpha:1.0]];
        [self.sAirportLabels addObject:label];
        [self addSubview:[self.sAirportLabels objectAtIndex:i]];
 
        rect = CGRectMake(160-13, y, 26, 25);
        label = [[UILabel alloc] initWithFrame:rect];
        [label setTextAlignment:UITextAlignmentCenter];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor colorWithWhite:0.5 alpha:1.0]];
        [label setText:@"to"];
        [self.joinerLabels addObject:label];
        [self addSubview:[self.joinerLabels objectAtIndex:i]];

        rect = CGRectMake((160+13), y, 50, 25);
        label = [[UILabel alloc] initWithFrame:rect];
        [label setTextAlignment:UITextAlignmentLeft];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor colorWithWhite:0.2 alpha:1.0]];
        [self.tAirportLabels addObject:label];
        [self addSubview:[self.tAirportLabels objectAtIndex:i]];
        
        rect = CGRectMake(self.bounds.size.width-80, y, 70, 25);
        label = [[UILabel alloc] initWithFrame:rect];
        [label setTextAlignment:UITextAlignmentRight];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:11]];
        [label setTextColor:[UIColor colorWithWhite:0.5 alpha:1.0]];
        [self.hopDurationLabels addObject:label];
        [self addSubview:[self.hopDurationLabels objectAtIndex:i]];
    }
    
    self.layoverNameLabels = [[NSMutableArray alloc] initWithCapacity:MAX_FLIGHT_STOPS-1];
    self.layoverDurationLabels = [[NSMutableArray alloc] initWithCapacity:MAX_FLIGHT_STOPS-1];
    
    for (int i = 0; i < MAX_FLIGHT_STOPS-1; i++)
    {
        int y = 65 + (i*50);

        rect = CGRectMake(38, y, 190, 25);
        UILabel *label = [[UILabel alloc] initWithFrame:rect];
        [label setTextAlignment:UITextAlignmentLeft];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setMinimumFontSize:10.0];
        [label setAdjustsFontSizeToFitWidth:YES];
        [label setTextColor:[UIColor colorWithWhite:0.5 alpha:1.0]];
        [self.layoverNameLabels addObject:label];
        [self addSubview:[self.layoverNameLabels objectAtIndex:i]];
        
        rect = CGRectMake(self.bounds.size.width-80, y, 70, 25);
        label = [[UILabel alloc] initWithFrame:rect];
        [label setTextAlignment:UITextAlignmentRight];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont systemFontOfSize:11]];
        [label setTextColor:[UIColor colorWithWhite:0.5 alpha:1.0]];
        [self.layoverDurationLabels addObject:label];
        [self addSubview:[self.layoverDurationLabels objectAtIndex:i]];
    }
}

-(void)setDisplaySingleIcon
{
    [self.secondAirlineIcon setHidden:YES];
}

-(void)setDisplayDoubleIcon
{
    [self.secondAirlineIcon setHidden:NO];
}

@end
