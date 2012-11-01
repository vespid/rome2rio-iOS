//
//  R2RConnection.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 30/08/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RConnection.h"

@interface R2RConnection()

@property (strong, nonatomic) NSURLConnection *connection;

@end    

@implementation R2RConnection

@synthesize responseData, connection, delegate, connectionString;

-(id) initWithConnectionUrl:(NSURL *)connectionUrl delegate:(id<R2RConnectionDelegate>)r2rConnectionDelegate
{
    self = [super init];
    
    if (self != nil)
    {
        
        self.delegate = r2rConnectionDelegate;
        
        self.responseData = [NSMutableData data];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:connectionUrl];
        
        self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

        self.connectionString = [NSString stringWithFormat:@"%@", connectionUrl];
//        self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
//        [self.connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
//        [self.connection start];
//        NSLog(@"%@", [NSRunLoop currentRunLoop]);
        
    }
    return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.responseData setLength:0];
}	

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[self delegate] R2RConnectionError:self];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[self delegate] R2RConnectionProcessData:self];
}

@end
