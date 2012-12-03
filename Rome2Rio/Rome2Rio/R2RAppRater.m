//
//  R2RAppRater.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 3/12/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//


#import "R2RAppRater.h"
#import "R2RConstants.h"

static NSInteger usesUntilPrompt = 2;
//static NSInteger daysUntilPrompt = 1;
//static NSInteger daysUntilReminder = 1;
static float daysUntilPrompt = 0.001;
static float daysUntilReminder = 0.001;

@implementation R2RAppRater

-(void) appStarted
{
    [self incrementUse];
    
    if ([self canShowRatePrompt])
    {
        [self showRatePrompt];
    }
}

-(void) incrementUse
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //can add version number if rating is desired for each version
    
    NSString *appName = [userDefaults stringForKey:@"R2RAppName"];
    
    if (appName == nil)
    {
        appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
        [userDefaults setObject:appName forKey:@"R2RAppName"];
        [userDefaults setDouble:[[NSDate date] timeIntervalSince1970] forKey:@"R2RFirstUseTimeInterval"];
        [userDefaults setInteger:1 forKey:@"R2RUseCount"];
        [userDefaults setBool:NO forKey:@"R2RDidRate"];
        [userDefaults setBool:NO forKey:@"R2RDeclinedToRate"];
        [userDefaults setDouble:0.0 forKey:@"R2RReminderTimeInterval"];
    }
    else
    {
        //make sure a date is set
        NSTimeInterval timeInterval = [userDefaults doubleForKey:@"R2RFirstUseTimeInterval"];
		if (timeInterval == 0)
		{
			timeInterval = [[NSDate date] timeIntervalSince1970];
			[userDefaults setDouble:timeInterval forKey:@"R2RFirstUseTimeInterval"];
		}
        
        int count = [userDefaults integerForKey:@"R2RUseCount"];
		count++;
		[userDefaults setInteger:count forKey:@"R2RUseCount"];

    }
    
    [userDefaults synchronize];
}

-(bool) canShowRatePrompt
{
//    if (DEBUG)
//		return YES;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    bool userDidRate = [userDefaults boolForKey:@"R2RDidRate"];
    R2RLog(@"%i", userDidRate);
    if (userDidRate) return NO;
    
    bool userDeclinedToRate = [userDefaults boolForKey:@"R2RDeclinedToRate"];
    R2RLog(@"%i", userDeclinedToRate);
    if (userDeclinedToRate) return NO;
    
    int useCount = [userDefaults integerForKey:@"R2RUseCount"];
    R2RLog(@"%d", useCount);
	if (useCount <= usesUntilPrompt) return NO;

    NSTimeInterval firstUseTimeInterval = [userDefaults doubleForKey:@"R2RFirstUseTimeInterval"];
    NSTimeInterval timeIntervalUntilNow = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval timeUntilPrompt = 60 * 60 * 24 * daysUntilPrompt;
    R2RLog(@"%f\t%f\t%f\t%f", firstUseTimeInterval, timeUntilPrompt, timeIntervalUntilNow, (firstUseTimeInterval + timeUntilPrompt) - timeIntervalUntilNow);
    if (firstUseTimeInterval + timeUntilPrompt > timeIntervalUntilNow) return NO;
    
    NSTimeInterval reminderTimeInterval = [userDefaults doubleForKey:@"R2RReminderTimeInterval"];
    NSTimeInterval timeUntilReminder = 60 * 60 * 24 * daysUntilReminder;
    R2RLog(@"%f\t%f\t%f\t%f", reminderTimeInterval, timeUntilReminder, timeIntervalUntilNow, (reminderTimeInterval + timeUntilReminder) - timeIntervalUntilNow);
    if (reminderTimeInterval + timeUntilReminder > timeIntervalUntilNow) return NO;
    
    // return yes if all conditions are passed
    return YES;
}

-(void) showRatePrompt
{
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    NSString *title = [NSString stringWithFormat:@"Rate %@", appName];
    NSString *message = [NSString stringWithFormat:@"If you enjoy using %@, please take a moment to rate it", appName];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"No thanks"
                                              otherButtonTitles:title, @"Remind me later", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
	switch (buttonIndex)
    {
		case 0:
            // "No Thanks"
            [userDefaults setBool:YES forKey:@"R2RDeclinedToRate"];
			[userDefaults synchronize];
            break;
            
		case 1:
			// "Rate App"
			[self rateApp];
			break;
            
		case 2:
        	// "Remind me later"
			[userDefaults setDouble:[[NSDate date] timeIntervalSince1970] forKey:@"R2RReminderTimeInterval"];
			[userDefaults synchronize];
			break;
            
        default:
			break;
	}
    
}

-(void) rateApp
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

@end
