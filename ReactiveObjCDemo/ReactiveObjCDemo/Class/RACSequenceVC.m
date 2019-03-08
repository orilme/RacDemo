//
//  RACSequenceVC.m
//  ReactiveObjCDemo
//
//  Created by orilme on 2018/12/4.
//  Copyright © 2018年 orilme. All rights reserved.
//

#import "RACSequenceVC.h"
#import "UIViewController+ORStoryboard.h"
#import "ReactiveObjC.h"

@interface RACSequenceVC ()

@end

@implementation RACSequenceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 1.遍历数组
    [self sequenceArray];
    // 2.遍历字典
    [self sequenceDictionary];
    // 3.字典转模型 待写
}

- (void)sequenceArray {
    NSArray *numbers = @[@1, @2, @3, @4];
    // 这里其实是三步
    // 第一步: 把数组转换成集合RACSequence numbers.rac_sequence
    // 第二步: 把集合RACSequence转换RACSignal信号类,numbers.rac_sequence.signal
    // 第三步: 订阅信号，激活信号，会自动把集合中的所有值，遍历出来。
    [numbers.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"遍历数组---%@", x);
    }];
}

- (void)sequenceDictionary {
    // 2.遍历字典,遍历出来的键值对会包装成RACTuple(元组对象)
    NSDictionary *dict = @{@"name":@"xmg", @"age":@18};
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
        RACTupleUnpack(NSString *key, NSString *value) = x;
        // 相当于以下写法
        //NSString *key = x[0];
        //NSString *value = x[1];
        NSLog(@"遍历字典---%@ %@", key, value);
    }];
}

@end
