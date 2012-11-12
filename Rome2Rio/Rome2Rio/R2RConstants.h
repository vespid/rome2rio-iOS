//
//  R2RConstants.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 29/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface R2RConstants : NSObject

+(UIColor *) getBackgroundColor;
+(UIColor *) getCellColor;
+(UIColor *) getExpandedCellColor;
+(UIColor *) getLightTextColor;
+(UIColor *) getDarkTextColor;
+(UIColor *) getFlightLineColor;
+(UIColor *) getBusLineColor;
+(UIColor *) getTrainLineColor;
+(UIColor *) getFerryLineColor;
+(UIColor *) getWalkDriveLineColor;


#define MAX_FLIGHT_STOPS 5
#define MAX_ICONS 5

@end
