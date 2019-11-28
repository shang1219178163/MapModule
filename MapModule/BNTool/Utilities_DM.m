//
//  Utilities_DM.m
//  
//
//  Created by BIN on 2017/12/13.
//  Copyright © 2017年 SHANG. All rights reserved.
//

#import "Utilities_DM.h"

#import "NNGloble.h"
#import <Photos/Photos.h>
#import "UIApplication+Helper.h"
#import "UIWindow+Helper.h"

@implementation Utilities_DM

+ (BOOL)hasAccessRightOfPhotosLibrary{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        //无权限
        return NO;
    }
    return YES;
}
+ (BOOL)hasAccessRightOfCameraUsage{
    //相机权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus ==AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
        authStatus ==AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
    {
        return NO;
        
    }
    return YES;
}

+ (BOOL)hasAccessRightOfAVCapture{
    
   __block BOOL isHasRight = NO;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        isHasRight = YES;
                        DDLog(@"用户第一次同意了访问相机权限 - - %@", NSThread.currentThread);
                    } else {
                        DDLog(@"用户第一次拒绝了访问相机权限 - - %@", NSThread.currentThread);
                    }
                }];
                break;
            }
            case AVAuthorizationStatusAuthorized: {
                isHasRight = YES;
                break;
            }
            case AVAuthorizationStatusDenied: {
                NSString * msg = [NSString stringWithFormat:@"请去-> [设置 - 隐私 - 相机 - %@] 打开访问开关",UIApplication.appName];
               [UIWindow showToastWithTips:msg place:@1];

                break;
            }
            case AVAuthorizationStatusRestricted: {
                NSString * msg = @"因为系统原因, 无法访问相册";
               [UIWindow showToastWithTips:msg place:@1];
                break;
            }
            default:
                break;
        }
    }
    return isHasRight;
}

+ (BOOL)imageOne:(UIImage *)image equelToImageTwo:(NSString *)imageStr{
    NSData *imgDataDefault = UIImageJPEGRepresentation([UIImage imageNamed:imageStr], 0.1);
    NSData *imgData = UIImageJPEGRepresentation(image, 0.1);
    if ([imgData isEqualToData:imgDataDefault]) {
        
        return YES;
    }
    return NO;
    
}

//待试用
- (UIImage *)getThumbnailFromImage:(UIImage *)image size:(CGSize)size{
    
    CGSize originImageSize = image.size;
    CGSize newSize = CGSizeMake(40,40);
    if (!CGSizeEqualToSize(size, CGSizeZero)) {
        newSize.width = size.width;
        newSize.height = size.height;
    }
    
    //根据当前屏幕scaling factor创建一个透明的位图图形上下文(此处不能直接从UIGraphicsGetCurrentContext获取,原因是UIGraphicsGetCurrentContext获取的是上下文栈的顶,在drawRect:方法里栈顶才有数据,其他地方只能获取一个nil.详情看文档)
    UIGraphicsBeginImageContextWithOptions(newSize,NO,0.0);
    //保持宽高比例,确定缩放倍数
    //(原图的宽高做分母,导致大的结果比例更小,做MAX后,ratio*原图长宽得到的值最小是40,最大则比40大,这样的好处是可以让原图在画进40*40的缩略矩形画布时,origin可以取=(缩略矩形长宽减原图长宽*ratio)/2 ,这样可以得到一个可能包含负数的origin,结合缩放的原图长宽size之后,最终原图缩小后的缩略图中央刚好可以对准缩略矩形画布中央)
    float ratio = MAX(newSize.width/ originImageSize.width, newSize.height/ originImageSize.height);
    
    //创建一个圆角的矩形UIBezierPath对象
    CGRect newRect = CGRectMake(0,0, newSize.width, newSize.height);
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    //用Bezier对象裁剪上下文
    [path addClip];
    
    //让image在缩略图范围内居中()
    CGRect projectRect;
    projectRect.size.width = originImageSize.width* ratio;
    projectRect.size.height= originImageSize.height* ratio;
    projectRect.origin.x = (newSize.width - projectRect.size.width) /2.0;
    projectRect.origin.y = (newSize.height - projectRect.size.height) /2.0;
    
    //在上下文中画图
    [image drawInRect:projectRect];
    //从图形上下文获取到UIImage对象,赋值给thumbnai属性
    UIImage * smallImg = UIGraphicsGetImageFromCurrentImageContext();
    //清理图形上下文(用了UIGraphicsBeginImageContext需要清理)
    UIGraphicsEndImageContext();
    
    return smallImg;
}

//1.自动缩放到指定大小
+ (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize{
    UIImage *newimage;
    if (!image) {
        newimage = nil;
        
    }
    else{
        UIGraphicsBeginImageContext(asize);
        [image drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
    
}

//2.保持原来的长宽比，生成一个缩略图
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize{
    UIImage *newimage;
    if (!image) {
        newimage = nil;
        
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            
            rect.size.width = asize.height * oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
            
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width * oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
            
        }
        
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, UIColor.clearColor.CGColor);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
    
}

#pragma mark 调整图片分辨率/尺寸（等比例缩放）
- (UIImage *)newSizeImage:(CGSize)size image:(UIImage *)source_image {
    CGSize newSize = CGSizeMake(source_image.size.width, source_image.size.height);
    
    CGFloat tempHeight = newSize.height / size.height;
    CGFloat tempWidth = newSize.width / size.width;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(source_image.size.width / tempWidth, source_image.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(source_image.size.width / tempHeight, source_image.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [source_image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark 二分法
- (NSData *)halfFuntion:(NSArray *)arr image:(UIImage *)image sourceData:(NSData *)finallImageData maxSize:(NSInteger)maxSize {
    NSData *tempData = [NSData data];
    NSUInteger start = 0;
    NSUInteger end = arr.count - 1;
    NSUInteger index = 0;
    
    NSUInteger difference = NSIntegerMax;
    while(start <= end) {
        index = start + (end - start)/2;
        
        finallImageData = UIImageJPEGRepresentation(image,[arr[index] floatValue]);
        
        NSUInteger sizeOrigin = finallImageData.length;
        NSUInteger sizeOriginKB = sizeOrigin / 1024;
        DDLog(@"当前降到的质量：%ld", (unsigned long)sizeOriginKB);
        DDLog(@"%lu----%lf", (unsigned long)index, [arr[index] floatValue]);
        
        if (sizeOriginKB > maxSize) {
            start = index + 1;
        } else if (sizeOriginKB < maxSize) {
            if (maxSize-sizeOriginKB < difference) {
                difference = maxSize-sizeOriginKB;
                tempData = finallImageData;
            }
            end = index - 1;
        } else {
            break;
        }
    }
    return tempData;
}

+ (UIImage *)compressImage:(UIImage *)image maxFileSize:(NSInteger)maxFileSize {
    CGFloat compression = 1.0f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    DDLog(@"压缩后图片大小:%luK",[imageData length]/1024);
    
    UIImage *compresseImage = [UIImage imageWithData:imageData];
    return compresseImage;
}

+ (NSData *)compressImageDataFromImage:(UIImage *)image maxFileSize:(NSInteger)maxFileSize {
    CGFloat compression = 1.0f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    //    DDLog(@"压缩后图片大小:%luK",[imageData length]/1024);
    return imageData;
}


+ (UIImage *)compressImageWithImage:(UIImage *)image toFileSize:(CGFloat)fileSize{
    NSData * orginImageData = UIImageJPEGRepresentation(image, 1.0f);
    CGFloat orignImageDataSize = [orginImageData length]/1024;
    CGFloat yasuolv = fileSize/orignImageDataSize;//压缩到fileSize
    
    if (yasuolv<0.1) {
        yasuolv = 0.1;
    }
    NSString * yasuolvString = [NSString stringWithFormat:@"%0.1f",yasuolv];
    
    NSData * yasuoImageData = UIImageJPEGRepresentation(image, [yasuolvString floatValue]);
    UIImage *compressImage = [UIImage imageWithData:yasuoImageData];
    
    //大小
    NSData * oneImageData = UIImageJPEGRepresentation(compressImage, 0.1f);
    DDLog(@"压缩后图片大小:%luK",[oneImageData length]/1024);
    return compressImage;
}

+ (NSString *)stringBase64FromImage:(UIImage *)image maxFileSize:(NSInteger)maxFileSize {
    CGFloat compression = 1.0f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    DDLog(@"压缩后图片大小:%luK",[imageData length]/1024);
    NSString *encodedImageStr = [imageData base64EncodedStringWithOptions:0];
    return encodedImageStr;
}

//通过图片Data数据第一个字节 来获取图片扩展名
+ (NSString *)contentTypeForImageData:(NSData *)data{
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            if ([data length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            return nil;
    }
    return nil;
}

+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (NSInteger i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        }
        else if (data.length > maxLength) {
            max = compression;
        }
        else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return resultImage;
}


+ (id)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength type:(NSString *)type{
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (NSInteger i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        }
        else if (data.length > maxLength) {
            max = compression;
        }
        else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
        DDLog(@"data.length__:%luK",data.length);
        
    }
    
    //
    NSData *imageData ;
    if (!UIImagePNGRepresentation(resultImage)) {
        imageData = UIImageJPEGRepresentation(resultImage, 1.0);
    }
    else{
        imageData = UIImagePNGRepresentation(resultImage);
    }
    DDLog(@"压缩后图片大小____:%luK",[imageData length]/1024);
    
    id imageNew = resultImage;
    switch ([type integerValue]) {
        case 1:
        {
            imageNew = imageData;
        }
            break;
        case 2:
        {
            imageNew = [imageData base64EncodedStringWithOptions:0];
            
        }
            break;
        default:
            imageNew = resultImage;
            break;
    }
    return imageNew;
}

+ (BOOL)fileExistAtPath:(NSString *)path{
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    BOOL isExist = [fileManager fileExistsAtPath:path];
    return isExist;
}

+ (BOOL)createDirectoryAtPath:(NSString *)path{
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    if ([fileManager fileExistsAtPath:path]) {
        return YES;
    }
    BOOL isSuccess = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    return isSuccess;
}


@end
