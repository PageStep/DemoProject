//
//  UIView+Frame.m
//  BuDeJie
//
//  Created by xiaomage on 16/3/12.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (void)setPl_width:(CGFloat)pl_width
{
    CGRect rect = self.frame;
    rect.size.width = pl_width;
    self.frame = rect;
}

- (CGFloat)pl_width
{
    return self.frame.size.width;
}


- (void)setPl_height:(CGFloat)pl_height
{
    CGRect rect = self.frame;
    rect.size.height = pl_height;
    self.frame = rect;
}

- (CGFloat)pl_height
{
    return self.frame.size.height;
}


- (void)setPl_x:(CGFloat)pl_x
{
    CGRect rect = self.frame;
    rect.origin.x = pl_x;
    self.frame = rect;
}

- (CGFloat)pl_x
{
    return self.frame.origin.x;
    
}


- (void)setPl_y:(CGFloat)pl_y
{
    CGRect rect = self.frame;
    rect.origin.y = pl_y;
    self.frame = rect;
}

- (CGFloat)pl_y
{

    return self.frame.origin.y;
}


- (void)setPl_centerX:(CGFloat)pl_centerX
{
    CGPoint center = self.center;
    center.x = pl_centerX;
    self.center = center;
}

- (CGFloat)pl_centerX
{
    return self.center.x;
}


- (void)setPl_centerY:(CGFloat)pl_centerY
{
    CGPoint center = self.center;
    center.y = pl_centerY;
    self.center = center;
}

- (CGFloat)pl_centerY
{
    return self.center.y;
}

@end
