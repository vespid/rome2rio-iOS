//
//  R2RNameCell.m
//  R2RApp
//
//  Created by Ash Verdoorn on 7/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RNameCell.h"
#import "R2RImageView.h"

@implementation R2RNameCell

//@synthesize nameLabel;
@synthesize nameLabel, icon, connectTop, connectBottom;


- (id) initWithCoder:(NSCoder *)aDecoder
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

- (void) initSubviews
{
    //set static properties for cell
    
    self.connectTop = [[UIImageView alloc] initWithFrame:CGRectMake(23, 0, 6, self.contentView.bounds.size.height/2)];
    [self.contentView addSubview:connectTop];
    
    self.connectBottom = [[UIImageView alloc] initWithFrame:CGRectMake(23, self.contentView.bounds.size.height/2, 6, self.contentView.bounds.size.height/2)];
    [self.contentView addSubview:connectBottom];
    
    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, self.contentView.bounds.size.height/2-6, 12, 12)];
    [self.contentView addSubview:icon];
}

@end
