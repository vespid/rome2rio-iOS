//
//  R2RSegmentHandler.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 26/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "R2RSprite.h"
#import "R2RDataController.h"

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

-(id) initWithData: (R2RDataController *) data;

-(R2RSprite *) getRouteSprite:(NSString *) kind;
//-(UIImage *) getRouteIcon:(NSString *) kind;
-(R2RSprite *) getSegmentResultSprite:(id) segment;
//-(UIImage *) getSegmentResultIcon:(id) segment;
-(R2RSprite *) getConnectionSprite: (id) segment;
//-(UIImage *) getConnectionImage: (id) segment;

-(BOOL) getSegmentIsMajor:(id) segment;
-(NSString*) getSegmentKind:(id) segment;
-(NSString*) getSegmentPath:(id) segment;
-(R2RPosition *) getSegmentSPos:(id) segment;
-(R2RPosition *) getSegmentTPos:(id) segment;

-(NSInteger) getTransitChanges: (R2RTransitSegment *) segment;
//-(NSString *) getTransitVehicle: (R2RTransitSegment *) segment;
//-(NSString *) getFrequencyText: (R2RTransitSegment *) segment;
-(float) getTransitFrequency: (R2RTransitSegment *)segment;


-(NSInteger) getFlightChanges: (R2RFlightSegment *) segment;


@end
