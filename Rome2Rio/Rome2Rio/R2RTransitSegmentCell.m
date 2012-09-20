//
//  R2RTransitSegmentCell.m
//  R2RApp
//
//  Created by Ash Verdoorn on 13/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RTransitSegmentCell.h"

@implementation R2RTransitSegmentCell
@synthesize kindLabel;
@synthesize fromLabel;
@synthesize toLabel;
@synthesize lineLabel;
@synthesize durationLabel;
@synthesize agencyLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
