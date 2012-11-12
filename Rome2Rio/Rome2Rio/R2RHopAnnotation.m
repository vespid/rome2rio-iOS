//
//  R2RHopAnnotation.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 9/11/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RHopAnnotation.h"

@implementation R2RHopAnnotation

@synthesize name = _name;
@synthesize coordinate = _coordinate;

- (id)initWithName:(NSString*)name coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        _name = [name copy];
        
        _coordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    if ([_name isKindOfClass:[NSNull class]])
        return @"Unknown charge";
    else
        return _name;
}

@end
