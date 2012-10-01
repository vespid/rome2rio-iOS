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

@property (strong, nonatomic) NSString *sName;
@property (strong, nonatomic) R2RPosition *sPos;
@property (strong, nonatomic) NSString *tName;
@property (strong, nonatomic) R2RPosition *tPos;
@property (strong, nonatomic) NSString *vehicle;
@property (strong, nonatomic) NSString *line;
@property (nonatomic) float frequency;
@property (nonatomic) float duration;
@property (strong, nonatomic) NSString *agency;
@property (nonatomic) CGPoint iconOffset;
@property (strong, nonatomic) NSString *iconPath;

@property (strong, nonatomic) NSMutableArray *path;

@end
