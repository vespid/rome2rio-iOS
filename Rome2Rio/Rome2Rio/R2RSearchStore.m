//
//  R2RDataStore.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 2/11/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RSearchStore.h"

@implementation R2RSearchStore

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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTitle" object:nil];
}

-(void)setToPlace:(R2RPlace *)toPlace
{
    _toPlace = toPlace;
    
    _searchResponse = nil;
    
    [self setStatusMessage:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshToTextField" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTitle" object:nil];
}

-(void) setStatusMessage:(NSString *)statusMessage
{
    _statusMessage = statusMessage;

    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshStatusMessage" object:nil];
}

-(void) setSearchMessage:(NSString *)searchMessage
{
    _searchMessage = searchMessage;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSearchMessage" object:nil];
}

-(void) setSearchResponse:(R2RSearchResponse *)searchResponse
{
    _searchResponse = searchResponse;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshResults" object:nil];
}
@end
