//
//  R2RConstants.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 29/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RConstants.h"
#import "R2RKeys.h"

@interface R2RConstants()

@end

@implementation R2RConstants

+(id) alloc
{
    [NSException raise:@"R2RConstants is static" format:@"R2RConstants is static"];
    return nil;
}

+(NSString *) getUserId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userId = [userDefaults stringForKey:@"R2RUserID"];
    
    if (userId == NULL)
    {
        // if no userId generate a new one from
        // localeIdentifier + date + random number seeded from ID
        
        NSString *localeId = [[NSLocale currentLocale] localeIdentifier];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyyMMddHHmmssSSS"];
        
        NSDate *now = [[NSDate alloc] init];
        
        NSString *theDate = [dateFormat stringFromDate:now];
        
        NSString *deviceUDID = NULL;
        
        if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)])
        {
            //get vendor UUID
            deviceUDID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        }
        else
        {
            // pre 6.0 generate a UUID
            CFUUIDRef theUUID = CFUUIDCreate( kCFAllocatorDefault );
            CFStringRef theUUIDString = CFUUIDCreateString( kCFAllocatorDefault, theUUID );
            
            deviceUDID = (NSString *)CFBridgingRelease(theUUIDString);
            
            CFRelease(theUUID);
        }
        
        // using adler32 checksum as random seed
        NSInteger a = 1, b = 0;
        NSInteger const MOD_ADLER = 65521;
        for (NSInteger i = 0; i < [deviceUDID length]; i++)
        {
            a = (a + [deviceUDID characterAtIndex:i]) %MOD_ADLER;
            b = (b + a) % MOD_ADLER;
        }
        NSInteger adler = (b << 16) | a;
        
        srand((uint)adler);
        NSInteger randNum = rand() % (9999 - 1000) + 1000;
        
        userId = [NSString stringWithFormat:(@"%@%@%ld"),localeId, theDate, (long)randNum];
        
        R2RLog(@"%@", userId);
        [userDefaults setObject:userId forKey:@"R2RUserID"];
    }
    
    return userId;
}

+(void)setUserCurrency:(NSString *)currencyCode
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    [userDefaults setObject:currencyCode forKey:@"R2RUserCurrency"];
}

+(NSString *)getUserCurrency
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSString *userCurrency = [userDefaults stringForKey:@"R2RUserCurrency"];
    
    if (userCurrency == NULL)
    {
        NSString *currencyCode = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencyCode];
        
        userCurrency = currencyCode;
        
        [userDefaults setObject:currencyCode forKey:@"R2RUserCurrency"];
    }
    
    return userCurrency;
}


+(NSString *)getAppURL
{
    return [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", [R2RKeys getAppId]];
}

+(NSString *)getAppDescription
{
    return @"Discover how to get anywhere by plane, train, bus, ferry or car!";
}

+(UIImage *) getMasterViewBackgroundImage
{
    return [UIImage imageNamed:@"bg-retina"];
}

+(UIImage *) getMasterViewLogo
{
    return [UIImage imageNamed:@"r2r-retina"];
}

+(float)getTableWidth
{
    return (IPAD) ? 380.0 : 320.0;
}

+(MKCoordinateRegion) getStartMapRegion
{
    //Region for Melbourne
//    CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(-37.816022 , 144.96151);
//    return MKCoordinateRegionMakeWithDistance(startCoord , 50000, 50000);
    
    return MKCoordinateRegionForMapRect(MKMapRectWorld);
}

+(NSString *) getIconSpriteFileName
{
    return @"Rome2rio_2_0_sprites";
}

+(NSString *) getConnectionsImageFileName
{
    return @"Rome2rio_2_0_lines";
}

+(NSString *) getMyLocationSpriteFileName
{
    return @"Blue_dot-24px";
}

//detail view icon
+(CGRect) getConnectionIconRect
{
    return CGRectMake(160, 272, 48, 48);
};

+(CGRect)getExternalLinkWhiteIconRect
{
    return CGRectMake(240, 276, 48, 44);
}

+(CGRect)getExternalLinkPinkIconRect
{
    return CGRectMake(320, 276, 48, 44);
}

//annotation icon
+(CGRect) getHopIconRect
{
    return CGRectMake(540, 70, 18, 18);
};

+(CGRect) getMyLocationIconRect
{
    return CGRectMake(0, 0, 24, 24);
};

+(CGRect) getRouteFlightSpriteRect
{
    return CGRectMake(320, 112, 48, 48);
}

+(CGRect) getRouteHelicopterSpriteRect
{
    return CGRectMake(160, 192, 48, 48);
}

+(CGRect) getRouteTrainSpriteRect
{
    return CGRectMake(80, 112, 48, 48);
}

+(CGRect) getRouteTramSpriteRect
{
    return CGRectMake(80, 192, 48, 48);
}

+(CGRect) getRouteCablecarSpriteRect
{
    return CGRectMake(240, 192, 48, 48);
}

+(CGRect) getRouteBusSpriteRect
{
    return CGRectMake(160, 112, 48, 48);
}

+(CGRect) getRouteFerrySpriteRect
{
    return CGRectMake(240, 112, 48, 48);
}

+(CGRect) getRouteCarSpriteRect
{
    return CGRectMake(400, 112, 48, 48);
}

+(CGRect) getRouteTaxiSpriteRect
{
    return CGRectMake(480, 112, 48, 48);
}

+(CGRect) getRouteRideshareSpriteRect
{
    return CGRectMake(560, 192, 48, 48);
}

+(CGRect) getRouteWalkSpriteRect
{
    return CGRectMake(560, 112, 48, 48);
}

+(CGRect) getRouteAnimalSpriteRect
{
    return CGRectMake(320, 192, 48, 48);
}

+(CGRect) getRouteUnknownSpriteRect
{
    return CGRectMake(80, 272, 48, 48);
}

+(UIColor *)getBackgroundColor
{
    return [UIColor colorWithWhite:224/255.0 alpha:1.0];
}

+(UIColor *)getExpandedCellColor
{
    return [UIColor colorWithWhite:1.0 alpha:1.0];
}

+(UIColor *)getCellColor
{
    return [UIColor colorWithWhite:242/255.0 alpha:1.0];
}

+(UIColor *)getDarkTextColor
{
    return [UIColor colorWithWhite:0.2 alpha:1.0];
}

+(UIColor *)getLightTextColor
{
    return [UIColor colorWithWhite:112/255.0 alpha:1.0];
}

+ (UIColor *)getButtonHighlightColor
{
    return [UIColor colorWithRed:222/255.0 green:0/255.0 blue:123/255.0 alpha:1.0];
}

+ (UIColor *)getButtonHighlightDarkerColor
{
    return [UIColor colorWithRed:197/255.0 green:0/255.0 blue:109/255.0 alpha:1.0];
}

+(UIColor *)getFlightColor
{
    return [UIColor colorWithRed:4/255.0 green:201/255.0 blue:166/255.0 alpha:1.0];
}

+(UIColor *)getBusColor
{
    return [UIColor colorWithRed:228/255.0 green:114/255.0 blue:37/255.0 alpha:1.0];
}

+(UIColor *)getTrainColor
{
    return [UIColor colorWithRed:115/255.0 green:66/255.0 blue:134/255.0 alpha:1.0];
}

+(UIColor *)getFerryColor
{
    return [UIColor colorWithRed:46/255.0 green:186/255.0 blue:211/255.0 alpha:1.0];
}

+(UIColor *)getDriveColor
{
    return [UIColor colorWithWhite:96/255.0 alpha:1.0];
}

+(UIColor *)getTaxiColor
{
    return [UIColor colorWithRed:255/255.0 green:163/255.0 blue:0/255.0 alpha:1.0];
}

+(UIColor *)getUnknownColor
{
    return [UIColor colorWithWhite:144/255.0 alpha:1.0];
}

+(UIColor *)getWalkColor
{
    return [UIColor colorWithRed:224/255.0 green:4/255.0 blue:59/255.0 alpha:1.0];
}

+(NSArray *)getAllCurrencies
{
    NSArray *currencyCodes = @[@"ARS", @"AUD", @"BRL", @"CAD", @"CNY", @"HRK", @"CZK", @"DKK", @"EUR", @"HKD", @"HUF", @"INR", @"IDR", @"ILS", @"JPY", @"MYR", @"MXN", @"MAD", @"NZD", @"NOK", @"PHP", @"PLN", @"GBP", @"RUB", @"SAR", @"RSD", @"SGD", @"ZAR", @"KRW", @"LKR", @"SEK", @"CHF", @"THB", @"TRY", @"AED", @"UAH", @"USD"];
    
    NSArray *currencyDescriptions = @[@"Argentine Peso (ARS)", @"Australian Dollar (AUD)", @"Brazillian Real (BRL)", @"Canadian Dollar (CAD)", @"Chinese Yuan (CNY)", @"Croatian Kuna (HRK)", @"Czech Koruna (CZK)", @"Danish Krone (DKK)", @"Euro (EUR)", @"Hong Kong Dollar (HKD)", @"Hungarian Forint (HUF)", @"Indian Rupee (INR)", @"Indonesian Rupiah (IDR)", @"Israeli New Shekel (ILS)", @"Japanese Yen (JPY)", @"Malaysian Ringgit (MYR)", @"Mexican Peso (MXN)", @"Moroccan Dirham (MAD)", @"New Zealand Dollar (NZD)", @"Norwegian Krone (NOK)", @"Philippines Peso (PHP)", @"Polish Złoty (PLN)", @"Pound Sterling (GBP)", @"Russian Ruble (RUB)", @"Saudi Arabian Riyal (SAR)", @"Serbian Dinar (RSD)", @"Singapore Dollar (SGD)", @"South African Rand (ZAR)", @"South Korean Won (KRW)", @"Sri Lankan Rupee (LKR)", @"Swedish Krona (SEK)", @"Swiss Franc (CHF)", @"Thai Baht (THB)", @"Turkish Lira (TRY)", @"UAE Dirham (AED)", @"Ukranian Hryvnia (UAH)", @"US Dollar (USD)"];
    
    NSArray* allCurrencies = @[currencyCodes, currencyDescriptions];

    return allCurrencies;
}

@end
