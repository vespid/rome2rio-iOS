//
//  R2RStringFormatters.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 20/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface R2RStringFormatter : NSObject

+(NSString *) formatFlightHopCellDescriptionWithMinutes:(float) minutes stops:(NSInteger) stops;
+(NSString *) formatTransitHopDescriptionWithMinutes:(float) minutes changes:(NSInteger) changes frequency:(float) frequency vehicle:(NSString *) vehicle line:(NSString *) line;
+(NSString *) formatWalkDriveHopCellDescriptionWithMinutes:(float) minutes distance:(float) distance kind:(NSString *) kind;
+(NSString *) formatTransitHopVehicle: (NSString *) vehicle;

+(NSString *) formatDuration: (float) minutes;
+(NSString *) formatDurationZeroPadded: (float) minutes;
+(NSString *) formatFrequency: (float) frequency;
+(NSString *) formatDistance: (float) distance;
+(NSString *) formatDays: (int) days;

+(NSString *) capitaliseFirstLetter: (NSString *) string;

@end
