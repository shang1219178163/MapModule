//
//  GlobleConst.m
//  HuiZhuBang
//
//  Created by BIN on 2017/10/13.
//  Copyright © 2017年 WeiHouKeJi. All rights reserved.
//

#import "GlobleConst.h"




#pragma mark - -认证相关

NSString * const kString_IDName     = @"真实姓名";
NSString * const kString_IDNumber   = @"身份证号";
NSString * const kString_IDPhoto    = @"身份证照";

NSString * const kString_DriverName             = @"真实姓名";
NSString * const kString_DriverNumber           = @"驾驶证号";
NSString * const kString_DriverExpirationDate   = @"有效日期";
NSString * const kString_DriverLicensePhoto     = @"驾驶证照";

NSString * const kString_DrivingCarNumber       = @"车辆号码";
NSString * const kString_DrivingCarOwner        = @"车辆所有人";
NSString * const kString_DrivingCarBrand        = @"车辆品牌";
NSString * const kString_DrivingExpirationDate  = @"有效日期";
NSString * const kString_DrivingLicensePhoto    = @"行驶证照";

NSString * const kString_TransLicenseexpirationDate = @"有效日期";
NSString * const kString_TransCargoCertificatePhoto = @"货运资格证";

NSString * const kString_EPName         = @"真实姓名";
NSString * const kString_EPAddress      = @"驾驶证号";
NSString * const kString_EPLicensePhoto = @"有效日期";


//NSString * const kString_IDCardAuth_tips = @"请提交本人真是的身份证信息,否则将无法获得本平台的安全保障";
//NSString * const kString_DriverCardAuth_tips = @"为了保证出行安全,请务必填写本人的驾驶证资料";
//NSString * const kString_DrivingCardAuth_tips = @"认证后可获得官方车主认证身份";
//NSString * const kString_TransCardAuth_tips = @"认证后可获得官方车主认证身份";
//
//NSString * const kString_EPInfoAuth_tips = @"认证后为您提供安全保障";

NSString * const kExplain_ShippingCost_Sevice   = @"体积重量是一种反映包裹密度的计算方式。低密度的包裹，与实际重量比较，占用的空间通常较大。计算出来的体积重量与实际重量比较，取大者作为计费重量，用以计算运费。" ;
NSString * const kExplain_ShippingCost_Cost     = @"1. 同城、省内及经济区域内互寄：体积重量(KG)的计算方法为：长度(CM)x宽度(CM)x高度(CM)÷12000。\n\n2. 省外非经济区域内互寄，体积重量(KG)的计算方法为：【即日/次晨/次日】长度(CM)x宽度(CM)x高度(CM)÷6000；【隔日】长度(CM)x宽度(CM)x高度(CM)÷12000。\n\n备注：经济区域为：京津冀区域、江浙沪皖区域、黑吉辽区域、川渝区域。其他服务(产  品)体积重量计算方法详情请致电大陆客户服务热线95338。";


#pragma makr - - 订单

NSString * const kOrder_OwnerAddress = @"车主位置";
NSString * const kOrder_OwnerLocation = @"车主定位";

NSString * const kOrder_DriverAddress = @"司机位置";
NSString * const kOrder_DriverLocation = @"司机定位";

NSString * const kOrder_Track = @"订单轨迹";
NSString * const kOrder_Evaluation = @"去评价";
NSString * const kOrder_Cancell = @"取消订单";
NSString * const kOrder_Detail = @"查看详情";

NSString * const kOrder_GoodsAddressLoad  = @"装货地址";
NSString * const kOrder_GoodsAddressReceived  = @"收货地址";

NSString * const kOrder_GoodsLoad = @"确认装货";

NSString * const kOrder_TransToFriends  = @"转给好友";
NSString * const kOrder_Send = @"立即派单";

NSString * const kOrder_Pay = @"立刻确认";
NSString * const kOrder_SignFor = @"确认收货";

#pragma mark - -订单创建
NSString * const kOrder_collection          = @"代收货款";
NSString * const kOrder_otherNeeds          = @"额外需求";
NSString * const kOrder_shipping            = @"预计运费";
NSString * const kOrder_amount              = @"出        价";
NSString * const kOrder_All                 = @"合计:";

NSString * const kOrderKey_additionalDemand    = @"additionalDemand";
NSString * const kOrderKey_receipt             = @"receipt";
NSString * const kOrderKey_collection          = @"collection";
NSString * const kOrderKey_carry               = @"carry";
NSString * const kOrderKey_backTracking        = @"backTracking";
NSString * const kOrderKey_dray                = @"dray";

NSString * const kOrderObject_receipt       = @"回单";
NSString * const kOrderObject_collection    = @"代收货款";
NSString * const kOrderObject_carry         = @"搬运";
NSString * const kOrderObject_backTracking  = @"返程";
NSString * const kOrderObject_dray          = @"板车";

#pragma mark - -好友/司机

NSString * const kfriendAdd          = @"好友申请已发送,等待对方同意。";


#pragma mark - -数据录入

NSString * const kDataAdd_AnimalSpecies         = @"猪品种添加";
NSString * const kDataAdd_AnimalHouse           = @"猪舍添加";
NSString * const kDataAdd_AnimalFeed            = @"饲料添加";
NSString * const kDataAdd_AnimalDataEntry       = @"盘存操作";

NSString * const kDataAdd_AnimalOrigin          = @"添加新种猪";
NSString * const kDataAdd_AnimalSemenCollect    = @"采精录入";
NSString * const kDataAdd_AnimalTupping         = @"配种录入";
NSString * const kDataAdd_AnimalPregnancyTest   = @"孕检录入";

NSString * const kDataAdd_AnimalChildbirth      = @"分娩录入";
NSString * const kDataAdd_AnimalAblactation     = @"断奶录入";
NSString * const kDataAdd_AnimalOut             = @"死淘录入";
NSString * const kDataAdd_AnimalBatch           = @"新增批次";

NSString * const kDataAdd_AnimalSemenColor           = @"正常,不正常";
NSString * const kDataAdd_AnimalSemenSmell           = @"正常,不正常";
NSString * const kDataAdd_AnimalSemenLevel           = @"优秀,良好,合格,不合格";

NSString * const kDataAdd_AnimalOutDes               = @"死亡,淘汰,销售";

NSString * const kTitle_EarID                   = @"耳        标:";
NSString * const kTitle_Earpiercing             = @"耳        缺:";
NSString * const kTitle_Sex                     = @"性        别:";
NSString * const kTitle_Variety                  = @"品        种:";
NSString * const kTitle_GestationalAge          = @"胎        龄:";
NSString * const kTitle_CurrentState            = @"当前状态:";
NSString * const kTitle_DayCount                = @"天        数:";
NSString * const kTitle_Birthday                = @"出生日期:";

NSString * const kTitle_BreedCount              = @"配种次数:";

NSString * const kTitle_House                   = @"栋        舍:";
NSString * const kTitle_createDay               = @"创建日期:";

NSString * const kTitle_currentCount            = @"存栏头数:";
NSString * const kTitle_RateLive                = @"成活率/%:";
NSString * const kTitle_watch                   = @"责 任 人:";

NSString * const kTitle_DayCount_grown          = @"生长日龄:";
NSString * const kTitle_date_dayGrown           = @"日龄日期:";
NSString * const kTitle_number_current          = @"存栏头数:";

NSString * const kTitle_PregnancyTestDate           = @"孕检时间:";
NSString * const kTitle_PregnancyTestState          = @"孕检状态:";
NSString * const kTitle_PregnancyTestManager        = @"孕检管理员:";


NSString * const kList_AnimalBreed              = @"哺乳猪仔,商品猪群,生产母猪,生产公猪,后备种猪";

NSString * const kTitle_Remark                  = @"备        注:";

NSString * const kReplay                     = @"恢复";
NSString * const kUpdate                     = @"修改";
NSString * const kDelete                     = @"删除";
NSString * const kRemark                     = @"备注";


#pragma mark - -inter

NSString * const kNum_PreSecondtime        = @"1";
NSString * const kNum_PreyDuetime        = @"114";

NSString * const kWei_batch_aniSingle       =   @"20.00";

#pragma mark - - air

NSString * const kAir_UserModel              = @"WHKNetInfoCheckLoginModel";
//NSString * const kAir_FacoryList             = @"kAir_FacoryList";
NSString * const kAir_FacoryModel            = @"WHKNetHogpenInfoModel";
NSString * const kAir_AppParamModel          = @"WHKNetInfoAppParamModel";

NSString * const kAir_Dic_State             = @"kAir_dic_State";

NSString * const kAir_NoticeList            = @"kAir_NoticeList";
NSString * const kAir_ImageList             = @"kAir_ImageList";
NSString * const kAir_OperatorList          = @"kAir_OperatorList";


@implementation GlobleConst

@end
