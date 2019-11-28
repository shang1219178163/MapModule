//
//  BNReGeoAnno.h
//  HuiZhuBang
//
//  Created by BIN on 2017/9/9.
//  Copyright © 2017年 Shang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapCommonObj.h>

@interface BNReGeoAnno : NSObject<MAAnnotation>

@property (nonatomic, readonly, strong) AMapReGeocode *reGeocode;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate reGeocode:(AMapReGeocode *)reGeocode;
- (void)setAMapReGeocode:(AMapReGeocode *)reGerocode;

@end
