//
//  R2RInfoViewController.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 1/11/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "R2RInfoViewController.h"
#import "R2RConstants.h"

@interface R2RInfoViewController ()

@end

@implementation R2RInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.versionLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Version %@", nil), [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [self.feedbackButton setTitle:NSLocalizedString(@"Send Feedback", nil) forState:UIControlStateNormal];
    [self.rateButton setTitle:NSLocalizedString(@"Rate App", nil) forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [self setVersionLabel:nil];
    [self setFeedbackButton:nil];
    [self setRateButton:nil];
    [self setShareEmailButton:nil];
    [super viewDidUnload];
}

- (IBAction)rateApp:(id)sender
{
    NSString *appId = [R2RConstants getAppId];

    NSURL *reviewURL = [NSURL URLWithString: [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appId]];
    
    if ([[UIApplication sharedApplication] canOpenURL:reviewURL])
    {
        [[UIApplication sharedApplication] openURL:reviewURL];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Could not start iTunes", nil)
                                                        message:NSLocalizedString(@"Please rate rome2rio in the iTunes store", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                              otherButtonTitles:nil];
        [alert show];
        R2RLog(@"App store not available");
    }
}

- (IBAction)sendFeedbackMail:(id)sender
{
    /* create mail subject */
    NSString *subject = [NSString stringWithFormat:@"iPhone App Feedback"];
    
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Could not start email client", nil)
                                                        message:NSLocalizedString(@"Please send feedback to feedback@rome2rio.com", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                              otherButtonTitles:nil];
        [alert show];
        R2RLog(@"Email not available");
    }
}

- (IBAction)showMasterView:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)shareByEmail:(id)sender
{
    NSString *subject = [NSString stringWithFormat:@"%@ iPhone App", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
    
    NSString *body = [NSString stringWithFormat:@"Check out the %@ App\n%@\n\n%@\n\nPowered by http://www.rome2rio.com\n\n",
                                        [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
                                        [R2RConstants getAppURL],
                                        [R2RConstants getAppDescription]];
    
    /* create the URL */
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"mailto:?subject=%@&body=%@",
                                       [subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
                                       [body stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
    
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        /* load the URL */
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Could not start email client", nil)
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                              otherButtonTitles:nil];
        [alert show];
        R2RLog(@"Email not available");
    }
    
    
}

@end
