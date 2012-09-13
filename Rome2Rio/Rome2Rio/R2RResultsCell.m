//
//  R2RResultsCell.m
//  R2RApp
//
//  Created by Ash Verdoorn on 7/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RResultsCell.h"

@implementation R2RResultsCell

@synthesize routeNumberLabel;
@synthesize routeKindLabel;
@synthesize routeDurationLabel;


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

@end
