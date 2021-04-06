---
title: "Bug Sur android emulator 启动失败修复，卡cash-server，没有界面"
date: 2021-04-06T13:23:00+08:00
draft: true
---
# 问题1 add library fail
qemu 目录下没有vulkan库文件，在emulator/lib64下拷贝复制过来就行（确实有一个add library fail，但是不确定是否影响启动
```
added library /Users/suke/Library/Android/sdk/emulator/qemu/darwin-x86_64/lib64/vulkan/libvulkan.dylib
```

# 问题2 无法启动模拟器，
1.最早是直接卡cash-server进程，
2.更新2021-4-6最新版本之后保grpc server start fail
```
emulator: info: grpcservices.cpp:301: started grpc server at 127.0.0.1:8554, security: local
```
3.qemu-system-x86_64: Error: HV_ERROR
```
HVF error: HV_ERROR qemu-system-x86_64: failed to initialize HVF: Invalid argument
```

# 解决办法
使用如下链接教程，重新签名qemu,获取对虚拟机管理程序的使用权限
[https://www.arthurkoziel.com/qemu-on-macos-big-sur/](https://www.arthurkoziel.com/qemu-on-macos-big-sur/)


{{% quote %}}
####  引用内容 来自：https://www.arthurkoziel.com/qemu-on-macos-big-sur

 大约3个月前，我写了一篇博客文章，介绍如何在macOS上创建QEMU Ubuntu 20.04 VM。如果按照新发布的macOS 11.0的说明进行操作，则QEMU 5.1将失败，并显示以下错误：

```shell
qemu-system-x86_64: Error: HV_ERROR
fish: 'qemu-system-x86_64 \
    -machi…' terminated by signal SIGABRT (Abort)
```
 发生此错误的原因是Apple对虚拟机管理程序权利进行了更改。权利是键值对，授予对使用服务或技术的可执行权限。在这种情况下，QEMU二进制文件缺少创建和管理虚拟机的权利。

更具体地说，该com.apple.vm.hypervisor权利（在macOS 10.15中使用）已被弃用，并由代替com.apple.security.hypervisor。

要解决此问题，我们要做的就是将权利添加到qemu-system-x86_64二进制文件中。首先创建一个entitlements.xml具有以下内容的xml文件：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.security.hypervisor</key>
    <true/>
</dict>
</plist>

```

 然后用它签名qemu二进制文件：

 codesign -s - --entitlements entitlements.xml --force /usr/local/bin/qemu-system-x86_64
 现在，该qemu-system-x86_64命令应该可以使用了，并且可以用来启动虚拟机。
{{% /quote %}}

```
⚠️注意签名文件的地址要改为emulator目录下的qemu/qemu-system-x86_64
```


要了亲命了，折腾好几周
