//
//  R2RIconLoader.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 27/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RIconLoader.h"

#import "R2RConnection.h"

@interface R2RIconLoader() <R2RConnectionDelegate>

@property (strong, nonatomic) NSString *iconPath;
@property (strong, nonatomic) R2RConnection *connection;


@end


@implementation R2RIconLoader

@synthesize icon, delegate, airline;

-(id) initWithIconPath:(NSString *)iconPath delegate:(id<R2RIconLoaderDelegate>)r2rIconLoaderDelegate
{
    self = [super init];
    
    if (self != nil)
    {
        self.iconPath = iconPath;
        self.delegate = r2rIconLoaderDelegate;
        
        [self sendAsynchronousRequest];
    }
    
    return self;
}

-(void)sendAsynchronousRequest
{
    
#if DEBUG
    NSString *iconString = [NSString stringWithFormat:@"http://prototype.rome2rio.com%@", self.iconPath];
#else
    NSString *iconString = [NSString stringWithFormat:@"http://ios.rome2rio.com%@", self.iconPath];
#endif
    
    NSString *iconEncoded = [iconString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *iconUrl =  [NSURL URLWithString:iconEncoded];
    
    self.connection = [[R2RConnection alloc] initWithConnectionUrl:iconUrl delegate:self];
}

-(void)R2RConnectionProcessData:(R2RConnection *)delegateConnection
{
    if (self.connection == delegateConnection)
    {
        self.icon = [[UIImage alloc] initWithData:self.connection.responseData];
//        if (!self.icon)
//        {
//            NSString *string = [[NSString alloc] initWithData:self.connection.responseData encoding:NSUTF8StringEncoding];
//            NSLog(@"%@", string);
//        }
//        NSLog(@"%@", self.icon);
        
        [[self delegate] R2RIconLoaded:self];
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
