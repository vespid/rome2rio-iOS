//
//  R2RAirlineIconLoader.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 29/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RAirlineIconLoader.h"

#import "R2RConnection.h"

@interface R2RAirlineIconLoader() <R2RConnectionDelegate>

@property (strong, nonatomic) NSString *iconPath;
@property (strong, nonatomic) R2RConnection *connection;

@end

@implementation R2RAirlineIconLoader

@synthesize airline, sprite, delegate;

-(id) initWithIconPath:(NSString *)iconPath delegate:(id<R2RAirlineIconLoaderDelegate>)r2rAirlineIconLoaderDelegate
{
    self = [super init];
    
    if (self != nil)
    {
        self.iconPath = iconPath;
        self.delegate = r2rAirlineIconLoaderDelegate;
        
//        [self sendAsynchronousRequest];
    }
    
    return self;
}

-(void)sendAsynchronousRequest
{
    NSString *iconString = [NSString stringWithFormat:@"http://prototype.rome2rio.com%@", self.iconPath];
    
    NSString *iconEncoded = [iconString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *iconUrl =  [NSURL URLWithString:iconEncoded];
    
    self.connection = [[R2RConnection alloc] initWithConnectionUrl:iconUrl delegate:self];
}

-(void)R2RConnectionProcessData:(R2RConnection *)delegateConnection
{
    if (self.connection == delegateConnection)
    {
        UIImage *image = [[UIImage alloc] initWithData:self.connection.responseData];
        CGSize airlineIconSize = CGSizeMake(27,23);
        self.sprite = [[R2RSprite alloc] initWithImage:image :self.airline.iconOffset :airlineIconSize];

//        if (!self.icon)
//        {
//            NSString *string = [[NSString alloc] initWithData:self.connection.responseData encoding:NSUTF8StringEncoding];
//            NSLog(@"%@", string);
//        }
        //        NSLog(@"%@", self.icon);
        
        [[self delegate] r2rAirlineIconLoaded:self];
    }
    else
    {
        //        NSLog(@"%@\t%@", self.connection.connectionString, delegateConnection.connectionString);
    }
}

-(void)R2RConnectionError:(R2RConnection *)delegateConnection
{
    
}


@end

