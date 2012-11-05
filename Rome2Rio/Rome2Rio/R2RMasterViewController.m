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

//- (IBAction)fromEditingDidBegin:(id)sender;
//- (IBAction)toEditingDidBegin:(id)sender;
- (IBAction)searchTouchUpInside:(id)sender;

enum R2RState
{
    IDLE = 0,
    RESOLVING_FROM,
    RESOLVING_TO,
    SEARCHING,
} ;

@end

@implementation R2RMasterViewController

@synthesize dataStore, fromTextField, toTextField;

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
//    [self setStatusMessage:self.dataController.statusMessage];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    
//    [self.toTextField resignFirstResponder];
//    [self.fromTextField resignFirstResponder];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    [self.view setBackgroundColor:[R2RConstants getBackgroundColor]];

    self.statusButton = [[R2RMasterViewStatusButton alloc] initWithFrame:CGRectMake(0.0, (self.view.frame.size.height-30), self.view.frame.size.width-30, 30.0)];

    [self.view addSubview:self.statusButton];
    
    
    //TODO 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resolvingFrom:) name:@"resolvingFrom" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resolvingTo:) name:@"resolvingTo" object:nil];
    
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"resolvingFrom" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"resolvingTo" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshFromTextField" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshToTextField" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshStatusMessage" object:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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
//        resultsViewController.dataController = self.dataController;
    }
    
    if ([[segue identifier] isEqualToString:@"showAutocomplete"])
    {
        R2RAutocompleteViewController *autocompleteViewController = [segue destinationViewController];
        autocompleteViewController.delegate = self;
//        autocompleteViewController.dataController = self.dataController;
        autocompleteViewController.dataManager = self.dataManager;
        autocompleteViewController.fieldName = sender; //TODO
       
    }
}

//- (IBAction)fromEditingDidBegin:(id)sender
//{
////    [self.dataController fromEditingDidBegin];
////    [self.fromTextField resignFirstResponder]; //TODO maybe change field to no longer be a text field so we don't have to worry about responder
////    
////    if ([self.fromTextField.text length] == 0) //TODO cheat to clear the place result if the clear button is pressed in master view 
////    {
////        [self.dataManager setFromPlace:nil];
////    }
////    
////    [self performSegueWithIdentifier:@"showAutocomplete" sender:@"from"];
//}
//
//- (IBAction)toEditingDidBegin:(UITextField *)sender
//{
////    [self.dataController toEditingDidBegin];
////    [self.toTextField resignFirstResponder]; //TODO maybe change field to no longer be a text field so we don't have to worry about responder
////    
////    if ([self.toTextField.text length] == 0) //TODO cheat to clear the place result if the clear button is pressed in master view
////    {
////        [self.dataManager setToPlace:nil];
//////        if ([sender] )
////    }
////    
////    [self performSegueWithIdentifier:@"showAutocomplete" sender:@"to"];
//}

- (IBAction)searchTouchUpInside:(id)sender
{
    //If not geocoding or searching and there is no searchResponse restart process
    [self.dataManager refreshSearchIfNoResponse];
    
    if ([self.dataManager canShowSearch])
        [self performSegueWithIdentifier:@"showSearchResults" sender:self];

}

- (void) warningMessage: (NSString *) message: (NSString *) textField
{
    [self setStatusMessage:message];
}

-(void) resolvingFrom:(NSNotification *) notification
{
//    [self.fromTextField setText:@""];
    self.fromTextField.placeholder = @"Finding current location";
}

-(void) resolvingTo:(NSNotification *) notification
{
    self.toTextField.placeholder = @"Finding current location";
}

-(void) refreshFromTextField:(NSNotification *) notification
{
    self.fromTextField.placeholder = @"Origin";
    self.fromTextField.text = self.dataStore.fromPlace.longName;
    
//    [self.fromTextField setPlaceholder:@"Origin"];
//    self.fromTextField.text = self.dataController.geoCoderFrom.geoCodeResponse.place.longName;
}

-(void) refreshToTextField:(NSNotification *) notification
{
    self.toTextField.placeholder = @"Destination";
    self.toTextField.text = self.dataStore.toPlace.longName;
//    self.toTextField.text = self.dataController.geoCoderTo.geoCodeResponse.place.longName;
    
}

-(void) refreshStatusMessage:(NSNotification *) notification
{
//    [self setStatusMessage:self.dataController.statusMessage];
}

-(void) setStatusMessage: (NSString *) message
{
    [self.statusButton setTitle:message forState:UIControlStateNormal];
}

- (void)autocompleteViewControllerDidCancel:(R2RAutocompleteViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)autocompleteViewControllerDidSelect:(R2RAutocompleteViewController *)controller response:(R2RGeoCodeResponse *)geocodeResponse fieldName:(NSString *)fieldName
{
//    [textField setText:geocodeResponse.place.longName];
//    if ([fieldName isEqualToString:@"from"]);
//    {
//        self.dataController.fromGeocodeResponse = geocodeResponse;
//        [self.dataController fromEditingDidEnd:self.fromTextField.text];
//    }
//    if ([fieldName isEqualToString:@"to"])
//    {
//        self.dataController.toGeocodeResponse = geocodeResponse;
//        [self.dataController toEditingDidEnd:self.toTextField.text];
//    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

//-(void)autocompleteViewControllerDidSelect:(R2RAutocompleteViewController *)controller selection:(NSString *)selection textField:(UITextField *)textField
//{
//    [textField setText:selection];
//    [self dismissViewControllerAnimated:YES completion:NULL];
//    
//    if (textField == self.fromTextField && [self.fromTextField.text length]> 0)
//    {
//        [self.dataController fromEditingDidEnd:self.fromTextField.text];
//    }
//    if (textField == self.toTextField && [self.toTextField.text length]> 0)
//    {
//        [self.dataController toEditingDidEnd:self.toTextField.text];
//    }
//}
//
//-(void)autocompleteViewControllerDidSelectMyLocation:(R2RAutocompleteViewController *)controller textField:(UITextField *)textField
//{
//    [textField setText:@""];
//    [textField setPlaceholder:@"Finding current location"];
//    [textField resignFirstResponder];
//
//    [self dismissViewControllerAnimated:YES completion:NULL];
//    
//    if (textField == self.fromTextField)
//    {
//        [self.dataController currentLocationTouchUpInside];
//    }
//    else if (textField == self.toTextField)
//    {
//        //[self.dataController.]
//    }
//    
//}

- (IBAction)showInfoView:(id)sender
{
    [self performSegueWithIdentifier:@"showInfo" sender:self];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.fromTextField)
    {
        [self performSegueWithIdentifier:@"showAutocomplete" sender:@"from"];
    }
    if (textField == self.toTextField)
    {
        [self performSegueWithIdentifier:@"showAutocomplete" sender:@"to"];
    }
    
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
    return YES;
    
}

@end
