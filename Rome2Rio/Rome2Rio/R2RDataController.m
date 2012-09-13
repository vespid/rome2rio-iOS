//
//  R2RDataController.m
//  R2RApp
//
//  Created by Ash Verdoorn on 12/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RDataController.h"

@interface R2RDataController ()

enum {
    stateEmpty = 0,
    stateEditingDidBegin,
    stateEditingDidEnd,
    stateResolved,
    stateLocationNotFound
};

@end


@implementation R2RDataController

@synthesize geoCoderFrom, geoCoderTo, search;


-(void) geoCodeFromQuery:(NSString *)query
{
    self.geoCoderFrom = [[R2RGeoCoder alloc] initWithSearchString:query delegate:self];
    [self.geoCoderFrom sendAsynchronousRequest];
}

-(void) geoCodeToQuery:(NSString *)query
{
    self.geoCoderTo = [[R2RGeoCoder alloc] initWithSearchString:query delegate:self];
    [self.geoCoderTo sendAsynchronousRequest];
}

-(void) clearGeoCoderFrom
{
    self.geoCoderFrom = nil;
}

-(void) clearGeoCoderTo
{
    self.geoCoderTo = nil;
}

-(void) clearSearch
{
    self.search = nil;
}

-(void) R2RGeoCoderResolved:(R2RGeoCoder *)delegateGeoCoder
{
    if (delegateGeoCoder == self.geoCoderFrom)
    {
        if (self.geoCoderFrom.responseCompletionState == stateLocationNotFound)
        {
            //use notification
            //[self TextBoxAlert:@"Not Found" :@"From location not found"];
            return;
        }
        
        //use notification
        //self.fromTextField.text = self.geoCoderFrom.geoCodeResponse.place.longName;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFromTextField" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTitle" object:nil];
        
        if (self.geoCoderTo != nil && self.geoCoderTo.responseCompletionState != stateResolved)
        {
            [self.geoCoderTo sendAsynchronousRequest];
            return;
        }
        
    }
    else if (delegateGeoCoder == self.geoCoderTo)
    {
        
        if (self.geoCoderTo.responseCompletionState == stateLocationNotFound)
        {
            //use notification
            //[self TextBoxAlert:@"Not Found" :@"To location not found"];
            return;
        }
            
        //use notification
        //self.toTextField.text = self.geoCoderTo.geoCodeResponse.place.longName;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshToTextField" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTitle" object:nil];
        
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
        [self performSelector:@selector(InitSearch) withObject:nil afterDelay:3.0];
        
    }
}

- (void) InitSearch
{
    //add lat longs to search
    self.search = [[R2RSearch alloc] initWithFromToStrings:self.geoCoderFrom.searchString :self.geoCoderTo.searchString delegate:self];
    //self.search = [[R2RSearch alloc] initWithFromToStrings:self.fromSearchPlace.longName :self.toSearchPlace.longName delegate:self];
}

- (void)R2RSearchResolved:(R2RSearch *)delegateSearch;
{
    
    //[self setResultsViewControllerData];
    
    //use notification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshResults" object:nil];
    //[self.resultsViewController UpdateResults];
}



@end
