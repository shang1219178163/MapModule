//
//  MAAnnotationView+Map.h
//  VehicleBonus
//
//  Created by Bin Shang on 2019/4/4.
//  Copyright © 2019 Xi'an iRain IOT Technology Service CO., Ltd. . All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAAnnotationView (Map)

/**
 [源]获取针视图
 */
+ (instancetype)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation identifier:(NSString *)identifier;

/**
 [源]获取针视图
 */
+ (instancetype)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation;
    
@end

NS_ASSUME_NONNULL_END
