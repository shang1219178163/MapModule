//
//  BNNum.h
//  
//
//  Created by BIN on 2017/12/21.
//  Copyright © 2017年 SHANG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNNum : NSObject

- (NSString *)numberSeparator:(NSString *)groupSparator groupSize:(NSUInteger)groupSize number:(NSNumber *)number type:(NSString *)type;

- (NSString *)decimalWithFormat:(NSString *)format floatV:(double)floatV;

@end
