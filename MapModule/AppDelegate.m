//
//  AppDelegate.m
//  MapModule
//
//  Created by Bin Shang on 2019/11/28.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

#import "AppDelegate.h"
#import "NNCategoryPro.h"
#import "NNMapManager.h"

#import "LocationTracker.h"

#import "NNMapViewController.h"

@interface AppDelegate ()
/// 后台定时定位
@property(nonatomic, strong) LocationTracker *locationTracker;
@property(nonatomic, strong) NSTimer *locationTimer;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setupThridSDKWithOptions:launchOptions];
    UIColor.themeColor = UIColor.lightBlue;
//    UIColor.themeColor = UIColorHexValue(0x0082e0);
    
    [UIApplication setupAppearanceDefault:false];
    
    UIViewController *controller = UICtrFromString(@"HomeViewController");
//    controller = UICtrFromString(@"PKMainController");
    
    controller.view.backgroundColor = UIColor.redColor;
    [UIApplication setupRootController:controller isAdjust:true];

    return YES;
}

- (void)setupThridSDKWithOptions:(NSDictionary *)launchOptions{
//    [UIApplication setupIQKeyboardManager];

    //高德地图
    AMapServices.sharedServices.apiKey = kGDMapKey;
//微信支付
//    [WXApi registerApp:kAppID_WX];
//社交分享
//    [UIApplication registerShareSDK];
    //友盟
//    [UIApplication registerUMengSDKAppKey:kAppKey_UMeng channel:kChannel_UMeng];
//    //极光
//    [self registerJPushSDKAppKey:kAppKey_JPush channel:kChannel_JPush isProduction:kIsProduction options:launchOptions];
    // 后台定位
//    [self startBackgroudUploadLocation];
}

- (void)startBackgroudUploadLocation{
    [UIApplication registerAPNsWithDelegate:self];
    
    NSDictionary *dic = @{
                          @(UIBackgroundRefreshStatusDenied): @"The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh",
                          @(UIBackgroundRefreshStatusRestricted): @"The functions of this app are limited because the Background App Refresh is disable."
                          };
    if ([dic.allKeys containsObject:@(UIApplication.sharedApplication.backgroundRefreshStatus)]) {
        NSString * message = dic[@(UIApplication.sharedApplication.backgroundRefreshStatus)];
        [UIAlertController showSheetTitle:@"" msg:message actionTitles:@[kTitleSure] handler:nil];
        return;
    }
    
    self.locationTracker = [[LocationTracker alloc]init];
    [self.locationTracker startLocationTracking];
    self.locationTimer = [NSTimer scheduledTimerWithTimeInterval:kTimerInterval
                                                          target:self
                                                        selector:@selector(updateLocation)
                                                        userInfo:nil
                                                         repeats:YES];
}

-(void)updateLocation {
    NSLog(@"updateLocation");
    [self.locationTracker updateLocationToServer];
}

#pragma mark - UISceneSession lifecycle

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0
- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

#else

#endif

@end
