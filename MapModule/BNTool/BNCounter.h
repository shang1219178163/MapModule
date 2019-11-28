//
//  BNCounter.h
//  BNCounterDemo
//
//  Created by FDC-iOS on 2017/4/21.
//  Copyright © 2017年 meilun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSInteger kCounterLabTag = 3600;

@interface BNCounter : NSObject

@property (nonatomic, strong) dispatch_source_t       timer;
@property (nonatomic, strong) UITableView             *tableView;
@property (nonatomic, strong) NSArray                 *dataList;
@property (nonatomic, assign) NSInteger               less;


- (void)destoryTimer;

///每秒走一次，回调block
- (instancetype)initWithTable:(UITableView *)tableView;

/// 滑动过快的时候时间不会闪  (tableViewcell数据源方法里实现即可)
- (NSString *)countDownWithPerSec:(NSIndexPath *)indexPath;

- (instancetype)initWith :(UITableView*)tableView :(NSArray*)dataList;

@property (nonatomic,assign)BOOL isPlusTime;

//+(instancetype)shared;
//
//+(void)destoryShared;

@end
