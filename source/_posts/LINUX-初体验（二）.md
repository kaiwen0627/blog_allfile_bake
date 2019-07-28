---
title: LINUX 初体验(二)
date: 2018-08-19 12:00:38
tags: [linux, 后台 , 服务器,shell]
categories: linux&&shell
---


> 本文主要是对linux下的shell编程相关知识做一下总结。

## 1.什么是SHELL？什么是SHELL脚本？

> Shell 是一个用 C 语言编写的程序，它是用户使用 Linux 的桥梁。Shell 既是一种命令语言，又是一种程序设计语言。

> Shell 是指一种应用程序，这个应用程序提供了一个界面，用户通过这个界面访问操作系统内核的服务。

> Shell 脚本（shell script），是一种为 shell 编写的脚本程序。业界所说的 shell 通常都是指 shell 脚本，但读者朋友要知道，shell 和 shell script 是两个不同的概念。由于习惯的原因，简洁起见，本文出现的 "shell编程" 都是指 shell 脚本编程，不是指开发 shell 自身。

***简单来说，shell和shell脚本就是雷锋与雷峰塔的区别，听着都与雷锋有关而已。***

## 2.shell脚本

+ shell脚本就是将一些linux操作命令集成为“.sh”脚本
+ shell脚本第一行一般如下：
    ```bash
     #!/bin/bash  
    ```
+ shell脚本运行的方法：

    1.作为解释器参数
    ```bash
     bash ./text.sh
    ```
    2.作为可执行程序
    ```bash
    ./text.sh
    ```
    ***注意，一定要写成 ./test.sh，而不是 test.sh，运行其它二进制的程序也一样，直接写 test.sh，linux 系统会去 PATH 里寻找有没有叫 test.sh 的，而只有 /bin, /sbin, /usr/bin，/usr/sbin 等在 PATH 里，你的当前目录通常不在 PATH 里，所以写成 test.sh 是会找不到命令的，要用 ./test.sh 告诉系统说，就在当前目录找。***

## 3.shell编程注意事项：

### 1. 变量&&字符串

+ 字符串变量定义时，单引号里面不能有其他变量拼接，会原样输出；在双引号里面可以包含其他变量引用后输出。
+ 定义变量时，变量名不加美元符号$,使用变量需要在前边加 ***$num*** 或者写成 ***${num}***  。
+ 变量重新赋值不属于使用变量，不需要加$ 。
    ```bash
    your_name="kw"                  #定义变量
    echo $your_name                    #使用变量
    your_name="tiantian"               #重新赋值
    echo your name is $your_name !     #使用变量
    echo your name is ${your_name} !   #使用变量
    ```
+ 字符串拼接直接将变量“放置”在对于位置即可。
  > 变量相关其他知识可以参考 [菜鸟教程](http://www.runoob.com/linux/linux-shell-variable.html) 相关章节。

### 2.参数传递

***shell执行机制本身就比较"傻"，它会从上到下一条条命令执行。假如没有做容错处理，执行错误了，也不会停止，会继续执行下面的命令直到脚本底部***

假如测试脚本 file.sh 如下：

```bash
#!/bin/bash
echo "Shell 传递参数实例！";
echo "执行的文件名：$0";
echo "第一个参数为：$1";
echo "第二个参数为：$2";
echo "第三个参数为：$3";
```

我们调用执行他：

``` bash
chmod +x file.sh #给文件file.sh添加自执行权限
./file.sh 1 2 3  #调用脚本并传入参数
```

执行结果：

``` text
Shell 传递参数实例！
执行的文件名：./file.sh
第一个参数为：1
第二个参数为：2
第三个参数为：3
```

> shell的脚本调用传参必须严格遵守传参顺序

## 4.shell数组

1.定义方法：

```bash
arr=(A B "C" D)
```

2.注意点：

+ 数组定义以 () 包裹。
+ shell数组只支持一维数组。
+ shell数组元素以空格分割
+ 数组元素获取方法和JScript相同。
    ```bash
    arr1=arr[0]   #获取数组第一个元素
    arrL=arr[@]   #获取数组长度
    arrL=arr[*]   #同上
    ```

## 5.流程控制

***shell里面的流程控制语句，一定要注意关键词的之后空格和缩进***

1. if

```bash
if condition
then
    command1 
    command2
    ...
    commandN 
fi
```

2. if-else

```bash
num1=$[2*3]
num2=$[1+5]
if test $[num1] -eq $[num2]
then
    echo '两个数字相等!'
else
    echo '两个数字不相等!'
fi
```




3. for

```bash
for var in item1 item2 ... itemN
do
    command1
    command2
    ...
    commandN
done
```

## 6.函数

***shell里面的函数定义与JScript一样,不过要注意缩进，调用时如果不需要传参，不跟()***

```bash
#!/bin/bash

funWithReturn(){
    echo "这个函数会对输入的两个数字进行相加运算..."
    echo "输入第一个数字: "
    read aNum
    echo "输入第二个数字: "
    read anotherNum
    echo "两个数字分别为 $aNum 和 $anotherNum !"
    return $(($aNum+$anotherNum))
}
funWithReturn  #函数调用
echo "输入的两个数字之和为 $? !"
```

函数传参方法：

类似脚本运行传参,参数获取从$1开始，代表第一个参数。

```bash
funWithReturn(){ 
 echo "第一个参数为：$1";
 echo "第二个参数为：$2";
 echo "第三个参数为：$3";
}
funWithReturn  a b c    #函数传参调用

================================

第一个参数为：a
第一个参数为：b
第一个参数为：c
```

## 7.Shell 输入/输出重定向

> 大多数 UNIX 系统命令从你的终端接受输入并将所产生的输出发送回​​到您的终端。一个命令通常从一个叫标准输入的地方读取输入，默认情况下，这恰好是你的终端。同样，一个命令通常将其输出写入到标准输出，默认情况下，这也是你的终端。

用的较多的几个：

```bash
command 1 > file1.log   #将运行结果输入到file1.log文件中。
command 2 >> file       #将运行结果输入追加到file1.log文件中。不删除以前的。
command > /dev/null     #/dev/null 是一个特殊的文件，写入到它的内容都会被丢弃；如果尝试从该文件读取内容，那么什么也读不到。但是 /dev/null 文件非常有用，将命令的输出重定向到它，会起到"禁止输出"的效果。   
```

## 8.Shell 文件包含

>和其他语言一样，Shell 也可以包含外部脚本。这样可以很方便的封装一些公用的代码作为一个独立的文件。

```bash
. filename   

# 注意点号(.)和文件名中间有一空格.可以理解为JScript里面的import后可以直接使用filename中的变量、方法等.
```













【未完待续】