//
//  RACTimeMethodVC.m
//  ReactiveObjCDemo
//
//  Created by orilme on 2018/12/4.
//  Copyright © 2018年 orilme. All rights reserved.
//

#import "RACTimeMethodVC.h"
#import "ReactiveObjC.h"

@interface RACTimeMethodVC ()

@end

@implementation RACTimeMethodVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    // timeout：超时，可以让一个信号在一定的时间后，自动报错
    [self timeout];
    
    // interval 定时：每隔一段时间发出信号
    //[self interval];
    
    // delay 延迟发送next
    [self delay];
}

- (void)timeout {
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        return nil;
    }] timeout:1 onScheduler:[RACScheduler currentScheduler]];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"timeout---%@", x);
    } error:^(NSError *error) {
        // 1秒后会自动调用
        NSLog(@"timeout---%@", error);
    }];
}

- (void)interval {
    [[RACSignal interval:1 onScheduler:[RACScheduler currentScheduler]] subscribeNext:^(id x) {
        NSLog(@"interval---%@", x);
    }];
}

- (void)delay {
    RACSignal *signal = [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        return nil;
    }] delay:2] subscribeNext:^(id x) {
        NSLog(@"delay---%@", x);
    }];
}

@end
