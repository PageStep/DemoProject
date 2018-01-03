//
//  PLLoginRegisterViewControlle.m
//  OC项目-综合应用
//
//  Created by Page on 2017/12/15.
//  Copyright © 2017年 Page. All rights reserved.
//

#import "PLLoginRegisterViewController.h"
#import "PLLoginRegisterView.h"
#import "PLFastLoginView.h"

@interface PLLoginRegisterViewController ()

@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleViewLeadingConstraints;

@end

@implementation PLLoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建登录界面view
    PLLoginRegisterView *loginView = [PLLoginRegisterView loginView];
    // 添加到middleView
    [self.middleView addSubview:loginView];
    
    // 创建注册界面view
    PLLoginRegisterView *registerView = [PLLoginRegisterView registerView];
    // 添加到middleView
    [self.middleView addSubview:registerView];
    
    // 添加快速登录view
    PLFastLoginView *fastLoginView = [PLFastLoginView fastLoginView];
    // 添加到bottomView
    [self.bottomView addSubview:fastLoginView];

}

- (void)viewDidLayoutSubviews
{
    // 一定要调用super
    [super viewDidLayoutSubviews];
    
    // 设置登录view
    PLLoginRegisterView *loginView = self.middleView.subviews[0];
    loginView.frame = CGRectMake(0, 0, self.middleView.pl_width * 0.5, self.middleView.pl_height);
    
    // 设置注册view
    PLLoginRegisterView *registerView = self.middleView.subviews[1];
    registerView.frame = CGRectMake( self.middleView.pl_width * 0.5, 0,self.middleView.pl_width * 0.5, self.middleView.pl_height);
    
    // 设置快速登录view
    PLFastLoginView *fastLoginView = self.bottomView.subviews.firstObject;
    fastLoginView.frame = self.bottomView.bounds;
}

- (IBAction)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickRegister:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    // 平移middleView
    _middleViewLeadingConstraints.constant = _middleViewLeadingConstraints.constant == 0 ? -self.middleView.pl_width * 0.5 : 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
