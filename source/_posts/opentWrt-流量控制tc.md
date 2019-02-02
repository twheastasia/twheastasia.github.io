title: opentWrt 流量控制tc
author: weihai
tags:
  - tc
  - openwrt
categories: []
date: 2019-02-02 09:48:00
---
## 在openwrt路由上使用tc命令控制网络的带宽、延时、丢包率，来模拟一些弱网络的环境

#### 1.核心命令

参考：Network Traffic Control (QOS)

![upload successful](/images/pasted-0.png)

###### 用opkg安装
```
opkg update
opkg install tc iptables-mod-ipopt
```

###### 用法
```
tc qdisc del dev eth0 root
tc qdisc add dev eth0 root netem rate 1mbit delay 200ms loss 10%​
```

#### 2.界面

光有了命令，每次都要ssh上去，还是很麻烦，所以需要一个快捷执行命令的方法

这里非常感谢Shuhao Wu分享的Traffic Cop工具，可以方便的在网页上设置网络环境

安装方法在他的文章末尾有，我主要说下我安装、使用过程中碰到的问题：

- Package kmod-sched wants to install file /lib/modules/3.10.49/sch_netem.ko But that file is already provided by package kmod-netem Collected errors **解决方法是 命令后加  --force-overwrite**

- 安装成功后，启动trafficcop，网页访问后，点了按钮，不能实现限速。原因应该是tc命令中的interface 或参数设置不正确，具体还没仔细看，临时的解决方法是，把 tc命令直接在在 /usr/lib/trafficcop/api/edge 等文件中

- 还可以自己加按钮加配置，按钮的id要和新的配置文件名一样就可以