//
//  MAMapView+Helper.m
//  ParkingWang
//
//  Created by Bin Shang on 2020/7/31.
//  Copyright © 2020 Xi'an iRain IoT. Technology Service CO., Ltd. . All rights reserved.
//

#import "MAMapView+Helper.h"

@implementation MAMapView (Helper)

- (CLLocationCoordinate2D)coordLeftTop{
    CGPoint point = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame));
    return [self convertPoint:point toCoordinateFromView:self.superview];
}

- (CLLocationCoordinate2D)coordLeftBtm{
    CGPoint point = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame));
    return [self convertPoint:point toCoordinateFromView:self.superview];
}

- (CLLocationCoordinate2D)coordRightTop{
    CGPoint point = CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMinY(self.frame));
    return [self convertPoint:point toCoordinateFromView:self.superview];
}

- (CLLocationCoordinate2D)coordRightBtm{
    CGPoint point = CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame));
    return [self convertPoint:point toCoordinateFromView:self.superview];
}

@end
