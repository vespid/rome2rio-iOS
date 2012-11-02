//
//  R2RInfoViewController.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 1/11/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "R2RInfoViewController.h"

@interface R2RInfoViewController ()

@end

@implementation R2RInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.feedbackTextView.clipsToBounds = YES;
    self.feedbackTextView.layer.cornerRadius = 10.0f;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setFeedbackTextView:nil];
    [super viewDidUnload];
}

- (IBAction)sendFeedback:(id)sender
{
    /* create mail subject */
    NSString *subject = [NSString stringWithFormat:@"Feedback"];
    
    /* define email address */
    NSString *mail = [NSString stringWithFormat:@"feedback@rome2rio.com"];
    
    NSString *body = self.feedbackTextView.text;
    
    /* create the URL */
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"mailto:?to=%@&subject=%@&body=%@",
                                                [mail stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
                                                [subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
                                                [body stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
    
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        /* load the URL */
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        //TODO status message? pissible only occurs on simulator with no email client
        R2RLog(@"email not available");
    }
}

- (IBAction)sendFeedbackMail:(id)sender
{
    
    /* create mail subject */
    NSString *subject = [NSString stringWithFormat:@"Feedback"];
    
    /* define email address */
    NSString *mail = [NSString stringWithFormat:@"feedback@rome2rio.com"];
    
    /* create the URL */
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"mailto:?to=%@&subject=%@",
                                                [mail stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
                                                [subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
    
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        /* load the URL */
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        //TODO status message? pissible only occurs on simulator with no email client
        R2RLog(@"email not available");
    }
}

- (IBAction)showMasterView:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UITextView Delegate

//TODO check for alternatives. (correct behaviour is done button elsewhere on screen?)
//trick way to hide the keyboard when return is pressed instead of nomral behaviour of going to new line
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

@end
