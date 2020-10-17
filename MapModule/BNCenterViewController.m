
//
//  BNCenterViewController.m
//  ProductTemplet
//
//  Created by BIN on 2018/5/21.
//  Copyright © 2018年 BN. All rights reserved.
//

#import "BNCenterViewController.h"

@interface BNCenterViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, strong) NNTablePlainView *plainView;

@end

@implementation BNCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tbView.backgroundColor = UIColor.whiteColor;
//    [self.view addSubview:self.tableView];
    [self.view addSubview:self.plainView];

    self.view.backgroundColor = UIColor.yellowColor;
    [self createBarItem:@"筛选" isLeft:false handler:^(id obj, UIView *item, NSInteger idx) {
  
    }];

    self.dataList = @[@[@"PKMainController", @"高德地图轨迹回溯",],
                      @[@"NNMapViewController", @"系统相关",],
                      @[@"TrackRecordsController", @"后台二十四小时定时定位",],
                      
                      ].mutableCopy;
    
    self.plainView.list = self.dataList;
    [self.plainView.tableView reloadData];
    
    [self setupSearchBar];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.plainView.frame = self.view.bounds;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -funtions
- (void)setupSearchBar {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [UIApplication setupAppearanceSearchbarCancellButton];
    self.searchBar = ({
        UISearchBar *searchBar = [UISearchBar createRect:CGRectMake(0, 0, kScreenWidth - 100, 30)];
        searchBar.placeholder = @"请输入流水号、商品信息或会员信息";
        searchBar.delegate = self;
//        searchBar.scopeButtonTitles = @[@"111", @"22", @"333"];
//        searchBar.showsScopeBar = true;
//        searchBar.showsBookmarkButton = true;
        searchBar;
    });
    
    //Set to titleView
    self.navigationItem.titleView = ({
        UIView *titleView = [[UIView alloc]initWithFrame:self.searchBar.bounds];
        //UIColor *color =  self.navigationController.navigationBar.tintColor;
        //[titleView setBackgroundColor:color];
        [titleView addSubview:self.searchBar];
        
        titleView;
    });
}

#pragma mark -UISearchBar

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return true;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return true;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    DDLog(@"%@1", searchBar.text);
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    DDLog(@"%@", searchBar.text);
    
    return true;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    DDLog(@"%@", searchBar.text);
    
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    DDLog(@"%@", searchBar.text);
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    DDLog(@"%@", searchBar.text);
    
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{
    DDLog(@"%@", searchBar.text);
    
}


#pragma mark -lazy

- (NNTablePlainView *)plainView{
    if (!_plainView) {
        _plainView = [[NNTablePlainView alloc]initWithFrame:self.view.bounds];
        _plainView.tableView.rowHeight = 70;
        
        @weakify(self);
        _plainView.blockCellForRow = ^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            @strongify(self);
            NSArray * list = self.dataList[indexPath.row];

            static NSString * identifier = @"UITableViewCell1";
            //    UITableViewOneCell * cell = [UITableViewOneCell cellWithTableView:tableView];
            UITableViewCell * cell = [UITableViewCell cellWithTableView:tableView identifier:identifier style:UITableViewCellStyleSubtitle];
            cell.textLabel.text = list[1];
            cell.textLabel.textColor = UIColor.themeColor;
            
            cell.detailTextLabel.text = list[0];
            cell.detailTextLabel.textColor = UIColor.grayColor;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        };
        
        _plainView.blockDidSelectRow = ^(UITableView *tableView, NSIndexPath *indexPath) {
            @strongify(self);
            NSArray * list = self.dataList[indexPath.row];
            //    [self goController:list.lastObject title:list.firstObject];
            UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            [self pushController:list[0] title:list[1] item:cell type:@0];
        };
    }
    return _plainView;
}

@end

