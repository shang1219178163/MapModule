//
//  ErrorInfoUtility.h
//  MAMapKit_2D_Demo
//
//  Created by hanxiaoming on 16/11/30.
//  Copyright © 2016年 Autonavi. All rights reserved.
//
//高德地图专用
#import <Foundation/Foundation.h>

@interface ErrorInfoUtility : NSObject

+ (NSString *)errorDescriptionWithCode:(NSInteger)errorCode;

@end
