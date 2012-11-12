//
//  R2RMasterViewController.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 6/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "R2RAutocompleteViewController.h"

#import "R2RSearchStore.h"
#import "R2RSearchManager.h"

@interface R2RMasterViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) R2RSearchManager *dataManager;
@property (strong, nonatomic) R2RSearchStore *dataStore;

- (IBAction)showInfoView:(id)sender;

@end	
