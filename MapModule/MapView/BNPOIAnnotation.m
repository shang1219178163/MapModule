//
//  BNPOIAnnotation.m
//  VehicleBonus
//
//  Created by Bin Shang on 2019/3/19.
//  Copyright © 2019 Xi'an iRain IOT Technology Service CO., Ltd. . All rights reserved.
//

#import "BNPOIAnnotation.h"

#import "BNMapManager.h"

@interface BNPOIAnnotation ()

@end

@implementation BNPOIAnnotation

//- (NSString *)title{
//    return self.poi.name;
//}
//
//- (NSString *)subtitle{
//    return self.poi.address;
//}

#pragma mark - Life Cycle

- (id)initWithPOI:(AMapPOI *)poi{
    if (self = [super init]){
        self.poi = poi;
        
    }
    return self;
}

- (void)setPoi:(AMapPOI *)poi{
    _poi = poi;
    self.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);

}

@end

