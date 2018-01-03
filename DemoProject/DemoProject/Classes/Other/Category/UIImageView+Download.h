//
//  UIImageView+Download.h
//  OC项目-day02
//
//  Created by Page on 2017/12/5.
//  Copyright © 2017年 Page. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>

@interface UIImageView (Download)

// 设置头像图片
- (void)pl_setHeaderImageWithURLString:(NSString *)string placeholderImage:(UIImage *)placeholderImage;

// 设置普通图片 (原图, 缩略图)
- (void)pl_setOriginImage:(NSString *)originImageURL thumbnailImageL:(NSString *)thumbnailImageURL placeholderImage:(UIImage *)placeholderImage;

// 设置普通图片 (原图, 缩略图), block: 设置图片后隐藏占位图片, 这里的占位图片是另外一个imageView
- (void)pl_setOriginImage:(NSString *)originImageURL thumbnailImageL:(NSString *)thumbnailImageURL placeholderImage:(UIImage *) placeholderImage completed:(SDExternalCompletionBlock)completedBlock;

@end
