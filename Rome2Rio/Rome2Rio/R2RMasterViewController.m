//
//  R2RMasterViewController.m
//  R2RApp
//
//  Created by Ash Verdoorn on 6/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RMasterViewController.h"
#import "R2RDetailViewController.h"
#import "R2RResultsViewController.h"


@interface R2RMasterViewController ()

//@property (strong, nonatomic) R2RGeoCoder *geoCoderFrom;
//@property (strong, nonatomic) R2RGeoCoder *geoCoderTo;
//@property (strong, nonatomic) R2RSearch *search;
//@property (strong, nonatomic) R2RPlace *fromSearchPlace;
//@property (strong, nonatomic) R2RPlace *toSearchPlace;
@property (weak, nonatomic) IBOutlet UITextField *fromTextField;
@property (weak, nonatomic) IBOutlet UITextField *toTextField;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
//@property (weak, nonatomic) R2RResultsViewController *resultsViewController;

- (IBAction)FromEditingDidBegin:(id)sender;
- (IBAction)ToEditingDidBegin:(id)sender;
- (IBAction)FromEditingDidEnd:(id)sender;
- (IBAction)ToEditingDidEnd:(id)sender;
- (IBAction)SearchTouchUpInside:(id)sender;

enum {
    stateEmpty = 0,
    stateEditingDidBegin,
    stateEditingDidEnd,
    stateResolved,
    stateLocationNotFound
};

@end

@implementation R2RMasterViewController

@synthesize dataController, fromTextField, toTextField, messageLabel;


//- (void)awakeFromNib
//{
//    [super awakeFromNib];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView:) name:@"refreshFromTextField" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView:) name:@"refreshToTextField" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView:) name:@"displayStatusMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView:) name:@"clearStatusMessage" object:nil];
    
    // Do any additional setup after loading the view, typically from a nib.
    
///////don't need navigation items on main view
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
//
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)viewDidUnload
{
    
    //here or dealloc???
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshFromTextField" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshToTextField" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"displayStatusMessage" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"clearStatusMessage" object:nil];
    
    [self setFromTextField:nil];
    [self setToTextField:nil];
    [self setMessageLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

//- (void)insertNewObject:(id)sender
//{
//    if (!_objects) {
//        _objects = [[NSMutableArray alloc] init];
//    }
//    [_objects insertObject:[NSDate date] atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
    //return _objects.count;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath == 0)
//    {
//        return [tableView data]
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
//
//    NSDate *object = [_objects objectAtIndex:indexPath.row];
//    cell.textLabel.text = [object description];
//    return cell;
//}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [_objects removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
//}

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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ((textField == self.fromTextField) || (textField == self.toTextField))
    {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showSearchResults"])
    {
         
        R2RResultsViewController *resultsViewController = [segue destinationViewController];
        
        resultsViewController.dataController = self.dataController;
        
    }
}

- (IBAction)FromEditingDidEnd:(id)sender
{
    if ([self.fromTextField.text length] == 0)
    {
        return;
    }
    
    [self.dataController geoCodeFromQuery:self.fromTextField.text];

}

- (IBAction)ToEditingDidEnd:(id)sender
{
    if ([self.toTextField.text length] == 0)
    {
        //self.geoCoderTo.responseCompletionState = stateEmpty;
        return;
    }
    
    [self.dataController geoCodeToQuery:self.toTextField.text];
    
}

- (IBAction)SearchTouchUpInside:(id)sender
{
    if ([self.fromTextField.text length] == 0)
    {
        //[self TextBoxAlert:@"Enter Location": @"Please enter origin"];
        [self WarningMessage:@"Please enter origin":@"from"];
        return;
    }
    if ([self.toTextField.text length] == 0)
    {
        //[self TextBoxAlert:@"Enter Location": @"Please enter destination"];
        [self WarningMessage:@"Please enter destination":@"to"];
        return;
    }
    
    //clear warning message
    //[self ClearMessage:<#(NSString *)#>];
    
    [self performSegueWithIdentifier:@"showSearchResults" sender:self];
    
}

- (IBAction)FromEditingDidBegin:(id)sender
{
    [self.dataController clearGeoCoderFrom];
    [self.dataController clearSearch];
    
    //self.geoCoderFrom = nil;
}

- (IBAction)ToEditingDidBegin:(id)sender
{
    [self.dataController clearGeoCoderTo];
    [self.dataController clearSearch];
    //self.geoCoderTo = nil;
}


- (void)WarningMessage: (NSString *) message: (NSString *) textField
{
    //maybe enum the textField
    
    //messageState = textField;
    
    self.messageLabel.text = message;
}

- (void)ClearMessage: (NSString *) textField;
{
    //if ([messageState isEqualToString:textField])
    {
        self.messageLabel.text = nil;
    }
}

- (void)TextBoxAlert:(NSString *) title: (NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void) refreshView:(NSNotification *) notification
{
    if ([notification.name isEqualToString:@"refreshFromTextField"])
    {
        [self refreshFromTextField];
        return;
    }
    if ([notification.name isEqualToString:@"refreshToTextField"])
    {
        [self refreshToTextField];
        return;
    }
    if ([notification.name isEqualToString:@"displayStatusMessage"])
    {
        //[self displayStatusMessage];
        return;
    }
    if ([notification.name isEqualToString:@"clearStatusMessage"])
    {
        //[self clearStatusMessage];
        return;
    }
    
    
}

-(void) refreshFromTextField
{
    self.fromTextField.text = self.dataController.geoCoderFrom.geoCodeResponse.place.longName;
}

-(void) refreshToTextField
{
    self.toTextField.text = self.dataController.geoCoderTo.geoCodeResponse.place.longName;
}


@end
