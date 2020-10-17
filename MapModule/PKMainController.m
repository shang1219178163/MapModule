//
//  PKMainController.m
//  VehicleBonus
//
//  Created by Bin Shang on 2019/3/18.
//  Copyright © 2019 Xi'an iRain IOT Technology Service CO., Ltd. . All rights reserved.
//

#import "PKMainController.h"

#import "NNDriverRouteController.h"
#import "TrackViewController.h"
#import "UIPOIAnnotationView.h"

@interface PKMainController ()
@property (nonatomic, strong) UIButton *locaBtn;

@end

@implementation PKMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"首页OC";
    
    [self createBarItem:@"轨迹" isLeft:false handler:^(id obj, UIView *item, NSInteger idx) {
        [self.navigationController pushVC:@"TrackViewController" title:@"轨迹回溯" animated:true block:^(__kindof UIViewController * _Nonnull vc) {

        }];
        
//        UIViewController *controller = [[TrackViewController alloc]init];
//        [self.navigationController pushViewController:controller animated:true];
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

-(NNMapContainView *)containView{
    if (!_containView) {
        _containView = [[NNMapContainView alloc]initWithFrame:self.view.bounds];
        [_containView.locaBtn addTarget:self action:@selector(handleMapLocation:) forControlEvents:UIControlEventTouchUpInside];
        
        @weakify(self);
        _containView.viewForAnnotationHandler = ^MAAnnotationView *(MAMapView *mapView, id<MAAnnotation> annotation) {
            if ([annotation isKindOfClass:NNPOIAnnotation.class]){
                static NSString *poiAnnotation = @"poiAnnotation";
                NNPOIAnnotation * anno = (NNPOIAnnotation *)annotation;
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
            NNDriverRouteController * controller = [[NNDriverRouteController alloc]init];
            controller.startPoint = mapView.userLocation.coordinate;
            controller.endPoint = view.annotation.coordinate;
            [self.navigationController pushViewController:controller animated:true];
            
        };
    }
    return _containView;
}

- (void)handleMapLocation:(UIButton *)sender{
    [NNMapManager.shared startSingleLocationWithReGeocode:true handler:^(CLLocation *location, AMapLocationReGeocode *regeocode, AMapLocationManager *manager, NSError *error) {
        if (error) {
            [UIAlertController alertControllerWithTitle:@"" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert]
            .nn_present(true, nil);
            return;
        }
//            DDLog(@"coordinate:%@\nreGeocode:%@",NSStringFromCoordinate(location.coordinate),regeocode);
        self.title = regeocode ? NSStringFromReGeocode(regeocode) : self.title;
        //定位成功
        self.containView.mapView.centerCoordinate = location.coordinate;
        [NNMapManager.shared keywordsSearchWithKeywords:@"停车场" city:@"西安" page:1 block:^(AMapPOIKeywordsSearchRequest * _Nonnull request) {
                
        } handler:^(AMapPOISearchBaseRequest * _Nonnull request, AMapPOISearchResponse * _Nonnull response, NSError * _Nullable error) {
            DDLog(@"AMapInputTipsSearchRequest个数_%ld", (long)response.count);
            MAMapView *mapView = self.containView.mapView;
            
            NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
            [response.pois enumerateObjectsUsingBlock:^(AMapPOI * _Nonnull poi, NSUInteger idx, BOOL * _Nonnull stop) {
                NNPOIAnnotation *anno = [[NNPOIAnnotation alloc] initWithPOI:poi];
                anno.index = idx;
                [poiAnnotations addObject:anno];
                
            }];
            [mapView addAnnotations:poiAnnotations];
            /* 如果只有一个结果，设置其为中心点. */
            if (poiAnnotations.count == 1){
               mapView.centerCoordinate = [(NNPOIAnnotation *)poiAnnotations[0] coordinate];
            } else {
//                [_containView.mapView showAnnotations:poiAnnotations animated:NO];
                UIEdgeInsets edge = UIEdgeInsetsMake(20, 20, 20, 20);
                [mapView showAnnotations:poiAnnotations edgePadding:edge animated:NO];
            }
        }];
        
//        CLLocationCoordinate2D coordinate = self.containView.mapView.userLocation.location.coordinate;
//        [NNMapManager.shared geoFenceAddCircleRegionWithCenter:coordinate radius:1000 customID:@"999" handler:^(AMapGeoFenceManager *manager, NSArray<AMapGeoFenceRegion *> *regions, NSString *customID, NSError *error) {
//            if (error) {
//                DDLog(@"error_%@",error.description);
//                return ;
//            }
//        }];

    }];
}

- (void)handleRoutePlanningDrive{
    //    self.coordinateStart = CLLocationCoordinate2DMake(38.6518,108.96263700);
    //    self.coordinateEnd = CLLocationCoordinate2DMake(34.25771100,104.07642);
    
    //    DDLog(@"起点终点%@->%@",[NSString stringFromCoordinate:self.coordinateStart],[NSString stringFromCoordinate:self.coordinateEnd]);
    
    

}


@end
