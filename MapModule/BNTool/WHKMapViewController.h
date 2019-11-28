//
//  WHKMapViewController.h
//  
//
//  Created by BIN on 2017/9/7.
//  Copyright © 2017年 SHANG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BNMapManager.h"

@interface WHKMapViewController : UIViewController<MAMapViewDelegate,AMapLocationManagerDelegate,AMapSearchDelegate>

@property (nonatomic, strong) MAMapView * mapView;
@property (nonatomic, strong) UIView * containView;

- (MAPointAnnotation *)addAnnotionCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title isBegin:(BOOL)isBegin;


@end
