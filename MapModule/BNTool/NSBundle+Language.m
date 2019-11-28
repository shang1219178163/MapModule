//
//  NSBundle+Language.m
//  
//
//  Created by BIN on 2018/9/12.
//  Copyright © 2018年 SHANG. All rights reserved.
//

#import "NSBundle+Language.h"

#import <objc/runtime.h>

@interface DDBundle : NSBundle

@end

@implementation NSBundle (Language)

+ (BOOL)isChineseLanguage{
    NSString *language = [self currentLanguage];
    return [language hasPrefix:@"zh-Hans"];
}

+ (NSString *)currentLanguage{
    return BNLanguage.userLanguage ? : NSLocale.preferredLanguages.firstObject;
}

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //动态继承、交换，方法类似KVO，通过修改NSBundle.mainBundle对象的isa指针，使其指向它的子类DABundle，这样便可以调用子类的方法；其实这里也可以使用method_swizzling来交换mainBundle的实现，来动态判断，可以同样实现。
//        object_setClass(NSBundle.mainBundle, [DDBundle class]);
    });
}

@end


@implementation DDBundle

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName{
    if ([DDBundle currentBundle]) {
        return [[DDBundle currentBundle] localizedStringForKey:key value:value table:tableName];
    }
    else {
        return [super localizedStringForKey:key value:value table:tableName];
    }
}

+ (NSBundle *)currentBundle{
    if ([NSBundle currentLanguage].length) {
        NSString *path = [NSBundle.mainBundle pathForResource:[NSBundle currentLanguage] ofType:@"lproj"];
        if (path.length) {
            return [NSBundle bundleWithPath:path];
        }
    }
    return nil;
}

@end
