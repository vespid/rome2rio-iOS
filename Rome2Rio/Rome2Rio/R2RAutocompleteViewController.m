//
//  R2RAutocompleteViewController.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 31/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RAutocompleteViewController.h"
#import "R2RAutocompleteCell.h"
#import "R2RStatusButton.h"
#import "R2RMapViewController.h"

@interface R2RAutocompleteViewController ()

@property (strong, nonatomic) R2RAutocomplete *autocomplete;
@property (strong, nonatomic) NSMutableArray *places;

@property (strong, nonatomic) R2RStatusButton *statusButton;

@property (strong, nonatomic) NSString *prevSearchText;

@property (nonatomic) BOOL fallbackToCLGeocoder;

@end

@implementation R2RAutocompleteViewController

@synthesize searchManager, fieldName;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchBar.delegate = self;
    self.places = [[NSMutableArray alloc] init];

    self.fallbackToCLGeocoder = NO;
    
    self.statusButton = [[R2RStatusButton alloc] initWithFrame:CGRectMake(0.0, (self.view.bounds.size.height- self.navigationController.navigationBar.bounds.size.height-30), self.view.bounds.size.width, 30.0)];
    [self.statusButton addTarget:self action:@selector(statusButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.statusButton];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footer;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshStatusMessage:) name:@"refreshStatusMessage" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasHidden:)
                                                 name:UIKeyboardDidHideNotification object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.fallbackToCLGeocoder = NO;
    if ([self.fieldName isEqualToString:@"from"])
    {
        [self.searchBar setText:self.searchManager.fromText];
        [self startAutocomplete:self.searchManager.fromText];
    }
    if ([self.fieldName isEqualToString:@"to"])
    {
        [self.searchBar setText:self.searchManager.toText];
        [self startAutocomplete:self.searchManager.toText];
    }
    
    [self.searchBar becomeFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidUnload {
    [self setSearchBar:nil];
    [self setStatusView:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshStatusMessage" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];

    [self setTableView:nil];
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
    
    return (2 + [self.places count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"autocompleteCell";
    
    if (indexPath.row == [self.places count] + 1)
    {
        R2RAutocompleteCell *mapCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        [mapCell.autocompleteImageView setHidden:NO];
        [mapCell.label setText:@"Select on map"];
        
        return mapCell;
    }
    
    R2RAutocompleteCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (indexPath.row == [self.places count])
    {
        [cell.autocompleteImageView setHidden:NO];
        [cell.label setText:@"Current location"];
        
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
    [self setText:self.searchBar.text];
    if (indexPath.row == [self.places count])
    {
        [self currentLocationClicked];
    }
    else if (indexPath.row == [self.places count] + 1)
    {
//        [self performSegueWithIdentifier:@"showMap" sender:self];
    }
    else
    {
        [self placeClicked:[self.places objectAtIndex:indexPath.row]];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showMap"])
    {

        R2RMapViewController *mapViewController = [segue destinationViewController];
        mapViewController.searchManager = self.searchManager;
        mapViewController.fieldName = self.fieldName;
        
        R2RLog(@"showMap");
    }
}

#pragma mark - Search bar delegate

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self startAutocomplete:searchText];
}

-(void) startAutocomplete: (NSString *) searchText
{
    if (![self.searchManager.searchStore.statusMessage isEqualToString:@"Searching"])
    {
        [self.searchManager setStatusMessage:@""];
    }
    
    if ([searchText length] < [self.prevSearchText length])
    {
        self.fallbackToCLGeocoder = NO;
    }
    
    if ([searchText length] >=2)
    {
//        self.autocomplete = [[R2RAutocomplete alloc] initWithSearchString:searchText delegate:self];
        if (self.fallbackToCLGeocoder == YES)
        {
            [self sendCLGeocodeRequest:searchText];
        }
        else
        {
            [self sendAutocompleteRequest:searchText];
        }
    }
    else
    {
        self.places = nil;
        [self.tableView reloadData];
    }
    self.prevSearchText = searchText;
    
}

//store the typed text;
-(void) setText:(NSString *) searchText;
{
    if ([self.fieldName isEqualToString:@"from"])
    {
        self.searchManager.fromText = searchText;
    }
    if ([self.fieldName isEqualToString:@"to"])
    {
        self.searchManager.toText = searchText;
    }

}

-(void) sendAutocompleteRequest:(NSString *)query
{
    self.autocomplete = [[R2RAutocomplete alloc] initWithQueryString:query delegate:self];
    [self.autocomplete sendAsynchronousRequest];
    [self performSelector:@selector(setStatusSearching:) withObject:self.autocomplete afterDelay:1.0];
}

-(void) sendCLGeocodeRequest:(NSString *)query
{
    self.autocomplete = [[R2RAutocomplete alloc] initWithQueryString:query delegate:self];
    [self.autocomplete geocodeFallback:query];
    [self performSelector:@selector(setStatusSearching:) withObject:self.autocomplete afterDelay:1.0];
}

-(void) setStatusSearching:(R2RAutocomplete *) autocomplete
{
    if (self.autocomplete == autocomplete)
    {
        if (self.autocomplete.responseCompletionState != r2rCompletionStateResolved && self.autocomplete.responseCompletionState != r2rCompletionStateError && self.autocomplete.responseCompletionState != r2rCompletionStateLocationNotFound)
        {
            [self.searchManager setStatusMessage:@"Searching"];
        }
    }
}

-(void) currentLocationClicked
{
    if ([self.fieldName isEqualToString:@"from"])
    {
        [self.searchManager setFromWithCurrentLocation];
    }
    if ([self.fieldName isEqualToString:@"to"])
    {
        [self.searchManager setToWithCurrentLocation];
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(void) placeClicked:(R2RPlace *) place;
{
    if ([self.fieldName isEqualToString:@"from"])
    {
        [self.searchManager setFromPlace:place];
    }
    if ([self.fieldName isEqualToString:@"to"])
    {
        [self.searchManager setToPlace:place];
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([self.searchBar.text length] <= 1) return;
    
    //restart search if not currently searching or idle
    if (self.autocomplete.responseCompletionState == r2rCompletionStateError || self.autocomplete.responseCompletionState == r2rCompletionStateLocationNotFound)
    {
        [self startAutocomplete:self.searchBar.text];
    }
}

#pragma mark - autocomplete delegate

-(void)autocompleteResolved:(R2RAutocomplete *)autocomplete
{
    if (self.autocomplete == autocomplete)
    {
        if (autocomplete.responseCompletionState == r2rCompletionStateResolved)
        {
            if ([autocomplete.geocodeResponse.places count] > 0)
            {
                [self.searchManager setStatusMessage:@""];
                self.places = self.autocomplete.geocodeResponse.places;
                [self.tableView reloadData];
            }
            else
            {
                if (self.fallbackToCLGeocoder == NO)
                {
                    self.fallbackToCLGeocoder = YES;
                    [self sendCLGeocodeRequest:autocomplete.query];
                }
            }
        }
        else if (autocomplete.responseCompletionState == r2rCompletionStateLocationNotFound) //state only returned from geocodeFallback
        {
            [self.searchManager setStatusMessage:autocomplete.responseMessage];
            self.places = self.autocomplete.geocodeResponse.places;
            [self.tableView reloadData];
        }
        else
        {
            //if response not resolved send off a single CLGeocode request
            [self sendCLGeocodeRequest:autocomplete.query];
        }
    }
}

-(void) refreshStatusMessage:(NSNotification *) notification
{
    [self.statusButton setTitle:self.searchManager.searchStore.statusMessage forState:UIControlStateNormal];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect frame = self.statusButton.frame;
    frame.origin.y = self.view.frame.size.height - 30 - kbSize.height;
    
    [self.statusButton setFrame:frame];
    
    CGRect tableViewFrame = self.tableView.frame;
    
    if (tableViewFrame.size.height >=  self.view.frame.size.height - self.searchBar.frame.size.height)
    {
        tableViewFrame.size.height -= kbSize.height;
    }
    [self.tableView setFrame:tableViewFrame];
}

// Called when the UIKeyboardDidHideNotification is sent
// Using DidHide instead of WillHide so it doesn't do anything while the modal view is being dismissed
- (void) keyboardWasHidden:(NSNotification*)aNotification
{
    CGRect frame = self.statusButton.frame;
    frame.origin.y = self.view.frame.size.height - 30;
    
    [self.statusButton setFrame:frame];
    
    CGRect tableViewFrame = self.tableView.frame;
    
    if (tableViewFrame.size.height <  self.view.frame.size.height - self.searchBar.frame.size.height)
    {
        tableViewFrame.size.height = self.view.frame.size.height - self.searchBar.frame.size.height;
    }
    
    [self.tableView setFrame:tableViewFrame];
}

@end
