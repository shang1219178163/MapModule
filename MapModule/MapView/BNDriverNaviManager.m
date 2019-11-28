//
//  BNDriverNaviManager.m
//  VehicleBonus
//
//  Created by Bin Shang on 2019/4/1.
//  Copyright © 2019 Xi'an iRain IOT Technology Service CO., Ltd. . All rights reserved.
//

#import "BNDriverNaviManager.h"
#import "BNDriverNaviController.h"
#import "BNSpeechSynthesizer.h"
#import <SVProgressHUD/SVProgressHUD.h>

NSString * NSStringFromAMapNaviPoint(AMapNaviPoint *point) {
    NSString * string = [NSString stringWithFormat:@"{%.6f,%.6f}",point.latitude,point.longitude];
    return string;
}

AMapNaviPoint * AMapNaviPointFromString(NSString *coordinateInfo) {
    assert([coordinateInfo containsString:@","]);
    coordinateInfo = [coordinateInfo stringByReplacingOccurrencesOfString:@"{" withString:@""];
    coordinateInfo = [coordinateInfo stringByReplacingOccurrencesOfString:@"}" withString:@""];
    
    NSArray * list = [coordinateInfo componentsSeparatedByString:@","];
    CGFloat latitude = [list.firstObject floatValue] > 0.0 ? [list.firstObject floatValue] : 0.0;
    CGFloat longitude = [list.lastObject floatValue] > 0.0 ? [list.lastObject floatValue] : 0.0;
    AMapNaviPoint * point = AMapNaviPointFromCoordinate(CLLocationCoordinate2DMake(latitude, longitude));
    return point;
}

AMapNaviPoint * AMapNaviPointFromCoordinate(CLLocationCoordinate2D coordinate){
    AMapNaviPoint * point = [AMapNaviPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    return point;
}

@interface BNDriverNaviManager()<AMapNaviDriveManagerDelegate, BNDriverNaviControllerDelegate>


@end

@implementation BNDriverNaviManager

+ (instancetype)shareInstance{
    static BNDriverNaviManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[BNDriverNaviManager alloc]init];
    });
    return _instance;
}

#pragma mark -AMapNaviDriveManagerDelegate
- (void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteSuccessWithType:(AMapNaviRoutePlanType)type{
    [SVProgressHUD dismiss];
    DDLog(@"规则路线成功");
//    self.driveManager.allowsBackgroundLocationUpdates = true;

//    if (self.naviDriveHandler) {
//        self.naviDriveHandler(driveManager, type, nil);
//    }

    [self presenterToDriveNaviController];
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteFailure:(NSError *)error{
    [SVProgressHUD dismiss];
    DDLog(@"规则路线失败");
    if (self.naviDriveHandler) {
        self.naviDriveHandler(driveManager, 0, error);
    }
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType{
    //语音播报
    DDLog(@"%@", soundString);
    [BNSpeechSynthesizer.shared speakString:soundString];
    
}


#pragma mark -DriveNaviViewControllerDelegate

-(void)driveNaviControllerCloseSender:(AMapNaviDriveView *)driveView{
    [self.driveManager stopNavi];
    self.driveManager.allowsBackgroundLocationUpdates = NO;
    [BNSpeechSynthesizer.shared stopSpeak];
}

- (void)driveNaviControllerMoreSender:(AMapNaviDriveView *)driveView{
    
}

#pragma mark - Pubilc Method

- (void)calculateDriveRouteWithStartPoint:(AMapNaviPoint *)startPoint endPoint:(AMapNaviPoint *)endPoint handler: (MapNaviDriveHandler)handler{
    [SVProgressHUD showWithStatus:@"路线规划中..."];

    self.naviDriveHandler = handler;
    [self.driveManager calculateDriveRouteWithStartPoints:@[startPoint] endPoints:@[endPoint] wayPoints:nil drivingStrategy:AMapNaviDrivingStrategySingleDefault];
}

- (void)presenterToDriveNaviController{
    BNDriverNaviController *driveVC = [[BNDriverNaviController alloc] init];
    driveVC.delegate = self;
    [self.driveManager addDataRepresentative:driveVC.driveView];
    [self.driveManager setAllowsBackgroundLocationUpdates:YES]; //开启这项会使回到桌面时，顶部会有蓝条的定位信息，准确来做的话，应该是导航的时候开启这个，导航结束关闭
    [self.driveManager startGPSNavi];
    if (self.presnteDriveVC) {
        [self.presnteDriveVC presentViewController:driveVC animated:YES completion:nil];
    }else{
        UIViewController * rootController = UIApplication.sharedApplication.keyWindow.rootViewController;
        [rootController presentViewController:driveVC animated:YES completion:nil];
    }
    
}

#pragma mark -lazy
-(AMapNaviDriveManager *)driveManager{
    if (!_driveManager) {
        _driveManager = ({
            AMapNaviDriveManager * manager = AMapNaviDriveManager.sharedInstance;
            manager.pausesLocationUpdatesAutomatically = NO;
            manager.allowsBackgroundLocationUpdates = YES;

            manager.delegate = self;
            
            manager;
        });
    }
    return _driveManager;
}

//-(BNDriverNaviController *)driveNaviController{
//    if (!_driveNaviController) {
//        _driveNaviController = [[BNDriverNaviController alloc]init];
//    }
//    return _driveNaviController;
//}

@end
