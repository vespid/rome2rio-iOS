//
//  R2RFlightItinerary.h
//  HttpRequest
//
//  Created by Ash Verdoorn on 4/09/12.
//  Copyright (c) 2012 Ash Verdoorn. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "R2RFlightLeg.h"
#import "R2RFlightTicketSet.h"

@interface R2RFlightItinerary : NSObject

@property (strong, nonatomic) NSMutableArray *legs;
@property (strong, nonatomic) NSMutableArray *ticketSets;

@end
