//
//  MainViewController.m
//  Tracking
//
//  Created by xiaojian on 14-7-30.
//  Copyright (c) 2014年 Tab. All rights reserved.
//

#import "TrackingViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "Tracking.h"

#import "BNMapManager.h"

@interface TrackingViewController ()<MAMapViewDelegate, TrackingDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) Tracking *tracking;

@end

@implementation TrackingViewController

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if (annotation == self.tracking.moveAnno){
        static NSString *trackingReuseIndetifier = @"trackingReuseIndetifier";
        
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:trackingReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:trackingReuseIndetifier];
        }
        
        annotationView.canShowCallout = NO;
        annotationView.image = [UIImage imageNamed:@"map_ball_yellow"];
        
        return annotationView;
    }
    
    return nil;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay{
//    if (overlay == self.tracking.polyline){
    if ([overlay isKindOfClass:[MAPolyline class]]){
        //初始化一个路线类型的view
        MAPolylineRenderer *polygonView = [[MAPolylineRenderer alloc] initWithPolyline:(MAPolyline *)overlay];
        //设置线宽颜色等
        polygonView.lineWidth = 3.f;
        polygonView.strokeColor = [UIColor colorWithRed:0.015 green:0.658 blue:0.986 alpha:1.000];
        polygonView.fillColor = [UIColor colorWithRed:0.940 green:0.771 blue:0.143 alpha:0.800];
        polygonView.lineJoinType = kMALineJoinRound;//连接类型
        //返回view，就进行了添加
        return polygonView;
    }
    return nil;
}

#pragma mark - TrackingDelegate

- (void)willBeginTracking:(Tracking *)tracking{
    NSLog(@"%s", __func__);
}

- (void)didEndTracking:(Tracking *)tracking{
    NSLog(@"%s", __func__);
}

#pragma mark - Handle Action

- (void)handleRunAction{
    if (self.tracking == nil){
        [self setupTracking];
    }
    
    [self.tracking execute];
}

#pragma mark - Setup

/* 构建mapView. */
- (void)setupMapView{
    _mapView = BNMapManager.createDefaultMapView;
    _mapView.frame = self.view.bounds;
    
//    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    
    [self.view addSubview:self.mapView];
}

/* 构建轨迹回放. */
- (void)setupTracking{
    NSString *trackingFilePath = [[NSBundle mainBundle] pathForResource:@"GuGong" ofType:@"tracking"];
    NSData *trackingData = [NSData dataWithContentsOfFile:trackingFilePath];
    
    CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D *)malloc(trackingData.length);
    
    /* 提取轨迹原始数据. */
    [trackingData getBytes:coordinates length:trackingData.length];
    
    /* 构建tracking. */
    self.tracking = [[Tracking alloc] initWithCoordinates:coordinates count:trackingData.length / sizeof(CLLocationCoordinate2D)];
    self.tracking.delegate = self;
    self.tracking.mapView  = self.mapView;
    self.tracking.duration = 5.f;
    self.tracking.edgeInsets = UIEdgeInsetsMake(30, 30, 30, 30);
}

- (void)setupNavigationBar{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Run"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(handleRunAction)];
}
#pragma mark - Life Cycle

- (instancetype)init{
    if (self = [super init]){
        self.title = @"轨迹回放";
    }
    
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setupNavigationBar];
    
    [self setupMapView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barStyle    = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.mapView.frame = self.view.bounds;
}

@end
