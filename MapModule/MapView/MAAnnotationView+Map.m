//
//  MAAnnotationView+Map.m
//  VehicleBonus
//
//  Created by Bin Shang on 2019/4/4.
//  Copyright © 2019 Xi'an iRain IOT Technology Service CO., Ltd. . All rights reserved.
//

#import "MAAnnotationView+Map.h"

@implementation MAAnnotationView (Map)

+ (instancetype)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation identifier:(NSString *)identifier{
    MAAnnotationView * view = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!view) {
        view = [[self alloc]initWithAnnotation:annotation reuseIdentifier:identifier];
    }
    return view;
}

+ (instancetype)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    NSString *identifier = NSStringFromClass(self.class);
    return [self mapView:mapView viewForAnnotation:annotation identifier:identifier];
}
    
@end
