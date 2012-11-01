//
//  R2RInfoViewController.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 1/11/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface R2RInfoViewController : UIViewController <UITabBarDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

- (IBAction)sendFeedback:(id)sender;
- (IBAction)sendFeedbackMail:(id)sender;

@end
