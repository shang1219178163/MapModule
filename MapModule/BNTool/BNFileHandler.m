
//
//  FileHandler.m
//  BINAchiver
//
//  Created by BIN on 2017/12/7.
//  Copyright © 2017年 BIN. All rights reserved.
//

#import "BNFileHandler.h"

#import "NNGloble.h"

@interface BNFileHandler ()


@end


@implementation BNFileHandler

//返回缓存根目录 "caches"
+(NSString *)getCachesDirectory{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return path;
}

//返回根目录路径 "document"
+ (NSString *)getDocumentPath{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return path;
}

//创建文件目录
+(BOOL)creatDir:(NSString*)dirPath{
    if ([[NSFileManager defaultManager] fileExistsAtPath:dirPath]){
        return NO;
    }
    else{
        [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];//创建文件夹
        return YES;
    }
    
}

//删除文件目录
+(BOOL)deleteDir:(NSString*)dirPath{
    if([[NSFileManager defaultManager] fileExistsAtPath:dirPath]){
        NSError *error = nil;
        return [[NSFileManager defaultManager]  removeItemAtPath:dirPath error:&error];
        
    }
    return  NO;
}

//移动文件夹(prePath 为原路径、 cenPath 为目标路径)

+(BOOL)moveDir:(NSString*)srcPath to:(NSString*)desPath{
    NSError *error=nil;
    if([[NSFileManager defaultManager] moveItemAtPath:srcPath toPath:desPath error:&error] != YES){
        DDLog(@"移动文件失败");
        return NO;
    }
    else{
        DDLog(@"移动文件成功");
        return YES;
    }
}

//创建文件
+ (BOOL)creatFile:(NSString*)filePath withData:(NSData*)data{
    return  [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil];
    
}

//读取文件
+(NSData*)readFile:(NSString *)filePath{
    return [NSData dataWithContentsOfFile:filePath options:0 error:NULL];
    
}

//删除文件
+(BOOL)deleteFile:(NSString *)filePath{
    return [self deleteDir:filePath];
    
}

//获取文件目录
+(BOOL)getFileDir:(NSString *)dirPath{
    if ([[NSFileManager defaultManager] fileExistsAtPath:dirPath]){
        return YES;
    }
    else{
        BOOL isSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];//创建文件夹
        return isSuccess;
    }
}

+(NSString *)getFilePath:(NSString *)fileName{
    NSString * docPath = [self getDocumentPath];
    NSString * myAppData = [NSString stringWithFormat:@"%@/%@",docPath,@"myAppData"];
    if ([self getFileDir:myAppData]){
        NSString *dirPath = [myAppData stringByAppendingPathComponent:fileName];
        return dirPath;
        
    }
    return nil;
}

+(BOOL)writeDataToFile:(NSString*)fileName data:(NSData *)data{
    NSString *filePath = [self getFilePath:fileName];
    return [self creatFile:filePath withData:data];
    
}

+(NSData*)readDataFromFile:(NSString*)fileName{
    NSString *filePath = [self getFilePath:fileName];
    return [self readFile:filePath];
    
}

#pragma mark - -归档

+(BOOL)archiveObject:(id)obj key:(NSString *)key filPath:(NSString *)filPath{
    // 新建一块可变数据区
    NSMutableData *data = [NSMutableData dataWithCapacity:0];
    // 将数据区连接到一个NSKeyedArchiver对象
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    // 开始存档对象，存档的数据都会存储到NSMutableData中
    [archiver encodeObject:obj forKey:key];
    // 存档完毕(一定要调用这个方法，调用了这个方法，archiver才会将encode的数据存储到NSMutableData中)
    [archiver finishEncoding];
    // 将存档的数据写入文件
    BOOL isSuccess = [data writeToFile:filPath atomically:YES];
    return isSuccess;
}

+(id)UnarchiveObjectKey:(NSString *)objectKey filPath:(NSString *)filPath{
    // 从文件中读取数据
    NSData *data = [NSData dataWithContentsOfFile:filPath];
    // 根据数据，解析成一个NSKeyedUnarchiver对象
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    id obj = [unarchiver decodeObjectForKey:objectKey];
    
    // 恢复完毕(这个方法调用之后，unarchiver不能再decode对象，而且会通知unarchiver的代理调用unarchiverWillFinish:和unarchiverDidFinish:方法)
    [unarchiver finishDecoding];
    
    return obj;
}


+(BOOL)archiveObject:(id)obj filName:(NSString *)filName{
    NSString *path = [self getFilePath:[NSString stringWithFormat:@"%@%@",filName,kFileType_Achiver]];//后缀名可以随意命名.archiver
    BOOL flag = [NSKeyedArchiver archiveRootObject:obj toFile:path];
    
//    DDLog(@"归档路径_%@",path);
    return flag;
}

+(BOOL)archiveObject:(id)obj{
    NSString *filName = NSStringFromClass([obj class]);
    return [self archiveObject:obj filName:filName];
}


+(id)UnarchiveObjectFilName:(NSString *)filName{
    NSString *path = [self getFilePath:[NSString stringWithFormat:@"%@%@",filName,kFileType_Achiver]];//后缀名可以随意命名.archiver
    id obj = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
//    DDLog(@"解档路径_%@",path);
    return obj;
}

+(void)deleteAirFileName:(NSString *)filName handler:(void(^)(BOOL isExist,BOOL isSuccess))handler{
    NSString *path = [self getFilePath:[NSString stringWithFormat:@"%@%@",filName,kFileType_Achiver]];//后缀名可以随意命名.archiver

    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL isExist = [fileMgr fileExistsAtPath:path];
    BOOL isSuccess = NO;
    if (isExist) {
        //
        NSError *err;
        isSuccess = [fileMgr removeItemAtPath:path error:&err];
    }
    handler(isExist, isSuccess);
}


+(BOOL)writeData:(id)data dataKey:(NSString *)dataKey fileName:(NSString *)fileName{
    NSString *path = [self getFilePath:[NSString stringWithFormat:@"%@%@",fileName,kFileType_Plist]];
    
    NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithCapacity:0];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        mdict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        if (!mdict) {
            mdict = [NSMutableDictionary dictionaryWithCapacity:0];
            
        }
    }
    [mdict setObject:data forKey:dataKey];
    BOOL isSuccess = [mdict writeToFile:path atomically:YES];
    if (isSuccess) {
        DDLog(@"isSuccess");
        
    }
    else{
        DDLog(@"isFail");
        
    }
    return isSuccess;
}

+ (id)readDataKey:(NSString *)dataKey fileName:(NSString *)fileName{
    NSString *path = [self getFilePath:[NSString stringWithFormat:@"%@%@",fileName,kFileType_Plist]];

    NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:path];
    id obj = dict[dataKey];
    return obj;

}


+ (BOOL)deleteDataKey:(NSString *)dataKey fileName:(NSString *)fileName{
    NSString *path = [self getFilePath:[NSString stringWithFormat:@"%@%@",fileName,kFileType_Plist]];
    
    NSMutableDictionary * mdict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    [mdict removeObjectForKey:dataKey];
    //移除对象之后必须重新写入
    BOOL isSuccess = [mdict writeToFile:path atomically:YES];
    if (isSuccess) {
        DDLog(@"delete__isSuccess");
        
    }
    else{
        DDLog(@"delete__isFail");
        
    }
    return isSuccess;
}

#pragma mark - -文件检索

+(void)showAllFileDirIndex:(NSUInteger)dirIndex{
    
    NSString *path = [self getFilePathIndex:dirIndex];
    DDLog(@"目录:\n%@",path);
    NSArray * filePathArr = [path componentsSeparatedByString:@"/"];
    NSString * proDir = [filePathArr lastObject];

    //tmp文件夹为空时需要处理
    NSArray *tmpList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    if ([proDir isEqualToString:@""] || tmpList.count == 0) proDir = filePathArr[filePathArr.count - 2];
    if (proDir.length > 12) proDir = [proDir substringFromIndex:proDir.length - 12];
    
    DDLog(@"-----------------------------------以下为该目录文件----------------------------------------------");
//    NSString * pathNew = path;
//    NSMutableArray * marr = [NSMutableArray arrayWithCapacity:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnumerator;
    dirEnumerator = [fileManager enumeratorAtPath:path];
    
    //列举目录内容，可以遍历子目录
    if ((path = [dirEnumerator nextObject]) != nil) {
        //path进入枚举器之后值发生变化
        do {
            DDLog(@"%@/%@",proDir,path);
            
//            NSDictionary * dict = [self filterFileType:@"air" pathPrefix:pathNew pathSuffix:path];
//            if (dict) {
//                [marr addObject:dict];
//            }
            
        } while ((path = [dirEnumerator nextObject]) != nil);
        
    }
    else{
        DDLog(@"%@",proDir);
        
    }
    DDLog(@"-----------------------------------以上为该目录文件----------------------------------------------");
//    DDLog(@"marr__%@",marr);

}

+(NSString *)getFilePathIndex:(NSUInteger)pathIndex{
    
    NSAssert(pathIndex >= 0 && pathIndex <= 3, @"0:打印全部,1:Documents,2:Library,3:tmp,索引错误");

    NSString *pathHom = NSHomeDirectory();
    NSString *pathDoc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *pathLib = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *pathTmp = NSTemporaryDirectory();
    
    
    NSArray * pathList = @[pathHom,pathDoc,pathLib,pathTmp];
    return pathList[pathIndex];
}

+(NSArray *)getAllFilterListFileType:(NSString *)fileType dirPath:(NSString *)dirPath{
    
    NSString *path = dirPath;
    DDLog(@"目录:\n%@",path);
    NSArray * filePathArr = [path componentsSeparatedByString:@"/"];
    NSString * proDir = [filePathArr lastObject];
    
    //tmp文件夹为空时需要处理
    NSArray *tmpList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    if ([proDir isEqualToString:@""] || tmpList.count == 0) proDir = filePathArr[filePathArr.count - 2];
    if (proDir.length > 12) proDir = [proDir substringFromIndex:proDir.length - 12];
    
    DDLog(@"-----------------------------------以下为该目录文件----------------------------------------------");
    NSString * pathNew = path;
    NSMutableArray * marr = [NSMutableArray arrayWithCapacity:0];
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnumerator;
    dirEnumerator = [fileManager enumeratorAtPath:path];
    
    //列举目录内容，可以遍历子目录
    if ((path = [dirEnumerator nextObject]) != nil) {
        //path进入枚举器之后值发生变化
        do {
            DDLog(@"%@/%@",proDir,path);
            
            NSDictionary * dict = [self getfilterDictFileType:fileType pathPrefix:pathNew pathSuffix:path];
            if (dict) {
                [marr addObject:dict];
            }
            
        } while ((path = [dirEnumerator nextObject]) != nil);
        
    }
    else{
        DDLog(@"%@",proDir);
        
    }
    DDLog(@"-----------------------------------以上为该目录文件----------------------------------------------");
    return (NSArray *)marr;
}

+(NSDictionary *)getfilterDictFileType:(NSString *)fileType pathPrefix:(NSString *)pathPrefix pathSuffix:(NSString *)pathSuffix{
    
    NSString * fullPath = [pathPrefix stringByAppendingPathComponent:pathSuffix];
    NSArray * array = [BNFileHandler getFileNameListType:fileType dirPath:fullPath];
    if (array.count != 0){
        NSArray * pathArr = [pathSuffix componentsSeparatedByString:@"/"];
        NSString * key = pathSuffix;
        if (pathArr.count > 0) {
            key = [pathArr lastObject];
            NSDictionary * dict = @{
                                    key:array
                                    };
            return dict;
        }
    }
    return nil;
    
}

+(NSArray *)getFileNameListType:(NSString *)type dirPath:(NSString *)dirPath{
    NSMutableArray *fileNamelist = [NSMutableArray arrayWithCapacity:10];
    NSArray *tmplist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:nil];
    
    for (NSString *filename in tmplist) {
        NSString *fullpath = [dirPath stringByAppendingPathComponent:filename];
        if ([self isFileExistAtPath:fullpath]) {
            if ([[filename pathExtension] isEqualToString:type]) {
                [fileNamelist  addObject:filename];
            }
        }
    }
    return fileNamelist;
}

+(BOOL)isFileExistAtPath:(NSString *)fileFullPath{
    BOOL isExist = NO;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath];
    return isExist;
}

@end
