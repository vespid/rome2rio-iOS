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

#import "R2RImageView.h"

@interface R2RMasterViewController ()

//@property (strong, nonatomic) R2RGeoCoder *geoCoderFrom;
//@property (strong, nonatomic) R2RGeoCoder *geoCoderTo;
//@property (strong, nonatomic) R2RSearch *search;
//@property (strong, nonatomic) R2RPlace *fromSearchPlace;
//@property (strong, nonatomic) R2RPlace *toSearchPlace;
@property (weak, nonatomic) IBOutlet UITextField *fromTextField;
@property (weak, nonatomic) IBOutlet UITextField *toTextField;
//@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
//@property (weak, nonatomic) R2RResultsViewController *resultsViewController;
@property (strong, nonatomic) R2RStatusButton *statusButton;


//@property (strong, nonatomic) NSString *myLocation;

//@property (strong, nonatomic) UIView *statusMessageView;


- (IBAction)FromEditingDidBegin:(id)sender;
- (IBAction)ToEditingDidBegin:(id)sender;
- (IBAction)FromEditingDidEnd:(id)sender;
- (IBAction)ToEditingDidEnd:(id)sender;
- (IBAction)SearchTouchUpInside:(id)sender;
- (IBAction)currentLocationTouchUpInside:(id)sender;
- (IBAction)geoCodeFrom:(id)sender;

enum R2RState
{
    IDLE = 0,
    RESOLVING_FROM,
    RESOLVING_TO,
    SEARCHING,
} ;

@end

@implementation R2RMasterViewController

@synthesize dataController, fromTextField, toTextField;


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

    [self displayIcons];

    [self.view setBackgroundColor:[UIColor colorWithRed:234.0/256.0 green:228.0/256.0 blue:224.0/256.0 alpha:1.0]];
    
    self.statusButton = [[R2RStatusButton alloc] initWithFrame:CGRectMake(0.0, 360.0, 320.0, 30.0)];
    //self.statusButton = [R2RStatusButton buttonWithType:UIButtonTypeCustom];
    
    [self.view addSubview:self.statusButton];
    
    [self setStatusMessage:self.dataController.statusMessage];
    
    //[self drawIcons];
//    
//    if (nil == self.locationManager)
//        self.locationManager = [[CLLocationManager alloc] init];
//    
//    self.locationManager.delegate = self;
//    [self.locationManager startMonitoringSignificantLocationChanges];
//    
}



- (void) displayIcons
{
    //Header Image
    CGPoint position = CGPointMake(10, 20); //position to place icon
    CGSize size = CGSizeMake(300, 70); // size of icon  //make size exact and adjust position based on screen size
    CGPoint imageLocation = CGPointMake(70, 100); //position of icon in image
    CGSize imageSize = CGSizeMake(386, 83); //size of icon in image
    
    R2RImageView *view = [[R2RImageView alloc] initWithFrame:CGRectMake(position.x, position.y, size.width, size.height)];
    [view setCroppedImage:[UIImage imageNamed:@"sprites6.png"] :CGRectMake(imageLocation.x, imageLocation.y, imageSize.width, imageSize.height)];
    [self.view addSubview:view];
    
    NSInteger xPos = (self.view.bounds.size.width/7);
    
    //plane
    position = CGPointMake(1*xPos+5, 265); //position to place icon
    size = CGSizeMake(50, 36); // size of icon
    imageSize = CGSizeMake(42, 36); //size of icon in image
    imageLocation = CGPointMake(0, 0); //position of icon in image
    
    view = [[R2RImageView alloc] initWithFrame:CGRectMake(position.x+5, position.y, size.width, size.height)];
    [view setCroppedImage:[UIImage imageNamed:@"sprites6.png"] :CGRectMake(imageLocation.x, imageLocation.y, imageSize.width, imageSize.height)];
    [self.view addSubview:view];
    
    //train
    position = CGPointMake(3*xPos, 265); //position to place icon
    size = CGSizeMake(58, 36); // size of icon
    imageSize = CGSizeMake(58, 36); //size of icon in image
    imageLocation = CGPointMake(102, 0); //position of icon in image

    view = [[R2RImageView alloc] initWithFrame:CGRectMake(position.x, position.y, size.width, size.height)];
    [view setCroppedImage:[UIImage imageNamed:@"sprites6.png"] :CGRectMake(imageLocation.x, imageLocation.y, imageSize.width, imageSize.height)];
    [self.view addSubview:view];
    
    //bus
    position = CGPointMake(5*xPos, 265); //position to place icon
    size = CGSizeMake(55, 36); // size of icon
    imageSize = CGSizeMake(55, 36); //size of icon in image
    imageLocation = CGPointMake(174, 40); //position of icon in image
    
    view = [[R2RImageView alloc] initWithFrame:CGRectMake(position.x, position.y, size.width, size.height)];
    [view setCroppedImage:[UIImage imageNamed:@"sprites6.png"] :CGRectMake(imageLocation.x, imageLocation.y, imageSize.width, imageSize.height)];
    [self.view addSubview:view];
    
    //ferry
    position = CGPointMake(2*xPos/*+(xPos/2)*/, 310); //position to place icon
    size = CGSizeMake(67, 36); // size of icon
    imageSize = CGSizeMake(67, 36); //size of icon in image
    imageLocation = CGPointMake(162, 0); //position of icon in image
    
    view = [[R2RImageView alloc] initWithFrame:CGRectMake(position.x, position.y, size.width, size.height)];
    [view setCroppedImage:[UIImage imageNamed:@"sprites6.png"] :CGRectMake(imageLocation.x, imageLocation.y, imageSize.width, imageSize.height)];
    [self.view addSubview:view];
    
    //car
    position = CGPointMake(4*xPos/*+(xPos/2)*/, 310); //position to place icon
    size = CGSizeMake(57, 36); // size of icon
    imageSize = CGSizeMake(57, 36); //size of icon in image
    imageLocation = CGPointMake(43, 0); //position of icon in image
    
    view = [[R2RImageView alloc] initWithFrame:CGRectMake(position.x, position.y, size.width, size.height)];
    [view setCroppedImage:[UIImage imageNamed:@"sprites6.png"] :CGRectMake(imageLocation.x, imageLocation.y, imageSize.width, imageSize.height)];
    [self.view addSubview:view];
    
    
    
}

- (void)viewDidUnload
{
    
    //here or dealloc???
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshFromTextField" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshToTextField" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshStatusMessage" object:nil];
    
    [self setFromTextField:nil];
    [self setToTextField:nil];
//    [self setMessageLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

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

- (IBAction)currentLocationTouchUpInside:(id)sender
{
    [self.dataController currentLocationTouchUpInside];
}

- (IBAction)geoCodeFrom:(id)sender
{
    [self.dataController geoCodeFrom:self.fromTextField.text];
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

- (void) drawIcons
{
    //self.view.backgroundColor = [UIColor blueColor];
    // Initialization code
    //UIImageView *planeView = [[UIImageView alloc] initWithImage:]
    //UIImage *plane = [[UIImage alloc] init];
    UIImage *sprites = [UIImage imageNamed:@"sprites6.png"];
    
    //plane
    CGPoint point = CGPointMake(100, 50);
    //        UIRectClip(CGRectMake(20, 50, 42, 36));
    [sprites drawAtPoint:point];
    
//    //train
//    point = CGPointMake(80-102, 50);
//    //        UIRectClip(CGRectMake(20, 50, 58, 36));
//    [sprites drawAtPoint:point];
//    
//    //bus
//    point = CGPointMake(140-174, 50-40);
//    //        UIRectClip(CGRectMake(20, 50, 55, 36));
//    [sprites drawAtPoint:point];
//    
//    //ferry
//    point = CGPointMake(200-162, 50);
//    //        UIRectClip(CGRectMake(20, 50, 67, 36));
//    [sprites drawAtPoint:point];
//    
//    //car
//    point = CGPointMake(260-43, 50);
//    //        UIRectClip(CGRectMake(20, 50, 57, 36));
//    [sprites drawAtPoint:point];
}


@end
