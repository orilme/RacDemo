//
//  RACSubjectVC.h
//  ReactiveObjCDemo
//
//  Created by orilme on 2018/12/4.
//  Copyright © 2018年 orilme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"

NS_ASSUME_NONNULL_BEGIN

@interface RACSubjectVC : UIViewController
@property (nonatomic, strong) RACSubject *delegateSignal;
@end

NS_ASSUME_NONNULL_END
