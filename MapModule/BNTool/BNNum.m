//
//  BNNum.m
//  
//
//  Created by BIN on 2017/12/21.
//  Copyright © 2017年 SHANG. All rights reserved.
//

#import "BNNum.h"


@interface BNNum ()

@property (nonatomic, strong) NSNumberFormatter *numFormatter;

@end

@implementation BNNum


-(NSNumberFormatter *)numFormatter{
    if (!_numFormatter) {
        _numFormatter = [[NSNumberFormatter alloc] init];
        
    }
    return _numFormatter;
}

- (NSString *)numberSeparator:(NSString *)groupSparator groupSize:(NSUInteger)groupSize number:(NSNumber *)number type:(NSString *)type{
    
    self.numFormatter.groupingSize = groupSize;
    self.numFormatter.groupingSeparator = groupSparator;
    self.numFormatter.usesGroupingSeparator = YES;
    
    if ([[number stringValue] containsString:@"."]) {
        self.numFormatter.minimumFractionDigits = 2;
        self.numFormatter.roundingMode = NSNumberFormatterRoundCeiling;
        
    }
    
    switch ([type integerValue]) {
        case 0:
        {
            return [self.numFormatter stringFromNumber:number];
            
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            
        }
            break;
        default:
            break;
    }
    return nil;
}

//格式话小数 四舍五入类型
- (NSString *)decimalWithFormat:(NSString *)format floatV:(double)floatV{
    
    //677789.98
    //    self.numFormatter.positiveFormat = @",###.00";//输出：677，789.98
    //    self.numFormatter.positiveFormat = @".00;";//输出：677789.98
    //    self.numFormatter.positiveFormat = @"0%;";//输出：67778998%
    //    self.numFormatter.positiveFormat = @"0.00%;";//输出：67778998.00%
    
    //    self.numFormatter.positiveFormat = format;
    
    if (format) {
        self.numFormatter.positiveFormat = format;

    } else {
        self.numFormatter.minimumFractionDigits = 2;
        self.numFormatter.roundingMode = NSNumberFormatterRoundCeiling;
        
    }
   
    NSString *result = [self.numFormatter stringFromNumber:@(floatV)];
    return  result;
}


@end
