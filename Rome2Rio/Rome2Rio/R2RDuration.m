//
//  R2RDuration.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 20/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RDuration.h"

@implementation R2RDuration

@synthesize totalMinutes = _totalMinutes;

-(id) initWithMinutes: (float) totalMinutes
{
    self = [super init];
    
    if (self != nil)
    {
        self.totalMinutes = (NSInteger)totalMinutes;
    }
    
    return self;
}

-(NSInteger) getDays
{
    return self.totalMinutes / (60*24);
}

-(NSInteger) getHours
{
    return self.totalHours % 24;
}

-(NSInteger) getMinutes
{
    return self.totalMinutes % 60;
}

-(NSInteger) getTotalHours
{
    return self.totalMinutes / 60;
}

@end
