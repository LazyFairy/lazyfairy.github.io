---
title: Flutter开发日记-侧滑删除组件
intro: ""
featured_image: ""
date: 2020-04-07 09:41:25
---

# flutter 侧滑删除组件

文件地址 [click here](https://github.com/Treblex/go-echo-demo/blob/master/flutter_client/lib/library/SlidingEventsStatus.dart)

这个组件现在还处于刚刚好能用的状态，问题还蛮多，就是在点击和 touch 事件的时候记录位置，处理偏移

布局使用的一个<code>Stack</code>定位组件
![](https://tva1.sinaimg.cn/large/007S8ZIlgy1ge1ed7ly39j30ue0m0whi.jpg)
以及在行首定义了一个 eventbus，可以在页面调用的时候通知全局点击重置状态

需要一个 event_bus 插件支持

```dart
import 'package:event_bus/event_bus.dart';

```
