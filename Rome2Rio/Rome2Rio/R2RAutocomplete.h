//
//  R2RAutocomplete.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 31/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "R2RConnection.h"
#import "R2RGeoCodeResponse.h"
#import "R2RPlace.h"

@protocol R2RAutocompleteDelegate;

@interface R2RAutocomplete : NSObject <CLLocationManagerDelegate>

@property (weak, nonatomic) id<R2RAutocompleteDelegate> delegate;
@property (strong, nonatomic) R2RGeoCodeResponse *geoCodeResponse;
@property (strong, nonatomic) NSString *searchString;
@property (nonatomic) NSInteger responseCompletionState;
@property (strong, nonatomic) NSString *responseMessage;

-(id) initWithSearch:(NSString *) query: (NSString *) country: (NSString *) language delegate:(id<R2RAutocompleteDelegate>)r2rGeoCoderDelegate;
-(id) initWithSearchString:(NSString *)initSearchString delegate:(id<R2RAutocompleteDelegate>)r2rGeoCoderDelegate;
-(void) sendAsynchronousRequest;
-(void) geocodeFallback:(NSString *)query;

enum {
    stateEmpty = 0,
    stateEditingDidBegin,
    stateEditingDidEnd,
    stateResolved,
    stateLocationNotFound,
    stateError,
    stateResolving
};

@end


@protocol R2RAutocompleteDelegate <NSObject>

- (void)autocompleteResolved:(R2RAutocomplete *) autocomplete;
//- (void)myLocationResolved:(R2RAutocomplete *) autocomplete;

@end