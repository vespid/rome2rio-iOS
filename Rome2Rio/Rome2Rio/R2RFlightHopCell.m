//
//  R2RFlightHopCell.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 14/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RFlightHopCell.h"
#import "R2RImageView.h"


@implementation R2RFlightHopCell

@synthesize hopLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
//        R2RImageView *view = [[R2RImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
//        [view setCroppedImage:[UIImage imageNamed:@"sprites6.png"] :CGRectMake(267, 46, 12, 12)];
//        [self setBackgroundColor:[UIColor blueColor]];
//        [self addSubview:view];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
