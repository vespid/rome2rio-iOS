//
//  R2RFlightSegment.h
//  HttpRequest
//
//  Created by Ash Verdoorn on 4/09/12.
//  Copyright (c) 2012 Ash Verdoorn. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "R2RFlightItinerary.h"

@interface R2RFlightSegment : NSObject

@property (strong, nonatomic) NSString *kind;
@property (nonatomic) float distance;
@property (nonatomic) float duration;
@property (strong, nonatomic) NSString *sCode;
@property (strong, nonatomic) NSString *tCode;

@property (strong, nonatomic) NSMutableArray *itineraries;

@end
