//
//  BNDriverRouteController.h
//  VehicleBonus
//
//  Created by Bin Shang on 2019/4/2.
//  Copyright © 2019 Xi'an iRain IOT Technology Service CO., Ltd. . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BNDriverRouteView.h"
#import "BNDriverRouteTipView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 驾车路径展示控制器
 */
@interface BNDriverRouteController : UIViewController

@property (nonatomic, strong) BNDriverRouteView *routeView;
@property (nonatomic, strong) BNDriverRouteTipView *routeTipView;

@property (nonatomic, assign) CLLocationCoordinate2D startPoint;
@property (nonatomic, assign) CLLocationCoordinate2D endPoint;

@property (nonatomic, strong) id start;
@property (nonatomic, strong) id end;

@end

NS_ASSUME_NONNULL_END
