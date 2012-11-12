//
//  R2RDataStore.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 2/11/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RDataStore.h"

@implementation R2RDataStore

@synthesize fromPlace = _fromPlace, toPlace = _toPlace, searchResponse = _searchResponse, spriteStore = _spriteStore, statusMessage = _statusMessage, searchMessage = _searchMessage;

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
    
    _searchResponse = nil;
    
    [self setStatusMessage:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFromTextField" object:nil];
}

-(void)setToPlace:(R2RPlace *)toPlace
{
    _toPlace = toPlace;
    
    _searchResponse = nil;
    
    [self setStatusMessage:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshToTextField" object:nil];
}

-(void) setStatusMessage:(NSString *)statusMessage
{
    _statusMessage = statusMessage;

    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshStatusMessage" object:nil];// userInfo:dictionary];
}

-(void) setSearchMessage:(NSString *)searchMessage
{
    _searchMessage = searchMessage;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSearchMessage" object:nil];
}

@end
