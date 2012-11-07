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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (IBAction)rateApp:(id)sender
{
    NSString *appId = @"569793256";

    NSURL *reviewURL = [NSURL URLWithString: [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appId]];
    
    if ([[UIApplication sharedApplication] canOpenURL:reviewURL])
    {
        [[UIApplication sharedApplication] openURL:reviewURL];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not start iTunes"
                                                        message:@"Please rate rome2rio in the iTunes store"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        R2RLog(@"App store not available");
    }
}

- (IBAction)sendFeedbackMail:(id)sender
{
    /* create mail subject */
    NSString *subject = [NSString stringWithFormat:@"Feedback"];
    
    /* define email address */
    NSString *mail = [NSString stringWithFormat:@"feedback@rome2rio.com"];
    
    /* create the URL */
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"mailto:?to=%@&subject=%@",
                                                [mail stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
                                                [subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
    
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        /* load the URL */
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not start email client"
                                                             message:@"Please send feedback to feedback@rome2rio.com"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [alert show];
        R2RLog(@"Email not available");
    }
}

- (IBAction)showMasterView:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
