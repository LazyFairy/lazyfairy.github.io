---
title: "How to Use Flutter MethodChannel"
date: 2021-05-21T11:27:20+08:00
draft: true
---

资料：[https://stablekernel.com/article/flutter-platform-channels-quick-start/](https://stablekernel.com/article/flutter-platform-channels-quick-start/)


####  在flutter中methodChannel是双向的,既可以flutter调用本机代码，也可以本机代码调用flutter


flutter实现methodChannel

<code>channel.dart</code>

```dart
import 'package:flutter/services.dart';

class MyChannel {
  static MyChannel? _instance;
  static MyChannel shared() {
    if (_instance == null) {
      _instance = MyChannel();
    }
    return _instance!;
  }

  final String channelName = "default";
  MethodChannel? channel;

  MyChannel() {
    //初始化 MethodChannel
    channel = MethodChannel(channelName);

    //设置handler
    channel?.setMethodCallHandler((call) async {
      print(call.arguments); //dynamic
      switch (call.method) {
        case 'something':
          print("flutter method handler");
          break;
      }
      return "";
    });
  }
}


```

ios实现method channel

<code>AppDelegaet.swift</code>

```swift
import UIKit
import Flutter

class MethodChannel {
    var channel:FlutterMethodChannel?
    let channelName = "custom/methodChannel"
    init(rootView:FlutterViewController){
        // 初始化 methodChannel
        channel = FlutterMethodChannel(name: channelName, binaryMessenger: rootView as! FlutterBinaryMessenger)

        //    设置handler
        channel?.setMethodCallHandler {(call: FlutterMethodCall, result: FlutterResult) -> Void in
            if (call.method == "start") {

                //测试：反向跳用flutter代码
                let dict = NSMutableDictionary()
                dict.setValue(1, forKey: "keys1")
                self.channel?.invokeMethod("something", arguments:dict )


                result(1)
            }
        }

    }

}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        // 本机代码跳用methodChannel时需要rootViewController作为binaryMessenger传递消息
        let rootViewController : FlutterViewController = window?.rootViewController as! FlutterViewController
        var _ = MethodChannel.init(rootView: rootViewController)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}


```



### 调用
需要确保视图组件初始化之后调用，否则可能找不到对应的methodChannel

flutter
```dart
    var res = await MyChannel.shared().channel.invokeMethod("start");
    print(res);
```

swift
```swift
    let dict = NSMutableDictionary()
            dict.setValue(1, forKey: "keys1")
            methodChannel.invokeMethod("something", arguments:dict )
```


### ⚠️ 遗留的一个问题
1.我尝试在ios extension中使用flutter methodChannel复用flutter的代码，失败！

binaryMessenger不知道该怎么搞，extension与app的进程是分离的

目前似乎只能做到使用coredata相互通信
