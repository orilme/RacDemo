//
//  RACNetWorkExampleVC.m
//  ReactiveObjCDemo
//
//  Created by orilme on 2018/12/5.
//  Copyright © 2018年 orilme. All rights reserved.
//

#import "RACNetWorkExampleVC.h"
#import "ReactiveObjC.h"
#import "RACRequestViewModel.h"

@interface RACNetWorkExampleVC ()
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) RACRequestViewModel *requesViewModel;
@end

@implementation RACNetWorkExampleVC

- (RACRequestViewModel *)requesViewModel {
    if (_requesViewModel == nil) {
        _requesViewModel = [[RACRequestViewModel alloc] init];
    }
    return _requesViewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 创建tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.dataSource = self.requesViewModel;
    
    [self.view addSubview:tableView];
    
    // 执行请求
    RACSignal *requesSiganl = [self.requesViewModel.reuqesCommand execute:nil];
    
    // 获取请求的数据
    [requesSiganl subscribeNext:^(NSArray *x) {
        self.requesViewModel.models = x;
        [self.tableView reloadData];
    }];
    
}

@end
