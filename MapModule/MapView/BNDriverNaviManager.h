//
//  BNDriverNaviManager.h
//  VehicleBonus
//
//  Created by Bin Shang on 2019/4/1.
//  Copyright © 2019 Xi'an iRain IOT Technology Service CO., Ltd. . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapNaviKit/AMapNaviKit.h>

UIKIT_EXTERN NSString * NSStringFromAMapNaviPoint(AMapNaviPoint *point) ;
UIKIT_EXTERN AMapNaviPoint * AMapNaviPointFromString(NSString *coordinateInfo) ;
UIKIT_EXTERN AMapNaviPoint * AMapNaviPointFromCoordinate(CLLocationCoordinate2D coordinate);

typedef void(^MapNaviDriveHandler)(AMapNaviDriveManager *driveManager, AMapNaviRoutePlanType type, NSError *error);


/**
 驾车导航代理方法处理
 */
@interface BNDriverNaviManager : NSObject

@property (nonatomic, strong) AMapNaviDriveManager *driveManager;
@property (nonatomic, copy) MapNaviDriveHandler naviDriveHandler;
@property (nonatomic, strong) UINavigationController * target;
@property (nonatomic, weak) UIViewController *presnteDriveVC; //弹出导航VC的VC

+ (instancetype)shareInstance;

- (void)calculateDriveRouteWithStartPoint:(AMapNaviPoint *)startPoint endPoint:(AMapNaviPoint *)endPoint handler: (MapNaviDriveHandler)handler;

@end


