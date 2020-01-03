//
//  BNMapView.m
//  VehicleBonus
//
//  Created by Bin Shang on 2019/3/18.
//  Copyright © 2019 Xi'an iRain IOT Technology Service CO., Ltd. . All rights reserved.
//

#import "NNMapContainView.h"
#import "UIPOIAnnotationView.h"
#import "MoveAnnotationView.h"


@interface NNMapContainView ()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@property (nonatomic, assign) BOOL isSearch;

@property (nonatomic, assign) CLLocationCoordinate2D userCoordinate;

@property (nonatomic, strong) AMapGeocodeSearchRequest *GeocodeRequest;

@property (nonatomic, strong) AMapPOIAroundSearchRequest *POIAroundRequest;
@property (nonatomic, strong) AMapPOIKeywordsSearchRequest *POIKeywordsRequest;
@property (nonatomic, strong) AMapInputTipsSearchRequest *InputTipsRequest;

@property (nonatomic, strong) AMapDrivingRouteSearchRequest *DrivingRequest;

@property (nonatomic, strong) MapLocationInfoModel * locationModel;

@end

@implementation NNMapContainView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.mapView];
        [self addSubview:self.locaBtn];
        
    }
    return self;
}


+ (instancetype)shared{
    static NNMapContainView *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[NNMapContainView alloc]initWithFrame:CGRectZero];
    });
    return _instance;
}

#pragma mark - MapViewDelegate

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    if(updatingLocation == true && !self.userLocationView){
        MAAnnotationView *userLocationView = [self.mapView viewForAnnotation:self.mapView.userLocation];
        userLocationView.annotation.coordinate = self.mapView.userLocation.coordinate;

        userLocationView.annotation.title = kAnnoTitleUser;
//        userLocationView.image = [UIImage imageNamed:self.annViewDict[userLocationView.annotation.title]];
        self.userLocationView = userLocationView;

    }
//    DDLog(@"didUpdateUserLocation\n___%@->%@", NSStringFromCoordinate(userLocation.coordinate),userLocation.title);
    if (self.didUpdateUserHandler) self.didUpdateUserHandler(mapView, userLocation, updatingLocation, nil);
    
}

- (void)mapViewRequireLocationAuth:(CLLocationManager *)locationManager{
    [locationManager requestAlwaysAuthorization];
}

- (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager *)locationManager{
    [locationManager requestAlwaysAuthorization];
}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    if (error) {
        DDLog(@"error:%@",error)
        if (self.didUpdateUserHandler) self.didUpdateUserHandler(mapView, nil, nil, error);
        
    }
}

- (void)mapViewDidFailLoadingMap:(MAMapView *)mapView withError:(NSError *)error{
    if (error) {
        DDLog(@"error:%@",error)
        if (self.didUpdateUserHandler) self.didUpdateUserHandler(mapView, nil, nil, error);
        
    }
}

#pragma mark - MAMapView展示元素
// 大头针视图
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
//    if (self.viewForAnnotationHandler && self.viewForAnnotationHandler(mapView, annotation)) {
//        return self.viewForAnnotationHandler(mapView, annotation);
//    }
 
    if ([annotation isKindOfClass: NNPOIAnnotation.class]){
        static NSString *poiIdentifier = @"BNPOIAnnotation";
        NNPOIAnnotation * anno = (NNPOIAnnotation *)annotation;
        UIPOIAnnotationView * annoView = [UIPOIAnnotationView mapView:mapView viewForAnnotation:annotation identifier:poiIdentifier];
  
        annoView.label.text = [NSString stringWithFormat:@"¥%@",@(arc4random()%9)];
        annoView.type = @(anno.index%4);
        return annoView;
    }
    else if ([annotation isKindOfClass: MAUserLocation.class]){
        static NSString *userIdentifier = @"MAUserLocation";
        MAPinAnnotationView * annoView = [MAPinAnnotationView mapView:mapView viewForAnnotation:annotation identifier:userIdentifier];
        NSString * annoTitle = kAnnoTitleUser;
        annoView.image = [UIImage imageNamed:NNMapManager.shared.annViewDict[annoTitle]];
//        annoView.image = UIImageNamed(@"map_userLocation_default");

        return annoView;
    }
    else if ([annotation isKindOfClass: MAPointAnnotation.class]){
        static NSString *pointIdentifier = @"MAPointAnnotation";
        MAAnnotationView * annoView = nil;
        if ([annotation.title isEqualToString:kAnnoTitleMove]) {
            annoView = [MoveAnnotationView mapView:mapView viewForAnnotation:annotation identifier:pointIdentifier];
            annoView.centerOffset = CGPointZero;
        }
        else {
            annoView = [MAAnnotationView mapView:mapView viewForAnnotation:annotation identifier:pointIdentifier];
        }
        NSString * annoTitle = [NNMapManager.shared.annViewDict.allKeys containsObject:annotation.title] ? annotation.title : kAnnoTitleDefault;
        annoView.image = [UIImage imageNamed:NNMapManager.shared.annViewDict[annoTitle]];
        return annoView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    [UIPOIAnnotationView selectAnnotationView:view];
//    DDLog(@"%@", view);
    
    if (self.selectHandler) {
        self.selectHandler(mapView, view, true);
    }
}

- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view{
    [UIPOIAnnotationView selectAnnotationView:view];
//    DDLog(@"%@", view);
    if (self.selectHandler) {
        self.selectHandler(mapView, view, false);
    }
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay{
    // 自定义定位精度对应的MACircleView
    if (overlay == mapView.userLocationAccuracyCircle){
        MACircleRenderer *renderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        
        renderer.lineWidth    = 10.f;
        renderer.strokeColor  = [UIColor lightGrayColor];
        renderer.fillColor    = [UIColor colorWithRed:1 green:0 blue:0 alpha:.3];
        
        //通过颜色隐藏精度圈
        renderer.strokeColor  = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.0];
        renderer.fillColor    = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.0];
        renderer.fillColor    = [UIColor colorWithRed:166.f/255.f green:202.f/255.f blue:237.f/255.f alpha:0.5]; //0x7FA6CAED

        return renderer;
    }
    if ([overlay isKindOfClass:[LineDashPolyline class]]){
        MAPolylineRenderer *renderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        renderer.lineWidth   = 4.f;
        renderer.lineDashType = kMALineDashTypeDot;
        renderer.strokeColor = [UIColor redColor];
        
        return renderer;
    }
    if ([overlay isKindOfClass:[MANaviPolyline class]]){
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineRenderer *renderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];
        
        renderer.lineWidth = 4.f;
        renderer.lineJoinType = kMALineJoinRound;
        renderer.lineCapType = kMALineCapRound;
        
        if (naviPolyline.type == MANaviAnnotationTypeWalking){
            renderer.strokeColor = self.naviRoute.walkingColor;
        }
        else if (naviPolyline.type == MANaviAnnotationTypeRailway){
            renderer.strokeColor = self.naviRoute.railwayColor;
        }
        else {
            renderer.strokeColor = self.naviRoute.routeColor;
        }
        return renderer;
    }
    if ([overlay isKindOfClass:[MAMultiPolyline class]]){
        MAMultiColoredPolylineRenderer * renderer = [[MAMultiColoredPolylineRenderer alloc] initWithMultiPolyline:(MAMultiPolyline *)overlay];

        renderer.lineWidth = 4;
        renderer.strokeColors = [self.naviRoute.multiPolylineColors copy];
        renderer.gradient = YES;

        return renderer;
    }
     //画路线
    if ([overlay isKindOfClass:[MAPolyline class]]){
        //初始化一个路线类型的view
        MAPolylineRenderer *polygonView = [[MAPolylineRenderer alloc] initWithPolyline:(MAPolyline *)overlay];
        //设置线宽颜色等
        polygonView.lineWidth = 4.f;
        polygonView.strokeColor = [UIColor colorWithRed:0.015 green:0.658 blue:0.986 alpha:1.000];
        polygonView.fillColor = [UIColor colorWithRed:0.940 green:0.771 blue:0.143 alpha:0.800];
        polygonView.lineJoinType = kMALineJoinRound;//连接类型
        //返回view，就进行了添加
        return polygonView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate{
    return;
    //    DDLog(@"distance___%@",[BN_Map distanceWithStart:self.coordinateStart endPoint:self.coordinateEnd type:@"0"]);
//    [self addAnnoCoordinate:coordinate title:kMapAddressDefault isStart:false];
    
    MAPointAnnotation * pointAnno = [[MAPointAnnotation alloc] init];
    pointAnno.coordinate = coordinate;
    pointAnno.title = kAnnoTitleDefault;
    pointAnno.subtitle  = NSStringFromCoordinate(coordinate);
    [mapView addAnnotation:pointAnno];
    [mapView selectAnnotation:pointAnno animated:true];

    DDLog(@"annotations_%@_%@",@(mapView.annotations.count),NSStringFromCoordinate(pointAnno.coordinate));
    [mapView.annotations enumerateObjectsUsingBlock:^(MAPointAnnotation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DDLog(@"_%@_%@_",@(idx),NSStringFromCoordinate(obj.coordinate));
        
    }];

    if (mapView.annotations.count > 1) {
        MAPointAnnotation * annoStart = mapView.annotations.firstObject;
        annoStart.title = kAnnoTitleStart;
        MAPointAnnotation * annoEnd = mapView.annotations.lastObject;
        
        annoEnd = pointAnno;
        DDLog(@"%@_%@",NSStringFromCoordinate(annoStart.coordinate), NSStringFromCoordinate(annoEnd.coordinate));

        [NNMapManager.shared routeSearchStartPoint:annoStart.coordinate endPoint:annoEnd.coordinate strategy:5 type:@"0" handler:^(AMapRouteSearchBaseRequest *request, AMapRouteSearchResponse *response, NSError *error) {
            if (error) {
                DDLog(@"error:%@",error);
                
            }
            else {
                DDLog(@"response:%@_",@(response.count));
            }
        }];
    }
}

#pragma mark - funtions

//在地图上显示当前选择的路径(需要mapView: rendererForOverlay:配合使用)
- (void)presentCurrentRouteStartPoint:(CLLocationCoordinate2D )startPoint endPoint:(CLLocationCoordinate2D )endPoint response:(AMapRouteSearchResponse *)response{
    [self.naviRoute removeFromMapView];  //清空地图上已有的路线
    
    AMapGeoPoint *origin      =  AMapGeoPointFromCoordinate(startPoint); //起点
    AMapGeoPoint *destination =  AMapGeoPointFromCoordinate(endPoint);  //终点
    //根据已经规划的路径，起点，终点，规划类型，是否显示实时路况，生成显示方案
    self.naviRoute = [MANaviRoute naviRouteForPath:response.route.paths[0] withNaviType:MANaviAnnotationTypeDrive showTraffic:false startPoint:origin endPoint:destination];
    self.naviRoute.anntationVisible = false;
    self.naviRoute.routeColor = UIColor.themeColor;
    
    [self.naviRoute addToMapView:self.mapView];  //显示到地图上
    
    //缩放地图使其适应polylines的展示
    [self.mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines]
                   edgePadding:UIEdgeInsetsMake(30, 30, 30, 30)
                      animated:YES];
}

- (void)presentDriveRouteStart:(CLLocationCoordinate2D )startPoint end:(CLLocationCoordinate2D )endPoint response:(AMapRouteSearchResponse *)response{
    [self.naviRoute removeFromMapView];  //清空地图上已有的路线
    
    AMapGeoPoint *origin      =  AMapGeoPointFromCoordinate(startPoint); //起点
    AMapGeoPoint *destination =  AMapGeoPointFromCoordinate(endPoint);  //终点
    //根据已经规划的路径，起点，终点，规划类型，是否显示实时路况，生成显示方案
    self.naviRoute = [MANaviRoute naviRouteForPath:response.route.paths[0] withNaviType:MANaviAnnotationTypeDrive showTraffic:true startPoint:origin endPoint:destination];
    self.naviRoute.anntationVisible = false;
    self.naviRoute.routeColor = UIColor.themeColor;
    [self.naviRoute addToMapView:self.mapView];  //显示到地图上
    
    //缩放地图使其适应polylines的展示
    [self.mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines]
                        edgePadding:UIEdgeInsetsMake(30, 30, 30, 30)
                           animated:YES];
}

#pragma mark - layz
- (MAMapView *)mapView{
    if (!_mapView) {
        _mapView = NNMapManager.createDefaultMapView;
        _mapView.frame = self.bounds;
        _mapView.delegate = self;
        
    }
    return _mapView;
}

-(UIButton *)locaBtn{
    if (!_locaBtn) {
        _locaBtn = NNMapManager.createDefaultLocaBtn;
    }
    return _locaBtn;
}

- (AMapLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = NNMapManager.createDefaultLocationManager;
        _locationManager.delegate = self;
        
    }
    return _locationManager;
}

- (AMapSearchAPI *)searchAPI{
    if (!_searchAPI) {
        _searchAPI = [[AMapSearchAPI alloc] init];

        _searchAPI.delegate = self;
    }
    return _searchAPI;
}


@end

