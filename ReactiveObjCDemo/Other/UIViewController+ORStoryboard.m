//
//  UIViewController+ORStoryboard.m
//  ReactiveObjCDemo
//
//  Created by orilme on 2018/12/4.
//  Copyright © 2018年 orilme. All rights reserved.
//

#import "UIViewController+ORStoryboard.h"
#import <objc/runtime.h>

@implementation UIViewController (ORStoryboard)

+ (__kindof UIViewController *)orilme_viewController
{
#pragma clang diagnostic push
#pragma GCC diagnostic ignored "-Wundeclared-selector"
    SEL storyboardNameSel = @selector(orilme_storyboardName);
#pragma clang diagnostic pop
    // 仅搜索当前的类方法。项目中目前无复杂的继承关系，所以并无太大关系。可视情况换为[self respondsToSelector:]
    BOOL hasMethod = NO;
    unsigned int methodCount = 0;
    Method *methodList = class_copyMethodList(object_getClass(self), &methodCount);
    for (unsigned int i = 0; i < methodCount; i++) {
        Method method = methodList[i];
        SEL selector = method_getName(method);
        if (selector == storyboardNameSel) {
            hasMethod = YES;
            break;
        }
    }
    free(methodList);
    if (!hasMethod) {
        return [[self alloc] init];
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    NSString *storyboardName = [self performSelector:storyboardNameSel];
#pragma clang diagnostic pop
    NSBundle *bundle = [NSBundle bundleForClass:self];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:bundle];
    if (!storyboard) {
        return nil;
    }
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    return viewController;
}

@end
