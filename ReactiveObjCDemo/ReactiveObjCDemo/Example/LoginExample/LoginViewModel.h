//
//  LoginViewModel.h
//  ReactiveObjCDemo
//
//  Created by orilme on 2018/12/4.
//  Copyright © 2018年 orilme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"
#import "Account.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewModel : NSObject
@property (nonatomic, strong) Account *account;
@property (nonatomic, strong, readonly) RACSignal *enableLoginSignal; // 是否允许登录的信号
@property (nonatomic, strong, readonly) RACCommand *LoginCommand;
@end

NS_ASSUME_NONNULL_END
