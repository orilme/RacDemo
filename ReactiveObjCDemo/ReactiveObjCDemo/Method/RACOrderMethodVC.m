//
//  RACOrderMethodVC.m
//  ReactiveObjCDemo
//
//  Created by orilme on 2018/12/4.
//  Copyright © 2018年 orilme. All rights reserved.
//

#import "RACOrderMethodVC.h"
#import "ReactiveObjC.h"

@interface RACOrderMethodVC ()

@end

@implementation RACOrderMethodVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self sequence];
}

- (void)sequence {
    // doNext: 执行Next之前，会先执行这个Block
    // doCompleted: 执行sendCompleted之前，会先执行这个Block
    [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return nil;
    }] doNext:^(id x) {
        // 执行[subscriber sendNext:@1];之前会调用这个Block
        NSLog(@"sequence---doNext");;
    }] doCompleted:^{
        // 执行[subscriber sendCompleted];之前会调用这个Block
        NSLog(@"sequence---doCompleted");;
    }] subscribeNext:^(id x) {
        NSLog(@"sequence---%@", x);
    }];
}

@end
