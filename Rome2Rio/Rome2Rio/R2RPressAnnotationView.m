//
//  R2RPressAnnotationView.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 23/11/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RPressAnnotationView.h"

@implementation R2RPressAnnotationView

@synthesize fromButton, toButton;

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        
        CGRect frame = self.frame;
        frame.size = CGSizeMake(100.0, 50.0);
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        self.centerOffset = CGPointMake(0.0, -25.0);
        
        self.fromButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        [self.fromButton setTitle:@"From here" forState:UIControlStateNormal];
        [self addSubview:self.fromButton];
        
        self.toButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 100, 20)];
        [self.toButton setTitle:@"To here" forState:UIControlStateNormal];
        [self addSubview:self.toButton];
//        R2RPressAnnotation *annotation = (R2RPressAnnotation *)self.annotation;

//        CGRect frame = self.frame;
//        frame.size = CGSizeMake(60.0, 85.0);
//        self.frame = frame;
//        self.backgroundColor = [UIColor clearColor];
//        self.centerOffset = CGPointMake(30.0, 42.0);
    }
    return self;
}

//- (void)setAnnotation:(id <MKAnnotation>)annotation
//{
//    [super setAnnotation:annotation];
//}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    
    // draw the gray pointed shape:
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0.0, 0.0);
    CGPathAddLineToPoint(path, NULL, 100.0, 0.0);
    CGPathAddLineToPoint(path, NULL, 100.0, 40.0);
    CGPathAddLineToPoint(path, NULL, 60.0, 40.0);
    CGPathAddLineToPoint(path, NULL, 50.0, 50.0);
    CGPathAddLineToPoint(path, NULL, 40.0, 40.0);
    CGPathAddLineToPoint(path, NULL, 0.0, 40.0);
    CGPathAddLineToPoint(path, NULL, 0.0, 0.0);
    CGContextAddPath(context, path);
    CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGPathRelease(path);
}


@end
