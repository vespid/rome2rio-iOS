//
//  R2RFlightSegmentViewController.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 14/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//


#import "R2RFlightSegmentViewController.h"
#import "R2RFlightSegmentCell.h"
#import "R2RTitleLabel.h"
#import "R2RAirline.h"
#import "R2RAirport.h"
#import "R2RStringFormatters.h"
#import "R2RSprite.h"

@interface R2RFlightSegmentViewController ()

@property (strong, nonatomic) NSMutableArray *flightGroups;

@end

@implementation R2RFlightSegmentViewController

@synthesize flightSegment, airports, airlines, iconDownloadsInProgress;

//
//-(id)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        
//        // Custom initialization
//    }
//    return self;
//}

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
    
    self.iconDownloadsInProgress = [NSMutableDictionary dictionary];
    [self.tableView setSectionHeaderHeight:55];
    
//    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 30)];
//    [label setText:@"this is a header"];
//    [header addSubview:label];
//    
////    [self.view addSubview:header];
////    [super.view addSubview:header];
//                      
//    self.tableView.tableHeaderView = header;

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
    return [self.flightGroups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return [flightSegment.itineraries count];

    FlightGroup *flightGroup = [self.flightGroups objectAtIndex:section];
//    int count = [flightGroup.flights count];
//    return count;
    return [flightGroup.flights count];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
//    [header setAlpha:1.0];
    [header setBackgroundColor:[UIColor colorWithRed:234.0/256.0 green:228.0/256.0 blue:224.0/256.0 alpha:1.0]];
    
    R2RTitleLabel *titleLabel = [[R2RTitleLabel alloc] initWithFrame:CGRectMake(0, 5, self.view.bounds.size.width, 25)];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    [titleLabel setBackgroundColor:[UIColor colorWithRed:234.0/256.0 green:228.0/256.0 blue:224.0/256.0 alpha:1.0]];
    FlightGroup *flightGroup = [self.flightGroups objectAtIndex:section];
    [titleLabel setText:flightGroup.name];
    [header addSubview:titleLabel];
    
    NSString *from = [[NSString alloc] init];
    NSString *to = [[NSString alloc] init];
    for (R2RAirport *airport in self.airports)
    {
        if ([airport.code isEqualToString:self.flightSegment.sCode])
        {
            from = [NSString stringWithString:airport.code];
        }
        if ([airport.code isEqualToString:self.flightSegment.tCode])
        {
            to = [NSString stringWithString:airport.code];
        }
    
    }
    
    NSString *joiner = @" to ";
    CGSize joinerSize = [joiner sizeWithFont:titleLabel.font]; //change to font of choice
    
    CGRect rect = CGRectMake((self.view.bounds.size.width/2)-(joinerSize.width/2), 30, joinerSize.width, 25);
    
    UILabel *joinerLabel = [[UILabel alloc] initWithFrame:rect];
    [joinerLabel setTextAlignment:UITextAlignmentCenter];
    [joinerLabel setBackgroundColor:[UIColor colorWithRed:234.0/256.0 green:228.0/256.0 blue:224.0/256.0 alpha:1.0]];
    [joinerLabel setText:joiner];
    [joinerLabel setTextColor:[UIColor lightGrayColor]];
    [header addSubview:joinerLabel];
    
    rect = CGRectMake(0, 30, (self.view.bounds.size.width/2)-(joinerSize.width/2), 25);
    UILabel *fromLabel = [[UILabel alloc] initWithFrame:rect];
    [fromLabel setTextAlignment:UITextAlignmentRight];
    [fromLabel setBackgroundColor:[UIColor colorWithRed:234.0/256.0 green:228.0/256.0 blue:224.0/256.0 alpha:1.0]];
    [fromLabel setMinimumFontSize:10.0];
    [fromLabel setAdjustsFontSizeToFitWidth:YES];
    [fromLabel setText:from];
    [header addSubview:fromLabel];
    
    rect = CGRectMake((self.view.bounds.size.width/2)+(joinerSize.width/2), 30, (self.view.bounds.size.width/2)-(joinerSize.width/2), 25);
    UILabel *toLabel = [[UILabel alloc] initWithFrame:rect];
    [toLabel setTextAlignment:UITextAlignmentLeft];
    [toLabel setBackgroundColor:[UIColor colorWithRed:234.0/256.0 green:228.0/256.0 blue:224.0/256.0 alpha:1.0]];
    [toLabel setMinimumFontSize:10.0];
    [toLabel setAdjustsFontSizeToFitWidth:YES];
    [toLabel setText:to];
    [header addSubview:toLabel];
    
    return header;
    
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//	// The header for the section is the region name -- get this from the region at the section index.
//    
//    FlightGroup *flightGroup = [self.flightGroups objectAtIndex:section];
//	return [flightGroup name];
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FlightSegmentCell";
    R2RFlightSegmentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
//    UITableView *table = self.tableView;
//    NSLog(@"%@", table);
    
    FlightGroup *flightGroup = [self.flightGroups objectAtIndex:indexPath.section];
    
    R2RFlightItinerary *flightItinerary = [flightGroup.flights objectAtIndex:indexPath.row];
    
    R2RFlightLeg *flightLeg = ([flightItinerary.legs count] > 0) ? [flightItinerary.legs objectAtIndex:0] : nil;
    if (cell.flightLeg == flightLeg) return cell;
    
    cell.flightLeg = flightLeg;
    if (flightLeg == nil) return cell;
    
//    for (UIView *view in cell.subviews)
//    {
//        [view removeFromSuperview];
//    }
//    
    
    NSInteger hops = [flightLeg.hops count];
    
    NSString *sTime = [[flightLeg.hops objectAtIndex:0] sTime];
    NSString *tTime = [[flightLeg.hops objectAtIndex:(hops-1)] tTime];
    
    float duration = 0.0;
    
    NSString *firstAirlineCode = nil;
    NSString *secondAirlineCode = nil;
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
    }
    
    for (R2RAirline *airline in self.airlines)
    {
        if ([airline.code isEqualToString:firstAirlineCode])
        {
            if (!airline.icon) //caching
            {
                [self startIconDownload:airline forIndexPath:indexPath];
                [cell.firstAirlineIcon setImage:[UIImage imageNamed:@""]];//placeholder image
                continue;
            }
            else
            {
                [cell.firstAirlineIcon setImage:airline.icon];
            }
            
        }
        if ([airline.code isEqualToString:secondAirlineCode])
        {
            if (!airline.icon) //caching
            {
                [self startIconDownload:airline forIndexPath:indexPath];
                [cell.secondAirlineIcon setImage:[UIImage imageNamed:@""]];//placeholder image
                continue;
            }
            else
            {
                [cell.secondAirlineIcon setImage:airline.icon];
            }
        }
    }
    
    [cell.sTimeLabel setText:sTime];
    [cell.tTimeLabel setText:tTime];
    
    R2RStringFormatters *stringFormatter = [[R2RStringFormatters alloc] init];
    stringFormatter.showMinutesIfZero = YES;
    [cell.durationLabel setText:[stringFormatter formatDuration:duration]];
    
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
        
        FlightGroup *flightGroup = nil;
        
        for (FlightGroup *group in self.flightGroups)
        {
            if (group.hops == hops)
            {
                flightGroup = group;
                break;
            }
        }
        
        if (flightGroup == nil)
        {
            flightGroup = [[FlightGroup alloc] initWithHops:hops];
            [self.flightGroups addObject:flightGroup];
        }
        
        [flightGroup.flights addObject:itinerary];
        
    }
    
//    int itinCount = [self.flightSegment.itineraries count];
//
//    NSLog(@"%d", itinCount);
//    
//    for (FlightGroup *group in self.flightGroups)
//    {
//            NSLog(@"%d", [group.flights count]);
//    }

}


//- (void)startIconDownload:(R2RAirline *)airline
//{
//    R2RIconLoader *iconLoader = [iconDownloadsInProgress objectForKey:airline.code];
//    if (iconLoader == nil)
//    {
//        iconLoader = [[R2RIconLoader alloc] initWithIconPath:airline.iconPath delegate:self];
//        //        iconLoader = [[R2RIconLoader alloc] initWithIconPath:airline.iconPath delegate:self];
//        iconLoader.airline = airline;
//        [iconDownloadsInProgress setObject:iconLoader forKey:airline.code];
//        [iconLoader sendAsynchronousRequest];
//    }
//}

- (void)startIconDownload:(R2RAirline *)airline forIndexPath:(NSIndexPath *)indexPath
{
    R2RAirlineIconLoader *iconLoader = [iconDownloadsInProgress objectForKey:airline.code];
    if (iconLoader == nil)
    {
        iconLoader = [[R2RAirlineIconLoader alloc] initWithIconPath:airline.iconPath delegate:self];
        //        iconLoader = [[R2RIconLoader alloc] initWithIconPath:airline.iconPath delegate:self];
        iconLoader.airline = airline;
        iconLoader.cellPaths = [[NSMutableArray alloc] initWithObjects:indexPath, nil ];
//        [iconLoader.cellPaths addObject:indexPath];
        [iconDownloadsInProgress setObject:iconLoader forKey:airline.code];
        [iconLoader sendAsynchronousRequest];
    }
    else
    {
        if (![iconLoader.cellPaths containsObject:indexPath])
        {
            [iconLoader.cellPaths addObject:indexPath];
        }
    }
    
    
//    R2RAirlineIconLoader *iconLoader = [iconDownloadsInProgress objectForKey:indexPath];
//    if (iconLoader == nil)
//    {
//        
//        iconLoader = [[R2RAirlineIconLoader alloc] initWithIconPath:airline.iconPath delegate:self];
////        iconLoader = [[R2RIconLoader alloc] initWithIconPath:airline.iconPath delegate:self];
//        iconLoader.airline = airline;
//        iconLoader.indexPathInTableView = indexPath;
//        [iconDownloadsInProgress setObject:iconLoader forKey:indexPath];
//        [iconLoader sendAsynchronousRequest];
//    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
//- (void)loadImagesForOnscreenRows
//{
//    if ([self.entries count] > 0)
//    {
//        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
//        for (NSIndexPath *indexPath in visiblePaths)
//        {
//            AppRecord *appRecord = [self.entries objectAtIndex:indexPath.row];
//            
//            if (!appRecord.appIcon) // avoid the app icon download if the app already has an icon
//            {
//                [self startIconDownload:appRecord forIndexPath:indexPath];
//            }
//        }
//    }
//}

//// called by our ImageDownloader when an icon is ready to be displayed
//- (void)appImageDidLoad:(NSIndexPath *)indexPath
//{
//    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
//    if (iconDownloader != nil)
//    {
//        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
//        
//        // Display the newly loaded image
//        cell.imageView.image = iconDownloader.appRecord.appIcon;
//    }
//    
//    // Remove the IconDownloader from the in progress list.
//    // This will result in it being deallocated.
//    [imageDownloadsInProgress removeObjectForKey:indexPath];
//}

-(void) r2rAirlineIconLoaded:(R2RAirlineIconLoader *)delegateIconLoader
{
    R2RAirlineIconLoader *iconLoader = [iconDownloadsInProgress objectForKey:delegateIconLoader.airline.code];
    
    if (iconLoader)
    {
        iconLoader.airline.icon = iconLoader.sprite.sprite;
        
        for (NSIndexPath *indexPath in iconLoader.cellPaths)
        {
            R2RFlightSegmentCell *cell = (R2RFlightSegmentCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            if (cell)
            {
                R2RFlightHop *flightHop = [cell.flightLeg.hops objectAtIndex:0];
                if ([flightHop.airline isEqualToString:iconLoader.airline.code]) //if icon belongs to first airline display in first position
                {
                    [cell.firstAirlineIcon setImage:iconLoader.sprite.sprite];
                }
                else
                {
                    [cell.secondAirlineIcon setImage:iconLoader.sprite.sprite];
                }
                //            [cell setBackgroundColor:[UIColor greenColor]];
            }
            else
            {
//                NSLog(@"%@", self.tableView);
            }
        }
        
    }
    else
    {
        NSLog(@"%@", @"break");
    }
    
    [iconDownloadsInProgress removeObjectForKey:delegateIconLoader.airline.code];
    
//    R2RAirlineIconLoader *iconLoader = [iconDownloadsInProgress objectForKey:delegateIconLoader.indexPathInTableView];
//    
//    if (iconLoader)
//    {
//        iconLoader.airline.icon = iconLoader.sprite.sprite;
//        
////        UITableView *table = self.tableView;
//
//        R2RFlightSegmentCell *cell = (R2RFlightSegmentCell *)[self.tableView cellForRowAtIndexPath:iconLoader.indexPathInTableView];
//        
//        if (cell)
//        {
//            R2RFlightHop *flightHop = [cell.flightLeg.hops objectAtIndex:0];
//            if ([flightHop.airline isEqualToString:iconLoader.airline.code]) //if icon belongs to first airline display in first position
//            {
//                [cell.firstAirlineIcon setImage:iconLoader.sprite.sprite];
//            }
//            else
//            {
//                [cell.secondAirlineIcon setImage:iconLoader.sprite.sprite];
//            }
////            [cell setBackgroundColor:[UIColor greenColor]];
//        }
//        else
//        {
//        
//            NSLog(@"%@", table);
//        }
//    }
//    else
//    {
//        NSLog(@"%@", @"break");
//    }
//    
//    [iconDownloadsInProgress removeObjectForKey:delegateIconLoader.indexPathInTableView];
    
}


//-(void) R2RIconLoaded:(R2RIconLoader *)delegateIconLoader
//{
//    R2RIconLoader *iconLoader = [iconDownloadsInProgress objectForKey:delegateIconLoader.airline.code];
//
//    if (iconLoader && iconLoader == delegateIconLoader)
//    {
//        iconLoader.airline.icon = iconLoader.icon;
//        
//        for (R2RFlightSegmentCell *cell in self.tableView.visibleCells)
//        {
//            if (cell.firstAirlineIcon.image == nil)
//            {
//                [cell.firstAirlineIcon setCroppedImage:iconLoader.airline.icon :CGRectMake(iconLoader.airline.iconOffset.x, iconLoader.airline.iconOffset.y, 27, 23)];
//                [cell setBackgroundColor:[UIColor greenColor]];
//                //                [cell.firstAirlineIcon setImage:iconLoader.airline.icon];
//                [cell setNeedsDisplay];
//                continue;
//            }
//            if (cell.secondAirlineIcon && !cell.secondAirlineIcon.image)
//            {
//                //                [cell.secondAirlineIcon setImage:iconLoader.airline.icon];
//                //                [cell setNeedsDisplay];
//            }
//        }
//        //        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:iconLoader.indexPathInTableView];
//        //        R2RFlightSegmentCell *cell = c;//[self.tableView cellForRowAtIndexPath:iconLoader.indexPathInTableView];
//        //        [cell setNeedsDisplay];
//        //        cell.firstAirlineIcon.image = iconLoader.icon;
//    }
//    else
//    {
//        NSLog(@"%@", @"break");
//    }
//    
//
//    [iconDownloadsInProgress removeObjectForKey:delegateIconLoader.airline.code];
//    
//}

@end

//@interface FlightGroup()
//
//
//
//@end


@implementation FlightGroup

@synthesize flights, hops, name;

-(id) initWithHops: (NSInteger) initHops
{
    self = [super init];
    if (self != nil)
    {
        self.flights = [[NSMutableArray alloc] init];
        self.hops = initHops;
        if (self.hops == 1)
        {
            self.name = @"Direct Flights";
        }
        else
        {
            self.name = [NSString stringWithFormat:@"%d stopver flights", self.hops-1];
        }
    }
    return self;
}

@end
