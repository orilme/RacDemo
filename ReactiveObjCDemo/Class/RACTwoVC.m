//
//  RACTwoVC.m
//  ReactiveObjCDemo
//
//  Created by orilme on 2018/12/4.
//  Copyright © 2018年 orilme. All rights reserved.
//

#import "RACTwoVC.h"
#import "UIViewController+ORStoryboard.h"
#import "ReactiveObjC.h"

@interface RACTwoVC ()
@property (weak, nonatomic) IBOutlet UISlider *redSilder;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSilder;
@property (weak, nonatomic) IBOutlet UITextField *redInput;
@property (weak, nonatomic) IBOutlet UITextField *blueInput;
@property (weak, nonatomic) IBOutlet UITextField *greenInput;
@property (weak, nonatomic) IBOutlet UIView *showView;

@end

@implementation RACTwoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //[self test];
    [self test2];
}

- (void)test2 {
    self.redInput.text = self.blueInput.text = self.greenInput.text = @"0.5";
    RACSignal *redSignal = [self blindSlider:self.redSilder textField:self.redInput];
    RACSignal *blueSignal = [self blindSlider:self.blueSlider textField:self.blueInput];
    RACSignal *greenSignal = [self blindSlider:self.greenSilder textField:self.greenInput];
    
    // 写法一
//    [[[RACSignal combineLatest:@[redSignal, blueSignal, greenSignal]] map:^id _Nullable(RACTuple * _Nullable value) {
//        return [UIColor colorWithRed:[value[0] floatValue] green:[value[0] floatValue] blue:[value[1] floatValue] alpha:[value[2] floatValue]];
//    }] subscribeNext:^(id  _Nullable x) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.showView.backgroundColor = x;
//        });
//    }];
    
    // 写法二
    RACSignal *changeValueSignal = [[RACSignal combineLatest:@[redSignal, blueSignal, greenSignal]] map:^id _Nullable(RACTuple * _Nullable value) {
        return [UIColor colorWithRed:[value[0] floatValue] green:[value[1] floatValue] blue:[value[2] floatValue] alpha:1];
    }];
    RAC(self.showView, backgroundColor) = changeValueSignal;
}

- (RACSignal *)blindSlider:(UISlider *)slider textField:(UITextField *)textField {
    RACSignal *textSignal = [[textField rac_textSignal] take:1];
    RACChannelTerminal *sigalSlider = [slider rac_newValueChannelWithNilValue:nil];
    RACChannelTerminal *signalText = [textField rac_newTextChannel];
    [signalText subscribe:sigalSlider];
    [[sigalSlider map:^id _Nullable(id  _Nullable value) {
        return [NSString stringWithFormat:@"%.02f", [value floatValue]];
    }] subscribe:signalText];
    return [[signalText merge:sigalSlider] merge:textSignal];
}

- (void)test {
    // RACSignal使用步骤：
    // 1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
    // 2.订阅信号,才会激活信号. - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 3.发送信号 - (void)sendNext:(id)value
    
    
    // RACSignal底层实现：
    // 1.创建信号，首先把didSubscribe保存到信号中，还不会触发。
    // 2.当信号被订阅，也就是调用signal的subscribeNext:nextBlock
    // 2.2 subscribeNext内部会创建订阅者subscriber，并且把nextBlock保存到subscriber中。
    // 2.1 subscribeNext内部会调用siganl的didSubscribe
    // 3.siganl的didSubscribe中调用[subscriber sendNext:@1];
    // 3.1 sendNext底层其实就是执行subscriber的nextBlock
    
    // 1.创建信号
    RACSignal *siganl = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // block调用时刻：每当有订阅者订阅信号，就会调用block。
        
        // 2.发送信号
        [subscriber sendNext:@1];
        
        // 如果不在发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            
            // block调用时刻：当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号。
            
            // 执行完Block后，当前信号就不在被订阅了。
            
            NSLog(@"信号被销毁");
            
        }];
    }];
    
    // 3.订阅信号,才会激活信号.
    [siganl subscribeNext:^(id x) {
        // block调用时刻：每当有信号发出数据，就会调用block.
        NSLog(@"接收到数据:%@",x);
    }];
    
    [siganl subscribeNext:^(id x) {
        // block调用时刻：每当有信号发出数据，就会调用block.
        NSLog(@"接收到数据2:%@",x);
    }];
}

ORStoryboard(Main)

@end
