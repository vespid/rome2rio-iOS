//
//  R2RTransitSchedulesViewController.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 7/02/13.
//  Copyright (c) 2013 Rome2Rio. All rights reserved.
//

#import "R2RTransitSchedulesViewController.h"

@interface R2RTransitSchedulesViewController ()

@end

@implementation R2RTransitSchedulesViewController

@synthesize schedulesURL;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:schedulesURL];
    
    //Load the request in the UIWebView.
    [self.webView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [self setBack:nil];
    [self setForward:nil];
    [self setRefresh:nil];
    [self setOpenExternal:nil];
    [super viewDidUnload];
}
- (IBAction)openInBrowser:(id)sender {
}
@end
