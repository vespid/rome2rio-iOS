//
//  R2RResultsCell.h
//  R2RApp
//
//  Created by Ash Verdoorn on 7/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface R2RResultsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *routeNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeKindLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeDurationLabel;

@end
