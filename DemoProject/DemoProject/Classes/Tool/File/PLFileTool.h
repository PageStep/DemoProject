//
//  PLFileTool.h
//  OC项目-综合应用
//
//  Created by Page on 2017/12/15.
//  Copyright © 2017年 Page. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLFileTool : NSObject

/**
 *  获取文件夹尺寸
 *
 *  @param directoryPath 文件夹路径
 */

+ (void)getFileSize:(NSString *)directoryPath completion:(void(^)(NSInteger))completion;


/**
 *  删除文件夹所有文件
 *
 *  @param directoryPath 文件夹路径
 */
+ (void)removeDirectoryPath:(NSString *)directoryPath;

@end
