#import <UIKit/UIKit.h>

/** UITabBar的高度 */
CGFloat const PLTabBarH = 49;

/** 导航栏的最大Y值 */
CGFloat const PLNavMaxY = 64;

/** 标题栏的高度 */
CGFloat const PLTitlesViewH = 35;

/** 全局统一的间距 */
CGFloat const PLMargin = 10;

/** 统一的请求路径 */
NSString  * const PLCommonURL = @"http://api.budejie.com/api/api_open.php";

/** TabBarButton被重复点击的通知 */
NSString  * const PLTabBarButtonDidRepeatClickNotification = @"PLTabBarButtonDidRepeatClickNotification";

/** TitleButton被重复点击的通知 */
NSString  * const PLTitleButtonDidRepeatClickNotification = @"PLTitleButtonDidRepeatClickNotification";
