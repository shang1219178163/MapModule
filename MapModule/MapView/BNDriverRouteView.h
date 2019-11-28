//
//  BNDriverRouteView.h
//  VehicleBonus
//
//  Created by Bin Shang on 2019/4/2.
//  Copyright © 2019 Xi'an iRain IOT Technology Service CO., Ltd. . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNMapContainView.h"
#import "Tracking.h"

NS_ASSUME_NONNULL_BEGIN

/**
 驾车路径规划视图
 */
@interface BNDriverRouteView : UIView

@property (nonatomic, strong) BNMapContainView *containView;

@property (nonatomic, strong, readonly) Tracking *tracking;
@property (nonatomic, strong, readonly) NSMutableArray * trackingPoints;

@property (nonatomic, copy) void(^distanceInfoHandler)(NSString *distanceInfo);
@property (nonatomic, copy) void(^routeSearchResponse)(AMapRouteSearchResponse *response);

@property (nonatomic, strong) MAAnimatedAnnotation* annotation;

/// 路径所有点经纬度字符串集合
FOUNDATION_EXPORT NSArray<NSString *> *RouteStepCoordsFromSteps(NSArray<AMapStep *> *steps);
/// 路径所有点经纬度结构体集合
FOUNDATION_EXPORT CLLocationCoordinate2D *RouteCoordsForStepCoords(NSArray<NSString *> *stepCoords);
/// 路径大头针集合
FOUNDATION_EXPORT NSMutableArray<MAPointAnnotation *> * RouteAnnosFromParam(CLLocationCoordinate2D *coords, NSString *title, NSInteger count);

- (void)showRouteStartPoint:(CLLocationCoordinate2D)startPoint endPoint:(CLLocationCoordinate2D)endPoint;
- (void)presentDriveRouteWithResponse:(AMapRouteSearchResponse *)response;

@end

NS_ASSUME_NONNULL_END
