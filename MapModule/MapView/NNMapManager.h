//
//  NNMapManager.h
//  VehicleBonus
//
//  Created by Bin Shang on 2019/4/2.
//  Copyright © 2019 Xi'an iRain IOT Technology Service CO., Ltd. . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

//#import <AMapNaviKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

#import "CommonUtility.h"
#import "ErrorInfoUtility.h"
#import "MANaviRoute.h"
#import "NNPOIAnnotationView.h"
#import "NNPOIAnnotation.h"

NS_ASSUME_NONNULL_BEGIN
//{纬度(-90~90),经度(-180~180)}

static NSString *const kUserCoordinateInfo = @"kUserCoordinateInfo";
static NSString *const kAnnoTitleStart = @"起点";
static NSString *const kAnnoTitleEnd = @"终点";
static NSString *const kAnnoTitleDefault = @"大头针";
static NSString *const kAnnoTitleUser = @"用户位置";
static NSString *const kAnnoTitleMove = @"轨迹移动针";
static NSString *const kAnnoTitleRoute = @"轨迹针";

static NSString *const kAnnoTitleCarGreen = @"car_green";
static NSString *const kAnnoTitleCarRed = @"car_red";

/// 经度,纬度
FOUNDATION_EXPORT NSString * NSStringFromCoordinate(CLLocationCoordinate2D coordinate);
/// {纬度(-90~90),经度(-180~180)}转经纬度结构体
FOUNDATION_EXPORT CLLocationCoordinate2D Coordinate2DFromString(NSString *coordinateInfo);
/// 界面之间数据传递类型转换为经纬度
FOUNDATION_EXPORT CLLocationCoordinate2D Coordinate2DFromObj(id obj);
/// 经度,纬度
FOUNDATION_EXPORT NSString * NSStringFromAMapGeoPoint(AMapGeoPoint *point);
/// AMapGeoPoint
FOUNDATION_EXPORT AMapGeoPoint * AMapGeoPointFromString(NSString *coordinateInfo);
/// AMapGeoPoint
FOUNDATION_EXPORT AMapGeoPoint * AMapGeoPointFromCoordinate(CLLocationCoordinate2D coordinate);
/// 定位位置描述
FOUNDATION_EXPORT NSString * NSStringFromReGeocode(AMapLocationReGeocode *regeocode);
/// 定位位置描述
FOUNDATION_EXPORT NSString * NSStringFromPlacemark(CLPlacemark *placemark);
/// 经纬度转NSData
FOUNDATION_EXPORT NSData * NSDataFromCoordinate(CLLocationCoordinate2D obj);
/// NSData转经纬度
FOUNDATION_EXPORT CLLocationCoordinate2D Coordinate2DFromNSData(NSData * data);
/// 经纬度转NSValue
FOUNDATION_EXPORT NSValue * NSValueFromCoordinate(CLLocationCoordinate2D obj);
/// NSValue转经纬度
FOUNDATION_EXPORT CLLocationCoordinate2D Coordinate2DFromNSValue(NSValue * value);

// 百度地图经纬度 -> 高德地图经纬度
FOUNDATION_EXPORT CLLocationCoordinate2D GaoDeCoordinate2DFromBaiDu(CLLocationCoordinate2D coordinate);
// 高德地图经纬度 -> 百度地图经纬度
FOUNDATION_EXPORT CLLocationCoordinate2D BaiDuCoordinate2DFromGaoDe(CLLocationCoordinate2D coordinate);
    
/// 路线长度信息描述
FOUNDATION_EXPORT NSString *DistanceInfoFromMeter(NSInteger distance);
/// 路线长度信息描述
FOUNDATION_EXPORT NSString * DistanceInfoFromAMapRoute(AMapRoute *route);
/// 获取两点经纬度之间直线/投影的距离
FOUNDATION_EXPORT CLLocationDistance DistanceFromTwoPoint(CLLocationCoordinate2D a, CLLocationCoordinate2D b);
/// 获取两点经纬度之间直线/投影的距离描述
FOUNDATION_EXPORT NSString * DistanceInfoFromTwoPoint(CLLocationCoordinate2D a, CLLocationCoordinate2D b);
/// 获取地图中心点和最长半径的距离
FOUNDATION_EXPORT CLLocationDistance DistanceFromMapCenterAndMaxEdg(MAMapView *mapView);
/// 获取地图中心点和最长半径的距离描述
FOUNDATION_EXPORT NSString * DistanceInfoFromMapCenterAndMaxEdgDes(MAMapView *mapView);

/// 经纬度转屏幕坐标, 调用者负责释放内存
FOUNDATION_EXPORT CGPoint *_Nullable MapPointsForParam(CLLocationCoordinate2D *coords, NSUInteger count, MAMapView *mapView);
/// 构建path, 调用着负责释放内存
FOUNDATION_EXPORT CGMutablePathRef MapPathForParam(CGPoint *points, NSUInteger count);
/// 多段MAPolyline
FOUNDATION_EXPORT NSArray<MAPolyline *> *MapPolylinesForPath(AMapPath *path);

/// 
//FOUNDATION_EXPORT CLLocationCoordinate2D *MapCoordinatesForParam(NSArray<AMapStep *> *steps);
//FOUNDATION_EXPORT CLLocationCoordinate2D *MapCoordinatesForParam(NSArray<NSString *> *stepCoords);


typedef MAAnnotationView* _Nullable (^ViewForAnnotationHandler)(MAMapView *mapView, id<MAAnnotation>annotation);
typedef MAOverlayRenderer* _Nullable (^RendererForOverlay)(MAMapView *mapView, id <MAOverlay>overlay);
typedef void (^MapSelectAnnotationViewHandler)(MAMapView *mapView, MAAnnotationView *view, BOOL didSelect);

typedef void (^MapDidUpdateUserHandler)(MAMapView *mapView, MAUserLocation *userLocation, BOOL updatingLocation, NSError *_Nullable error);
typedef void (^MapRegionDidChangeHandler)(MAMapView * mapView, BOOL animated, BOOL wasUserAction);

typedef void (^MapSingleTappedHandler)(MAMapView * mapView, CLLocationCoordinate2D coordinate);

typedef void (^MapLocationHandler)(CLLocation *_Nullable location, AMapLocationReGeocode *_Nullable regeocode, AMapLocationManager *_Nullable manager, NSError *_Nullable error);
typedef void (^MapReGeocodeSearchHandler)(AMapReGeocodeSearchRequest *request, AMapReGeocodeSearchResponse *_Nullable response, NSError *_Nullable error);
typedef void (^MapGeocodeSearchHandler)(AMapGeocodeSearchRequest *request,  AMapGeocodeSearchResponse *_Nullable response, NSError *_Nullable error);
typedef void (^MapPOISearchHandler)(AMapPOISearchBaseRequest *request, AMapPOISearchResponse *_Nullable response, NSError *_Nullable error);
typedef void (^MapInputTipsHandler)(AMapInputTipsSearchRequest *request, AMapInputTipsSearchResponse *_Nullable response, NSError *_Nullable error);

typedef void (^MapRouteHandler)(AMapRouteSearchBaseRequest *request, AMapRouteSearchResponse *_Nullable response, NSError *_Nullable error);
/// 地理围栏
typedef void (^MapGeoFenceHandler)(AMapGeoFenceManager *manager, NSArray <AMapGeoFenceRegion *> *regions, NSString *customID, NSError *_Nullable error);
///定制
typedef void (^ViewForPOIAnnotationHandler)(MAMapView *mapView, NNPOIAnnotationView *annotationView, NNPOIAnnotation *annotation);

@class MapLocationInfoModel;
@interface NNMapManager : NSObject<MAMapViewDelegate, AMapSearchDelegate, AMapLocationManagerDelegate, AMapGeoFenceManagerDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) AMapSearchAPI *searchAPI;
@property (nonatomic, strong) AMapGeoFenceManager *geoFenceManager;

@property (nonatomic, assign) CLLocationCoordinate2D coordinateStart;
@property (nonatomic, assign) CLLocationCoordinate2D coordinateEnd;

@property (nonatomic, strong) MAAnnotationView *userLocationView;
@property (nonatomic, strong) UIButton *locaBtn;

@property (nonatomic, assign) MANaviAnnotationType naviRouteType;

@property (nonatomic, copy) ViewForAnnotationHandler viewForAnnotationHandler;
@property (nonatomic, copy) RendererForOverlay RendererForOverlayHandler;

/**mapView: didUpdateUserLocation: updatingLocation:*/
@property (nonatomic, copy) MapDidUpdateUserHandler didUpdateUserHandler;
/**mapView: regionDidChangeAnimated: wasUserAction:*/
@property (nonatomic, copy) MapRegionDidChangeHandler regionDidChangeHandler;
@property (nonatomic, copy) MapSelectAnnotationViewHandler selectAnnotationViewHandler;

/** amapLocationManager:didUpdateLocation: reGeocode:*/
@property (nonatomic, copy) MapLocationHandler locationHandler;
@property (nonatomic, copy) MapReGeocodeSearchHandler reGeocodeSearchHandler;
@property (nonatomic, copy) MapGeocodeSearchHandler geocodeSearchHandler;
@property (nonatomic, copy) MapPOISearchHandler POISearchHandler;
@property (nonatomic, copy) MapInputTipsHandler tipsHandler;
@property (nonatomic, copy) MapRouteHandler routeHandler;
@property (nonatomic, copy) MapGeoFenceHandler geoFenceHandler;

@property (nonatomic, strong) NSDictionary *annViewDict;//起点终点信息

/** 是否有经纬度*/
@property (nonatomic, assign) BOOL hasLocation;

+ (instancetype)shared;
/**
 创建地图(通用配置)
 */
+(MAMapView *)createDefaultMapView;
/**
 创建地图定位按钮(通用配置)
 */
+(UIButton *)createDefaultLocaBtn;
/**
 创建地图LocationManager(通用配置)
 */
+(AMapLocationManager *)createDefaultLocationManager;

/**
 定位权限
 */
- (BOOL)hasAccessRightOfLocation;

/**
 开始单次定位
 */
- (void)startSingleLocationWithReGeocode:(BOOL)reGeocode handler:(MapLocationHandler)handler;
/**
 开始持续定位
 */
- (void)startSerialLocationWithReGeocode:(BOOL)reGeocode;

/**
 根据mapview参数实时返回经纬度
 */
//- (void)didUpdateUserLocationHandler:(MapLocationHandler)handler;

/**
 开始周边搜索🔍
 */
- (void)aroundSearchCoordinate:(CLLocationCoordinate2D)coordinate
                         block:(void(^_Nullable)(AMapPOIAroundSearchRequest *request))block
                       handler:(MapPOISearchHandler)handler;

/**
 逆地理编码请求
 */
- (void)reGeocodeSearchWithBlock:(void(^_Nullable)(AMapReGeocodeSearchRequest *request))block
                         handler:(MapReGeocodeSearchHandler)handler;
/**
 地理编码请求
 */
- (void)geocodeSearchWithBlock:(void(^_Nullable)(AMapGeocodeSearchRequest *request))block
                       handler:(MapGeocodeSearchHandler)handler;

/**
 关键字搜索
 
 @param keywords 搜索关键字 必传参数
 */
- (void)keywordsSearchWithKeywords:(NSString *)keywords
                              city:(NSString *)city
                              page:(NSInteger)page
                             block:(void(^_Nullable)(AMapPOIKeywordsSearchRequest *request))block
                           handler:(MapPOISearchHandler)handler;
/**
 提示搜索
 */
- (void)tipsSearchWithKeywords:(NSString *)keywords
                          city:(NSString *)city
                         block:(void(^_Nullable)(AMapInputTipsSearchRequest *request))block
                       handler:(MapPOISearchHandler)handler;

/**
 路径搜索
 */
///驾车路线
- (void)searchRoutePlanningDriveStartPoint:(CLLocationCoordinate2D)startPoint endPoint:(CLLocationCoordinate2D)endPoint strategy:(NSInteger)strategy handler:(MapRouteHandler)handler;
///步行路线
- (void)searchRoutePlanningWalkStartPoint:(CLLocationCoordinate2D)startPoint endPoint:(CLLocationCoordinate2D)endPoint handler:(MapRouteHandler)handler;
///公交路线
- (void)searchRoutePlanningBusStartPoint:(CLLocationCoordinate2D)startPoint endPoint:(CLLocationCoordinate2D)endPoint strategy:(NSInteger)strategy city:(NSString *)city handler:(MapRouteHandler)handler;
///骑行路线
- (void)searchRoutePlanningRidingStartPoint:(CLLocationCoordinate2D)startPoint endPoint:(CLLocationCoordinate2D)endPoint strategy:(NSInteger)strategy city:(NSString *)city handler:(MapRouteHandler)handler;
///货车路线
- (void)searchRoutePlanningTruckStartPoint:(CLLocationCoordinate2D)startPoint endPoint:(CLLocationCoordinate2D)endPoint strategy:(NSInteger)strategy handler:(MapRouteHandler)handler;
///路线搜索并绘制到地图
- (void)routePlanningDriveStartPoint:(CLLocationCoordinate2D)startPoint endPoint:(CLLocationCoordinate2D)endPoint strategy:(NSInteger)strategy mapView:(MAMapView *)mapView handler:(MapRouteHandler)handler;
///绘制路线到地图
- (void)presentRouteStartPoint:(CLLocationCoordinate2D )startPoint endPoint:(CLLocationCoordinate2D )endPoint response:(AMapRouteSearchResponse *)response mapView:(MAMapView *)mapView type:(MANaviAnnotationType)type;

    
- (void)geoFenceAddCircleRegionWithCenter:(CLLocationCoordinate2D)center radius:(CLLocationDistance)radius customID:(NSString *)customID handler:(MapGeoFenceHandler)handler;

- (void)geoFenceAddPolygonRegionWithCoordinates:(CLLocationCoordinate2D *)coordinates count:(NSInteger)count customID:(NSString *)customID handler:(MapGeoFenceHandler)handler;

- (void)geoFenceAddKeywordPOIRegionForMonitoringWithKeyword:(NSString *)keyword POIType:(NSString *)type city:(NSString *)city size:(NSInteger)size customID:(NSString *)customID handler:(MapGeoFenceHandler)handler;

- (void)geoFenceAddAroundPOIRegionForMonitoringWithLocationPoint:(CLLocationCoordinate2D)locationPoint aroundRadius:(NSInteger)aroundRadius keyword:(NSString *)keyword POIType:(NSString *)type size:(NSInteger)size customID:(NSString *)customID handler:(MapGeoFenceHandler)handler;

- (void)geoFenceAddDistrictRegionForMonitoringWithDistrictName:(NSString *)districtName customID:(NSString *)customID handler:(MapGeoFenceHandler)handler;


/**
 获取指定title的针
 */
+ (MAPointAnnotation *)annoWithTitle:(NSString *)title mapView:(MAMapView *)mapView;

+ (NSString *)getAddressInfo:(id)obj isAdjust:(BOOL)isAdjust;

- (AMapTip *)mapTipFromPoi:(AMapPOI *)mapPoi;

@end


@interface MapLocationInfoModel : NSObject

@property (nonatomic, strong) AMapLocationReGeocode *locationReGeocode;
@property (nonatomic, strong) AMapReGeocodeSearchResponse *reGeocodeResponse;
@property (nonatomic, strong) AMapGeocodeSearchResponse *geocodeResponse;

@property (nonatomic, strong) AMapInputTipsSearchResponse *inputTipsResponse;
@property (nonatomic, strong) AMapRouteSearchResponse *routeResponse;

@property (nonatomic, strong) AMapPOISearchResponse *poiSearchResponse;

@end


NS_ASSUME_NONNULL_END
