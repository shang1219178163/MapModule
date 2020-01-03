//
//  TrackViewController.m
//  test
//
//  Created by yi chen on 14-8-20.
//  Copyright (c) 2014年 yi chen. All rights reserved.
//

#import "TrackViewController.h"
#import "MoveAnnotationView.h"
#import "TracingPoint.h"
#import "Util.h"
#import "NNMapManager.h"

@interface TrackViewController ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView * mapView;

@property (nonatomic, strong) MAPointAnnotation * carAnno;
@property (nonatomic, strong) MAPolyline *polyline;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@end

@implementation TrackViewController
{
    NSMutableArray * _tracking;
    CFTimeInterval _duration;
    CLLocationCoordinate2D *_coordinates;
    NSUInteger              _count;

}

#pragma mark life cycle

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.mapView];
    [self initBtn];
    
    [self.mapView.layer insertSublayer:self.shapeLayer atIndex:1];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self initAnnotation];
    
    [self execute];

}

- (void)execute{
    [self.mapView setVisibleMapRect:self.polyline.boundingMapRect edgePadding:UIEdgeInsetsMake(30, 30, 30, 30) animated:NO];
    /* 构建path. */
    CGPoint *points = MapPointsForParam(_coordinates, _count, self.mapView);
    CGPathRef path = MapPathForParam(points, _count);
    self.shapeLayer.path = path;
}

#pragma mark - Map Delegate
- (void)mapViewRequireLocationAuth:(CLLocationManager *)locationManager{
    [locationManager requestAlwaysAuthorization];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
//    if ([annotation isKindOfClass:[MAUserLocation class]]) {
//       return nil;
//    }
    /* Step 2. */
    if ([annotation isKindOfClass:[MAPointAnnotation class]]){
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MoveAnnotationView *annoView = (MoveAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annoView == nil) {
            annoView = [[MoveAnnotationView alloc] initWithAnnotation:annotation
                                                              reuseIdentifier:pointReuseIndetifier];
        }
        
        if ([annotation.title isEqualToString:@"Car"]){
            UIImage *imge  =  [UIImage imageNamed:@"map_userLocation_arrow"];
            annoView.image =  imge;
            annoView.centerOffset = CGPointZero;
        }
        else if ([annotation.title isEqualToString:@"route"]){
            annoView.image = [UIImage imageNamed:@"trackingPoints.png"];
        }
        
        return annoView;
    }
    
    return nil;
}

- (MAPolylineRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay{
    if ([overlay isKindOfClass:[MAPolyline class]]){
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth   = 3.f;
        polylineRenderer.strokeColor = [UIColor colorWithRed:0 green:0.47 blue:1.0 alpha:0.9];
        
        return polylineRenderer;
    }
    
    return nil;
}

#pragma mark - Action

- (void)mov{
    /* Step 3. */
    
    MoveAnnotationView * carView = (MoveAnnotationView *)[self.mapView viewForAnnotation:self.carAnno];
    [carView addTrackingAnimationForPoints:_tracking duration:_duration];
}

- (void)initBtn{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(0, 150, 60, 30);
    btn.backgroundColor = [UIColor grayColor];
    [btn setTitle:@"move" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(mov) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}

#pragma mark - Initialization

- (void)initAnnotation{
    [self initRoute];
    [self initRoute:_coordinates count:_count];

    //show car
    TracingPoint * start = [_tracking firstObject];
    self.carAnno.coordinate = start.coordinate;
    [self.mapView addAnnotation:self.carAnno];
    
}


#pragma mark - trackings

- (void)initRoute{
    
    NSUInteger count = 14;
    CLLocationCoordinate2D * coords = malloc(count * sizeof(CLLocationCoordinate2D));
    
//    coords[0] = CLLocationCoordinate2DMake(39.93563, 116.387358);
//    coords[1] = CLLocationCoordinate2DMake(39.935564, 116.386414);
//    coords[2] = CLLocationCoordinate2DMake(39.935646, 116.386038);
//    coords[3] = CLLocationCoordinate2DMake(39.93586, 116.385791);
//    coords[4] = CLLocationCoordinate2DMake(39.93586, 116.385791);
//    coords[5] = CLLocationCoordinate2DMake(39.937983, 116.38474);
//    coords[6] = CLLocationCoordinate2DMake(39.938616, 116.3846);
//    coords[7] = CLLocationCoordinate2DMake(39.938888, 116.386971);
//    coords[8] = CLLocationCoordinate2DMake(39.938855, 116.387047);
//    coords[9] = CLLocationCoordinate2DMake(39.938172,  116.387132);
//    coords[10] = CLLocationCoordinate2DMake(39.937604, 116.387218);
//    coords[11] = CLLocationCoordinate2DMake(39.937489, 116.387132);
//    coords[12] = CLLocationCoordinate2DMake(39.93614,  116.387283);
//    coords[13] = CLLocationCoordinate2DMake(39.935622,  116.387347);
    
    coords[0] = CLLocationCoordinate2DMake(108.84075928,34.20860291);
    coords[1] = CLLocationCoordinate2DMake(108.84162903,34.20859909);
    coords[2] = CLLocationCoordinate2DMake(108.84159088,34.20849228);
    coords[3] = CLLocationCoordinate2DMake(108.84158325,34.20799255);
    coords[4] = CLLocationCoordinate2DMake(108.84158325,34.20778656);
    coords[5] = CLLocationCoordinate2DMake(108.84164429,34.20773315);
    coords[6] = CLLocationCoordinate2DMake(108.84259033,34.20773315);
    coords[7] = CLLocationCoordinate2DMake(108.84480286,34.20771790);
    coords[8] = CLLocationCoordinate2DMake(108.84512329,34.20728302);
    coords[9] = CLLocationCoordinate2DMake(108.84536743,34.20562744);
    coords[10] = CLLocationCoordinate2DMake(108.84563446,34.20397568);
    coords[11] = CLLocationCoordinate2DMake(108.84597015,34.20214081);
    coords[12] = CLLocationCoordinate2DMake(108.84597015,34.20214081);
    coords[13] = CLLocationCoordinate2DMake(108.84593964,34.20162582);
    
//    [self showRouteForCoords:coords count:count];
//    [self initTrackingWithCoords:coords count:count];
    
    //    if (coords) {
    //        free(coords);
    //    }
    _coordinates = coords;
    _count = count;

}

- (void)initRoute:(CLLocationCoordinate2D *)coords count:(NSUInteger)count{
    _duration = 8.0;

    [self showRouteForCoords:coords count:count];
    [self initTrackingWithCoords:coords count:count];
}


- (void)showRouteForCoords:(CLLocationCoordinate2D *)coords count:(NSUInteger)count{
    //show route
    self.polyline = [MAPolyline polylineWithCoordinates:coords count:count];
    [self.mapView addOverlay:self.polyline];
    
    NSMutableArray * routeAnno = [NSMutableArray array];
    for (int i = 0 ; i < count; i++){
        MAPointAnnotation * a = [[MAPointAnnotation alloc] init];
        a.coordinate = coords[i];
        a.title = @"route";
        [routeAnno addObject:a];
    }
    [self.mapView addAnnotations:routeAnno];
    //    [self.map addAnnotation:routeAnno[0]];
    [self.mapView showAnnotations:routeAnno animated:YES];
    
}

- (void)initTrackingWithCoords:(CLLocationCoordinate2D *)coords count:(NSUInteger)count{
    _tracking = [NSMutableArray array];
    for (int i = 0; i<count - 1; i++)
    {
        TracingPoint * tp = [[TracingPoint alloc] init];
        tp.coordinate = coords[i];
        tp.direction = [Util calculateCourseFromCoordinate:coords[i] to:coords[i+1]];
        [_tracking addObject:tp];
    }
    
    TracingPoint * tp = [[TracingPoint alloc] init];
    tp.coordinate = coords[count - 1];
    tp.direction = ((TracingPoint *)[_tracking lastObject]).direction;
    [_tracking addObject:tp];
}

#pragma mark - -lazy

- (MAMapView *)mapView{
    if (!_mapView){
        _mapView = [[MAMapView alloc] initWithFrame:self.view.frame];
        _mapView.delegate = self;
        
        //加入annotation旋转动画后，暂未考虑地图旋转的情况。
        _mapView.rotateCameraEnabled = NO;
        _mapView.rotateEnabled = NO;
    }
    return _mapView;
}

-(MAPointAnnotation *)carAnno{
    if (!_carAnno) {
        _carAnno = ({
            MAPointAnnotation *anno = [[MAPointAnnotation alloc]init];
            anno.title = @"Car";
            
            anno;
        });
    }
    return _carAnno;
}

-(CAShapeLayer *)shapeLayer{
    if (!_shapeLayer) {
        _shapeLayer = ({
            CAShapeLayer * layer = [[CAShapeLayer alloc] init];
            layer.lineWidth   = 3;
            layer.strokeColor = UIColor.redColor.CGColor;
            layer.fillColor   = UIColor.clearColor.CGColor;
            layer.lineJoin    = kCALineCapRound;
            
            layer;
        });
    }
    return _shapeLayer;
}


@end
