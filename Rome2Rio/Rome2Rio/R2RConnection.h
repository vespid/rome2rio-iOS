//
//  R2RConnection.h
//  HttpRequest
//
//  Created by Ash Verdoorn on 30/08/12.
//  Copyright (c) 2012 Ash Verdoorn. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol R2RConnectionDelegate;


@interface R2RConnection : NSObject

@property (weak, nonatomic) id<R2RConnectionDelegate> delegate;
@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSString *connectionString;

-(id) initWithConnectionUrl:(NSURL *)connectionUrl delegate:(id<R2RConnectionDelegate>)r2rConnectionDelegate;

@end


@protocol R2RConnectionDelegate <NSObject>

- (void) R2RConnectionProcessData:(R2RConnection *)delegateConnection;
- (void) R2RConnectionError:(R2RConnection *)delegateConnection;

@end

