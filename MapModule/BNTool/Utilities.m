//
//  Utilities.m
//  
//
//  Created by 晁进 on 17-7-25.
//  Copyright (c) 2017年 SHANG. All rights reserved.
//

#import "Utilities.h"

#import "NNGloble.h"

#import "AESCrypt.h"
#import "Utilities_DM.h"

#import "NSData+Helper.h"
#import "NSString+Other.h"

static NSString *const kACSEncrypt = @"mbqh1Gtpj9L8pJuv";

@interface Utilities ()

@property(nonatomic, strong) NSDictionary * infoDict;

@end

@implementation Utilities

+ (id)readBoundleDataWithKey:(NSString *)key plistFileName:(NSString *)fileName{
    NSArray * array = [fileName componentsSeparatedByString:@"."];
    NSString *path = [NSBundle.mainBundle pathForResource:array[0] ofType:array[1]];// 找到plist文件
    
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];// 获取文件列表
    
    id obj = dict[key];
    return obj;
}

//sandBox
+ (id)readDataWithKey:(NSString *)key plistFileName:(NSString *)fileName{
//    NSString * plistPath = [NSHomeDirectory() stringByAppendingFormat:@"/Library/File_Plist/%@",fileName];
    NSString * filePath = [NSHomeDirectory() stringByAppendingFormat:@"%@%@",kPlistFilePath,fileName];
    NSMutableDictionary  *mdict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    id obj = mdict[key];
    return obj;
}

+ (BOOL)writeData:(id)data plistKey:(NSString *)plistKey plistFileName:(NSString *)fileName{
//    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    DDLog(@"%@", paths[0]);

    //    NSString * plistPath = [NSHomeDirectory() stringByAppendingFormat:@"/Library/File_Plist/%@",fileName];
    NSString * plistPath = [NSHomeDirectory() stringByAppendingFormat:@"%@",kPlistFilePath];
    if (![Utilities_DM fileExistAtPath:plistPath]) {
        [Utilities_DM createDirectoryAtPath:plistPath];
    }
    NSString *filePath = [plistPath stringByAppendingPathComponent:kPlistName_common];
//    DDLog(@"%@\n", filePath);

    NSMutableDictionary  *mdict = [NSMutableDictionary dictionaryWithCapacity:0];
    if ([Utilities_DM fileExistAtPath:plistPath]) {
        mdict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
        if (!mdict) {
            mdict = [NSMutableDictionary dictionaryWithCapacity:0];

        }
    }

    [mdict setObject:data forKey:plistKey];
   
    BOOL isSuccess = [mdict writeToFile:filePath atomically:YES];
    if (isSuccess) {
        DDLog(@"isSuccess");
        
    } else {
        DDLog(@"isFail");
        
    }
    return isSuccess;
}

//如果需要另外编码,此处处理
+ (NSString *)encodeTheString:(NSString *)inputString{
    
    return inputString;
    
}
//AES加密
+ (NSString *)AESEncryptTheString:(NSString *)inputString{
    
    inputString = [AESCrypt encrypt:inputString password:kACSEncrypt];
    return inputString;
}
//AES解密
+ (NSString *)AESDencryptTheString:(NSString *)inputString{
    
    inputString = [AESCrypt decrypt:inputString password:kACSEncrypt];
    return inputString;
}


- (id)AES128_EncryptParameters:(id)parameters collection:(id)collection{
    
    parameters = [NSString AES128Encrypt:parameters key:kPwdKey_AES];
    
    return parameters ;
}

- (id)AES128_DecryptParameters:(id)parameters collection:(id)collection obj:(id)obj{
    if (![parameters isKindOfClass:[NSString class]]) return obj;
    obj = [NSString AES128Decrypt:obj key:kPwdKey_AES];

    return obj;
}



@end
