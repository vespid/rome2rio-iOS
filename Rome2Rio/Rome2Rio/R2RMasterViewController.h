//
//  R2RMasterViewController.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 6/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "R2RDataController.h"
#import "R2RAutocompleteViewController.h"

@interface R2RMasterViewController : UIViewController <UITextFieldDelegate, R2RAutocompleteViewControllerDelegate, UITabBarDelegate>

@property (strong, nonatomic) R2RDataController *dataController;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

@end	
