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
@synthesize kind = _kind;
@synthesize coordinate = _coordinate;

- (id)initWithName:(NSString*)name kind:(NSString*)kind coordinate:(CLLocationCoordinate2D)coordinate
{
    if ((self = [super init]))
    {
        _name = [name copy];
        
        //only display items before the ":"
        NSArray *kinds = [kind componentsSeparatedByString:@":"];
        _kind = [kinds objectAtIndex:0];
        
        _coordinate = coordinate;
    }
    return self;
}

- (NSString *)title
{
    return _name;
}

- (NSString *)subtitle
{
    return _kind;
}

-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    _coordinate = newCoordinate;
}

@end
