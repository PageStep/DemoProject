# DemoProject 展示

### 提供娱乐视频、图片、文字的 App

## 模块-主页
- 左右滑动切换视频, 图片...界面
- 点击视频播放, 点击图片查看大图
- 查看大图时, 点击保存, 保存到系统相册和APP对应相册
- 下拉刷新, 上拉加载更多
     
![gif](https://github.com/PageStep/DemoProject/raw/master/Screenshots/1.gif)

## 模块-关注
- 点击推荐关注, 弹出推荐列表

![gif](https://github.com/PageStep/DemoProject/raw/master/Screenshots/2.gif)

## 模块-登陆界面
- 点击弹出登陆界面或注册界面

![gif](https://github.com/PageStep/DemoProject/raw/master/Screenshots/3.gif)

## 模块-我的
- 详情界面
- 设置界面, 显示已使用缓存, 点击清除缓存

![gif](https://github.com/PageStep/DemoProject/raw/master/Screenshots/4.gif)


# DemoProject 设计思路

## 基本架构
- window.rootViewController -> UITabBarController
- tabBarController.viewControllers -> UINavigationController
- navigationController.rootViewController -> UIViewController / UITableViewController

- 1.在 tabBarController 中分别设置 navigationController 的 tabBarItem.title, tabBarItem.image, tabBarItem.selectedImage

- 2.自定义 UINavigationController
  - 重写 +(void)load 方法, 设置导航栏上全局的标题字体属性和全局的背景图片
  - 重写 pushViewController... 方法, 拦截 push 出来的控制器
    - 1.设置控制器的属性, `hidesBottomBarWhenPushed = YES`
    - 2.设置控制器的 navigationItem.leftBarButtonItem 为自定义的 UIBarButtonItem, 替换系统的 UIBarButtonItem 样式, 替换后, 系统的滑动返回手势失效
    - 3.在 self.view 中添加一个全屏滑动返回手势, 利用系统的手势代理调用系统的手势代理方法
  
## 模块-主页
### 1.主页控制器中 (UIViewController)

- 1.设置导航栏的内容
- 2.添加多个子控制器分别管理视频, 图片等内容, 子控制器继承 UITableViewController, 可以上下滚动
- 3.添加一个滚动视图 (scrollView)
  - 根据主页控制器中中子控制器的count来设置其 contentSize
  - 设置 scrollView 的相关属性和 delegate
  - 在代理方法中监听 scrollView 的滚动结束, 添加对应子控制器的 view (如果 view 已经被加载过，就直接返回)
- 4.添加一个标题视图 (titleView)
  - titleView 上添加多个 button 对应视频, 图片等内容
  - 监听 button 的点击, 改变 titleView 中 button 的颜色, 添加对应子控制器的 view
  - 监听 button 的重复点击, 发出通知让对应的子控制器进行刷新最新数据的操作
- 5.进入主页控制器, 自动加载 index 为 0 的子控制器

### 2.子控制器中 (UITableViewController)
- 1.自定义数据模型 (item)
- 2.新增模型数组属性, 保存从服务器获取的数据
- 3.设置 tableView.contentInset, 使 cell 在导航栏或 tabBar 后可以看到(透视效果)
- 4.设置 tableView.separatorStyle 为 none (因为 tableView 自带的分隔线两边有空隙)
- 5.添加通知中心监听, 来监听 titleView 中 button 的重复点击
- 6.利用 MJRefresh 框架设置上拉刷新控件和下拉加载更多控件
- 7.实现 tableView 的数据源方法
- 8.实现 tableView 的代理方法 scrollViewDidScroll: 来稳定内存缓存
- 9.实现刷新数据的方法
  - 根据接口文档, 确定参数和请求方式
  - 发送请求, 在回调 block 中, 获取响应体中数据, 一般是字典数组, 利用 MJExtension 框架, 将字典数组转换为模型数组, 然后 reloadData
- 10.实现加载更多数据的方法
  - 步骤和刷新数据一样, 只是把获取到的字典数组添加到模型数组中

> 注意: 在请求数据之前, 先取消之前的数据请求, 因为如果网速不好的情况下, 上拉刷新时, 数据还没获取到时, 又下拉加载更多, 因为请求数据是异步执行的, 所以可能是刷新的数据先获取到, 保存到模型数组中,加载更多的数据后获取到, 再添加到数组中, 而加载更多的数据是根据之前旧数据的最后一个请求的, 所以最后有可能会造成数据缺失, 解决方案: 在请求数据之前, 先取消之前的数据请求

### 3.自定义多个 UIView, 同时创建 xib 来描述 view
- 1.多个自定义 view 分别用来在 cell 中显示视频 / 图片 / ...
- 2.在自定义 view 中新增模型属性 (item), 重写 setItem: 方法:
  - 把传递过来的模型数据, 赋值给相应的控件
  - 设置 view 中 imageView 的 image 时, 根据网络状态设置不同质量的 image 
  - 如果 image 是长图时, 还需要利用 Quartz2D 重新绘制 image, 保证 image 显示时没有被拉伸变形
- 3.在 awakeFromNib 方法中:
  - 设置 `self.autoresizingMask = UIViewAutoresizingNone;`使其不跟随父控件 size   变化而变化
  - 监听 view 中 imageView 的点击, 弹出图片查看控制器

### 4.自定义 UITableViewCell, 同时创建 xib 来描述 cell
- 1.在 xib 中搭建好固定的控件, 设置好约束和属性
- 2.新增视图控件属性(自定义的 view), 实现懒加载
- 3.新增模型 (item) 属性, 重写 setItem: 方法:
  - 把传递过来的模型数据, 赋值给相应的控件
  - 根据模型数据, 来判断显示和隐藏哪些视图控件(防止循环利用)
  - 如果显示某个自定义 view, 把模型数据传递过去
- 4.重写 setFrame: 方法:
  - 把传进来的 frame 中的 size.height 减去 10, 再调用`[super setFrame:frame];`cell 之间就会产生间距为10的间距, 这种方法设置 cell 之间的间距简单方便
  > 原理: tableView 出现之前, 会调用代理方法`tableView:heightForRowAtIndexPath:`多次, 所有 cell 的 height 确定了, 所以 tableView 的布局也确定了, 再重写 cell 的 setFrame: 方法, 改变 cell 的height, 就可以使 cell 之间产生间距了
 
### 5.在自定义的数据模型中增加两个属性 cellHeight 和 viewFrame
- 1.重写 cellHeight 属性的 get 方法:
  - 计算 cell 的 height, 返回给 tableView 的代理方法`tableView:heightForRowAtIndexPath:`
  - 计算自定义 view 的 frame 赋值给 viewFrame 属性
- 2.在自定义 cell 的 layoutSubviews 方法中, 把数据模型中的 viewFrame 赋值给自定义 view, 完成 view 在 cell 中的布局

### 6.自定义 UIViewController, 来查看大图, 同时创建 xib
- 1.添加 scrollView, 并在 scrollView 上添加点按手势来退出控制器
- 2.在 scrollView 中添加 imageView , 根据 image 大小来布局 imageView
- 3.设置`scrollView.maximumZoomScale`来缩放图片 (需要实现 UIScrollView 的代理方法: `viewForZoomingInScrollView:` )
- 4.利用系统的 Photos 框架, 提供保存图片到系统相册和 APP 对应相册的功能


## 模块-关注
### 1.关注控制器中 (UIViewController), 创建 xib
- 1.搭建界面, 提供自定义方法快速设置导航栏的 barButtonItem
> 在自定义方法中, 把 UIButton 包装成 UIBarButtonItem 会导致按钮点击区域扩大, 解决方案: 用添加了 button 的 view 来代替

### 2.推荐列表控制器 (UITableViewController)
- 1.用 MVC设计模式: controller 请求数据, model 接收数据, view 设置数据
- 2.在 cell 中设置图片时, 利用 Quartz2D 把图片裁剪成圆形


## 模块-登陆界面
### 1.登陆界面控制器 (UIViewController), 同时创建 xib 
- 1.登陆界面分为上, 中, 下, 3块区域, 控制器的 xib 中搭建上面的区域

### 2.自定义 view, 同时创建 xib, 描述登陆界面中间的区域
- 1.自定义 textField
  - 设置光标颜色为白色
  - 监听 textField, 开始编辑时占位文字颜色为 whiteColor, 结束编辑时占位文字颜色为 lightGrayColor
  - textField 并没有占位文字颜色这个属性, 但是可以利用 runtime, 获取 UITextField的私有属性 placeholderLabel, 拿到这个属性后, 再设置其颜色
- 2.xib 中, 注册 view 和登陆 view 只是 button 的 title 不一样而已
- 3.提供类方法, 加载 xib 中的 view

### 3.自定义 view, 同时创建 xib, 描述登陆界面下面的区域
- 1.该区域的 button 中, imageView 在上方, titleLabel 在下方, 而默认的 UIButton 中, imageView 在左边, titleLabel 在右边, 解决方案: 自定义 button, 在 layoutSubviews 方法中, 修改 imageView 和 titleLabel 的布局
- 2.提供类方法, 加载 xib 中的 view


## 模块-我的
### 1.详情界面 (UITableViewController), 同时创建 storyboard 
- 1.创建有流水布局的 collectionView 作为 tableView 的 tableFooterView
- 2.用MVC设计模式展示 collectionView 中的 cell
- 3.实现 UICollectionView 的代理方法, 监听 cell 的点击, 如果可以打开 URL, 创建 SFSafariViewController, 并且以 modal 形式弹出 (可以响应"完成"按钮的点击)

### 2.设置界面 (UITableViewController), 同时创建 storyboard
- 1.自定义文件管理工具, 实现计算缓存大小的方法(计算操作异步执行), 实现删除缓存的方法


## 其它

- 用到的第三方框架
  - AFNetworking
  - SDWebImage
  - MJExtension
  - MJRefresh
  - SVProgressHUD
