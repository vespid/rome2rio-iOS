//
//  R2RFlight2ViewController.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 23/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RFlight2ViewController.h"

#import "R2RFlightSegmentSectionHeader.h"
#import "R2RFlightSegmentCell.h"
#import "R2RStringFormatters.h"
#import "R2RFlightGroup.h"

@interface R2RFlight2ViewController ()

@property (strong, nonatomic) NSMutableArray *flightGroups;
@property (strong, nonatomic) NSIndexPath *selectedRowIndex; //current selected row. used for unselecting cell on second click

@end

@implementation R2RFlight2ViewController

@synthesize dataController, route, flightSegment;
@synthesize flightsTable, linkMenu;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:234.0/256.0 green:228.0/256.0 blue:224.0/256.0 alpha:1.0]];
    
    self.navigationItem.title = @"Fly";
    
    [self.flightsTable setSectionHeaderHeight:55];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setFlightsTable:nil];
    [self setLinkMenu:nil];
    [super viewDidUnload];
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
    
    //    NSString *joiner = @" to ";
    //    CGSize joinerSize = [joiner sizeWithFont:header.titleLabel.font]; //change to font of choice
    //    rect = CGRectMake((self.view.bounds.size.width/2)-(joinerSize.width/2), 30, joinerSize.width, 25);
    //    [header.joinerLabel setFrame:rect];
    
    //    rect = CGRectMake(0, 30, (self.view.bounds.size.width/2)-(joinerSize.width/2), 25);
    //    [header.fromLabel setFrame:rect];
    [header.fromLabel setText:from];
    
    //    rect = CGRectMake((self.view.bounds.size.width/2)+(joinerSize.width/2), 30, (self.view.bounds.size.width/2)-(joinerSize.width/2), 25);
    //    [header.toLabel setFrame:rect];
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
    
    bool selected = NO;
    if (self.selectedRowIndex && indexPath.section == self.selectedRowIndex.section && indexPath.row == self.selectedRowIndex.row)
    {
        selected = YES;
    }
    
    //    R2RLog(@"%@\t%@", indexPath, self.selectedRowIndex);
    
    static NSString *CellIdentifier = @"FlightSegmentCell";
    
    R2RFlightSegmentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    //    UITableView *table = self.tableView;
    //    NSLog(@"%@", table);
    
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
    
    [cell.linkButton setImage:[UIImage imageNamed:@"externalLinkIconGray"] forState:UIControlStateNormal];
    [cell.linkButton addTarget:self action:@selector(showLinkMenu) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.frequencyLabel setText:@"Operates Mon to Sun"];
    
    float duration = 0.0;
    NSString *firstAirlineCode = nil;
    NSString *secondAirlineCode = nil;
    int hopNumber = 0;
    
    for (R2RFlightHop *flightHop in flightLeg.hops)
    {
        duration += flightHop.duration;
        if (flightHop.lDuration > 0)
        {
            duration += flightHop.lDuration;
        }
        
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
        for (R2RAirline *airline in self.dataController.search.searchResponse.airlines)
        {
            if ([airline.code isEqualToString:flightHop.airline])
            {
                R2RSprite *sprite = [[R2RSprite alloc] initWithPath:airline.iconPath :airline.iconOffset :airline.iconSize];
                [self.dataController.spriteStore setSpriteInView:sprite :[cell.airlineIcons objectAtIndex:hopNumber]];
                label = [cell.airlineNameLabels objectAtIndex:hopNumber];
                [label setText:airline.name];
                break;
            }
        }
        
        label = [cell.flightNameLabels objectAtIndex:hopNumber];
        [label setText:[NSString stringWithFormat:@"%@%@", flightHop.airline, flightHop.flight]];
        
        label = [cell.hopDurationLabels objectAtIndex:hopNumber];
        [label setText:[stringFormatter formatDuration:flightHop.duration]];
        
        if (flightHop.lDuration > 0 && hopNumber > 0) //the layover should always be in the second hop but adding this for safety
        {
            for (R2RAirport *airport in self.dataController.search.searchResponse.airports)
            {
                if ([airport.code isEqualToString:flightHop.sCode])
                {
                    label = [cell.layoverNameLabels objectAtIndex:(hopNumber -1)];
                    [label setText:[NSString stringWithFormat:@"Layover at %@", airport.name]];
                }
            }
            
            label = [cell.layoverDurationLabels objectAtIndex:(hopNumber - 1)];
            [label setText:[stringFormatter formatDuration:flightHop.lDuration]];
            
            duration += flightHop.lDuration;
        }
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
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissLinkMenu];
    
    //    R2RLog(@"%@\t%@", self.selectedRowPath, indexPath);
    NSIndexPath *prevIndex = self.selectedRowIndex;
    
    if (self.selectedRowIndex && indexPath.section == self.selectedRowIndex.section && indexPath.row == self.selectedRowIndex.row)
    {
        [self.flightsTable deselectRowAtIndexPath:indexPath animated:YES];
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
    
    //    [self.tableView reloadSections: [NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    [self.flightsTable reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //check if the index actually exists
    if(self.selectedRowIndex && indexPath.row == self.selectedRowIndex.row && indexPath.section == self.selectedRowIndex.section)
    {
        R2RFlightGroup *flightGroup = [self.flightGroups objectAtIndex:indexPath.section];
        R2RFlightItinerary *flightItinerary = [flightGroup.flights objectAtIndex:indexPath.row];
        R2RFlightLeg *flightLeg = [flightItinerary.legs objectAtIndex:0];
        NSInteger hops = [flightLeg.hops count];
        return (85+(50*(hops-1)));
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
}

- (void) showLinkMenu
{
//    NSIndexPath *indexPath = self.selectedRowIndex;
//    
//    R2RFlightGroup *flightGroup = [self.flightGroups objectAtIndex:indexPath.section];
//    R2RFlightItinerary *flightItinerary = [flightGroup.flights objectAtIndex:indexPath.row];
//    R2RFlightLeg *flightLeg = [flightItinerary.legs objectAtIndex:0];
//    
//    [self.linkMenuView setHidden:NO];
//    
//    [UIView beginAnimations:nil context: nil];
//    [UIView setAnimationDuration: 1.5];
//    
//    CGRect tableRect = CGRectMake(0, 0, self.view.bounds.size.width, self.view.frame.size.height-90);
//    
//    [self.flightsTable setFrame:tableRect];
//    
//    CGRect rect = CGRectMake(0, self.view.frame.size.height-90, self.view.bounds.size.width, 90);
//    [self.linkMenuView setFrame:rect];
    
}

- (void) dismissLinkMenu
{
//    [UIView beginAnimations:nil context: nil];
//    [UIView setAnimationDuration: 1.5];
//
//    CGRect rect = CGRectMake(0, self.view.bounds.size.width, self.view.frame.size.height, 90);
//    [self.linkMenuView setFrame:rect];
//    
//    [self.linkMenuView setHidden:YES];
}
@end
