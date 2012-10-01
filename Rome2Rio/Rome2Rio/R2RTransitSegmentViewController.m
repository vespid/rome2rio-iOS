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

#import "R2RStringFormatters.h"

@interface R2RTransitSegmentViewController ()

@end

@implementation R2RTransitSegmentViewController

@synthesize transitSegment;

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
	
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footer;
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
    
    R2RTransitItinerary *transitItinerary = [self.transitSegment.itineraries objectAtIndex:0];
    
    //R2RTransitLeg *transitLeg = [transitItinerary.legs objectAtIndex:0];
    
    NSInteger count = 0;
    for (R2RTransitLeg *transitLeg in transitItinerary.legs)
    {
        count += [transitLeg.hops count];
    }
    
    return count;
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
    
    R2RTransitItinerary *transitItinerary = [self.transitSegment.itineraries objectAtIndex:0];
    
    
    //this can be redone if we change to using 1 cell for legs with multiple hops instead of individual cells for hops per leg
    NSInteger count = 0;
    for (R2RTransitLeg *transitLeg in transitItinerary.legs)
    {
        for (R2RTransitHop *transitHop in transitLeg.hops)
        {
            if (count == indexPath.row)
            {
                int paddingTop = 10;
                int paddingRight = 10;
                int labelSizeY = 25; //can make this dynamic
                int paddingY = 5;
                int paddingX = 5;
                int labelSplitX = 80; //split position for Titles and values
                int row = 0;
                
                R2RStringFormatters *stringFormatter = [[R2RStringFormatters alloc] init];
                NSString *vehicle = [stringFormatter formatTransitHopVehicle: transitHop.vehicle];
                
                CGRect rect = CGRectMake(paddingRight, paddingTop+(row*(labelSizeY + paddingY)), labelSplitX-paddingRight-paddingX, labelSizeY);
                R2RTitleLabel *fromTitle = [[R2RTitleLabel alloc] initWithFrame:rect];
                [fromTitle setText:vehicle];
                [cell addSubview:fromTitle];
                
                rect = CGRectMake(labelSplitX, paddingTop+(row*(labelSizeY + paddingY)), cell.contentView.bounds.size.width-labelSplitX-5, labelSizeY);
                UILabel *from = [[UILabel alloc] initWithFrame:rect];
                [from setText:transitHop.sName];
                [from setMinimumFontSize:10.0];
                [from setAdjustsFontSizeToFitWidth:YES];
                [cell addSubview:from];
                
                row++;
                
                rect = CGRectMake(paddingRight, paddingTop+(row*(labelSizeY + paddingY)), labelSplitX-paddingRight-paddingX, labelSizeY);
                R2RTitleLabel *toTitle = [[R2RTitleLabel alloc] initWithFrame:rect];
                [toTitle setText:@"to"];
                [cell addSubview:toTitle];
                
                rect = CGRectMake(labelSplitX, paddingTop+(row*(labelSizeY + paddingY)), cell.contentView.bounds.size.width-labelSplitX-5, labelSizeY);
                UILabel *to = [[UILabel alloc] initWithFrame:rect];
                [to setText:transitHop.tName];
                [to setMinimumFontSize:10.0];
                [to setAdjustsFontSizeToFitWidth:YES];
                [cell addSubview:to];
                
                row++;
                
                rect = CGRectMake(paddingRight, paddingTop+(row*(labelSizeY + paddingY)), labelSplitX-paddingRight-paddingX, labelSizeY);
                R2RTitleLabel *durationTitle = [[R2RTitleLabel alloc] initWithFrame:rect];
                [durationTitle setText:@"duration"];
                [cell addSubview:durationTitle];
                
                rect = CGRectMake(labelSplitX, paddingTop+(row*(labelSizeY + paddingY)), cell.contentView.bounds.size.width-labelSplitX-5, labelSizeY);
                UILabel *duration = [[UILabel alloc] initWithFrame:rect];
                [duration setText:[stringFormatter formatTransitHopDescription: transitHop.duration :0 :transitHop.frequency :transitHop.vehicle]];
                [duration setMinimumFontSize:10.0];
                [duration setAdjustsFontSizeToFitWidth:YES];
                [cell addSubview:duration];
                
                row++;
                
                if ([transitHop.line length] != 0)
                {
                    rect = CGRectMake(paddingRight, paddingTop+(row*(labelSizeY + paddingY)), labelSplitX-paddingRight-paddingX, labelSizeY);
                    R2RTitleLabel *lineTitle = [[R2RTitleLabel alloc] initWithFrame:rect];
                    [lineTitle setText:@"line"];
                    [cell addSubview:lineTitle];
                    
                    rect = CGRectMake(labelSplitX, paddingTop+(row*(labelSizeY + paddingY)), cell.contentView.bounds.size.width-labelSplitX-5, labelSizeY);
                    UILabel *line = [[UILabel alloc] initWithFrame:rect];
                    [line setText:transitHop.line];
                    [line setMinimumFontSize:10.0];
                    [line setAdjustsFontSizeToFitWidth:YES];
                    [cell addSubview:line];
                    
                    row++;
                }
                
                rect = CGRectMake(paddingRight, paddingTop+(row*(labelSizeY + paddingY)), labelSplitX-paddingRight-paddingX, labelSizeY);
                R2RTitleLabel *scheduleTitle = [[R2RTitleLabel alloc] initWithFrame:rect];
                [scheduleTitle setText:@"schedule"];
                [cell addSubview:scheduleTitle];
                
                rect = CGRectMake(labelSplitX, paddingTop+(row*(labelSizeY + paddingY)), cell.contentView.bounds.size.width-labelSplitX-5, labelSizeY);
                UILabel *schedule = [[UILabel alloc] initWithFrame:rect];
                [schedule setText:transitLeg.host];
                [schedule setMinimumFontSize:10.0];
                [schedule setAdjustsFontSizeToFitWidth:YES];
                [cell addSubview:schedule];
                
                row++;
                
                if ([transitHop.agency length] != 0)
                {
                    CGSize imageSize = CGSizeMake(27, 23);
                    
                    rect = CGRectMake(labelSplitX-paddingX-imageSize.width, paddingTop+(row*(labelSizeY + paddingY))+1, imageSize.width, imageSize.height); //imagesize is 27*23 so dropping yPos 1 pixel to align better with 25px label

//                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
                   
                    [cell initAgencyIconView:rect];
                    [cell loadAgencyIcon:@"logos/trains/Skybus.png"];
                    
//                    rect = CGRectMake(paddingRight, paddingTop+(row*(labelSizeY + paddingY)), labelSplitX-paddingRight-paddingX, labelSizeY);
//                    R2RTitleLabel *agencyTitle = [[R2RTitleLabel alloc] initWithFrame:rect];
//                    [agencyTitle setText:@"agency"];
//                    [cell addSubview:agencyTitle];
                    
                    rect = CGRectMake(labelSplitX, paddingTop+(row*(labelSizeY + paddingY)), cell.contentView.bounds.size.width-labelSplitX-5, labelSizeY);
                    UILabel *agency = [[UILabel alloc] initWithFrame:rect];
                    [agency setText:transitHop.agency];
                    [agency setMinimumFontSize:10.0];
                    [agency setAdjustsFontSizeToFitWidth:YES];
                    [cell addSubview:agency];
                    
                    row++;
                }
                
//                [[cell kindLabel] setText:vehicle];
//                [[cell fromLabel] setText:transitHop.sName];
//                [[cell toLabel] setText:transitHop.tName];
//                
//                [[cell durationLabel] setText:[stringFormatter formatTransitHopDescription: transitHop.duration :0 :transitHop.frequency :transitHop.vehicle]];
//
//                [[cell lineLabel] setText:transitHop.line];
//                [[cell agencyLabel] setText:transitHop.agency];
//                if ([transitHop.agency length] == 0)
//                {
//                    [[cell agencyLabel] setText:transitLeg.host];
//                }
            }
            count++;
        }
    }
    //R2RTransitLeg *transitLeg = [transitItinerary.legs objectAtIndex:0];
    
    //R2RTransitHop *transitHop = [transitLeg.hops objectAtIndex:indexPath.row];


    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 20;// top and bottom padding
    float labelY = 30;// label size + padding
    height = height + (4 * labelY); //from, to, duration, schedules
    
    R2RTransitItinerary *transitItinerary = [self.transitSegment.itineraries objectAtIndex:0];
    NSInteger count = 0;
    for (R2RTransitLeg *transitLeg in transitItinerary.legs)
    {
        for (R2RTransitHop *transitHop in transitLeg.hops)
        {
            if (count == indexPath.row)
            {
                if ([transitHop.line length] != 0)
                {
                    height = height + labelY;
                }
                if ([transitHop.agency length] != 0)
                {
                    height = height + labelY;
                }
                
            }
            count++;
        }
    }
    
    
    return height;
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
