//
//  MainViewController.m
//  Location
//
//  Created by hsf on 2017/12/22.
//  Copyright © 2017年 Location. All rights reserved.
//

#import "TrackRecordsController.h"

#import "BNEmail.h"
#import "LocationTracker.h"

@interface TrackRecordsController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * titleMarr;

@property (nonatomic, strong) UILabel * label;
@property (nonatomic, strong) BNEmail * emailVC;

@end

@implementation TrackRecordsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Main";
    self.view.backgroundColor = [UIColor cyanColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(handleActionBtn)];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.label;
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleNoti:) name:kNotiPostNameLocationOld object:nil];
    
    [self addChildViewController:self.emailVC];
    
}

-(void)handleActionBtn{
    NSDictionary * dic = @{
                            kEmail_Title : @"测试邮件Title",
                            kEmail_Subject : @"邮件Subject",
                            kEmail_Body : self.titleMarr.description,
                            kEmail_Recipients:@[@"1219176600@qq.com"]
                            };
    
    NSError * error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
    if (error) {
        DDLog(@"%@", error.localizedDescription);
        return;
    }
    NSDictionary *attachDict = @{
                                  kEmail_attachData:data,
                                  kEmail_attachFilName:@"日志.doc",
                                  };
    [self.emailVC sendEmailDict:dic attachmentDict:attachDict];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
    [self.tableView reloadData];
    
}

-(void)handleNoti:(NSNotification *)noti{
    NSLog(@"=============_%@_%@",noti.name,noti.object);
    
    [self.titleMarr insertObject:noti.object atIndex:0];
    self.label.text = [NSString stringWithFormat:@"    总共%@条数据",@(self.titleMarr.count)];

    [self.tableView reloadData];

}

#pragma mark - - tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleMarr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellIdentifier = @"cell";
    UITableViewCell * cell = [UITableViewCell cellWithTableView:tableView identifier:cellIdentifier style:UITableViewCellStyleSubtitle];
    
    NSDictionary * dict = self.titleMarr[indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"row%@_(%@,%@)",@(indexPath.row),dict[keyLocationLatitude],dict[keyLocationLongitude]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[NSDateFormatter stringFromInterval:dict[keyLocationTimeStamp] fmt:kFormatDate]];
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];

    UIView * backgroudView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(cell.frame),  CGRectGetHeight(cell.frame))];
    backgroudView.backgroundColor = [UIColor cyanColor];
    cell.selectedBackgroundView = backgroudView;
    
    //    NSLog(@"cell-%ld",(long)indexPath.row);
    [cell getViewLayer];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dict = self.titleMarr[indexPath.row];
    NSLog(@"dict__%@",dict);

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -lazy
-(BNEmail *)emailVC{
    if (!_emailVC) {
        _emailVC = [[BNEmail alloc]init];
        
    }
    return _emailVC;
}

-(NSMutableArray *)titleMarr{
    if (!_titleMarr) {
        _titleMarr = [NSMutableArray array];
    }
    return _titleMarr;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;//确保TablView能够正确的调整大小
        
        //        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [UIColor greenColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
    }
    return _tableView;
}

-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        _label.text = [NSString stringWithFormat:@"    总共%@条数据",@(0)];
        _label.backgroundColor = [UIColor greenColor];
    }
    return _label;
}

@end
