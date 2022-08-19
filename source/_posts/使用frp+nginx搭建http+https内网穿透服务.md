title: 使用frp+nginx搭建http+https内网穿透服务
author: weihai
tags:
  - frp
  - nginx
  - https
categories: []
date: 2022-08-18 19:27:00
---

最近入手了一个海思机顶盒（[https://www.ecoo.top/](https://www.ecoo.top/)），刷好了armbian系统，突发奇想可以利用这个小系统的frp做一个类似花生棒的工具。以前是直接在服务器上运行frp客户端，这次把frp客户端运行在独立的设备上，通过IP+port访问局域网里的其他服务，并且使用泛域名方便以后无限扩展。

大概的流程在参考资料里，网友写的很详细了，我主要是记录我在实践中遇到的问题。

## 1.使用acme生成和管理证书

前置条件：

1. 域名
2. dnspod
3. 云主机

```
# 下载安装acme
curl https://get.acme.sh | sh
# 创建acme别名
alias acme.sh=~/.acme.sh/acme.sh
# 查看crontab，应该已经有定时任务去更新证书
crontab -l
# 给泛域名生成证书，这里不写了
```



## 2.frps端配置



```YAML
[common]
auto_token = xxxxx
bind_addr = 0.0.0.0
bind_port = 7001
#frp内网穿透服务器可以支持虚拟主机的http和https协议，一般我们都用80，可以直接用域名而不用增加端口号，如果使用其它端口，那么客户端也需要配置相同的其他端口。
vhost_http_port = 7999
#vhost_https_port = 443
dashboard_user = admin
dashboard_pwd = admin
# 这个是frp内网穿透服务器的web界面的端口，可以通过http://你的ip:7003查看frp内网穿透服务器端的连接情况，和各个frp内网穿透客户端的连接情况。
dashboard_port = 7003
privilege_token = 12345678
subdomain_host = frp.example.com
```



## 3.nginx配置

这里采用的方案是把证书放在frp服务器上，不放在客户端

```Nginx
# frp https
server {
    listen 80;
    listen 443 ssl;
    server_name *.frp.linyanli.cn;
    ssl_certificate /home/lighthouse/.acme.sh/*.frp.example.com/*.frp.example.com.cer;
    ssl_certificate_key /home/lighthouse/.acme.sh/*.frp.example.com/*.frp.example.com.key;
    ssl_session_timeout 5m;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2; #按照这个协议配置
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:HIGH:!aNULL:!MD5:!RC4:!DHE;#按照这个套件配置
    ssl_prefer_server_ciphers on;
    if ($ssl_protocol = "") { return 301 https://$host$request_uri; }
    location / {
        proxy_pass http://127.0.0.1:7999;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_set_header X-NginX-Proxy true;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_max_temp_file_size 0;
        proxy_redirect off;
        proxy_read_timeout 240s;
    }

    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
    }
}
```



## 4.frpc配置

```YAML
[common]
server_addr = 49.235.100.43
server_port = 7001
auto_token = twh_frp

[ssh-hi-nas]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = 7015

[web-nas]
type = http
local_ip = 局域网ip
local_port = 5000
subdomain = nas

[web-hinas]
type = http
local_ip = 127.0.0.1
local_port = 80
subdomain = hinas

```


## 遇到的问题
1. nginx反代后访问域名报404错误。
2. nginx反代后访问域名报502错误。
> 1 和 2 都是端口没有配置对，当然还需要确保云主机防火墙规则是否开放、frps有没有端口限制；如果是docker容器启动的frps，要看看端口都设置好没有
3. 多级域名在 http强制跳转https时，url遇到转义问题。
> nginx 里同时监听80 和 443 端口，并加上
> `if ($ssl_protocol = "") { return 301 https://$host$request_uri; }`


## 两种模式：
1. 设置vhost_https_port，nginx代理时转到这个端口，然后证书都配置在客户端
2. 只设置vhost_http_port，nginx代理时转到这个端口，然后证书配置在服务端

配合acme自动管理、更新服务器端证书，明显第二种模式方便很多，服务端只需要配置一次，基本就可以不用再操心了。

## 参考资料：

[https://www.bilibili.com/read/cv13684403/](https://www.bilibili.com/read/cv13684403/)

