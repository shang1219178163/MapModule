//
//  BNMapOpenHelper.h
//  VehicleBonus
//
//  Created by Bin Shang on 2019/4/4.
//  Copyright © 2019 Xi'an iRain IOT Technology Service CO., Ltd. . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BNMapOpenHelper : NSObject

FOUNDATION_EXPORT CLLocation * CLLocationFromCoordinate(CLLocationCoordinate2D coordinate);

FOUNDATION_EXPORT MKPlacemark * MKPlacemarkFromCLPlacemark(CLPlacemark *placemark);

FOUNDATION_EXPORT MKMapItem * MKMapItemFromMKPlacemark(MKPlacemark *placemark);

///苹果地图
+ (void)openAppleMapWithEndPoint:(CLLocationCoordinate2D)endPoint address:(NSString *)address;
///高德地图
+ (void)openGDMapWithEndPoint:(CLLocationCoordinate2D)endPoint address:(NSString *)address;
///百度地图
+ (void)openBaiDuMapWithStartPoint:(CLLocationCoordinate2D)startPoint endPoint:(CLLocationCoordinate2D)endPoint;

@end

NS_ASSUME_NONNULL_END
