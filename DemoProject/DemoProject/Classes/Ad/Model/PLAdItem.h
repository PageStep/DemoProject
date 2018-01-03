//
//  PLAdItem.h
//  OC项目-综合应用
//
//  Created by Page on 2017/12/14.
//  Copyright © 2017年 Page. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLAdItem : NSObject

/** 广告地址 */
@property (nonatomic, strong) NSString *w_picurl;
/** 点击广告跳转的界面 */
@property (nonatomic, strong) NSString *ori_curl;

/** 广告图片宽度 */
@property (nonatomic, assign) CGFloat w;
/** 广告图片高度 */
@property (nonatomic, assign) CGFloat h;

@end
