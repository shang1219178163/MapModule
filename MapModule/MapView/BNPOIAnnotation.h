//
//  BNPOIAnnotation.h
//  VehicleBonus
//
//  Created by Bin Shang on 2019/3/19.
//  Copyright © 2019 Xi'an iRain IOT Technology Service CO., Ltd. . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapCommonObj.h>


typedef NS_ENUM(NSInteger, BNParkAnnotationType){
    PAWParkAnnotationTypePark,
    PAWParkAnnotationTypeBill
};


/**
 商户POI对象
 */
@interface BNPOIAnnotation : NSObject <MAAnnotation>

- (id)initWithPOI:(AMapPOI *)poi;

@property (nonatomic, strong) AMapPOI *poi;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;


@end


