//
//  R2RStringFormatters.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 20/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface R2RStringFormatters : NSObject

//@property BOOL showMinutesIfZero;

+(NSString *) formatFlightHopCellDescription: (float) minutes: (NSInteger) stops;
+(NSString *) formatTransitHopDescription: (float) minutes: (NSInteger) changes: (float) frequency: (NSString *) vehicle;
+(NSString *) formatWalkDriveHopCellDescription: (float) minutes: (float) distance: (NSString *) kind;
+(NSString *) formatTransitHopVehicle: (NSString *) vehicle;

+(NSString *) formatDuration: (float) minutes;
+(NSString *) formatDurationZeroPadded: (float) minutes;
+(NSString *) formatFrequency: (float) frequency;
+(NSString *) formatDistance: (float) distance;
+(NSString *) formatDays: (int) days;

+(NSString *) capitaliseFirstLetter: (NSString *) string;

@end
