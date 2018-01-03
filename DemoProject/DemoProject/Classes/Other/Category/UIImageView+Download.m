//
//  UIImageView+Download.m
//  OC项目-day02
//
//  Created by Page on 2017/12/5.
//  Copyright © 2017年 Page. All rights reserved.
//

#import "UIImageView+Download.h"
#import <AFNetworkReachabilityManager.h>
#import <UIImageView+WebCache.h>

@implementation UIImageView (Download)

// 设置头像图片
- (void)pl_setHeaderImageWithURLString:(NSString *)string placeholderImage:(UIImage *)placeholderImage
{
    
    [self sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[placeholderImage pl_circleImage] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        // 图片下载失败，直接返回 (设置了占位图片)
        if (!image) return;
        
        self.image = [image pl_circleImage];
    }];
}

// 设置普通图片 (原图, 缩略图)
- (void)pl_setOriginImage:(NSString *)originImageURL thumbnailImageL:(NSString *)thumbnailImageURL placeholderImage:(UIImage *)placeholderImage
{
    // 根据网络状态来加载图片
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 获得原图（SDWebImage的图片缓存是用图片的url字符串作为key）
    UIImage *originImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:originImageURL];
    
    if (originImage) {  // 如果下载过原图, 直接设置图片
        self.image = originImage;
    } else if (mgr.isReachableViaWiFi) { // WiFi网络
        [self sd_setImageWithURL:[NSURL URLWithString:originImageURL] placeholderImage:placeholderImage];
    } else if (mgr.isReachableViaWWAN) { // 移动网络
        // 用户如果设置了允许移动网络下载原图
#warning downloadOriginImageWhenWWAN配置项的值需要从沙盒里面获取
        BOOL downloadOriginImageWhenWWAN = YES;
        if (downloadOriginImageWhenWWAN) {
            [self sd_setImageWithURL:[NSURL URLWithString:originImageURL] placeholderImage:placeholderImage];
        } else {
            [self sd_setImageWithURL:[NSURL URLWithString:thumbnailImageURL] placeholderImage:placeholderImage];
        }
    } else { // 没有可用网络
        UIImage *thumbnailImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:thumbnailImageURL];
        if (thumbnailImage) { // 如果下载过缩略图, 设置缩略图
            self.image = thumbnailImage;
        } else { // 没有下载过任何图片
            // 设置占位图片;
            self.image = placeholderImage;
        }
    }
}

// 设置普通图片 (原图, 缩略图), block: 设置图片后隐藏占位图片, 这里的占位图片是另外一个imageView
- (void)pl_setOriginImage:(NSString *)originImageURL thumbnailImageL:(NSString *)thumbnailImageURL placeholderImage:(UIImage *) placeholderImage completed:(SDExternalCompletionBlock)completedBlock
{
    // 根据网络状态来加载图片
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 获得原图（SDWebImage的图片缓存是用图片的url字符串作为key）
    UIImage *originImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:originImageURL];
    
    if (originImage) {  // 如果下载过原图, 直接设置图片
        [self sd_setImageWithURL:[NSURL URLWithString:originImageURL] placeholderImage:placeholderImage completed:completedBlock];
    } else if (mgr.isReachableViaWiFi) { // WiFi网络
        [self sd_setImageWithURL:[NSURL URLWithString:originImageURL] placeholderImage:placeholderImage completed:completedBlock];
    } else if (mgr.isReachableViaWWAN) { // 移动网络
        // 用户如果设置了允许移动网络下载原图
#warning downloadOriginImageWhenWWAN配置项的值需要从沙盒里面获取
        BOOL downloadOriginImageWhenWWAN = YES;
        if (downloadOriginImageWhenWWAN) {
            [self sd_setImageWithURL:[NSURL URLWithString:originImageURL] placeholderImage:placeholderImage completed:completedBlock];
        } else {
            [self sd_setImageWithURL:[NSURL URLWithString:thumbnailImageURL] placeholderImage:placeholderImage completed:completedBlock];
        }
    } else { // 没有可用网络
        UIImage *thumbnailImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:thumbnailImageURL];
        if (thumbnailImage) { // 如果下载过缩略图, 设置缩略图
            [self sd_setImageWithURL:[NSURL URLWithString:thumbnailImageURL] placeholderImage:placeholderImage completed:completedBlock];
        } else { // 没有下载过任何图片
            // 设置占位图片;
            [self sd_setImageWithURL:nil placeholderImage:placeholderImage completed:completedBlock];
        }
    }
}

@end
