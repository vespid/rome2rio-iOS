//
//  R2RFlightSegmentViewController.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 14/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RFlightSegmentViewController.h"
#import "R2RFlightSegmentCell.h"

@interface R2RFlightSegmentViewController ()

@end

@implementation R2RFlightSegmentViewController

@synthesize flightSegment;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [flightSegment.itineraries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FlightSegmentCell";
    R2RFlightSegmentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    R2RFlightItinerary *flightItinerary = [self.flightSegment.itineraries objectAtIndex:indexPath.row];
    
    NSMutableString *airline = [[NSMutableString alloc] init];
    float duration = 0.0;
    //NSDate *sTime =
    NSMutableString *sTime = [[NSMutableString alloc] init];
    NSMutableString *tTime = [[NSMutableString alloc] init];
    
    R2RFlightLeg *flightLeg = [flightItinerary.legs objectAtIndex:0];
    for (R2RFlightHop *flightHop in flightLeg.hops)
    {
        [airline appendString:flightHop.airline];
        [airline appendString: @" "];
        
        if ([sTime isEqualToString:@""])
        {
            [sTime setString: [NSString stringWithFormat:@"%.0f", flightHop.sTime]];
        }
        [tTime setString:[NSString stringWithFormat:@"%.0f", flightHop.tTime]];
        duration += flightHop.duration;
    
    }
    
    [[cell airlineLabel] setText:airline];
    [[cell departureTimeLabel] setText:sTime];
    [[cell arrivalTimeLabel] setText:tTime];
    [[cell durationLabel] setText:[NSString stringWithFormat:@"%f", duration]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
