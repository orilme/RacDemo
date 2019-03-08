//
//  RACRepeatMethodVC.m
//  ReactiveObjCDemo
//
//  Created by orilme on 2018/12/4.
//  Copyright © 2018年 orilme. All rights reserved.
//

#import "RACRepeatMethodVC.h"
#import "ReactiveObjC.h"

@interface RACRepeatMethodVC ()

@end

@implementation RACRepeatMethodVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    // retry重试 ：只要失败，就会重新执行创建信号中的block,直到成功
    [self retry];
    
    // replay(重放)：当一个信号被多次订阅,反复播放内容
    [self replay];
    
    // throttle节流:当某个信号发送比较频繁时，可以使用节流，在某一段时间不发送信号内容，过了一段时间获取信号的最新内容发出
    [self throttle];
}

- (void)retry {
    __block int i = 0;
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if (i == 10) {
            [subscriber sendNext:@1];
        }else{
            NSLog(@"retry---接收到错误");
            [subscriber sendError:nil];
        }
        i++;
        return nil;
    }] retry] subscribeNext:^(id x) {
        NSLog(@"retry---%@",x);
    } error:^(NSError *error) {
        
    }];
}

- (void)replay {
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        return nil;
    }] replay];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"replay---第一个订阅者%@",x);
    }];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"replay---第二个订阅者%@",x);
    }];
}

- (void)throttle {
    RACSubject *signal = [RACSubject subject];
    // 节流，在一定时间（4秒）内，不接收任何信号内容，过了这个时间（1秒）获取最后发送的信号内容发出。
    [[signal throttle:2] subscribeNext:^(id x) {
        NSLog(@"throttle---%@",x);
    }];
}

@end
