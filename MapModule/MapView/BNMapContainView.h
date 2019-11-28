//
//  BNMapView.h
//  VehicleBonus
//
//  Created by Bin Shang on 2019/3/18.
//  Copyright © 2019 Xi'an iRain IOT Technology Service CO., Ltd. . All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BNMapManager.h"
#import "MAAnnotationView+Map.h"
#import "BNPOIAnnotation.h"

@class MapLocationInfoModel;

@interface BNMapContainView : UIView<MAMapViewDelegate, AMapSearchDelegate, AMapLocationManagerDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) AMapSearchAPI *searchAPI;
@property (nonatomic, strong) MANaviRoute * naviRoute;

@property (nonatomic, assign) CLLocationCoordinate2D coordinateStart;
@property (nonatomic, assign) CLLocationCoordinate2D coordinateEnd;

@property (nonatomic, strong) MAAnnotationView *userLocationView;
@property (nonatomic, strong) UIButton *locaBtn;


@property (nonatomic, copy) ViewForAnnotationHandler viewForAnnotationHandler;
/**mapView: didUpdateUserLocation: updatingLocation:*/
@property (nonatomic, copy) MapDidUpdateUserHandler didUpdateUserHandler;

/** amapLocationManager:didUpdateLocation: reGeocode:*/
@property (nonatomic, copy) MapLocationHandler locationHandler;
@property (nonatomic, copy) MapSelectViewHandler selectHandler;

// 快速创建一个locationManager
+ (instancetype)shared;

- (void)presentCurrentRouteStartPoint:(CLLocationCoordinate2D )startPoint endPoint:(CLLocationCoordinate2D )endPoint response:(AMapRouteSearchResponse *)response;
/// 展示驾车路径(显示交通情况)
- (void)presentDriveRouteStart:(CLLocationCoordinate2D )startPoint end:(CLLocationCoordinate2D )endPoint response:(AMapRouteSearchResponse *)response;

@end

