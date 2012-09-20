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
#import "R2RStatusButton.h"


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
@property (strong, nonatomic) R2RStatusButton *statusButton;

//@property (strong, nonatomic) UIView *statusMessageView;




- (IBAction)FromEditingDidBegin:(id)sender;
- (IBAction)ToEditingDidBegin:(id)sender;
- (IBAction)FromEditingDidEnd:(id)sender;
- (IBAction)ToEditingDidEnd:(id)sender;
- (IBAction)SearchTouchUpInside:(id)sender;

enum R2RState
{
    IDLE = 0,
    RESOLVING_FROM,
    RESOLVING_TO,
    SEARCHING,
} ;

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
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFromTextField:) name:@"refreshFromTextField" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshToTextField:) name:@"refreshToTextField" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshStatusMessage:) name:@"refreshStatusMessage" object:nil];
    
    // Do any additional setup after loading the view, typically from a nib.
    
//    self.statusMessage = [[R2RStatusLabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height -100, self.view.bounds.size.width, 30.0)];
//    [self.view addSubview:self.statusMessage];
    
    self.statusButton = [[R2RStatusButton alloc] initWithFrame:CGRectMake(0.0, 360.0, 320.0, 30.0)];
    //self.statusButton = [R2RStatusButton buttonWithType:UIButtonTypeCustom];
    
    [self.view addSubview:self.statusButton];
    
    [self setStatusMessage:self.dataController.statusMessage];
    
}


- (void)viewDidUnload
{
    
    //here or dealloc???
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshFromTextField" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshToTextField" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshStatusMessage" object:nil];
    
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

- (IBAction)FromEditingDidBegin:(id)sender
{
    [self.dataController FromEditingDidBegin];
    
//    self.dataController.fromText = @"";
//    [self.dataController clearGeoCoderFrom];
//    [self.dataController clearSearch];
}

- (IBAction)ToEditingDidBegin:(id)sender
{
    [self.dataController ToEditingDidBegin];
    
//    self.dataController.toText = @"";
//    [self.dataController clearGeoCoderTo];
//    [self.dataController clearSearch];
}

- (IBAction)FromEditingDidEnd:(id)sender
{
    if ([self.fromTextField.text length]> 0)
    {
        [self.dataController FromEditingDidEnd:self.fromTextField.text];
    }
    
//    self.dataController.fromText = self.fromTextField.text;
//    
//    if ([self.fromTextField.text length] == 0)
//    {
//        return;
//    }
//    
//    if (self.dataController.state == IDLE || self.dataController.state == RESOLVING_FROM)
//    {
//        [self.dataController geoCodeFromQuery:self.fromTextField.text];
//    }

}

- (IBAction)ToEditingDidEnd:(id)sender
{
    if ([self.toTextField.text length]> 0)
    {
        [self.dataController ToEditingDidEnd:self.toTextField.text];
    }
    
//    self.dataController.toText = self.toTextField.text;
//    
//    if ([self.toTextField.text length] == 0)
//    {
//        return;
//    }
//    
//    if (self.dataController.state == IDLE || self.dataController.state == RESOLVING_TO)
//    {
//        [self.dataController geoCodeToQuery:self.toTextField.text];
//    }
}

- (IBAction)SearchTouchUpInside:(id)sender
{
    if ([self.fromTextField.text length] == 0)
    { 
        [self WarningMessage:@"Please enter origin":@"from"];        
        return;
    }
    if ([self.toTextField.text length] == 0)
    {
        [self WarningMessage:@"Please enter destination":@"to"];
        return;
    }
    
    //clear warning message
    //[self ClearMessage:<#(NSString *)#>];
    
    [self performSegueWithIdentifier:@"showSearchResults" sender:self];
    
}




- (void)WarningMessage: (NSString *) message: (NSString *) textField
{

//    
//    self.statusButton.hidden = false;
//    self.statusButton.titleLabel.text = message;
//    
//    [self performSelector:@selector(clearMessage) withObject:nil afterDelay:3.0];
//    
    
    [self setStatusMessage:message];
    //[self performSelector:@selector(setStatusMessage:) withObject:@"" afterDelay:3.0];
    
    //maybe enum the textField
    
    //messageState = textField;
    
    //self.messageLabel.text = message;
}

//-(void) clearMessage
//{
//    self.statusButton.hidden = true;
//    //[self.view removeFromSuperview];
//}

//-(void) refreshView:(NSNotification *) notification
//{
//    if ([notification.name isEqualToString:@"refreshFromTextField"])
//    {
//        [self refreshFromTextField];
//        return;
//    }
//    if ([notification.name isEqualToString:@"refreshToTextField"])
//    {
//        [self refreshToTextField];
//        return;
//    }
//    if ([notification.name isEqualToString:@"refreshStatusMessage"])
//    {
//        [self refreshStatusMessage];
//        return;
//    }
//    
//    if ([notification.name isEqualToString:@"displayStatusMessage"])
//    {
//        //[self displayStatusMessage];
//        return;
//    }
//    if ([notification.name isEqualToString:@"clearStatusMessage"])
//    {
//        //[self clearStatusMessage];
//        return;
//    }
//    
//    
//}

-(void) refreshFromTextField:(NSNotification *) notification
{
    self.fromTextField.text = self.dataController.geoCoderFrom.geoCodeResponse.place.longName;
}

-(void) refreshToTextField:(NSNotification *) notification
{
    self.toTextField.text = self.dataController.geoCoderTo.geoCodeResponse.place.longName;
}

-(void) refreshStatusMessage:(NSNotification *) notification
{
    
    
    
    [self setStatusMessage:self.dataController.statusMessage];
    
    //[self.statusButton setTitle:self.dataController.statusMessage forState:UIControlStateNormal];
    
//    if ([self.dataController.statusMessage length] == 0)
//    {
//        [self.statusButton setHidden:true];
//    }
//    else
//    {
//        [self.statusButton setHidden:false];
//    }
}

-(void) setStatusMessage: (NSString *) message
{
    //added this to have a selector for setting message to nil.
    //will probably change when resolving of multiple messages is sorted
    
    
    [self.statusButton setTitle:message forState:UIControlStateNormal];
    //-(void) setStatusMessage {
    //[self.statusButton setTitle:self.dataController.statusMessage forState:UIControlStateNormal];
    //}
}

-(void) setStatusMessage: (NSString *) message: (NSString *) sender
{
    //added this to have a selector for setting message to nil.
    //will probably change when resolving of multiple messages is sorted

    [self.statusButton setTitle:message forState:UIControlStateNormal];

}



@end
