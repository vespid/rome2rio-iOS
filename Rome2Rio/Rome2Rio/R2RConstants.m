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

+(UIImage *) getMasterViewBackgroundImage
{
    return [UIImage imageNamed:@"bg-retina"];
}

+(UIImage *) getMasterViewLogo
{
    return [UIImage imageNamed:@"r2r-retina"];
}

+(NSString *) getIconSpriteFileName
{
    return @"sprites6x2";
}

+(CGRect) getHopIconRect
{
    return CGRectMake(534, 92, 24, 24);
};

+(CGRect) getRouteFlightSpriteRect
{
    return CGRectMake(0, 160, 36, 36);
}

+(CGRect) getRouteTrainSpriteRect
{
    return CGRectMake(0, 196, 36, 36);
}

+(CGRect) getRouteBusSpriteRect
{
    return CGRectMake(0, 376, 36, 36);
}

+(CGRect) getRouteFerrySpriteRect
{
    return CGRectMake(0, 412, 36, 36);
}

+(CGRect) getRouteCarSpriteRect
{
    return CGRectMake(0, 304, 36, 36);
}

+(CGRect) getRouteWalkSpriteRect
{
    return CGRectMake(0, 448, 36, 36);
}

+(CGRect) getRouteUnknownSpriteRect
{
    return CGRectMake(0, 340, 36, 36);
}

+(CGRect) getResultFlightSpriteRect
{
    return CGRectMake(680, 120, 28, 24);
}

+(CGRect) getResultTrainSpriteRect
{
    return CGRectMake(708, 120, 38, 24);
}

+(CGRect) getResultBusSpriteRect
{
    return CGRectMake(768, 120, 36, 24);
}

+(CGRect) getResultFerrySpriteRect
{
    return CGRectMake(636, 120, 44, 24);
}

+(CGRect) getResultCarSpriteRect
{
    return CGRectMake(600, 120, 36, 24);
}

+(CGRect) getResultWalkSpriteRect
{
    return CGRectMake(804, 120, 28, 24);
}

+(CGRect) getResultUnknownSpriteRect
{
    return CGRectMake(746, 120, 22, 24);
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

+ (UIColor *)getButtonHighlightColor
{
    return [UIColor colorWithRed:242.0/256.0 green:103.0/256.0 blue:54.0/256.0 alpha:1.0];
}

+(UIColor *)getFlightLineColor
{
    return [UIColor colorWithRed:241/255.0 green:96/255.0 blue:36/255.0 alpha:0.8];
}

+(UIColor *)getBusLineColor
{
    return [UIColor colorWithRed:98/255.0 green:144/255.0 blue:46/255.0 alpha:0.8];
}

+(UIColor *)getTrainLineColor
{
    return [UIColor colorWithRed:48/255.0 green:124/255.0 blue:192/255.0 alpha:0.8];
}

+(UIColor *)getFerryLineColor
{
    return [UIColor colorWithRed:64/255.0 green:170/255.0 blue:196/255.0 alpha:0.8];
}

+(UIColor *)getDriveLineColor
{
    return [UIColor colorWithWhite:0.0 alpha:0.4];
}

+(UIColor *)getWalkLineColor
{
    return [UIColor colorWithWhite:0.4 alpha:0.8];
}

@end
