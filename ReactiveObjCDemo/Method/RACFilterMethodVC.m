//
//  RACFilterMethodVC.m
//  ReactiveObjCDemo
//
//  Created by orilme on 2018/12/4.
//  Copyright © 2018年 orilme. All rights reserved.
//

#import "RACFilterMethodVC.h"
#import "UIViewController+ORStoryboard.h"
#import "ReactiveObjC.h"

@interface RACFilterMethodVC ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation RACFilterMethodVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    // filter：过滤，每次信号发出，会先执行过滤条件判断
    [self filter];
    
    // ignore：内部调用filter过滤，忽略掉ignore的值
    [self ignore];
    
    // distinctUntilChanged：当上一次的值和当前的值有明显的变化就会发出信号，否则会被忽略掉
    [self distinctUntilChanged];
    
    // take：从开始一共取N次的信号
    [self take];
    
    // takeLast:取最后N次的信号,前提条件，订阅者必须调用完成，因为只有完成，就知道总共有多少信号.
    [self takeLast];
    
    // takeUntil:(RACSignal *):获取信号直到某个信号执行完成
    [self takeUntil];
    
    // skip:(NSUInteger):跳过几个信号,不接受
    [self skip];
    
    // switchToLatest:用于signalOfSignals（信号的信号），有时候信号也会发出信号，会在signalOfSignals中，获取signalOfSignals发送的最新信号。
    [self switchToLatest];
}

- (void)filter {
    // filter：过滤，每次信号发出，会先执行过滤条件判断.
    [self.textField.rac_textSignal filter:^BOOL(NSString *value) {
        return value.length > 3;
    }];
}

- (void)ignore {
    // 内部调用filter过滤，忽略掉ignore的值
    [[self.textField.rac_textSignal ignore:@"1"] subscribeNext:^(id x) {
        NSLog(@"ignore---%@", x);
    }];
}

- (void)distinctUntilChanged {
    // 过滤，当上一次和当前的值不一样，就会发出内容。
    // 在开发中，刷新UI经常使用，只有两次数据不一样才需要刷新
    [[self.textField.rac_textSignal distinctUntilChanged] subscribeNext:^(id x) {
        NSLog(@"distinctUntilChanged---%@", x);
    }];
}

- (void)take {
    // 1.创建信号
    RACSubject *signal = [RACSubject subject];
    // 2.处理信号，订阅信号
    [[signal take:1] subscribeNext:^(id x) {
        NSLog(@"take---%@",x);
    }];
    // 3.发送信号
    [signal sendNext:@1];
    [signal sendNext:@2];
}

- (void)takeLast {
    // 1.创建信号
    RACSubject *signal = [RACSubject subject];
    // 2.处理信号，订阅信号
    [[signal takeLast:1] subscribeNext:^(id x) {
        NSLog(@"takeLast---%@", x);
    }];
    // 3.发送信号
    [signal sendNext:@1];
    [signal sendNext:@2];
    // 4.完成
    [signal sendCompleted];
}

- (void)takeUntil {
    // 监听文本框的改变直到当前对象被销毁
    [self.textField.rac_textSignal takeUntil:self.rac_willDeallocSignal];
}

- (void)skip {
    // 表示输入第一次，不会被监听到，跳过第一次发出的信号
    [[self.textField.rac_textSignal skip:1] subscribeNext:^(id x) {
        NSLog(@"skip---%@", x);
    }];
}

- (void)switchToLatest {
    RACSubject *signalOfSignals = [RACSubject subject];
    RACSubject *signal = [RACSubject subject];
    
    // 获取信号中信号最近发出信号，订阅最近发出的信号。
    // 注意switchToLatest：只能用于信号中的信号
    [signalOfSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"switchToLatest---%@", x);
    }];
    [signalOfSignals sendNext:signal];
    [signal sendNext:@1];
}

ORStoryboard(Main)
@end
