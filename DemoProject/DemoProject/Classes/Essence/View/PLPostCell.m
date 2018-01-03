//
//  PLPostCell.m
//  OC项目-综合应用1
//
//  Created by Page on 2017/12/16.
//  Copyright © 2017年 Page. All rights reserved.
//

#import "PLPostCell.h"

#import "PLPostItem.h"
#import <UIImageView+WebCache.h>

#import "PLPostVideoView.h"
#import "PLPostVoiceView.h"
#import "PLPostPictureView.h"

@interface PLPostCell ()

// 控件的命名: 功能 + 控件类型
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *text_label;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *repostButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIView *topCmtView;
@property (weak, nonatomic) IBOutlet UILabel *topCmtLabel;

/* 中间视图 */
/** 视频控件 */
@property (nonatomic, weak) PLPostVideoView *videoView;
/** 声音控件 */
@property (nonatomic, weak) PLPostVoiceView *voiceView;
/** 图片控件 */
@property (nonatomic, weak) PLPostPictureView *pictureView;

@end

@implementation PLPostCell

#pragma mark - 懒加载
- (PLPostVideoView *)videoView {
    if (!_videoView) {
        PLPostVideoView *videoView = [PLPostVideoView pl_viewFromXib];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}

- (PLPostVoiceView *)voiceView {
    if (!_voiceView) {
        PLPostVoiceView *voiceView = [PLPostVoiceView pl_viewFromXib];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}

- (PLPostPictureView *)pictureView {
    if (!_pictureView) {
        PLPostPictureView *pictureView = [PLPostPictureView pl_viewFromXib];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}

// 设置cell之间的间距
- (void)setFrame:(CGRect)frame {

    frame.size.height -= PLMargin;
    
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
}

- (void)setItem:(PLPostItem *)item {
    
    _item = item;
    
    // 设置顶部控件
    [self.profileImageView pl_setHeaderImageWithURLString:item.profile_image placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    self.nameLabel.text = item.name;
    self.passtimeLabel.text = item.passtime;
    self.text_label.text = item.text;
    
    // 设置底部按钮
    [self setupButtonTitle:self.dingButton number:item.ding placeholder:@"顶"];
    [self setupButtonTitle:self.caiButton number:item.cai placeholder:@"踩"];
    [self setupButtonTitle:self.repostButton number:item.repost placeholder:@"分享"];
    [self setupButtonTitle:self.commentButton number:item.comment placeholder:@"评论"];
    
    // 设置最热评论视图
    // 如果有最热评论才设置其视图
    if (item.top_cmt.count) {
        
        self.topCmtView.hidden = NO;
        
        NSDictionary *cmt = item.top_cmt.firstObject;
        NSString *content = cmt[@"content"];
        if (content.length == 0) {
            content = @"[语音评论]";
        }
        NSString *username = cmt[@"user"][@"username"];
        self.topCmtLabel.text = [NSString stringWithFormat:@"%@ : %@", username, content];
    } else {
        // 没有最热评论
        self.topCmtView.hidden = YES;
    }
    
    // 根据帖子的类型设置是否隐藏
    if (item.type == PLPostTypeVideo) { // 视频
        self.voiceView.hidden = YES;
        self.pictureView.hidden = YES;
        self.videoView.hidden = NO;
        self.videoView.item = item; // 把模型数据传递给videoView
    } else if (item.type == PLPostTypeVoice) { // 声音
        self.videoView.hidden = YES;
        self.pictureView.hidden = YES;
        self.voiceView.hidden = NO;
        self.voiceView.item = item; // 把模型数据传递给voiceView
    } else if (item.type == PLPostTypePicture) { // 图片
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = NO;
        self.pictureView.item = item; // 把模型数据传递给pictureView
    } else if (item.type == PLPostTypeWord) { // 段子
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = YES;
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 根据帖子的类型设置中间视图的frame
    if (self.item.type == PLPostTypeVideo) { // 视频
        self.videoView.frame = self.item.middleViewFrame;
    } else if (self.item.type == PLPostTypeVoice) { // 声音
        self.voiceView.frame = self.item.middleViewFrame;
    } else if (self.item.type == PLPostTypePicture) { // 图片
        self.pictureView.frame = self.item.middleViewFrame;
    }
}

/**
 *  处理按钮文字
 *  @param number      按钮的数字
 *  @param placeholder 数字为0时显示的文字
 */
- (void)setupButtonTitle:(UIButton *)button number:(NSInteger)number placeholder:(NSString *)placeholder {
    if (number >= 10000) {
        [button setTitle:[NSString stringWithFormat:@"%.1f万", number / 10000.0] forState:UIControlStateNormal];
    } else if (number > 0) {
        [button setTitle:[NSString stringWithFormat:@"%zd", number] forState:UIControlStateNormal];
    } else {
        [button setTitle:placeholder forState:UIControlStateNormal];
    }
}

@end
