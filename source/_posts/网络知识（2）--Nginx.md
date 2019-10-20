---
title: 网络知识（2）--Nginx
date: 2019-10-20 13:57:38
tags: [http, 前端,Nginx]
categories: Nginx
---

## 1.Nginx相关知识

### 1.1 正向代理
> 正向代理，意思是一个位于客户端和原始服务器(origin server)之间的服务器，为了从原始服务器取得内容，客户端向代理发送一个请求并指定目标(原始服务器)，然后代理向原始服务器转交请求并将获得的内容返回给客户端。客户端才能使用正向代理。

> 举个例子：用户想访问www.google.com，不能直接访问。需要先访问代理服务器A，A服务器会去访问www.google.com。然后将数据发送给用户。

### 1.2 反向代理
> 反向代理是代理服务器的一种。服务器根据客户端的请求，从其关联的一组或多组后端服务器（如Web服务器）上获取资源，然后再将这些资源返回给客户端，客户端只会得知反向代理的IP地址，而不知道在代理服务器后面的服务器簇的存在.

### 1.3 负载均衡

> 负载均衡（Load Balance）其意思就是分摊到多个操作单元(服务器)上进行执行，例如Web服务器、FTP服务器、企业关键应用服务器和其它关键任务服务器等，从而共同完成工作任务。

### 1.4 动静分离
> 动静分离是指在web服务器架构中，将静态页面与动态页面或者静态内容接口和动态内容接口分开不同系统访问的架构设计方法，进而提升整个服务访问性能和可维护性。

### 1.5 常用命令

```sh
nginx -s start # 开始
nginx -s reload # 重新加载
nginx -s stop # 停止

```
### 1.6 nginx配置

```sh
# =================全局模块==============================
#user  nobody;
worker_processes  1;    #并发处理的值。越大，并发量越大

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;


# ========================events模块=======================
# 影响nginx服务器与用户的链接
events {
    worker_connections  1024;   # nginx最大连接数，对性能影响较大
}

#=======================http模块============================
http {
    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;

    server {
        listen       9999;                            # nginx监听的端口号
        server_name  localhost;                       #主机名称

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
            root   html;
            index  index.html index.htm;
        }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }

        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php$ {
        #    proxy_pass   http://127.0.0.1;
        #}

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        #location ~ \.php$ {
        #    root           html;
        #    fastcgi_pass   127.0.0.1:9000;
        #    fastcgi_index  index.php;
        #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        #    include        fastcgi_params;
        #}

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #    deny  all;
        #}
    }


    # another virtual host using mix of IP-, name-, and port-based configuration
    #
    #server {
    #    listen       8000;
    #    listen       somename:8080;
    #    server_name  somename  alias  another.alias;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}


    # HTTPS server
    #
    #server {
    #    listen       443 ssl;
    #    server_name  localhost;

    #    ssl_certificate      cert.pem;
    #    ssl_certificate_key  cert.key;

    #    ssl_session_cache    shared:SSL:1m;
    #    ssl_session_timeout  5m;

    #    ssl_ciphers  HIGH:!aNULL:!MD5;
    #    ssl_prefer_server_ciphers  on;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}

}

```

## 2.nginx配置实例

### 2.1 反向代理1
- 实现效果：打开浏览器，地址栏输入 www.123.com(http://192.168.17.129:80)，跳转到linux系统Tomact主界面(http://127.0.0.1:8080)

```sh

    server {
        listen       80;
        server_name  192.168.17.129;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
            root   html;
            proxy_pass http://127.0.0.1:8080
            index  index.html index.htm;
        }
```

### 2.2 反向代理2
- 实现效果：使用nginx反向代理，根据访问的路径跳转到不同端口的服务中。nginx监听端口为9001
- 访问http://127.0.0.1:9001/edu 直接跳转到 http://127.0.0.1:8080
- 访问http://127.0.0.1:9001/vod 直接跳转到 http://127.0.0.1:8081

```sh
    server {
       listen       9001;
       server_name       192.168.17.129;

       location ~ /edu/ {                      # ~ 表示后面是正则匹配
           proxy_pass http://127.0.0.1:8080
       }
       location ~ /vod/ {
           proxy_pass http://127.0.0.1:8081
       }
    }
```

### 2.3 location 配置说明
1. = ：用于不含正则表达式的uri前，要求请求字符与uri严格匹配
2. ~ ：用于表示uri包含正则表达式，区分大小写
3. ~* ：用于表示uri包含正则表达式，不区分大小写
4. ^~ : 用于不含正则表达式的uri前，要求nginx服务器找到标识uri和请求字符串匹配最高的location后，立即使用此location处理清除，而不再使用location块中的正则uri和请求字符串做匹配。
   注意：如果uri包含正则表达式，则必须要有~ 或者~*标识。

### 2.4 负载均衡

```sh
    # 负载均衡服务器
    upstream myserver {
        server 192.168.17.129:8080;
        server 192.168.17.129:8081;
    }

    server {
        listen       80;
        server_name  192.168.17.129;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
            proxy_pass http://myserver;  # 将请求转发给负载均衡服务器
            root   html;
            index  index.html index.htm;
        }
```

#### 2.4.1 负载均衡策略

 - 轮询 （默认）  每个请求按时间顺序逐一分配到不同的后端服务器，如果后端服务器down掉，能自动剔除
 - weight  权重策略

  ```sh
   upstream myserver {
        server 192.168.17.129:8080 weight=5;
        server 192.168.17.129:8081 weight=10;
    }
  ```

 - ip_hash : 后台根据访问的ip固定后台响应的服务器，一一对应起来
  ```sh
   upstream myserver {
        ip_hash;
        server 192.168.17.129:8080 weight=5;
        server 192.168.17.129:8081 weight=10;
    }
  ```

  - fair  根据后台的服务器响应时间来分配请求，响应时间短的优先分配。

  ```sh
   upstream myserver {
        fair;
        server 192.168.17.129:8080 weight=5;
        server 192.168.17.129:8081 weight=10;
    }
  ```

  
