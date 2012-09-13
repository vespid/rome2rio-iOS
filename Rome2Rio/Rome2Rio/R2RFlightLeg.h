//
//  R2RFlightLeg.h
//  HttpRequest
//
//  Created by Ash Verdoorn on 4/09/12.
//  Copyright (c) 2012 Ash Verdoorn. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "R2RFlightHop.h"

@interface R2RFlightLeg : NSObject

@property (strong, nonatomic) NSMutableArray *hops;

@end
