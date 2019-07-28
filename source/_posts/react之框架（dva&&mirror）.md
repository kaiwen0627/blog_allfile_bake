---
title: react之框架（dva&&mirror）
date: 2019-01-13 13:00:38
tags: [react, redux, react-redux, 前端, dva, mirror]
categories: react
---

1. 上面一章说到了 redux。但是。老实说、配置太麻烦繁琐。所以这段时间研究了下蚂蚁金服的两个 redux 框架，在此总结下做个笔记。

2. 至于 redux 是什么，干什么用就不赘述了。这里只是简单说下使用这两个框架的感受，不强调 API 和代码编写，具体参考官方的文档即可：

   - [mirror](https://github.com/mirrorjs/mirror/blob/master/docs/zh/api.md)
   - [dva](https://dvajs.com/api/)

## 1.使用体会：

### 1. dva 使用起来更像一个框架，有自己的 模块、路由相关配置，文件结构相对 mirror 严格一些。而 mirror 更像一个库。

1.  这点从使用方法就可以看出来：

- mirror：

```bash
//使用 create-react-app 创建一个新的 app：

npm i -g create-react-app
$ create-react-app my-app

#创建之后，从 npm 安装 Mirror：
$ cd my-app
$ npm i --save mirrorx
$ npm start
```

- dva :

```bash
#安装 dva-cli
#通过 npm 安装 dva-cli 并确保版本是 0.9.1 或以上#
$ npm install dva-cli -g
$ dva -v
dva-cli version 0.9.1
#创建新应用
#安装完 dva-cli 之后，就可以在命令行里访问到 dva 命令（不能访问？）。现在，你可以通过 dva new 创建新应用。

$ dva new dva-quickstart
#这会创建 dva-quickstart 目录，包含项目初始化目录和文件，并提供开发服务器、构建脚本、数据 mock 服务、代理服务器等功能。

#然后我们 cd 进入 dva-quickstart 目录，并启动开发服务器：

$ cd dva-quickstart
$ npm start
```

2. 初始项目结构：

- 由于 mirror 是在 create-react-app 脚手架工具上 import 使用，所以他的目录结构比较灵活。
- dva 更接近于框架，所以，目录结构和 react-react-app 区别较大。刚上手需要简单熟悉下：

--- dva 初始项目结构：---

![](https://s2.ax1x.com/2019/01/13/FvrR1K.png)

- mock 存放用于 mock 数据的文件；
- public 一般用于存放静态文件，打包时会被直接复制到输出目录(./dist)；
- src 文件夹用于存放项目源代码；
  - asserts 用于存放静态资源，打包时会经过 webpack 处理；
  - components 用于存放 React 组件，一般是该项目公用的无状态组件；
  - models 用于存放模型文件
  - routes 用于存放需要 connect model 的路由组件；可以在此文件夹中编写“页面”
  - services 用于存放服务文件，一般是网络请求等；
  - utils 工具类库
- router.js 路由文件
- index.js 项目的入口文件
- index.css 一般是共用的样式
- .editorconfig 编辑器配置文件
- .eslintrc ESLint 配置文件
- .gitignore Git 忽略文件
- .roadhogrc.mock.js Mock 配置文件
- .webpackrc 自定义的 webpack 配置文件，JSON 格式，如果需要 JS 格式，可修改为 - .webpackrc.js

## 2. 相关知识：

1. 高阶组件：
   > 如果一个函数操作其他函数，即将其他函数作为参数或将函数作为返回值，将其称为高阶函数。高阶组件(high-order component)类似于高阶函数，接收 React 组件作为输入，输出一个新的 React 组件。高阶组件让代码更具有复用性、逻辑性与抽象特征。可以对 render 方法作劫持，也可以控制 props 与 state。

首先，高阶组件不是组件。而是函数！ 简单地说，高阶组件就是一个函数接收参数是一个组件，然后返回一个加工修饰后的组件。典型的高阶组件：redux 中的 connect：

```js
export default connect(state => ({ state }))(IndexPage);
```

== 传入 IndexPage 组件，给上面绑定 state 数据后返回==


(未完待续)