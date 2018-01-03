//
//  PLAdViewController.m
//  OC项目-综合应用
//
//  Created by Page on 2017/12/14.
//  Copyright © 2017年 Page. All rights reserved.
//

#import "PLAdViewController.h"
#import "PLTabBarController.h"
#import <AFNetworking/AFNetworking.h>
#import <UIImageView+WebCache.h>
#import <MJExtension/MJExtension.h>
#import "PLAdItem.h"

#define code2 @"phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam"

@interface PLAdViewController ()

@property (weak, nonatomic) IBOutlet UIView *adContentView;
@property (weak, nonatomic) IBOutlet UIButton *jumpButton;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) PLAdItem *item;

@property (nonatomic, weak) UIImageView *adImageView;

@end

@implementation PLAdViewController

- (UIImageView *)adImageView {
    if (_adImageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        
        [self.adContentView addSubview:imageView];
        
        _adImageView = imageView;
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAd)];
        [_adImageView addGestureRecognizer:tapGes];
        
    }
    
    return _adImageView;
}

- (void)tapAd {
    // 点击广告跳转到safari
    NSURL *url = [NSURL URLWithString:_item.ori_curl];
    
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:url]) {
        [app openURL:url];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadAdData];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
  
}

- (void)timeChange {
    
    static int i = 3;
    
    if (i == 0) {
        [self jump];
    }
    
    i--;
    
    [self.jumpButton setTitle:[NSString stringWithFormat:@"跳转 (%d)", i] forState:UIControlStateNormal];
  
}

- (IBAction)jump {
    
    [UIApplication sharedApplication].keyWindow.rootViewController = [[PLTabBarController alloc] init];
    
    [self.timer invalidate];
}

- (void)loadAdData {
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"code2"] = code2;
    
    [mgr GET:@"http://mobads.baidu.com/cpro/ui/mads.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {

        NSDictionary *adDict = [responseObject[@"ad"] firstObject];
        _item = [PLAdItem mj_objectWithKeyValues:adDict];

        // 设置adImageView的frame
        CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
        CGFloat adViewH = screenW * _item.h / _item.w;
        self.adImageView.frame = CGRectMake(0, 0, screenW, adViewH);
        
        // 加载广告图片
        [self.adImageView sd_setImageWithURL:[NSURL URLWithString:_item.w_picurl]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        PLLog(@"%@", error);
    }];

}

@end
