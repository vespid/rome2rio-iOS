//
//  R2RSpriteViewsModel.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 16/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RSpriteViewsModel.h"

@implementation R2RSpriteViewsModel

-(id)init
{
    self = [super init];
    
    if (self != nil)
    {
        self.views = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
