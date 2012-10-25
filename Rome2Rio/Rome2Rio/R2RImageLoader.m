//
//  R2RImageLoader.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 15/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RImageLoader.h"
#import "R2RConnection.h"

@interface R2RImageLoader() <R2RConnectionDelegate>

@property (strong, nonatomic) R2RConnection *connection;

@end

@implementation R2RImageLoader

@synthesize delegate;

-(id)initWithPath:(NSString *)path
{
    self = [super init];
    
    if (self != nil)
    {
        self.path = path;
        //[self sendAsynchronousRequest];
    }
    
    return self;
}

-(void)sendAsynchronousRequest
{
    
#if DEBUG
    NSString *imageString = [NSString stringWithFormat:@"http://prototype.rome2rio.com%@", self.path];
#else
    NSString *imageString = [NSString stringWithFormat:@"http://ios.rome2rio.com%@", self.path];
#endif
    
    NSString *imageEncoded = [imageString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *imageUrl =  [NSURL URLWithString:imageEncoded];
    
    self.connection = [[R2RConnection alloc] initWithConnectionUrl:imageUrl delegate:self];
}

-(void)R2RConnectionProcessData:(R2RConnection *)delegateConnection
{
    if (self.connection == delegateConnection)
    {
        self.image = [[UIImage alloc] initWithData:self.connection.responseData];
        
        [self.delegate r2rImageDidLoad:self];
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
