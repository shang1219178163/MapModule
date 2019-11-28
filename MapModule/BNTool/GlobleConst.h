//
//  GlobleConst.h
//  HuiZhuBang
//
//  Created by BIN on 2017/10/13.
//  Copyright © 2017年 WeiHouKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>



/**
 认证相关
 */
UIKIT_EXTERN NSString * const kString_IDName ;
UIKIT_EXTERN NSString * const kString_IDNumber ;
UIKIT_EXTERN NSString * const kString_IDPhoto ;

UIKIT_EXTERN NSString * const kString_DriverName ;
UIKIT_EXTERN NSString * const kString_DriverNumber ;
UIKIT_EXTERN NSString * const kString_DriverExpirationDate ;
UIKIT_EXTERN NSString * const kString_DriverLicensePhoto ;

UIKIT_EXTERN NSString * const kString_DrivingCarNumber ;
UIKIT_EXTERN NSString *const  kString_DrivingCarOwner ;
UIKIT_EXTERN NSString * const kString_DrivingCarBrand ;
UIKIT_EXTERN NSString * const kString_DrivingExpirationDate ;
UIKIT_EXTERN NSString * const kString_DrivingLicensePhoto ;

UIKIT_EXTERN NSString * const kString_TransLicenseexpirationDate ;
UIKIT_EXTERN NSString * const kString_TransCargoCertificatePhoto ;

UIKIT_EXTERN NSString * const kString_EPName ;
UIKIT_EXTERN NSString * const kString_EPAddress ;
UIKIT_EXTERN NSString * const kString_EPLicensePhoto ;


//UIKIT_EXTERN NSString * const kString_IDCardAuth_tips ;
//UIKIT_EXTERN NSString * const kString_DriverCardAuth_tips ;
//UIKIT_EXTERN NSString * const kString_DrivingCardAuth_tips ;
//UIKIT_EXTERN NSString * const kString_TransCardAuth_tips ;
//UIKIT_EXTERN NSString * const kString_EPInfoAuth_tips ;

UIKIT_EXTERN NSString * const kExplain_ShippingCost_Sevice ;
UIKIT_EXTERN NSString * const kExplain_ShippingCost_Cost ;

#pragma make - -订单
/**
 订单
 */
UIKIT_EXTERN NSString * const kOrder_OwnerAddress ;
UIKIT_EXTERN NSString * const kOrder_OwnerLocation ;

UIKIT_EXTERN NSString * const kOrder_DriverAddress ;
UIKIT_EXTERN NSString * const kOrder_DriverLocation ;

UIKIT_EXTERN NSString * const kOrder_Track ;

UIKIT_EXTERN NSString * const kOrder_Evaluation ;
UIKIT_EXTERN NSString * const kOrder_Cancell ;
UIKIT_EXTERN NSString * const kOrder_Detail ;
UIKIT_EXTERN NSString * const kOrder_GoodsAddressLoad ;
UIKIT_EXTERN NSString * const kOrder_GoodsAddressReceived ;

UIKIT_EXTERN NSString * const kOrder_GoodsLoad;

UIKIT_EXTERN NSString * const kOrder_TransToFriends ;
UIKIT_EXTERN NSString * const kOrder_Send ;

UIKIT_EXTERN NSString * const kOrder_Pay ;
UIKIT_EXTERN NSString * const kOrder_SignFor ;


UIKIT_EXTERN NSString * const kOrder_collection ;
UIKIT_EXTERN NSString * const kOrder_otherNeeds ;
UIKIT_EXTERN NSString * const kOrder_shipping ;
UIKIT_EXTERN NSString * const kOrder_amount ;
UIKIT_EXTERN NSString * const kOrder_All ;
/**
 额外需求
 */
UIKIT_EXTERN NSString * const kOrderKey_additionalDemand ;
UIKIT_EXTERN NSString * const kOrderKey_receipt ;
UIKIT_EXTERN NSString * const kOrderKey_collection ;
UIKIT_EXTERN NSString * const kOrderKey_carry ;
UIKIT_EXTERN NSString * const kOrderKey_backTracking ;
UIKIT_EXTERN NSString * const kOrderKey_dray ;

UIKIT_EXTERN NSString * const kOrderObject_receipt ;
UIKIT_EXTERN NSString * const kOrderObject_collection ;
UIKIT_EXTERN NSString * const kOrderObject_carry ;
UIKIT_EXTERN NSString * const kOrderObject_backTracking ;
UIKIT_EXTERN NSString * const kOrderObject_dray ;
/**
 好友/司机
 */

UIKIT_EXTERN NSString * const kfriendAdd ;


/**
 数据录入
 */
UIKIT_EXTERN NSString * const kDataAdd_AnimalSpecies ;
UIKIT_EXTERN NSString * const kDataAdd_AnimalHouse ;
UIKIT_EXTERN NSString * const kDataAdd_AnimalFeed ;
UIKIT_EXTERN NSString * const kDataAdd_AnimalDataEntry ;

UIKIT_EXTERN NSString * const kDataAdd_AnimalOrigin ;
UIKIT_EXTERN NSString * const kDataAdd_AnimalSemenCollect ;
UIKIT_EXTERN NSString * const kDataAdd_AnimalTupping ;
UIKIT_EXTERN NSString * const kDataAdd_AnimalPregnancyTest ;

UIKIT_EXTERN NSString * const kDataAdd_AnimalChildbirth ;
UIKIT_EXTERN NSString * const kDataAdd_AnimalAblactation ;
UIKIT_EXTERN NSString * const kDataAdd_AnimalOut ;
UIKIT_EXTERN NSString * const kDataAdd_AnimalBatch ;

UIKIT_EXTERN NSString * const kDataAdd_AnimalSemenColor ;
UIKIT_EXTERN NSString * const kDataAdd_AnimalSemenSmell ;
UIKIT_EXTERN NSString * const kDataAdd_AnimalSemenLevel ;

UIKIT_EXTERN NSString * const kDataAdd_AnimalOutDes ;

/**
 种猪管理
 */
UIKIT_EXTERN NSString * const kTitle_EarID ;
UIKIT_EXTERN NSString * const kTitle_Earpiercing ;
UIKIT_EXTERN NSString * const kTitle_Sex ;
UIKIT_EXTERN NSString * const kTitle_Variety ;
UIKIT_EXTERN NSString * const kTitle_GestationalAge ;
UIKIT_EXTERN NSString * const kTitle_CurrentState ;
UIKIT_EXTERN NSString * const kTitle_DayCount ;
UIKIT_EXTERN NSString * const kTitle_Birthday ;

UIKIT_EXTERN NSString * const kTitle_BreedCount ;

UIKIT_EXTERN NSString * const kTitle_House ;
UIKIT_EXTERN NSString * const kTitle_createDay ;

UIKIT_EXTERN NSString * const kTitle_currentCount ;
UIKIT_EXTERN NSString * const kTitle_RateLive ;
UIKIT_EXTERN NSString * const kTitle_watch ;

UIKIT_EXTERN NSString * const kTitle_DayCount_grown ;
UIKIT_EXTERN NSString * const kTitle_date_dayGrown ;
UIKIT_EXTERN NSString * const kTitle_number_current ;

UIKIT_EXTERN NSString * const kTitle_PregnancyTestDate ;
UIKIT_EXTERN NSString * const kTitle_PregnancyTestState ;
UIKIT_EXTERN NSString * const kTitle_PregnancyTestManager ;

UIKIT_EXTERN NSString * const kList_AnimalBreed ;

UIKIT_EXTERN NSString * const kTitle_Remark ;


UIKIT_EXTERN NSString * const kReplay ;
UIKIT_EXTERN NSString * const kUpdate ;
UIKIT_EXTERN NSString * const kDelete ;
UIKIT_EXTERN NSString * const kRemark ;


#pragma mark - -inter

UIKIT_EXTERN NSString * const kNum_PreSecondtime ;//二配时间间隔1天
UIKIT_EXTERN NSString * const kNum_PreyDuetime ;//预产期时间间隔114天

UIKIT_EXTERN NSString * const kWei_batch_aniSingle ;//转入转出单头猪重量

#pragma mark - - air
/**
 achiver
 */
UIKIT_EXTERN NSString * const kAir_UserModel ;
//UIKIT_EXTERN NSString * const kAir_FacoryList ;
UIKIT_EXTERN NSString * const kAir_FacoryModel ;
UIKIT_EXTERN NSString * const kAir_AppParamModel ;

UIKIT_EXTERN NSString * const kAir_Dic_State ;//猪的所有状态字典

UIKIT_EXTERN NSString * const kAir_NoticeList ;
UIKIT_EXTERN NSString * const kAir_ImageList ;
UIKIT_EXTERN NSString * const kAir_OperatorList ;

@interface GlobleConst : NSObject

@end
