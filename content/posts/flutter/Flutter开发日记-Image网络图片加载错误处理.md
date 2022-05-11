---
title: Flutter开发日记-Image网络图片加载错误处理
intro: ""
featured_image: ""
date: 2020-04-07 09:41:10
---

# 自定义 ImageProvider 实现

文件 github 地址 ：[click here](https://github.com/Treblex/go-echo-demo/blob/master/flutter_client/lib/library/NetImage.dart)

注释比较清楚，不多写了,这个主题很好看，但是代码高亮一直没啥反应

主要的方法都是和原生组件已有的，主要重写了 \_loadAsync 方法（图片加载）以及 getter operator 的实现（影响底层组件判断这张图片是否使用缓存）
