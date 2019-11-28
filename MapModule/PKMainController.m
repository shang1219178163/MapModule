//
//  PKMainController.m
//  VehicleBonus
//
//  Created by Bin Shang on 2019/3/18.
//  Copyright © 2019 Xi'an iRain IOT Technology Service CO., Ltd. . All rights reserved.
//

#import "PKMainController.h"

#import "UIPOIAnnotationView.h"

#import "BNDriverRouteController.h"

@interface PKMainController ()
@property (nonatomic, strong) UIButton *locaBtn;

@end

@implementation PKMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"首页OC";

  
    
    [self createBarItem:@"😁" isLeft:false handler:^(id obj, UIView *item, NSInteger idx) {
        [self goController:@"TrackViewController" title:@"轨迹回溯"];
        
    }];
    
    [self.view addSubview:self.containView];

    [self handleMapLocation:nil];
    
//    DDLog(@"%@", UINavigationBar.appearance.tintColor);
//    DDLog(@"%@", UINavigationBar.appearance.barTintColor);
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    

}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.containView.frame = self.view.bounds;
    self.containView.locaBtn.frame = CGRectMake(kX_GAP, CGRectGetHeight(self.containView.frame) - 120, 40, 40);

    self.containView.locaBtn.backgroundColor = UIColor.redColor;
    
}

#pragma mark - driverNavi


#pragma mark - -lazy

-(BNMapContainView *)containView{
    if (!_containView) {
        _containView = [[BNMapContainView alloc]initWithFrame:self.view.bounds];
        [_containView.locaBtn addTarget:self action:@selector(handleMapLocation:) forControlEvents:UIControlEventTouchUpInside];
        
        @weakify(self);
        _containView.viewForAnnotationHandler = ^MAAnnotationView *(MAMapView *mapView, id<MAAnnotation> annotation) {
            if ([annotation isKindOfClass:BNPOIAnnotation.class]){
                static NSString *poiAnnotation = @"poiAnnotation";
                BNPOIAnnotation * anno = (BNPOIAnnotation *)annotation;
                UIPOIAnnotationView * view = [UIPOIAnnotationView mapView:mapView viewForAnnotation:anno identifier:poiAnnotation];
                view.label.text = [NSString stringWithFormat:@"¥%@",@(arc4random()%9)];
                view.type = @(anno.index%4);
                return view;
            }
            return nil;
        };
        _containView.selectHandler = ^(MAMapView *mapView, MAAnnotationView *view, BOOL didSelect) {
            @strongify(self);
            if (didSelect == false) {
                return ;
            }
            BNDriverRouteController * controller = [[BNDriverRouteController alloc]init];
//            controller.startPoint = mapView.userLocation.coordinate;
//            controller.endPoint = view.annotation.coordinate;
            controller.start = mapView.userLocation;
            controller.end = view;
            [self.navigationController pushViewController:controller animated:true];
            
        };
    }
    return _containView;
}

- (void)handleMapLocation:(UIButton *)sender{
    [BNMapManager.shared startSingleLocationWithReGeocode:true handler:^(CLLocation *location, AMapLocationReGeocode *regeocode, AMapLocationManager *manager, NSError *error) {
        if (error) {
            [self showAlertTitle:@"error" msg:error.localizedDescription actionTitles:nil handler:nil];

        } else {
//            DDLog(@"coordinate:%@\nreGeocode:%@",NSStringFromCoordinate(location.coordinate),regeocode);
            self.title = regeocode ? NSStringFromReGeocode(regeocode) : self.title;
            
            if (location){
                //定位成功
                self.containView.mapView.centerCoordinate = location.coordinate;
//                [self showAlertTitle:@"定位成功" msg:NSStringFromCoordinate(location.coordinate)];
                [BNMapManager.shared keywordsSearchWithKeywords:@"停车场" city:@"西安" page:1 coordinate:_containView.userLocationView.annotation.coordinate handler:^(AMapPOISearchBaseRequest *request, AMapPOISearchResponse *response, NSError *error) {
                    DDLog(@"AMapInputTipsSearchRequest个数_%ld", (long)response.count);
                    
                    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
                    [response.pois enumerateObjectsUsingBlock:^(AMapPOI * _Nonnull poi, NSUInteger idx, BOOL * _Nonnull stop) {
                        BNPOIAnnotation * anno = [[BNPOIAnnotation alloc] initWithPOI:poi];
                        anno.index = idx;
                        [poiAnnotations addObject:anno];
                        
                    }];
                    [_containView.mapView addAnnotations:[poiAnnotations subarrayWithRange:NSMakeRange(0, 20)]];
                    /* 如果只有一个结果，设置其为中心点. */
                    if (poiAnnotations.count >= 1){
                        _containView.mapView.centerCoordinate = [(BNPOIAnnotation *)poiAnnotations[0] coordinate];
                    }
                    /* 如果有多个结果, 设置地图使所有的annotation都可见. */
                    else{
                        [_containView.mapView showAnnotations:poiAnnotations animated:NO];
                    }
                }];
                
                CLLocationCoordinate2D coordinate = self.containView.mapView.userLocation.location.coordinate;
//                coordinate = self.containView.mapView.centerCoordinate;
                [BNMapManager.shared geoFenceAddCircleRegionWithCenter:coordinate radius:1000 customID:@"999" handler:^(AMapGeoFenceManager *manager, NSArray<AMapGeoFenceRegion *> *regions, NSString *customID, NSError *error) {
                    if (error) {
                        DDLog(@"error_%@",error.description);
                        return ;
                    }
//                    DDLog(@"_%@_%@_%@_",customID, NSStringFromCoordinate(coordinate), @(regions.firstObject.fenceStatus));
                }];
            } else {
//                [MBProgressHUD showToastWithTips:kLocationFailed inView:self.navigationController.view];
                [self showAlertTitle:@"error" msg:location.description];
            
            }
        }
    }];
}

- (void)handleRoutePlanningDrive{
    //    self.coordinateStart = CLLocationCoordinate2DMake(38.6518,108.96263700);
    //    self.coordinateEnd = CLLocationCoordinate2DMake(34.25771100,104.07642);
    
    //    DDLog(@"起点终点%@->%@",[NSString stringFromCoordinate:self.coordinateStart],[NSString stringFromCoordinate:self.coordinateEnd]);

}


@end
