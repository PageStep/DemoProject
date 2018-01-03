//
//  PLPostVoiceView.m
//  OC项目-综合应用1
//
//  Created by Page on 2017/12/16.
//  Copyright © 2017年 Page. All rights reserved.
//

#import "PLPostVoiceView.h"
#import "PLPostItem.h"
#import "PLSeeBigPictureViewController.h"

@interface PLPostVoiceView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderImageView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *voicetimeLabel;

@end

@implementation PLPostVoiceView

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
    self.voicetimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", item.voicetime / 60, item.voicetime % 60];
}

@end
