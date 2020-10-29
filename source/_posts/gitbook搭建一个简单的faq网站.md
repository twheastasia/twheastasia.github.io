title: gitbook搭建一个简单的faq网站
author: weihai
tags:
  - gitbook
  - faq
categories: []
date: 2020-10-29 09:47:00
---
这篇写于很久以前，现在gitbook已经发生了巨大的变化。
谨以此篇，留作纪念。

### 1. npm安装gitbook-cli

> npm install -g gitbook-cli

### 2. 新建一个项目目录，进到目录里执行

> gitbook init

### 3. 新建book.json（这是配置文件），加入faq主题

> {	"plugins":["theme-faq"]}

### 4. 再加入中文搜索功能

> {"plugins":["theme-faq", "-lunr", "search-jieba"]}

### 5. 加入插件后需要执行

> gitbook install 

### 6. 启动服务

> gitbook serve

### 7. 启动后访问localhost:4000，页面样式就像这样

![输入文字开始搜索](http://img.blog.csdn.net/20170105203323433?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvdHdoX2Vhc3Q=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

### 8. Gitbook Editor很好用，可以添加、管理文章

-------

## 有一些坑： 

- 官网上说最多可以添加100篇文章，可能是说在线gitbook，具体需要尝试 - 中文搜索由于分词的关系，搜索单字时效果不好 

- 搜索框内输入过快、或者说快速变化输入的单词时，搜索的结果和预期的不一样 

- README会显示在搜索框下方，不显示在文章列表里，但是下面第一部分的文章数量又包含了README，强迫症很纠结 


----
参考：

https://www.gitbook.com/

https://plugins.gitbook.com/

https://help.gitbook.com/

https://plugins.gitbook.com/plugin/search-jieba