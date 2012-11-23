//
//  R2RPressAnnotationView.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 23/11/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "R2RPressAnnotation.h"

@interface R2RPressAnnotationView : MKAnnotationView

@property (strong, nonatomic) UIButton *fromButton;
@property (strong, nonatomic) UIButton *toButton;

@end
