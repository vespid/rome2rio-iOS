//
//  R2RStatusButton.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 18/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RStatusButton.h"

@implementation R2RStatusButton


- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self != nil)
    {
        self.titleLabel.font = [UIFont boldSystemFontOfSize:20.];
        self.titleLabel.textAlignment = UITextAlignmentCenter;
        //button.hidden = false;
        
        //[self setHidden:false];
        [self setHidden:true];
        [self setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.7]];
//        [self setBackgroundColor:[UIColor colorWithRed:(25/255.0) green:(25/255.0) blue:(25/255.0) alpha:0.8]];
//        [self setBackgroundColor:[UIColor darkGrayColor]];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    
    return self;
}

//+ (id)buttonWithType:(UIButtonType)buttonType
//{
//    UIButton *button = [UIButton buttonWithType:buttonType];
//    if (button != nil)
//    {
//        
//        [button setFrame: CGRectMake(0, 360, 320, 30.0)];
//        
//        //[button setFrame: CGRectMake(10, 10, 200, 50)];
//        // do own config
//        
//        button.titleLabel.font = [UIFont boldSystemFontOfSize:20.];
//        button.titleLabel.textAlignment = UITextAlignmentCenter;
//        //button.hidden = false;
//        
//        [button setHidden:false];
//        //[button setHidden:true];
//        [button setBackgroundColor:[UIColor darkGrayColor]];
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        
//        //[button setTitle:@"hi ................." forState:UIControlStateNormal];
//        
//        //self.text = [NSString stringWithFormat:@"%s", "hello world"];
//        
//        //
//    }
//
//    return button;
//}

- (void) setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    if ([title length] == 0)
    {
        self.hidden = true;
    }
    else
    {
        self.hidden = false;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
