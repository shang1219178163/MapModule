//
//  BNNoti.h
//  Location
//
//  Created by BIN on 2017/12/22.
//  Copyright © 2017年 Location. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UserNotifications/UserNotifications.h>
#import <CoreLocation/CoreLocation.h>

#define kNoti_isRemote   @"kNoti_isRemote"

#define kNotiPostNameLocation_UploadCoordinate @"kNotiPostNameLocation_UploadCoordinate"

@interface BNNoti : NSObject

+ (instancetype)shared;

@property (nonatomic, copy) void (^NotiHandler)(NSString * notiName, NSNotification *noti);

- (void)addObserverNotiName:(NSString *)name object:(id)object handler:(void (^)(NSString * notiName, NSNotification *noti))handler;

- (void)removeNotiName:(NSString *)notiName;

+ (void)registerPushType;

- (void)addLocalizedUserNotiTrigger:(id)trigger content:(UNMutableNotificationContent *)content identifier:(NSString *)identifier notiCategories:(id)notiCategories handler:(void(^)(UNUserNotificationCenter* center, UNNotificationRequest *request,NSError * _Nullable error))handler;

@end
