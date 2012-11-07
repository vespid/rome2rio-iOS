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
@synthesize kind = _kind;
@synthesize coordinate = _coordinate;

- (id)initWithName:(NSString*)name kind:(NSString*)kind coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        _name = [name copy];
        
        //only display items before a ":"
        NSArray *kinds = [kind componentsSeparatedByString:@":"];
        _kind = [kinds objectAtIndex:0];
        R2RLog(@"%@", [kinds objectAtIndex:0]);
        
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
    return _kind;
}

@end
