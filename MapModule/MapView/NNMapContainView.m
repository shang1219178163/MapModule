//
//  BNMapView.m
//  VehicleBonus
//
//  Created by Bin Shang on 2019/3/18.
//  Copyright © 2019 Xi'an iRain IOT Technology Service CO., Ltd. . All rights reserved.
//

#import "NNMapContainView.h"
#import "NNPOIAnnotationView.h"
#import <Masonry/Masonry.h>

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
        
        self.bottomSpacing = 10;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.mapView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.locaBtn makeConstraints:^(MASConstraintMaker *make) {
        if (self.isBottomLeft) {
            make.left.equalTo(self).offset(10);
        } else {
            make.right.equalTo(self).offset(-10);
        }
        make.bottom.equalTo(self).offset(-self.bottomSpacing);
        make.size.equalTo(self.locaBtnSize);
    }];    
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
        MAAnnotationView *locationView = [mapView viewForAnnotation:mapView.userLocation];
        locationView.annotation.coordinate = mapView.userLocation.coordinate;

        locationView.annotation.title = kAnnoTitleUser;
//        userLocationView.image = [UIImage imageNamed:self.annViewDict[userLocationView.annotation.title]];
        self.userLocationView = locationView;
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

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated wasUserAction:(BOOL)wasUserAction{
//    DDLog(@"DistanceInfo_%@", DistanceInfoFromMapCenterAndMaxEdg(mapView));
    if (self.regionDidChangeHandler) self.regionDidChangeHandler(mapView, animated, wasUserAction);
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
    if (self.viewForAnnotationHandler && self.viewForAnnotationHandler(mapView, annotation)) {
        return self.viewForAnnotationHandler(mapView, annotation);
    }
    else if ([annotation isKindOfClass: NNPOIAnnotation.class]){
        static NSString *poiIdentifier = @"NNPOIAnnotation";
        NNPOIAnnotation *anno = (NNPOIAnnotation *)annotation;
        NNPOIAnnotationView *annoView = [NNPOIAnnotationView mapView:mapView viewForAnnotation:annotation identifier:poiIdentifier];
        
        annoView.label.text = [NSString stringWithFormat:@"¥%@",@(arc4random()%9)];
        annoView.type = NNPOIAnnotationStyleBlue;
        
        if (self.viewForPOIAnnotationHandler) {
            self.viewForPOIAnnotationHandler(mapView, annoView, anno);
        }
        return annoView;
    }
    else if ([annotation isKindOfClass: MAUserLocation.class]){
        static NSString *userIdentifier = @"MAUserLocation";
        MAPinAnnotationView *annoView = [MAPinAnnotationView mapView:mapView viewForAnnotation:annotation identifier:userIdentifier];
        NSString *annoTitle = kAnnoTitleUser;
        annoView.image = [UIImage imageNamed:NNMapManager.shared.annViewDict[annoTitle]];
//        annoView.image = [UIImage imageNamed:@"map_userLocation_default");

        return annoView;
    }
    else if ([annotation isKindOfClass: MAPointAnnotation.class]){
        static NSString *pointIdentifier = @"MAPointAnnotation";
        MAAnnotationView *annoView = [MAAnnotationView mapView:mapView viewForAnnotation:annotation identifier:pointIdentifier];
        annoView.canShowCallout = true;
        
        NSString * annoTitle = [NNMapManager.shared.annViewDict.allKeys containsObject:annotation.title] ? annotation.title : kAnnoTitleDefault;
        annoView.image = [UIImage imageNamed:NNMapManager.shared.annViewDict[annoTitle]];
        return annoView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    if ([view isKindOfClass: NNPOIAnnotationView.class]) {
        ((NNPOIAnnotationView *)view).tapSelected = view.isSelected;
    }
    
    if (self.selectHandler) {
        self.selectHandler(mapView, view, true);
    }
}

- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view{
    if ([view isKindOfClass: NNPOIAnnotationView.class]) {
        ((NNPOIAnnotationView *)view).tapSelected = view.isSelected;
    }
//    DDLog(@"%@", view);
    if (self.selectHandler) {
        self.selectHandler(mapView, view, false);
    }
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay{
    // 自定义定位精度对应的MACircleView
    if (overlay == mapView.userLocationAccuracyCircle){
        MACircleRenderer *renderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        
        renderer.lineWidth    = 5.f;
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
        renderer.strokeColor = UIColor.systemBlueColor;

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
        renderer.strokeColor = UIColor.systemBlueColor;

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
    if (self.singleTappedHandler) {
        self.singleTappedHandler(mapView, coordinate);
    }
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
        MAPointAnnotation *annoStart = mapView.annotations.firstObject;
        annoStart.title = kAnnoTitleStart;
        MAPointAnnotation *annoEnd = mapView.annotations.lastObject;
        
        annoEnd = pointAnno;
        DDLog(@"%@_%@",NSStringFromCoordinate(annoStart.coordinate), NSStringFromCoordinate(annoEnd.coordinate));

        [self routePlanningDriveStartPoint:annoStart.coordinate
                                  endPoint:annoEnd.coordinate
                                   handler:^(AMapRouteSearchBaseRequest * _Nonnull request, AMapRouteSearchResponse * _Nonnull response, NSError * _Nullable error) {
            
        }];
    }
}

#pragma mark - funtions
- (void)routePlanningDriveStartPoint:(CLLocationCoordinate2D)startPoint
                            endPoint:(CLLocationCoordinate2D)endPoint
                             handler:(MapRouteHandler)handler{
    [NNMapManager.shared routePlanningDriveStartPoint:startPoint
                                             endPoint:endPoint
                                             strategy:0
                                              mapView:self.mapView
                                              handler:handler];
}

- (void)presentRouteStartPoint:(CLLocationCoordinate2D )startPoint
                      endPoint:(CLLocationCoordinate2D )endPoint
                      response:(AMapRouteSearchResponse *)response
                          type:(MANaviAnnotationType)type{
    [NNMapManager.shared presentRouteStartPoint:startPoint
                                       endPoint:endPoint
                                       response:response
                                        mapView:self.mapView
                                           type:type];
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

