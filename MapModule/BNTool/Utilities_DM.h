//
//  Utilities_DM.h
//  
//
//  Created by BIN on 2017/12/13.
//  Copyright © 2017年 SHANG. All rights reserved.
//

//Utilities_DM

/**
 多媒体方法基地,视频,图片等
 */


#import <Foundation/Foundation.h>

@interface Utilities_DM : NSObject

+ (BOOL)hasAccessRightOfPhotosLibrary;

+ (BOOL)hasAccessRightOfCameraUsage;

+ (BOOL)hasAccessRightOfAVCapture;

+ (BOOL)imageOne:(UIImage *)image equelToImageTwo:(NSString *)imageStr;

//待试用
- (UIImage *)getThumbnailFromImage:(UIImage *)image size:(CGSize)size;

//1.自动缩放到指定大小
+ (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize;

//2.保持原来的长宽比，生成一个缩略图
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;

//递归缩小压缩系数
+ (UIImage *)compressImage:(UIImage *)image maxFileSize:(NSInteger)maxFileSize;

//压缩后imageData
+ (NSData *)compressImageDataFromImage:(UIImage *)image maxFileSize:(NSInteger)maxFileSize;

//压缩到固定大小
+ (UIImage *)compressImageWithImage:(UIImage *)image toFileSize:(CGFloat)fileSize;

//图片二进制数据的base64编码
+ (NSString *)stringBase64FromImage:(UIImage *)image maxFileSize:(NSInteger)maxFileSize;

/**
 通过图片Data数据第一个字节 来获取图片扩展名
 */
+ (NSString *)contentTypeForImageData:(NSData *)data;

/**
 保证图片清晰度,先压缩图片质量。如果要使图片一定小于指定大小，压缩图片尺寸可以满足。对于后一种需求，还可以先压缩图片质量，如果已经小于指定大小，就可得到清晰的图片，否则再压缩图片尺寸。
 
 @param image 图片
 @param maxLength 文件大小
 @return uiimage
 */
+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;


+ (id)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength type:(NSString *)type;

- (id)imageWithOriImage:(UIImage *)image type:(NSString *)type;

#pragma mark - -文件管理

+ (BOOL)fileExistAtPath:(NSString *)path;

+ (BOOL)createDirectoryAtPath:(NSString *)path;

@end
