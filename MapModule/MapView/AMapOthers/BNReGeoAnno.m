//
//  BNReGeoAnno.m
//  HuiZhuBang
//
//  Created by BIN on 2017/9/9.
//  Copyright © 2017年 Shang. All rights reserved.
//

#import "BNReGeoAnno.h"

@interface BNReGeoAnno ()

@property (nonatomic, readwrite, strong) AMapReGeocode *reGeocode;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

@end

@implementation BNReGeoAnno

- (void)updateContent{
    /* 包含 省, 市, 区以及乡镇.  */
    self.title = [NSString stringWithFormat:@"%@%@%@%@",
                  self.reGeocode.addressComponent.province?: @"",
                  self.reGeocode.addressComponent.city ?: @"",
                  self.reGeocode.addressComponent.district?: @"",
                  self.reGeocode.addressComponent.township?: @""];
    
    /* 包含 社区，建筑. */
    self.subtitle = [NSString stringWithFormat:@"%@%@",
                     self.reGeocode.addressComponent.neighborhood?: @"",
                     self.reGeocode.addressComponent.building?: @""];
}

#pragma mark - Life Cycle

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate reGeocode:(AMapReGeocode *)reGeocode{
    if (self = [super init]){
        self.coordinate = coordinate;
        self.reGeocode  = reGeocode;
        [self updateContent];
    }
    
    return self;
}


- (void)setAMapReGeocode:(AMapReGeocode *)reGerocode{
    self.reGeocode = reGerocode;
    
    [self updateContent];
}


@end
