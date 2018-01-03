//
//  PLSquareCell.m
//  OC项目-综合应用
//
//  Created by Page on 2017/12/15.
//  Copyright © 2017年 Page. All rights reserved.
//

#import "PLSquareCell.h"
#import "PLSquareItem.h"
#import <UIImageView+WebCache.h>

@interface PLSquareCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation PLSquareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItem:(PLSquareItem *)item
{
    _item = item;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:item.icon]];
    _nameLabel.text = item.name;
}
    
@end
