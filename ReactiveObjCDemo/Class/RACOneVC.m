//
//  RACOneVC.m
//  ReactiveObjCDemo
//
//  Created by orilme on 2018/12/4.
//  Copyright © 2018年 orilme. All rights reserved.
//

#import "RACOneVC.h"
#import "UIViewController+ORStoryboard.h"
#import "ReactiveObjC.h"

@interface RACOneVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@end

@implementation RACOneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    RACSignal *viewDidAppearSignal = [self rac_signalForSelector:@selector(viewDidAppear:)];
    [viewDidAppearSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"RAC---%s", __func__);
    }];
    
    //[self testLogin];
    //[self example1];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    NSLog(@"%s", __func__);
}

// 登录原生代理方法和RAC对比
- (void)testLogin {
    RACSignal *enableSignal = [[RACSignal combineLatest:@[self.userTextField.rac_textSignal, self.pwdTextField.rac_textSignal]] map:^id _Nullable(id value) {
        return @([value[0] length] > 0 && [value[1] length ] > 6);
    }];
    
    self.loginButton.rac_command = [[RACCommand alloc]initWithEnabled:enableSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal empty];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *s1 = self.userTextField.text;
    NSString *s2 = self.pwdTextField.text;
    if (textField == self.userTextField) {
        s1 = str;
    }else {
        s2 = str;
    }
    if (s1.length > 0 && s2.length > 6) {
        self.loginButton.enabled = YES;
    }else {
        self.loginButton.enabled = NO;
    }
    NSLog(@"系统方法---%@, %@", s1, s2);
    return YES;
}

// 信号量的统一
- (void)example1 {
    self.loginButton.rac_command = [[RACCommand alloc]initWithEnabled:nil signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            NSLog(@"clicked");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:[[NSDate date] description]];
                [subscriber sendCompleted];
            });
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
    }];
                                    
    [[[self.loginButton rac_command] executionSignals] subscribeNext:^(RACSignal<id> * _Nullable x) {
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"%@", x);
        }];
    }];
}


ORStoryboard(Main)

@end
