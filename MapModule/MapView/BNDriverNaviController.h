//
//  BNDriverNaviController.h
//  VehicleBonus
//
//  Created by Bin Shang on 2019/4/1.
//  Copyright © 2019 Xi'an iRain IOT Technology Service CO., Ltd. . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapNaviKit/AMapNaviKit.h>

@protocol BNDriverNaviControllerDelegate <NSObject>

@required
- (void)driveNaviControllerCloseSender:(AMapNaviDriveView *)driveView;
- (void)driveNaviControllerMoreSender:(AMapNaviDriveView *)driveView;

@end


/**
 驾车导航控制器
 */
@interface BNDriverNaviController : UIViewController

@property (nonatomic, strong) AMapNaviDriveView *driveView;
@property (nonatomic, weak) id <BNDriverNaviControllerDelegate> delegate;

@property (nonatomic, strong) AMapNaviPoint *startPoint;
@property (nonatomic, strong) AMapNaviPoint *endPoint;

@end


