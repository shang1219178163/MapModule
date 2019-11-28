//
//  BNCounter.m
//  BNCounterDemo
//
//  Created by FDC-iOS on 2017/4/21.
//  Copyright © 2017年 meilun. All rights reserved.
//

#import "BNCounter.h"
#import "NNCategoryPro.h"

@implementation BNCounter 

- (instancetype)initWithTable:(UITableView *)tableView{
    self = [super init];
    if (self) {
        _tableView = tableView;
        
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(setupLess) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

-(void)setDataList:(NSArray *)dataList{
    _dataList = dataList;
    [_tableView reloadData];
    [self setupLess];
   
}

- (void)setupLess {
    NSString *path = @"http://api.k780.com:88/?app=life.time&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5];
    request.HTTPMethod = @"POST";
    request.HTTPMethod = @"GET";

    NSURLSessionDataTask *dataTask = [NSURLSession.sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSString * webCurrentTimeStr = responseObject[@"result"][@"timestamp"];
            NSInteger webCurrentTime = webCurrentTimeStr.longLongValue;
            NSInteger nowTimeStamp = NSDate.date.timeIntervalSince1970;
            _less = nowTimeStamp - webCurrentTime;
            NSLog(@" --  与服务器时间的差值 -- %zd",_less);
            
            if (_dataList.count > 0) {
                [self destoryTimer];
                [self counterWithTableView:_tableView :_dataList];
            }
        }
    }];
    [dataTask resume];
    
}

- (void)counterWithTableView:(UITableView *)tableView :(NSArray *)dataList {
    _tableView = tableView;
    _dataList = dataList;
    self.timer = [NSTimer createGCDTimer:60 repeats:true block:^{
        for (UITableViewCell * cell in tableView.visibleCells) {
            NSString* tmpEndTime = [dataList.firstObject isKindOfClass:[NSArray class]] ? dataList[cell.tag/100][cell.tag%100] : dataList[cell.tag];

            for (UIView * labText in cell.contentView.subviews) {
                if (labText.tag == kCounterLabTag) {
                    UILabel * textLabel = (UILabel *)labText;
                    NSInteger endTime = tmpEndTime.longLongValue + _less;
                    textLabel.text = [self showTimeInfoWithEndTime:endTime];
                    
                }
            }
        }
    }];
}

/// 滑动过快的时候不会闪
- (NSString *)countDownWithPerSec:(NSIndexPath *)indexPath{
    NSString* endTimeStr = [_dataList.firstObject isKindOfClass:[NSArray class]] ? _dataList[indexPath.section][indexPath.row] : _dataList[indexPath.row];

    NSInteger endTime = endTimeStr.longLongValue + _less;
    return [self showTimeInfoWithEndTime:endTime];
}

// 传入结束时间 | 计算与当前时间的差值
-(NSString *)showTimeInfoWithEndTime:(NSInteger )endtime{
    NSTimeInterval nowTimeStamp = NSDate.date.timeIntervalSince1970;
    NSTimeInterval timeInterval = endtime - nowTimeStamp;
    
    int days = (int)(timeInterval/(3600*24));
    int hours = (int)((timeInterval - days*24*3600)/3600);
    int minutes = (int)(timeInterval - days*24*3600 - hours*3600)/60;
    int seconds = timeInterval - days*24*3600 - hours*3600 - minutes*60;
    
    if (self.isPlusTime) {
        if (hours >= 0 && minutes >= 0 && seconds >= 0) return @"活动尚未开始！";//截止时间小于当前时间
        hours = -hours;
        minutes = -minutes;
        seconds = -seconds;
    }
    else{
        if (hours <= 0 && minutes <= 0 && seconds <= 0) return @"活动已经结束！";
        
    }
    NSString * daysInfo = days > 0 ? [[@(days) stringValue] stringByAppendingString:@"天"] : @"";
    return [NSString stringWithFormat:@"%@ %@小时 %@分 %@秒", daysInfo,@(hours),@(minutes),@(seconds)];
}

/**
 *  主动销毁定时器
 */
-(void)destoryTimer{
    [NSTimer destoryTimer:self.timer];

}

-(void)dealloc{
    NSLog(@"%s dealloc",object_getClassName(self));
    
}

//static BNCounter * _instance = nil;
//static dispatch_once_t onceToken;
//+(instancetype)shared{
//    dispatch_once(&onceToken, ^{
//        _instance = [[self alloc]init];
//    });
//    return _instance;
//}
//+(void)destoryShared{
//    _instance = nil;
//    onceToken = 0;
//    
//}

@end
