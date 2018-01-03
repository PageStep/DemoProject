//
//  UIBarButtonItem+Item.h
//  BuDeJie
//
//  Created by xiaomage on 16/3/12.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Item)
// 快速创建UIBarButtonItem
+ (UIBarButtonItem *)itemWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)itemWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage target:(id)target action:(SEL)action;

// 快速创建返回按钮
+ (UIBarButtonItem *)backItemWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage target:(id)target action:(SEL)action title:(NSString *)title;

@end
