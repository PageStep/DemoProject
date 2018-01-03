//
//  PLEssenceViewController.m
//  OC项目-综合应用
//
//  Created by Page on 2017/12/14.
//  Copyright © 2017年 Page. All rights reserved.
//

#import "PLEssenceViewController.h"

#import "PLTitleButton.h"

#import "PLAllViewController.h"
#import "PLVideoViewController.h"
#import "PLVoiceViewController.h"
#import "PLPictureViewController.h"
#import "PLWordViewController.h"

@interface PLEssenceViewController () <UIScrollViewDelegate>

/** 标题栏 */
@property (nonatomic, weak) UIView *titlesView;
/** 标题下划线 */
@property (nonatomic, weak) UIView *titleUnderline;
/** 上一次点击的标题按钮 */
@property (nonatomic, weak) PLTitleButton *selectedButton;
/** 用来存放所有子控制器view的scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation PLEssenceViewController

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"主页";
    
    // 设置导航条
    [self setupNavBar];
    
    // 初始化子控制器
    [self setupAllChildVcs];
    
    // scrollView
    [self setupScrollView];
    
    // 标题栏
    [self setupTitlesView];
    
    // 添加第0个子控制器的view (懒加载)
    [self addChildVcViewIntoScrollView:0];
}

// 设置导航条
- (void)setupNavBar {
    
    // 左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"nav_item_game_icon"] highlightedImage:[UIImage imageNamed:@"nav_item_game_click_icon"] target:self action:@selector(game)];
    
    // 右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"navigationButtonRandom"]  highlightedImage:[UIImage imageNamed:@"navigationButtonRandomClick"] target:nil action:nil];
}

- (void)game {
    
}

// 初始化子控制器
- (void)setupAllChildVcs {
    [self addChildViewController:[[PLAllViewController alloc] init]];
    [self addChildViewController:[[PLVideoViewController alloc] init]];
    [self addChildViewController:[[PLVoiceViewController alloc] init]];
    [self addChildViewController:[[PLPictureViewController alloc] init]];
    [self addChildViewController:[[PLWordViewController alloc] init]];
}

// scrollView
- (void)setupScrollView {
    // 不允许自动修改UIScrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 创建scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor blueColor];
    scrollView.frame = self.view.bounds;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    // 点击状态栏的时候，这个scrollView不会滚动到最顶部
    scrollView.scrollsToTop = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    
    // 添加子控制器的view到scrollView
    NSUInteger count = self.childViewControllers.count;
    CGFloat scrollViewW = scrollView.pl_width;
    
    scrollView.contentSize = CGSizeMake(count * scrollViewW, 0);
}

// 标题栏
- (void)setupTitlesView {
    UIView *titlesView = [[UIView alloc] init];
    
    // 设置半透明背景色
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    
    titlesView.frame = CGRectMake(0, 64, self.view.pl_width, 35);
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 设置标题栏按钮
    [self setupTitleButtons];
    
    // 设置标题下划线
    [self setupTitleUnderline];
}

// 标题栏按钮
- (void)setupTitleButtons {
    // 文字
    NSArray *titles = @[@"全部", @"视频", @"声音", @"图片", @"文字"];
    NSUInteger count = titles.count;
    
    // 标题按钮的尺寸
    CGFloat titleButtonW = self.titlesView.pl_width / count;
    CGFloat titleButtonH = self.titlesView.pl_height;
    
    // 创建5个标题按钮
    for (NSUInteger i = 0; i < count; i++) {
        
        PLTitleButton *titleButton = [[PLTitleButton alloc] init];
        titleButton.tag = i;
        [titleButton addTarget:self action:@selector(clickTitleButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.titlesView addSubview:titleButton];
        // frame
        titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
        // 文字
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
    }
}

//标题下划线
- (void)setupTitleUnderline {
    // 获取标题按钮的backgroundColor
    PLTitleButton *firstTitleButton = self.titlesView.subviews.firstObject;
    UIColor *backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];
    
    // 下划线
    UIView *titleUnderline = [[UIView alloc] init];
    titleUnderline.pl_height = 2;
    titleUnderline.pl_y = self.titlesView.pl_height - titleUnderline.pl_height;
    titleUnderline.backgroundColor = backgroundColor;
    [self.titlesView addSubview:titleUnderline];
    self.titleUnderline = titleUnderline;
    
    // 进入页面默认点击firstTitleButton (没有动画效果)
    firstTitleButton.selected = YES;
    self.selectedButton = firstTitleButton;
    
    // 虽然已经设置了按钮中label的内容, 但viewDidLoad方法中不会主动去根据内容计算label的尺寸, 这里用sizeToFit主动去让label根据文字内容计算尺寸
    [firstTitleButton.titleLabel sizeToFit];
    
    self.titleUnderline.pl_width = firstTitleButton.titleLabel.pl_width + PLMargin;
    self.titleUnderline.pl_centerX = firstTitleButton.pl_centerX;
}

#pragma mark - 监听
// 点击标题按钮
- (void)clickTitleButton:(PLTitleButton *)titleButton {
    // 重复点击了标题按钮
    if (self.selectedButton == titleButton) {
        [[NSNotificationCenter defaultCenter] postNotificationName:PLTitleButtonDidRepeatClickNotification object:nil];
    }
    
    [self manageSelectedTitleButton:titleButton];
}

- (void)manageSelectedTitleButton:(PLTitleButton *)titleButton {
    // 切换按钮状态
    self.selectedButton.selected = NO;
    titleButton.selected = YES;
    self.selectedButton = titleButton;
    
    NSUInteger index = titleButton.tag;
    
    [UIView animateWithDuration:0.25 animations:^{
        // 处理下划线
        self.titleUnderline.pl_width = titleButton.titleLabel.pl_width + PLMargin;
        self.titleUnderline.pl_centerX = titleButton.pl_centerX;
        
        // 滚动scrollView
        CGFloat offsetX = self.scrollView.pl_width * index;
        // 偏移y值保持原来
        self.scrollView.contentOffset = CGPointMake(offsetX, self.scrollView.contentOffset.y);
    } completion:^(BOOL finished) {
        // 添加子控制器的view (懒加载)
        [self addChildVcViewIntoScrollView:index];
    }];
    
    // 设置index位置对应的tableView.scrollsToTop = YES， 其它都设置为NO
    for (NSInteger i = 0; i < self.childViewControllers.count; i++) {
        UIViewController *childVc = self.childViewControllers[i];
        // 如果view还没有被创建，就不用去处理
        if (!childVc.isViewLoaded) continue;
        
        UIScrollView *scrollView = (UIScrollView *)childVc.view;
        if (![scrollView isKindOfClass:[UIScrollView class]]) continue;
        
        if (i == index) {
            // 是标题按钮对应的子控制器
            scrollView.scrollsToTop = YES;
        } else {
            scrollView.scrollsToTop = NO;
        }
        //        scrollView.scrollsToTop = (i == titleButton.tag);
        
    }
}

#pragma mark - <UIScrollViewDelegate>
// 当用户松开scrollView并且滑动结束时调用这个代理方法（scrollView停止滚动的时候）
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 算出标题按钮的索引
    NSUInteger index = scrollView.contentOffset.x / scrollView.pl_width;
    // 处理对应的标题按钮
    PLTitleButton *titleButton = self.titlesView.subviews[index];
    [self manageSelectedTitleButton:titleButton];
}

#pragma mark - 其它
// 添加第index对应子控制器的view到scrollView中
- (void)addChildVcViewIntoScrollView:(NSInteger)index {
    //取出按钮索引对应的控制器
    UIViewController *childVc = self.childViewControllers[index];
    
    // 如果view已经被加载过，就直接返回
    if (childVc.isViewLoaded) return;
    
    // 取出index位置对应的子控制器view
    UIView *childVcView = childVc.view;
    // 如果view已经被加载过，就直接返回
    
    // 设置子控制器view的frame
    /*
     self.scrollView.bounds.origin.x == self.scrollView.contentOffset.x
     self.scrollView.bounds.origin.y == self.scrollView.contentOffset.y
     */
    childVcView.frame = self.scrollView.bounds;
    
    // 添加子控制器的view到scrollView中
    [self.scrollView addSubview:childVcView];
}


@end
