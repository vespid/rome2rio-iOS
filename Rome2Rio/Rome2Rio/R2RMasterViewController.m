//
//  R2RMasterViewController.m
//  R2RApp
//
//  Created by Ash Verdoorn on 6/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RMasterViewController.h"
#import "R2RDetailViewController.h"
#import "R2RResultsViewController.h"
#import "R2RStatusButton.h"

#import "R2RImageView.h"

@interface R2RMasterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *fromTextField;
@property (weak, nonatomic) IBOutlet UITextField *toTextField;

@property (weak, nonatomic) IBOutlet UIView *headerBackground;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (strong, nonatomic) R2RStatusButton *statusButton;

@property (nonatomic) BOOL keyboardShowing;

- (IBAction)FromEditingDidBegin:(id)sender;
- (IBAction)ToEditingDidBegin:(id)sender;
- (IBAction)FromEditingDidEnd:(id)sender;
- (IBAction)ToEditingDidEnd:(id)sender;
- (IBAction)SearchTouchUpInside:(id)sender;
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


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
//        self.keyboardShowing = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    if (self.dataController.geoCoderFrom.geoCodeResponse.place.longName)
        self.fromTextField.text = self.dataController.geoCoderFrom.geoCodeResponse.place.longName;
    
    if (self.dataController.geoCoderTo.geoCodeResponse.place.longName)
        self.toTextField.text = self.dataController.geoCoderTo.geoCodeResponse.place.longName;
    
    [self setStatusMessage:self.dataController.statusMessage];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
//    self.keyboardShowing = NO;
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
 
    [self.view setBackgroundColor:[UIColor colorWithRed:234.0/256.0 green:228.0/256.0 blue:224.0/256.0 alpha:1.0]];

    self.statusButton = [[R2RStatusButton alloc] initWithFrame:CGRectMake(0.0, (self.view.bounds.size.height-30), self.view.bounds.size.width, 30.0)];

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

- (IBAction)FromEditingDidBegin:(id)sender
{
    [self.dataController FromEditingDidBegin];
}

- (IBAction)ToEditingDidBegin:(id)sender
{
    [self.dataController ToEditingDidBegin];
}

- (IBAction)FromEditingDidEnd:(id)sender
{
    if ([self.fromTextField.text length]> 0)
    {
        [self.dataController FromEditingDidEnd:self.fromTextField.text];
    }
}

- (IBAction)ToEditingDidEnd:(id)sender
{
    if ([self.toTextField.text length]> 0)
    {
        [self.dataController ToEditingDidEnd:self.toTextField.text];
    }
}

- (IBAction)SearchTouchUpInside:(id)sender
{
    [self.toTextField resignFirstResponder];
    [self.fromTextField resignFirstResponder];
    
    if ([self.fromTextField.text length] == 0)
    { 
        [self WarningMessage:@"Please enter origin":@"from"];        
        return;
    }
    if ([self.toTextField.text length] == 0)
    {
        [self WarningMessage:@"Please enter destination":@"to"];
        return;
    }
    
    //If not geocoding or searching and there is no searchResponse restart process
    [self.dataController refreshSearchIfNoResponse];
    
    [self performSegueWithIdentifier:@"showSearchResults" sender:self];
    
}

- (IBAction)currentLocationTouchUpInside:(id)sender
{

    [self.fromTextField setText:@""];    
    [self.fromTextField setPlaceholder:@"Finding current location"];
    [self.fromTextField resignFirstResponder];
    
    [self.dataController currentLocationTouchUpInside];
}

- (void)WarningMessage: (NSString *) message: (NSString *) textField
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
    //TODO
    //added this to have a selector for setting message to nil.
    //will probably change when resolving of multiple messages is sorted
    
    
    [self.statusButton setTitle:message forState:UIControlStateNormal];
    //-(void) setStatusMessage {
    //[self.statusButton setTitle:self.dataController.statusMessage forState:UIControlStateNormal];
    //}
}

-(void) setStatusMessage: (NSString *) message: (NSString *) sender
{
    //added this to have a selector for setting message to nil.
    //will probably change when resolving of multiple messages is sorted

    [self.statusButton setTitle:message forState:UIControlStateNormal];

}


@end
