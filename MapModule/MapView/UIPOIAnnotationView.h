//
//  UIPOIAnnotationView.h
//  VehicleBonus
//
//  Created by Bin Shang on 2019/3/20.
//  Copyright © 2019 Xi'an iRain IOT Technology Service CO., Ltd. . All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 商户POI视图自定义(接近圆形最好)
 */
@interface UIPOIAnnotationView : MAAnnotationView

//@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSNumber *type;

+ (void)selectAnnotationView:(MAAnnotationView *)view;

@end

NS_ASSUME_NONNULL_END
