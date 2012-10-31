//
//  R2RDataController.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 12/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "R2RGeoCoder.h"
#import "R2RSearch.h"
#import "R2RSpriteStore.h"

@interface R2RDataController : NSObject <R2RGeoCoderDelegate, R2RSearchDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) R2RGeoCoder *geoCoderFrom;
@property (strong, nonatomic) R2RGeoCoder *geoCoderTo;
@property (strong, nonatomic) NSString *fromText;
@property (strong, nonatomic) NSString *toText;
@property (strong, nonatomic) R2RSearch *search;
@property (strong, nonatomic) NSString *statusMessage;
@property (nonatomic) NSInteger state;
@property (strong, nonatomic) R2RSpriteStore *spriteStore;

-(void) geoCodeFromQuery:(NSString *)query;
-(void) geoCodeToQuery:(NSString *)query;

- (void) refreshStatusMessage: (id) sender;
- (void) refreshSearchIfNoResponse;
- (void) fromEditingDidBegin;
- (void) fromEditingDidEnd:(NSString *)query;
- (void) toEditingDidBegin;
- (void) toEditingDidEnd:(NSString *)query;
- (void) currentLocationTouchUpInside;

- (BOOL) isGeocoderResolved:(R2RGeoCoder *) geocoder;

@end
