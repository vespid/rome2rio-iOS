//
//  R2RDuration.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 20/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RDuration.h"

@interface R2RDuration()

//@property (strong, nonatomic) NSNumber *totalMinutes;

@end

@implementation R2RDuration

@synthesize days, hours, minutes, totalHours, totalMinutes;

-(id) initWithMinutes: (float) initMinutes
{
    self = [super init];
    
    if (self != nil)
    {
        NSNumber *inputMinutes = [[NSNumber alloc] initWithFloat:initMinutes];
        [self convertMinutes:inputMinutes];
    }
    
    return self;
}

-(void) convertMinutes: (NSNumber *) inputMinutes
{
    NSInteger remainingMinutes = [inputMinutes intValue];
    
    self.totalMinutes = remainingMinutes;
    self.totalHours = remainingMinutes / 60;
    
    self.days = remainingMinutes / (60*24);
    
    remainingMinutes = remainingMinutes % (60*24);
    
    self.hours = remainingMinutes / 60;
    
    self.minutes = remainingMinutes % 60;
    
//    NSLog(@"in %@\tdays %d\thours %d\tminutes %d", inputMinutes, self.days, self.hours, self.minutes);
}

//-(NSString *) durationString
//{
//    NSMutableString *string = [[NSMutableString alloc] init];
//    
//    if (self.days > 0)
//    {
//        [string appendFormat:@"%d days,", self.days];
//    }
//    if (self.hours > 0)
//    {
//        [string appendFormat:@" %d hours,", self.hours];
//    }
//    if (self.minutes > 0)
//    {
//        [string appendFormat:@" %d minutes", self.minutes];
//    }
//    
//    return string;
//}

@end
