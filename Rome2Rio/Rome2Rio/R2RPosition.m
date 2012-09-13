//
//  R2RPosition.m
//  HttpRequest
//
//  Created by Ash Verdoorn on 31/08/12.
//  Copyright (c) 2012 Ash Verdoorn. All rights reserved.
//

#import "R2RPosition.h"

@implementation R2RPosition

@synthesize lat, lng;

- (NSString *)description 
{
	return [NSString stringWithFormat: @"%f, %f", self.lat, self.lng];
}

@end
