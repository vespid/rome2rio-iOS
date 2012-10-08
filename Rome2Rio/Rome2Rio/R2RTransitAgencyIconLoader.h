//
//  R2RTransitAgencyIconLoader.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 2/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "R2RSprite.h"
#import "R2RAgency.h"

@protocol R2RTransitAgencyIconLoaderDelegate;

@interface R2RTransitAgencyIconLoader : NSObject

@property (strong, nonatomic) R2RAgency *agency;
@property (strong, nonatomic) R2RSprite *sprite;
@property (weak, nonatomic) id<R2RTransitAgencyIconLoaderDelegate> delegate;
@property (nonatomic) NSInteger section;
@property (nonatomic) CGPoint iconOffset;

//@property (strong, nonatomic) NSMutableArray *cellPaths; //where the current loading icon needs to be displayed
//@property (nonatomic, retain) NSIndexPath *indexPathInTableView;

-(id) initWithIconPath:(NSString *) iconPath delegate:(id<R2RTransitAgencyIconLoaderDelegate>)r2rIconLoaderDelegate;
-(void) sendAsynchronousRequest;

@end

@protocol R2RTransitAgencyIconLoaderDelegate <NSObject>

- (void)r2rTransitAgencyIconLoaded:(R2RTransitAgencyIconLoader *) delegateIconLoader;

@end