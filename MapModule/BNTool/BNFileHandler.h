//
//  FileHandler.h
//  BINAchiver
//
//  Created by BIN on 2017/12/7.
//  Copyright © 2017年 BIN. All rights reserved.
//

/*
 [NSKeyedArchiver archiveRootObject:testArray toFile:path];
 [data writeToFile:path atomically:YES];
区别:
 
一：数据存储方式不同一个是序列化和反序列化后存储文件，另一个就是直接的存储文件了。


二：对象不同，archiveRootObject:toFile：可以将IOS常见的NSData，NSArray等写入文件，也可以将你自己定义的类型（必须实现了序列和凡序列化的，即遵循NSCoding协议，encodeWithCoder和initWithCoder：方法）写入文件，而writeToFile只能将NSDate等IOS常见的数据类型存入文件，因为本身遵循NSCoding协议。

*/
 
#import <Foundation/Foundation.h>

//#define kFileType_Achiver  @".achiver"
#define kFileType_Achiver  @".air"
#define kFileType_Plist  @".plist"

@interface BNFileHandler : NSObject

//返回缓存根目录 "caches"
+(NSString *)getCachesDirectory;

//返回根目录路径 "document"
+ (NSString *)getDocumentPath;

//创建文件夹
+(BOOL)creatDir:(NSString*)dirPath;

//删除文件夹
+(BOOL)deleteDir:(NSString*)dirPath;

//移动文件夹
+(BOOL)moveDir:(NSString*)srcPath to:(NSString*)desPath;

//创建文件
+ (BOOL)creatFile:(NSString*)filePath withData:(NSData*)data;

//读取文件
+(NSData*)readFile:(NSString *)filePath;

//删除文件
+(BOOL)deleteFile:(NSString *)filePath;

//获取文件目录
+(BOOL)getFileDir:(NSString *)dirPath;

//返回 文件全路径
+ (NSString *)getFilePath:(NSString *)fileName;

//在对应文件保存数据
+ (BOOL)writeDataToFile:(NSString*)fileName data:(NSData*)data;

//从对应的文件读取数据
+ (NSData*)readDataFromFile:(NSString*)fileName;

/**
 对象归档
 
 @param filPath 路径
 @return 归档是是否存储成功
 */
+(BOOL)archiveObject:(id)obj key:(NSString *)key filPath:(NSString *)filPath;

/**
 对象解档
 
 @param filPath 路径
 @return 归档是是否存储成功
 */
+(id)UnarchiveObjectKey:(NSString *)objectKey filPath:(NSString *)filPath;

/**
 collection对象归档
 
 @param objc 归档对象
 @param filName 文件名称
 @return 归档是是否存储成功
 */
+(BOOL)archiveObject:(id)obj filName:(NSString *)filName;

+(BOOL)archiveObject:(id)obj;
/**
 collection对象解档
 
 @param filName 归档文件名称
 @return 归档是是否存储成功
 */
+(id)UnarchiveObjectFilName:(NSString *)filName;

+(void)deleteAirFileName:(NSString *)filName handler:(void(^)(BOOL isExist,BOOL isSuccess))handler;

/**
 指定位置创建plist文件,最外层为root字典,通过字典key操作数据(读取删除,更新)

 @param data 字典,数组,字符串等(不能为模型,模型请用归档)
 @param dataKey 字典key
 @param fileName plist文件名称(不包括后缀名)
 @return 是否操作成功
 */
+(BOOL)writeData:(id)data dataKey:(NSString *)dataKey fileName:(NSString *)fileName;

/**
 指定位置读取plist文件,最外层为root字典,通过字典key操作数据(读取删除,更新)
 
 @param dataKey 字典key
 @param fileName plist文件名称(不包括后缀名)
 @return 是否操作成功
 */
+ (id)readDataKey:(NSString *)dataKey fileName:(NSString *)fileName;

/**
 指定位置创建plist文件内容修改,最外层为root字典,通过字典key操作数据(读取删除,更新)
 
 @param dataKey 字典key
 @param fileName plist文件名称(不包括后缀名)
 @return 是否操作成功
 */
+ (BOOL)deleteDataKey:(NSString *)dataKey fileName:(NSString *)fileName;

/**
 根据索引打印目的文件路径集合中所有文件名称

 @param dirIndex 文件路径索引;
 */
+(void)showAllFileDirIndex:(NSUInteger)dirIndex;

/**
 根据索引从沙盒文件路径集合中获取目的文件夹路径

 @param pathIndex 文件路径索引
 @return 路径
 */
+(NSString *)getFilePathIndex:(NSUInteger)pathIndex;

/**
 遍历文件夹及子文件夹,收集fileType类型文件

 @param fileType 文件类型
 @param dirPath 路径(调用getFilePathIndex)
 @return 返回目标文件类型数组
 */
+(NSArray *)getAllFilterListFileType:(NSString *)fileType dirPath:(NSString *)dirPath;

/**
 子方法(找到目标文件之后封装为字典装入数组)
 */
+(NSDictionary *)getfilterDictFileType:(NSString *)fileType pathPrefix:(NSString *)pathPrefix pathSuffix:(NSString *)pathSuffix;

/**
 子方法(单个文件夹目标查找)
 */
+(NSArray *)getFileNameListType:(NSString *)type dirPath:(NSString *)dirPath;


+(BOOL)isFileExistAtPath:(NSString *)fileFullPath;

@end
