//
//  R2RDetailViewController.m
//  R2RApp
//
//  Created by Ash Verdoorn on 6/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RDetailViewController.h"
#import "R2RNameCell.h"
#import "R2RHopCell.h"

#import "R2RAirport.h"
#import "R2RAirline.h"
#import "R2RRoute.h"
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
#import "R2RPosition.h"
#import "R2RStop.h"

@interface R2RDetailViewController ()
- (void)configureView;
@end

@implementation R2RDetailViewController

#pragma mark - Managing the detail item

//- (void)setDetailItem:(id)newDetailItem
//{
//    if (_detailItem != newDetailItem) {
//        _detailItem = newDetailItem;
//        
//        // Update the view.
//        [self configureView];
//    }
//}

- (void)configureView
{
    // Update the user interface for the detail item.

//    if (self.detailItem) {
//        self.detailDescriptionLabel.text = [self.detailItem description];
//    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    //    // Return the number of rows in the section.
    //    return 0;
    
    return (([self.route.segments count] * 2)+1);//[self.searchResponse.routes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0)
//    {
//        static NSString *CellIdentifier = @"NameCell";
//        R2RNameCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        
//        NSString *sourceName = [self getSegmentSourceName:[self.route.segments objectAtIndex:indexPath.row]];
//        [[cell nameLabel] setText:sourceName];
//        
//        return cell;
//    }
    
    if (indexPath.row % 2 == 0)
    {
        int routeIndex = floor(indexPath.row/2);
        
        static NSString *CellIdentifier = @"NameCell";
        
        //NSString *targetName = [self getSegmentTargetName:[self.route.segments objectAtIndex:routeIndex]];

        R2RNameCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        R2RStop *stop = [self.route.stops objectAtIndex:routeIndex];
        
        [[cell nameLabel] setText:stop.name];
        
        return cell;
    }
    else
    {
        int routeIndex = floor(indexPath.row/2);
        
        static NSString *CellIdentifier = @"HopCell";
        
        float duration = [self getSegmentDuration:[self.route.segments objectAtIndex:routeIndex]];
        NSString *kind = [self getSegmentKind:[self.route.segments objectAtIndex:routeIndex]];
        
        NSString *hopDescription = [NSString stringWithFormat:@"%.0f minutes by %@", duration, kind];
        
        R2RHopCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        [[cell hopLabel] setText:hopDescription];
        
        return cell;
    }
    
}

-(NSString*) getSegmentSourceName:(id) segment
{
    NSMutableString *sourceName = [[NSMutableString alloc] init];
    /////////  REDO THIS SECTION
    if([segment isKindOfClass:[R2RWalkDriveSegment class]])
    {
        R2RWalkDriveSegment *currentSegment = segment;
        [sourceName appendString:currentSegment.sName];
    }
    else if([segment isKindOfClass:[R2RTransitSegment class]])
    {
        R2RTransitSegment *currentSegment = segment;
        [sourceName appendString:currentSegment.sName];
    }
    else if([segment isKindOfClass:[R2RFlightSegment class]])
    {
        R2RFlightSegment *currentSegment = segment;
        [sourceName appendString:currentSegment.sCode];
    }
    
    return sourceName;

}

-(NSString*) getSegmentTargetName:(id) segment
{
    NSMutableString *targetName = [[NSMutableString alloc] init];
    /////////  REDO THIS SECTION
    if([segment isKindOfClass:[R2RWalkDriveSegment class]])
    {
        R2RWalkDriveSegment *currentSegment = segment;
        [targetName appendString:currentSegment.tName];
    }
    else if([segment isKindOfClass:[R2RTransitSegment class]])
    {
        R2RTransitSegment *currentSegment = segment;
        [targetName appendString:currentSegment.tName];
    }
    else if([segment isKindOfClass:[R2RFlightSegment class]])
    {
        R2RFlightSegment *currentSegment = segment;
        [targetName appendString:currentSegment.tCode];
    }
    
    return targetName;
    
}

-(float) getSegmentDuration:(id) segment
{
    float duration;
    /////////  REDO THIS SECTION
    if([segment isKindOfClass:[R2RWalkDriveSegment class]])
    {
        R2RWalkDriveSegment *currentSegment = segment;
        duration = currentSegment.duration;
    }
    else if([segment isKindOfClass:[R2RTransitSegment class]])
    {
        R2RTransitSegment *currentSegment = segment;
        duration = currentSegment.duration;
    }
    else if([segment isKindOfClass:[R2RFlightSegment class]])
    {
        R2RFlightSegment *currentSegment = segment;
        duration = currentSegment.duration;
    }
    
    return duration;
    
}

-(NSString*) getSegmentKind:(id) segment
{
    NSMutableString *kind = [[NSMutableString alloc] init];
    /////////  REDO THIS SECTION
    if([segment isKindOfClass:[R2RWalkDriveSegment class]])
    {
        R2RWalkDriveSegment *currentSegment = segment;
        [kind appendString:currentSegment.kind];
    }
    else if([segment isKindOfClass:[R2RTransitSegment class]])
    {
        R2RTransitSegment *currentSegment = segment;
        [kind appendString:currentSegment.kind];
    }
    else if([segment isKindOfClass:[R2RFlightSegment class]])
    {
        R2RFlightSegment *currentSegment = segment;
        [kind appendString:currentSegment.kind];
    }
    
    return kind;
    
}


@end
