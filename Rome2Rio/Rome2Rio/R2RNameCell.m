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

@synthesize nameLabel;
//@synthesize nameLabel, icon, connectTop, connectBottom;


- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        //set static properties for cell
//        topConnection = [[UIView alloc] initWithFrame:CGRectMake(23, 0, 6, self.contentView.bounds.size.height/2)];
//        bottomConnection = [[UIView alloc] initWithFrame:CGRectMake(23, self.contentView.bounds.size.height/2, 6, self.contentView.bounds.size.height/2)];
//        
        
//        connectTop = [[R2RImageView alloc] initWithFrame:CGRectMake(23, 0, 6, self.contentView.bounds.size.height/2)];
//        [self.contentView addSubview:connectTop];
//        
//        connectBottom = [[R2RImageView alloc] initWithFrame:CGRectMake(23, self.contentView.bounds.size.height/2, 6, self.contentView.bounds.size.height/2)];
//        [self.contentView addSubview:connectBottom];
//        
//        icon = [[R2RImageView alloc] initWithFrame:CGRectMake(20, self.contentView.bounds.size.height/2-6, 12, 12)];
//        [icon setCroppedImage:[UIImage imageNamed:@"sprites6.png"] :CGRectMake(267, 46, 12, 12)];
//        
//        [self.contentView addSubview:icon];
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

@end
