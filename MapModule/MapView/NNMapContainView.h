//
//  NNMapView.h
//  VehicleBonus
//
//  Created by Bin Shang on 2019/3/18.
//  Copyright © 2019 Xi'an iRain IOT Technology Service CO., Ltd. . All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NNMapManager.h"
#import "MAAnnotationView+Map.h"
#import "NNPOIAnnotation.h"

@class MapLocationInfoModel;

NS_ASSUME_NONNULL_BEGIN

@interface NNMapContainView : UIView<MAMapViewDelegate, AMapSearchDelegate, AMapLocationManagerDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) AMapSearchAPI *searchAPI;
@property (nonatomic, strong) MANaviRoute * naviRoute;
@property (nonatomic, assign) MANaviAnnotationType naviRouteType;

@property (nonatomic, assign) CLLocationCoordinate2D coordinateStart;
@property (nonatomic, assign) CLLocationCoordinate2D coordinateEnd;

@property (nonatomic, strong) MAAnnotationView *userLocationView;
@property (nonatomic, strong) UIButton *locaBtn;
@property (nonatomic, assign) CGSize locaBtnSize;
@property (nonatomic, assign) BOOL isBottomLeft;
@property (nonatomic, assign) CGFloat bottomSpacing;

@property (nonatomic, assign) BOOL hideCircleView;

@property (nonatomic, copy) ViewForAnnotationHandler viewForAnnotationHandler;
@property (nonatomic, copy) ViewForPOIAnnotationHandler viewForPOIAnnotationHandler;

/**mapView: didUpdateUserLocation: updatingLocation:*/
@property (nonatomic, copy) MapDidUpdateUserHandler didUpdateUserHandler;
/**mapView: regionDidChangeAnimated: wasUserAction:*/
@property (nonatomic, copy) MapRegionDidChangeHandler regionDidChangeHandler;
/**- (void)mapView: didSingleTappedAtCoordinate:*/
@property (nonatomic, copy) MapSingleTappedHandler singleTappedHandler;

/** amapLocationManager:didUpdateLocation: reGeocode:*/
@property (nonatomic, copy) MapLocationHandler locationHandler;
@property (nonatomic, copy) MapSelectAnnotationViewHandler selectHandler;

// 快速创建一个locationManager
+ (instancetype)shared;

- (void)routePlanningDriveStartPoint:(CLLocationCoordinate2D)startPoint
                            endPoint:(CLLocationCoordinate2D)endPoint
                             handler:(MapRouteHandler)handler;

- (void)presentRouteStartPoint:(CLLocationCoordinate2D )startPoint
                      endPoint:(CLLocationCoordinate2D )endPoint
                      response:(AMapRouteSearchResponse *)response
                          type:(MANaviAnnotationType)type;

@end

NS_ASSUME_NONNULL_END
