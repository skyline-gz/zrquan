开发Todo备忘录
======
### 2014/12/10
* 由于关闭了全局简单escape尖括号<>的配置escape_html_entities_in_json，需要封装一个防止JSON XSS的filter来对返回进行处理
* 问答列表中的缩略答案，现在采用strip_tag进行简单的处理，但丢掉的原文的格式，应使用XPATH工具(gem nokogiri)对文档的标签进行处理，并返回前几个html标签
* 问答列表中的缩略答案，应参考知乎，展示第一张缩略图，可使用(gem nokogiri)提取第一张image的url
* 待补充列表下拉刷新的图标的样式
* 待实现后端正文编辑框的图片/附件上传的后台接口
