//
//  R2RDataStore.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 2/11/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "R2RSearch.h"

#import "R2RGeoCodeResponse.h"
#import "R2RSearchResponse.h"
#import "R2RSpriteStore.h"

@interface R2RDataStore : NSObject

@property (strong, nonatomic) R2RSearchResponse *searchResponse;
@property (strong, nonatomic) R2RPlace *fromPlace;
@property (strong, nonatomic) R2RPlace *toPlace;
@property (strong, nonatomic) R2RSpriteStore *spriteStore;
@property (strong, nonatomic) NSString *statusMessage;

@end
