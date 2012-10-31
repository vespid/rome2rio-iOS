//
//  R2RMasterViewController.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 6/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RMasterViewController.h"
#import "R2RResultsViewController.h"
#import "R2RStatusButton.h"

#import "R2RConstants.h"

@interface R2RMasterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *fromTextField;
@property (weak, nonatomic) IBOutlet UITextField *toTextField;

@property (weak, nonatomic) IBOutlet UIView *headerBackground;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (strong, nonatomic) R2RStatusButton *statusButton;

@property (nonatomic) BOOL keyboardShowing;

- (IBAction)fromEditingDidBegin:(id)sender;
- (IBAction)toEditingDidBegin:(id)sender;
- (IBAction)fromEditingDidEnd:(id)sender;
- (IBAction)toEditingDidEnd:(id)sender;
- (IBAction)searchTouchUpInside:(id)sender;
- (IBAction)currentLocationTouchUpInside:(id)sender;

enum R2RState
{
    IDLE = 0,
    RESOLVING_FROM,
    RESOLVING_TO,
    SEARCHING,
} ;

@end

@implementation R2RMasterViewController

@synthesize dataController, fromTextField, toTextField;

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    if (self.dataController.geoCoderFrom.geoCodeResponse.place.longName)
        self.fromTextField.text = self.dataController.geoCoderFrom.geoCodeResponse.place.longName;
    
    if (self.dataController.geoCoderTo.geoCodeResponse.place.longName)
        self.toTextField.text = self.dataController.geoCoderTo.geoCodeResponse.place.longName;
    
    [self setStatusMessage:self.dataController.statusMessage];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFromTextField:) name:@"refreshFromTextField" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshToTextField:) name:@"refreshToTextField" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshStatusMessage:) name:@"refreshStatusMessage" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    
	[self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.toTextField resignFirstResponder];
    [self.fromTextField resignFirstResponder];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshFromTextField" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshToTextField" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshStatusMessage" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    [self.view setBackgroundColor:[R2RConstants getBackgroundColor]];

    self.statusButton = [[R2RStatusButton alloc] initWithFrame:CGRectMake(0.0, (self.view.frame.size.height-30), self.view.frame.size.width, 30.0)];

    [self.view addSubview:self.statusButton];
}

- (void)viewDidUnload
{
    [self setFromTextField:nil];
    [self setToTextField:nil];
    [self setHeaderBackground:nil];
    [self setHeaderImage:nil];
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
        
        resultsViewController.dataController = self.dataController;
    }
}

#define kOFFSET_FOR_KEYBOARD 80.0

-(void)keyboardWillShow {
    // Animate the current view out of the way

    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    
    self.keyboardShowing = YES;
}

-(void)keyboardWillHide
{
    if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
    
    self.keyboardShowing = NO;
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    CGRect headerBackgroundRect = self.headerBackground.frame;
    CGRect headerImageRect = self.headerImage.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
        headerBackgroundRect.origin.y += kOFFSET_FOR_KEYBOARD;
        headerImageRect.origin.y += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
        headerBackgroundRect.origin.y -= kOFFSET_FOR_KEYBOARD;
        headerImageRect.origin.y -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    self.headerBackground.frame = headerBackgroundRect;
    self.headerImage.frame = headerImageRect;
    
    [UIView commitAnimations];
}

- (IBAction)fromEditingDidBegin:(id)sender
{
    [self.dataController fromEditingDidBegin];
}

- (IBAction)toEditingDidBegin:(id)sender
{
    [self.dataController toEditingDidBegin];
}

- (IBAction)fromEditingDidEnd:(id)sender
{
    if ([self.fromTextField.text length]> 0)
    {
        [self.dataController fromEditingDidEnd:self.fromTextField.text];
    }
}

- (IBAction)toEditingDidEnd:(id)sender
{
    if ([self.toTextField.text length]> 0)
    {
        [self.dataController toEditingDidEnd:self.toTextField.text];
    }
}

- (IBAction)searchTouchUpInside:(id)sender
{
    [self.toTextField resignFirstResponder];
    [self.fromTextField resignFirstResponder];
    
    if ([self.fromTextField.text length] == 0)
    { 
        [self warningMessage:@"Please enter origin":@"from"];
        return;
    }
    if ([self.toTextField.text length] == 0)
    {
        [self warningMessage:@"Please enter destination":@"to"];
        return;
    }
    
    //If not geocoding or searching and there is no searchResponse restart process
    [self.dataController refreshSearchIfNoResponse];
    
    [self performSegueWithIdentifier:@"showSearchResults" sender:self];
    
}

- (IBAction) currentLocationTouchUpInside:(id)sender
{

    [self.fromTextField setText:@""];    
    [self.fromTextField setPlaceholder:@"Finding current location"];
    [self.fromTextField resignFirstResponder];
    
    [self.dataController currentLocationTouchUpInside];
}

- (void) warningMessage: (NSString *) message: (NSString *) textField
{
    [self setStatusMessage:message];
}

-(void) refreshFromTextField:(NSNotification *) notification
{
    [self.fromTextField setPlaceholder:@"Origin"];
    self.fromTextField.text = self.dataController.geoCoderFrom.geoCodeResponse.place.longName;
}

-(void) refreshToTextField:(NSNotification *) notification
{
    self.toTextField.text = self.dataController.geoCoderTo.geoCodeResponse.place.longName;
}

-(void) refreshStatusMessage:(NSNotification *) notification
{
    [self setStatusMessage:self.dataController.statusMessage];
}

-(void) setStatusMessage: (NSString *) message
{
    [self.statusButton setTitle:message forState:UIControlStateNormal];
}

@end
