//
//  BNDriverNaviController.m
//  VehicleBonus
//
//  Created by Bin Shang on 2019/4/1.
//  Copyright © 2019 Xi'an iRain IOT Technology Service CO., Ltd. . All rights reserved.
//

#import "BNDriverNaviController.h"

@interface BNDriverNaviController ()<AMapNaviDriveViewDelegate>

@end

@implementation BNDriverNaviController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.driveView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = YES;
}


#pragma mark - AMapNaviDriveViewDelegate

- (void)driveViewCloseButtonClicked:(AMapNaviDriveView *)driveView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(driveNaviControllerCloseSender:)]){
        [self.delegate driveNaviControllerCloseSender:driveView];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)driveViewMoreButtonClicked:(AMapNaviDriveView *)driveView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(driveNaviControllerMoreSender:)]) {
        [self.delegate driveNaviControllerMoreSender:driveView];
    }
}

- (void)driveViewTrunIndicatorViewTapped:(AMapNaviDriveView *)driveView{
    if (self.driveView.showMode == AMapNaviDriveViewShowModeCarPositionLocked){
        self.driveView.showMode = AMapNaviDriveViewShowModeNormal;
    }
    else if (self.driveView.showMode == AMapNaviDriveViewShowModeNormal){
        self.driveView.showMode = AMapNaviDriveViewShowModeOverview;
    }
    else if (self.driveView.showMode == AMapNaviDriveViewShowModeOverview){
        self.driveView.showMode = AMapNaviDriveViewShowModeCarPositionLocked;
    }
}

- (void)driveView:(AMapNaviDriveView *)driveView didChangeShowMode:(AMapNaviDriveViewShowMode)showMode{
    NSLog(@"didChangeShowMode:%ld", (long)showMode);
}


#pragma mark -lazy

-(AMapNaviDriveView *)driveView{
    if (!_driveView) {
        _driveView = ({
            AMapNaviDriveView * view = [[AMapNaviDriveView alloc]init];
            view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            view.delegate = self;

            view;
        });
    }
    return _driveView;
}


@end
