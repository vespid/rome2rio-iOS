//
//  R2RConstants.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 29/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface R2RConstants : NSObject

+(NSString *) getAppId;

+(UIImage *) getMasterViewBackgroundImage;
+(UIImage *) getMasterViewLogo;

+(MKCoordinateRegion) getStartMapRegion;

+(NSString *) getIconSpriteFileName;
+(NSString *) getConnectionsImageFileName;

+(CGRect) getHopIconRect;

+(CGRect) getRouteFlightSpriteRect;
+(CGRect) getRouteTrainSpriteRect;
+(CGRect) getRouteBusSpriteRect;
+(CGRect) getRouteFerrySpriteRect;
+(CGRect) getRouteCarSpriteRect;
+(CGRect) getRouteWalkSpriteRect;
+(CGRect) getRouteUnknownSpriteRect;

+(CGRect) getResultFlightSpriteRect;
+(CGRect) getResultTrainSpriteRect;
+(CGRect) getResultBusSpriteRect;
+(CGRect) getResultFerrySpriteRect;
+(CGRect) getResultCarSpriteRect;
+(CGRect) getResultWalkSpriteRect;
+(CGRect) getResultUnknownSpriteRect;

+(UIColor *) getBackgroundColor;
+(UIColor *) getCellColor;
+(UIColor *) getExpandedCellColor;
+(UIColor *) getLightTextColor;
+(UIColor *) getDarkTextColor;
+(UIColor *) getButtonHighlightColor;
+(UIColor *) getFlightLineColor;
+(UIColor *) getBusLineColor;
+(UIColor *) getTrainLineColor;
+(UIColor *) getFerryLineColor;
+(UIColor *) getDriveLineColor;
+(UIColor *) getWalkLineColor;



#define MAX_FLIGHT_STOPS 5
#define MAX_ICONS 5

@end
