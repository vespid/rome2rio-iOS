//
//  R2RGetRoutesData.h
//  HttpRequest
//
//  Created by Ash Verdoorn on 4/09/12.
//  Copyright (c) 2012 Ash Verdoorn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface R2RSearchResponse : NSObject

@property (strong, nonatomic) NSMutableArray *routes;
@property (strong, nonatomic) NSMutableArray *airports;
@property (strong, nonatomic) NSMutableArray *airlines;
@property (strong, nonatomic) NSMutableArray *agencies;

@end
