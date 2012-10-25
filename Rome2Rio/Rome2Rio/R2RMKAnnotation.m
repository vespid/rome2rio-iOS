//
//  R2RMKAnnotation.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 15/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//


#import "R2RMKAnnotation.h"


@implementation R2RMKAnnotation 

@synthesize name = _name;
@synthesize address = _address;
@synthesize coordinate = _coordinate;

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        _name = [name copy];
        _address = [address copy];
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

- (NSString *)subtitle {
    return _address;
}

@end
