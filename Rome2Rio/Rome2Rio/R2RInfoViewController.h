//
//  R2RInfoViewController.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 1/11/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface R2RInfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;
@property (weak, nonatomic) IBOutlet UIButton *rateButton;
@property (weak, nonatomic) IBOutlet UIButton *shareEmailButton;

- (IBAction)sendFeedbackMail:(id)sender;
- (IBAction)rateApp:(id)sender;
- (IBAction)showMasterView:(id)sender;
- (IBAction)shareByEmail:(id)sender;

@end
