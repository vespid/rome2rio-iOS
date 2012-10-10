//
//  r2rGeoCoder.h
//  HttpRequest
//
//  Created by Ash Verdoorn on 30/08/12.
//  Copyright (c) 2012 Ash Verdoorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "R2RConnection.h"
#import "R2RGeoCodeResponse.h"
#import "R2RPlace.h"

@protocol R2RGeoCoderDelegate;

@interface R2RGeoCoder : NSObject

@property (weak, nonatomic) id<R2RGeoCoderDelegate> delegate;
@property (strong, nonatomic) R2RGeoCodeResponse *geoCodeResponse;
@property (strong, nonatomic) NSString *searchString;
@property (nonatomic) NSInteger responseCompletionState;
@property (strong, nonatomic) NSString *responseMessage;

-(id) initWithSearch:(NSString *) query: (NSString *) country: (NSString *) language delegate:(id<R2RGeoCoderDelegate>)r2rGeoCoderDelegate;
-(id) initWithSearchString:(NSString *)initSearchString delegate:(id<R2RGeoCoderDelegate>)r2rGeoCoderDelegate;
-(void) sendAsynchronousRequest;

@end


@protocol R2RGeoCoderDelegate <NSObject>

- (void)R2RGeoCoderResolved:(R2RGeoCoder *)delegateGeoCoder;

@end