//
//  R2RConstants.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 29/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RConstants.h"

@interface R2RConstants()

@end

@implementation R2RConstants

+(id) alloc
{
    [NSException raise:@"R2RConstants is static" format:@"R2RConstants is static"];
    return nil;
}

+(UIColor *) getBackgroundColor
{
    return [UIColor colorWithRed:234.0/256.0 green:228.0/256.0 blue:224.0/256.0 alpha:1.0];
}

+(UIColor *)getExpandedCellColor
{
    return [UIColor colorWithRed:244.0/256.0 green:238.0/256.0 blue:234.0/256.0 alpha:1.0];
}

+(UIColor *)getCellColor
{
    return [UIColor colorWithRed:254.0/256.0 green:248.0/256.0 blue:244.0/256.0 alpha:1.0];
}

+(UIColor *)getDarkTextColor
{
    return [UIColor colorWithWhite:0.2 alpha:1.0];
}

+(UIColor *)getLightTextColor
{
    return [UIColor colorWithWhite:0.5 alpha:1.0];
}

+(UIColor *)getFlightLineColor
{
    return [UIColor colorWithRed:241/255.0 green:96/255.0 blue:36/255.0 alpha:1.0];
}

+(UIColor *)getBusLineColor
{
    return [UIColor colorWithRed:98/255.0 green:144/255.0 blue:46/255.0 alpha:1.0];
}

+(UIColor *)getTrainLineColor
{
    return [UIColor colorWithRed:48/255.0 green:124/255.0 blue:192/255.0 alpha:1.0];
}

+(UIColor *)getFerryLineColor
{
    return [UIColor colorWithRed:64/255.0 green:170/255.0 blue:196/255.0 alpha:1.0];
}

+(UIColor *)getWalkDriveLineColor
{
    return [UIColor blackColor];
}

@end
