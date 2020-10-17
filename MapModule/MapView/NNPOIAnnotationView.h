//
//  NNPOIAnnotationView.h
//  VehicleBonus
//
//  Created by Bin Shang on 2019/3/20.
//  Copyright © 2019 Xi'an iRain IOT Technology Service CO., Ltd. . All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, NNPOIAnnotationStyle) {
    NNPOIAnnotationStyleBlue,
    NNPOIAnnotationStyleOrange,
    NNPOIAnnotationStyleGray,
    NNPOIAnnotationStyleRed
};

/**
 商户POI视图自定义(接近圆形最好)
 */
@interface NNPOIAnnotationView : MAAnnotationView

//@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) NNPOIAnnotationStyle type;

//+ (void)selectAnnotationView:(MAAnnotationView *)view;

@property (nonatomic, strong) UIImage *imageNormal;
@property (nonatomic, strong) UIImage *imageSelected;


@property (nonatomic, assign) BOOL tapSelected;

@end

NS_ASSUME_NONNULL_END
