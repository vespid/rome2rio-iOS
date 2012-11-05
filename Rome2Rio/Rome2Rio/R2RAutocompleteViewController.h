//
//  R2RAutocompleteViewController.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 31/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "R2RAutocomplete.h"
#import "R2RDataManager.h"

@protocol R2RAutocompleteViewControllerDelegate;

@interface R2RAutocompleteViewController : UITableViewController <UISearchBarDelegate, R2RAutocompleteDelegate>

//@property (strong, nonatomic) R2RDataController *dataController;

@property (strong, nonatomic) R2RDataManager *dataManager;

@property (weak, nonatomic) id <R2RAutocompleteViewControllerDelegate> delegate;
//@property (strong, nonatomic) UITextField *textField;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSString *fieldName;
@property (strong, nonatomic) IBOutlet UIView *statusView;

@end

@protocol R2RAutocompleteViewControllerDelegate <NSObject>

- (void)autocompleteViewControllerDidCancel:(R2RAutocompleteViewController *)controller;
//- (void)autocompleteViewControllerDidSelect:(R2RAutocompleteViewController *)controller selection:(NSString *)selection textField:(UITextField *)textField;

//- (void)autocompleteViewControllerDidSelectMyLocation:(R2RAutocompleteViewController *)controller textField:(UITextField *)textField;

- (void)autocompleteViewControllerDidSelect:(R2RAutocompleteViewController *)controller response:(R2RGeoCodeResponse *)geocodeResponse fieldName:(UITextField *)fieldName;


@end