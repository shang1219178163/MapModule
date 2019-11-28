//
//  BNMapOpenHelper.m
//  VehicleBonus
//
//  Created by Bin Shang on 2019/4/4.
//  Copyright © 2019 Xi'an iRain IOT Technology Service CO., Ltd. . All rights reserved.
//

#import "BNMapOpenHelper.h"
#import "JZLocationConverter.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation BNMapOpenHelper

CLLocation * CLLocationFromCoordinate(CLLocationCoordinate2D coordinate){
    CLLocation * location = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    return location;
}

MKPlacemark * MKPlacemarkFromCLPlacemark(CLPlacemark *placemark){
    MKPlacemark *mark = [[MKPlacemark alloc] initWithPlacemark:placemark];
    return mark;
}

MKMapItem * MKMapItemFromMKPlacemark(MKPlacemark *placemark){
    MKMapItem *mark = [[MKMapItem alloc] initWithPlacemark:placemark];
    return mark;
}

+ (void)openAppleMapWithEndPoint:(CLLocationCoordinate2D)endPoint address:(NSString *)address{
    [SVProgressHUD showWithStatus:@"正在打开本地导航"];
    MKMapItem * currentLocation = MKMapItem.mapItemForCurrentLocation;
    CLGeocoder * geocoder = [[CLGeocoder alloc]init];
    CLLocation * location = CLLocationFromCoordinate(endPoint);
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        MKMapItem *mappItem = MKMapItemFromMKPlacemark(MKPlacemarkFromCLPlacemark(placemarks.firstObject));
        [MKMapItem openMapsWithItems:@[currentLocation,mappItem]
                       launchOptions:@{
                                       MKLaunchOptionsDirectionsModeKey:   MKLaunchOptionsDirectionsModeDriving,
                                       MKLaunchOptionsShowsTrafficKey:   @(true),
                                       }];
        
    }];
    
}

//打开高德地图导航
+ (void)openGDMapWithEndPoint:(CLLocationCoordinate2D)endPoint address:(NSString *)address{
    NSString *sourceApplication = @"高德地图";
    NSString *backScheme = @"";
    NSString *dev = @"0";
    NSString *style = @"0";
    NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&poiname=%@&lat=%f&lon=%f&dev=%@&style=%@",sourceApplication, backScheme, address, endPoint.latitude, endPoint.longitude,dev,style];
    [BNMapOpenHelper openLocationString:urlString];
}

+ (void)openBaiDuMapWithStartPoint:(CLLocationCoordinate2D)startPoint endPoint:(CLLocationCoordinate2D)endPoint{
    NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:终点&mode=driving",startPoint.latitude,startPoint.longitude,endPoint.latitude,endPoint.longitude];
    [BNMapOpenHelper openLocationString:urlString];
}

+ (void)openLocationString:(NSString *)string{
//    string = @"iosamap://navi?sourceApplication=高德地图&backScheme=&poiname=IOP嵌套测试车场&lat=34.209373&lon=108.840889&dev=0&style=0";
    
    NSString * result = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:result];
    if ([UIApplication.sharedApplication canOpenURL:url]) {
        [UIApplication.sharedApplication openURL:url];
        
    } else {
        [SVProgressHUD showErrorWithStatus:@"操作失败,请稍后重试"];
    }
}

@end
