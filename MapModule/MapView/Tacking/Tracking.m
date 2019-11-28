//
//  Tracking.m
//  Tracking
//
//  Created by xiaojian on 14-7-30.
//  Copyright (c) 2014年 Tab. All rights reserved.
//

#import "Tracking.h"
#import "BNMapManager.h"

@interface Tracking ()<CAAnimationDelegate>
{
    CLLocationCoordinate2D *_coordinates;
    NSUInteger              _count;
}

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (nonatomic, strong, readwrite) MAPointAnnotation *moveAnno;
@property (nonatomic, strong, readwrite) MAPolyline *polyline;

@end

@implementation Tracking

- (void)dealloc{
    [self clear];
 
    
    if (_coordinates != NULL){
        (void)(free(_coordinates)), _coordinates = NULL;
    }
}

#pragma mark - Life Cycle

- (instancetype)initWithCoordinates:(CLLocationCoordinate2D *)coordinates count:(NSUInteger)count{
    if (self = [super init]){
        [self setupCoordinates:coordinates count:count];
    }
    return self;
}

#pragma mark - Initialization
- (void)initBaseData{
    self.polyline = [MAPolyline polylineWithCoordinates:_coordinates count:_count];
    self.moveAnno.coordinate = _coordinates[0];
    // 动画开始前就展示路径
    [self.mapView setVisibleMapRect:self.polyline.boundingMapRect edgePadding:self.edgeInsets animated:NO];
    [self.mapView addOverlay:self.polyline];
}

#pragma mark - CoreAnimation Delegate

- (void)animationDidStart:(CAAnimation *)anim{
    self.isMoving = true;
    
    [self makeMapViewEnable:NO];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(willBeginTracking:)]){
        [self.delegate willBeginTracking:self];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag){
         //动画结束后展示路径
//        [self.mapView addOverlay:self.polyline];
        [self.shapeLayer removeFromSuperlayer];
        self.isMoving = !flag;
        
        [self makeMapViewEnable:YES];
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didEndTracking:)]){
            [self.delegate didEndTracking:self];
        }
    }
}

#pragma mark - Utility

- (void)setupCoordinates:(CLLocationCoordinate2D *)coordinates count:(NSUInteger)count{
    NSParameterAssert(coordinates != NULL && count > 1);
    self.duration = 3.f;
    self.edgeInsets = UIEdgeInsetsMake(30, 30, 30, 30);
    
    _count = count;
    _coordinates = (CLLocationCoordinate2D *)malloc(count * sizeof(CLLocationCoordinate2D));
    NSParameterAssert(_coordinates != NULL);
    
    /* 内存拷贝. */
    memcpy(_coordinates, coordinates, count * sizeof(CLLocationCoordinate2D));
    
    [self initBaseData];
   
}


/* Enable/Disable mapView. */
- (void)makeMapViewEnable:(BOOL)enabled{
    self.mapView.scrollEnabled          = enabled;
    self.mapView.zoomEnabled            = enabled;
    self.mapView.rotateEnabled          = enabled;
    self.mapView.rotateCameraEnabled    = enabled;
}

/* 构建annotationView的keyFrameAnimation. */
- (CAAnimation *)constructAnnotationAnimationWithPath:(CGPathRef)path{
    if (path == NULL){
        return nil;
    }
    
    CAKeyframeAnimation *keyFrameAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyFrameAnim.duration        = self.duration;
    keyFrameAnim.path            = path;
    keyFrameAnim.calculationMode = kCAAnimationPaced;
    
    return keyFrameAnim;
}

/* 构建shapeLayer的basicAnimation. */
- (CAAnimation *)constructShapeLayerAnimation{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anim.duration         = self.duration;
    anim.fromValue        = @0.f;
    anim.toValue          = @1.f;
    
    return anim;
}

#pragma mark - Interface

- (void)execute{
    if (self.isMoving) {
        return;
    }

    /* 使轨迹在地图可视范围内. */
    [self.mapView setVisibleMapRect:self.polyline.boundingMapRect edgePadding:self.edgeInsets animated:NO];
    
    CGPoint *points = MapPointsForParam(_coordinates, _count, self.mapView);
    CGPathRef path = MapPathForParam(points, _count);
    self.shapeLayer.path = path;
    
    [self.mapView.layer insertSublayer:self.shapeLayer atIndex:1];
    [self.mapView addAnnotation:self.moveAnno];
    
    MAAnnotationView *annoView = [self.mapView viewForAnnotation:self.moveAnno];
    if (annoView != nil){
        /* Annotation animation. */
        CAAnimation *annoAnim = [self constructAnnotationAnimationWithPath:path];
        [annoView.layer addAnimation:annoAnim forKey:@"annotation"];
        annoView.annotation.coordinate = _coordinates[_count - 1];
        
        /* ShapeLayer animation. */
        CAAnimation *shapeLayerAnim = [self constructShapeLayerAnimation];
        shapeLayerAnim.delegate = self;
        [self.shapeLayer addAnimation:shapeLayerAnim forKey:@"shape"];
    }
    
    (void)(free(points)),           points  = NULL;
    (void)(CGPathRelease(path)),    path    = NULL;
}

- (void)clear{
    /* 删除annotation. */
    [self.mapView removeAnnotation:self.moveAnno];
    
    /* 删除polyline. */
    [self.mapView removeOverlay:self.polyline];
    
    /* 删除shapeLayer. */
    [self.shapeLayer removeFromSuperlayer];
}


#pragma mark - -lazy
-(CAShapeLayer *)shapeLayer{
    if (!_shapeLayer) {
        _shapeLayer = ({
            CAShapeLayer * layer = [[CAShapeLayer alloc] init];
            layer.lineWidth   = 3.0;
            layer.strokeColor = UIColor.redColor.CGColor;
            layer.fillColor   = UIColor.clearColor.CGColor;
            layer.lineJoin    = kCALineCapRound;
            
            layer;
        });
    }
    return _shapeLayer;
}

-(MAPointAnnotation *)moveAnno{
    if (!_moveAnno) {
        _moveAnno = [[MAPointAnnotation alloc] init];
        _moveAnno.title = kAnnoTitleMove;
    }
    return _moveAnno;
}


@end
