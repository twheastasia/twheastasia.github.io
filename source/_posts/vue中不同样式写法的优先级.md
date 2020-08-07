title: vue中不同样式写法的优先级
author: twh
tags:
  - vue
  - css
categories:
  - vuejs
date: 2020-08-03 09:45:00
---
# vue中不同样式写法的优先级

### 先直接上代码

> html
```html
<div class="hello">
  <h1>{{ msg }}</h1>
  <h1 class="style-template">{{ msg }}</h1>
  <h1 class="style-template" style="color: red;">{{ msg }}</h1>
  <h1>
    <span>{{ msg }}</span>
    <br>
    <span class="style-template">{{ msg }}</span>
    <br>
    <span class="style-template" style="color: red;">{{ msg }}</span>
  </h1>
</div>
```

> css
```css
h1 {
  color: green;
  .style-template {
    color: brown;
  }
  span {
    color: chartreuse;
  }
}
.style-template {
  color: blue;
}
```

### 主要有几种写法：
1. html元素的css
2. 在元素下设置子元素样式
3. 元素设置class属性
4. 元素设置style属性

### 代码实际运行结果：
![css-demo](/images/WX20200807-102652.png)

### 根据实验得出结论（优先级从高到底）：
> **元素设置style属性 > 元素设置class属性 > 在元素下设置子元素样式 > html元素的css**