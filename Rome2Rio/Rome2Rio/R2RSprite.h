//
//  R2RSprite.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 29/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

// Only retaining the sprites image, not the combined image it is taken from 

#import <Foundation/Foundation.h>

@interface R2RSprite : NSObject

@property (strong, nonatomic) UIImage *sprite;
@property (nonatomic) CGPoint spriteOffset;
@property (nonatomic) CGSize spriteSize;
@property (strong, nonatomic) NSString *imagePath;

-(id) initWithPath:(NSString *) path :(CGPoint)offset :(CGSize)size;
-(id) initWithImage:(UIImage *) image :(CGPoint)offset :(CGSize)size;

-(void) setSpriteFromImage:(UIImage *)image;
-(void) setSpriteFromImage:(UIImage *)image :(CGPoint)offset :(CGSize)size;


@end
