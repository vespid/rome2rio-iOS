//
//  R2RAirport.h
//  HttpRequest
//
//  Created by Ash Verdoorn on 4/09/12.
//  Copyright (c) 2012 Ash Verdoorn. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "R2RPosition.h"

@interface R2RAirport : NSObject

@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) R2RPosition *pos;

@end
