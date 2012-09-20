//
//  R2RDataController.m
//  R2RApp
//
//  Created by Ash Verdoorn on 12/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RDataController.h"

@interface R2RDataController ()

enum R2RState
{
    IDLE = 0,
    RESOLVING_FROM,
    RESOLVING_TO,
    SEARCHING,
};

enum R2REvent
{
    EDIT_FROM_BEGIN = 0,
    EDIT_FROM_END,
    EDIT_TO_BEGIN,
    EDIT_TO_END,
    FINISHED,
    ERROR,
    TIMEOUT,
    STATUS    
};


enum {
    stateEmpty = 0,
    stateEditingDidBegin,
    stateEditingDidEnd,
    stateResolved,
    stateLocationNotFound,
    stateError
};

@end


@implementation R2RDataController

@synthesize geoCoderFrom, geoCoderTo, search, statusMessage, state;

-(id) init
{
    self = [super init];
    
    if (self != nil)
    {
        self.state = IDLE;
    }
    
    return self;
}

-(void) geoCodeFromQuery:(NSString *)query
{
    //reset status message
    //[self RefreshStatusMessage:nil];
    self.statusMessage = @"";
    [self RefreshStatusMessage:self.geoCoderFrom];
    
    self.geoCoderFrom = [[R2RGeoCoder alloc] initWithSearchString:query delegate:self];
    
    [self.geoCoderFrom sendAsynchronousRequest];
    self.state = RESOLVING_FROM;
    
    self.statusMessage = @"Resolving Origin";
    
    [self performSelector:@selector(RefreshStatusMessage:) withObject:self.geoCoderFrom afterDelay:2.0];
}

-(void) geoCodeToQuery:(NSString *)query
{
    //[self RefreshStatusMessage:nil]; //reset status message while state is still IDLE
    self.statusMessage = @"";
    [self RefreshStatusMessage:self.geoCoderTo];
    
    self.geoCoderTo = [[R2RGeoCoder alloc] initWithSearchString:query delegate:self];
    [self.geoCoderTo sendAsynchronousRequest];
    self.state = RESOLVING_TO;
    
    self.statusMessage = @"Resolving Destination";
    
    //[self performSelector:@selector(setStatusMessage:) withObject:@"Resolving to" afterDelay:2.0];
    [self performSelector:@selector(RefreshStatusMessage:) withObject:self.geoCoderTo afterDelay:2.0];
}

//-(void) clearGeoCoderFrom
//{
//    self.geoCoderFrom = nil;
//}
//
//-(void) clearGeoCoderTo
//{
//    self.geoCoderTo = nil;
//}
//
//-(void) clearSearch
//{
//    self.search = nil;
//}

-(void) R2RGeoCoderResolved:(R2RGeoCoder *)delegateGeoCoder
{
     
    if (delegateGeoCoder == self.geoCoderFrom & self.state == RESOLVING_FROM)
    {
//        if (self.geoCoderFrom.responseCompletionState == stateLocationNotFound)
//        {
//            //use notification
//            //[self TextBoxAlert:@"Not Found" :@"From location not found"];
//            self.statusMessage = @"Origin not found";
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshStatusMessage" object:nil];
//            return;
//        }
        
//        if (self.geoCoderFrom.responseCompletionState == stateError)
//        {
//            self.statusMessage = [NSString stringWithFormat:@"%@: %@", @"Origin", self.geoCoderFrom.responseMessage];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshStatusMessage" object:nil];
//        }

        if (self.geoCoderFrom.responseCompletionState == stateResolved)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFromTextField" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTitle" object:nil];
        }
        
        self.state = IDLE;
        
        [self RefreshStatusMessage:geoCoderFrom];
        
        //if (self.geoCoderTo != nil && self.geoCoderTo.responseCompletionState != stateResolved)
        if (self.geoCoderTo == nil && [self.toText length] > 0)
        {
            //[self.geoCoderTo sendAsynchronousRequest];
            [self geoCodeToQuery:self.toText];
            return;
        }
        
    }
    else if (delegateGeoCoder == self.geoCoderTo & self.state == RESOLVING_TO)
    {
        
//        if (self.geoCoderTo.responseCompletionState == stateLocationNotFound)
//        {
//            //use notification
//            //[self TextBoxAlert:@"Not Found" :@"To location not found"];
//            
//            self.statusMessage = @"Destination not found";
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshStatusMessage" object:nil];
//            return;
//        }
            
//        if (self.geoCoderTo.responseCompletionState == stateError)
//        {
//            self.statusMessage = [NSString stringWithFormat:@"%@: %@", @"Destination", self.geoCoderTo.responseMessage];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshStatusMessage" object:nil];
//        }
        
        //use notification
        //self.toTextField.text = self.geoCoderTo.geoCodeResponse.place.longName;
        
        if (self.geoCoderTo.responseCompletionState == stateResolved)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshToTextField" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTitle" object:nil];
        }
     
        self.state = IDLE;
        
        [self RefreshStatusMessage:self.geoCoderTo];
        
        //if (self.geoCoderFrom != nil && self.geoCoderFrom.responseCompletionState != stateResolved)
        if (self.geoCoderFrom == nil && [self.fromText length] > 0)
        {
            //[self.geoCoderFrom sendAsynchronousRequest];
            [self geoCodeFromQuery:self.fromText];
            return;
        }
    }
    
    [self ResolvedStateChanged];
    
}

- (void) ResolvedStateChanged
{
    if (self.geoCoderFrom == nil || self.geoCoderTo == nil)
    {
        return;
    }
    
    if (self.geoCoderFrom.responseCompletionState == stateResolved && self.geoCoderTo.responseCompletionState == stateResolved)
    {
        NSLog(@"from\t%@\tto%@\t...", self.geoCoderFrom.geoCodeResponse.place.shortName, self.geoCoderTo.geoCodeResponse.place.shortName);
        
        //simulate delay. return to original code after testing
        //self.search = [[R2RSearch alloc] initWithFromToStrings:self.geoCoderFrom.searchString :self.geoCoderTo.searchString delegate:self];
        [self performSelector:@selector(InitSearch) withObject:nil afterDelay:0.0];
        
    }
}

- (void) InitSearch
{
    self.statusMessage = @"";
    [self RefreshStatusMessage:self.search];
    
    NSString *oName = self.geoCoderFrom.geoCodeResponse.place.shortName;
    NSString *dName = self.geoCoderTo.geoCodeResponse.place.shortName;
    NSString *oPos = [NSString stringWithFormat:@"%f,%f", self.geoCoderFrom.geoCodeResponse.place.lat, self.geoCoderFrom.geoCodeResponse.place.lng];
    NSString *dPos = [NSString stringWithFormat:@"%f,%f", self.geoCoderTo.geoCodeResponse.place.lat, self.geoCoderTo.geoCodeResponse.place.lng];
    
    self.search = [[R2RSearch alloc] initWithSearch:oName :dName :oPos :dPos delegate:self];
    
//    self.statusMessage = @"Searching";
    
    self.state = SEARCHING;
    [self performSelector:@selector(RefreshStatusMessage:) withObject:self.search afterDelay:2.0];
    
    //self.search = [[R2RSearch alloc] initWithFromToStrings:self.geoCoderFrom.searchString :self.geoCoderTo.searchString delegate:self];
    //self.search = [[R2RSearch alloc] initWithFromToStrings:self.fromSearchPlace.longName :self.toSearchPlace.longName delegate:self];
}

- (void) R2RSearchResolved:(R2RSearch *)delegateSearch;
{
    
    if (self.search == delegateSearch && self.state == SEARCHING)
    {
//        if (self.search.responseCompletionState == stateError)
//        {
//            self.statusMessage = [NSString stringWithFormat:@"%@: %@", @"Search", self.search.responseMessage];
//        }
        
        if (self.search.responseCompletionState == stateResolved)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshResults" object:nil];
//            self.statusMessage = @"";
        }
        
        //self.statusMessage = @"Search Finished";
        self.state = IDLE;
        
        [self RefreshStatusMessage:self.search];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshStatusMessage" object:nil];
    }
    //[self setResultsViewControllerData];
    
    //use notification
    //self.statusMessage = nil;
    //[self.resultsViewController UpdateResults];
}


- (void) RefreshStatusMessage: (id) sender
{
    
    if (self.geoCoderFrom != nil && self.geoCoderFrom.responseCompletionState == stateError)
    {
        self.statusMessage = [NSString stringWithFormat:@"%@: %@", @"Origin", self.geoCoderFrom.responseMessage];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshStatusMessage" object:nil];
        return;
    }
    
    if (self.geoCoderTo != nil && self.geoCoderTo.responseCompletionState == stateError)
    {
        self.statusMessage = [NSString stringWithFormat:@"%@: %@", @"Destination", self.geoCoderTo.responseMessage];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshStatusMessage" object:nil];
        return;
    }
    
    switch (self.state) {
        case IDLE:
            
            if (self.search != nil && self.search.responseCompletionState == stateError)
            {
                self.statusMessage = [NSString stringWithFormat:@"%@: %@", @"Search", self.search.responseMessage];
            }
            else
            {
                self.statusMessage = @"";
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshStatusMessage" object:nil];
            return;
            break;
            
        case RESOLVING_FROM:
            
            if (self.geoCoderFrom != nil && self.geoCoderFrom == sender)
            {
                self.statusMessage = [NSString stringWithFormat:@"%@: %@", @"Origin", @"Resolving"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshStatusMessage" object:nil];
            }
            break;
            
        case RESOLVING_TO:
            
            if (self.geoCoderTo != nil && self.geoCoderTo == sender)
            {
                self.statusMessage = [NSString stringWithFormat:@"%@: %@", @"Destination", @"Resolving"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshStatusMessage" object:nil];
            }
            break;
            
        case SEARCHING:
            
            if (self.search != nil && self.search == sender)
            {
                self.statusMessage = [NSString stringWithFormat:@"%@", @"Searching"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshStatusMessage" object:nil];
            }
            break;
            
        default:
            break;
    }
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshStatusMessage" object:sender];
}

- (void) FromEditingDidBegin
{
    self.fromText = @"";
    self.geoCoderFrom = nil;
    self.search = nil;
}

- (void) FromEditingDidEnd:(NSString *)query
{
    self.fromText = query;

    if (self.state == IDLE || self.state == RESOLVING_FROM)
    {
        [self geoCodeFromQuery:query];
    }
}

- (void) ToEditingDidBegin
{
    self.toText = @"";
    self.geoCoderTo = nil;
    self.search = nil;
}

- (void) ToEditingDidEnd:(NSString *)query
{
    self.toText = query;
    
    if (self.state == IDLE || self.state == RESOLVING_TO)
    {
        [self geoCodeToQuery:query];
    }
}




@end
