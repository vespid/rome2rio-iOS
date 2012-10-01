//
//  R2RIconLoader.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 27/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "R2RAirline.h"

@protocol R2RIconLoaderDelegate;

@interface R2RIconLoader : NSObject

@property (strong, nonatomic) R2RAirline *airline;
@property (strong, nonatomic) UIImage *icon;
@property (weak, nonatomic) id<R2RIconLoaderDelegate> delegate;
@property (nonatomic, retain) NSIndexPath *indexPathInTableView;

-(id) initWithIconPath:(NSString *) iconPath delegate:(id<R2RIconLoaderDelegate>)r2rIconLoaderDelegate;
-(void) sendAsynchronousRequest;

@end

@protocol R2RIconLoaderDelegate <NSObject>

- (void)R2RIconLoaded:(R2RIconLoader *) delegateIconLoader;

@end