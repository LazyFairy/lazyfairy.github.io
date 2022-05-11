---
title: 🚀 UniApp热更新检测🔥🔥🔥
intro: ""
featured_image: ""
date: 2019-12-03 13:55:37
---

# 使用

```javascript
    //入口文件
    // 检查更新
	let updateCheck = //new update(this.api.update,true,'1.0.0')

    // 模板中
    import update from '@/util/update.js'
	export default {
		data() {
			return {
				updateCheck://new update(this.api.update),
			}
		},
        ...

        updateCheck.status //更新状态

        updateCheck.version //当前资源包版本

        updateCheck.doUpdate() //更新方法


```

# 代码

接口和字段都需要对应修改

```javascript
export default class update {
  // #ifdef APP-PLUS
  // 查询更新接口
  api = null;
  // 当前版本号
  version = "1.0.0";
  // 更新包状态
  status = "";
  updateInfo = {}; //远程返回的更新信息
  autoInstall = false;

  // 初始化
  constructor(api, autoInstall = false, choooseVersion = "1.0.40") {
    this.api = api;
    this.autoInstall = autoInstall;
    this.choooseVersion = choooseVersion;
    this.init();
  }

  async init() {
    this.status = await this.checkVersion();
    if (this.autoInstall) {
      this.doUpdate(true);
    }
  }
  // 获取版本号
  getVersion() {
    return new Promise((resolve, reject) => {
      plus.runtime.getProperty(plus.runtime.appid, (widgetInfo) => {
        if (widgetInfo) {
          if (widgetInfo.version == this.choooseVersion) {
            uni.setStorageSync("chooseVersion", true);
          }
          resolve(widgetInfo.version);
        }
        reject(widgetInfo);
      });
    });
  }

  // 查看云端接口
  async checkVersion() {
    let version = await this.getVersion();
    this.version = version;
    return new Promise((resolve, reject) => {
      this.api().then((res) => {
        if (res) {
          this.updateInfo = res;
          console.log(res);
          let { version: versionOl, update_size } = res;
          if (versionOl == version) {
            resolve("");
          }
          let versionArr = version.split(".").map((x) => Number(x));
          let versionOlArr = versionOl.split(".").map((x) => Number(x));
          console.log(versionOlArr, versionArr);
          if (versionArr && versionOlArr) {
            if (versionOlArr[0] > versionArr[0] && update_size == 2) {
              resolve("版本更新");
            }
            if (versionOlArr[0] == versionArr[0]) {
              if (versionOlArr[1] > versionArr[1]) {
                resolve("修复更新");
              }
              if (versionOlArr[0] == versionArr[0]) {
                if (versionOlArr[2] > versionArr[2]) {
                  resolve("修复更新");
                }
              }
            }
          }
          reject("获取版本号失败");
        }
      });
    });
  }

  // 整包更新
  doFullUpdate() {
    let url = this.updateInfo.download_url;
    plus.runtime.openURL(url);
  }
  // 热更新
  doUpdate(autoInstall) {
    let that = this;
    if (this.status == "版本更新") {
      this.doFullUpdate();
    }
    if (this.status == "修复更新") {
      if (autoInstall) {
        uni.showModal({
          title: "更新提示",
          content:
            this.updateInfo.version_desc +
            "\n更新版本号：" +
            this.updateInfo.version,
          success(res) {
            if (res.confirm) {
              that.install();
            }
          },
        });
      } else {
        this.install();
      }
    }
  }
  //下载热更新包 重启更新
  install() {
    uni.showLoading({
      title: "下载更新中",
      icon: "none",
      mask: true,
    });
    uni.downloadFile({
      url: this.updateInfo.update_file,
      success: (downloadResult) => {
        uni.hideLoading();
        console.log(downloadResult);
        uni.showLoading({
          title: "正在安装...",
          icon: "none",
          mask: true,
        });
        if (downloadResult.statusCode === 200) {
          plus.runtime.install(
            downloadResult.tempFilePath,
            {},
            function () {
              uni.hideLoading();
              console.log("install success...");
              uni.showModal({
                title: "提示",
                content: "更新已安装，是否立即重启？",
                success(res) {
                  if (res.confirm) {
                    plus.runtime.restart();
                  }
                },
              });
            },
            function (e) {
              uni.hideLoading();
              console.error("install fail...", e);
            }
          );
        }
      },
    });
  }
  // #endif
}
```
