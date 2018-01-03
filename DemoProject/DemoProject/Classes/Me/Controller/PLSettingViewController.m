//
//  PLSettingViewController.m
//  OC项目-综合应用
//
//  Created by Page on 2017/12/14.
//  Copyright © 2017年 Page. All rights reserved.
//

#import "PLSettingViewController.h"
#import "PLFileTool.h"
#import <SVProgressHUD/SVProgressHUD.h>

#define CachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

@interface PLSettingViewController ()

@property (nonatomic, assign) NSInteger totalSize;

@end

@implementation PLSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    // 处理cell间距
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = PLMargin;
    // tableView分组样式默认有额外头部高度 (35)
    self.tableView.contentInset = UIEdgeInsetsMake(PLMargin - 35, 0, 0, 0);
    
    // 获取缓存文件夹大小
    [PLFileTool getFileSize:CachePath completion:^(NSInteger totalSize) {
        
        _totalSize = totalSize;
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.textLabel.text = [self sizeStr];
    }];

}

// 获取缓存大小字符串
- (NSString *)sizeStr
{
    NSInteger totalSize = _totalSize;
    NSString *sizeStr;
    // MB KB B
    if (totalSize > 1000 * 1000) {
        // MB
        CGFloat sizeF = totalSize / 1000.0 / 1000.0;
        sizeStr = [NSString stringWithFormat:@"清除缓存(已使用%.1fMB)",sizeF];
    } else if (totalSize > 1000) {
        // KB
        CGFloat sizeF = totalSize / 1000.0;
        sizeStr = [NSString stringWithFormat:@"清除缓存(已使用%.1fKB)",sizeF];
    } else if (totalSize > 0) {
        // B
        sizeStr = [NSString stringWithFormat:@"清除缓存(已使用%.ldB)",totalSize];
    } else if (totalSize == 0) {
        // B
        sizeStr = @"清除缓存";
    }
    
    return sizeStr;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        // 清空缓存, 删除文件夹里面所有文件
        [PLFileTool removeDirectoryPath:CachePath];
        _totalSize = 0;
        
        [SVProgressHUD showSuccessWithStatus:@"清除缓存成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.text = [self sizeStr];
    }
    
}

@end
