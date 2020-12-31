# Intro

[![Gem Version](https://badge.fury.io/rb/intro.svg)](https://badge.fury.io/rb/intro)
[![Build Status](https://travis-ci.org/jinhucheung/intro.svg?branch=master)](https://travis-ci.org/jinhucheung/intro)

Intro 为 Rails 应用添加新功能介绍以及用户指引，她根据用户是否需要功能引导，动态注入了 [Shepherd.js](https://github.com/shipshapecode/shepherd) 脚本至应用中。Intro 包含以下功能：

+ 可在后台中管理用户引导
+ 引导内容支持多语言及图片上传
+ 更改引导样式简单
+ 支持 Turbolinks
+ 便于非开发者使用

## 示例

![example](https://user-images.githubusercontent.com/19590194/64253419-dbe38d80-cf4f-11e9-9aab-b1e6058990ab.png)

## 演示

[Demo](https://intro-demo.herokuapp.com/): [Source](https://github.com/jinhucheung/intro-demo)

## 安装

添加 `intro` 到 Gemfile:

```
gem 'intro'
```

执行下面这行代码安装:

```
$ bundle install
```

生成迁移以及配置文件:

```
$ rails generate intro:install
```

然后执行迁移:

```
$ rails db:migrate
```

然后编译资源:

```
$ rails assets:precompile
```

## 使用

### 将资源文件添加至视图

添加 `intro_tags` 在共用的 layout 中, 在 body 标签关闭之前:

```
<%= intro_tags %>
</body>
</html>
```

`intro_tags` 引入了 intro 相关资源文件和添加了一个记录 intro 配置的全局变量 `_intro` 。

**Note**: 如果你正在使用 Turbolinks, 为了更新 `_intro` 变量， `intro_tags` 须插入在 body 关闭之前。

### 后台添加引导

运行 Rails 应用并访问 `http://localhost:3000/intro/admin`。在 `config/initializers/intro.rb` 文件中，你可以获取到默认的帐号以登录后台。

然后添加引导并填入相关内容，最后你需要发布它。

### 更改引导样式

如果默认样式不能满足你，你可以执行下面代码生成样式文件:

```
$ rails generate intro:assets
```

你将会得到下面的文件:

```
app/javascript/stylesheets/intro/_variables.scss
app/javascript/stylesheets/intro/custom.scss
app/javascript/packs/intro/custom.js
```

更改它们以满足你的需要。

最后，在 `intro_tags` 中引入 custom pack 文件。

```
<%= intro_tags do %>
  <%= javascript_pack_tag('intro/custom') %>
<% end %>
```

### 配置 Intro

查看 `config/initializers/intro.rb` 获取详情的配置信息

## 致谢

+ [shepherd](https://github.com/shipshapecode/shepherd)
+ [abraham](https://github.com/actmd/abraham)

## 贡献

欢迎报告 Bug 或提交 Pull Request。

1. 分叉此仓库
2. 创建你的功能分支 (git checkout -b my-new-feature)
3. 提交你的改动 (git commit -am 'Add some feature')
4. 推送到当前分支 (git push origin my-new-feature)

如有必要，请为你的代码编写单元测试。

## 许可

根据 [MIT](MIT-LICENSE) 许可的条款，此仓库可作为开放源代码使用。