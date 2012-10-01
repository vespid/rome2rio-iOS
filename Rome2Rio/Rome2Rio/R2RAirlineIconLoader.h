//
//  R2RAirlineIconLoader.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 29/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "R2RAirline.h"
#import "R2RSprite.h"

@protocol R2RAirlineIconLoaderDelegate;

@interface R2RAirlineIconLoader : NSObject

@property (strong, nonatomic) R2RAirline *airline;
@property (strong, nonatomic) R2RSprite *sprite;
@property (weak, nonatomic) id<R2RAirlineIconLoaderDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *cellPaths; //where the current loading icon needs to be displayed
//@property (strong, nonatomic) NSDictionary *cellPaths; //where the current loading icon needs to be displayed
//@property (nonatomic, retain) NSIndexPath *indexPathInTableView;

-(id) initWithIconPath:(NSString *) iconPath delegate:(id<R2RAirlineIconLoaderDelegate>)r2rIconLoaderDelegate;
-(void) sendAsynchronousRequest;

@end

@protocol R2RAirlineIconLoaderDelegate <NSObject>

- (void)r2rAirlineIconLoaded:(R2RAirlineIconLoader *) delegateIconLoader;

@end

