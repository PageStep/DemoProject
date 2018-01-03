//
//  UITextField+placeholder.m
//  OC项目-day02
//
//  Created by Page on 2017/11/26.
//  Copyright © 2017年 Page. All rights reserved.
//

#import "UITextField+Placeholder.h"
#import <objc/message.h>

@implementation UITextField (Placeholder)

/*
 UITextField可以直接设置占位文字, 不能直接设置占位文字颜色
 当前分类中, 添加一个属性, UIColor *placeholderColor, 来直接设置占位文字颜色
 >利用runtime或断点, 找到UITextField的一个私有属性placeholderLabel, 拿到这个属性后, 再设置其颜色, 就达到设置占位文字颜色的目的
 
 占位文字, 要先有内容 (有值), 再设置占位文字颜色才有效果
 所以为了保证该分类使用方便, 利用runtime交换方法, 保证设置占位文字颜色之前, placeholderLabel有值, 这样即使先设置颜色, 再设置文字, 也有效果
 
 textField.placeholderColor = [UIColor greenColor];
 textField.placeholder = @"test";
 
 */

+ (void)load
{
    // 交换方法
    Method setPlaceholderMethod = class_getInstanceMethod(self, @selector(setPlaceholder:));
    Method setPl_placeholderMethod = class_getInstanceMethod(self, @selector(setPl_placeholder:));
    
    method_exchangeImplementations(setPlaceholderMethod, setPl_placeholderMethod);
}

// 设置占位文字颜色, 如果占位文字label没有值, 先把颜色保存起来
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    // runtime给系统的类添加成员属性, 赋值
    objc_setAssociatedObject(self, @"placeholderColor1", placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 获取占位文字label控件
    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
    
    // 设置占位文字颜色
    placeholderLabel.textColor = placeholderColor;
}


- (UIColor *)placeholderColor
{
    return objc_getAssociatedObject(self, @"placeholderColor1");
}

// 设置占位文字, 并且设置占位文字颜色
- (void)setPl_placeholder:(NSString *)placeholder
{
    [self setPl_placeholder:placeholder];
    
    self.placeholderColor = self.placeholderColor;
}

@end
