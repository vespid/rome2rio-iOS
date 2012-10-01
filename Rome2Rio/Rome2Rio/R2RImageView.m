//
//  R2RImageView.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 24/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RImageView.h"

@implementation R2RImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void) setCroppedImage:(UIImage *)image :(CGRect) rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    
    UIImage *result = [UIImage imageWithCGImage:imageRef];
    
    self.image = result;
}

@end
