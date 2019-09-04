# Intro

[![Gem Version](https://badge.fury.io/rb/intro.svg)](https://badge.fury.io/rb/intro)
[![Build Status](https://travis-ci.org/jinhucheung/intro.svg?branch=master)](https://travis-ci.org/jinhucheung/intro)

Intro 帮助开发者方便地在 Rails 应用添加新功能介绍以及用户指引，她根据用户是否需要功能引导，动态注入了 [Shepherd.js](https://github.com/shipshapecode/shepherd) 脚本至应用中。Intro 包含以下功能：

+ 可在后台中管理用户引导
+ 引导内容支持多语言及图片上传
+ 更改引导样式简单
+ 支持 Turbolinks
+ 便于非开发者使用

## 示例

![example](https://user-images.githubusercontent.com/19590194/64253419-dbe38d80-cf4f-11e9-9aab-b1e6058990ab.png)

## 演示

[Demo](https://intro-demo.herokuapp.com/)

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
$ bundle exec rake db:migrate
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
app/assets/stylesheets/intro/shepherd/_variables.scss
app/assets/stylesheets/intro/shepherd/base.scss
```

更改它们以满足你的需要。

### 配置 Intro

查看 `config/initializers/intro.rb` 获取详情的配置信息

## Thanks

+ [shepherd](https://github.com/shipshapecode/shepherd)
+ [abraham](https://github.com/actmd/abraham)

## Contributing

Bug report or pull request are welcome.

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)

Please write unit test with your code if necessary.

## License

The gem is available as open source under the terms of the [MIT License](MIT-LICENSE).