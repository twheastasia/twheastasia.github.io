title: mac下使用plist实现定时任务
author: weihai
tags:
  - mac
categories: []
date: 2019-02-02 10:43:00
---
记录下主要步骤：
1. 新建一个任务脚本文件，如 /Users/username/Downloads/autoRun.sh (里面的具体内容就是到了时间要跑的任务内容)
2. chmod 755 autoRun.sh （确保有可执行的权限）
3. 然后进入到~/Library/LaunchAgents 下建一个plist文件，如com.twh.test.autorun.plist
4. plist文件内容可以参考下面的：
5. Label 可以随便起，但是要唯一 
```
ProgramArguments 存放需要定时跑的脚本路径+名字
StartCalendarInterval 可以定时到 “时 分 秒”
也可以使用StartInterval 表示间隔多少秒,如
StartInterval 60
```
6.
```
开始执行定时任务 launchctl load com.twh.test.autorun.plist 
取消定时任务 launchctl unload com.twh.test.autorun.plist  
立即执行任务一次 launchctl start com.twh.test.autorun.plist  
停止执行任务 launchctl stop com.twh.test.autorun.plist  
```

http://my.oschina.net/jackin/blog/263024

http://www.2cto.com/os/201305/215350.html