---
title: javascript算法（壹）
date: 2019-07-23 10:07:38
tags: [javascript, 算法 ]
categories: JavaScript
---

# JavaScript 语言基础部分

## 1. 数组部分

### 1.1 去重

```javascript

const arr=[1,2,'2',2,3,4,5];

// 1. ES6 Set
const set=[...new Set(arr)]
console.log(set);    // [ 1, 2,'2', 3, 4, 5 ]

// 2.for循环
function uniq(arr) {
  let _result = [];
  for (let i = 0; i < arr.length; i++) {
    if (!_result.includes(arr[i])) {   // includes 为 === 比较
      _result.push(arr[i]);
    }
  }
  return _result;
}
console.log(uniq(arr)); // [ 1, 2,'2', 3, 4, 5 ]

```

### 1.2 冒泡排序

- 5个球进行排序，需要比较4轮，共比较次数 4+3+2+1=10次。
- 比较此时公式：
  
$$
\sum_{i=1} ^{i=n-1} i
$$

```js
// 1. bubbleSort不是纯函数，会直接改变引用类型的arr
function bubbleSort(arr) {
  for (let i = 0; i < arr.length - 1; i++) {
    for (let j = 0; j < arr.length - 1 - i; j++) {
      if (arr[j] > arr[j + 1]) {
        let temp = arr[j];
        arr[j] = arr[j + 1];
        arr[j + 1] = temp;
      }
    }
  }
}
const arr = [12, 321, 32, 43, 455, 54, 5, 2];
bubbleSort(arr);
console.log(arr); // [ 2, 5, 12, 32, 43, 54, 321, 455 ]

// 2. 纯函数，不会改变原有数组
function bubbleSort (arr) {
  const _arr = [...arr]; // 浅克隆
  for (let i = 0; i < _arr.length - 1; i++) {
    for (let j = 0; j < _arr.length - 1 - i; j++) {
      if (_arr[j] > _arr[j + 1]) {
        let temp = _arr[j];
        _arr[j] = _arr[j + 1];
        _arr[j + 1] = temp;
      }
    }
  }
  return _arr;
}
const arr = [12, 321, 32, 43, 455, 54, 5, 2];
let result=bubbleSort(arr);
console.log(arr); //[ 12, 321, 32, 43, 455, 54, 5, 2 ]
console.log(result); // [ 2, 5, 12, 32, 43, 54, 321, 455 ]

```

### 1.3 快速排序（二分法排序）

- 选取一个标杆值。用这个值去和数组中其他的值去依次比较大小。比他的的放在bigger数组，小的放在smaller数组，然后拼接数组。依次递归。

```js
function quickSort(arr) {
  //停止递归
  if (arr.length <= 1) {
    return arr;
  }
  //标杆
  let p = arr[0];
  //存放比标杆大的值
  let bigger = [];
  //存放比标杆小的值
  let smaller = [];
  for (let i = 1; i < arr.length; i++) {
    if (arr[i] >= p) {
      bigger.push(arr[i]);
    } else {
      smaller.push(arr[i]);
    }
  }
  //递归调用
  return [...quickSort(smaller), p, ...quickSort(bigger)];
  // return quickSort(smaller).concat(p,quickSort(bigger))
}
const arr = [123, 2342, 43, 4354, 54, 656, 76];
const result = quickSort(arr);
console.log(result); // [ 43, 54, 76, 123, 656, 2342, 4354 ]

```

### 1.4 数组扁平化

```js

const arr = [0, "1", [1, 2], ["a", "b"], [[["xxx"], 3, 5]]];

function flattenArray(arr) {
  let result = [];
  //每一项进行遍历，看是不是常数还是数组，如果是数组，则递归调用
  for (let i = 0; i < arr.length; i++) {
    //注意检查数组方法。不能为 typeof
    if (Array.isArray(arr[i])) {
      result = [...result, ...flattenArray(arr[i])];
    } else {
      result.push(arr[i]);
    }
  }
  return result;
}

console.log(flattenArray(arr));

```

### 1.5 拓展功能

```js

//求数组的最大值
Math.max.apply(null,arr)

// prototype
Array.prototype.max=function (){
  return Math.max.apply(null,this)
}
let a = [1,2,3].max()
console.log(a); //3

```

## 2.函数

### 2.1 函数科里（curry）化

```js
function curry(fn) {
  return function() {
    //备份实参
    let args = arguments;
    return function() {
      return fn(...args, ...arguments);
    };
  };
}

function fun(a, b, c, d) {
  return a + b + c + d;
}

//把fun函数curry化
fun = curry(fun);

let fn = fun(1, 2);
console.log(fun()); // [Function]
console.log(fn(3, 4)); // 10
```

## 3. 深浅克隆

- 浅克隆 ： 表层克隆一层，如果数组的某一项是数组，这个内层数组还是内存中的同一个数组。

```js
let arr = [1, 2, 3, [5, 6, 7]];
let _arr = [];
for (let i = 0; i < arr.length; i++) {
  _arr.push(arr[i]);
}
console.log(arr === _arr); // false ，克隆成功
console.log(arr[0] === _arr[0]); // true ，第一层，直接复制值
console.log(arr[3] === _arr[3]); // true,第二层直接复制指针，不是复制值
```

- 深克隆
  
```js

// todo 如何区分正则表达式？

let arr = [1, "2", 3, [5, 6, 7], null, undefined, /^k[0-9]/g, { name: "kai" }];
function deepClone(obj) {
  if (typeof obj !== "object") {
    return obj;
  } else if (Array.isArray(obj)) {
    let _arr = [];
    for (let i = 0; i < obj.length; i++) {
      if (obj[i] === null) {
        _arr.push(null);
        continue;
      }
      _arr.push(deepClone(obj[i]));
    }
    return _arr;
  } else if (typeof obj === "object") {
    let _object = {};
    for (const key in obj) {
      _object[key] = obj[key];
    }
    return _object;
  }
}
let clone_obj = deepClone(arr);
console.log(arr);        // [ 1, "2", 3, [5, 6, 7], null, undefined, /^k[0-9]/g, { name: "kai" }]
console.log(clone_obj);  // [ 1, '2', 3, [ 5, 6, 7 ], null, undefined, {}, { name: 'kai' } ]
console.log(arr === clone_obj); //false
console.log(arr[3] === clone_obj[3]); // false


```







### 附录

##### 1. 使用递归的6种情况：

  1. 阶乘
  2. 数组扁平化
  3. 深克隆
  4. 快速排序
  5. 杨辉三角、各种三角
  6. 脑筋急转弯，eg:不使用for、while循环输出 1-100
  
