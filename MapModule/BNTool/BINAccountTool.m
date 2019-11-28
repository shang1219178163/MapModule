//
//  BINAccountTool.m
//  
//
//  Created by BIN on 2017/8/23.
//  Copyright © 2017年 SHANG. All rights reserved.
//

#import "BINAccountTool.h"
#import "KeychainTool.h"

@implementation BINAccountTool

static NSString * const KEY_KeyChainUserAccount = @"com.whkj.whb.account";
static NSString * const KEY_KeyChainUserName= @"com.whkj.whb.userid";
static NSString * const KEY_KeyChainUserPwd = @"com.whkj.whb.password";

+(void)saveUserName:(NSString *)name
{
    NSMutableDictionary *userAccountDict = [NSMutableDictionary dictionary];
    [userAccountDict setObject:name forKey:KEY_KeyChainUserName];
    [KeychainTool save:KEY_KeyChainUserAccount data:userAccountDict];
}

+(void)saveUserPassword:(NSString *)password
{
    NSMutableDictionary *userAccountDict = [NSMutableDictionary dictionary];
    [userAccountDict setObject:password forKey:KEY_KeyChainUserPwd];
    [KeychainTool save:KEY_KeyChainUserAccount data:userAccountDict];
}

+(id)readUserName
{
    NSMutableDictionary *userAccountDict = (NSMutableDictionary *)[KeychainTool load:KEY_KeyChainUserAccount];
    return [userAccountDict objectForKey:KEY_KeyChainUserName];
}
+(id)readUserPassWord
{
    NSMutableDictionary *userAccountDict = (NSMutableDictionary *)[KeychainTool load:KEY_KeyChainUserAccount];
    return [userAccountDict objectForKey:KEY_KeyChainUserPwd];
}

+(void)deleteUserPassWord
{
    [KeychainTool delete:KEY_KeyChainUserPwd];
}

+(void)deleteUserAccount
{
    [KeychainTool delete:KEY_KeyChainUserAccount];
}
@end
