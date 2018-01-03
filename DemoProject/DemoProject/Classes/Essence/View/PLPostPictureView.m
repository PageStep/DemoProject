//
//  PLPostPictureView.m
//  OC项目-综合应用1
//
//  Created by Page on 2017/12/16.
//  Copyright © 2017年 Page. All rights reserved.
//

#import "PLPostPictureView.h"
#import "PLPostItem.h"
#import "PLSeeBigPictureViewController.h"

@interface PLPostPictureView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderImageView;

@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@property (weak, nonatomic) IBOutlet UIButton *clickButton;

@end

@implementation PLPostPictureView
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPicture)]];
}

// 弹出查看大图控制器
- (void)seeBigPicture
{
    PLSeeBigPictureViewController *vc = [[PLSeeBigPictureViewController alloc] init];
    vc.item = self.item;
    [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
    
    // 获取窗口根控制器的另外一种方式
    //    [UIApplication sharedApplication].keyWindow.rootViewController;
}

- (void)setItem:(PLPostItem *)item
{
    _item = item;
    
    // 1.设置imageView (和placeholderImageView)
    self.placeholderImageView.hidden = NO;
    
    [self.imageView pl_setOriginImage:item.image1 thumbnailImageL:item.image0 placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        if (!image) return;
        
        self.placeholderImageView.hidden = YES;
        
        // 重新绘制长图的大小 (保证图片下载完后, 图片存在后再重绘)
        // 当imageView的contentMode为UIViewContentModeTop, imageView中的image就不会根据比例来填充(ScaleToFill)imageView了, 所以需要重新绘制长图的大小
        // 如果设置了tableView.estimatedRowHeight, tableView的数据源调用顺序会改变, 导致item.isBigPicture没有值,
        if (item.isBigPicture) {
            CGFloat imageW = item.middleViewFrame.size.width;
            CGFloat imageH = imageW * item.height / item.width;
            
            // 开启上下文
            UIGraphicsBeginImageContext(CGSizeMake(imageW, imageH));
            // 绘制图片到上下文中
            [self.imageView.image drawInRect:CGRectMake(0, 0, imageW, imageH)];
            self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            // 关闭上下文
            UIGraphicsEndImageContext();
        }
        
    }];
    
    // 2.设置是否显示gifView
    self.gifView.hidden = !item.isGif;
    
    //根据URL判断图片
    //[topic.image1.lowercaseString hasSuffix:@"gif"]
    //[topic.image1.pathExtension.lowercaseString
    
    
    // 3.设置是否显示clickButton, 并处理大图
    if (item.isBigPicture) { // 长图
        self.clickButton.hidden = NO;
        self.imageView.contentMode = UIViewContentModeTop;
        self.imageView.clipsToBounds = YES;
    } else {
        self.clickButton.hidden = YES;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        self.imageView.clipsToBounds = NO;
    }
    
}
@end
