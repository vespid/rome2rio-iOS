//
//  R2RDataController.h
//  R2RApp
//
//  Created by Ash Verdoorn on 12/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "R2RGeoCoder.h"
#import "R2RSearch.h"
#import "R2RIconLoader.h"

@interface R2RDataController : NSObject <R2RGeoCoderDelegate, R2RSearchDelegate, CLLocationManagerDelegate/*, R2RIconLoaderDelegate*/>

@property (strong, nonatomic) R2RGeoCoder *geoCoderFrom;
@property (strong, nonatomic) R2RGeoCoder *geoCoderTo;
@property (strong, nonatomic) NSString *fromText;
@property (strong, nonatomic) NSString *toText;
@property (strong, nonatomic) R2RSearch *search;
@property (strong, nonatomic) NSString *statusMessage;
//@property (strong, nonatomic) NSString *statusMessageSender;
@property (nonatomic) NSInteger state;

//@property (strong, nonatomic) NSMutableDictionary *agencyIcons;

//@property (strong, nonatomic) NSMutableString *statusMessage;
//@property (strong, nonatomic) R2RStatusMessageController *statusMessageController;

-(void) geoCodeFromQuery:(NSString *)query;
-(void) geoCodeToQuery:(NSString *)query;
//-(void) clearGeoCoderFrom;
//-(void) clearGeoCoderTo;
//-(void) clearSearch;

- (void) refreshStatusMessage: (id) sender;
- (void) FromEditingDidBegin;
- (void) FromEditingDidEnd:(NSString *)query;
- (void) ToEditingDidBegin;
- (void) ToEditingDidEnd:(NSString *)query;
- (void) currentLocationTouchUpInside;
- (void) geoCodeFrom:(NSString *) query;


@end
