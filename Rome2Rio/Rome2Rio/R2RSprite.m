//
//  R2RSprite.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 29/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RSprite.h"

@interface R2RSprite()

@end

@implementation R2RSprite

@synthesize sprite, spriteOffset, spriteSize, imagePath;

-(id)initWithPath:(NSString *)path :(CGPoint)offset :(CGSize)size
{
    self = [super init];
    if (self)
    {
        self.imagePath = path;
        self.spriteOffset = offset;
        self.spriteSize = size;
    }
    return self;
}

-(id)initWithImage:(UIImage *)image :(CGRect)rect
{
    self = [super init];
    if (self)
    {
        self.spriteOffset = CGPointMake(rect.origin.x, rect.origin.y);
        self.spriteSize = CGSizeMake(rect.size.width, rect.size.height);
        [self setSpriteFromImage:image];
    }
    return self;
}

-(id)initWithImage:(UIImage *)image :(CGPoint)offset :(CGSize)size
{
    self = [super init];
    if (self)
    {
        self.spriteOffset = offset;
        self.spriteSize = size;
        [self setSpriteFromImage:image];
    }
    return self;
}

-(void)setSpriteFromImage:(UIImage *)image
{
    CGRect rect = CGRectMake(self.spriteOffset.x, self.spriteOffset.y, self.spriteSize.width, self.spriteSize.height);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    
    self.sprite = [UIImage imageWithCGImage:imageRef];

    CGImageRelease(imageRef);
}

-(void)setSpriteFromImage:(UIImage *)image :(CGPoint)offset :(CGSize)size
{
    self.spriteOffset = offset;
    self.spriteSize = size;
    [self setSpriteFromImage:image];
}

@end
