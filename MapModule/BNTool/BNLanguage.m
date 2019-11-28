//
//  BNLanguage.m
//  
//
//  Created by BIN on 2018/9/11.
//  Copyright © 2018年 SHANG. All rights reserved.
//

#import "BNLanguage.h"

static NSString *const kAppleLanguages = @"AppleLanguages";
static NSString *const kUserLanguage = @"KeyUserLanguage";

#define kDefault  NSUserDefaults.standardUserDefaults

@implementation BNLanguage

+ (void)setUserLanguage:(NSString *)language{
    //跟随手机系统
    if (!language.length || [language isEqualToString:@""]) {
        [self resetSystemLanguage];
        return;
    }
    //用户自定义
    [kDefault setValue:language forKey:kUserLanguage];
    [kDefault setValue:@[language] forKey:kAppleLanguages];
    [kDefault synchronize];
    
}

+ (NSString *)userLanguage{
    return [kDefault valueForKey:kUserLanguage];
    
}

/**
 重置系统语言
 */
+ (void)resetSystemLanguage{
    [kDefault removeObjectForKey:kUserLanguage];
    [kDefault setValue:nil forKey:kAppleLanguages];
    [kDefault synchronize];
}

+(void)setLanguageType:(NSNumber *)languageType{
    NSString * name = [self dic][[self list][languageType.integerValue]];
    [BNLanguage setUserLanguage:name];
    
}

+ (NSNumber *)languageType{
    NSString * name = [self userLanguage];
    if (!name) {
        return @(0);
    }
    
    NSString * key = [[[self dic] allKeysForObject:name] firstObject];
    NSInteger index = [[self list]indexOfObject:key];
    return @(index);
    
}

+(NSArray *)list{
    return @[
             @"跟随系统", @"简体中文", @"English",
             ];
    
}

+(NSDictionary *)dic{
    return @{
             @"跟随系统":   @"",
             @"简体中文":   @"zh-Hans",
             @"English":   @"en",
             
             };
    
}

@end
