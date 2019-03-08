//
//  LoginExampleVC.m
//  ReactiveObjCDemo
//
//  Created by orilme on 2018/12/4.
//  Copyright © 2018年 orilme. All rights reserved.
//

#import "LoginExampleVC.h"
#import "UIViewController+ORStoryboard.h"
#import "ReactiveObjC.h"
#import "LoginViewModel.h"

@interface LoginExampleVC ()
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) LoginViewModel *loginViewModel;
@end

@implementation LoginExampleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self bindModel];
}

// 视图模型绑定
- (void)bindModel {
    // 给模型的属性绑定信号
    // 只要账号文本框一改变，就会给account赋值
    RAC(self.loginViewModel.account, account) = self.userTextField.rac_textSignal;
    RAC(self.loginViewModel.account, pwd) = self.pwdTextField.rac_textSignal;
    
    // 绑定登录按钮
    RAC(self.loginButton, enabled) = self.loginViewModel.enableLoginSignal;
    
    // 监听登录按钮点击
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        // 执行登录事件
        [self.loginViewModel.LoginCommand execute:nil];
    }];
}

- (LoginViewModel *)loginViewModel {
    if (_loginViewModel == nil) {
        _loginViewModel = [[LoginViewModel alloc] init];
    }
    return _loginViewModel;
}

ORStoryboard(Main)
@end
