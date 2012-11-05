//
//  R2RAutocompleteViewController.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 31/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RAutocompleteViewController.h"
#import "R2RAutocompleteCell.h"

@interface R2RAutocompleteViewController ()

@property (strong, nonatomic) R2RAutocomplete *autocomplete;
@property (strong, nonatomic) NSMutableArray *places;

@property (strong, nonatomic) NSString *prevSearchText;
@property (nonatomic) BOOL fallbackToCLGeocoder;

@end

@implementation R2RAutocompleteViewController

@synthesize delegate, dataManager, fieldName;

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

    self.fallbackToCLGeocoder = NO;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    //TODO
    if ([self.fieldName isEqualToString:@"from"])
    {
        [self.searchBar setText:self.dataManager.dataStore.fromPlace.longName];
        [self startAutocomplete:self.dataManager.dataStore.fromPlace.longName];
    }
    if ([self.fieldName isEqualToString:@"to"])
    {
        [self.searchBar setText:self.dataManager.dataStore.toPlace.longName];
        [self startAutocomplete:self.dataManager.dataStore.toPlace.longName];
    }
    
    
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
    static NSString *CellIdentifier = @"autocompleteCell";
    
    R2RAutocompleteCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (indexPath.row == [self.places count])
    {
        [cell.autocompleteImageView setHidden:NO];
        [cell.label setText:@"My location"];
        
        return cell;
    }
    
    R2RPlace *place = [self.places objectAtIndex:indexPath.row];
    
    [cell.autocompleteImageView setHidden:YES];
    [cell.label setText:place.longName];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.places count])
    {
//        [self sendMyLocationRequest];
        [self currentLocationClicked];
//        return;
    }
    else
    {
//        R2RPlace *place = [self.places objectAtIndex:indexPath.row];
//        self.autocomplete.geoCodeResponse.place = [self.places objectAtIndex:indexPath.row];
        
        [self placeClicked:[self.places objectAtIndex:indexPath.row]];
        
//        [self.delegate autocompleteViewControllerDidSelect:self response:self.autocomplete.geoCodeResponse textField:self.textField];
    }

}

#pragma mark - Search bar delegate

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self startAutocomplete:searchText];
}

-(void) startAutocomplete: (NSString *) searchText
{
    if ([searchText length] < [self.prevSearchText length])
    {
        self.fallbackToCLGeocoder = NO;
    }
    
    if ([searchText length] >=2)
    {
        self.autocomplete = [[R2RAutocomplete alloc] initWithSearchString:searchText delegate:self];
        if (self.fallbackToCLGeocoder == YES)
        {
            [self sendCLGeocodeRequest:searchText];
        }
        else
        {
            [self.autocomplete sendAsynchronousRequest];
        }
    }
    self.prevSearchText = searchText;
}

-(void) sendAutocompleteRequest:(NSString *)query
{
    self.autocomplete = [[R2RAutocomplete alloc] initWithSearchString:query delegate:self];
    [self.autocomplete sendAsynchronousRequest];
}

-(void) sendCLGeocodeRequest:(NSString *)query
{
    [self.autocomplete geocodeFallback:query];
}

-(void) currentLocationClicked
{
    if ([self.fieldName isEqualToString:@"from"])
    {
        [self.dataManager setFromWithCurrentLocation];
    }
    if ([self.fieldName isEqualToString:@"to"])
    {
        [self.dataManager setToWithCurrentLocation];
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(void) placeClicked:(R2RPlace *) place;
{
    if ([self.fieldName isEqualToString:@"from"])
    {
        [self.dataManager setFromPlace:place];
    }
    if ([self.fieldName isEqualToString:@"to"])
    {
        [self.dataManager setToPlace:place];
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.delegate autocompleteViewControllerDidCancel:self];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
//    [self.delegate autocompleteViewControllerDidSelect:self selection:searchBar.text textField:self.textField];
}

//-(void)myLocationClicked
//{
//#warning 
//
//    [self sendMyLocationRequest];
////    [self.delegate autocompleteViewControllerDidSelectMyLocation:self textField:self.textField];
//}

#pragma mark - autocomplete delegate

-(void)autocompleteResolved:(R2RAutocomplete *)autocomplete
{
    if (self.autocomplete == autocomplete)
    {
        if (autocomplete.responseCompletionState == stateResolved)
        {
            R2RLog(@"resolved places %d", [autocomplete.geoCodeResponse.places count]);
            
            if ([autocomplete.geoCodeResponse.places count] > 0)
            {
                self.places = self.autocomplete.geoCodeResponse.places;
                [self.tableView reloadData];
            }
            else
            {
                if (self.fallbackToCLGeocoder == NO)
                {
                    self.fallbackToCLGeocoder = YES;
                    [self sendCLGeocodeRequest:autocomplete.searchString];
                 }
            }
        }
    }
}

//-(void)myLocationResolved:(R2RAutocomplete *)autocomplete
//{
//    if (self.autocomplete == autocomplete)
//    {
//        [self.delegate autocompleteViewControllerDidSelect:self response:self.autocomplete.geoCodeResponse textField:self.textField];
//    }
//}


@end
