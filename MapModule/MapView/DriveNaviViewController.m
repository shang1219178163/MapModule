//
//  DriveNaviViewController.m
//  AMapNaviKit
//
//  Created by 刘博 on 16/3/8.
//  Copyright © 2016年 AutoNavi. All rights reserved.
//

#import "DriveNaviViewController.h"

@interface DriveNaviViewController ()<AMapNaviDriveViewDelegate>

@end

@implementation DriveNaviViewController

#pragma mark - Life Cycle

- (instancetype)init{
    if (self = [super init]){
        [self initDriveView];
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.driveView setFrame:self.view.bounds];
    [self.view addSubview:self.driveView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = YES;
}

- (void)initDriveView{
    if (self.driveView == nil){
        self.driveView = [[AMapNaviDriveView alloc] init];
        self.driveView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        [self.driveView setDelegate:self];
    }
}

- (void)viewWillLayoutSubviews{
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)){
//        [self.driveView setIsLandscape:NO];
    }else if (UIInterfaceOrientationIsLandscape(interfaceOrientation)){
//        [self.driveView setIsLandscape:YES];
    }
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark - DriveView Delegate

- (void)driveViewCloseButtonClicked:(AMapNaviDriveView *)driveView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(driveNaviViewCloseButtonClicked)]){
        [self.delegate driveNaviViewCloseButtonClicked];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)driveViewMoreButtonClicked:(AMapNaviDriveView *)driveView{
}

- (void)driveViewTrunIndicatorViewTapped:(AMapNaviDriveView *)driveView{
    if (self.driveView.showMode == AMapNaviDriveViewShowModeCarPositionLocked){
        [self.driveView setShowMode:AMapNaviDriveViewShowModeNormal];
    }else if (self.driveView.showMode == AMapNaviDriveViewShowModeNormal){
        [self.driveView setShowMode:AMapNaviDriveViewShowModeOverview];
    }else if (self.driveView.showMode == AMapNaviDriveViewShowModeOverview){
        [self.driveView setShowMode:AMapNaviDriveViewShowModeCarPositionLocked];
    }
}

- (void)driveView:(AMapNaviDriveView *)driveView didChangeShowMode:(AMapNaviDriveViewShowMode)showMode{
    NSLog(@"didChangeShowMode:%ld", (long)showMode);
}

@end
