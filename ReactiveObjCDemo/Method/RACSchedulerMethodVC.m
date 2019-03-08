//
//  RACSchedulerMethodVC.m
//  ReactiveObjCDemo
//
//  Created by orilme on 2018/12/9.
//  Copyright © 2018年 orilme. All rights reserved.
//

#import "RACSchedulerMethodVC.h"
#import "ReactiveObjC.h"

@implementation RACSchedulerMethodVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self deliverOn];
    [self subscribeOn];
}

-(void)deliverOn {
    // 创建信号
    RACSignal * signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"deliverOn,sendTestSignal---%@", [NSThread currentThread]);
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
        }];
    }];
    
    // 要想放在主线程执行只要将[RACScheduler scheduler]更换为[RACScheduler mainThreadScheduler]
    [[signal deliverOn:[RACScheduler scheduler]] subscribeNext:^(id x) {
        NSLog(@"deliverOn,receiveSignal---%@", [NSThread currentThread]);
    }];
}

- (void)subscribeOn {
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"subscribeOn,sendSignal---%@", [NSThread currentThread]);
        [subscriber sendNext:@1];
        return [RACDisposable disposableWithBlock:^{
        }];
    }] subscribeOn:[RACScheduler scheduler]] subscribeNext:^(id x) {
        NSLog(@"subscribeOnreceiveSignal---%@", [NSThread currentThread]);
    }];
}

@end
