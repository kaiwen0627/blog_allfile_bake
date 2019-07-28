---
title: git操作指南（1）
date: 2018-08-20 09:00:38
tags: [git, 前端]
categories: git
---

![PITrjA.jpg](https://s1.ax1x.com/2018/08/21/PITrjA.jpg)

小公司一般都会使用 svn 托管代码。工作原因，需要使用 git。没办法，硬着头皮上。第一次在超大的代码库中用 git 提交进去自己的两行字符串，还是挺兴奋的呢。【滑稽.jpg】

## 安装配置

- 安装：

  这个好像没什么说的，百度 git-->傻瓜下一步安装【手动狗头.jpg】

- 配置：

  ```bash
  $ git config --global user.name "John Doe"
  $ git config --global user.email johndoe@example.com
  ```

- 关联 github

  1. 生成密钥对

  - 大多数 Git 服务器都会选择使用 SSH 公钥来进行授权。系统中的每个用户都必须提供一个公钥用于授权，没有的话就要生成一个。生成公钥的过程在所有操作系统上都差不多。首先你要确认一下本机是否已经有一个公钥。SSH 公钥默认储存在账户的主目录下的 ~/.ssh 目录。进去看看：

  ```bash
  $ cd ~/.ssh
  $ ls
  authorized_keys2  id_dsa  known_hosts config  id_dsa.pub
  ```

  - 假如没有这些文件，甚至连 .ssh 目录都没有，可以用 ssh-keygen 来创建。该程序在 Linux/Mac 系统上由 SSH 包提供，而在 Windows 上则包含在 MSysGit 包里：

  ```bash
  $ ssh-keygen -t rsa -C "your_email@youremail.com"

  Creates a new ssh key using the provided email # Generating public/private rsa key pair.

  Enter file in which to save the key (/home/you/.ssh/id_rsa):
  ```

  直接按 Enter 就行。然后，会提示你输入密码，如下(建议输一个，安全一点，当然不输也行，应该不会有人闲的无聊冒充你去修改你的代码)：

  ```bash
  Enter same passphrase again: [Type passphrase again]
  ```

  完了之后，大概是这样：

  ```bash
  Your public key has been saved in /home/you/.ssh/id_rsa.pub.
  The key fingerprint is: # 01:0f:f4:3b:ca:85:d6:17:a1:7d:f0:68:9d:f0:a2:db your_email@youremail.com
  ```


    2.添加公钥到你的远程仓库（github）

    2.1、查看你生成的公钥：

    ```bash
    $ cat ~/.ssh/id_rsa.pub

    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC0X6L1zLL4VHuvGb8aJH3ippTozmReSUzgntvk434aJ/v7kOdJ/MTyBlWXFCR+HAo3FXRitBqxiX1nKhXpHAZsMciLq8vR3c8E7CjZN733f5AL8uEYJA+YZevY5UCvEg+umT7PHghKYaJwaCxV7sjYP7Z6V79OMCEAGDNXC26IBMdMgOluQjp6o6j2KAdtRBdCDS/QIU5THQDxJ9lBXjk1fiq9tITo/aXBvjZeD+gH/Apkh/0GbO8VQLiYYmNfqqAHHeXdltORn8N7C9lOa/UW3KM7QdXo6J0GFlBVQeTE/IGqhMS5PMln3 admin@admin-PC
    ```
    2.2、登陆你的github帐户。点击你的头像，然后 Settings -> 左栏点击 SSH and GPG keys -> 点击 New SSH key

    2.3、然后你复制上面的公钥内容，粘贴进“Key”文本域内。 title域，自己随便起个名字。

    2.4、点击 Add key。

    完成以后，验证下这个key是不是正常工作：

    ```bash
    $ ssh -T git@github.com

    Attempts to ssh to github

    Hi xxx! You've successfully authenticated, but GitHub does not # provide shell access.
    ```

## git 常用命令

- 拉取代码

```bash
git clone git@githome****    #从远程仓库克隆代码【master分支】

git clone -b xxx git@githome****    #从远程仓库克隆代码【xxx分支】
```

- 修改代码

  进入代码文件夹后开发代码

- 检查工作区状态

```bash
git status
```

- 检查分支

```bash
git branch  #查看目前所在分支
git checkout dev  #切换到dev分支
```

- 增加改动到缓存区

```bash
git add *   #增加所有改动到缓存区
```

- 提交代码到本地仓库

```bash
git commit -m "提交描述信息"
```

- 推送到远程服务器

```bash
git  push    #推送代码到master分支
git  push origin -u xxx  #推送代码到xxx分支
```
