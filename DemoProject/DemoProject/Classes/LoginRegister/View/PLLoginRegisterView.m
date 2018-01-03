//
//  PLLoginRegisterView.m
//  OC项目-综合应用
//
//  Created by Page on 2017/12/15.
//  Copyright © 2017年 Page. All rights reserved.
//

#import "PLLoginRegisterView.h"

@interface PLLoginRegisterView ()

@property (weak, nonatomic) IBOutlet UIButton *loginRegisterButton;

@end

@implementation PLLoginRegisterView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // 让按钮背景图片不要被拉伸
    UIImage *image = _loginRegisterButton.currentBackgroundImage;
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    [_loginRegisterButton setBackgroundImage:image forState:UIControlStateNormal];
}

+ (instancetype)loginView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

+ (instancetype)registerView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}


@end
