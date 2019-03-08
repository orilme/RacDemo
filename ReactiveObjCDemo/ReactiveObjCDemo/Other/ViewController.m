//
//  ViewController.m
//  ReactiveObjCDemo
//
//  Created by orilme on 2018/12/4.
//  Copyright © 2018年 orilme. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+ORStoryboard.h"
#import "ReactiveObjC.h"
#import "RACSubjectVC.h"

@interface ViewController ()
@property (nonatomic, copy) NSArray *meunArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    self.meunArr = @[@"RACOneVC", @"RACTwoVC", @"RACSubjectVC", @"RACOrderVC", @"RACCommandVC", @"RACMulticastConnectionVC", @"RACMacroVC", @"RACExampleOneVC", @"RACBindMethodVC", @"RACMapMethodVC", @"RACCombineMethodVC", @"RACFilterMethodVC", @"RACOrderMethodVC", @"RACTimeMethodVC", @"RACRepeatMethodVC", @"RACSchedulerMethodVC", @"LoginExampleVC", @"RACNetWorkExampleVC"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.meunArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text =  self.meunArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.meunArr[indexPath.row] isEqualToString:@"RACSubjectVC"]) {
        RACSubjectVC *vc = RACSubjectVC.orilme_viewController;
        vc.title = self.meunArr[indexPath.row];
        // 设置代理信号
        vc.delegateSignal = [RACSubject subject];
        // 订阅代理信号
        [vc.delegateSignal subscribeNext:^(id x) {
            NSLog(@"点击了通知按钮");
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        UIViewController *vc = NSClassFromString(self.meunArr[indexPath.row]).orilme_viewController;
        vc.title = self.meunArr[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

ORStoryboard(ViewController)

@end
