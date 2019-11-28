//
//  BNDriverRouteView.m
//  VehicleBonus
//
//  Created by Bin Shang on 2019/4/2.
//  Copyright © 2019 Xi'an iRain IOT Technology Service CO., Ltd. . All rights reserved.
//

#import "BNDriverRouteView.h"
#import <Masonry/Masonry.h>
#import "UIPOIAnnotationView.h"

@interface BNDriverRouteView ()<TrackingDelegate>

@property (nonatomic, strong) Tracking *tracking;
@property (nonatomic, strong) NSMutableArray * trackingPoints;

@end

@implementation BNDriverRouteView

/// coordinateInfo
NSArray<NSString *> *RouteStepCoordsFromSteps(NSArray<AMapStep *> *steps){
    
    __block NSMutableArray * marr = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < steps.count; i++) {
        AMapStep * step = steps[i];
        NSArray * polylineCoords = [step.polyline componentsSeparatedByString:@";"];
//        DDLog(@"%@_%@_%@",@(i), @(polylineCoords.count),polylineCoords);
        
        for (NSInteger j = 0; j < polylineCoords.count; j++) {
            NSString * coordinateInfo = polylineCoords[j];
//            NSArray * info = [coordinateInfo componentsSeparatedByString:@","];
//            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([info.firstObject floatValue], [info.lastObject floatValue]);
//            DDLog(@"%@", NSStringFromCoordinate(coordinate));
//            [marr addObject:info];
//            DDLog(@"____%@", coordinateInfo);
            [marr addObject:coordinateInfo];
        }
    }
    return marr.copy;
}

CLLocationCoordinate2D *RouteCoordsForStepCoords(NSArray<NSString *> *stepCoords){
    CLLocationCoordinate2D *coords = malloc(stepCoords.count * sizeof(CLLocationCoordinate2D));
    for (NSInteger i = 0; i < stepCoords.count; i++) {
        CLLocationCoordinate2D coordinate = Coordinate2DFromString(stepCoords[i]);
        coords[i] = coordinate;
        
    }
    return coords;
}

NSMutableArray<MAPointAnnotation *> * RouteAnnosFromParam(CLLocationCoordinate2D *coords, NSString *title, NSInteger count){
    NSMutableArray * routeAnnoList = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i++) {
        MAPointAnnotation * annoPoint = [[MAPointAnnotation alloc] init];
        annoPoint.coordinate = coords[i];
        annoPoint.title = title;
        [routeAnnoList addObject:annoPoint];
    }
    return routeAnnoList;
}

#pragma mark - -life cycle
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.containView];
         [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.edges.equalTo(self.containView.superview);
         }];
    }
    return self;
}

-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    
}

#pragma mark - -TrackingDelegate

-(void)didEndTracking:(Tracking *)tracking{
    [self.tracking.mapView removeAnnotation:self.tracking.moveAnno];
    
}

#pragma mark - -funtions

- (void)showRouteStartPoint:(CLLocationCoordinate2D)startPoint endPoint:(CLLocationCoordinate2D)endPoint{

    @weakify(self);
    [BNMapManager.shared routeSearchStartPoint:startPoint endPoint:endPoint strategy:0 type:@"0" handler:^(AMapRouteSearchBaseRequest *request, AMapRouteSearchResponse *response, NSError *error) {
        @strongify(self);
        
        [self presentDriveRouteWithResponse:response];
//        [self.containView presentCurrentRouteStartPoint:startPoint endPoint:endPoint response:response];

        if (self.distanceInfoHandler) {
            self.distanceInfoHandler(DistanceInfoFromAMapRoute(response.route));
        }
        
        if (self.routeSearchResponse) {
            self.routeSearchResponse(response);
        }

    }];
}


- (void)presentDriveRouteWithResponse:(AMapRouteSearchResponse *)response{
    NSArray<AMapStep *> *steps = response.route.paths.firstObject.steps;
    NSArray * stepCoords = RouteStepCoordsFromSteps(steps);
    DDLog(@"steps.count_%@,stepCoords.count_%@", @(steps.count), @(stepCoords.count));
    
    CLLocationCoordinate2D *coords = RouteCoordsForStepCoords(stepCoords);
    [self.tracking setupCoordinates:coords count:stepCoords.count];

    //points显示路段节点
//    NSMutableArray * routeAnnoList = [NSMutableArray array];
//    for (NSInteger i = 0; i < stepCoords.count; i++) {
//        MAPointAnnotation * annoPoint = [[MAPointAnnotation alloc] init];
//        annoPoint.coordinate = coords[i];
//        annoPoint.title = kAnnoTitleRoute;
//        [routeAnnoList addObject:annoPoint];
//    }
//    [self.containView.mapView addAnnotations:routeAnnoList];
//    [self.containView.mapView showAnnotations:routeAnnoList animated:YES];
}

#pragma make -lazy
-(BNMapContainView *)containView{
    if (!_containView) {
        _containView = [[BNMapContainView alloc]initWithFrame:self.bounds];
        _containView.locaBtn.hidden = true;
    }
    return _containView;
}

-(Tracking *)tracking{
    if (!_tracking) {
        _tracking = [[Tracking alloc] init];
        _tracking.edgeInsets = UIEdgeInsetsMake(30, 30, 30, 30);
        _tracking.duration = 5.f;
        _tracking.mapView  = self.containView.mapView;
        _tracking.delegate = self;

    }
    return _tracking;
}


@end
