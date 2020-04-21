title: quill-image-resize-module 踩坑
tags:
  - quill-image-resize-module
categories:
  - vue
author: twh
date: 2020-04-21 09:46:00
---
# quill-image-resize-module 踩坑

项目中使用了 [Vue-Quill-Editor](https://github.com/surmon-china/vue-quill-editor)，挺好用的，但是对于图片上传并不是我希望的效果。好在有扩展，可以满足我的两个需求：
1. 上传图片到图床
2. 调整图片大小

分别对应两个module：
1. [quill-image-extend-module](https://github.com/NextBoy/quill-image-extend-module)
2. [quill-image-resize-module](https://github.com/kensnyder/quill-image-resize-module)

### quill-image-extend-module
quill-image-extend-module照着readme一步一步操作即可

### quill-image-resize-module
这里遇到3个问题：
1. imports 问题
   需要在webpack中手动添加quill插件
2. register 问题
3. quill Cannot import modules/imageResize. Are you sure it was registered?
   > 这两个问题是一定要把大小写写对。。。
   > [代码](https://github.com/kensnyder/quill-image-resize-module/blob/60a43a2477e9947da78a08877bd18a38bc6476af/src/ImageResize.js#L199)中注册时写了imageResize,所以后面使用时也要写生首字母小写




##### 完整的代码如下：
> vue.config.js
~~~javascript
const webpack = require('webpack')

module.exports = {
  chainWebpack(config) {
    config
    .plugin('Quill')
    .use(webpack.ProvidePlugin, [{
      'window.Quill': 'quill'
      // 或
      // 'window.Quill': 'quill/dist/quill.js',
      // 'Quill': 'quill/dist/quill.js'
    }])
  }
}
~~~

> vue
~~~javascript
import { quillEditor, Quill } from 'vue-quill-editor'
import { ImageExtend, QuillWatch } from 'quill-image-extend-module'
import ImageResize from 'quill-image-resize-module'
import 'quill/dist/quill.core.css'
import 'quill/dist/quill.snow.css'
import 'quill/dist/quill.bubble.css'

Quill.register('modules/ImageExtend', ImageExtend)
Quill.register('modules/imageResize', ImageResize)

...

  quillEditorOptions: {
    modules: {
      // 调整图片大小
      imageResize: {
        modules: ['Resize', 'DisplaySize']
      },
      // 上传到图床
      ImageExtend: {
        loading: true,
        name: 'file',
        action: 'url,
        response: (res) => {
          return res.url
        }
      },
      // 如果不上传图片到服务器，此处不必配置
      toolbar: {
        // container为工具栏，此次引入了全部工具栏，也可自行配置
        container: [
          ['bold', 'italic', 'underline', 'strike'],
          ['blockquote', 'code-block'],
          [{ 'list': 'ordered' }, { 'list': 'bullet' }],
          ['link', 'image'],
          [{ 'color': [] }, { 'background': [] }],
          [{ 'align': [] }]
        ],
        handlers: {
          'image': function() {
            // 劫持原来的图片点击按钮事件
            QuillWatch.emit(this.quill.id)
          }
        }
      }
    }
  }
~~~
