---
title: Flutter实践
intro: ""
featured_image: ""
date: 2020-03-16 12:03:44
series: ["Themes Guide"]
---

# 环境配置

> 1. git clone https://github.com/flutter/flutter.git everyYouLike/flutter 设置环境变量指向 flutter/bin
> 2. 安装 vscode vscode flutter 插件
> 3. ctrl+p 命令模式 新建 flutter project

更多内容 [flutter.dev](https://flutter.dev)

# 推荐教程 [click here](https://book.flutterchina.club/)

# 开始

### 1.入口文件

```dart
import 'package:flutter/material.dart';
//不同于javascript，dart需要实现一个main函数，在执行文件到时候运行
void main() {
  runApp(MyApp()); //MyApp 实现一个组件类
}
```

### 2.MyApp 实现

```dart
class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  @override //class 继承之后  重写父类的方法
  Widget build(BuildContext context) {
    return new MaterialApp( //包含material组件
      title: "APP",
      home: Home(),//自定义实现到页面内容
      theme: ThemeData(primaryColor: CustomTheme.primaryColor),//主题
    );
  }
}
```

### 3.实现一个 Widget 组件

```dart
    Widget Home()=>Center(child:Text("hello world!"));
```

### 4.路由跳转

```dart
    Navigator.push(context,
        new MaterialPageRoute(
            builder: (BuildContext context) => newPageWidget()));
```

# 其他

### 状态栏高度

```dart
// 获取状态栏高度
double statusBarHeight(BuildContext c) => MediaQuery.of(c).padding.top;
// 底部安全区域
double bottomBarHeight(BuildContext c) => MediaQuery.of(c).padding.bottom;
```
