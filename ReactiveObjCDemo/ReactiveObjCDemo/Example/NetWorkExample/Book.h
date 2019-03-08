//
//  Book.h
//  ReactiveObjCDemo
//
//  Created by orilme on 2018/12/5.
//  Copyright © 2018年 orilme. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Book : NSObject
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *title;
+ (Book *)bookWithDict:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
