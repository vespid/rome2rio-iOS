//
//  R2RNameCell.h
//  R2RApp
//
//  Created by Ash Verdoorn on 7/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface R2RNameCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//@property (strong, nonatomic) UIView *topConnection;
//@property (strong, nonatomic) UIView *bottomConnection;
@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UIImageView *connectTop;
@property (strong, nonatomic) UIImageView *connectBottom;

@end
