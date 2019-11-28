
//
//  WHKMapViewController.m
//  
//
//  Created by BIN on 2017/9/7.
//  Copyright © 2017年 SHANG. All rights reserved.
//

#import "WHKMapViewController.h"

#import "NNGloble.h"
#import "NNCategoryPro.h"

#import "BNGeoAnno.h"
#import "KVOController.h"

static const NSInteger kRoutePaddingEdge = 20;

@interface WHKMapViewController ()

/*-------------------------------MAP------------------------------------------------*/

//@property (nonatomic, strong) MAMapView * mapView;
@property (nonatomic, strong) AMapLocationManager * locationManager;

//@property (nonatomic, strong) MAAnnotationView * annViewStart;
//@property (nonatomic, strong) MAAnnotationView * annViewEnd;

//@property (nonatomic, strong) AMapLocationManager * locationManager;
//@property (nonatomic, assign) CLLocationCoordinate2D curentCoordinate;
//@property (nonatomic, assign) CGPoint mapCenter;

//@property (nonatomic, strong) UIButton * btnLocation;
/* 路径规划类型 */
//@property (nonatomic, strong) AMapSearchAPI * searchAPI;
@property (nonatomic, strong) AMapRoute *route;
/* 用于显示当前路线方案. */
@property (nonatomic) MANaviRoute * naviRoute;

@property (nonatomic, strong) NSArray *pathPolylines;

@property (nonatomic, assign) CLLocationCoordinate2D coordinateBegin;
@property (nonatomic, assign) CLLocationCoordinate2D coordinateEnd;

@property (nonatomic, strong) MAAnnotationView *userLocationView;

/*-------------------------------MAP------------------------------------------------*/

@property (nonatomic, strong) NSDictionary *dictAnnotation;

@end

@implementation WHKMapViewController

-(NSDictionary *)dictAnnotation{
    if (!_dictAnnotation) {
        _dictAnnotation = BNMapManager.shared.annViewDict;
    }
    return _dictAnnotation;
}


-(UIView *)containView{
    if (!_containView) {
        _containView = [[UIView alloc]initWithFrame:self.view.bounds];
        _containView.backgroundColor = UIColor.whiteColor;
    }
    return _containView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"高德地图";
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIButton *rightBtn = [self createBarItemTitle:@"Next" imgName:nil isLeft:NO isHidden:NO handler:^(id obj, UIButton *item, NSInteger idx) {
        [self.navigationController popViewControllerAnimated:YES];

    }];
    
    [rightBtn addActionHandler:^(id obj, id item, NSInteger idx) {
        DDLog(@"objc__%@",obj);
        
        UIViewController * viewController  = [NSClassFromString(@"BNViewController") new];
        [self.navigationController pushViewController:viewController animated:YES];
    }];
    
  
    [self registerForKVO];
    
//    [self.view insertSubview:self.mapView atIndex:0];

    [self.containView insertSubview:self.mapView atIndex:0];
    [self.view insertSubview:self.containView atIndex:0];

//    self.containView.frame = CGRectMake(0, 0, 300, 200);
//    self.containView.frame = CGRectMake(0, 20, kScreenWidth - 40, CGRectGetHeight(self.view.bounds) - 40);
//    self.mapView.frame = CGRectMake(0, 0, CGRectGetWidth(self.containView.frame), CGRectGetHeight(self.containView.frame));

//    [self setupMapView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    // 开启定位
    self.mapView.showsUserLocation = YES;

    [self mapAddBeginPoint];
}

-(void)mapAddBeginPoint{
//    MAAnnotationView *userLocationView = [self.mapView viewForAnnotation:self.mapView.userLocation];
//    userLocationView.image = [UIImage imageNamed:@"map_userLocation@2x.png"];
//    
//    [self.mapView removeAnnotations:self.mapView.annotations];//添加起点移除全部
//
//    [self addAnnotionCoordinate:self.mapView.userLocation.coordinate title:kMapAddressBegin isBegin:YES];
    
//    [self.locationManager startUpdatingLocation];
//    self.locationManager.locatingWithReGeocode = YES;
}

#pragma mark - - MapAbout
- (void)setupMapView{
    //把地图放在底层
    [self.containView insertSubview:self.mapView atIndex:0];
    
//    self.mapCenter = CGPointMake(CGRectGetWidth(self.mapView.frame)/2.0, CGRectGetHeight(self.mapView.frame)/2.0);
    
}

#pragma mark - MapViewDelegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    
    //    DDLog(@"didUpdateUserLocation\n___%f->%f->%@",userLocation.coordinate.latitude,userLocation.coordinate.longitude,userLocation.title);
    if(updatingLocation){
        if (!self.userLocationView) {
            MAAnnotationView *userLocationView = [self.mapView viewForAnnotation:self.mapView.userLocation];
            userLocationView.annotation.coordinate = self.mapView.userLocation.coordinate;

            userLocationView.annotation.title = kAnnoTitleUser;
            userLocationView.image = [UIImage imageNamed:self.dictAnnotation[kAnnoTitleUser]];
            self.userLocationView = userLocationView;
            
        }
//        [self addAnnotionCoordinate:userLocation.location.coordinate title:kMapAddressBegin isBegin:YES];
        
        //构造AMapReGeocodeSearchRequest对象
//        [self handleMapReGeocodeWithCoordinate:userLocation.coordinate];
    }
}

//- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
//
//    if(updatingLocation){
//        //取出当前位置的坐标
//        DDLog(@"%f,%f,%@",userLocation.coordinate.latitude,userLocation.coordinate.longitude,userLocation.title);
//        
//        //构造AMapReGeocodeSearchRequest对象
//        [self handleMapReGeocodeWithCoordinate:userLocation.coordinate];
//    }
//}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    
    DDLog(@"LocationFail_error:%@",error);
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    

}

/* 大头针 */
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointIdentifier = @"pointIdentifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointIdentifier];
        if (!annotationView)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointIdentifier];
            annotationView.canShowCallout   = YES;
            annotationView.animatesDrop     = YES;
//            annotationView.draggable          = YES;
        }
        annotationView.pinColor = (annotation == self.mapView.annotations.firstObject ? MAPinAnnotationColorRed : MAPinAnnotationColorGreen);
        
        if ([annotation isKindOfClass:[MAUserLocation class]]) {
            annotationView.image = [UIImage imageNamed: self.dictAnnotation[kAnnoTitleUser]];
            
        }
        else if([self.dictAnnotation.allKeys containsObject:annotation.title]){
            annotationView.image = [UIImage imageNamed: self.dictAnnotation[annotation.title]];
            
        }
        else{
            annotationView.image = [UIImage imageNamed:self.dictAnnotation[kAnnoTitleDefault]];

        }
        return annotationView;
    }
    return nil;
}
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay{
    // 自定义定位精度对应的MACircleView
    if (overlay == mapView.userLocationAccuracyCircle)
    {
        MACircleRenderer *accuracyCircleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        
        accuracyCircleRenderer.lineWidth    = 2.f;
        accuracyCircleRenderer.strokeColor  = UIColor.lightGrayColor;
        accuracyCircleRenderer.fillColor    = [UIColor colorWithRed:1 green:0 blue:0 alpha:.3];
        
        //通过颜色隐藏精度圈
        accuracyCircleRenderer.strokeColor  = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.0];
        accuracyCircleRenderer.fillColor    = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.0];
        
        return accuracyCircleRenderer;
    }
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        polylineRenderer.lineWidth   = 5.f;
        polylineRenderer.lineDash = YES;
        polylineRenderer.strokeColor = UIColor.redColor;
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MANaviPolyline class]])
    {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];
        
        polylineRenderer.lineWidth = 5.f;
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineCapType = kMALineCapRound;
        
        if (naviPolyline.type == MANaviAnnotationTypeWalking){
            polylineRenderer.strokeColor = self.naviRoute.walkingColor;
        }
        else if (naviPolyline.type == MANaviAnnotationTypeRailway){
            polylineRenderer.strokeColor = self.naviRoute.railwayColor;
        }
        else {
            polylineRenderer.strokeColor = self.naviRoute.routeColor;
        }
        return polylineRenderer;
    }
    //    if ([overlay isKindOfClass:[MAMultiPolyline class]])
    //    {
    //        MAMultiColoredPolylineRenderer * polylineRenderer = [[MAMultiColoredPolylineRenderer alloc] initWithMultiPolyline:overlay];
    //
    //        polylineRenderer.lineWidth = 10;
    //        polylineRenderer.strokeColors = [self.naviRoute.multiPolylineColors copy];
    //        polylineRenderer.gradient = YES;
    //
    //        return polylineRenderer;
    //    }
    
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        //初始化一个路线类型的view
        MAPolylineRenderer *polygonView = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        //设置线宽颜色等
        polygonView.lineWidth = 5.f;
        polygonView.strokeColor = [UIColor colorWithRed:0.015 green:0.658 blue:0.986 alpha:1.000];
        polygonView.fillColor = [UIColor colorWithRed:0.940 green:0.771 blue:0.143 alpha:0.800];
        polygonView.lineJoinType = kMALineJoinRound;//连接类型
        //返回view，就进行了添加
        return polygonView;
    }
    
    return nil;
}


- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate{
    [self addAnnotionCoordinate:coordinate title:kAnnoTitleEnd isBegin:NO];
}


#pragma mark - -othersFuntions
- (MAPointAnnotation *)addAnnotionCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title isBegin:(BOOL)isBegin{
    
    MAPointAnnotation * pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = coordinate;
    pointAnnotation.title      = title;
    pointAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", coordinate.latitude, coordinate.longitude];
    
    if ([BNMapManager annoWithTitle:title mapView:self.mapView]) {
        pointAnnotation = [BNMapManager annoWithTitle:title mapView:self.mapView];
        pointAnnotation.coordinate = coordinate;
//        [self.mapView selectAnnotation:pointAnnotation animated:YES];

    }
    else{
        [self.mapView addAnnotation:pointAnnotation];
//        [self.mapView selectAnnotation:pointAnnotation animated:YES];
        
    }
    
    if (isBegin) {
        self.coordinateBegin = pointAnnotation.coordinate;
        
//        self.mapView.centerCoordinate = self.coordinateBegin;
//        [self.mapView setZoomLevel:16 animated:YES];
    }
    else{
        self.coordinateEnd = pointAnnotation.coordinate;
        
        if (CLLocationCoordinate2DIsValid(self.coordinateBegin) && CLLocationCoordinate2DIsValid(self.coordinateEnd)) {
            [self handleSearchRoutePlanningDrive];

        } else {
            DDLog(@"______________起止点:%@-->%@",NSStringFromCoordinate(self.coordinateBegin),NSStringFromCoordinate(self.coordinateEnd));

        }
    }
    return pointAnnotation;
}

- (void)handleMapReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate{
    AMapReGeocodeSearchRequest * request = [[AMapReGeocodeSearchRequest alloc]init];
    request.location                    = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    request.requireExtension            = YES;
    
    [BNMapManager.shared reGeocodeSearchWithRequest:request handler:^(AMapReGeocodeSearchRequest *request, AMapReGeocodeSearchResponse *response, NSError *error) {
        if (error) {
            DDLog(@"error:%@",error);
            
        }
        else{
            [self handleMapGeocodeAddress:response.regeocode.formattedAddress city:@""];
        }
    }];
}

- (void)handleMapGeocodeAddress:(NSString *)address city:(NSString *)city{
    [BNMapManager.shared geocodeSearchWithAddress:address city:city handler:^(AMapGeocodeSearchRequest *request, AMapGeocodeSearchResponse *response, NSError *error) {
        if (error) {
            DDLog(@"error:%@",error);
            
        }
        else{
            DDLog(@"%@",response);
            
        }
    }];
}

- (void)handleSearchRoutePlanningDrive{
    [BNMapManager.shared routeSearchStartPoint:self.coordinateBegin endPoint:self.coordinateEnd strategy:5 type:@"0" handler:^(AMapRouteSearchBaseRequest *request, AMapRouteSearchResponse *response, NSError *error) {
        if (error) {
            DDLog(@"error:%@",error);
            
        } else {
            [self presentDriveRouteWithResponse:response];
            
        }
    }];
}

/* 展示当前路线方案. */
- (void)presentDriveRouteWithResponse:(AMapRouteSearchResponse *)response{
    [self presentCurrentRouteBeginPoint:self.coordinateBegin endPoint:self.coordinateEnd response:response];
    return;
    //移除地图原本的遮盖
    [self.mapView removeOverlays:self.pathPolylines];
    self.pathPolylines = nil;
    
    // 只显⽰示第⼀条 规划的路径
    self.pathPolylines = MapPolylinesForPath(response.route.paths[0]);
    DDLog(@"steps_%@",response.route.paths[0]);
    //添加新的遮盖，然后会触发代理方法进行绘制
    [self.mapView addOverlays:self.pathPolylines];
    /* 缩放地图使其适应polylines的展示. */
    [self.mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.pathPolylines]
                        edgePadding:UIEdgeInsetsMake(kRoutePaddingEdge, kRoutePaddingEdge, kRoutePaddingEdge, kRoutePaddingEdge)
                           animated:YES];
    
}


//在地图上显示当前选择的路径
- (void)presentCurrentRouteBeginPoint:(CLLocationCoordinate2D )beginPoint endPoint:(CLLocationCoordinate2D )endPoint response:(AMapRouteSearchResponse *)response{
    
    [self.naviRoute removeFromMapView];  //清空地图上已有的路线
    
    AMapGeoPoint *origin =      [AMapGeoPoint locationWithLatitude:beginPoint.latitude longitude:beginPoint.longitude]; //起点
    AMapGeoPoint *destination = [AMapGeoPoint locationWithLatitude:endPoint.latitude longitude:endPoint.longitude];  //终点
    
    //根据已经规划的路径，起点，终点，规划类型，是否显示实时路况，生成显示方案
    self.naviRoute = [MANaviRoute naviRouteForPath:response.route.paths[0] withNaviType:MANaviAnnotationTypeDrive showTraffic:NO startPoint:origin endPoint:destination];
    self.naviRoute.anntationVisible = NO;
    self.naviRoute.routeColor = UIColor.themeColor;

    [self.naviRoute addToMapView:self.mapView];  //显示到地图上
    
    //缩放地图使其适应polylines的展示
    [self.mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines]
                        edgePadding:UIEdgeInsetsMake(kRoutePaddingEdge, kRoutePaddingEdge, kRoutePaddingEdge, kRoutePaddingEdge)
                           animated:YES];
}

- (void)registerForKVO {
    [self.KVOController observe:self.containView keyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        
        NSString *keyPath = change[FBKVONotificationKeyPathKey];
//        DDLog(@"监听:%@->%@->%@-->%@->%@",NSStringFromClass([observer class]),NSStringFromClass([object class]),keyPath,change[NSKeyValueChangeOldKey],change[NSKeyValueChangeNewKey]);
        if(object == self.containView && [keyPath isEqualToString:@"frame"]){
            self.mapView.frame = CGRectMake(0, 0, CGRectGetWidth(self.containView.frame), CGRectGetHeight(self.containView.frame));
            
        }
    }];
}

#pragma mark - -layz
//地图懒加载
- (MAMapView *)mapView{
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.frame))];
        _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
//        _mapView.desiredAccuracy = kCLLocationAccuracyBest;
        _mapView.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _mapView.distanceFilter = kCLLocationAccuracyNearestTenMeters;

        _mapView.headingFilter  = 90;
        
        _mapView.zoomLevel = 16;
        _mapView.showsCompass = NO;
        [_mapView setCompassImage:[UIImage imageNamed:@"map_address_compass@2x.png"]];
        //自定义定位经度圈样式
        _mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
        //地图跟踪模式
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        //后台定位
        _mapView.pausesLocationUpdatesAutomatically = NO;
        _mapView.allowsBackgroundLocationUpdates = NO;//iOS9以上系统必须配置
    }
    return _mapView;
}

//-(AMapLocationManager *)locationManager{
//    
//    if (!_locationManager) {
//        _locationManager = [[AMapLocationManager alloc]init];
//        _locationManager.delegate = self;
//        
//        //        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
//        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
//        
//        _locationManager.locationTimeout = 3;
//        //   逆地理请求超时时间，最低2s，此处设置为2s
//        _locationManager.reGeocodeTimeout = 3;
//        
//        _locationManager.locatingWithReGeocode = YES;
//        
//        if (iOSVersion(9)) {
//            _locationManager.allowsBackgroundLocationUpdates = YES;
//            
//        } else {
//            _locationManager.pausesLocationUpdatesAutomatically = NO;//允许后台定位参数，保持不会被系统挂起
//        }
//    }
//    
//    return _locationManager;
//}


//-(AMapSearchAPI *)searchAPI{
//    
//    if (!_searchAPI) {
//        _searchAPI = [[AMapSearchAPI alloc]init];
//        _searchAPI.delegate = self;
//    }
//    return _searchAPI;
//}


@end
