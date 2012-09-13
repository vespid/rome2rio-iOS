//
//  R2RTransitSegmentView.h
//  R2RApp
//
//  Created by Ash Verdoorn on 13/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface R2RTransitSegmentView : UIView

@property (strong, nonatomic) NSString *kind;
@property (strong, nonatomic) NSString *from;
@property (strong, nonatomic) NSString *to;
@property (strong, nonatomic) NSString *duration;
@property (strong, nonatomic) NSString *line;

@end
