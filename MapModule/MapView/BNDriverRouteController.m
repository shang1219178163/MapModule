//
//  BNDriverRouteController.m
//  VehicleBonus
//
//  Created by Bin Shang on 2019/4/2.
//  Copyright © 2019 Xi'an iRain IOT Technology Service CO., Ltd. . All rights reserved.
//

#import "BNDriverRouteController.h"
#import "BNDriverNaviManager.h"
#import "UIPOIAnnotationView.h"
#import "MAAnnotationView+Map.h"
#import "BNMapOpenHelper.h"
#import "TrackViewController.h"

#import "MoveAnnotationView.h"
#import "TracingPoint.h"
#import "Util.h"

#import <Masonry/Masonry.h>

@interface BNDriverRouteController ()<TrackingDelegate>

@property (nonatomic, strong) BNDriverNaviManager *driverNaviManager;
@property (nonatomic, strong) MAPointAnnotation * moveAnno;
@property (nonatomic, strong) NSMutableArray * trackingPoints;

@property (nonatomic, strong) NSNumber *type;;

@end

@implementation BNDriverRouteController

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.routeView];
    [self.view addSubview:self.routeTipView];

    self.type = @0;
//    self.type = @1;

    @weakify(self);
    [self createBarItem:@"轨迹回溯" isLeft:false handler:^(id obj, UIView *item, NSInteger idx) {
        @strongify(self);
        switch (self.type.integerValue) {
            case 1:
            {
                MoveAnnotationView * carView = (MoveAnnotationView *)[self.routeView.containView.mapView viewForAnnotation:self.moveAnno];
                [carView addTrackingAnimationForPoints:self.trackingPoints duration:10];
            }
                break;
            default:
                [self.routeView.tracking execute];
                break;
        }
    }];
    
    self.routeView.routeSearchResponse = ^(AMapRouteSearchResponse * _Nonnull response) {
        @strongify(self);

        if (self.type.integerValue == 0) {
            return ;
        }
        NSArray<AMapStep *> *steps = response.route.paths.firstObject.steps;
        NSArray * stepCoords = RouteStepCoordsFromSteps(steps);
        DDLog(@"steps.count_%@,stepCoords.count_%@", @(steps.count), @(stepCoords.count));
        CLLocationCoordinate2D *coords = RouteCoordsForStepCoords(stepCoords);
//        _coordinates = coords;
//        _count = stepCoords.count;

        [self initTrackingWithCoords:coords count:stepCoords.count];
//
        //show car
        self.moveAnno.coordinate = ((TracingPoint *)self.trackingPoints.firstObject).coordinate;
        [self.routeView.containView.mapView addAnnotation:self.moveAnno];

        //points
        NSMutableArray * routeAnnoList = RouteAnnosFromParam(coords, kAnnoTitleRoute, stepCoords.count);
        [self.routeView.containView.mapView addAnnotations:routeAnnoList];
        [self.routeView.containView.mapView showAnnotations:routeAnnoList animated:YES];
    };
    
    [self.view getViewLayer];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
//    self.routeView.frame = self.view.bounds;
    [self.routeTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.routeTipView.superview);
        make.bottom.equalTo(self.routeTipView.superview);
        make.height.equalTo(@(CGRectGetHeight(self.routeTipView.superview.bounds)/4.0));
    }];
    
    [self.routeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.routeTipView.superview);
        make.left.right.equalTo(self.routeTipView.superview);
        make.bottom.equalTo(self.routeTipView.mas_top);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

//    [self.navigationController.navigationBar setDefaultBackgroundImage:UIImageColor(UIColor.clearColor)];
//    self.edgesForExtendedLayout = UIRectEdgeAll;
//    [self createBackItem:[UIImage imageNamed:@"icon_arowLeft_black"] tintColor:UIColor.blackColor];
    
    DDLog(@"_%@_%@_", NSStringFromCoordinate(self.startPoint),NSStringFromCoordinate(self.endPoint));

    [self.routeView showRouteStartPoint:self.startPoint endPoint:self.endPoint];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];

}

- (void)presenterToDriveNaviController{
//    BNDriverNaviManager * manager = [[BNDriverNaviManager alloc]init];
//    BNDriverNaviManager * manager = BNDriverNaviManager.shareInstance;

//    BNDriveNaviController *driveNaviController = [[BNDriverNaviController alloc]init];
//    driveNaviController.delegate = self;
//    [manager.driveManager addDataRepresentative: driveNaviController.driveView];
//    [manager.driveManager setAllowsBackgroundLocationUpdates:YES];
//    [manager.driveManager startGPSNavi];
//    [self.navigationController presentViewController:driveNaviController animated:YES completion:nil];
    
}

//- (void)driveNaviViewCloseButtonClicked{
//    [self.driverNaviManager.driveManager stopNavi];
//    self.driverNaviManager.driveManager.allowsBackgroundLocationUpdates = NO;
//}

#pragma mark - funtions

- (void)goDriverNaviController{
    NSArray * list = @[@"高德地图",@"百度地图",@"苹果地图",@"内置地图",] ;
    @weakify(self);
    [UIAlertController showSheetTitle:nil msg:nil actionTitles:list handler:^(UIAlertController * _Nonnull alertVC, UIAlertAction * _Nonnull action) {
        @strongify(self);
        
        NSString * address = self.routeTipView.labelSub.text;
        
        NSInteger idx = [list indexOfObject:action.title];
        switch (idx) {
            case 0:
                [BNMapOpenHelper openGDMapWithEndPoint:self.endPoint address:address];

                break;
            case 1:
                [BNMapOpenHelper openBaiDuMapWithStartPoint:self.startPoint endPoint:self.endPoint];

                break;
            case 2:
                [BNMapOpenHelper openAppleMapWithEndPoint:self.endPoint address:address];

                break;
            case 3:
                [self openSDKDriverNavi];

                break;
            default:
                break;
        }
    }];
}

/// 内置地图
- (void)openSDKDriverNavi{
    AMapNaviPoint *startPoint = AMapNaviPointFromCoordinate(self.startPoint);
    AMapNaviPoint *endPoint = AMapNaviPointFromCoordinate(self.endPoint);
    BNDriverNaviManager *manager = BNDriverNaviManager.shareInstance;
    
    @weakify(self);
    [manager calculateDriveRouteWithStartPoint:startPoint endPoint:endPoint handler:^(AMapNaviDriveManager *driveManager, AMapNaviRoutePlanType type, NSError *error) {
        @strongify(self);
        if (error) {
            DDLog(@"%@",error.description);
            return ;
        }
        [self presenterToDriveNaviController];
    }];
}

- (void)initTrackingWithCoords:(CLLocationCoordinate2D *)coords count:(NSUInteger)count{
    _trackingPoints = [NSMutableArray array];
    for (int i = 0; i<count - 1; i++)
    {
        TracingPoint * tp = [[TracingPoint alloc] init];
        tp.coordinate = coords[i];
        tp.direction = [Util calculateCourseFromCoordinate:coords[i] to:coords[i+1]];
        [_trackingPoints addObject:tp];
    }
    
    TracingPoint * tp = [[TracingPoint alloc] init];
    tp.coordinate = coords[count - 1];
    tp.direction = ((TracingPoint *)[_trackingPoints lastObject]).direction;
    [_trackingPoints addObject:tp];
}
#pragma mark - -set

- (void)setStart:(id)start{
    _start = start;
    self.startPoint = Coordinate2DFromObj(start);
}

- (void)setEnd:(id)end{
    _end = end;
    self.endPoint = Coordinate2DFromObj(end);
    if ([end isKindOfClass: UIPOIAnnotationView.class]) {
        UIPOIAnnotationView * annoView = (UIPOIAnnotationView *)end;
        [self.routeView.containView.mapView addAnnotation:annoView.annotation];

        BNPOIAnnotation * anno = (BNPOIAnnotation *)annoView.annotation;
        self.routeTipView.labelSub.text = anno.poi.name;
//        @weakify(self);
        self.routeView.containView.viewForAnnotationHandler = ^MAAnnotationView *(MAMapView *mapView, id<MAAnnotation> annotation) {
//            @strongify(self);
            if ([annotation isKindOfClass:BNPOIAnnotation.class]){
                UIPOIAnnotationView * view = [UIPOIAnnotationView mapView:mapView viewForAnnotation:annotation];
                
                view.label.text = annoView.label.text;
                view.type = annoView.type;
                return view;
            }
            return nil;
        };
    }
}


#pragma mark - -lazy

-(BNDriverRouteView *)routeView{
    if (!_routeView) {
        _routeView = [[BNDriverRouteView alloc]initWithFrame:CGRectZero];
        
        @weakify(self);
        _routeView.distanceInfoHandler = ^(NSString * _Nonnull distanceInfo) {
            @strongify(self);
            self.routeTipView.label.text = distanceInfo;
            
        };
    }
    return _routeView;
}

-(BNDriverRouteTipView *)routeTipView{
    if (!_routeTipView) {
        _routeTipView = [[BNDriverRouteTipView alloc]initWithFrame:CGRectZero];
        _routeTipView.label.font = [UIFont systemFontOfSize:30];
        _routeTipView.labelSub.font = [UIFont systemFontOfSize:20];
        
        @weakify(self);
        [_routeTipView.btn addActionHandler:^(UIControl * _Nonnull control) {
            @strongify(self);
            [self goDriverNaviController];
            
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _routeTipView;
}

-(BNDriverNaviManager *)driverNaviManager{
    if (!_driverNaviManager) {
        _driverNaviManager = [[BNDriverNaviManager alloc]init];
    }
    return _driverNaviManager;
}


-(MAPointAnnotation *)moveAnno{
    if (!_moveAnno) {
        _moveAnno = [[MAPointAnnotation alloc] init];
        _moveAnno.title = kAnnoTitleMove;
    }
    return _moveAnno;
}


@end
