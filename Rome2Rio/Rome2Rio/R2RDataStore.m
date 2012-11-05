//
//  R2RDataStore.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 2/11/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RDataStore.h"

@implementation R2RDataStore

@synthesize fromPlace = _fromPlace, toPlace = _toPlace, searchResponse = _searchResponse, spriteStore = _spriteStore;

-(id)init
{
    self = [super init];
    if (self)
    {
        self.spriteStore = [[R2RSpriteStore alloc] init];
    }
    return self;
}

- (void)setFromPlace:(R2RPlace *)fromPlace
{
    _fromPlace = fromPlace;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFromTextField" object:nil];
}

-(void)setToPlace:(R2RPlace *)toPlace
{
    _toPlace = toPlace;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshToTextField" object:nil];
}


@end
