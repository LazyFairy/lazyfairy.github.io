---
title: javascript时间戳转指定格式 ⌚️
date: 2019-08-22 17:43:23
tags:
categories: ["javascript"]
---

## 场景

> Api 直接返回数据库表的 curd 小伙伴

## 思路

| 序号 | 简介                                               |
| :--: | :------------------------------------------------- |
|  1   | new 一个时间对象 返回 年月日 时分秒（按需补 0      |
|  2   | 传入一个类似 Y-m-d H:i:s 格式的字符串 不区分大小写 |
|  3   | 使用正则替换内容                                   |

## 效果

![](https://i.loli.net/2019/08/22/dVM6fRGBKlSbIro.png)

## 实现

```javascript
//返回时间对象
const getDate = (time) => {
  let date = new Date(time);
  let year = date.getFullYear();
  let month = fix0(date.getMonth() + 1);
  let day = fix0(date.getDate());
  let h = fix0(date.getHours());
  let minutes = fix0(date.getMinutes());
  let seconds = fix0(date.getSeconds());
  return {
    year,
    month,
    day,
    h,
    minutes,
    seconds,
  };
};

/**
 * 时间格式化
 * @param {*} time  10位时间戳
 * @param {*} str   制定到时间格式 y-m-d H:i:s 不区分大小写
 */
const timeformat = (time, str = "y-m-d H:i:S") => {
  let obj = getDate(time * 1);
  if (!obj) {
    return null;
  }
  let result = str
    .replace(/([yY])/, `${obj.year}`)
    .replace(/([mM])/, `${obj.month}`)
    .replace(/([dD])/, `${obj.day}`)
    .replace(/([hH])/, `${obj.h}`)
    .replace(/([iI])/, `${obj.minutes}`)
    .replace(/([sS])/, `${obj.seconds}`);
  return result;
};

// 十以内数字补零
const fix0 = (num) => {
  return num < 10 ? String("0" + num) : String(num);
};
```
