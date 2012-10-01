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

@synthesize kindLabel;
@synthesize fromLabel;
@synthesize toLabel;
@synthesize lineLabel;
@synthesize durationLabel;
@synthesize agencyLabel;

@synthesize agencyIconView;

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

-(void)loadAgencyIcon:(NSString *)iconPath
{
    
    self.iconLoader = [[R2RIconLoader alloc] initWithIconPath:iconPath delegate:self];
    
}

-(void) R2RIconLoaded:(R2RIconLoader *)delegateIconLoader
{

    [self.agencyIconView setImage:delegateIconLoader.icon];

}

-(void) initAgencyIconView: (CGRect) rect
{
    self.agencyIconView = [[UIImageView alloc] initWithFrame:rect];
    [self addSubview:self.agencyIconView];
}

@end
