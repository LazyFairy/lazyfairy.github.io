---
title: "最近学习esp32开发板的一些记录"
intro: ""
featured_image: ""
date: 2020-10-19 09:31:12
---

|          |                                      |
| :------- | -----------------------------------: |
| 开发环境 | macOS Big Sur 11.0 Beta 版(20A5395g) |
| 设备型号 |                          nodemcu 32s |

### esp32 的开发

最近心血来潮，买了块 esp32 的开发板，使用的 arduino 框架，需要使用到 c++，还没专门学习，主要考 arduino 的 demo 代码片段了解一些基础语法，方向还是了解 esp 开发相关的，暂不准备深度 c++ 相关

主要实验了 tinygo，micropython, idf(官方套件),esp-arduino （有一个共同的问题就是这些项目都共同依赖了 esptool.py 和 serial.py ,在 macos Big Sur 中因为一个系统依赖的改变导致自动查找端口的方法失败，需要注释掉一段代码，并且指定端口 [issues https://github.com/pyserial/pyserial/issues/509](https://github.com/pyserial/pyserial/issues/509)

#### tinygo

比较喜欢 go 语言，因此首选的考虑这个，但是仅支持了 gpio ipc ℹ2c 接口，没有 wifi 和蓝牙模块，所以暂时放弃了

环境配置：[https://tinygo.org/getting-started/macos/](https://tinygo.org/getting-started/macos/)

vscode 扩展 [tinygo.vscode-tinygo](https://marketplace.visualstudio.com/items?itemName=tinygo.vscode-tinygo)

vscode 中需要设置一下工作区配置，设置 goroot 和 gopath

tinygo 实现了 flash 方法不需要依赖 esptool，<code>tinygo flash -target=esp32-wroom-32 -port=/dev/ttyUSB0 examples/blinky1
</code> 指定 target 的时候 tinygo 会检测是否存在指定的硬件

#### micropython

这个实现相对完善的，并且支持了串口 repl 和 webscket 网络 repl，但是没有找到比较合适的软件，最开始只能在命令行执行 python 命令，开启 wifi 和网络 repl，之后可以使用网络 repl 上传文件

推荐一个 [thonny](https://thonny.org/) 的软件，支持指定 python 解释器和自动链接到串口 repl （使用 screen 链接是总是会占用串口，提示 busy，这个软件很合适）并且支持了一个简单的文件系统，可以直接选择开发板中的文件进行编辑

另外找到一个 1zlab 开发的 web ide [http://www.1zlab.com/wiki/micropython-esp32/](http://www.1zlab.com/wiki/micropython-esp32/) (这里也有一些 micropython 开发的教程和硬件基础知识，算是比较容易懂的)，扩展了 web repl 的使用，看起来很方便，但是没有部署成功，项目 2 年多没有更新了，并且前后端的命令有一些不兼容，可能需要修改一下（有时间可能想要 fork 这个项目维护一下

放弃的原因，一个是开发环境(还算不错的了，但是后边找到个更方便的)，另一个就是找到的资料普遍表示 micropython 性能会差一点(其实不用太介意)

#### idf

[https://docs.espressif.com/projects/esp-idf/en/release-v3.0/get-started/macos-setup.html](https://docs.espressif.com/projects/esp-idf/en/release-v3.0/get-started/macos-setup.html)

开发环境比较大，demo 的文件夹内容比较困惑，python 和 c 是混合的，似乎使用 python 完成一些构建配置，c 代码是主要内容
主要还是开发环境太大，下载了半天一个多 G、测试 demo 后，遂放弃

#### arduino

[https://www.arduino.cc/](https://www.arduino.cc/)
arduino ide for mac 使用的 esptool 是一个编译后文件，无法修改替换上述的一个问题，无法链接设备

[https://marketplace.visualstudio.com/items?itemName=platformio.platformio-ide](https://marketplace.visualstudio.com/items?itemName=platformio.platformio-ide)
platformIO IDE for vscode ,最新使用的是这个，可以指定 arduino 和 idf 环境，有挺多的扩展库支持，vscode toolbar 自动链接，烧录，测试都很方便，难点在与 c++的学习，（代码检测和错误提示的速度有些慢
