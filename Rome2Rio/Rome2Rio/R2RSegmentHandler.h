//
//  R2RSegmentHandler.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 26/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "R2RWalkDriveSegment.h"
#import "R2RTransitSegment.h"
#import "R2RTransitItinerary.h"
#import "R2RTransitLeg.h"
#import "R2RTransitHop.h"
#import "R2RFlightSegment.h"
#import "R2RFlightItinerary.h"
#import "R2RFlightLeg.h"
#import "R2RFlightHop.h"
#import "R2RFlightTicketSet.h"
#import "R2RFlightTicket.h"

@interface R2RSegmentHandler : NSObject

-(UIImage *) getRouteIcon:(NSString *) kind;
-(UIImage *) getSegmentResultIcon:(id) segment;
-(BOOL) getSegmentIsMajor:(id) segment;

-(NSInteger) getTransitChanges: (R2RTransitSegment *) segment;
//-(NSString *) getTransitVehicle: (R2RTransitSegment *) segment;
//-(NSString *) getFrequencyText: (R2RTransitSegment *) segment;
-(float) getTransitFrequency: (R2RTransitSegment *)segment;
- (UIImage *) getConnectionImage: (id) segment;


@end
