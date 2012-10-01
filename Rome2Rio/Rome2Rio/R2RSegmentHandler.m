//
//  R2RSegmentHandler.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 26/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RSegmentHandler.h"

@implementation R2RSegmentHandler

-(NSArray *) getTransitHops: (R2RTransitSegment *)segment
{
    if ([segment.itineraries count] >= 1)
    {
        R2RTransitItinerary *itinerary = [segment.itineraries objectAtIndex:0];
        if ([itinerary.legs count] >= 1)
        {
            R2RTransitLeg *leg = [itinerary.legs objectAtIndex:0];
            return leg.hops;
        }
    }
    
    return nil;
}

-(NSInteger) getTransitChanges:(R2RTransitSegment *)segment
{
    
    NSArray *hops = [self getTransitHops:segment];
    
    if ([hops count] > 1)
    {
        return ([hops count] -1);
    }

    return 0;
}

-(NSString *)getTransitVehicle:(R2RTransitSegment *)segment
{
    NSArray *hops = [self getTransitHops:segment];
    if (hops == nil)
    {
        return nil;
    }
    
    NSMutableArray *vehicles = [[NSMutableArray alloc] initWithCapacity:[hops count]];
    
    if ([vehicles count] > 1)
    {
        return segment.kind;
    }
    else
    {
        R2RTransitHop *hop = [hops objectAtIndex:0];
        NSMutableString *vehicle = [[NSMutableString alloc] init];
        if ([hops count] == 1 && ![hop.line isEqualToString:@""] && [hop.line integerValue] > 0)
        {
            [vehicle appendFormat:@"line %@ ", hop.line];
        }
        [vehicle appendFormat:@"%@", hop.vehicle];
        return vehicle;
    }
    
    return nil;
    
}

-(float) getTransitFrequency: (R2RTransitSegment *)segment
{
    NSArray *hops = [self getTransitHops:segment];
    if ([hops count] == 1)
    {
        R2RTransitHop *hop = [hops objectAtIndex:0];
        return hop.frequency;
    }
    return 0.0;
}

//-(NSString *)getFrequencyText: (R2RTransitSegment *)segment
//{
//    NSArray *hops = [self getTransitHops:segment];
//    NSInteger changes = [hops count] - 1;
//    
//    if (changes == 0)
//    {
//        return [NSString stringWithFormat:@"%@ by %@, %@", [self formatDuration:minutes], vehicle, [self formatFrequency:frequency]];
//    }
//    else if (changes == 1)
//    {
//        return [NSString stringWithFormat:@"%@ by %@, 1 change", [self formatDuration:minutes], vehicle];
//    }
//    else if (changes >= 2)
//    {
//        return [NSString stringWithFormat:@"%@ by %@, %d changes", [self formatDuration:minutes], vehicle, changes];
//    }
//    return nil;
//}


@end
