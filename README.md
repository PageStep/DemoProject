# DemoProject 展示

### 模块-主页
- 显示娱乐视频, 图片, 文字...
 - 点击视频播放, 点击图片查看大图
 - 查看大图时, 点击保存, 保存到系统相册和APP对应相册
 - 下拉刷新, 上拉加载更多
 - 左右滑动切换视频, 图片...界面
 
![](https://github.com/PageStep/DemoProject/raw/master/Shot1.png)

### 模块-关注
- 点击推荐关注, 弹出推荐列表

### 模块-登陆界面
- 点击弹出登陆界面或注册界面

### 模块-我的
- 详情界面
- 设置界面, 显示已使用缓存, 点击清除缓存

![](https://github.com/PageStep/DemoProject/raw/master/5.png)

# DemoProject 设计思路

### 基本架构
- window.rootViewController -> UITabBarController
- tabBarController.viewControllers -> UINavigationController
- navigationController.rootViewController -> UIViewController / UITableViewController

- 1.在tabBarController中分别设置navigationController的tabBarItem.title, tabBarItem.image, tabBarItem.selectedImage

- 2.自定义UINavigationController
 - 重写+(void)load方法, 设置导航栏上全局的标题字体属性和全局的背景图片
 - 重写pushViewController...方法, 拦截push出来的控制器
   - 1.设置控制器的属性, `hidesBottomBarWhenPushed = YES`
   - 2.设置控制器的navigationItem.leftBarButtonItem为自定义的UIBarButtonItem, 替换系统的UIBarButtonItem样式, 替换后, 系统的滑动返回手势失效
  - 在self.view中添加一个全屏滑动返回手势, 利用系统的手势代理调用系统的手势代理方法
  
### 模块-主页
#### 1.主页控制器中 (UIViewController)

- 1.设置导航栏的内容
- 2.添加多个子控制器分别管理视频, 图片等内容, 子控制器继承UITableViewController, 可以上下滚动
- 3.添加一个滚动视图(scrollView)
 - 根据主页控制器中中子控制器的count来设置其contentSize
 - 设置scrollView的相关属性和delegate
 - 在代理方法中监听scrollView的滚动结束, 添加对应子控制器的view (如果view已经被加载过，就直接返回)
- 4.添加一个标题视图(titleView)
 - titleView上添加多个button对应视频, 图片等内容
 - 监听button的点击, 改变titleView中button的颜色, 添加对应子控制器的view
 - 监听button的重复点击, 发出通知让对应的子控制器进行刷新最新数据的操作
- 5.进入主页控制器, 自动加载index为0的子控制器

#### 2.子控制器中(UITableViewController)
- 1.自定义数据模型(item)
- 2.新增模型数组属性, 保存从服务器获取的数据
- 3.设置tableView.contentInset, 使cell在导航栏或tabBar后可以看到(透视效果)
- 4.设置tableView.separatorStyle为none (tableView自带的分隔线两边有空隙)
- 5.添加通知中心监听, 来监听titleView中button的重复点击
- 6.利用MJRefresh框架设置上拉刷新控件和下拉加载更多控件
- 7.实现tableView的数据源方法
- 8.实现tableView的代理方法scrollViewDidScroll:来稳定内存缓存
- 9.实现刷新数据的方法
 - 根据接口文档, 确定参数和请求方式
 - 发送请求, 在回调block中, 获取响应体中数据, 一般是字典数组, 利用MJExtension框架, 将字典数组转换为模型数组, 然后reloadData
- 10.实现加载更多数据的方法
 - 步骤和刷新数据一样, 只是把获取到的字典数组添加到模型数组中

> 注意: 在请求数据之前, 先取消之前的数据请求, 因为如果网速不好的情况下, 上拉刷新时, 数据还没获取到时, 又下拉加载更多, 因为请求数据是异步执行的, 所以可能是刷新的数据先获取到, 保存到模型数组中,加载更多的数据后获取到, 再添加到数组中, 而加载更多的数据是根据之前旧数据的最后一个请求的, 所以最后有可能会造成数据缺失, 解决方案: 在请求数据之前, 先取消之前的数据请求

#### 3.自定义多个UIView, 同时创建xib来描述view
- 1.多个自定义view分别用来在cell中显示视频 / 图片 / ...
- 2.在自定义view中新增模型属性(item), 重写setItem:方法:
 - 把传递过来的模型数据, 赋值给相应的控件
 - 设置view中imageView的image时, 根据网络状态设置不同质量的image 
 - 如果image是长图时, 还需要利用Quartz2D重新绘制image, 保证image显示时没有被拉伸变形
- 3.在awakeFromNib方法中:
 - 设置 `self.autoresizingMask = UIViewAutoresizingNone;`使其不跟随父控件size变化而变化
 - 监听view中imageView的点击, 弹出图片查看控制器

#### 4.自定义UITableViewCell, 同时创建xib来描述cell
- 1.在xib中搭建好固定的控件, 设置好约束和属性
- 2.新增视图控件属性(自定义的view), 实现懒加载
- 3.新增模型(item)属性, 重写setItem:方法:
 - 把传递过来的模型数据, 赋值给相应的控件
 - 根据模型数据, 来判断显示和隐藏哪些视图控件(循环引用机制)
 - 如果显示某个自定义view, 把模型数据传递过去
- 4.重写setFrame:方法:
 - 把传进来的frame中的size.height减去10, 再调用`[super setFrame:frame];`cell之间就会产生间距为10的间距, 这种方法设置cell之间的间距简单方便
 > 原理: tableView出现之前, 会调用代理方法`tableView:heightForRowAtIndexPath:`多次, 所有cell的height确定了, 所以tableView的布局也确定了, 再重写cell的setFrame:方法:
改变cell的height, 就可以使cell之间产生间距了
 
#### 5.在自定义的数据模型中增加两个属性cellHeight和viewFrame
- 1.重写cellHeight属性的get方法:
 - 计算cell的height, 返回给tableView的代理方法`tableView:heightForRowAtIndexPath:`
 - 计算自定义view的frame赋值给viewFrame属性
- 2.在自定义cell的layoutSubviews方法中, 把数据模型中的viewFrame赋值给自定义view, 完成view在cell中的布局

#### 6.自定义UIViewController, 来查看大图, 同时创建xib
- 1.添加scrollView, 并在scrollView上添加点按手势来退出控制器
- 2.在scrollView中添加imageView, 根据image大小来布局imageView
- 3.设置`scrollView.maximumZoomScale`来缩放图片 (需要实现UIScrollView代理方法: `viewForZoomingInScrollView:` )
- 4.利用系统的Photos框架, 提供保存图片到系统相册和APP对应相册的功能


### 模块-关注
#### 1.关注控制器中 (UIViewController), 创建xib描述
- 1.搭建界面, 提供自定义方法快速设置导航栏的barButtonItem
> 在自定义方法中, 把UIButton包装成UIBarButtonItem会导致按钮点击区域扩大, 解决方案: 用添加了button的view来代替

#### 2.推荐列表控制器 (UITableViewController)
- 1.用MVC设计模式, controller请求数据, model接收数据, view设置数据
- 2.在cell中设置图片时, 利用Quartz2D把图片裁剪成圆形


### 模块-登陆界面
#### 1.登陆界面控制器 (UIViewController), 同时创建xib描述
- 1.登陆界面分为上, 中, 下, 3块区域, 控制器的xib中搭建上面的区域

#### 2.自定义view, 同时创建xib, 描述登陆界面中间的区域
- 1.自定义textField
 - 设置光标颜色为白色
 - 监听textField, 开始编辑时占位文字颜色为whiteColor, 结束编辑时占位文字颜色为lightGrayColor
 - textField并没有占位文字颜色这个属性, 但是可以利用runtime, 获取UITextField的私有属性placeholderLabel, 拿到这个属性后, 再设置其颜色
- 2.xib中, 注册view和登陆view只是button的title不一样而已
- 3.提供类方法, 加载xib中的view

#### 3.自定义view, 同时创建xib, 描述登陆界面下面的区域
- 1.该区域的button中, imageView在上方, titleLabel在下方, 而默认的UIButton中, imageView在左边, titleLabel在右边, 解决方案: 自定义button, 在layoutSubviews方法中, 修改imageView和titleLabel的布局
- 2.提供类方法, 加载xib中的view


### 模块-我的
#### 1.详情界面 (UITableViewController), 同时创建storyboard描述
- 1.创建有流水布局的collectionView作为tableView的tableFooterView
- 2.用MVC设计模式展示collectionView中的cell
- 3.实现UICollectionView代理方法, 监听cell的点击, 如果可以打开URL, 创建SFSafariViewController, 并且以modal形式弹出 (可以响应"完成"按钮的点击)

#### 2.设置界面 (UITableViewController), 同时创建storyboard描述
- 1.自定义文件管理工具, 实现计算缓存大小的方法(计算操作异步执行), 实现删除缓存的方法

### 其它
- 用到的第三方框架
 - AFNetworking
 - SDWebImage
 - MJExtension
 - MJRefresh
 - SVProgressHUD
- 注意: Assets.xcassets中的mainCellBackground图片要在xib中设置其slicing属性, 设置拉伸时的保护区域
