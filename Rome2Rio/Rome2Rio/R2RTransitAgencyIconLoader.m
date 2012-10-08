//
//  R2RTransitAgencyIconLoader.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 2/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RTransitAgencyIconLoader.h"
#import "R2RConnection.h"

@interface R2RTransitAgencyIconLoader() <R2RConnectionDelegate>

@property (strong, nonatomic) NSString *iconPath;
@property (strong, nonatomic) R2RConnection *connection;

@end

@implementation R2RTransitAgencyIconLoader

@synthesize agency, sprite, delegate, section, iconOffset;


-(id) initWithIconPath:(NSString *)iconPath delegate:(id<R2RTransitAgencyIconLoaderDelegate>)r2rTransitAgencyIconLoaderDelegate
{
    self = [super init];
    
    if (self != nil)
    {
        self.iconPath = iconPath;
        self.delegate = r2rTransitAgencyIconLoaderDelegate;
        
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
         
        self.sprite = [[R2RSprite alloc] initWithImage:image :self.iconOffset :image.size];
        
        [[self delegate] r2rTransitAgencyIconLoaded:self];
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
