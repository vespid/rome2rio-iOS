//
//  R2RAutocompleteViewController.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 31/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "R2RAutocomplete.h"

@protocol R2RAutocompleteViewControllerDelegate;

@interface R2RAutocompleteViewController : UITableViewController <UISearchBarDelegate, R2RAutocompleteDelegate>

//@property (strong, nonatomic) R2RDataController *dataController;

@property (weak, nonatomic) id <R2RAutocompleteViewControllerDelegate> delegate;
@property (strong, nonatomic) UITextField *textField;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@protocol R2RAutocompleteViewControllerDelegate <NSObject>

- (void)autocompleteViewControllerDidCancel:(R2RAutocompleteViewController *)controller;
- (void)autocompleteViewControllerDidSelect:(R2RAutocompleteViewController *)controller selection:(NSString *)selection textField:(UITextField *)textField;
- (void)autocompleteViewControllerDidSelectMyLocation:(R2RAutocompleteViewController *)controller textField:(UITextField *)textField;

@end