---
title: Redux(一)
date: 2018-08-22 22:00:38
tags: [react,redux, 前端 ]
categories: react
---

>如果要用一句话来概括Redux，那么可以使用官网的这句话：Redux是针对JavaScript应用的可预测状态容器。此句话虽然简单，但包含了以下几个含义：

- 可预测性(predictable): 因为Redux用了reducer与纯函数(pure function)的概念，每个新的state都会由旧的state建来一个全新的state。因而所有的状态修改都是”可预测的”。
- 状态容器(state container): state是集中在单一个对象树状结构下的单一store，store即是应用程序领域(app domain)的状态集合。
- JavaScript应用: 这说明Redux并不是单指设计给React用的，它是独立的一个函数库，可通用于各种JavaScript应用。

> Redux基于简化版本的Flux框架，Flux是Facebook开发的一个框架。在标准的MVC框架中，数据可以在UI组件和存储之间双向流动，而Redux严格限制了 ***数据只能在一个方向上流动***。

[![PTGuW9.md.png](https://s1.ax1x.com/2018/08/22/PTGuW9.md.png)](https://imgchr.com/i/PTGuW9)

为了说明整个模型的运作流程，首先我们需要弄清Redux模型中的几个组成对象：action 、reducer、store。

- action：官方的解释是action是把数据从应用传到 store 的有效载荷，它是 store 数据的唯一来源；要通过本地或远程组件更改状态，需要分发一个action；
- reducer：action发出了做某件事的请求，只是描述了要做某件事，并没有去改变state来更新界面，reducer就是根据action的type来处理不同的事件；
- store：store就是把action和reducer联系到一起的对象，store本质上是一个状态树，保存了所有对象的状态。任何UI组件都可以直接从store访问特定对象的状态。

在Redux中，所有的数据（比如state）被保存在一个被称为store的容器中 ，在一个应用程序中只能有一个store对象。当一个store接收到一个action，它将把这个action代理给相关的reducer。reducer是一个纯函数，它可以查看之前的状态，执行一个action并且返回一个新的状态。

## Redux配置

配置Redux开发环境的最快方法是使用create-react-app工具。在开始之前，确保已经安装并更新了nodejs、npm和yarn。下面以生成一个redux-shopping项目并安装Redux为例。

如果没有安装create-react-app工具，请使用下面的命令先执行安装操作。

```cmd
npm install -g create-react-app
```

然后，在使用下面的命令创建redux-shopping项目。

```cmd
create-react-app redux-shopping
cd redux-shopping
yarn add redux
```

首先，删除src文件夹中除index.js以外的所有文件。打开index.js，删除所有代码，键入以下内容：

```js
import { createStore } from "redux";

const reducer = function(state, action) {
  return state;
}

const store = createStore(reducer);
```
上面代码的意思是：

1. 从redux包中引入createStore()方法；
2. 创建了一个名为reducer的方法，第一个参数state是当前保存在store中的数据，第二个参数action是一个容器，用于： 
    - type - 一个简单的字符串常量，例如ADD, UPDATE, DELETE等。 
    - payload - 用于更新状态的数据。
3. 创建一个Redux存储区，它只能使用reducer作为参数来构造。存储在Redux存储区中的数据可以被直接访问，但只能通过提供的reducer进行更新。

目前，state为undefined或null，要解决这个问题，需要分配一个默认的值给state，使其成为一个空数组。例如：

```js
const reducer = function(state=[], action) {
  return state;
}
```

目前我们创建的reducer是通用的，那么我们如何使用多个reducer呢？此时我们可以使用Redux包中提供的combineReducers函数。做如下内容修改：

```js
// src/index.js

import { createStore } from "redux";
import { combineReducers } from 'redux';

const productsReducer = function(state=[], action) {
  return state;
}

const cartReducer = function(state=[], action) {
  return state;
}

const allReducers = {
  products: productsReducer,
  shoppingCart: cartReducer
}

const rootReducer = combineReducers(allReducers);

let store = createStore(rootReducer);
```
接下来，我们将为reducer定义一些测试数据。

```js
// src/index.js

…

const initialState = {
  cart: [
    {
      product: 'bread 700g',
      quantity: 2,
      unitCost: 90
    },
    {
      product: 'milk 500ml',
      quantity: 1,
      unitCost: 47
    }
  ]
}

const cartReducer = function(state=initialState, action) {
  return state;
}

…

let store = createStore(rootReducer);

console.log("initial state: ", store.getState());
```

接下来，我们可以在终端中执行npm start或者yarn start来运行dev服务器，并在控制台中查看state。 

![PTtSiD.jpg](https://s1.ax1x.com/2018/08/22/PTtSiD.jpg)

现在，我们的cartReducer什么也没做，但它应该在Redux的存储区中管理购物车商品的状态。我们需要定义添加、更新和删除商品的操作(action)。此时我们可以做如下的一些定义：

```js
// src/index.js

…

const ADD_TO_CART = 'ADD_TO_CART';

const cartReducer = function(state=initialState, action) {
  switch (action.type) {
    case ADD_TO_CART: {
      return {
        ...state,
        cart: [...state.cart, action.payload]
      }
    }

    default:
      return state;
  }
}

…
```
我们继续来分析一下代码。一个reducer需要处理不同的action类型，因此我们需要一个SWITCH语句。当一个ADD_TO_CART类型的action在应用程序中分发时，switch中的代码将处理它。

接下来，我们将定义一个action，作为store.dispatch()的一个参数。action是一个Javascript对象，有一个必须的type和可选的payload。我们在cartReducer函数后定义一个：

```js
…
function addToCart(product, quantity, unitCost) {
  return {
    type: ADD_TO_CART,
    payload: { product, quantity, unitCost }
  }
}
…
```

在这里，我们定义了一个函数，返回一个JavaScript对象。在我们分发消息之前，我们添加一些代码，让我们能够监听store事件的更改。

```js
…
let unsubscribe = store.subscribe(() =>
  console.log(store.getState())
);

unsubscribe();
```
接下来，我们通过分发消息到store来向购物车中添加商品。将下面的代码添加在unsubscribe()之前：

```js
store.dispatch(addToCart('Coffee 500gm', 1, 250));
store.dispatch(addToCart('Flour 1kg', 2, 110));
store.dispatch(addToCart('Juice 2L', 1, 250));
```

![PTtBO1.png](https://s1.ax1x.com/2018/08/22/PTtBO1.png)

到此，我们已经走通了redux的简易流程。不过代码有点乱。维护成本太高。所以我们需要拆分代码。

## 代码拆分
会发现，index.js中的代码逐渐变得冗杂。所以，接下来我们对上面的项目进行一个组织拆分，使之成为Redux项目。首先，在src文件夹中创建一下文件和文件夹，文件结构如下：

```txt
src/
├── actions
│ └── cart-actions.js
├── index.js
├── reducers
│ ├── cart-reducer.js
│ ├── index.js
│ └── products-reducer.js
└── store.js
```
然后，我们把index.js中的代码进行整理：

```js
// src/actions/cart-actions.js

export const ADD_TO_CART = 'ADD_TO_CART';

export function addToCart(product, quantity, unitCost) {
  return {
    type: ADD_TO_CART,
    payload: { product, quantity, unitCost }
  }
}
```

```js
// src/reducers/cart-reducer.js

import  { ADD_TO_CART }  from '../actions/cart-actions';

const initialState = {
  cart: [
    {
      product: 'bread 700g',
      quantity: 2,
      unitCost: 90
    },
    {
      product: 'milk 500ml',
      quantity: 1,
      unitCost: 47
    }
  ]
}

export default function(state=initialState, action) {
  switch (action.type) {
    case ADD_TO_CART: {
      return {
        ...state,
        cart: [...state.cart, action.payload]
      }
    }

    default:
      return state;
  }
}
```
```js
// src/reducers/index.js

import { combineReducers } from 'redux';
import productsReducer from './products-reducer';
import cartReducer from './cart-reducer';

const allReducers = {
  products: productsReducer,
  shoppingCart: cartReducer
}

const rootReducer = combineReducers(allReducers);

export default rootReducer;
```

```js
// src/store.js

import { createStore } from "redux";
import rootReducer from './reducers';

let store = createStore(rootReducer);

export default store;
```

```js
// src/index.js

import store from './store.js';
import { addToCart }  from './actions/cart-actions';

console.log("initial state: ", store.getState());

let unsubscribe = store.subscribe(() =>
  console.log(store.getState())
);

store.dispatch(addToCart('Coffee 500gm', 1, 250));
store.dispatch(addToCart('Flour 1kg', 2, 110));
store.dispatch(addToCart('Juice 2L', 1, 250));

unsubscribe();
```
整理完代码之后，程序依然会正常运行.现在我们来添加修改和删除购物车中商品的逻辑。修改cart-actions.js和cart-reducer.js文件：

```js
// src/reducers/cart-actions.js
…
export const UPDATE_CART = 'UPDATE_CART';
export const DELETE_FROM_CART = 'DELETE_FROM_CART';
…
export function updateCart(product, quantity, unitCost) {
  return {
    type: UPDATE_CART,
    payload: {
      product,
      quantity,
      unitCost
    }
  }
}

export function deleteFromCart(product) {
  return {
    type: DELETE_FROM_CART,
    payload: {
      product
    }
  }
}
```

```js
// src/reducers/cart-reducer.js
…
export default function(state=initialState, action) {
  switch (action.type) {
    case ADD_TO_CART: {
      return {
        ...state,
        cart: [...state.cart, action.payload]
      }
    }

    case UPDATE_CART: {
      return {
        ...state,
        cart: state.cart.map(item => item.product === action.payload.product ? action.payload : item)
      }
    }

    case DELETE_FROM_CART: {
      return {
        ...state,
        cart: state.cart.filter(item => item.product !== action.payload.product)
      }
    }

    default:
      return state;
  }
}
```

最后，我们在index.js中分发这两个action：

```js
// Update Cart
store.dispatch(updateCart('Flour 1kg', 5, 110));

// Delete from Cart
store.dispatch(deleteFromCart('Coffee 500gm'));
```
## 使用Redux工具进行调试

Redux拥有很多第三方的调试工具，可用于分析代码和修复bug。最受欢迎的是time-travelling tool，即redux-devtools-extension。设置它只需要三个步骤。

首先，在Chrome中安装Redux Devtools扩展；
然后，在运行Redux应用程序的终端里使用Ctrl+C停止服务器。并用npm或yarn安装redux-devtools-extension包；

```cmd
yarn add redux-devtools-extension
```
一旦安装完成，我们对store.js稍作修改都会反映到结果上。例如，我们还可以把src/index.js中日志相关的代码删除掉。返回Chrome，右键单击该工具的图标，打开Redux DevTools面板。 

