//
//  R2RGeocodeData.h
//  HttpRequest
//
//  Created by Ash Verdoorn on 4/09/12.
//  Copyright (c) 2012 Ash Verdoorn. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "R2RPlace.h"

@interface R2RGeoCodeResponse : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *language;

// only ever use first result so no longer storing all results
//@property (strong, nonatomic) NSMutableArray *places;
@property (strong, nonatomic) R2RPlace *place;

@end
