//
//  PLTitleButton.m
//  OC项目-综合应用1
//
//  Created by Page on 2017/12/16.
//  Copyright © 2017年 Page. All rights reserved.
//

#import "PLTitleButton.h"

@implementation PLTitleButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    }
    return self;
}


// 只要重写了这个方法，按钮就无法进入highlighted状态
- (void)setHighlighted:(BOOL)highlighted {
    
}

@end
