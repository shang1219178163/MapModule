//
//  BINAccountTool.h
//  
//
//  Created by BIN on 2017/8/23.
//  Copyright © 2017年 SHANG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BINAccountTool : NSObject

+(void)saveUserName:(NSString *)name;
+(void)saveUserPassword:(NSString *)password;

+(id)readUserName;
+(id)readUserPassWord;

+(void)deleteUserPassWord;
+(void)deleteUserAccount;

@end
