//
//  PLFastLoginView.m
//  OC项目-综合应用
//
//  Created by Page on 2017/12/15.
//  Copyright © 2017年 Page. All rights reserved.
//

#import "PLFastLoginView.h"

@implementation PLFastLoginView

+ (instancetype)fastLoginView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

@end
