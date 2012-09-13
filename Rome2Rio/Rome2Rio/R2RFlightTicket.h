//
//  R2RFlightTicket.h
//  HttpRequest
//
//  Created by Ash Verdoorn on 4/09/12.
//  Copyright (c) 2012 Ash Verdoorn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface R2RFlightTicket : NSObject

@property (strong, nonatomic) NSString *name;
@property (nonatomic) float price;
@property (strong, nonatomic) NSString *currency;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSURL *url;

@end
