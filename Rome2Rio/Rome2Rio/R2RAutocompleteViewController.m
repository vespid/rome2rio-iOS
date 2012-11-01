//
//  R2RAutocompleteViewController.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 31/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RAutocompleteViewController.h"

@interface R2RAutocompleteViewController ()

@property (strong, nonatomic) R2RAutocomplete *autocomplete;
@property (strong, nonatomic) NSMutableArray *places;

@end

@implementation R2RAutocompleteViewController

@synthesize delegate;

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
 
    self.searchBar.delegate = self;
    self.places = [[NSMutableArray alloc] init];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.searchBar becomeFirstResponder];
}

- (void)viewDidUnload {
    [self setSearchBar:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    return (1 + [self.places count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.places count])
    {
        NSString *CellIdentifier = @"myLocationCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
        return cell;
    }
    
    NSString *CellIdentifier = @"autocompleteCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    R2RPlace *place = [self.places objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:place.longName];
    
    return cell;
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    
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
    if (indexPath.row == [self.places count])
    {
        [self myLocationClicked];
        return;
    }
    else
    {
        R2RPlace *place = [self.places objectAtIndex:indexPath.row];
        [self.delegate autocompleteViewControllerDidSelect:self selection:place.longName textField:self.textField];
    }
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Search bar delegate

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] >=3)
    {
        self.autocomplete = [[R2RAutocomplete alloc] initWithSearchString:searchText delegate:self];
        [self.autocomplete sendAsynchronousRequest];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.delegate autocompleteViewControllerDidCancel:self];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.delegate autocompleteViewControllerDidSelect:self selection:searchBar.text textField:self.textField];
}

-(void)myLocationClicked
{
    [self.delegate autocompleteViewControllerDidSelectMyLocation:self textField:self.textField];
}

#pragma mark - autocomplete delegate

-(void)autocompleteResolved:(R2RAutocomplete *)delegateAutocomplete
{
    if (self.autocomplete == delegateAutocomplete)
    {
        if (self.autocomplete.responseCompletionState == stateResolved)
        {
            self.places = self.autocomplete.geoCodeResponse.places;
            [self.tableView reloadData];
        }
    }
}


@end
