//
//  R2RLinkActionSheet.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 23/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RLinkActionSheet.h"

@implementation R2RLinkActionSheet

@synthesize titles, urls, tableView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super initWithTitle:title delegate:delegate cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles, nil];
    if (self)
    {
        self.tableView = [[UITableView alloc] initWithFrame:self.frame];
        
        
    }
    
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)showInView:(UIView *)view
{
    
    
    
    [super showInView:view];
}


@end
