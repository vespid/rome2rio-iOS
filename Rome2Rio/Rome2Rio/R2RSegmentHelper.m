//
//  R2RSegmentHandler.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 26/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RSegmentHelper.h"
#import "R2RConstants.h"

@interface R2RSegmentHelper()

@property (strong, nonatomic) R2RSearchStore *dataStore;

@end

@implementation R2RSegmentHelper

-(id)initWithData:(R2RSearchStore *)dataStore
{
    self = [super init];
    if (self)
    {
        self.dataStore = dataStore;
    }
    return self;
}

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

-(NSString*) getSegmentPath:(id)segment
{
    if([segment isKindOfClass:[R2RWalkDriveSegment class]])
    {
        R2RWalkDriveSegment *currentSegment = segment;
        return currentSegment.path;
    }
    else if([segment isKindOfClass:[R2RTransitSegment class]])
    {
        R2RTransitSegment *currentSegment = segment;
        return currentSegment.path;
    }
    else if([segment isKindOfClass:[R2RFlightSegment class]])
    {
        return nil;
    }
    
    return nil;
}

//used to return start coordinate for any segment including flights
-(R2RPosition *) getSegmentSPos:(id) segment
{
    if([segment isKindOfClass:[R2RWalkDriveSegment class]])
    {
        R2RWalkDriveSegment *currentSegment = (R2RWalkDriveSegment *)segment;
        return currentSegment.sPos;
    }
    else if([segment isKindOfClass:[R2RTransitSegment class]])
    {
        R2RTransitSegment *currentSegment = (R2RTransitSegment *)segment;
        return currentSegment.sPos;
    }
    else if([segment isKindOfClass:[R2RFlightSegment class]])
    {
        R2RFlightSegment *currentSegment = (R2RFlightSegment *)segment;
        R2RFlightItinerary *itinerary = [currentSegment.itineraries objectAtIndex:0];
        R2RFlightLeg *leg = [itinerary.legs objectAtIndex:0];
        R2RFlightHop *hop = [leg.hops objectAtIndex:0];
        R2RAirport *airport = [self.dataStore getAirport:hop.sCode];
        
        return airport.pos;
    }
    
    return nil;
}

//used to return end coordinate for any segment including flights
-(R2RPosition *) getSegmentTPos:(id) segment
{
    if([segment isKindOfClass:[R2RWalkDriveSegment class]])
    {
        R2RWalkDriveSegment *currentSegment = (R2RWalkDriveSegment *)segment;
        return currentSegment.tPos;
    }
    else if([segment isKindOfClass:[R2RTransitSegment class]])
    {
        R2RTransitSegment *currentSegment = (R2RTransitSegment *)segment;
        return currentSegment.tPos;
    }
    else if([segment isKindOfClass:[R2RFlightSegment class]])
    {
        R2RFlightSegment *currentSegment = (R2RFlightSegment *)segment;
        R2RFlightItinerary *itinerary = [currentSegment.itineraries objectAtIndex:0];
        R2RFlightLeg *leg = [itinerary.legs objectAtIndex:0];
        R2RFlightHop *hop = [leg.hops lastObject];
        R2RAirport *airport = [self.dataStore getAirport:hop.tCode];
        
        return airport.pos;
    }
    
    return nil;
}

-(CGRect) getRouteIconRect: (NSString *) kind
{
    if ([kind isEqualToString:@"flight"])
    {
        return [R2RConstants getRouteFlightSpriteRect];
    }
    else if ([kind isEqualToString:@"train"])
    {
        return [R2RConstants getRouteTrainSpriteRect];
    }
    else if ([kind isEqualToString:@"bus"])
    {
        return [R2RConstants getRouteBusSpriteRect];
    }
    else if ([kind isEqualToString:@"ferry"])
    {
        return [R2RConstants getRouteFerrySpriteRect];
    }
    else if ([kind isEqualToString:@"car"])
    {
        return [R2RConstants getRouteCarSpriteRect];
    }
    else if ([kind isEqualToString:@"walk"])
    {
        return [R2RConstants getRouteWalkSpriteRect];
    }
    else
    {
        return [R2RConstants getRouteUnknownSpriteRect];
    }
}

-(CGRect) getResultIconRect: (NSString *) kind
{
    if ([kind isEqualToString:@"flight"])
    {
        return [R2RConstants getResultFlightSpriteRect];
    }
    else if ([kind isEqualToString:@"train"])
    {
        return [R2RConstants getResultTrainSpriteRect];
    }
    else if ([kind isEqualToString:@"bus"])
    {
        return [R2RConstants getResultBusSpriteRect];
    }
    else if ([kind isEqualToString:@"ferry"])
    {
        return [R2RConstants getResultFerrySpriteRect];
    }
    else if ([kind isEqualToString:@"car"])
    {
        return [R2RConstants getResultCarSpriteRect];
    }
    else if ([kind isEqualToString:@"walk"])
    {
        return [R2RConstants getResultWalkSpriteRect];
    }
    else
    {
        return [R2RConstants getResultUnknownSpriteRect];
    }
}

-(R2RSprite *) getSegmentResultSprite:(id)segment
{
    NSString *kind = [self getSegmentKind:segment];
    return [self getResultSprite:kind];
}

-(R2RSprite *) getResultSprite:(NSString *)kind
{
    CGRect rect = [self getResultIconRect:kind];
    R2RSprite *sprite = [[R2RSprite alloc] initWithPath:[R2RConstants getIconSpriteFileName] :rect.origin :rect.size];
    return sprite;
}

-(R2RSprite *) getRouteSprite:(NSString *)kind
{
    CGRect rect = [self getRouteIconRect:kind];
    R2RSprite *sprite = [[R2RSprite alloc] initWithPath:[R2RConstants getIconSpriteFileName] :rect.origin :rect.size];
    return sprite;
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

-(NSInteger) getTransitChangeCount:(R2RTransitSegment *)segment
{
    NSInteger hopCount = [self getTransitHopCount:segment];
    return (hopCount - 1);//1 less change than hops;
}

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

-(R2RSprite *)getConnectionSprite:(id)segment
{
    NSString *kind = [self getSegmentKind:segment];
    
    if ([kind isEqualToString:@"flight"])
    {
        CGPoint offset = CGPointMake(0, 0);
        CGSize size = CGSizeMake(10, 50);
        R2RSprite *sprite = [[R2RSprite alloc] initWithPath:[R2RConstants getConnectionsImageFileName] :offset :size];
        return sprite;
    }
    if ([kind isEqualToString:@"train"])
    {
        CGPoint offset = CGPointMake(10, 0);
        CGSize size = CGSizeMake(10, 50);
        R2RSprite *sprite = [[R2RSprite alloc] initWithPath:[R2RConstants getConnectionsImageFileName] :offset :size];
        return sprite;
    }
    else if ([kind isEqualToString:@"bus"])
    {
        CGPoint offset = CGPointMake(20, 0);
        CGSize size = CGSizeMake(10, 50);
        R2RSprite *sprite = [[R2RSprite alloc] initWithPath:[R2RConstants getConnectionsImageFileName] :offset :size];
        return sprite;
    }
    else if ([kind isEqualToString:@"car"])
    {
        CGPoint offset = CGPointMake(30, 0);
        CGSize size = CGSizeMake(10, 50);
        R2RSprite *sprite = [[R2RSprite alloc] initWithPath:[R2RConstants getConnectionsImageFileName] :offset :size];
        return sprite;
    }
    else if ([kind isEqualToString:@"ferry"])
    {
        CGPoint offset = CGPointMake(40, 0);
        CGSize size = CGSizeMake(10, 50);
        R2RSprite *sprite = [[R2RSprite alloc] initWithPath:[R2RConstants getConnectionsImageFileName] :offset :size];
        return sprite;
    }
    else if ([kind isEqualToString:@"walk"])
    {
        CGPoint offset = CGPointMake(50, 0);
        CGSize size = CGSizeMake(10, 50);
        R2RSprite *sprite = [[R2RSprite alloc] initWithPath:[R2RConstants getConnectionsImageFileName] :offset :size];
        return sprite;
    }
    CGPoint offset = CGPointMake(60, 0);
    CGSize size = CGSizeMake(10, 50);
    R2RSprite *sprite = [[R2RSprite alloc] initWithPath:[R2RConstants getConnectionsImageFileName] :offset :size];
    return sprite;
}

-(NSInteger)getFlightChangeCount:(R2RFlightSegment *)segment
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
