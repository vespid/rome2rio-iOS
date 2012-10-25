//
//  R2RLinkActionSheet.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 23/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface R2RLinkActionSheet : UIActionSheet <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *urls;
@property (strong, nonatomic) UITableView *tableView;


@end
