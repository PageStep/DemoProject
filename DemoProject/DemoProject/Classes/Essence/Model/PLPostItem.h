//
//  PLPostItem.h
//  OC项目-综合应用1
//
//  Created by Page on 2017/12/15.
//  Copyright © 2017年 Page. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PLPostType) {
    /** 全部 */
    PLPostTypeAll = 1,
    /** 图片 */
    PLPostTypePicture = 10,
    /** 文字 */
    PLPostTypeWord = 29,
    /** 声音 */
    PLPostTypeVoice = 31,
    /** 视频 */
    PLPostTypeVideo = 41
};

@interface PLPostItem : NSObject

/** 用户的名字 */
@property (nonatomic, copy) NSString *name;
/** 用户的头像 */
@property (nonatomic, copy) NSString *profile_image;
/** 帖子的文字内容 */
@property (nonatomic, copy) NSString *text;
/** 帖子审核通过的时间 */
@property (nonatomic, copy) NSString *passtime;

/** 顶数量 */
@property (nonatomic, assign) NSInteger ding;
/** 踩数量 */
@property (nonatomic, assign) NSInteger cai;
/** 转发\分享数量 */
@property (nonatomic, assign) NSInteger repost;
/** 评论数量 */
@property (nonatomic, assign) NSInteger comment;

/** 帖子的类型 10为图片 29为段子 31为音频 41为视频 */
@property (nonatomic, assign) PLPostType type;

/** 最热评论 */
@property (nonatomic, strong) NSArray *top_cmt;
/** 宽度(像素) */
@property (nonatomic, assign) NSInteger width;
/** 高度(像素) */
@property (nonatomic, assign) NSInteger height;

/** 小图 */
@property (nonatomic, copy) NSString *image0;
/** 中图 */
@property (nonatomic, copy) NSString *image2;
/** 大图 */
@property (nonatomic, copy) NSString *image1;
/** 是否为动图 */
@property (nonatomic, assign, getter=isGif) BOOL is_gif;

/** 音频时长 */
@property (nonatomic, assign) NSInteger voicetime;
/** 视频时长 */
@property (nonatomic, assign) NSInteger videotime;
/** 视频URL */
@property (nonatomic, copy) NSString * videouri;

/** 音频\视频的播放次数 */
@property (nonatomic, assign) NSInteger playcount;

/* 额外增加的属性（并非服务器返回的属性） */
/** 根据当前模型数据计算出来的cell高度, 作为tableView代理方法中的返回值 */
@property (nonatomic, assign) CGFloat cellHeight;
/** 根据当前模型数据计算出来的中间内容的frame, 用于cell的setItem:方法中设置中间视图的frame*/
@property (nonatomic, assign) CGRect middleViewFrame;
/** 是否为超长图片 */
@property (nonatomic, assign, getter=isBigPicture) BOOL bigPicture;


@end
