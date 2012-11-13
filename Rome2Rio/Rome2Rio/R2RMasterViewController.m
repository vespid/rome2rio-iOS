//
//  R2RMasterViewController.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 6/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RMasterViewController.h"
#import "R2RResultsViewController.h"
#import "R2RMasterViewStatusButton.h"

#import "R2RConstants.h"

@interface R2RMasterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *fromTextField;
@property (weak, nonatomic) IBOutlet UITextField *toTextField;

@property (weak, nonatomic) IBOutlet UIView *headerBackground;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (strong, nonatomic) R2RMasterViewStatusButton *statusButton;

@property (nonatomic) BOOL textFieldDidClear;

- (IBAction)searchTouchUpInside:(id)sender;

@end

@implementation R2RMasterViewController

@synthesize dataStore, fromTextField, toTextField;

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    [self.view setBackgroundColor:[R2RConstants getBackgroundColor]];

    self.statusButton = [[R2RMasterViewStatusButton alloc] initWithFrame:CGRectMake(0.0, (self.view.frame.size.height-30), self.view.frame.size.width-30, 30.0)];

    [self.view addSubview:self.statusButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFromTextField:) name:@"refreshFromTextField" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshToTextField:) name:@"refreshToTextField" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshStatusMessage:) name:@"refreshStatusMessage" object:nil];
}

- (void)viewDidUnload
{
    [self setFromTextField:nil];
    [self setToTextField:nil];
    [self setHeaderBackground:nil];
    [self setHeaderImage:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshFromTextField" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshToTextField" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshStatusMessage" object:nil];
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ((textField == self.fromTextField) || (textField == self.toTextField))
    {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showSearchResults"])
    {
        R2RResultsViewController *resultsViewController = [segue destinationViewController];
        resultsViewController.dataManager = self.dataManager;
        resultsViewController.dataStore = self.dataStore;
    }
    
    if ([[segue identifier] isEqualToString:@"showAutocomplete"])
    {
        R2RAutocompleteViewController *autocompleteViewController = [segue destinationViewController];
        autocompleteViewController.dataManager = self.dataManager;
        autocompleteViewController.fieldName = sender;
    }
}

- (IBAction)searchTouchUpInside:(id)sender
{
    //If not geocoding or searching and there is no searchResponse restart process
    [self.dataManager restartSearchIfNoResponse];
    
    if ([self.dataManager canShowSearchResults])
        [self performSegueWithIdentifier:@"showSearchResults" sender:self];

}

-(void) refreshFromTextField:(NSNotification *) notification
{
    self.fromTextField.text = self.dataStore.fromPlace.longName;
}

-(void) refreshToTextField:(NSNotification *) notification
{
    self.toTextField.text = self.dataStore.toPlace.longName;
}

-(void) refreshStatusMessage:(NSNotification *) notification
{
    [self setStatusMessage:self.dataStore.statusMessage];
}

-(void) setStatusMessage: (NSString *) message
{
    [self.statusButton setTitle:message forState:UIControlStateNormal];
}

- (IBAction)showInfoView:(id)sender
{
    [self performSegueWithIdentifier:@"showInfo" sender:self];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (!self.textFieldDidClear)
    {
        if (textField == self.fromTextField)
        {
            [self performSegueWithIdentifier:@"showAutocomplete" sender:@"from"];
        }
        if (textField == self.toTextField)
        {
            [self performSegueWithIdentifier:@"showAutocomplete" sender:@"to"];
        }
    }
    self.textFieldDidClear = NO;
    return NO;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (textField == self.fromTextField)
    {
        [self.dataManager setFromPlace:nil];
        self.dataManager.fromText = nil;
    }
    if (textField == self.toTextField)
    {
        [self.dataManager setToPlace:nil];
        self.dataManager.toText = nil;
    }
    self.textFieldDidClear = YES;
    return YES;
}

@end
