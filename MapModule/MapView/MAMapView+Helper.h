//
//  MAMapView+Helper.h
//  ParkingWang
//
//  Created by Bin Shang on 2020/7/31.
//  Copyright © 2020 Xi'an iRain IoT. Technology Service CO., Ltd. . All rights reserved.
//

#import <AMapNaviKit/AMapNaviKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAMapView (Helper)

@property(nonatomic, assign, readonly) CLLocationCoordinate2D coordLeftTop;
@property(nonatomic, assign, readonly) CLLocationCoordinate2D coordRightTop;
@property(nonatomic, assign, readonly) CLLocationCoordinate2D coordLeftBtm;
@property(nonatomic, assign, readonly) CLLocationCoordinate2D coordRightBtm;

@end

NS_ASSUME_NONNULL_END
