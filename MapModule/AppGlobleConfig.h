//
//  AppGlobleConfig.h
//  ProductTemplet
//
//  Created by Bin Shang on 2019/4/19.
//  Copyright © 2019 BN. All rights reserved.
//

#import <UIKit/UIKit.h>


/// 协议条款网址
static NSString * kAgreementURL     = @"";

//
static NSString * kAppStoreID       = @"";

#pragma mark - -极光

static NSString * kAppKey_JPush     =   @"";
static NSString * kAppSecret_JPush  =   @"";
static NSString * kChannel_JPush    =   @"App Store";

//#ifdef DEBUG
//static NSString * kIsProduction     =   NO;
//#else
//static NSString * kIsProduction     =   YES;
//#endif

#pragma mark - -友盟

static NSString * kAppKey_UMeng     =       @"";
static NSString * kChannel_UMeng    =   @"App Store";

#pragma mark - -地图

static NSString * kGDMapKey         =    @"bf85ccf99b03d6837a9c9ae8ee0e4aa1";


#pragma mark - -支付宝支付
/**
 -----------------------------------
 支付宝支付需要配置的参数
 -----------------------------------
 */

//开放平台登录https://openhome.alipay.com/platform/appManage.htm
//管理中心获取APPID
static NSString * kAPPID_Ali         =        @"";
//合作伙伴身份ID(partnerID)
static NSString * kPID_Ali           =          @"";

//应用注册scheme,在AliSDKDemo-Info.plist定义URL types
static NSString * kPay_URLScheme_Ali =    @"com.payAli.iOSClient";

/*=====================================================================*/

#pragma mark - -微信支付
/**
 注意:支付单位为分
 
 */

static NSString * kAppID_WX          =        @"";
static NSString * kAppKey_WX         =        @"";

static NSString * kAppID_QQ          =       @"";
static NSString * kAppKey_QQ         =       @"";


#pragma mark - -RecognizeCard
/**
 身份证识别
 */
static NSString * kRecognizeCard_AppKey    =  @"";
static NSString * kRecognizeCard_AppSecret =  @"";
static NSString * kRecognizeCard_AppCode   = @"";

@interface AppGlobleConfig : NSObject

@end
