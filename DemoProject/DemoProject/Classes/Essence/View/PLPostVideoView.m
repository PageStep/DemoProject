//
//  PLPostVideoView.m
//  OC项目-综合应用1
//
//  Created by Page on 2017/12/16.
//  Copyright © 2017年 Page. All rights reserved.
//

#import "PLPostVideoView.h"
#import "PLPostItem.h"
#import "PLSeeBigPictureViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PLPostVideoView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderImageView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videotimeLabel;

@end

@implementation PLPostVideoView

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
}
- (IBAction)play {
    
    AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
    NSURL *url = [NSURL URLWithString:_item.videouri];
    playerVC.player = [[AVPlayer alloc] initWithURL:url];
    
    [self.window.rootViewController presentViewController:playerVC animated:YES completion:nil];

}

- (void)setItem:(PLPostItem *)item
{
    _item = item;
    
    // 1.设置imageView (和placeholderImageView)
    self.placeholderImageView.hidden = NO;
    
    [self.imageView pl_setOriginImage:item.image1 thumbnailImageL:item.image0 placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        if (!image) return;
        
        self.placeholderImageView.hidden = YES;
    }];
    
    // 2.设置播放数量
    if (item.playcount >= 10000) {
        self.playcountLabel.text = [NSString stringWithFormat:@"%.1f万播放", item.playcount / 10000.0];
    } else {
        self.playcountLabel.text = [NSString stringWithFormat:@"%zd播放", item.playcount];
    }
    // 3.设置播放时间
    // %04d : 占据4位，多余的空位用0填补
    self.videotimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", item.videotime / 60, item.videotime % 60];
}


@end
