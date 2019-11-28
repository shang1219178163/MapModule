//
//  Utilities.h
//  
//
//  Created by 晁进 on 17-7-25.
//  Copyright (c) 2017年 SHANG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject
  
//plist文件读取数据
+ (id)readBoundleDataWithKey:(NSString *)key plistFileName:(NSString *)fileName;
//plist文件写入数据
+ (BOOL)writeData:(id)data plistKey:(NSString *)plistKey plistFileName:(NSString *)fileName;
+ (id)readDataWithKey:(NSString *)key plistFileName:(NSString *)fileName;

+ (NSString *)encodeTheString:(NSString *)inputString;

+ (NSString *)AESEncryptTheString:(NSString *)inputString;

+ (NSString *)AESDencryptTheString:(NSString *)inputString;

+ (NSString *)encrypt:(NSString *)message password:(NSString *)password;


/**
 接口集合加密

 @param parameters jsonString
 @param collection 接口集合
 @return 加密jsonString
 */
- (id)AES128_EncryptParameters:(id)parameters collection:(id)collection;

/**
 集合接口解密

 @param parameters jsonString
 @param collection 接口集合
 @param obj responseObject接口返回数据
 @return 解密responseObject
 */
- (id)AES128_DecryptParameters:(id)parameters collection:(id)collection obj:(id)obj;


@end


