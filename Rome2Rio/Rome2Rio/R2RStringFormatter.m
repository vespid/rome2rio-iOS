//
//  R2RStringFormatters.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 20/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RStringFormatter.h"
#import "R2RDuration.h"


@implementation R2RStringFormatter

+(id) alloc
{
    [NSException raise:@"R2RStringFormatters is static" format:@"R2RStringFormatters is static"];
    return nil;
}

+(NSString *) formatFlightHopCellDescription: (float) minutes: (NSInteger) stops
{
    return [NSString stringWithFormat:@"%@ by plane, %@", [R2RStringFormatter formatDuration:minutes], [R2RStringFormatter formatStopovers:stops]];
}

+(NSString *) formatTransitHopDescription: (float) minutes: (NSInteger) changes: (float) frequency: (NSString *) vehicle: (NSString *) line
{
    if (changes == 0)
    {
        if ([line length] > 0)
            return [NSString stringWithFormat:@"%@ by %@ %@, %@", [R2RStringFormatter formatDuration:minutes], line, vehicle, [R2RStringFormatter formatFrequency:frequency]];
        else
            return [NSString stringWithFormat:@"%@ by %@, %@", [R2RStringFormatter formatDuration:minutes], vehicle, [R2RStringFormatter formatFrequency:frequency]];
    }
    else if (changes == 1)
    {
        return [NSString stringWithFormat:@"%@ by %@, 1 change", [self formatDuration:minutes], vehicle];
    }
    else if (changes >= 2)
    {
        return [NSString stringWithFormat:@"%@ by %@, %d changes", [self formatDuration:minutes], vehicle, changes];
    }
    return nil;
}

+(NSString *) formatWalkDriveHopCellDescription: (float) minutes: (float) distance: (NSString *) kind
{
    if ([kind isEqualToString:@"walk"])
    {
        return [NSString stringWithFormat:@"%@ by foot, %@", [self formatDuration:minutes], [self formatDistance:distance]];
    }
    else
    {
        return [NSString stringWithFormat:@"%@ by car, %@", [self formatDuration:minutes], [self formatDistance:distance]];
    }
    
}

+(NSString *) formatDuration: (float) minutes
{
    R2RDuration *duration = [[R2RDuration alloc] initWithMinutes:minutes];
    
    if (duration.totalHours >= 48)
    {
        return [NSString stringWithFormat:@"%ddays %dhrs", duration.days, duration.hours];
    }
    else if (duration.totalHours < 1)
    {
        return [NSString stringWithFormat:@"%dmin", duration.minutes];
    }
    else
    {
        if (duration.minutes == 0)
        {
            return [NSString stringWithFormat:@"%dhrs", duration.totalHours];
        }
        else
        {
            return [NSString stringWithFormat:@"%dhrs %dmin", duration.totalHours, duration.minutes];
        }
    }
}

+(NSString *) formatDurationZeroPadded:(float)minutes
{
    R2RDuration *duration = [[R2RDuration alloc] initWithMinutes:minutes];
    
    if (duration.totalHours >= 48)
    {
        return [NSString stringWithFormat:@"%ddays %dhrs", duration.days, duration.hours];
    }
    else if (duration.totalHours < 1)
    {
        return [NSString stringWithFormat:@"%dmin", duration.minutes];
    }
    else
    {
        return [NSString stringWithFormat:@"%dhrs %dmin", duration.totalHours, duration.minutes];
    }
}

+(NSString *) formatFrequency: (float) frequency
{
    int weekFrequency = lroundf(frequency);
    if (weekFrequency <= 1)
    {
        return @"once a week";
    }
    if (weekFrequency == 2)
    {
        return @"twice a week";
    }
    if (weekFrequency < 7)
    {
        return [NSString stringWithFormat:@"%d times a week", weekFrequency];
    }
    
    NSInteger dayFrequency = lroundf(frequency/7);
    
    if (dayFrequency == 1)
    {
        return @"once daily";
    }
    if (dayFrequency == 2)
    {
        return @"twice daily";
    }
    if (dayFrequency < 6)
    {
        return [NSString stringWithFormat:@"%d times a day", dayFrequency];
    }
    if (dayFrequency < 9)
    {
        return @"every 4 hours";
    }
    if (dayFrequency < 11)
    {
        return @"every 3 hours";
    }
    if (dayFrequency < 13)
    {
        return @"every 2 hours";
    }
    
    NSInteger hourFrequency = lroundf(frequency/7/24);
    
    if (hourFrequency == 1)
    {
        return @"hourly";
    }
    if (hourFrequency == 2)
    {
        return @"every 30 minutes";
    }
    if (hourFrequency == 3)
    {
        return @"every 20 minutes";
    }
    if (hourFrequency == 4 || hourFrequency == 5)
    {
        return @"every 15 minutes";
    }
    if (hourFrequency <= 10)
    {
        return @"every 10 minutes";
    }
    
    return @"every 5 minutes";
}

+(NSString *) formatDistance: (float) distance
{
    if (distance < 1)
    {
        return [NSString stringWithFormat:@"%.0f m", distance*1000];
    }
    else if(distance < 100)
    {
        return [NSString stringWithFormat:@"%.1f km", distance];
    }
    else
    {
        return [NSString stringWithFormat:@"%.0f km", distance];
    }
}

+(NSString *) formatDays: (int) days
{
	NSString *labels[] = { @"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat" };

	if (days == 0x7F)		// every day
		return @"Daily";

	else if (days == 0x3E)	// week days
		return @"Mon to Fri";

	else
	{
		NSMutableString *result = [[NSMutableString alloc] init];
		NSString *separator = @"";

		for (NSInteger day = 0; day < 7; day++)
		{
			if ((days & (1 << day)) != 0)
			{
				[result appendString:separator];
				[result appendString:labels[day]];
				separator = @" ";
			}
		}

		return result;
	}
}

+(NSString *) padNumber: (NSInteger) number
{
    if (number < 10)
    {
        return [NSString stringWithFormat:@"0%d", number];
    }
    else
    {
        return [NSString stringWithFormat:@"%d", number];
    }
}

+(NSString *) formatStopovers: (NSInteger) stops
{
    if (stops == 0)
    {
        return @"non-stop";
    }
    else if (stops == 1)
    {
        return @"1 stopover";
    }
    else if (stops >= 2)
    {
        return [NSString stringWithFormat:@"%d stopovers", stops];
    }
    return @"";
}

+(NSString *)formatTransitHopVehicle:(NSString *) vehicle
{
    vehicle = [vehicle stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[vehicle substringToIndex:1] uppercaseString]];
    vehicle = [vehicle stringByAppendingString:@" from"];
    return vehicle;
}

+(NSString *) capitaliseFirstLetter: (NSString *) string
{
    string = [string stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[string substringToIndex:1] uppercaseString]];
    return string;
}


@end
