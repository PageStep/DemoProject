//
//  PLFastLoginButton.m
//  OC项目-综合应用
//
//  Created by Page on 2017/12/15.
//  Copyright © 2017年 Page. All rights reserved.
//

#import "PLFastLoginButton.h"

@implementation PLFastLoginButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置图片位置
    self.imageView.pl_y = 0;
    self.imageView.pl_centerX = self.pl_width * 0.5;
    
    // 设置标题位置
    self.titleLabel.pl_y = self.pl_height - self.titleLabel.pl_height;
    
    // 计算文字宽度, 设置label的宽度
    // 注意: sizeToFit对centerX做了处理, 要先调用sizeToFit, 再设置centerX
    [self.titleLabel sizeToFit];
    
    self.titleLabel.pl_centerX = self.pl_width * 0.5;
    
}


@end
