---
title: "程序员弯路指南关于-关于android\U0001F62D-我在网上瞎逼学的日常"
intro: ""
featured_image: ""
date: 2020-12-10 08:55:26
---

# First . ADB 基础 ，测试设备

这个在之前疯狂刷机的年纪学的，零零散散的没有具体的文档了，因为用的 android studio 所以直接找到相关目录加入环境变量即可'

```bash
    # 常用命令
    adb devices #列出已链接的设备
    adb connect 192.168.0.xx:5555 #链接局域网的设备
```

![](https://tva1.sinaimg.cn/large/0081Kckwgy1glihfjm9bvj31tk0lkq6d.jpg)

测试手机用的小米 note3，miui 开始慢慢限制权限了，所以刷了个魔趣的系统，开启开发者模式之后，可以在开发者模式里找到 网络 adb 开启

### ！跑题，关于刷机的步骤 非必要

Twrp 下载 [https://twrp.me/Devices/](https://twrp.me/Devices/)
魔趣 ROM [https://download.mokeedev.com/](https://download.mokeedev.com/)

```bash
    # 使用命令行刷机
    # ！需提前确认相关机型如何解bl锁，国内厂商很多不开启了，小米需要在官网 http://www.miui.com/unlock/index.html 开启
    # 1.使用usb链接
    adb reboot bootloader
    # 2.进入fastboot开发模式后 先刷入recover
    fastboot flash recovery twrp-2.8.x.x-xxx.img
    # 重启后进入rec模式，小米是按住开机和音量+
    fastboot reboot
    # 进入rec模式后,adb发送系统镜像
    adb push /xxxx/xxx.img /sdcard/
    # more twrp卡刷，清除分区（某些时候需要重启下再安装），返回首页安装，找到镜像刷入即可
```

下一步使用 <code>adb connect 192.168.0.xx:5555</code> 链接局域网设备。 天下苦（type c 的接口一直掉）已久 😂

# Second . 新建项目

![](https://tva1.sinaimg.cn/large/0081Kckwgy1glii24w68aj313u0u00tn.jpg)

# Third . build.Gradle 配置

看的 [uniapp adnroid 本地打包](https://nativesupport.dcloud.net.cn/AppDocs/usesdk/android) 的文档

```gradle
//声明项目是一个app
plugins {
    id 'com.android.application'
}

//构建配置
android {
    //项目签名
    signingConfigs {
        jks {
            storeFile file('xx.jks')
            storePassword 'xx'
            keyAlias 'xx'
            keyPassword 'xxx'
        }
    }

    compileSdkVersion 30
    buildToolsVersion "30.0.2"

    defaultConfig {
        //包名
        applicationId "com.rtg.test"
        //最小支持版本 ，小于这个版本的无法安装app
        minSdkVersion 19
        //目标版本 ，上架市场指定 现在一般是28
        targetSdkVersion 30
        //版本号 市场判断升级
        versionCode 1
        versionName "1.0"

        //引用依赖过多之后报了一个错误 无法编译 需要开启这个
        multiDexEnabled true
        //指定内核
        ndk {
            abiFilters 'x86','armeabi-v7a'
        }
        //默认的 还是没入测试的门
        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
        //签名app
        signingConfig signingConfigs.jks
    }

    //默认
    buildTypes { ... }

    //使用uniapp时，需复制下面代码
    /*代码开始*/
    aaptOptions {
        additionalParameters '--auto-add-overlay'
        //noCompress 'foo', 'bar'
        ignoreAssetsPattern "!.svn:!.git:.*:!CVS:!thumbs.db:!picasa.ini:!*.scc:*~"
    }
    /*代码结束*/

    //指定java版本
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
}

repositories {
    flatDir(
            dirs: "libs"
    )
}
dependencies {
    //引用依赖  就学会一个 filetree 挺好用的
    implementation fileTree(dir: "libs",includes: ["*.aar","*.jar"])
}
```

# Fourth . AndroidManifest.xml

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.rtg.test">

    <!-- 申请权限 -->
    <uses-permission android:name="android.permission.CAMERA" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Test">

        <!-- 默认视图 -->
        <activity
            android:name=".MainActivity"
            android:label="@string/app_name"
            android:theme="@style/TranslucentTheme"
            android:screenOrientation="user"
            android:windowSoftInputMode="adjustResize" >
            <!-- 应该是设置为主窗口 -->
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>

</manifest>
```

# More .

## Android 文档

[https://developer.android.com/guide/components/fundamentals?hl=zh-cn](https://developer.android.com/guide/components/fundamentals?hl=zh-cn)
官方文档挺清晰的，就是没耐心看完

## UniApp 原生扩展加 alipay 的 demo,没 UI 的，安卓画界面的方式还是没搞懂

支付宝文档：[https://opendocs.alipay.com/open/204/105296](https://opendocs.alipay.com/open/204/105296)

<code>import io.dcloud.feature.uniapp</code> 的包是在 [uniapp adnroid 本地打包](https://nativesupport.dcloud.net.cn/AppDocs/usesdk/android) 下的 sdk 里 <code>uniapp-v8-release.aar</code>

```java
package com.rtg.mylibrary;


import android.annotation.SuppressLint;
import android.app.Activity;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;

import com.alipay.sdk.app.AuthTask;
import com.alipay.sdk.app.EnvUtils;
import com.alipay.sdk.app.PayTask;

import java.util.HashMap;
import java.util.Map;

import io.dcloud.feature.uniapp.annotation.UniJSMethod;
import io.dcloud.feature.uniapp.bridge.UniJSCallback;
import io.dcloud.feature.uniapp.common.UniModule;


// UniModule 声明为可以在uni原生模块中调用
public class Pay extends UniModule {

    @UniJSMethod //声明一个js可以调用的方法
    public void sayHello(String tag) {
        System.out.println("hello uni module!");
    }

    // private final int SDK_PAY_FLAG = 1; //没用到，基于官方到sdk改了

    // 设置沙箱变量，是一个常量，所以如果不写else部分，下一次调用还是沙箱
    private void isSandBox(Boolean sandbox){
        if(sandbox){
            EnvUtils.setEnv(EnvUtils.EnvEnum.SANDBOX);
        }else {
            EnvUtils.setEnv(EnvUtils.EnvEnum.ONLINE);
        }
    }


    @UniJSMethod(uiThread = true)
    public void AliPay(String orderInfo,Boolean sandbox, UniJSCallback callBack){

        //是个常量，需要重写 大意了就没有闪
        this.isSandBox(sandbox);

        // mUniSDKInstance.getContext() 获取到uni的当前Activity
        if(mUniSDKInstance.getContext() instanceof Activity){
            final Activity activity = (Activity) mUniSDKInstance.getContext();
             Map<String,Object> jsCallbackResult = new HashMap<>();

            // 声明一个新的Runnable 用于下一步开启线程
            Runnable payRunnable = new Runnable() {
                @Override
                public void run() {
                   try{
                       PayTask task = new PayTask(activity);
                       String result = task.pay(orderInfo,true);
                    //    需要在当前 Activity 启动线程 回调处理结果，否则会造成cash
                       activity.runOnUiThread(new Runnable() {
                           @Override
                           public void run() {
                               jsCallbackResult.put("result",result);
                              if(callBack!=null)callBack.invoke(jsCallbackResult);
                           }
                       });
                   }catch(final Exception err){
                       activity.runOnUiThread(new Runnable() {
                           @Override
                           public void run() {
                               jsCallbackResult.put("exception",err);
                               if(callBack!=null)callBack.invoke(jsCallbackResult);
                           }
                       });
                        System.out.println("支付失败"+err);
                   }
                }
            };

            // 启动线程，线程用完即自动结束 不需要手动关闭
            Thread _thread = new Thread(payRunnable);
            _thread.start();
        }

    }
}
```
