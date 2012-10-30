//
//  R2RFlightSegmentViewController.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 14/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//


#import "R2RFlightSegmentViewController.h"
#import "R2RFlightSegmentCell.h"
#import "R2RFlightSegmentSectionHeader.h"
#import "R2RStringFormatters.h"
//#import "R2RAirline.h"
//#import "R2RAirport.h"
//#import "R2RSprite.h"
#import "R2RFlightGroup.h"

@interface R2RFlightSegmentViewController ()

@property (strong, nonatomic) NSMutableArray *flightGroups;
@property (strong, nonatomic) NSIndexPath *selectedRowIndex; //current selected row. used for unselecting cell on second click

@property (strong, nonatomic) UIActionSheet *linkMenuSheet;
//@property (strong, nonatomic) UIView *linkMenuView;

@property (strong, nonatomic) NSMutableArray *links;

@end

@implementation R2RFlightSegmentViewController

@synthesize dataController, route, flightSegment;

#define MAX_FLIGHT_STOPS 5

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:234.0/256.0 green:228.0/256.0 blue:224.0/256.0 alpha:1.0]];
    
    self.navigationItem.title = @"Fly";
    
    [self.tableView setSectionHeaderHeight:55];
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
    return [self.flightGroups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return [flightSegment.itineraries count];

    R2RFlightGroup *flightGroup = [self.flightGroups objectAtIndex:section];
//    int count = [flightGroup.flights count];
//    return count;
    return [flightGroup.flights count];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, 50);
    
    R2RFlightSegmentSectionHeader *header = [[R2RFlightSegmentSectionHeader alloc] initWithFrame:rect];

    R2RFlightGroup *flightGroup = [self.flightGroups objectAtIndex:section];
    [header.titleLabel setText:flightGroup.name];
    
    NSString *from = [[NSString alloc] initWithString:self.flightSegment.sCode];
    NSString *to = [[NSString alloc] initWithString:self.flightSegment.tCode];

    [header.fromLabel setText:from];
   
    [header.toLabel setText:to];
    
    return header;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedRowIndex && indexPath.section == self.selectedRowIndex.section && indexPath.row == self.selectedRowIndex.row)
    {
        [cell setBackgroundColor:[UIColor colorWithRed:244.0/256.0 green:238.0/256.0 blue:234.0/256.0 alpha:1.0]];
    }
    else
    {
        [cell setBackgroundColor:[UIColor colorWithRed:254.0/256.0 green:248.0/256.0 blue:244.0/256.0 alpha:1.0]];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FlightSegmentCell";
 
    R2RFlightSegmentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
    // Configure the cell...
    
    R2RFlightGroup *flightGroup = [self.flightGroups objectAtIndex:indexPath.section];
    
    R2RFlightItinerary *flightItinerary = [flightGroup.flights objectAtIndex:indexPath.row];
    
    R2RFlightLeg *flightLeg = ([flightItinerary.legs count] > 0) ? [flightItinerary.legs objectAtIndex:0] : nil;
 
    if (cell.flightLeg == flightLeg) return cell;
    
    cell.flightLeg = flightLeg;
    if (flightLeg == nil) return cell;
    
    NSInteger hops = [flightLeg.hops count];
    
    NSString *sTime = [[flightLeg.hops objectAtIndex:0] sTime];
    NSString *tTime = [[flightLeg.hops objectAtIndex:(hops-1)] tTime];
    
    [cell.sTimeLabel setText:sTime];
    [cell.tTimeLabel setText:tTime];
    
    R2RStringFormatters *stringFormatter = [[R2RStringFormatters alloc] init];
    stringFormatter.showMinutesIfZero = YES;
    
    CGRect frame = cell.linkButton.frame;
    frame.origin.y = 75 + (50* (hops-1));
    
    [cell.linkButton setFrame:frame];
    [cell.linkButton setImage:[UIImage imageNamed:@"externalLinkIconGray"] forState:UIControlStateNormal];
    [cell.linkButton addTarget:self action:@selector(showLinkMenu) forControlEvents:UIControlEventTouchUpInside];
    
    frame = cell.frequencyLabel.frame;
    frame.origin.y = 75 + (50* (hops-1));
    [cell.frequencyLabel setFrame:frame];
    
    [cell.frequencyLabel setText:[stringFormatter formatDays:flightLeg.days]];
    
    float duration = 0.0;
    NSString *firstAirlineCode = nil;
    NSString *secondAirlineCode = nil;
    int hopNumber = 0;
    
    for (R2RFlightHop *flightHop in flightLeg.hops)
    {
        duration += flightHop.duration;
        
        if (firstAirlineCode == nil)
        {
            [cell setDisplaySingleIcon];
            firstAirlineCode = flightHop.airline;
        }
        else if (secondAirlineCode == nil && ![flightHop.airline isEqualToString:firstAirlineCode])
        {
            [cell setDisplayDoubleIcon];
            secondAirlineCode = flightHop.airline;
        }

        UILabel *label;

        if (flightHop.lDuration > 0 && hopNumber > 0) //the layover should always be in the second hop but adding this for safety
        {
            for (R2RAirport *airport in self.dataController.search.searchResponse.airports)
            {
                if ([airport.code isEqualToString:flightHop.sCode])
                {
                    label = [cell.layoverNameLabels objectAtIndex:(hopNumber -1)];
                    [label setText:[NSString stringWithFormat:@"Layover at %@", airport.name]];
                    [label setHidden:NO];
                }
            }
            
            label = [cell.layoverDurationLabels objectAtIndex:(hopNumber - 1)];
            [label setText:[stringFormatter formatDuration:flightHop.lDuration]];
            [label setHidden:NO];
            
            duration += flightHop.lDuration;
        } 
        
        for (R2RAirline *airline in self.dataController.search.searchResponse.airlines)
        {
            if ([airline.code isEqualToString:flightHop.airline])
            {   
                UIImageView *imageView =[cell.airlineIcons objectAtIndex:hopNumber];
                R2RSprite *sprite = [[R2RSprite alloc] initWithPath:airline.iconPath :airline.iconOffset :airline.iconSize];
                [self.dataController.spriteStore setSpriteInView:sprite :imageView];
                [imageView setHidden:NO];
                break;
            }
        }
        
        label = [cell.sAirportLabels objectAtIndex:hopNumber];
        [label setText:flightHop.sCode];
        [label setHidden:NO];
        
        label = [cell.tAirportLabels objectAtIndex:hopNumber];
        [label setText:flightHop.tCode];
        [label setHidden:NO];
        
        label = [cell.hopDurationLabels objectAtIndex:hopNumber];
        [label setText:[stringFormatter formatDuration:flightHop.duration]];
        [label setHidden:NO];
        
        hopNumber++;
    }
    
    [cell.durationLabel setText:[stringFormatter formatDuration:duration]];
    
    for (R2RAirline *airline in self.dataController.search.searchResponse.airlines)
    {
        if ([airline.code isEqualToString:firstAirlineCode])
        {
            R2RSprite *sprite = [[R2RSprite alloc] initWithPath:airline.iconPath :airline.iconOffset :airline.iconSize];
            [self.dataController.spriteStore setSpriteInView:sprite :cell.firstAirlineIcon];
        }
        if ([airline.code isEqualToString:secondAirlineCode])
        {
            R2RSprite *sprite = [[R2RSprite alloc] initWithPath:airline.iconPath :airline.iconOffset :airline.iconSize];
            [self.dataController.spriteStore setSpriteInView:sprite :cell.secondAirlineIcon];
        }
    }
    
    //1 less layover than stops
    for (int i = hops; i < MAX_FLIGHT_STOPS; i++)
    {
        UILabel *label = [cell.layoverNameLabels objectAtIndex:(i-1)];
        [label setHidden:YES];
        label = [cell.layoverDurationLabels objectAtIndex:(i-1)];
        [label setHidden:YES];
        
        
        UIImageView *view = [cell.airlineIcons objectAtIndex:i];
        [view setHidden:YES];
        label = [cell.flightNameLabels objectAtIndex:i];
        [label setHidden:YES];
        label = [cell.hopDurationLabels objectAtIndex:i];
        [label setHidden:YES];
        label = [cell.sAirportLabels objectAtIndex:i];
        [label setHidden:YES];
        label = [cell.tAirportLabels objectAtIndex:i];
        [label setHidden:YES];
        label = [cell.joinerLabels objectAtIndex:i];
        [label setHidden:YES];
    }
    

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
    [self dismissLinkMenu];
    
    NSIndexPath *prevIndex = self.selectedRowIndex;

    if (self.selectedRowIndex && indexPath.section == self.selectedRowIndex.section && indexPath.row == self.selectedRowIndex.row)
    {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        self.selectedRowIndex = nil;
    }
    else
    {
        self.selectedRowIndex = indexPath;
    }

    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:2];
    if (prevIndex)
        [indexPaths addObject:prevIndex];
    if (self.selectedRowIndex)
        [indexPaths addObject:self.selectedRowIndex];
    
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //check if the index actually exists
    if(self.selectedRowIndex && indexPath.row == self.selectedRowIndex.row && indexPath.section == self.selectedRowIndex.section)
    {
        R2RFlightGroup *flightGroup = [self.flightGroups objectAtIndex:indexPath.section];
        R2RFlightItinerary *flightItinerary = [flightGroup.flights objectAtIndex:indexPath.row];
        R2RFlightLeg *flightLeg = [flightItinerary.legs objectAtIndex:0];
        NSInteger hops = [flightLeg.hops count];
        return (115+(50*(hops-1)));
    }
    return 30;
}

- (IBAction)ReturnToSearch:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) sortFlightSegment
{
    self.flightGroups = [[NSMutableArray alloc] init]; //
    
    for (R2RFlightItinerary *itinerary in flightSegment.itineraries)
    {
        if ([itinerary.legs count] == 0)
        {
            continue;
        }
        R2RFlightLeg *leg = [itinerary.legs objectAtIndex:0];
        int hops = [leg.hops count];
        if (hops == 0)
        {
            continue;
        }
        
        R2RFlightGroup *flightGroup = nil;
        
        for (R2RFlightGroup *group in self.flightGroups)
        {
            if (group.hops == hops)
            {
                flightGroup = group;
                break;
            }
        }
        
        if (flightGroup == nil)
        {
            flightGroup = [[R2RFlightGroup alloc] initWithHops:hops];
            [self.flightGroups addObject:flightGroup];
        }
        
        [flightGroup.flights addObject:itinerary];
        
    }
    
    for (R2RFlightGroup *flightGroup in self.flightGroups)
    {
        [flightGroup.flights sortUsingComparator:^(R2RFlightItinerary *itin1, R2RFlightItinerary *itin2){
            R2RFlightLeg *leg1 = [itin1.legs objectAtIndex:0];
            R2RFlightLeg *leg2 = [itin2.legs objectAtIndex:0];
            R2RFlightHop *hop1 = [leg1.hops objectAtIndex:0];
            R2RFlightHop *hop2 = [leg2.hops objectAtIndex:0];
            return [hop1.sTime compare:hop2.sTime];
        }];
        
        [flightGroup.flights sortUsingComparator:^(R2RFlightItinerary *itin1, R2RFlightItinerary *itin2){
            R2RFlightLeg *leg1 = [itin1.legs objectAtIndex:0];
            R2RFlightLeg *leg2 = [itin2.legs objectAtIndex:0];
            R2RFlightHop *hop1 = [leg1.hops objectAtIndex:0];
            R2RFlightHop *hop2 = [leg2.hops objectAtIndex:0];
            return [hop1.airline compare:hop2.airline];
        }];
    }

}

- (void) showLinkMenu
{

    self.links = [[NSMutableArray alloc] init];
    
    NSIndexPath *indexPath = self.selectedRowIndex;
    
    R2RFlightGroup *flightGroup = [self.flightGroups objectAtIndex:indexPath.section];
    R2RFlightItinerary *flightItinerary = [flightGroup.flights objectAtIndex:indexPath.row];
    R2RFlightLeg *flightLeg = [flightItinerary.legs objectAtIndex:0];
    
    
    self.linkMenuSheet = [[UIActionSheet alloc] initWithTitle:@"External Links"
                                                     delegate:self
                                            cancelButtonTitle:nil
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:nil];

    NSMutableArray *airlines = [[NSMutableArray alloc] init];
    
    for (R2RFlightHop *flightHop in flightLeg.hops)
    {
        bool airlineFound = NO;
        for (R2RAirline *airline in airlines)
        {
            if ([flightHop.airline isEqualToString:airline.code])
            {
                airlineFound = YES;
                break;
            }
        }
        if (!airlineFound)
        {
            for (R2RAirline *airline in self.dataController.search.searchResponse.airlines)
            {
                if ([flightHop.airline isEqualToString:airline.code])
                {
                    [self.linkMenuSheet addButtonWithTitle:airline.name];
                    [airlines addObject:airline];
                    [self.links addObject:airline.url];
                    break;
                }
            }
        }
    }
    
    [self.linkMenuSheet addButtonWithTitle:@"cancel"];
    [self.linkMenuSheet setCancelButtonIndex:[airlines count]];
    
    [self.linkMenuSheet showInView:self.view];
}

- (void) dismissLinkMenu
{
    
    
//    [UIView beginAnimations:nil context: nil];
//    [UIView setAnimationDuration: 1.5];
//    
//    //
//    //    CGRect rect = CGRectMake(0, self.view.bounds.size.height-60, self.view.bounds.size.width, 60);
//    //    UIView *view = [[UIView alloc] initWithFrame:rect];
//    //    [view setBackgroundColor:[UIColor darkGrayColor]];
//    //
//    CGRect rect = CGRectMake(0, self.view.bounds.size.width, self.view.frame.size.height, 90);
//    [self.linkMenuView setFrame:rect];
//    
//    [self.linkMenuView setHidden:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [self.links count])
        return;
    
    R2RLog(@"Button %d", buttonIndex);
    NSURL *url = [self.links objectAtIndex:buttonIndex];
    if ([[url absoluteString] length] > 0)
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
