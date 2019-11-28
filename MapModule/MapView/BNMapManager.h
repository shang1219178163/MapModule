//
//  BNMapManager.h
//  VehicleBonus
//
//  Created by Bin Shang on 2019/4/2.
//  Copyright © 2019 Xi'an iRain IOT Technology Service CO., Ltd. . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

#import "CommonUtility.h"
#import "ErrorInfoUtility.h"
#import "MANaviRoute.h"

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

/// {纬度,经度}
FOUNDATION_EXPORT NSString * NSStringFromCoordinate(CLLocationCoordinate2D coordinate);
/// {纬度(-90~90),经度(-180~180)}转经纬度结构体
FOUNDATION_EXPORT CLLocationCoordinate2D Coordinate2DFromString(NSString * coordinateInfo);
/// 界面之间数据传递类型转换为经纬度
FOUNDATION_EXPORT CLLocationCoordinate2D Coordinate2DFromObj(id obj);
/// {纬度,经度}
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
/// 路线长度信息描述
FOUNDATION_EXPORT NSString * DistanceInfoFromAMapRoute(AMapRoute *route);
/// 经纬度转屏幕坐标, 调用着负责释放内存
FOUNDATION_EXPORT CGPoint *MapPointsForParam(CLLocationCoordinate2D *coords, NSUInteger count, MAMapView *mapView);
/// 构建path, 调用着负责释放内存
FOUNDATION_EXPORT CGMutablePathRef MapPathForParam(CGPoint *points, NSUInteger count);
/// 多段MAPolyline
FOUNDATION_EXPORT NSArray<MAPolyline *> *MapPolylinesForPath(AMapPath *path);

/// 
//FOUNDATION_EXPORT CLLocationCoordinate2D *MapCoordinatesForParam(NSArray<AMapStep *> *steps);
//FOUNDATION_EXPORT CLLocationCoordinate2D *MapCoordinatesForParam(NSArray<NSString *> *stepCoords);


typedef MAAnnotationView* (^ViewForAnnotationHandler)(MAMapView *mapView, id<MAAnnotation>annotation);
typedef MAOverlayRenderer* (^RendererForOverlay)(MAMapView *mapView, id <MAOverlay>overlay);
typedef void (^MapSelectViewHandler)(MAMapView * mapView, MAAnnotationView * view, BOOL didSelect);

typedef void (^MapDidUpdateUserHandler)(MAMapView *mapView, MAUserLocation *userLocation, BOOL updatingLocation, NSError *error);
typedef void (^MapLocationHandler)(CLLocation *location, AMapLocationReGeocode *regeocode, AMapLocationManager *manager, NSError *error);
typedef void (^MapReGeocodeSearchHandler)(AMapReGeocodeSearchRequest *request, AMapReGeocodeSearchResponse *response, NSError *error);
typedef void (^MapGeocodeSearchHandler)(AMapGeocodeSearchRequest *request,  AMapGeocodeSearchResponse *response, NSError *error);
typedef void (^MapPOISearchHandler)(AMapPOISearchBaseRequest *request, AMapPOISearchResponse *response, NSError *error);
typedef void (^MapInputTipsHandler)(AMapInputTipsSearchRequest *request, AMapInputTipsSearchResponse *response, NSError *error);

typedef void (^MapRouteHandler)(AMapRouteSearchBaseRequest *request, AMapRouteSearchResponse *response, NSError *error);
/// 地理围栏
typedef void (^MapGeoFenceHandler)(AMapGeoFenceManager *manager, NSArray <AMapGeoFenceRegion *> *regions, NSString *customID, NSError *error);

@class MapLocationInfoModel;
@interface BNMapManager : NSObject<MAMapViewDelegate, AMapSearchDelegate, AMapLocationManagerDelegate, AMapGeoFenceManagerDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) AMapSearchAPI *searchAPI;
@property (nonatomic, strong) AMapGeoFenceManager *geoFenceManager;

@property (nonatomic, assign) CLLocationCoordinate2D coordinateStart;
@property (nonatomic, assign) CLLocationCoordinate2D coordinateEnd;

@property (nonatomic, strong) MAAnnotationView *userLocationView;
@property (nonatomic, strong) UIButton *locaBtn;

@property (nonatomic, copy) ViewForAnnotationHandler viewForAnnotationHandler;
@property (nonatomic, copy) RendererForOverlay RendererForOverlayHandler;
@property (nonatomic, copy) MapSelectViewHandler selectHandler;


/**mapView: didUpdateUserLocation: updatingLocation:*/
@property (nonatomic, copy) MapDidUpdateUserHandler didUpdateUserHandler;

/** amapLocationManager:didUpdateLocation: reGeocode:*/
@property (nonatomic, copy) MapLocationHandler locationHandler;
@property (nonatomic, copy) MapReGeocodeSearchHandler reGeocodeSearchHandler;
@property (nonatomic, copy) MapGeocodeSearchHandler geocodeSearchHandler;
@property (nonatomic, copy) MapPOISearchHandler POISearchHandler;
@property (nonatomic, copy) MapInputTipsHandler tipsHandler;
@property (nonatomic, copy) MapRouteHandler routeHandler;
@property (nonatomic, copy) MapGeoFenceHandler geoFenceHandler;

@property (nonatomic, strong) NSDictionary * annViewDict;//起点终点信息

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
- (void)aroundSearchCoordinate:(CLLocationCoordinate2D)coordinate keywords:(NSString *)keywords pageIndex:(NSInteger)pageIndex handler:(MapPOISearchHandler)handler;

/**
 逆地理编码请求
 */
- (void)reGeocodeSearchWithRequest:(AMapReGeocodeSearchRequest *)request handler:(MapReGeocodeSearchHandler)handler;

/**
 地理编码请求
 */
- (void)geocodeSearchWithAddress:(NSString *)address city:(NSString *)city handler:(MapGeocodeSearchHandler)handler;

/**
 关键字搜索
 
 @param keywords 搜索关键字 必传参数
 @param city 搜索城市
 @param page 搜索页数
 */
- (void)keywordsSearchWithKeywords:(NSString *)keywords city:(NSString *)city page:(NSInteger)page coordinate:(CLLocationCoordinate2D )coordinate handler:(MapPOISearchHandler)handler;
/**
 提示搜索
 */
- (void)tipsSearchWithKeywords:(NSString *)key city:(NSString *)city handler:(MapInputTipsHandler)handler;

/**
 路径搜索
 */
- (void)routeSearchStartPoint:(CLLocationCoordinate2D)startPoint endPoint:(CLLocationCoordinate2D)endPoint strategy:(NSInteger)strategy type:(NSString *)type handler:(MapRouteHandler)handler;

- (void)geoFenceAddCircleRegionWithCenter:(CLLocationCoordinate2D)center radius:(CLLocationDistance)radius customID:(NSString *)customID handler:(MapGeoFenceHandler)handler;

- (void)geoFenceAddPolygonRegionWithCoordinates:(CLLocationCoordinate2D *)coordinates count:(NSInteger)count customID:(NSString *)customID handler:(MapGeoFenceHandler)handler;

- (void)geoFenceAddKeywordPOIRegionForMonitoringWithKeyword:(NSString *)keyword POIType:(NSString *)type city:(NSString *)city size:(NSInteger)size customID:(NSString *)customID handler:(MapGeoFenceHandler)handler;

- (void)geoFenceAddAroundPOIRegionForMonitoringWithLocationPoint:(CLLocationCoordinate2D)locationPoint aroundRadius:(NSInteger)aroundRadius keyword:(NSString *)keyword POIType:(NSString *)type size:(NSInteger)size customID:(NSString *)customID handler:(MapGeoFenceHandler)handler;

- (void)geoFenceAddDistrictRegionForMonitoringWithDistrictName:(NSString *)districtName customID:(NSString *)customID handler:(MapGeoFenceHandler)handler;

/**
 两点之间直线/投影距离
 
 @param type 0返回米.1返回公里
 @return 返回值
 */
+ (NSString *)distanceWithStart:(CLLocationCoordinate2D )startPoint end:(CLLocationCoordinate2D )endPoint type:(NSString *)type mapView:(MAMapView *)mapView;

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
