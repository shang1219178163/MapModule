//
//  NNDriverRouteController.m
//  VehicleBonus
//
//  Created by Bin Shang on 2019/4/2.
//  Copyright © 2019 Xi'an iRain IOT Technology Service CO., Ltd. . All rights reserved.
//

#import "NNDriverRouteController.h"
#import "NNDriverNaviManager.h"
#import "NNPOIAnnotationView.h"
#import "MAAnnotationView+Map.h"
#import "NNMapOpenHelper.h"

#import <Masonry/Masonry.h>
#import <NNCategoryPro/NNCategoryPro.h>

@interface NNDriverRouteController ()

//@property (nonatomic, strong) NNDriverNaviManager *driverNaviManager;
@property (nonatomic, strong) MAPointAnnotation *moveAnno;
@property (nonatomic, strong) NSMutableArray *trackingPoints;

@property (nonatomic, strong) NSNumber *type;;

@end

@implementation NNDriverRouteController

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.containView];
    [self.view addSubview:self.routeTipView];

    self.type = @0;
//    self.type = @1;
    
//    [self.view getViewLayer];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
//    self.routeView.frame = self.view.bounds;
    [self.routeTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.routeTipView.superview);
        make.bottom.equalTo(self.routeTipView.superview);
        make.height.equalTo(@(150));
    }];
    
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.routeTipView.superview);
        make.left.right.equalTo(self.routeTipView.superview);
        make.bottom.equalTo(self.routeTipView.mas_top);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

//    [self.navigationController.navigationBar setDefaultBackgroundImage:UIImage(color: UIColor.clearColor)];
//    self.edgesForExtendedLayout = UIRectEdgeAll;
//    [self createBackItem:[UIImage imageNamed:@"icon_arowLeft_black"] tintColor:UIColor.blackColor];

    
    DDLog(@"_%@_%@_", NSStringFromCoordinate(self.startPoint),NSStringFromCoordinate(self.endPoint));
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];

}

- (void)showRoutePlanningDrive {
    [self.containView routePlanningDriveStartPoint:self.startPoint
                                          endPoint:self.endPoint
                                           handler:^(AMapRouteSearchBaseRequest * _Nonnull request, AMapRouteSearchResponse * _Nonnull response, NSError * _Nullable error) {
            
        AMapPath *path = response.route.paths[0];
        if (!path || error) {
            DDLog(@"地图信息获取失败");
            return;
        }
        DDLog(@"%@", path.steps.lastObject.road);
//        self.routeTipView.label.text = path.steps.lastObject.road.length > 0 ? path.steps.lastObject.road : path.steps.lastObject.assistantAction;
        self.routeTipView.labelSub.text = DistanceInfoFromMeter(path.distance);
        return;
        __block NSMutableArray *annos = [NSMutableArray array];
        [path.steps enumerateObjectsUsingBlock:^(AMapStep * _Nonnull step, NSUInteger idx, BOOL * _Nonnull stop) {
                    
            NSArray<NSString *> *coordnateInfos = [step.polyline componentsSeparatedByString:@";"];
            [coordnateInfos enumerateObjectsUsingBlock:^(NSString * _Nonnull coordnateInfo, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx == 0) {
                    CLLocationCoordinate2D coordnate = Coordinate2DFromString(coordnateInfo);
                    MAPointAnnotation *annotation = [[MAPointAnnotation alloc]init];
                    annotation.coordinate = coordnate;
                    annotation.title = step.road;
                    annotation.subtitle = step.instruction;

                    [annos addObject:annotation];
                }
            }];
            
        }];
        [self.containView.mapView addAnnotations:annos.copy];
        [self.containView.mapView showAnnotations:annos animated:YES];
    }];
}


#pragma mark - funtions

- (void)goDriverNavi{
    NSArray *list = @[@"高德地图",@"百度地图",@"苹果地图",@"内置地图",];
    list = @[@"高德地图",@"百度地图",@"苹果地图",];

    @weakify(self);
    [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet]
    .nn_addAction(list, ^(UIAlertAction * _Nonnull action) {
        @strongify(self);

        NSString *address = self.routeTipView.labelSub.text;
        NSInteger idx = [list indexOfObject:action.title];
        switch (idx) {
            case 0:
                [NNMapOpenHelper openGDMapWithEndPoint:self.endPoint address:address];

                break;
            case 1:
                [NNMapOpenHelper openBaiDuMapWithStartPoint:self.startPoint endPoint:self.endPoint];

                break;
            case 2:
                [NNMapOpenHelper openAppleMapWithEndPoint:self.endPoint address:address];

                break;
            case 3:
//                [self openSDKDriverNavi];

                break;
            default:
                break;
        }
    })
    .nn_present(true, ^{
        
    });
    
}

/// 内置地图
//- (void)openSDKDriverNavi{
//    AMapNaviPoint *startPoint = AMapNaviPointFromCoordinate(self.startPoint);
//    AMapNaviPoint *endPoint = AMapNaviPointFromCoordinate(self.endPoint);
//    NNDriverNaviManager *manager = NNDriverNaviManager.shareInstance;
//
//    @weakify(self);
//    [manager calculateDriveRouteWithStartPoint:startPoint endPoint:endPoint handler:^(AMapNaviDriveManager *driveManager, AMapNaviRoutePlanType type, NSError *error) {
//        @strongify(self);
//        if (error) {
//            DDLog(@"%@",error.description);
//            return ;
//        }
//    }];
//}

#pragma mark -lazy

-(NNMapContainView *)containView{
    if (!_containView) {
        _containView = ({
            NNMapContainView *view = [[NNMapContainView alloc]initWithFrame:CGRectZero];
            view.didUpdateUserHandler = ^(MAMapView * _Nonnull mapView, MAUserLocation * _Nonnull userLocation, BOOL updatingLocation, NSError * _Nullable error) {
                self.startPoint = userLocation.coordinate;
            };
//            @weakify(self);
//            view.viewForAnnotationHandler = ^MAAnnotationView *(MAMapView *mapView, id<MAAnnotation> annotation) {
////              @strongify(self);
//                if ([annotation isKindOfClass:NNPOIAnnotation.class]){
//                    NNPOIAnnotationView * annoView = [NNPOIAnnotationView mapView:mapView viewForAnnotation:annotation];
////                    annoView.label.text = annoView.label.text;
////                    annoView.type = annoView.type;
//                    return view;
//                }
//                return nil;
//            };
            view.singleTappedHandler = ^(MAMapView * _Nonnull mapView, CLLocationCoordinate2D coordinate) {
                self.endPoint = coordinate;
                
                [mapView removeAnnotations:mapView.annotations];
                
                NNPOIAnnotation *anno = [[NNPOIAnnotation alloc] init];
                anno.coordinate = coordinate;
                [mapView addAnnotation:anno];

                [self showRoutePlanningDrive];
                
                [NNMapManager.shared reGeocodeSearchWithBlock:^(AMapReGeocodeSearchRequest * _Nonnull request) {
                    request.location = AMapGeoPointFromCoordinate(coordinate);
                    
                } handler:^(AMapReGeocodeSearchRequest * _Nonnull request, AMapReGeocodeSearchResponse * _Nonnull response, NSError * _Nullable error) {
                    NSString * formattedAddress = response.regeocode.formattedAddress;
                    self.routeTipView.label.text = formattedAddress;
                }];
            };
            view;
        });
    }
    return _containView;
}

-(NNDriverRouteTipView *)routeTipView{
    if (!_routeTipView) {
        _routeTipView = [[NNDriverRouteTipView alloc]initWithFrame:CGRectZero];
        _routeTipView.label.font = [UIFont systemFontOfSize:30];
        _routeTipView.labelSub.font = [UIFont systemFontOfSize:20];
        
        [_routeTipView.btn addTarget:self action:@selector(goDriverNavi) forControlEvents:UIControlEventTouchUpInside];
    }
    return _routeTipView;
}



//-(NNDriverNaviManager *)driverNaviManager{
//    if (!_driverNaviManager) {
//        _driverNaviManager = [[NNDriverNaviManager alloc]init];
//    }
//    return _driverNaviManager;
//}


-(MAPointAnnotation *)moveAnno{
    if (!_moveAnno) {
        _moveAnno = [[MAPointAnnotation alloc] init];
        _moveAnno.title = kAnnoTitleMove;
    }
    return _moveAnno;
}


@end
