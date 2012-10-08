//
//  R2RMasterViewController.h
//  R2RApp
//
//  Created by Ash Verdoorn on 6/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "R2RDataController.h"
//#import "R2RGeoCoder.h"
//#import "R2RSearch.h"

@interface R2RMasterViewController : UIViewController <UITextFieldDelegate/*, R2RGeoCoderDelegate, R2RSearchDelegate*/>

@property R2RDataController *dataController;

@end	
