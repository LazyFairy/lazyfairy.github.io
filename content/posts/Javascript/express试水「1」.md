---
title: express试水（1）「大淘客api」😎
# intro: --
featured_image: https://tva1.sinaimg.cn/large/006y8mN6gy1g9enb2rw4ij30zv08rtb1.jpg
date: 2019-11-27 12:00:00
tags:
  - express
  - javascript
---

# 安装

> npm init

> npm install express --save

## 快速生成项目

> npm install -g express-generator

> express newApp

# 基础目录

![](https://tva1.sinaimg.cn/large/006y8mN6gy1g9eofwkq2mj30950dsdgq.jpg)

### <code>bin/www</code>

www 配置文件，某些插件会把 log 文件写在这里

### <code>public</code>

静态资源文件，需要在入口文件挂载才可以访问

```javascrpt
    //static是一个虚拟目录 可以直接用 root目录
    app.use('/static',express.static(path.join(__dirname, 'public')));
```

### <code>routes</code>

路由文件

### <code>views</code>

模板文件，可自定义程度很高 还没有详细了解过，暂时倾向于前后端分离，只写接口在这里

### <code>app.js</code>

入口文件，大部分的配置都可以在这里完成
使用插件 cookie jsonparse 这些都需要引用插件实现，模板项目中已经生成了常用的插件
自定义模板
定义路由

# Curl 接第三方接口

> 这里使用大淘客的 api 做的尝试，没有具体项目逻辑想不到应该做什么，另外数据库也还没尝试

## demo

[https://github.com/Treblex/dataoke-api/blob/master/server/util/CommodityFactory.js](https://github.com/Treblex/dataoke-api/blob/master/server/util/CommodityFactory.js)

> 新建一个文件夹放自己的工具类就可以，对文件夹结构没有强制对要求,对应的调用方法在 router/api.js

## Request

直接调用 request 模块就可以，使用方法也非常的简单，符合前端的习惯

```javascript
const request = require("request");
request({ data }, (callback = (err, res, body) => {}));
```

## 验签

在大淘客的 demo 中，引用了 corypt md5 进行加密，这里需要注意不要在引用文件后就立即<code>createHash('md5')</code>，因为每个实例只能进行一次加密，在需要的地方<code>createHash('md5')</code>就可以了

```javscript
    crypto.createHash('md5')
```

## 调用

[https://github.com/Treblex/dataoke-api/blob/master/server/routes/api.js](https://github.com/Treblex/dataoke-api/blob/master/server/routes/api.js)

```javascript
var express = require("express");
var router = express.Router();
var factory = require("../util/CommodityFactory");
// 商品工厂对象
let CommodityFactory = new factory({
  appSecret: "17eda35413998548b3fdebd31e6d2c51",
  appKey: "5dc6fcef48989",
});
// 临时写的
const errCode = (title) => {
  return {
    time: new Date() * 1,
    code: -1,
    msg: title,
    data: {},
  };
};
// 品牌
router.get("/get-brand-list", async function (req, res, next) {
  let { pageId, pageSize = 10 } = req.query;
  //   req.query 请求的参数,
  //   如果需要支持类似thinkphp的静态url   url地址可以写成  '/detail/:id'
  //   取值使用 req.params['id'],如果有正则，正则的部分为 req.params[index]
  if (!pageId) {
    res.send(errCode("pageId不可空"));
  }
  let body = await CommodityFactory.getBarndList({
    pageId,
    pageSize,
  });

  //   返回页面显示的内容，在此之前可以设置返回的header 等一些常用内容
  res.send(body);
  //   res.render('index', { title: 'Express' ,中文:"打火机卡上打哈电话接啊活动空间啊"});
  // 渲染到模板的写法，第一个参数模板名字，第二个为渲染到模板的变量
});
```

# 中间件开发

[官网文档>>](http://www.expressjs.com.cn/guide/writing-middleware.html)

我的理解是中间件在 php 中类似于一个 base 控制器，

```php
    class loginBase{
        // 检查登录，跳转页面
        if(isLogin){
            return true
        }
        // 301 login.html
    }
    class home extends loginBase{
        return home
    }
```

![](https://tva1.sinaimg.cn/large/006y8mN6gy1g9eotnxbkaj30tk0iswkf.jpg)
像文档中介绍的，其实我们定义的路由也是中间件
我能想到的常用的业务场景就是像上边的 登录检测，用户权限这些

```javascript
app.use('/api',(res,req,next)=>{
  console.log('==err==||AppBase 登录检测或一些其他的内容');
  let islogin = false
  if(!islogin){
    req.send('err 未登录什么的'),//如果不执行下一步业务逻辑，我们就必须结束请求，而不能直接return，否则页面会一直处于加载中，直到请求超时
    return;
  }
  next();//执行下一步  api的路由文件
})
app.use('/api', apiRouter);//自定义路由  业务逻辑

```

# End

还没有部署，客户端没写，接口都对了，下面是 github 仓库
[https://github.com/Treblex/dataoke-api](https://github.com/Treblex/dataoke-api)

其实遇到一个问题没有解决，request 大淘客接口的时候又一个 version 参数，这个参数有的接口是 1.0.0 有的是 1.0.1，而且有过期验证，过期的版本无法使用，对于怎么更新接口版本和过期通知没有太好解决方法，现在 version 是在 factory 的每个请求里边写的默认参数
