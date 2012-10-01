//
//  R2RDetailViewController.m
//  R2RApp
//
//  Created by Ash Verdoorn on 6/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RDetailViewController.h"
#import "R2RFlightSegmentViewController.h"
#import "R2RTransitSegmentViewController.h"
#import "R2RWalkDriveSegmentViewController.h"
#import "R2RImageView.h"

#import "R2RNameCell.h"
#import "R2RFlightHopCell.h"
#import "R2RTransitHopCell.h"
#import "R2RWalkDriveHopCell.h"
//#import "R2RHopCell.h"
#import "R2RStringFormatters.h"
#import "R2RSegmentHandler.h"

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

@synthesize route, airlines, airports;

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
    
    return (([self.route.segments count] * 2)+1)*2;
    //return (([self.route.segments count] * 2)+1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int aCount = (([self.route.segments count] * 2)+1);
    if ((indexPath.row%aCount) % 2 == 0)
    //if (indexPath.row % 2 == 0)
    {
        int row = indexPath.row;
        int routeIndex = floor((row%aCount)/2.0);//  floor((indexPath.row%(([self.route.segments count] * 2)+1))/2);
        //int routeIndex = floor(indexPath.row/2);
        
        NSString *CellIdentifier = @"NameCell";
    
        R2RNameCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        R2RStop *stop = [self.route.stops objectAtIndex:routeIndex];
        
        [[cell nameLabel] setText:stop.name];
        
        
        
        if (routeIndex == 0)
        //if (indexPath.row == 0)
        {
//           connectTop.hidden = true;
            
//            cell.connectTop.hidden = true;
//            cell.topConnection.hidden = true;
        }
        else
        {
            R2RImageView *connectTop = [[R2RImageView alloc] initWithFrame:CGRectMake(23, 0, 6, cell.contentView.bounds.size.height/2)];
            CGRect rect = [self getConnectionRect:[self.route.segments objectAtIndex:routeIndex-1]];
            [connectTop setCroppedImage:[UIImage imageNamed:@"ConnectionLines"] :rect];
            [cell.contentView addSubview:connectTop];
            
            
//            cell.topConnection.hidden = false;
//            UIColor *color = [self getConnectionColor:[self.route.segments objectAtIndex:routeIndex-1]];
//            [cell.topConnection setBackgroundColor:color];
        }
        
        
        
        if (routeIndex == [self.route.segments count])
        //if (indexPath.row == ([self.route.segments count] * 2))
        {
//            connectBottom.hidden = true;
//            cell.connectBottom.hidden = true;
        }
        else
        {
            R2RImageView *connectBottom = [[R2RImageView alloc] initWithFrame:CGRectMake(23, cell.contentView.bounds.size.height/2, 6, cell.contentView.bounds.size.height/2)];
            CGRect rect = [self getConnectionRect:[self.route.segments objectAtIndex:routeIndex]];
            [connectBottom setCroppedImage:[UIImage imageNamed:@"ConnectionLines"] :rect];
            [cell.contentView addSubview:connectBottom];

            
//            cell.bottomConnection.hidden = false;
//            UIColor *color = [self getConnectionColor:[self.route.segments objectAtIndex:routeIndex]];
//            [cell.bottomConnection setBackgroundColor:color];
        }
       
        
        R2RImageView *icon = [[R2RImageView alloc] initWithFrame:CGRectMake(20, cell.contentView.bounds.size.height/2-6, 12, 12)];
        [icon setCroppedImage:[UIImage imageNamed:@"sprites6.png"] :CGRectMake(267, 46, 12, 12)];
        
        [cell.contentView addSubview:icon];

//        [cell.contentView setBackgroundColor:[UIColor greenColor]];
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:234.0/256.0 green:228.0/256.0 blue:224.0/256.0 alpha:1.0]];
        
        return cell;
    }
    else
    {
        int routeIndex = floor((indexPath.row%(([self.route.segments count] * 2)+1))/2);
        //int routeIndex = floor(indexPath.row/2);
        
        NSString *CellIdentifier = [self getCellIdentifier:[self.route.segments objectAtIndex:routeIndex]];
        
        id cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell = [self configureHopCell:cell :[self.route.segments objectAtIndex:routeIndex]];
        
//        float duration = [self getSegmentDuration:[self.route.segments objectAtIndex:routeIndex]];
//        NSString *kind = [self getSegmentKind:[self.route.segments objectAtIndex:routeIndex]];
//        NSString *hopDescription = [NSString stringWithFormat:@"%.0f minutes by %@", duration, kind];
//        
//        [[cell hopLabel] setText:hopDescription];
//        
//        R2RImageView *connectTop = [[R2RImageView alloc] initWithFrame:CGRectMake(23, 0, 6, cell.contentView.bounds.size.height/2)];
//        
//        CGRect rect = [self getConnectionRect:[self.route.segments objectAtIndex:routeIndex-1]];
//        [connectTop setCroppedImage:[UIImage imageNamed:@"ConnectionLines"] :rect];
//        [cell.contentView addSubview:connectTop];

        
        return cell;
    }
    
}

//-(NSString*) getSegmentSourceName:(id) segment
//{
//    NSMutableString *sourceName = [[NSMutableString alloc] init];
//    /////////  REDO THIS SECTION
//    if([segment isKindOfClass:[R2RWalkDriveSegment class]])
//    {
//        R2RWalkDriveSegment *currentSegment = segment;
//        [sourceName appendString:currentSegment.sName];
//    }
//    else if([segment isKindOfClass:[R2RTransitSegment class]])
//    {
//        R2RTransitSegment *currentSegment = segment;
//        [sourceName appendString:currentSegment.sName];
//    }
//    else if([segment isKindOfClass:[R2RFlightSegment class]])
//    {
//        R2RFlightSegment *currentSegment = segment;
//        [sourceName appendString:currentSegment.sCode];
//    }
//    
//    return sourceName;
//
//}
//

- (CGRect) getConnectionRect: (id) segment
{
    NSString *kind = [self getSegmentKind:segment];
    
    if ([kind isEqualToString:@"flight"])
    {
        return CGRectMake(0, 0, 10, 50);
    }
    if ([kind isEqualToString:@"train"])
    {
        return CGRectMake(10, 0, 10, 50);
    }
    else if ([kind isEqualToString:@"bus"])
    {
        return CGRectMake(20, 0, 10, 50);
    }
    else if ([kind isEqualToString:@"car"])
    {
        return CGRectMake(30, 0, 10, 50);
    }
    else if ([kind isEqualToString:@"ferry"])
    {
        return CGRectMake(40, 0, 10, 50);
    }
    
    return CGRectMake(50, 0, 10, 50);
}

//- (UIColor *) getConnectionColor: (id) segment
//{
//    NSString *kind = [self getSegmentKind:segment];
//    
//    if ([kind isEqualToString:@"flight"])
//    {
//        return [UIColor colorWithRed:(241.0/256.0) green:(96.0/256.0) blue:(36.0/256.0) alpha:1.0];
//    }
//    else if ([kind isEqualToString:@"train"])
//    {
//        return [UIColor colorWithRed:(48.0/256.0) green:(124.0/256.0) blue:(192.0/256.0) alpha:1.0];
//    }
//    else if ([kind isEqualToString:@"bus"])
//    {
//        return [UIColor colorWithRed:(98.0/256.0) green:(144.0/256.0) blue:(46.0/256.0) alpha:1.0];
//    }
//    else if ([kind isEqualToString:@"ferry"])
//    {
//        return [UIColor colorWithRed:(64.0/256.0) green:(170.0/256.0) blue:(196.0/256.0) alpha:1.0];
//    }
//    else if ([kind isEqualToString:@"car"])
//    {
//        return [UIColor blackColor];
//    }
//    
//    return [UIColor whiteColor];
//}

-(NSString*) getCellIdentifier:(id) segment
{
    
    if([segment isKindOfClass:[R2RWalkDriveSegment class]])
    {
        return @"WalkDriveHopCell";
    }
    else if([segment isKindOfClass:[R2RTransitSegment class]])
    {
        return @"TransitHopCell";
    }
    else if([segment isKindOfClass:[R2RFlightSegment class]])
    {
        return @"FlightHopCell";
    }
    
    return nil;
}

-(id) configureHopCell:(id) cell:(id) segment
{
    if([cell isKindOfClass:[R2RWalkDriveHopCell class]])
    {
        return [self configureWalkDriveHopCell:cell:segment];
    }
    else if([cell isKindOfClass:[R2RTransitHopCell class]])
    {
        return [self configureTransitHopCell:cell:segment];
    }
    else if([cell isKindOfClass:[R2RFlightHopCell class]])
    {
        return [self configureFlightHopCell:cell:segment];
    }
    return nil;
}

-(R2RFlightHopCell *) configureFlightHopCell:(R2RFlightHopCell *) cell:(R2RFlightSegment *) segment
{
    CGRect lineRect;
    CGRect iconRect;
    if ([segment.kind isEqualToString:@"flight"])
    {
        lineRect = CGRectMake(0, 0, 10, 50);
        iconRect = CGRectMake(0, 80, 18, 18);
    }
    else
    {
        lineRect = CGRectMake(50, 0, 10, 50);
        iconRect = CGRectMake(0, 170, 18, 18);
    }
        
    R2RStringFormatters *formatter = [[R2RStringFormatters alloc] init];
    
    NSString *hopDescription = [formatter formatFlightHopCellDescription:segment.duration :0];
//    NSString *hopDescription = [NSString stringWithFormat:@"%.0f minutes by %@", segment.duration, segment.kind];
    [[cell hopLabel] setText:hopDescription];
    
    R2RImageView *connectTop = [[R2RImageView alloc] initWithFrame:CGRectMake(23, 0, 6, cell.contentView.bounds.size.height/2)];
    [connectTop setCroppedImage:[UIImage imageNamed:@"ConnectionLines"] :lineRect];
    [cell.contentView addSubview:connectTop];
    
    R2RImageView *connectBottom = [[R2RImageView alloc] initWithFrame:CGRectMake(23, cell.contentView.bounds.size.height/2, 6, cell.contentView.bounds.size.height/2)];
    [connectBottom setCroppedImage:[UIImage imageNamed:@"ConnectionLines"] :lineRect];
    [cell.contentView addSubview:connectBottom];
    
//    NSLog(@"%f\t%f\t", cell.contentView.bounds.size.height, 0.0);
    
    R2RImageView *icon = [[R2RImageView alloc] initWithFrame:CGRectMake(17, cell.contentView.bounds.size.height/2-9, 18, 18)];
    [icon setCroppedImage:[UIImage imageNamed:@"sprites6"] :iconRect];
    [cell.contentView addSubview:icon];

    return cell;
}

-(R2RTransitHopCell *) configureTransitHopCell:(R2RTransitHopCell *) cell:(R2RTransitSegment *) segment
{
    CGRect lineRect;
    CGRect iconRect;
    if ([segment.kind isEqualToString:@"train"])
    {
        lineRect = CGRectMake(10, 0, 10, 50);
        iconRect = CGRectMake(0, 98, 18, 18);
    }
    else if ([segment.kind isEqualToString:@"bus"])
    {
        lineRect = CGRectMake(20, 0, 10, 50);
        iconRect = CGRectMake(0, 188, 18, 18);
    }
    else if ([segment.kind isEqualToString:@"ferry"])
    {
        lineRect = CGRectMake(30, 0, 10, 50);
        iconRect = CGRectMake(0, 206, 18, 18);
    }
    else
    {
        lineRect = CGRectMake(50, 0, 10, 50);
        iconRect = CGRectMake(0, 170, 18, 18);
    }
    
    R2RSegmentHandler *segmentHandler = [[R2RSegmentHandler alloc] init];
    NSInteger changes = [segmentHandler getTransitChanges:segment];
    NSString *vehicle = [segmentHandler getTransitVehicle:segment];
    NSInteger frequency = [segmentHandler getTransitFrequency:segment];
    
    R2RStringFormatters *formatter = [[R2RStringFormatters alloc] init];
    NSString *hopDescription = [formatter formatTransitHopDescription:segment.duration :changes :frequency :vehicle];
//    NSString *hopDescription = [NSString stringWithFormat:@"%.0f minutes by %@", segment.duration, segment.kind];
    [[cell hopLabel] setText:hopDescription];
    
    R2RImageView *connectTop = [[R2RImageView alloc] initWithFrame:CGRectMake(23, 0, 6, cell.contentView.bounds.size.height/2)];
    [connectTop setCroppedImage:[UIImage imageNamed:@"ConnectionLines"] :lineRect];
    [cell.contentView addSubview:connectTop];
    
    //CGRectMake(23, 20, 6, 20);
//     R2RImageView *connectBottom = [[R2RImageView alloc] initWithFrame:CGRectMake(5, 1, 6, 40)];
    R2RImageView *connectBottom = [[R2RImageView alloc] initWithFrame:CGRectMake(23, cell.contentView.bounds.size.height/2, 6, cell.contentView.bounds.size.height/2)];
    [connectBottom setCroppedImage:[UIImage imageNamed:@"ConnectionLines"] :lineRect];
    [cell.contentView addSubview:connectBottom];
    
    R2RImageView *icon = [[R2RImageView alloc] initWithFrame:CGRectMake(17, cell.contentView.bounds.size.height/2-9, 18, 18)];
    [icon setCroppedImage:[UIImage imageNamed:@"sprites6"] :iconRect];
    [cell.contentView addSubview:icon];
    
//    NSLog(@"%f\t%f\t", cell.contentView.bounds.size.height, cell.contentView.bounds.origin.y);
    
    return cell;
}

-(R2RWalkDriveHopCell *) configureWalkDriveHopCell:(R2RWalkDriveHopCell *) cell:(R2RWalkDriveSegment *) segment
{
    CGRect lineRect;
    CGRect iconRect;
    if ([segment.kind isEqualToString:@"car"])
    {
        lineRect = CGRectMake(30, 0, 10, 50);
        iconRect = CGRectMake(0, 152, 18, 18);
    }
    else
    {
        lineRect = CGRectMake(50, 0, 10, 50);
        iconRect = CGRectMake(0, 170, 18, 18);
    }
    
    R2RStringFormatters *formatter = [[R2RStringFormatters alloc] init];
    NSString *hopDescription = [formatter formatWalkDriveHopCellDescription:segment.duration :segment.distance];
//    NSString *hopDescription = [NSString stringWithFormat:@"%.0f minutes by %@", segment.duration, segment.kind];
    [[cell hopLabel] setText:hopDescription];
    
    R2RImageView *connectTop = [[R2RImageView alloc] initWithFrame:CGRectMake(23, 0, 6, cell.contentView.bounds.size.height/2)];
    [connectTop setCroppedImage:[UIImage imageNamed:@"ConnectionLines"] :lineRect];
    [cell.contentView addSubview:connectTop];
    
    R2RImageView *connectBottom = [[R2RImageView alloc] initWithFrame:CGRectMake(23, cell.contentView.bounds.size.height/2, 6, cell.contentView.bounds.size.height/2)];
    [connectBottom setCroppedImage:[UIImage imageNamed:@"ConnectionLines"] :lineRect];
    [cell.contentView addSubview:connectBottom];
    
    R2RImageView *icon = [[R2RImageView alloc] initWithFrame:CGRectMake(17, cell.contentView.bounds.size.height/2-9, 18, 18)];
    [icon setCroppedImage:[UIImage imageNamed:@"sprites6"] :iconRect];
    [cell.contentView addSubview:icon];
    
//    NSLog(@"%f\t%f\t", cell.contentView.bounds.size.height, 0.0);
    return cell;
}

//-(float) getSegmentDuration:(id) segment
//{
//    float duration;
//
//    if([segment isKindOfClass:[R2RWalkDriveSegment class]])
//    {
//        R2RWalkDriveSegment *currentSegment = segment;
//        duration = currentSegment.duration;
//    }
//    else if([segment isKindOfClass:[R2RTransitSegment class]])
//    {
//        R2RTransitSegment *currentSegment = segment;
//        duration = currentSegment.duration;
//    }
//    else if([segment isKindOfClass:[R2RFlightSegment class]])
//    {
//        R2RFlightSegment *currentSegment = segment;
//        duration = currentSegment.duration;
//    }
//    
//    return duration;
//    
//}

-(NSString*) getSegmentKind:(id) segment
{
    //NSMutableString *kind = [[NSMutableString alloc] init];

    if([segment isKindOfClass:[R2RWalkDriveSegment class]])
    {
        R2RWalkDriveSegment *currentSegment = segment;
//        [kind appendString:currentSegment.kind];
        return currentSegment.kind;
    }
    else if([segment isKindOfClass:[R2RTransitSegment class]])
    {
        R2RTransitSegment *currentSegment = segment;
//        [kind appendString:currentSegment.kind];
        return currentSegment.kind;
    }
    else if([segment isKindOfClass:[R2RFlightSegment class]])
    {
        R2RFlightSegment *currentSegment = segment;
//        [kind appendString:currentSegment.kind];
        return currentSegment.kind;
    }
    
    return nil;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showFlightSegment"])
    {
        R2RFlightSegmentViewController *segmentViewController = [segue destinationViewController];
        segmentViewController.flightSegment = [self.route.segments objectAtIndex:([self.tableView indexPathForSelectedRow].row)/2];
        segmentViewController.airlines = self.airlines;
        segmentViewController.airports = self.airports;
        [segmentViewController sortFlightSegment];
        
    }
    if ([[segue identifier] isEqualToString:@"showTransitSegment"])
    {
        R2RTransitSegmentViewController *segmentViewController = [segue destinationViewController];
        segmentViewController.transitSegment = [self.route.segments objectAtIndex:([self.tableView indexPathForSelectedRow].row)/2];
    }
    if ([[segue identifier] isEqualToString:@"showWalkDriveSegment"])
    {
        R2RWalkDriveSegment *segment = [self.route.segments objectAtIndex:([self.tableView indexPathForSelectedRow].row)/2];
        R2RWalkDriveSegmentViewController *segmentViewController = [segue destinationViewController];
        segmentViewController.walkDriveSegment = segment;
    }

}


- (IBAction)ReturnToSearch:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];

}
@end
