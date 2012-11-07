//
//  R2RMasterViewController.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 6/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "R2RAutocompleteViewController.h"

#import "R2RDataStore.h"
#import "R2RDataManager.h"

@interface R2RMasterViewController : UIViewController <UITextFieldDelegate, R2RAutocompleteViewControllerDelegate>

@property (strong, nonatomic) R2RDataManager *dataManager;
@property (strong, nonatomic) R2RDataStore *dataStore;

- (IBAction)showInfoView:(id)sender;

@end	
