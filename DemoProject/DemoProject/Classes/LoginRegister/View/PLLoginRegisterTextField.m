//
//  PLLoginRegisterTextField.m
//  OC项目-综合应用
//
//  Created by Page on 2017/12/15.
//  Copyright © 2017年 Page. All rights reserved.
//

#import "PLLoginRegisterTextField.h"
#import "UITextField+Placeholder.h"

@implementation PLLoginRegisterTextField

/*
 1.文本框光标变成白色
 2.文本框开始编辑的时候,占位文字颜色变成白色
 */
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // 设置光标的颜色为白色
    self.tintColor = [UIColor whiteColor];
    
    /*
     设置占位文字颜色, 方式1
     NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
     attrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
     self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attrs];
     */
    // 快速设置占位文字颜色 => 文本框占位文字可能是label => 验证占位文字是label => 拿到label => 查看label属性名(1.runtime 2.断点)
    // 设置占位文字颜色, 方式2 (给UITextField添加分类属性)
    self.placeholderColor = [UIColor lightGrayColor];
    
    
    // 监听文本框编辑 (监听的方式: 1.代理 2.通知 3.target, 原则:不要自己成为自己代理)
    [self addTarget:self action:@selector(textBegin) forControlEvents:UIControlEventEditingDidBegin];
    [self addTarget:self action:@selector(textEnd) forControlEvents:UIControlEventEditingDidEnd];
}

// 文本框开始编辑调用
- (void)textBegin
{
    self.placeholderColor = [UIColor whiteColor];
}

// 文本框结束编辑调用
- (void)textEnd
{
    self.placeholderColor = [UIColor lightGrayColor];
}


@end
