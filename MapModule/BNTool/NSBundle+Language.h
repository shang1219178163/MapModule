//
//  NSBundle+Language.h
//  
//
//  Created by BIN on 2018/9/12.
//  Copyright © 2018年 SHANG. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BNLanguage.h"

@interface NSBundle (Language)

+ (BOOL)isChineseLanguage;

+ (NSString *)currentLanguage;

@end
