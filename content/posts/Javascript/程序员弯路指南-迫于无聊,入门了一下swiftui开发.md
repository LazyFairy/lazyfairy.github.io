---
title: 程序员弯路指南-迫于无聊,入门了一下 swiftui 开发
intro: ""
featured_image: ""
date: 2020-10-24 09:08:35
---

上一篇文章写了点开发板的记录，基础刚刚看完，下一步需要搞焊接了，没买装备，暂时放下了，

最近莫名想着搞独立开发了，找了各种方向还是觉得做 apple store 的 app 会比较合适，于是拿着 ios14 上线之后很火的 widget 做了些练习，这里记录一下

## 学习目标

想要用于开发 widget，app 的主要内容还是倾向于使用 flutter

## 基础语法

这个还没细看，基于 xcode 代码提示和实际问题开始的

## 入门文档

[官方手把手教学 立即开始做一个简单 app](https://developer.apple.com/tutorials/swiftui/)

[swift 官方文档资源](https://developer.apple.com/cn/swift/resources/)

[SwiftUI 程式開發初體驗 medium.com ](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/swiftui-%E7%A8%8B%E5%BC%8F%E9%96%8B%E7%99%BC%E5%88%9D%E9%AB%94%E9%A9%97-aea9122741b1) 这是我找到的一个，官方的虽然交互漂亮，但是有点太慢了

[https://onevcat.com/ 猫神 似乎是个大咖 出过相关的开发书籍](https://onevcat.com/)

## 遇到的问题 解决记录

### 打开 xcode 找不到组件属性面板

因为 xcode11 之后支持了 canvas 实时预览组件，这个属性面板跟随了 canvas 的显示和隐藏，

![](https://tva1.sinaimg.cn/large/0081Kckwgy1gk05ufl3euj30uq0lqq3z.jpg)
右上角点击+号有一个选择组件可以直接拖放的面板，也跟随了这个设置

### swift ui 自动撑开父组件

和 flutter 一样，swift ui 常用布局组件类似 html 的<code>display:flex</code> ，但是没有实现类型<code>flex：1</code>的属性

需要使用一个 Spacer 的组件撑开剩余的空间
![](https://tva1.sinaimg.cn/large/0081Kckwgy1gk05yx1ha7j30i609e0sv.jpg)

### CocoaPods 使用

1.安装 [https://cocoapods.org/](https://cocoapods.org/)

2.使用<code>pod init</code>在工作目录进行初始化，之后打开<code>Profile</code>文件编辑

```
# Uncomment the next line to define a global platform for your project
# 指定ios版本
platform :ios, '10.0'

# 因为我需要在 app 和 widget 同时使用，所以直接全局安装了
pod 'Alamofire', '~> 5.2'
pod 'SwiftyJSON'

target 'infoExtension' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  # 在这里安装需要的库
  # Pods for infoExtension

end

target 'v2widget' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!



  # Pods for v2widget

  target 'v2widgetTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'v2widgetUITests' do
    # Pods for testing
  end

end

```

3.编辑完成之后，返回命令行在工作目录执行 <code>pod install </code>安装 4.安装完成之后需要关闭 xcode,找到工作目录，打开 workspace 文件，这个是 pod 新建的，包含了下载的库
![](https://tva1.sinaimg.cn/large/0081Kckwgy1gk068v86yhj30ok0bi3yx.jpg)

### request 网络请求(需要用到一个 Alamofire 的库

上一段已经安装了需要的库
最新版本的 Alamofire 不能直接使用 Alamofire.request 调用，而是声明了一个 AF 的命名空间
使用是类似 <code>AF.request(url)</code>

```swift
//声明url !在某些场景下表示必须实现类型
let url = URL(string: "https://www.xxxx.com/api/members/show.json?username=suke971219")!

//responseJSON 表示返回json类型 还支持string及其他类型
var user:User;
AF.request(url,method: HTTPMethod.get).responseJSON{
            response in
            // response in 相当于 (response)=>{} 但是不知道为什么这里不需要大括号{}
            switch (response.result){
            case .success(let json):
                print(json )//这里的json应该已经转换了 但是是一个Any类型，下一步类型强转
                let dict = json as! Dictionary<String,AnyObject>
                user = User(json:dict)
                print(user)
            case .failure(let err):
                print("error \(err)")
            }
        }
```

### Dictionary 到一个实际的 model（直接使用字典类型似乎不是一个好习惯

我找了很多，推荐的都是[HandyJSON](https://github.com/alibaba/HandyJSON) [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) 以及一些其他的框架，但是我使用 pod 安装的时候遇到了一个 swift 版本的问题，我有必须使用最新版本的强迫症，所以没有继续

这是一个简单的例子，在上一段中我们传入了一个 Dictionary 类型的字典，可以直接在初始化的阶段给对象赋值

```swift
public struct User {
    var username:String?
    var website:String?
    var github:String?
    var avatar_normal:String?
    var url:String?
    var created:Int?
    var location:String?
    var id:Int?
    var day:String?
    var twitter:String?

    init(json: Dictionary<String, Any>){
        self.username = json["username"] as? String
        self.website = json["website"] as? String
        self.github = json["github"] as? String
        self.avatar_normal = json["avatar_normal"] as? String
        self.created = json["created"] as? Int
        self.location = json["location"] as? String
        self.id = json["id"] as? Int
        self.twitter = json["twitter"] as? String
        self.day = timeStampToCurrennTime(timeStamp: Double(self.created ?? 0))
    }
}
```

### 一个转换时间戳的小工具

[掘金-swift 时间戳与时间相互转化](https://juejin.im/post/6844903796141735950)

### 模块间相互引用

你可以新建一个目录创建一些工具类的文件，并且只要在文件属性的 target 指定相关的模块就可以直接引用了

![](https://tva1.sinaimg.cn/large/0081Kckwgy1gk06tto0urj31f70u0tfh.jpg)
