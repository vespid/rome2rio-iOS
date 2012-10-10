//
//  R2RSegmentHandler.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 26/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RSegmentHandler.h"
#import "R2RSprite.h"

@implementation R2RSegmentHandler

-(BOOL) getSegmentIsMajor:(id) segment
{
    if([segment isKindOfClass:[R2RWalkDriveSegment class]])
    {
        R2RWalkDriveSegment *currentSegment = segment;
        return currentSegment.isMajor;
    }
    else if([segment isKindOfClass:[R2RTransitSegment class]])
    {
        R2RTransitSegment *currentSegment = segment;
        return currentSegment.isMajor;
    }
    else if([segment isKindOfClass:[R2RFlightSegment class]])
    {
        R2RFlightSegment *currentSegment = segment;
        return currentSegment.isMajor;
    }
    
    return NO;
}

-(NSString*) getSegmentKind:(id) segment
{
    if([segment isKindOfClass:[R2RWalkDriveSegment class]])
    {
        R2RWalkDriveSegment *currentSegment = segment;
        return currentSegment.kind;
    }
    else if([segment isKindOfClass:[R2RTransitSegment class]])
    {
        R2RTransitSegment *currentSegment = segment;
        return currentSegment.kind;
    }
    else if([segment isKindOfClass:[R2RFlightSegment class]])
    {
        R2RFlightSegment *currentSegment = segment;
        return currentSegment.kind;
    }
    
    return nil;
}

-(CGRect) getRouteIconRect: (NSString *) kind
{
    if ([kind isEqualToString:@"flight"])
    {
        return CGRectMake(0, 80, 18, 18);
    }
    else if ([kind isEqualToString:@"train"]/* || [kind isEqualToString:@"tram"]*/)
    {
        return CGRectMake(0, 98, 18, 18);
    }
    else if ([kind isEqualToString:@"bus"])
    {
        return CGRectMake(0, 188, 18, 18);
    }
    else if ([kind isEqualToString:@"ferry"])
    {
        return CGRectMake(0, 206, 18, 18);
    }
    else if ([kind isEqualToString:@"car"])
    {
        return CGRectMake(0, 152, 18, 18);
    }
    else if ([kind isEqualToString:@"walk"])
    {
        return CGRectMake(0, 224, 18, 18);
    }
    else
    {
        return CGRectMake(0, 170, 18, 18);
    }    
}

-(CGRect) getResultIconRect: (NSString *) kind
{
    if ([kind isEqualToString:@"flight"])
    {
        return CGRectMake(340, 60, 14, 12);
    }
    else if ([kind isEqualToString:@"train"])
    {
        return CGRectMake(354, 60, 19, 12);
    }
    else if ([kind isEqualToString:@"bus"])
    {
        return CGRectMake(384, 60, 18, 12);
    }
    else if ([kind isEqualToString:@"ferry"])
    {
        return CGRectMake(318, 60, 22, 12);
    }
    else if ([kind isEqualToString:@"car"])
    {
        return CGRectMake(300, 60, 18, 12);
    }
    else if ([kind isEqualToString:@"walk"])
    {
        return CGRectMake(402, 60, 14, 12);
    }
    else
    {
        return CGRectMake(373, 60, 11, 12);
    }

}

-(UIImage *) getSegmentResultIcon:(id)segment
{
    NSString *kind = [self getSegmentKind:segment];
    CGRect rect = [self getResultIconRect:kind];
    
    R2RSprite *iconSprite = [[R2RSprite alloc] initWithImage:[UIImage imageNamed:@"sprites6"]: rect];
    
    return iconSprite.sprite; //return just the correct subimage

}

-(UIImage *) getRouteIcon:(NSString *) kind
{

    CGRect rect = [self getRouteIconRect:kind];
    
    R2RSprite *iconSprite = [[R2RSprite alloc] initWithImage:[UIImage imageNamed:@"sprites6"]: rect];
    
    return iconSprite.sprite; //return just the correct subimage
    
}


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

-(NSInteger) getTransitHopCount:(R2RTransitSegment *)segment
{
    NSInteger hopCount = 0;

    if ([segment.itineraries count] >= 1)
    {
        R2RTransitItinerary *itinerary = [segment.itineraries objectAtIndex:0];
        for (R2RTransitLeg *leg in itinerary.legs)
        {
            hopCount += [leg.hops count];
        }
    }
    
    return hopCount;
}

-(NSInteger) getTransitChanges:(R2RTransitSegment *)segment
{
    NSInteger hopCount = [self getTransitHopCount:segment];
    return (hopCount - 1);//1 less change than hops;
}

//this used to contain overly complex code to return transit lines for detail view description
// but for consistency and room they have been removed from here and are only display in the actual transit segment
//-(NSString *)getTransitVehicle:(R2RTransitSegment *)segment
//{
//    NSArray *hops = [self getTransitHops:segment];
//    if (hops == nil)
//    {
//        return nil;
//    }
//    return segment.kind;
//}

-(float) getTransitFrequency: (R2RTransitSegment *)segment
{
    NSInteger hopCount = [self getTransitHopCount:segment];
    if (hopCount == 1)
    {
        R2RTransitItinerary *itinerary = [segment.itineraries objectAtIndex:0];
        R2RTransitLeg *transitLeg = [itinerary.legs objectAtIndex:0];
        R2RTransitHop *hop = [transitLeg.hops objectAtIndex:0];
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

- (UIImage *) getConnectionImage: (id) segment
{
    NSString *kind = [self getSegmentKind:segment];
    
    if ([kind isEqualToString:@"flight"])
    {
        CGPoint spriteOffset = CGPointMake(0, 0);
        CGSize spriteSize = CGSizeMake(10, 50);
        R2RSprite *connectionSprite = [[R2RSprite alloc] initWithImage:[UIImage imageNamed:@"ConnectionLines"] :spriteOffset :spriteSize];
        return connectionSprite.sprite;
    }
    if ([kind isEqualToString:@"train"])
    {
        CGPoint spriteOffset = CGPointMake(10, 0);
        CGSize spriteSize = CGSizeMake(10, 50);
        R2RSprite *connectionSprite = [[R2RSprite alloc] initWithImage:[UIImage imageNamed:@"ConnectionLines"] :spriteOffset :spriteSize];
        return connectionSprite.sprite;
    }
    else if ([kind isEqualToString:@"bus"])
    {
        CGPoint spriteOffset = CGPointMake(20, 0);
        CGSize spriteSize = CGSizeMake(10, 50);
        R2RSprite *connectionSprite = [[R2RSprite alloc] initWithImage:[UIImage imageNamed:@"ConnectionLines"] :spriteOffset :spriteSize];
        return connectionSprite.sprite;
    }
    else if ([kind isEqualToString:@"car"])
    {
        CGPoint spriteOffset = CGPointMake(30, 0);
        CGSize spriteSize = CGSizeMake(10, 50);
        R2RSprite *connectionSprite = [[R2RSprite alloc] initWithImage:[UIImage imageNamed:@"ConnectionLines"] :spriteOffset :spriteSize];
        return connectionSprite.sprite;
    }
    else if ([kind isEqualToString:@"ferry"])
    {
        CGPoint spriteOffset = CGPointMake(40, 0);
        CGSize spriteSize = CGSizeMake(10, 50);
        R2RSprite *connectionSprite = [[R2RSprite alloc] initWithImage:[UIImage imageNamed:@"ConnectionLines"] :spriteOffset :spriteSize];
        return connectionSprite.sprite;
    }
    else if ([kind isEqualToString:@"walk"])
    {
        CGPoint spriteOffset = CGPointMake(50, 0);
        CGSize spriteSize = CGSizeMake(10, 50);
        R2RSprite *connectionSprite = [[R2RSprite alloc] initWithImage:[UIImage imageNamed:@"ConnectionLines"] :spriteOffset :spriteSize];
        return connectionSprite.sprite;
    }
    CGPoint spriteOffset = CGPointMake(60, 0);
    CGSize spriteSize = CGSizeMake(10, 50);
    R2RSprite *connectionSprite = [[R2RSprite alloc] initWithImage:[UIImage imageNamed:@"ConnectionLines"] :spriteOffset :spriteSize];
    return connectionSprite.sprite;
}

-(NSInteger)getFlightChanges:(R2RFlightSegment *)segment
{
    int hops = 5;
    for (R2RFlightItinerary *itinerary in segment.itineraries)
    {
        for (R2RFlightLeg *leg in itinerary.legs)
        {
            if ([leg.hops count] < hops)
            {
                hops = [leg.hops count];
            }
        }
    }
    return (hops - 1); // 1 less change than hops
    
}

@end
