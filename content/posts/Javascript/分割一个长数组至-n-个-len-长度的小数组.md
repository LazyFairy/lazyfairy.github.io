---
title: 分割一个长数组至 n 个 len 长度的小数组
date: 2019-08-23 14:33:19
tags:
---
## 场景
>   拆分一个长列表<code>[1,2,3,...n]</code> 至 <code>[[1,2,3],[1,2,3],[1,2,3]...]</code> 配合套嵌循环，可以简单实现很多有趣的布局

## 效果
> 使用<code>flex</code>实现<code>Grid布局</code>,(这里flex好像作用不大哈哈 <code>float</code>也行)


## 思路
序号|内容
:---:|:--
1|拆分列表之后，之际写了两个循环，例:<code>[[1,2,3],[1,2,3],[1,2,3]...]</code>
2|第一级的item为<code>[1,2,3]</code>，也就是一行的内容
3|第二级就是单个icon的内容

![](https://i.loli.net/2019/08/23/buU3AjRgi9Xlzre.png)
> 到这里html 结构就完成,html结构比较分明,利用css <code>nth-child</code>也可以实现一些比较有趣的效果，例如：<code>nth-child(odd)</code> 和  <code>nth-child(even)</code> 搭配实现棋盘样式，或者上图这种九宫格样式的内边框
## 代码
```javascript 
/**
 * // 分割一个长数组至 n 个 len 长度的小数组
 * @param {Array} arr 需要转换的数组
 * @param {Number} len 切割的长度
 */
const split_array = (arr, len) => {
	var a_len = arr.length;
	var result = [];
	for (var i = 0; i < a_len; i += len) {
		result.push(arr.slice(i, i + len));
	}
	return result;
}
```