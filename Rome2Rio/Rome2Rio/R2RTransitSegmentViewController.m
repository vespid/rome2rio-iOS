//
//  R2RTransitSegmentViewController.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 14/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RTransitSegmentViewController.h"
#import "R2RTransitSegmentCell.h"
#import "R2RTitleLabel.h"
#import "R2RTransitSegmentHeader.h"
#import "R2RAgency.h"

#import "R2RStringFormatters.h"
#import "R2RSegmentHandler.h"
#import "R2RTransitAgencyIconLoader.h"
#import "R2RButtonWithUrl.h"
#import "R2RTransitLine.h"

@interface R2RTransitSegmentViewController () <R2RTransitAgencyIconLoaderDelegate>

//@property (strong, nonatomic) R2RTransitSegmentHeader *header;
@property (strong, nonatomic) NSMutableDictionary *iconDownloadsInProgress;
@property (strong, nonatomic) NSMutableArray *legs;

@end

@implementation R2RTransitSegmentViewController

@synthesize transitSegment, agencies;// agencyIcons;

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
    
    self.iconDownloadsInProgress = [NSMutableDictionary dictionary];  //maybe move this to init
    
    [self.tableView setBackgroundColor:[UIColor colorWithRed:234.0/256.0 green:228.0/256.0 blue:224.0/256.0 alpha:1.0]];
    
    [self.tableView setSectionFooterHeight:10.0];
    [self.tableView setSectionHeaderHeight:40];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footer;
    
    R2RStringFormatters *stringFormatter = [[R2RStringFormatters alloc] init];
    NSString *navigationTitle = [stringFormatter capitaliseFirstLetter:transitSegment.kind];
    self.navigationItem.title = navigationTitle;
    
    self.legs = [NSMutableArray array];
    [self sortLegs];

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

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, 35);
    
    R2RTransitSegmentHeader *header = [[R2RTransitSegmentHeader alloc] initWithFrame:rect];
    
    if ([self.transitSegment.itineraries count] == 0)
    {
        // if no itinerary return blank header
        return header;
    }
    
//    R2RTransitItinerary *transitItinerary = [self.transitSegment.itineraries objectAtIndex:0];
//    R2RTransitLeg *transitLeg = [transitItinerary.legs objectAtIndex:section];
    
    R2RTransitLeg *transitLeg = [self.legs objectAtIndex:section];
    R2RTransitHop *transitHop = [transitLeg.hops objectAtIndex:0];
    
    
    [header.agencyIconView addTarget:self action:@selector(agencyClicked:) forControlEvents:UIControlEventTouchUpInside];
    [header.agencyNameLabel addTarget:self action:@selector(agencyClicked:) forControlEvents:UIControlEventTouchUpInside];
    [header.agencyIconView setUrl:transitLeg.url];
    [header.agencyNameLabel setUrl:transitLeg.url];

    NSString *agencyName = nil;
    
//    for (R2RTransitLine *line in transitHop.lines)
//    just using first agency (most frequent) for now
    R2RTransitLine *transitLine = nil;
    if ([transitHop.lines count] > 0)
    {
        transitLine = [transitHop.lines objectAtIndex:0];
    }
    else
    {
        transitLine = [[R2RTransitLine alloc] init];
    }
        
    CGSize iconSize = CGSizeMake(27, 23);
    NSInteger iconPadding = 5;
    NSInteger startX = 15;// (header.bounds.size.width-(agencyNameLabelSize.width + iconSize.width + iconPadding))/2;
    
    rect = CGRectMake(startX, 9, iconSize.width, iconSize.height);
    [header.agencyIconView setFrame:rect];
//    UIImage *agencyIcon = nil;
    
    for (R2RAgency *agency in self.agencies)
    {
        if ([agency.code isEqualToString:transitLine.agency])
        {
            agencyName = agency.name;
            if ([agency.iconPath length] == 0)
            {
                //allow for smaller icon
                iconSize = CGSizeMake(18, 18);
                iconPadding = 9;
                startX = 19;
                rect = CGRectMake(startX, 11, iconSize.width, iconSize.height);
                
                [header.agencyIconView setFrame:rect];
                R2RSegmentHandler *segmentHandler = [[R2RSegmentHandler alloc] init];
                [header.agencyIconView setImage:[segmentHandler getRouteIcon:transitSegment.kind] forState:UIControlStateNormal];
                //        [header.agencyIconView setImage:[segmentHandler getRouteIcon:transitSegment.kind]];
            }
            else
            {
//                agencyIcon = [self.agencyIcons objectForKey:agency];
                if (agency.icon)
                {
                    [header.agencyIconView setImage:agency.icon forState:UIControlStateNormal];
                }
                else
                {
                    [self startIconDownload:agency forIndexPath:section];
                    [header.agencyIconView setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                }
            }
            
        }

    }
//    
//    if ([transitHop.iconPath length] == 0)
//    {
//        //allow for smaller icon
//        iconSize = CGSizeMake(18, 18);
//        iconPadding = 9;
//        startX = 19;
//        rect = CGRectMake(startX, 11, iconSize.width, iconSize.height);
//
//        [header.agencyIconView setFrame:rect];
//        R2RSegmentHandler *segmentHandler = [[R2RSegmentHandler alloc] init];
//        [header.agencyIconView setImage:[segmentHandler getRouteIcon:transitSegment.kind] forState:UIControlStateNormal];
////        [header.agencyIconView setImage:[segmentHandler getRouteIcon:transitSegment.kind]];
//    }
//    else
//    {
//        agencyIcon = [self.agencyIcons objectForKey:agency];
//        if (agencyIcon)
//        {
//            [header.agencyIconView setImage:agencyIcon forState:UIControlStateNormal];
//        }
//        else
//        {
//            [self startIconDownload:transitHop forIndexPath:section];
//            [header.agencyIconView setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        }
//    }
    if ([agencyName length] == 0)
    {
        R2RStringFormatters *formatter = [[R2RStringFormatters alloc] init];
        agencyName = [formatter capitaliseFirstLetter:transitLine.vehicle];
    }
    
    CGSize agencyNameLabelSize = [agencyName sizeWithFont:[UIFont fontWithName:@"Helvetica" size:17.0]];
    rect = CGRectMake(startX + iconSize.width + iconPadding, 8, agencyNameLabelSize.width, 25);
    
    [header.agencyNameLabel setFrame:rect];
    [header.agencyNameLabel setTitle:agencyName forState:UIControlStateNormal];
        
    return header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    
//    if ([self.legs count] == 0) return 0;
//    
//    R2RTransitItinerary *transitItinerary = [self.transitSegment.itineraries objectAtIndex:0];
//
//    return [transitItinerary.legs count];

    return [self.legs count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if ([self.transitSegment.itineraries count] == 0) return 0;
    
//    R2RTransitItinerary *transitItinerary = [self.transitSegment.itineraries objectAtIndex:0];
//    R2RTransitLeg *transitLeg = [transitItinerary.legs objectAtIndex:section];
    R2RTransitLeg *transitLeg = [self.legs objectAtIndex:section];
    
    return [transitLeg.hops count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TransitSegmentCell";	
    R2RTransitSegmentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    // Configure the cell...
    
    if ([self.transitSegment.itineraries count] == 0)
    {
        // if no itinerary return blank cell
        return cell; 
    }
    
//    R2RTransitItinerary *transitItinerary = [self.transitSegment.itineraries objectAtIndex:0];
//    R2RTransitLeg *transitLeg = [transitItinerary.legs objectAtIndex:indexPath.section];
    R2RTransitLeg *transitLeg = [self.legs objectAtIndex:indexPath.section];
    R2RTransitHop *transitHop = [transitLeg.hops objectAtIndex:indexPath.row];
    
    R2RStringFormatters *stringFormatter = [[R2RStringFormatters alloc] init];
//    NSString *vehicle = [stringFormatter formatTransitHopVehicle: transitHop.vehicle];
                
    [cell.fromLabel setText:transitHop.sName];
    [cell.toLabel setText:transitHop.tName];
    
    
    // the resizing of frames in not necessary with current static positioned labels
    NSString *duration = [stringFormatter formatDuration:transitHop.duration];
    NSString *frequency = [stringFormatter formatFrequency:transitHop.frequency];
    NSString *description = [NSString stringWithFormat:@"%@, %@", duration, frequency];
    CGSize durationSize = [description sizeWithFont:[UIFont fontWithName:@"Helvetica" size:17.0]];
    
//    CGSize iconSize = CGSizeMake(18, 18);
//    NSInteger iconPadding = 5;
    NSInteger startX = 40;//(cell.bounds.size.width-(durationSize.width + iconSize.width + iconPadding))/2;
    
//    CGRect rect = CGRectMake(startX, 34, iconSize.width, iconSize.height);
//    [cell.transitVehicleIcon setFrame:rect];
//    R2RSegmentHandler *segmentHandler = [[R2RSegmentHandler alloc] init];
//    [cell.transitVehicleIcon setImage:[segmentHandler getRouteIcon:self.transitSegment.kind]];
//    
//    rect = CGRectMake(startX + iconSize.width + iconPadding, 30, durationSize.width, 25);

    CGRect rect = CGRectMake(startX, 30, durationSize.width, 25);
    [cell.durationLabel setFrame:rect];
    [cell.durationLabel setText:description];
//    
//    [cell.frequencyLabel setText:[stringFormatter formatFrequency:transitHop.frequency]];
    
    NSMutableString *lineLabel = [[NSMutableString alloc] init];
    
    for (R2RTransitLine *line in transitHop.lines)
    {
        if ([line.name length] > 0)
        {
            [lineLabel appendString:line.name];
            if (line != [transitHop.lines lastObject])
            {
                [lineLabel appendString:@", "];
            }
        }
    }
    
    if ([lineLabel length] > 0)
    {
        [cell.lineLabel setHidden:NO];
        NSString *line = [NSString stringWithFormat:@"Line: %@", lineLabel];
        [cell.lineLabel setText:line];
        rect = CGRectMake(20, 80, cell.toLabel.bounds.size.width, 25);
        [cell.toLabel setFrame:rect];
    }
    else
    {
        [cell.lineLabel setHidden:YES];
        rect = CGRectMake(20, 55, cell.toLabel.bounds.size.width, 25);
        [cell.toLabel setFrame:rect];
    }
    
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    R2RTransitLeg *transitLeg = [self.legs objectAtIndex:indexPath.section];
    R2RTransitHop *transitHop = [transitLeg.hops objectAtIndex:indexPath.row];
    
    NSMutableString *lineLabel = [[NSMutableString alloc] init];
    
    for (R2RTransitLine *line in transitHop.lines)
    {
        [lineLabel appendString:line.name];
    }
    
    if ([lineLabel length] == 0)
    {
        return 85;
    }
    else
    {
        return 115;
    }
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

- (void)startIconDownload:(R2RAgency *)agency forIndexPath:(NSInteger )section
{
    R2RTransitAgencyIconLoader *iconLoader = [self.iconDownloadsInProgress objectForKey:agency.code];
    if (iconLoader == nil)
    {
        iconLoader = [[R2RTransitAgencyIconLoader alloc] initWithIconPath:agency.iconPath delegate:self];
        iconLoader.agency = agency;
        iconLoader.iconOffset = agency.iconOffset;
        iconLoader.section = section;
        
        [self.iconDownloadsInProgress setObject:iconLoader forKey:agency.code];

        [iconLoader sendAsynchronousRequest];
    }
}

-(void) r2rTransitAgencyIconLoaded:(R2RTransitAgencyIconLoader *)delegateIconLoader
{
    R2RTransitAgencyIconLoader *iconLoader = [self.iconDownloadsInProgress objectForKey:delegateIconLoader.agency.code];
    if (iconLoader)
    {
        iconLoader.agency.icon = iconLoader.sprite.sprite;
        
        
//        [self.agencyIcons setObject:delegateIconLoader.sprite.sprite forKey:delegateIconLoader.agency];
        
//        [self.tableView reloadSectionIndexTitles];
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:delegateIconLoader.section] withRowAnimation:UITableViewRowAnimationNone];
                
    }

}

-(void) sortLegs
{
    R2RTransitItinerary *transitItinerary = [self.transitSegment.itineraries objectAtIndex:0];
    
    NSInteger count = 0;
//    R2RTransitHop *prevHop = nil;
    
    R2RTransitLine *prevHopLine = nil;   
    
    for (R2RTransitLeg *transitLeg in transitItinerary.legs)
    {
        for (R2RTransitHop *transitHop in transitLeg.hops)
        {
            R2RTransitLine *hopLine = nil;
            
            if ([transitHop.lines count] > 0)
            {
                hopLine = [transitHop.lines objectAtIndex:0];
            }
            else
            {
                 continue;
            }
            
            if (![hopLine.agency isEqualToString:prevHopLine.agency])
            {
                R2RTransitLeg *newLeg = [[R2RTransitLeg alloc] init];
                newLeg.host = transitLeg.host;
                newLeg.url = transitLeg.url;
                
                newLeg.hops = [NSMutableArray array];
                [newLeg.hops addObject:transitHop];
                
                [self.legs addObject:newLeg];
                
                prevHopLine = hopLine;
                
                count++;
            }
            else
            {
                R2RTransitLeg *currentLeg = [self.legs objectAtIndex:count-1];
                [currentLeg.hops addObject:transitHop];
            }
            
        }
    }
    
//    NSInteger i = 0;
//    NSInteger j = 0;
//    for (R2RTransitLeg *leg in self.legs)
//    {
//        for (R2RTransitHop *hop in leg.hops)
//        {
//            NSLog(@"%d\t%d\t%@", i, j, hop.sName);
//            j++;
//        }
//        j = 0;
//        i++;
//    }
    
}


//-(void)agencyClicked
//{
//    [self.view setBackgroundColor:[UIColor yellowColor]];
//}

-(void)agencyClicked:(R2RButtonWithUrl *) agencyButton
{
    NSString *urlString = [agencyButton.url absoluteString];
    if ([urlString length] > 0)
    {
        [[UIApplication sharedApplication] openURL:agencyButton.url];
    }
    NSLog(@"%@", agencyButton);
}

@end
