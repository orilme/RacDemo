//
//  RACMacroVC.m
//  ReactiveObjCDemo
//
//  Created by orilme on 2018/12/4.
//  Copyright © 2018年 orilme. All rights reserved.
//

#import "RACMacroVC.h"
#import "UIViewController+ORStoryboard.h"
#import "ReactiveObjC.h"

@interface RACMacroVC ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *labelView;
@end

@implementation RACMacroVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self example1];
    [self racTuplePackTest];
    [self racTupleUnpackTest];
}

- (void)example1 {
    // RAC(TARGET, [KEYPATH, [NIL_VALUE]]):用于给某个对象的某个属性绑定。
    // 只要文本框文字改变，就会修改label的文字
    RAC(self.labelView, text) = self.textField.rac_textSignal;
    
    // RACObserve(self, name):监听某个对象的某个属性,返回的是信号。
    [RACObserve(self.view, center) subscribeNext:^(id x) {
        NSLog(@"RACObserve---%@",x);
    }];
}

- (void)racTuplePackTest {
    // RACTuplePack：把数据包装成RACTuple（元组类）
    // 把参数中的数据包装成元组
    RACTuple *tuple = RACTuplePack(@10, @20);
    NSLog(@"RACTuple---%@", tuple);
}

- (void)racTupleUnpackTest {
    // RACTupleUnpack：把RACTuple（元组类）解包成对应的数据。
    // 把参数中的数据包装成元组
    RACTuple *tuple = RACTuplePack(@"xmg", @20);
    
    // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
    // name = @"xmg" age = @20
    RACTupleUnpack(NSString *name, NSNumber *age) = tuple;
    
    NSLog(@"RACTupleUnpack---%@, %@", name, age);
}

ORStoryboard(Main)
@end
