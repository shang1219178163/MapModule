//
//  BNNoti.m
//  Location
//
//  Created by BIN on 2017/12/22.
//  Copyright © 2017年 Location. All rights reserved.
//

#import "BNNoti.h"

#import "NNGloble.h"
#import "NSObject+Helper.h"

@interface BNNoti ()

@property(nonatomic ,strong) NSNotificationCenter * notiCenter;
//@property(nonatomic ,strong) NSMutableArray * notiMarr;
@property(nonatomic ,strong) NSMutableDictionary * notiMdict;

@end

@implementation BNNoti

#pragma mark - - sharedInstance
+ (instancetype)shared {
    static BNNoti * _singleton = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [[self alloc] init];
    });
    return _singleton;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static BNNoti * _singleton = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [super allocWithZone:zone];

    });
    return _singleton;
    
}

-(NSMutableDictionary *)notiMdict{
    if (!_notiMdict) {
        _notiMdict = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _notiMdict;
}

-(void)dealloc{
    for (NSString *name in self.notiMdict.allKeys) {
        [NSNotificationCenter.defaultCenter removeObserver:self name:name object:nil];
        
    }
}

- (void)addObserverNotiName:(NSString *)name object:(nullable id)object handler:(void (^)(NSString * notiName, NSNotification *noti))handler{
    if (![self.notiMdict.allKeys containsObject:name]) {
        [self.notiMdict setObject:handler forKey:name];
        
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didReceiveNotification:) name:name object:object];
        
    }
}

- (void)didReceiveNotification:(NSNotification *)noti{
    if ([self.notiMdict.allKeys containsObject:noti.name]) {
        void (^handler)(NSString * notiName, NSNotification *noti) = self.notiMdict[noti.name];
        if (handler) {
            handler(noti.name, noti);
        }
    }
}

- (void)removeNotiName:(NSString *)notiName{
    [NSNotificationCenter.defaultCenter removeObserver:self name:notiName object:nil];
    
    [self.notiMdict.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:notiName]) {
            [self.notiMdict removeObjectForKey:notiName];
            *stop = YES;
        }
    }];

}

+ (void)registerPushType{
    if (iOSVer(10.0)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                DDLog(@"request authorization succeeded!");
            }
        }];
        
    }
    else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        UIUserNotificationType type = UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        [[UIApplication sharedApplication]registerUserNotificationSettings:setting];
#pragma clang diagnostic pop
    }
}

- (void)addLocalizedUserNotiTrigger:(id)trigger content:(UNMutableNotificationContent *)content identifier:(NSString *)identifier notiCategories:(id)notiCategories handler:(void(^)(UNUserNotificationCenter* center, UNNotificationRequest *request,NSError * _Nullable error))handler{
    
    if ([trigger isKindOfClass:[NSDate class]]) {
        NSTimeInterval interval = [(NSDate *)trigger timeIntervalSince1970] - [[NSDate date] timeIntervalSince1970];
        DDLog(@"_%@_",@(interval));
        interval = interval < 0 ? 1 : interval;
        
        UNTimeIntervalNotificationTrigger *timeTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:interval repeats:NO];
        trigger = timeTrigger;

    }
    else if ([trigger isKindOfClass:[NSDateComponents class]]){
        // 创建日期组建
//        NSDateComponents *components = [[NSDateComponents alloc] init];
//        components.weekday = 4;
//        components.hour = 10;
//        components.minute = 12;
        UNCalendarNotificationTrigger *calendarTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:trigger repeats:YES];
        trigger = calendarTrigger;
        
    }
    else if ([trigger isKindOfClass:[CLCircularRegion class]]){
//        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(39.788857, 116.5559392);
//        CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:center1 radius:500 identifier:@"经海五路"];
//        region.notifyOnEntry = YES;
//        region.notifyOnExit = YES
        UNLocationNotificationTrigger *locationTrigger = [UNLocationNotificationTrigger triggerWithRegion:trigger repeats:YES];
        trigger = locationTrigger;
        
    }
    else{
        NSParameterAssert([trigger isKindOfClass:[NSDate class]] || [trigger isKindOfClass:[NSDateComponents class]] || [trigger isKindOfClass:[CLCircularRegion class]]);
        
    }
    
    // 创建通知请求 UNNotificationRequest 将触发条件和通知内容添加到请求中
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center setNotificationCategories:[self notiCategories:notiCategories]];
    // 将通知请求 add 到 UNUserNotificationCenter
    
    
    __weak typeof(center) weakCenter = center;
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        __strong typeof(weakCenter) strongCenter = weakCenter;
        handler(strongCenter,request,error);
        if (!error) {
            DDLog(@"推送已添加成功 %@", identifier);
            //你自己的需求例如下面：
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"本地通知" message:@"成功添加推送" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//            [alert addAction:cancelAction];
//            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
            //此处省略一万行需求。。。。
            
        }
    }];
}

- (NSSet *)notiCategories:(id)obj{
    if (!obj) {
        return [NSSet set];
    }
    
    UNNotificationCategory *notiCategory = nil;
    if ([obj isKindOfClass:[UNTextInputNotificationAction class]]) {
        notiCategory = [UNNotificationCategory categoryWithIdentifier:@"locationCategory" actions:@[obj] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        
    } else {
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray * actions = [self actionsBylist:obj];
            notiCategory = [UNNotificationCategory categoryWithIdentifier:@"locationCategory" actions:actions intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];

        }
        
    }
    // 注册 category
    // * identifier 标识符
    // * actions 操作数组
    // * intentIdentifiers 意图标识符 可在 <Intents/INIntentIdentifiers.h> 中查看，主要是针对电话、carplay 等开放的 API。
    // * options 通知选项 枚举类型 也是为了支持 carplay
    
    // 将 category 添加到通知中心
//    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//    [center setNotificationCategories:[NSSet setWithObject:notiCategory]];
    return [NSSet setWithObject:notiCategory];
}

- (NSArray *)actionsBylist:(NSArray *)list{
    NSMutableArray * marr = [NSMutableArray array];
    
    for (NSArray * array in list) {
        //        array包含 0,actionid;1,title;2,UNNotificationActionOptions
        UNNotificationAction *action = [UNNotificationAction actionWithIdentifier:[array firstObject] title:array[1] options:[array[2] integerValue]];
        [marr addObject:action];
        
    }
    return marr;
    
}


- (void)addLocalNotification{
    
    /*
     ios8以上版本需要在appdelegate中注册申请权限 本地通知在软件杀死状态也可以接收到消息
     */
    
    // 1.创建本地通知
    UILocalNotification *localNote = [[UILocalNotification alloc] init];
    // 2.设置本地通知(发送的时间和内容是必须设置的)
    localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:3.0];
    localNote.alertBody = @"吃饭了么?";
    
    /**
     其他属性: timeZone 时区
     repeatInterval 多长时间重复一次:一年,一个世纪,一天..
     region 区域 : 传入中心点和半径就可以设置一个区域 (如果进入这个区域或者出来这个区域就发出一个通知)
     regionTriggersOnce  BOOL 默认为YES, 如果进入这个区域或者出来这个区域 只会发出 一次 通知,以后就不发送了
     alertAction: 设置锁屏状态下本地通知下面的 滑动来 ...字样  默认为滑动来查看
     hasAction: alertAction的属性是否生效
     alertLaunchImage: 点击通知进入app的过程中显示图片,随便写,如果设置了(不管设置的是什么),都会加载app默认的启动图
     alertTitle: 以前项目名称所在的位置的文字: 不设置显示项目名称, 在通知内容上方
     soundName: 有通知时的音效 UILocalNotificationDefaultSoundName默认声音
     可以更改这个声音: 只要将音效导入到工程中,localNote.soundName = @"nihao.waw"
     */
    
    localNote.alertAction = @"快点啊"; // 锁屏状态下显示: 滑动来快点啊
    //    localNote.alertLaunchImage = @"123";
    localNote.alertTitle = @"东方_未明";
    localNote.soundName = UILocalNotificationDefaultSoundName;
    localNote.soundName = @"nihao.waw";
    
    /* 这里接到本地通知,badge变为5, 如果打开app,消除掉badge, 则在appdelegate中实现
     [application setApplicationIconBadgeNumber:0];
     */
    localNote.applicationIconBadgeNumber = 5;
    
    // 设置额外信息,appdelegate中收到通知,可以根据不同的通知的额外信息确定跳转到不同的界面
    localNote.userInfo = @{@"type":@1};
    
    // 3.调用通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
    
}

@end
