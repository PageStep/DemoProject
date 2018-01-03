//
//  PLSeeBigPictureViewController.m
//  OC项目-综合应用1
//
//  Created by Page on 2017/12/16.
//  Copyright © 2017年 Page. All rights reserved.
//

#import "PLSeeBigPictureViewController.h"
#import "PLPostItem.h"
#import <Photos/Photos.h>
#import <SVProgressHUD.h>

@interface PLSeeBigPictureViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIImageView *imageView;

/** 返回当前APP对应的自定义相册 */
- (PHAssetCollection *)createdCollection;
/** 返回保存到【相机胶卷】的图片 */
- (PHFetchResult<PHAsset *> *)createdAssets;

@end

@implementation PLSeeBigPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = [UIScreen mainScreen].bounds;
    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)]];
    [self.view insertSubview:scrollView atIndex:0];
    self.scrollView = scrollView;
    
    // 添加imageView
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.item.image1] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) return;
        // 获取图片成功后, 保存按钮可点击
        self.saveButton.enabled = YES;
    }];
    // 根据image大小来布局imageView
    imageView.pl_width = scrollView.pl_width;
    imageView.pl_height = imageView.pl_width * self.item.height / self.item.width;
    imageView.pl_x = 0;
    if (imageView.pl_height > PLScreenH) { // 超过一个屏幕
        imageView.pl_y = 0;
        scrollView.contentSize = CGSizeMake(0, imageView.pl_height);
    } else {
        imageView.pl_centerY = scrollView.pl_height * 0.5;
    }
    [scrollView addSubview:imageView];
    self.imageView = imageView;
    
    // 设置图片缩放比例
    CGFloat maxScale = self.item.width / imageView.pl_width;
    if (maxScale > 1) {
        scrollView.maximumZoomScale = maxScale;
        scrollView.delegate = self;
    }
    
}

#pragma mark - <UIScrollViewDelegate>
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

#pragma mark - 返回上一界面
- (IBAction)goBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 保存图片
- (IBAction)clickSaveButton {
    
    // 获取访问权限的Status
    PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
    /*
     请求\检查访问权限:
     >如果用户还没有做出选择，会自动弹框，用户对弹框做出选择后，才会调用block
     >如果之前已经做过选择，会直接执行block
     */
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusDenied) { // 用户拒绝当前App访问相册
                
                if (oldStatus != PHAuthorizationStatusNotDetermined) {
                    [SVProgressHUD showWithStatus:@"请在【设置】>【隐私】>【照片】中允许程序访问照片"];
                }
            } else if (status == PHAuthorizationStatusAuthorized) { // 用户允许当前App访问相册
                [self saveImageIntoAlbum];
            } else if (status == PHAuthorizationStatusRestricted) { // 无法访问相册
                [SVProgressHUD showErrorWithStatus:@"系统限制，无法访问相册！"];
            }
        });
    }];
    
}

//保存图片到相册
- (void)saveImageIntoAlbum {
    // 1.获取保存到【相机胶卷】的图片
    PHFetchResult<PHAsset *> *createdAssets = self.createdAssets;
    if (createdAssets == nil) {
        [SVProgressHUD showErrorWithStatus:@"保存图片失败！"];
        return;
    }
    
    // 2.获取当前APP对应的【自定义相册】
    PHAssetCollection *createdCollection = self.createdCollection;
    if (createdCollection == nil) {
        [SVProgressHUD showErrorWithStatus:@"创建相册失败！"];
        return;
    }
    
    // 3.添加刚才保存的图片到【自定义相册】
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];
        
        [request insertAssets:createdAssets atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:&error];
    
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存图片失败！"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"保存图片成功！"];
    }
}

// 1.返回保存到【相机胶卷】的图片
- (PHFetchResult<PHAsset *> *)createdAssets {
    NSError *error = nil;
    __block NSString *assetID = nil;
    
    // 保存图片到【相机胶卷】
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        assetID = [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset.localIdentifier;
        
    } error:&error];
    
    if (error) return nil;
    
    // 获取刚才保存的相片
    return [PHAsset fetchAssetsWithLocalIdentifiers:@[assetID] options:nil];
}

// 2.返回当前APP对应的自定义相册
- (PHAssetCollection *)createdCollection {
    // 获得软件名字
    NSString *title = [NSBundle mainBundle].infoDictionary[(__bridge NSString *)kCFBundleNameKey];
    
    // 抓取所有的自定义相册
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    // 查找当前App对应的自定义相册
    for (PHAssetCollection *collection in collections) {
        if ([collection.localizedTitle isEqualToString:title]) {
            return collection;
        }
    }
    
    /** 当前App对应的自定义相册没有被创建过 **/
    // 创建一个【自定义相册】
    NSError *error = nil;
    __block NSString *createdCollectionID = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdCollectionID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    if (error) return nil;
    
    // 根据唯一标识获得刚才创建的相册
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createdCollectionID] options:nil].firstObject;
}



@end
