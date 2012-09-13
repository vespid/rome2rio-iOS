//
//  R2RTransitItinerary.h
//  HttpRequest
//
//  Created by Ash Verdoorn on 4/09/12.
//  Copyright (c) 2012 Ash Verdoorn. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "R2RTransitLeg.h"

@interface R2RTransitItinerary : NSObject

@property (strong, nonatomic) NSMutableArray *legs;

@end
