//
//  NNMapManager.m
//  VehicleBonus
//
//  Created by Bin Shang on 2019/4/2.
//  Copyright © 2019 Xi'an iRain IOT Technology Service CO., Ltd. . All rights reserved.
//

#import "NNMapManager.h"

NSString * NSStringFromCoordinate(CLLocationCoordinate2D coordinate) {
    NSString *string = [NSString stringWithFormat:@"%.8f,%.8f",coordinate.longitude, coordinate.latitude];
    return string;
}

CLLocationCoordinate2D Coordinate2DFromString(NSString * coordinateInfo) {
    assert([coordinateInfo containsString:@","]);
    coordinateInfo = [coordinateInfo stringByReplacingOccurrencesOfString:@"{" withString:@""];
    coordinateInfo = [coordinateInfo stringByReplacingOccurrencesOfString:@"}" withString:@""];
    
    NSArray * list = [coordinateInfo componentsSeparatedByString:@","];
    
    BOOL isDefaultFormat = fabs([list.firstObject doubleValue]) <= 90.00;
    CGFloat latitude = isDefaultFormat ? [list.firstObject doubleValue] : [list.lastObject doubleValue];
    CGFloat longitude = isDefaultFormat ? [list.lastObject doubleValue] : [list.firstObject doubleValue];
    //
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    return coordinate;
}

CLLocationCoordinate2D Coordinate2DFromObj(id obj) {
    if ([obj isKindOfClass: NSString.class]) {
        return Coordinate2DFromString(obj);
    }
    if ([obj isKindOfClass: NSValue.class]) {
        return ((NSValue *)obj).MACoordinateValue;
    }
    else if ([obj isKindOfClass: MAUserLocation.class]) {
        return ((MAUserLocation *)obj).location.coordinate;
    }
    //MAAnnotationView
    return ((MAAnnotationView *)obj).annotation.coordinate;
}

NSString * NSStringFromAMapGeoPoint(AMapGeoPoint *point) {
    NSString *string = [NSString stringWithFormat:@"%.8f,%.8f", point.longitude, point.latitude];
    return string;
}

AMapGeoPoint * AMapGeoPointFromString(NSString *coordinateInfo) {
    assert([coordinateInfo containsString:@","]);
    coordinateInfo = [coordinateInfo stringByReplacingOccurrencesOfString:@"{" withString:@""];
    coordinateInfo = [coordinateInfo stringByReplacingOccurrencesOfString:@"}" withString:@""];
    
    NSArray * list = [coordinateInfo componentsSeparatedByString:@","];
    CGFloat latitude = [list.firstObject floatValue] > 0.0 ? [list.firstObject floatValue] : 0.0;
    CGFloat longitude = [list.lastObject floatValue] > 0.0 ? [list.lastObject floatValue] : 0.0;
    
    AMapGeoPoint * point = AMapGeoPointFromCoordinate(CLLocationCoordinate2DMake(latitude, longitude));
    return point;
}

AMapGeoPoint * AMapGeoPointFromCoordinate(CLLocationCoordinate2D coordinate){
    AMapGeoPoint * point = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    return point;
}

NSString * NSStringFromReGeocode(AMapLocationReGeocode *regeocode) {
    NSString * string = [NSString stringWithFormat:@"%@%@%@",regeocode.district, regeocode.street, regeocode.POIName];
    return string;
}

NSString * NSStringFromPlacemark(CLPlacemark *placemark) {
    NSString * string = [NSString stringWithFormat:@"{%@,%@,%@}",placemark.name,placemark.subLocality,placemark.administrativeArea];
    return string;
}

NSData * NSDataFromCoordinate(CLLocationCoordinate2D obj){
    return [NSData dataWithBytes:&obj length:sizeof(obj)];
}

CLLocationCoordinate2D Coordinate2DFromNSData(NSData * data){
    CLLocationCoordinate2D coordinate;
    [data getBytes:&coordinate length:sizeof(coordinate)];
    return coordinate;
}

NSValue * NSValueFromCoordinate(CLLocationCoordinate2D obj){
//    NSValue *value = [NSValue valueWithBytes:&obj objCType:@encode(CLLocationCoordinate2D)];
    NSValue *value = [NSValue valueWithBytes:&obj objCType:@encode(typeof(obj))];
    return value;
}
// 百度地图经纬度 -> 高德地图经纬度
CLLocationCoordinate2D GaoDeCoordinate2DFromBaiDu(CLLocationCoordinate2D coordinate){
    return CLLocationCoordinate2DMake(coordinate.latitude - 0.006, coordinate.longitude - 0.0065);
}
// 高德地图经纬度 -> 百度地图经纬度
CLLocationCoordinate2D BaiDuCoordinate2DFromGaoDe(CLLocationCoordinate2D coordinate){
    return CLLocationCoordinate2DMake(coordinate.latitude + 0.006, coordinate.longitude + 0.0065);
}

NSString *DistanceInfoFromMeter(NSInteger distance) {
    NSString *result = @"0.0m";
    if (distance < 1000) {
        result = [NSString stringWithFormat:@" %@%@", @(distance), @"m"];
    } else {
        result = [NSString stringWithFormat:@" %@%@", @(distance/1000), @"km"];
    }
//    DDLog(@"距离_%@_", result);
    return result;
}

NSString *DistanceInfoFromAMapRoute(AMapRoute *route) {
    return DistanceInfoFromMeter(route.paths.firstObject.distance);
}

CLLocationDistance DistanceFromTwoPoint(CLLocationCoordinate2D a, CLLocationCoordinate2D b) {
    MAMapPoint start = MAMapPointForCoordinate(a);
    MAMapPoint end = MAMapPointForCoordinate(b);
    
    CLLocationDistance distance = MAMetersBetweenMapPoints(start, end);
    return distance;
}

NSString * DistanceInfoFromTwoPoint(CLLocationCoordinate2D a, CLLocationCoordinate2D b) {
    if (!CLLocationCoordinate2DIsValid(a) || !CLLocationCoordinate2DIsValid(b)) {
        return @"--";
    }
    CLLocationDistance distance = DistanceFromTwoPoint(a, b);
    return DistanceInfoFromMeter(distance);
}

CLLocationDistance DistanceFromMapCenterAndMaxEdg(MAMapView *mapView) {
    CGPoint point = CGPointMake(0, CGRectGetHeight(mapView.bounds)*0.5);
    if (CGRectGetWidth(mapView.bounds) > CGRectGetHeight(mapView.bounds))  {
        point = CGPointMake(CGRectGetWidth(mapView.bounds)*0.5, 0);
    }
    
    CLLocationCoordinate2D coordinate = [mapView convertPoint:point toCoordinateFromView:mapView.superview];
    CLLocationCoordinate2D coordinate1 = mapView.centerCoordinate;
    return DistanceFromTwoPoint(coordinate, coordinate1);
}

NSString * DistanceInfoFromMapCenterAndMaxEdgDes(MAMapView *mapView) {
    CGPoint point = CGPointMake(0, CGRectGetHeight(mapView.bounds)*0.5);
    if (CGRectGetWidth(mapView.bounds) > CGRectGetHeight(mapView.bounds))  {
        point = CGPointMake(CGRectGetWidth(mapView.bounds)*0.5, 0);
    }
    
    CLLocationCoordinate2D coordinate = [mapView convertPoint:point toCoordinateFromView:mapView.superview];
    CLLocationCoordinate2D coordinate1 = mapView.centerCoordinate;
    return DistanceInfoFromTwoPoint(coordinate, coordinate1);
}

CGPoint *MapPointsForParam(CLLocationCoordinate2D *coords, NSUInteger count, MAMapView *mapView){
    if (coords == NULL || count <= 1){
        return NULL;
    }
    
    /* 申请屏幕坐标存储空间. */
    CGPoint *points = (CGPoint *)malloc(count * sizeof(CGPoint));
    /* 经纬度转换为屏幕坐标. */
    for (int i = 0; i < count; i++){
        points[i] = [mapView convertCoordinate:coords[i] toPointToView:mapView];
    }
    return points;
}

CGMutablePathRef MapPathForParam(CGPoint *points, NSUInteger count){
    if (points == NULL || count <= 1){
        return NULL;
    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddLines(path, NULL, points, count);
    return path;
}

//路线解析
NSArray<MAPolyline *> *MapPolylinesForPath(AMapPath *path){
    if (path == nil || path.steps.count == 0) return nil;
    NSMutableArray *polylines = [NSMutableArray array];
    [path.steps enumerateObjectsUsingBlock:^(AMapStep *step, NSUInteger idx, BOOL *stop) {
        NSUInteger count = 0;
        CLLocationCoordinate2D *coordinates = [CommonUtility coordinatesForString:step.polyline
                                                                  coordinateCount:&count
                                                                       parseToken:@";"];
        
        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:count];
        //          MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:count];
        
        [polylines addObject:polyline];
        (void)(free(coordinates)), coordinates = NULL;
    }];
    return polylines;
}

//CLLocationCoordinate2D *MapCoordinatesForParam(NSArray<NSString *> *stepCoords){
//    CLLocationCoordinate2D *coords = (CLLocationCoordinate2D *)malloc(stepCoords.count * sizeof(CLLocationCoordinate2D));
//    for (NSInteger i = 0; i < stepCoords.count; i++) {
//        CLLocationCoordinate2D coordinate = Coordinate2DFromParam(stepCoords[i], false);
//        coords[i] = coordinate;
//        
//    }
//    return coords;
//}

//CLLocationCoordinate2D *MapCoordinatesForParam(NSArray<AMapStep *> *steps){
//    __block NSMutableArray * marr = [NSMutableArray arrayWithCapacity:0];
//    for (NSInteger i = 0; i < steps.count; i++) {
//        AMapStep * step = steps[i];
//        NSArray * polylineCoords = [step.polyline componentsSeparatedByString:@";"];
//        DDLog(@"%@_%@_%@",@(i), @(polylineCoords.count),polylineCoords);
//
//        for (NSInteger j = 0; j < polylineCoords.count; j++) {
//            NSString * coordinateInfo = polylineCoords[j];
//            [marr addObject:coordinateInfo];
//        }
//    }
//
//    CLLocationCoordinate2D *coords = (CLLocationCoordinate2D *)malloc(marr.count * sizeof(CLLocationCoordinate2D));
//    for (NSInteger i = 0; i < marr.count; i++) {
//        CLLocationCoordinate2D coordinate = Coordinate2DFromParam(marr[i], false);
//        coords[i] = coordinate;
//
//    }
//    return coords;
//}

@interface NNMapManager ()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@property (nonatomic, assign) BOOL isSearch;

@property (nonatomic, assign) CLLocationCoordinate2D userCoordinate;

@property (nonatomic, strong) AMapGeocodeSearchRequest *geocodeRequest;
//@property (nonatomic, strong) AMapPOIAroundSearchRequest *poiAroundRequest;
//@property (nonatomic, strong) AMapPOIKeywordsSearchRequest *poiKeywordsRequest;
//@property (nonatomic, strong) AMapInputTipsSearchRequest *inputTipsRequest;
//@property (nonatomic, strong) AMapDrivingRouteSearchRequest *drivingRequest;

@property (nonatomic, strong) MapLocationInfoModel *locationModel;
@property (nonatomic, strong) MANaviRoute *naviRoute;

@end

@implementation NNMapManager

+ (instancetype)shared{
    static NNMapManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[NNMapManager alloc]init];
    });
    return _instance;
}

+(MAMapView *)createDefaultMapView{
    MAMapView *mapView = [[MAMapView alloc] initWithFrame:CGRectZero];
    
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapView.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    mapView.distanceFilter = kCLLocationAccuracyKilometer;
//    mapView.headingFilter  = 90;
//    mapView.zoomLevel = 15;
    //自定义定位经度圈样式
    mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
    mapView.userTrackingMode = MAUserTrackingModeFollow;
    mapView.showsCompass = YES;
    [mapView setCompassImage:[UIImage imageNamed:@"map_compass"]];
    
    //后台定位
    mapView.pausesLocationUpdatesAutomatically = NO;
    mapView.allowsBackgroundLocationUpdates = NO;//iOS9以上系统必须配置
    mapView.showsUserLocation = YES;
    
    return mapView;
}

+(UIButton *)createDefaultLocaBtn{
    UIButton * view = [UIButton buttonWithType:UIButtonTypeCustom];
    view.frame = CGRectMake(0, 0, 40, 40);
    [view setBackgroundImage:[UIImage imageNamed:@"icon_location"] forState:UIControlStateNormal];
    view.adjustsImageWhenHighlighted = false;
    return view;
}

+(AMapLocationManager *)createDefaultLocationManager {
    AMapLocationManager * locationManager = [[AMapLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locationManager.locationTimeout = 2;
    locationManager.reGeocodeTimeout = 2;
        
        //iOS 9（不包含iOS 9） 之前设置允许后台定位参数，保持不会被系统挂起
    locationManager.pausesLocationUpdatesAutomatically = NO;
    
    if (@available(iOS 19.0, *)) {
        locationManager.allowsBackgroundLocationUpdates = NO;
    }
    locationManager.locatingWithReGeocode = YES;//返回地理信息
    return locationManager;
}

/**
 4种大头针样式,当前位置,普通大头针,起点,终点
 */
-(NSDictionary *)annViewDict{
    if (!_annViewDict) {
        _annViewDict = @{
                         kAnnoTitleUser:   @"map_userLocation_default",
                         kAnnoTitleDefault:   @"map_annotation_default_green",
                         kAnnoTitleStart:   @"map_annotation_begin_green",
                         kAnnoTitleEnd:   @"map_annotation_end_orange",
//                         kAnnoTitleMove:   @"map_userLocation_arrow",
                         kAnnoTitleMove:   @"map_car_yellow",
                         kAnnoTitleRoute:   @"map_trackingPoints_blue",
                         };
    }
    return _annViewDict;
}

// 开始定位
- (void)startSerialLocationWithReGeocode:(BOOL)reGeocode {
    if (![self hasAccessRightOfLocation]) {
        return ;
    }
    //持续定位是否返回逆地理信息，默认NO。
    [self.locationManager setLocatingWithReGeocode:reGeocode];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    //开始持续定位
    [self.locationManager startUpdatingLocation];
}

// 停止定位
- (void)stopSerialLocation {
    [self.locationManager stopUpdatingLocation];
    
}

// 开始单次定位
- (void)startSingleLocationWithReGeocode:(BOOL)reGeocode handler:(MapLocationHandler)handler {
    self.locationHandler = handler;
    
    if (![self hasAccessRightOfLocation]) {
        return ;
    }
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.locationTimeout = 10;
    self.locationManager.reGeocodeTimeout = 10;
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    @weakify(self);
    BOOL result = [self.locationManager requestLocationWithReGeocode:reGeocode completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        @strongify(self);
        if (self.locationHandler) self.locationHandler(location, regeocode, nil, error);
        
        if (error){
            DDLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            if (error.code == AMapLocationErrorLocateFailed){
                return;
            }
        }
        
        if (regeocode){
            DDLog(@"reGeocode:%@", regeocode);
        }
    }];
}

#pragma mark - -othersFuntions

/**
 添加针

 @param type 0,起点l;1,终点,2其他
 */
- (MAPointAnnotation *)addAnnoPoint:(CLLocationCoordinate2D)coordinate title:(NSString *)title type:(NSInteger)type mapView:(MAMapView *)mapView{
    
    MAPointAnnotation * pointAnno = [[MAPointAnnotation alloc] init];
    pointAnno.title      = title;
    
    if ([NNMapManager annoWithTitle:title mapView:mapView]) {
        pointAnno = [NNMapManager annoWithTitle:title mapView:mapView];
        
    }
    else{
        [mapView addAnnotation:pointAnno];
    }
    pointAnno.coordinate = coordinate;
    pointAnno.subtitle  = NSStringFromCoordinate(coordinate);
    [mapView selectAnnotation:pointAnno animated:false];
    
    switch (type) {
        case 0:
            self.coordinateStart = pointAnno.coordinate;

            break;
        case 1:
        {
            self.coordinateEnd = pointAnno.coordinate;
            if (CLLocationCoordinate2DIsValid(self.coordinateStart) && CLLocationCoordinate2DIsValid(self.coordinateEnd)) {
                //            [self handleSearchRoutePlanningDrive];
                
            } else {
                //            DDLog(@"起止点:%@->%@",NSStringFromCoordinate(self.coordinateStart),NSStringFromCoordinate(self.coordinateEnd)];
                
            }
        }
            break;
  
        default:
            
            break;
    }
    return pointAnno;
}


#pragma mark - -others
- (void)saveLocation:(CLLocation *)newLocation {
    NSString * locationInfo = NSStringFromCoordinate(newLocation.coordinate);
    [NSUserDefaults.standardUserDefaults setObject:locationInfo forKey:kUserCoordinateInfo];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (BOOL)hasAccessRightOfLocation{
    if (CLLocationManager.locationServicesEnabled && (CLLocationManager.authorizationStatus == kCLAuthorizationStatusAuthorizedAlways || CLLocationManager.authorizationStatus == kCLAuthorizationStatusNotDetermined || CLLocationManager.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse)) {
        return YES;
    } else {
        DDLog(@"请打开定位权限!");
//        [UIAlertController showAlert:@"请打开定位权限!" message:nil alignment:NSTextAlignmentCenter actionTitles:@[@"知道了"] handler:^(UIAlertController * alertVC, UIAlertAction * action) {
//
//        }];
        return NO;
    }
}

- (BOOL)hasLocation {
    return self.userCoordinate.latitude != 0.0 && self.userCoordinate.latitude != 0.0;
}

///逆地理编码请求
- (void)reGeocodeSearchWithBlock:(void(^)(AMapReGeocodeSearchRequest *request))block handler:(MapReGeocodeSearchHandler)handler{
    self.reGeocodeSearchHandler = handler;
    //
    AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc]init];
    if (block) block(request);
    [self.searchAPI AMapReGoecodeSearch:request];
}

///地理编码请求
- (void)geocodeSearchWithBlock:(void(^)(AMapGeocodeSearchRequest *request))block handler:(MapGeocodeSearchHandler)handler{
    self.geocodeSearchHandler = handler;
    //
    AMapGeocodeSearchRequest *request = [[AMapGeocodeSearchRequest alloc]init];
    if (block) block(request);
    [self.searchAPI AMapGeocodeSearch:request];
}

#pragma mark - 周边搜索

- (void)aroundSearchCoordinate:(CLLocationCoordinate2D)coordinate block:(void(^)(AMapPOIAroundSearchRequest *request))block handler:(MapPOISearchHandler)handler {
    self.POISearchHandler = handler;
    //
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc]init];
    
    request.location          = AMapGeoPointFromCoordinate(coordinate);
//    request.keywords          = keywords;
    /* 按照距离排序. */
    request.sortrule          = 0;
    request.requireExtension  = YES;
    request.page              = 30;
    if (block) block(request);
    [self.searchAPI AMapPOIAroundSearch:request];
}

#pragma mark - 关键字搜索
- (void)keywordsSearchWithKeywords:(NSString *)keywords
                              city:(NSString *)city
                              page:(NSInteger)page
                             block:(void(^)(AMapPOIKeywordsSearchRequest *request))block
                           handler:(MapPOISearchHandler)handler{
    self.POISearchHandler = handler;

    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc]init];
    request.keywords            = keywords;
    request.city                = city;
    request.cityLimit           = YES;
    request.requireExtension    = YES;
//    request.types               = @"高等院校";
//    request.requireSubPOIs      = YES;
    request.page                = page;
    request.offset              = 30;
    if (block) block(request);
    [self.searchAPI AMapPOIKeywordsSearch:request];
}

#pragma mark - 提示搜索
- (void)tipsSearchWithKeywords:(NSString *)keywords
                              city:(NSString *)city
                             block:(void(^)(AMapInputTipsSearchRequest *request))block
                           handler:(MapInputTipsHandler)handler{
    self.tipsHandler = handler;
    
    AMapInputTipsSearchRequest *request = [[AMapInputTipsSearchRequest alloc]init];
    request.keywords            = keywords;
    request.city                = city;
    request.cityLimit           = YES;
    if (block) block(request);
    [self.searchAPI AMapInputTipsSearch:request];
}

#pragma mark -驾车路线
- (void)searchRoutePlanningDriveStartPoint:(CLLocationCoordinate2D)startPoint
                                  endPoint:(CLLocationCoordinate2D)endPoint
                                  strategy:(NSInteger)strategy
                                   handler:(MapRouteHandler)handler{
    self.routeHandler = handler;
        
    AMapDrivingRouteSearchRequest * request = [[AMapDrivingRouteSearchRequest alloc]init];
    request.origin = AMapGeoPointFromCoordinate(startPoint);
    request.destination = AMapGeoPointFromCoordinate(endPoint);
    request.requireExtension = YES;
    request.strategy = strategy;
    [self.searchAPI AMapDrivingRouteSearch:request];
}
#pragma mark -步行路线
- (void)searchRoutePlanningWalkStartPoint:(CLLocationCoordinate2D)startPoint
                                 endPoint:(CLLocationCoordinate2D)endPoint
                                  handler:(MapRouteHandler)handler{
    self.routeHandler = handler;
        
    AMapWalkingRouteSearchRequest * request = [[AMapWalkingRouteSearchRequest alloc]init];
    request.origin = AMapGeoPointFromCoordinate(startPoint);
    request.destination = AMapGeoPointFromCoordinate(endPoint);
    [self.searchAPI AMapWalkingRouteSearch:request];
}
#pragma mark -公交路线
- (void)searchRoutePlanningBusStartPoint:(CLLocationCoordinate2D)startPoint
                                endPoint:(CLLocationCoordinate2D)endPoint
                                strategy:(NSInteger)strategy
                                    city:(NSString *)city
                                 handler:(MapRouteHandler)handler{
    self.routeHandler = handler;
        
    AMapTransitRouteSearchRequest * request = [[AMapTransitRouteSearchRequest alloc]init];
    request.origin = AMapGeoPointFromCoordinate(startPoint);
    request.destination = AMapGeoPointFromCoordinate(endPoint);
    request.requireExtension = true;
    request.city = city;
    [self.searchAPI AMapTransitRouteSearch:request];
}
#pragma mark -骑行路线
- (void)searchRoutePlanningRidingStartPoint:(CLLocationCoordinate2D)startPoint
                                   endPoint:(CLLocationCoordinate2D)endPoint
                                   strategy:(NSInteger)strategy
                                       city:(NSString *)city
                                    handler:(MapRouteHandler)handler{
    self.routeHandler = handler;
        
    AMapRidingRouteSearchRequest * request = [[AMapRidingRouteSearchRequest alloc]init];
    request.origin = AMapGeoPointFromCoordinate(startPoint);
    request.destination = AMapGeoPointFromCoordinate(endPoint);
    [self.searchAPI AMapRidingRouteSearch:request];
}
#pragma mark -货车路线
- (void)searchRoutePlanningTruckStartPoint:(CLLocationCoordinate2D)startPoint
                                  endPoint:(CLLocationCoordinate2D)endPoint
                                  strategy:(NSInteger)strategy
                                   handler:(MapRouteHandler)handler{
    self.routeHandler = handler;
        
    AMapTruckRouteSearchRequest * request = [[AMapTruckRouteSearchRequest alloc]init];
    request.origin = AMapGeoPointFromCoordinate(startPoint);
    request.destination = AMapGeoPointFromCoordinate(endPoint);
    [self.searchAPI AMapTruckRouteSearch:request];
}

- (void)routePlanningDriveStartPoint:(CLLocationCoordinate2D)startPoint
                            endPoint:(CLLocationCoordinate2D)endPoint
                            strategy:(NSInteger)strategy
                             mapView:(MAMapView *)mapView
                             handler:(MapRouteHandler)handler{

    if (startPoint.latitude == 0 || endPoint.latitude == 0) {
        DDLog(@"起止点经纬度错误");
        return;
    }
    
    [self searchRoutePlanningDriveStartPoint:startPoint
                                    endPoint:endPoint
                                    strategy:0
                                     handler:^(AMapRouteSearchBaseRequest * _Nonnull request, AMapRouteSearchResponse * _Nonnull response, NSError * _Nullable error) {
        if (handler) {
            handler(request, response, error);
        }
        if (error) {
            DDLog(@"错误:%@", error.domain);
            return;
        }
        [self presentRouteStartPoint:startPoint
                            endPoint:endPoint
                            response:response
                             mapView:mapView
                                type:MANaviAnnotationTypeDrive];
    }];
}


#pragma mark - 地理围栏

/**
 * @brief 添加一个圆形围栏
 * @param center 围栏的中心点经纬度坐标
 * @param radius 围栏的半径，单位：米，要求大于0
 * @param customID 用户自定义ID，可选，SDK原值返回
 */
- (void)geoFenceAddCircleRegionWithCenter:(CLLocationCoordinate2D)center
                                   radius:(CLLocationDistance)radius
                                 customID:(NSString *)customID
                                  handler:(MapGeoFenceHandler)handler{
    self.geoFenceHandler = handler;
    
    [self.geoFenceManager addCircleRegionForMonitoringWithCenter:center
                                                          radius:radius
                                                        customID:customID];
}

/**
 * @brief 根据经纬度坐标数据添加一个闭合的多边形围栏，点与点之间按顺序尾部相连, 第一个点与最后一个点相连
 * @param coordinates 经纬度坐标点数据,coordinates对应的内存会拷贝,调用者负责该内存的释放
 * @param count 经纬度坐标点的个数，不可小于3个
 * @param customID 用户自定义ID，可选，SDK原值返回
 */
- (void)geoFenceAddPolygonRegionWithCoordinates:(CLLocationCoordinate2D *)coordinates
                                          count:(NSInteger)count
                                       customID:(NSString *)customID
                                        handler:(MapGeoFenceHandler)handler{
    self.geoFenceHandler = handler;
    
    [self.geoFenceManager addPolygonRegionForMonitoringWithCoordinates:coordinates
                                                                 count:count
                                                              customID:customID];
}

/**
 * @brief 根据要查询的关键字，类型，城市等信息，添加一个或者多个POI地理围栏
 * @param keyword 要查询的关键字，多个关键字用“|”分割，必填，keyword和type两者至少必选其一
 * @param type 要查询的POI类型，多个类型用“|”分割，必填，keyword和type两者至少必选其一，具体分类编码和规则详见： http://lbs.amap.com/api/webservice/guide/api/search/#text
 * @param city 要查询的城市
 * @param size 要查询的数据的条数，(0,25]，传入<=0的值为10，传入大于25的值为25，默认10
 * @param customID 用户自定义ID，可选，SDK原值返回
 */
- (void)geoFenceAddKeywordPOIRegionForMonitoringWithKeyword:(NSString *)keyword
                                                    POIType:(NSString *)type
                                                       city:(NSString *)city
                                                       size:(NSInteger)size
                                                   customID:(NSString *)customID handler:(MapGeoFenceHandler)handler{
    self.geoFenceHandler = handler;
    
    [self.geoFenceManager addKeywordPOIRegionForMonitoringWithKeyword:keyword
                                                              POIType:type
                                                                 city:city
                                                                 size:size
                                                             customID:customID];
}

/**
 * @brief 根据要查询的点的经纬度，搜索半径等信息，添加一个或者多个POI围栏
 * @param locationPoint 点的经纬度坐标，必填
 * @param aroundRadius 查询半径，单位：米，(0,50000]，超出范围取3000，默认3000
 * @param keyword 要查询的关键字，多个关键字用“|”分割，可选
 * @param type 要查询的POI类型，多个类型用“|”分割，可选
 * @param size 要查询的数据的条数，(0,25]，传入<=0的值为10，传入大于25的值为25，默认10
 * @param customID 用户自定义ID，可选，SDK原值返回
 */
- (void)geoFenceAddAroundPOIRegionForMonitoringWithLocationPoint:(CLLocationCoordinate2D)locationPoint
                                                    aroundRadius:(NSInteger)aroundRadius
                                                         keyword:(NSString *)keyword
                                                         POIType:(NSString *)type
                                                            size:(NSInteger)size
                                                        customID:(NSString *)customID
                                                         handler:(MapGeoFenceHandler)handler{
    self.geoFenceHandler = handler;
    
    [self.geoFenceManager addAroundPOIRegionForMonitoringWithLocationPoint:locationPoint
                                                              aroundRadius:aroundRadius
                                                                   keyword:keyword
                                                                   POIType:type
                                                                      size:size
                                                                  customID:customID];
}


/**
 * @brief 根据要查询的行政区域关键字，添加一个或者多个行政区域围栏
 * @param districtName 行政区域关键字，必填，只支持单个关键词语：行政区名称、citycode、adcode，规则详见： http://lbs.amap.com/api/webservice/guide/api/district/#district
 * @param customID 用户自定义ID，可选，SDK原值返回
 */
- (void)geoFenceAddDistrictRegionForMonitoringWithDistrictName:(NSString *)districtName customID:(NSString *)customID handler:(MapGeoFenceHandler)handler{
    self.geoFenceHandler = handler;
    
    [self.geoFenceManager addDistrictRegionForMonitoringWithDistrictName:districtName customID:customID];
}

#pragma mark -AMapSearchDelegate

- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response{
    NSAssert(response.geocodes, @"response.geocodes = nil");
    if (self.geocodeSearchHandler) {
        self.geocodeSearchHandler(request, response, nil);
    }
    
    if (self.locationModel.geocodeResponse) {
        self.locationModel.geocodeResponse = response;
    }
    
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    NSAssert(response.regeocode, @"response.regeocode = nil");
    if (self.reGeocodeSearchHandler) {
        self.reGeocodeSearchHandler(request, response, nil);
    }
    
    if (self.locationModel.reGeocodeResponse) {
        self.locationModel.reGeocodeResponse = response;
    }
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    NSAssert(response.pois, @"response.pois = nil");
    //    for(AMapPOI *poi in response.pois){
    //        DDLog(@"%@.%@-%@-%@",poi.name,poi.district,poi.businessArea,poi.address);
    //    }
    
    if (self.POISearchHandler) {
        self.POISearchHandler(request,response, nil);
    }
    
    if (self.locationModel.poiSearchResponse) {
        self.locationModel.poiSearchResponse = response;
    }
}

/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response{
    NSAssert(response.tips, @"response.tips = nil");
    if (self.tipsHandler) {
        self.tipsHandler(request,response, nil);
    }
    
    if (self.locationModel.inputTipsResponse) {
        self.locationModel.inputTipsResponse = response;
    }
}

//实现路径搜索的回调函数
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response{
    NSAssert(response.route, @"response.route = nil");
    if (self.routeHandler) {
        self.routeHandler(request, response, nil);
    }
    
    if (self.locationModel.routeResponse) {
        self.locationModel.routeResponse = response;
    }
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    if (error) {
        if (self.geocodeSearchHandler)      self.geocodeSearchHandler(request, nil, error);
        if (self.reGeocodeSearchHandler)    self.reGeocodeSearchHandler(request, nil, error);
        if (self.POISearchHandler)          self.POISearchHandler(request,nil, error);
        if (self.tipsHandler)               self.tipsHandler(request,nil, error);
        if (self.routeHandler)              self.routeHandler(request, nil, error);
    }
}


#pragma mark -AMapGeoFenceManagerDelegate

- (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager*)locationManager{
    [locationManager requestAlwaysAuthorization];
}

- (void)amapGeoFenceManager:(AMapGeoFenceManager *)manager didAddRegionForMonitoringFinished:(NSArray <AMapGeoFenceRegion *> *)regions customID:(NSString *)customID error:(NSError *)error{
    if (self.geoFenceHandler) {
        self.geoFenceHandler(manager, regions, customID, error);
    }
}

- (void)amapGeoFenceManager:(AMapGeoFenceManager *)manager didGeoFencesStatusChangedForRegion:(AMapGeoFenceRegion *)region customID:(NSString *)customID error:(NSError *)error{
    if (self.geoFenceHandler) {
        self.geoFenceHandler(manager, @[region], customID, nil);
    }
}

#pragma mark - -other funtions

/* 获取指定title的针 */
+ (MAPointAnnotation *)annoWithTitle:(NSString *)title mapView:(MAMapView *)mapView{
    DDLog(@"_%@_", mapView.annotations);
    if (mapView.annotations) {
        for (id obj in mapView.annotations) {
            if ([obj isKindOfClass:[MAPointAnnotation class]]) {
                
                MAPointAnnotation * anno = (MAPointAnnotation *)obj;
                if ([anno.title isEqualToString:title]) {
                    return anno;
                }
            }
        }
    }
    return nil;
}

/* 展示当前路线方案. */

//在地图上显示当前选择的路径
- (void)presentRouteStartPoint:(CLLocationCoordinate2D )startPoint
                      endPoint:(CLLocationCoordinate2D )endPoint
                      response:(AMapRouteSearchResponse *)response
                       mapView:(MAMapView *)mapView
                          type:(MANaviAnnotationType)type{
    
    [self.naviRoute removeFromMapView];  //清空地图上已有的路线

    AMapGeoPoint *origin      =  AMapGeoPointFromCoordinate(startPoint); //起点
    AMapGeoPoint *destination =  AMapGeoPointFromCoordinate(endPoint);  //终点
    //根据已经规划的路径，起点，终点，规划类型，是否显示实时路况，生成显示方案
    self.naviRoute = [MANaviRoute naviRouteForPath:response.route.paths[0]
                                      withNaviType:type
                                       showTraffic:false
                                        startPoint:origin
                                          endPoint:destination];
    self.naviRoute.anntationVisible = false;
    self.naviRoute.routeColor = UIColor.systemBlueColor;
    
    [self.naviRoute addToMapView:mapView];  //显示到地图上
//    [self.mapView showOverlays:self.naviRoute.routePolylines edgePadding:UIEdgeInsetsMake(80, 20, 20, 20) animated:true];

//    //缩放地图使其适应polylines的展示
    [mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines]
                        edgePadding:UIEdgeInsetsMake(80, 20, 20, 20)
                           animated:YES];
}


//解析经纬度
+ (CLLocationCoordinate2D *)coordinatesForString:(NSString *)string
                                 coordinateCount:(NSUInteger *)coordinateCount
                                      parseToken:(NSString *)token{
    if (string == nil) return NULL;
    if (token == nil) token = @",";
    
    NSString *str = @"";
    if (![token isEqualToString:@","]){
        str = [string stringByReplacingOccurrencesOfString:token withString:@","];
    }
    else{
        str = [NSString stringWithString:string];
    }
    
    NSArray *components = [str componentsSeparatedByString:@","];
    NSUInteger count = components.count / 2;
    if (coordinateCount != NULL)  *coordinateCount = count;
    
    CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D*)malloc(count * sizeof(CLLocationCoordinate2D));
    for (NSInteger i = 0; i < count; i++){
        coordinates[i].longitude = [[components objectAtIndex:2 * i]     doubleValue];
        coordinates[i].latitude  = [[components objectAtIndex:2 * i + 1] doubleValue];
    }
    return coordinates;
}

+ (NSString *)getAddressInfo:(id)obj isAdjust:(BOOL)isAdjust{
    NSString *addressInfo = @"";
    if ([obj isKindOfClass:[AMapReGeocode class]]) {
        AMapReGeocode * regeocode = (AMapReGeocode *)obj;
        if (!regeocode.addressComponent) return @"";
        
        NSArray * list = @[@"province",@"city",@"district",@"town",@"neighborhood",@"building",@"street",@"streetNumber",];
        for (NSString * obj in list) {
            NSString * value = [regeocode.addressComponent valueForKey:obj];
            if (isAdjust == true) {
                if (value.length > 0) {
                    addressInfo = [addressInfo stringByAppendingFormat:@"%@:%@",obj, value];
                }
                
            } else {
                addressInfo = [addressInfo stringByAppendingFormat:@"%@:%@",obj,value.length > 0 ? value : @"--"];
                
            }
        }
        
    }
    else if ([obj isKindOfClass:[AMapLocationReGeocode class]]) {
        AMapLocationReGeocode *regeocode = (AMapLocationReGeocode *)obj;
        NSArray * list = @[@"province",@"city",@"district",@"street",@"number",];
        for (NSString * obj in list) {
            NSString * value = [regeocode valueForKey:obj];
            if (isAdjust == true) {
                if (value.length > 0) {
                    addressInfo = [addressInfo stringByAppendingFormat:@"%@:%@",obj, value];
                }
                
            } else {
                addressInfo = [addressInfo stringByAppendingFormat:@"%@:%@",obj,value.length > 0 ? value : @"--"];
                
            }
        }
    }
    return addressInfo;
}


#pragma mark - -lazy
-(AMapLocationManager *)locationManager {
    if (!_locationManager) {
//        _locationManager = [[AMapLocationManager alloc] init];
        _locationManager = NNMapManager.createDefaultLocationManager;
        _locationManager.delegate = self;
        
//        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
//        _locationManager.locationTimeout = 2;
//        _locationManager.reGeocodeTimeout = 2;
//
//        //iOS 9（不包含iOS 9） 之前设置允许后台定位参数，保持不会被系统挂起
//        _locationManager.pausesLocationUpdatesAutomatically = NO;
//        if (iOSVer(9)) {
//            _locationManager.allowsBackgroundLocationUpdates = NO;
//
//        }
//        _locationManager.locatingWithReGeocode = YES;//返回地理信息
    }
    return _locationManager;
}

-(AMapSearchAPI *)searchAPI{
    if (!_searchAPI) {
        _searchAPI = [[AMapSearchAPI alloc] init];
        _searchAPI.delegate = self;
    }
    return _searchAPI;
}

//-(AMapGeocodeSearchRequest *)geocodeRequest{
//    if (!_geocodeRequest) {
//        _geocodeRequest = [[AMapGeocodeSearchRequest alloc]init];
//    }
//    return _geocodeRequest;
//}

//-(AMapPOIAroundSearchRequest *)poiAroundRequest{
//    if (!_poiAroundRequest) {
//        _poiAroundRequest = [[AMapPOIAroundSearchRequest alloc] init];
//
//    }
//    return _poiAroundRequest;
//}
//
//-(AMapPOIKeywordsSearchRequest *)poiKeywordsRequest{
//    if (!_poiKeywordsRequest) {
//        _poiKeywordsRequest = [[AMapPOIKeywordsSearchRequest alloc]init];
//    }
//    return _poiKeywordsRequest;
//}
//
//-(AMapInputTipsSearchRequest *)inputTipsRequest{
//    if (!_inputTipsRequest) {
//        _inputTipsRequest = [[AMapInputTipsSearchRequest alloc]init];
//    }
//    return _inputTipsRequest;
//}

//-(AMapDrivingRouteSearchRequest *)drivingRequest{
//    if (!_drivingRequest) {
//        _drivingRequest = [[AMapDrivingRouteSearchRequest alloc]init];
//
//    }
//    return _drivingRequest;
//}

-(AMapGeoFenceManager *)geoFenceManager{
    if (!_geoFenceManager) {
        _geoFenceManager = [[AMapGeoFenceManager alloc]init];
        _geoFenceManager.allowsBackgroundLocationUpdates = true;
        _geoFenceManager.activeAction = AMapGeoFenceActiveActionInside | AMapGeoFenceActiveActionOutside | AMapGeoFenceActiveActionStayed;
        _geoFenceManager.delegate = self;
    }
    return _geoFenceManager;
}


-(MapLocationInfoModel *)locationModel{
    if (!_locationModel) {
        _locationModel = [[MapLocationInfoModel alloc]init];
    }
    return _locationModel;
}

-(AMapTip *)mapTipFromPoi:(AMapPOI *)mapPoi{
    AMapTip * mapTip = [[AMapTip alloc]init];
    mapTip.uid = mapPoi.uid;
    mapTip.name = mapPoi.name;
    mapTip.adcode = mapPoi.adcode;
    mapTip.district = mapPoi.district;
    mapTip.address = mapPoi.address;
    mapTip.location = mapPoi.location;
    mapTip.typecode = mapPoi.typecode;
    
    return mapTip;
}

@end


@implementation MapLocationInfoModel

-(AMapLocationReGeocode *)locationReGeocode{
    if (!_locationReGeocode) {
        _locationReGeocode = [[AMapLocationReGeocode alloc]init];
    }
    return _locationReGeocode;
}

-(AMapReGeocodeSearchResponse *)reGeocodeResponse{
    if (!_reGeocodeResponse) {
        _reGeocodeResponse = [[AMapReGeocodeSearchResponse alloc]init];
    }
    return _reGeocodeResponse;
}

-(AMapGeocodeSearchResponse *)geocodeResponse{
    if (!_geocodeResponse) {
        _geocodeResponse = [[AMapGeocodeSearchResponse alloc]init];
    }
    return _geocodeResponse;
}

-(AMapInputTipsSearchResponse *)inputTipsResponse{
    if (!_inputTipsResponse) {
        _inputTipsResponse = [[AMapInputTipsSearchResponse alloc]init];
    }
    return _inputTipsResponse;
}

-(AMapRouteSearchResponse *)routeResponse{
    if (!_routeResponse) {
        _routeResponse = [[AMapRouteSearchResponse alloc]init];
    }
    return _routeResponse;
}

-(AMapPOISearchResponse *)poiSearchResponse{
    if (!_poiSearchResponse) {
        _poiSearchResponse = [[AMapPOISearchResponse alloc]init];
    }
    return _poiSearchResponse;
}

@end
