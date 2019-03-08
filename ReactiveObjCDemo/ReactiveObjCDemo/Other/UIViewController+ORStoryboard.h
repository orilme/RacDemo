//
//  UIViewController+ORStoryboard.h
//  ReactiveObjCDemo
//
//  Created by orilme on 2018/12/4.
//  Copyright © 2018年 orilme. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ORStoryboard(SBN) \
+ (NSString *)orilme_storyboardName { \
return @(#SBN); \
}

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ORStoryboard)

+ (nullable __kindof UIViewController *)orilme_viewController;

@end

NS_ASSUME_NONNULL_END
