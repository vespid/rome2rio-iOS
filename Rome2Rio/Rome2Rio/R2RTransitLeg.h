//
//  R2RTransitLeg.h
//  HttpRequest
//
//  Created by Ash Verdoorn on 4/09/12.
//  Copyright (c) 2012 Ash Verdoorn. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "R2RTransitHop.h"

@interface R2RTransitLeg : NSObject

@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSMutableArray *hops;

@end
