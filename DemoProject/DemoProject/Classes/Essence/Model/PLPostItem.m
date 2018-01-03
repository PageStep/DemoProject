//
//  PLPostItem.m
//  OC项目-综合应用1
//
//  Created by Page on 2017/12/15.
//  Copyright © 2017年 Page. All rights reserved.
//

#import "PLPostItem.h"

@implementation PLPostItem

- (CGFloat)cellHeight
{
    // 如果已经计算过，就直接返回
    if (_cellHeight) return _cellHeight;
    
    
    // 1.加上 xib中头像视图的高度
    _cellHeight += 55;
    
    // 2.加上 xib中文本内容的高度
    CGSize textMaxSize = CGSizeMake(PLScreenW - 2 * PLMargin, MAXFLOAT);
    _cellHeight += [self.text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height + PLMargin;
    
    // 3.加上 中间内容视图的高度
    // 如果有中间内容, 才加上其高度
    if (self.type != PLPostTypeWord) {
        
        CGFloat middleViewW = textMaxSize.width;
        // 根据比例算出高度
        CGFloat middleViewH = middleViewW * self.height / self.width;
        if (middleViewH >= PLScreenH) { // 长图
            middleViewH = 200;
            self.bigPicture = YES;
        }
        CGFloat middleViewX = PLMargin;
        // 此时的_cellHeight是 加上了 xib中文本内容的高度, 之后的高度
        CGFloat middleViewY = _cellHeight;
        
        self.middleViewFrame = CGRectMake(middleViewX, middleViewY, middleViewW, middleViewH);
        
        _cellHeight += middleViewH + PLMargin;
    }
    
    // 4.加上 xib中最热评论视图的高度
    // 如果有最热评论, 才加上其高度
    if (self.top_cmt.count) {
        // 标题
        _cellHeight += 21;
        // 内容
        NSDictionary *cmt = self.top_cmt.firstObject;
        NSString *content = cmt[@"content"];
        if (content.length == 0) {
            content = @"[语音评论]";
        }
        NSString *username = cmt[@"user"][@"username"];
        NSString *cmtText = [NSString stringWithFormat:@"%@ : %@", username, content];
        _cellHeight += [cmtText boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil].size.height + PLMargin;
    }
    
    // 5.加上 xib中底部视图的高度
    _cellHeight += 35 + PLMargin;
    
    return _cellHeight;
}


@end
