//
//  PLSubTagCell.m
//  OC项目-综合应用1
//
//  Created by Page on 2017/12/15.
//  Copyright © 2017年 Page. All rights reserved.
//

#import "PLSubTagCell.h"
#import "PLSubTagItem.h"
#import <UIImageView+WebCache.h>

@interface PLSubTagCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UILabel *numView;

@end

@implementation PLSubTagCell

- (void)setFrame:(CGRect)frame
{
    frame.size.height -= 1;
    
    [super setFrame:frame];
}


- (void)setItem:(PLSubTagItem *)item
{
    _item = item;
    
    // 设置nameView
    _nameView.text = item.theme_name;
    
    // 设置numView, 处理显示的数字(numView)
    [self resolveNum];
    
    // 设置iconView
    // 头像图片变成圆形
    // 裁剪图片 (支持iOS7, iOS8)
    [_iconView pl_setHeaderImageWithURLString:item.image_list placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
}

// 处理订阅数字
- (void)resolveNum
{
    // 判断下有没有>10000
    NSString *numStr = [NSString stringWithFormat:@"%@人订阅", _item.sub_number] ;
    NSInteger num = _item.sub_number.integerValue;
    
    if (num > 10000) {
        CGFloat numF = num / 10000.0;
        numStr = [NSString stringWithFormat:@"%.1f万人订阅",numF];
        // 如果小数位为0, 就去掉
        numStr = [numStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
    }
    
    _numView.text = numStr;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
