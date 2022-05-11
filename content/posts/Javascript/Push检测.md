---
title: UniApp Push检测 👂
date: 2019-12-03 13:56:10
tags:
---
## 使用
```javascript
 import push from './push
 let checkPush = new push()
```
## 代码
这里class用处不大，只是觉得看起来很舒服，拆分模块也方便后续扩展
```javascript
export default class push{

	// 初始化
	constructor(){
		this.init()
	}

	init(){
		// 开启推送
		uni.subscribePush({
			provider: "unipush",
			success: function(res) {
				console.log("success:" + JSON.stringify(res));
			}
		});

		this.onPush()
	}


	onPush(){
		// 分客户端不同方案监听
		let osname = plus.os.name
		console.log(osname,'unipush')
		
		if (osname == 'Android') {
			uni.onPush({
				provider: "unipush",
				success: function() {
					console.log("监听透传成功");
				},
				callback: function(data) {
					console.log("接收到透传数据：" + JSON.stringify(data));
					plus.push.createMessage(data.data, {});
				}
			});
		}
		// 监听在线消息事件
		if (osname == 'iOS') {
			plus.push.addEventListener('receive', function(msg) {
				console.log(msg)
				 plus.push.createMessage(msg.content, "LocalMSG", {
					cover: false
				 });
				setTimeout(() => {
					// plus.push.clear();
				}, 3000)
			}, false);
		}

		this.onMessage()
	}
	// 点击消息处理
	onMessage(){
		plus.push.addEventListener(
			"click",
			function(data) {
				console.log(data);
			},
			false
		);
	}
}
```