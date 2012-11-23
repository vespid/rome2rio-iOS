//
//  R2RPressAnnotation.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 23/11/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RPressAnnotation.h"

@implementation R2RPressAnnotation

@synthesize name = _name;
@synthesize coordinate = _coordinate;

- (id)initWithName:(NSString*)name coordinate:(CLLocationCoordinate2D)coordinate
{
    if ((self = [super init]))
    {
        _name = [name copy];
       
        _coordinate = coordinate;
    }
    return self;
}

- (NSString *)title
{
    return _name;
}

-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    _coordinate = newCoordinate;
}

@end
