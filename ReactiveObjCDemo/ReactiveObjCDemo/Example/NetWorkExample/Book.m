//
//  Book.m
//  ReactiveObjCDemo
//
//  Created by orilme on 2018/12/5.
//  Copyright © 2018年 orilme. All rights reserved.
//

#import "Book.h"

@implementation Book
+ (Book *)bookWithDict:(NSDictionary *)dic {
    Book *book = [[Book alloc]init];
    book.subtitle = @"辣啊";
    book.title = @"不卡";
    return book;
}
@end
