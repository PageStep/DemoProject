//
//  UIView+View.m
//  OC项目-day02
//
//  Created by Page on 2017/12/5.
//  Copyright © 2017年 Page. All rights reserved.
//

#import "UIView+View.h"

@implementation UIView (View)

+ (instancetype)pl_viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

@end
