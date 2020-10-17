//
//  NNDriverRouteTipView.h
//  VehicleBonus
//
//  Created by Bin Shang on 2019/4/4.
//  Copyright © 2019 Xi'an iRain IOT Technology Service CO., Ltd. . All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NNDriverRouteTipView : UIView

@property (nonatomic, assign) UIEdgeInsets edge;

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *labelSub;
@property (nonatomic, strong) UIButton *btn;

@end

NS_ASSUME_NONNULL_END
