//
//  R2RTransitSegmentView.m
//  R2RApp
//
//  Created by Ash Verdoorn on 13/09/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RTransitSegmentView.h"

@implementation R2RTransitSegmentView

@synthesize kind, from, to, duration, line;

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

-(void) drawRect:(CGRect)rect
{
    
    NSMutableString *str = [[NSMutableString alloc] initWithString:self.kind];
    
    [str appendString:@" from "];
    [str appendString:self.from];
    [str appendString:@" to "];
    [str appendString:self.to];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]
                                         initWithString:str];
    
//    CGPoint point;
//    point = CGPointMake(5, 5);
//    
//    [str drawAtPoint:<#(CGPoint)#> forWidth:<#(CGFloat)#> withFont:<#(UIFont *)#> fontSize:<#(CGFloat)#> lineBreakMode:<#(UILineBreakMode)#> baselineAdjustment:<#(UIBaselineAdjustment)#>]
//    
//    [string drawAtPoint:point];
//    
//    [timeString drawAtPoint:point forWidth:MIDDLE_COLUMN_WIDTH withFont:mainFont minFontSize:actualFontSize actualFontSize:&actualFontSize lineBreakMode:UILineBreakModeTailTruncation baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
//    
    
    //CGFont *font = [CGFont fontWithName:@"Helvetica" size:14.0];
    
    //NSFont *font =
    
    
//    [string :<#(NSAttributedString *)#>]
//    //CGFontRef helvetica = CGFontCreateWithFontName(CFSTR("Helvetica"));
//    
//    CGFontRef helvetica = CGFontCreateCopyWithVariations(CFSTR("Helvetica"), 14.0, NULL);
//    
//    
//	// make a few words bold
//	CGFontRef helvetica = CGFontCreateWithName(CGSTR("Helvetica"), 14.0, NULL);
//	CGFontRef helveticaBold = CGFontCreateWithName(CGSTR("Helvetica-Bold"), 14.0, NULL);
//    
//	[string addAttribute:(id)kCTFontAttributeName
//                   value:(id)helvetica
//                   range:NSMakeRange(0, [string length])];
//    
//	[string addAttribute:(id)kCTFontAttributeName
//                   value:(id)helveticaBold
//                   range:NSMakeRange(6, 5)];
//    
//	[string addAttribute:(id)kCTFontAttributeName
//                   value:(id)helveticaBold
//                   range:NSMakeRange(109, 9)];
//    
//	[string addAttribute:(id)kCTFontAttributeName
//                   value:(id)helveticaBold
//                   range:NSMakeRange(223, 6)];
//    
//	// add some color
//	[string addAttribute:(id)kCTForegroundColorAttributeName
//                   value:(id)[UIColor redColor].CGColor
//                   range:NSMakeRange(18, 3)];
//    
//	[string addAttribute:(id)kCTForegroundColorAttributeName
//                   value:(id)[UIColor greenColor].CGColor
//                   range:NSMakeRange(657, 6)];
//    
//	[string addAttribute:(id)kCTForegroundColorAttributeName
//                   value:(id)[UIColor blueColor].CGColor
//                   range:NSMakeRange(153, 6)];
}

@end
