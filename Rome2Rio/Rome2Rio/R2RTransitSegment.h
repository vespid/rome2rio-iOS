//
//  R2RTransitSegment.h
//  HttpRequest
//
//  Created by Ash Verdoorn on 4/09/12.
//  Copyright (c) 2012 Ash Verdoorn. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "R2RPosition.h"
#import "R2RTransitItinerary.h"

@interface R2RTransitSegment : NSObject

@property (strong, nonatomic) NSString *kind;
@property (nonatomic) float distance;
@property (nonatomic) float duration;
@property (strong, nonatomic) NSString *sName;
@property (strong, nonatomic) R2RPosition *sPos;
@property (strong, nonatomic) NSString *tName;
@property (strong, nonatomic) R2RPosition *tPos;
@property (nonatomic) BOOL isMajor;
@property (strong, nonatomic) NSString *vehicle;
@property (strong, nonatomic) NSString *path;

@property (strong, nonatomic) NSMutableArray *itineraries;

@end
