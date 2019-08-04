title: ssh保持长链接
tags:
  - ssh
categories:
  - ssh
author: twh
date: 2019-08-04 12:11:00
---
# ssh 保持长连接
在不修改sever、client的ssh配置的前提下，可以通过在命令中添加参数来实现

```
ssh -o ServerAliveInterval=15 -o ServerAliveCountMax=3 root@xxxxxxx
```

每隔15秒重连一下，如果3次都没有返回，才会断开连接


