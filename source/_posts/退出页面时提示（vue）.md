# vue项目中离开页面时提示功能

----

- 当页面刷新、浏览器窗口关闭、页面前进、页面后退，用浏览器自带的confirm
- 项目中路由之间的跳转，可以用vue项目引入的组件实现

### 路由跳转

```javascript
beforeRouteLeave(to, from, next) {
  next(false)
  if (to.path !== 'xxx' && someOtherCondition) {
    this.$confirm('您还未保存页面内容，确定需要退出吗?', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }).then(() => {
      // 选择确定
      next()
    }).catch(() => {
      // 选择取消
    })
  } else {
    // 不是预期的页面就继续跳转
    next()
  }
}
```

### 页面刷新、浏览器窗口关闭、页面前进、页面后退

```javascript
// 这几个事件只能在beforeunload中捕获
window.addEventListener('beforeunload', (event) => {
  if (this.$route.name === 'xxx' && someOtherCondition) {
    event.returnValue = 'reload'
  }
})
```