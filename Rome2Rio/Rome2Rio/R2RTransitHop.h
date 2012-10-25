//
//  R2RTransitHop.h
//  HttpRequest
//
//  Created by Ash Verdoorn on 4/09/12.
//  Copyright (c) 2012 Ash Verdoorn. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "R2RPosition.h"

@interface R2RTransitHop : NSObject

@property (nonatomic) float duration;
@property (nonatomic) float frequency;
@property (strong, nonatomic) NSMutableArray *lines;
//@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSString *sName;
@property (strong, nonatomic) R2RPosition *sPos;
@property (strong, nonatomic) NSString *tName;
@property (strong, nonatomic) R2RPosition *tPos;

@end
