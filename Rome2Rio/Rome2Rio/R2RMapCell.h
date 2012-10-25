//
//  R2RMapCell.h
//  Rome2Rio
//
//  Created by Ash Verdoorn on 17/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface R2RMapCell : UITableViewCell

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
