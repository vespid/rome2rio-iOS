//
//  R2RFlightTicketSet.h
//  HttpRequest
//
//  Created by Ash Verdoorn on 4/09/12.
//  Copyright (c) 2012 Ash Verdoorn. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "R2RFlightTicket.h"

@interface R2RFlightTicketSet : NSObject

@property (strong, nonatomic) NSString *sCode;
@property (strong, nonatomic) NSString *tCode;

@property (strong, nonatomic) NSMutableArray *tickets;

@end
