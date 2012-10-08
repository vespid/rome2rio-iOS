//
//  R2RFlightHopCell.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 14/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RFlightHopCell.h"


@implementation R2RFlightHopCell

@synthesize hopLabel, connectTop, connectBottom, icon;

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

- (void) initSubviews
{
    
    self.connectTop = [[UIImageView alloc] initWithFrame:CGRectMake(23, 0, 6, self.contentView.bounds.size.height/2)];
    [self.contentView addSubview:connectTop];
    
    self.connectBottom = [[UIImageView alloc] initWithFrame:CGRectMake(23, self.contentView.bounds.size.height/2, 6, self.contentView.bounds.size.height/2)];
    [self.contentView addSubview:connectBottom];
    
    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(17, self.contentView.bounds.size.height/2-9, 18, 18)];
    [self.contentView addSubview:icon];
    
//    [[cell hopLabel] setText:hopDescription];
//    
//    R2RImageView *connectTop = [[R2RImageView alloc] initWithFrame:CGRectMake(23, 0, 6, cell.contentView.bounds.size.height/2)];
//    [connectTop setCroppedImage:[UIImage imageNamed:@"ConnectionLines"] :lineRect];
//    [cell.contentView addSubview:connectTop];
//    
//    R2RImageView *connectBottom = [[R2RImageView alloc] initWithFrame:CGRectMake(23, cell.contentView.bounds.size.height/2, 6, cell.contentView.bounds.size.height/2)];
//    [connectBottom setCroppedImage:[UIImage imageNamed:@"ConnectionLines"] :lineRect];
//    [cell.contentView addSubview:connectBottom];
//    
//    //    NSLog(@"%f\t%f\t", cell.contentView.bounds.size.height, 0.0);
//    
//    R2RImageView *icon = [[R2RImageView alloc] initWithFrame:CGRectMake(17, cell.contentView.bounds.size.height/2-9, 18, 18)];
//    [icon setCroppedImage:[UIImage imageNamed:@"sprites6"] :iconRect];
//    [cell.contentView addSubview:icon];
}
@end
