//
//  RACRequestViewModel.h
//  ReactiveObjCDemo
//
//  Created by orilme on 2018/12/5.
//  Copyright © 2018年 orilme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"

NS_ASSUME_NONNULL_BEGIN

@interface RACRequestViewModel : NSObject<UITableViewDataSource>
// 请求命令
@property (nonatomic, strong, readonly) RACCommand *reuqesCommand;
//模型数组
@property (nonatomic, strong) NSArray *models;
@end

NS_ASSUME_NONNULL_END
