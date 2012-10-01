//
//  R2RTransitSegmentCell.h
//  R2RApp
//
//  Created by Ash Verdoorn on 13/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "R2RIconLoader.h"

@interface R2RTransitSegmentCell : UITableViewCell <R2RIconLoaderDelegate>

@property (weak, nonatomic) IBOutlet UILabel *kindLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *toLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UILabel *agencyLabel;

@property (strong, nonatomic) UIImageView *agencyIconView;

-(void) initAgencyIconView: (CGRect) rect;
-(void) loadAgencyIcon: (NSString *) iconPath;

@end
