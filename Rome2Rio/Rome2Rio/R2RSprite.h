//
//  R2RSprite.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 29/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

//CODECHECK don't like that this is used 2 different ways.

#import <Foundation/Foundation.h>

@interface R2RSprite : NSObject

@property (nonatomic) CGPoint offset;
@property (nonatomic) CGSize size;
@property (strong, nonatomic) NSString *path;

//-(id) initWithImage:(UIImage *) image :(CGPoint)offset :(CGSize)size;
//-(id) initWithImage:(UIImage *)image :(CGRect)rect;

-(id) initWithPath:(NSString *) path :(CGPoint)offset :(CGSize)size;

-(UIImage *) getSprite:(UIImage *) image;

//-(UIImage *) getSprite; //used for local images if initWithImage


//-(void) setSpriteFromImage:(UIImage *)image;
//-(void) setSpriteFromImage:(UIImage *)image :(CGPoint)offset :(CGSize)size;



@end
