# Intro

[![Gem Version](https://badge.fury.io/rb/intro.svg)](https://badge.fury.io/rb/intro)
[![Build Status](https://travis-ci.org/jinhucheung/intro.svg?branch=master)](https://travis-ci.org/jinhucheung/intro)

[中文文档 Chinese document](/README-CN.md)

Intro brings your rails application to new feature introduction and step-by-step users guide.

Intro injects dynamically-generated [Shepherd.js](https://github.com/shipshapecode/shepherd) code into your application whenever user should see a guided tour.

+ Define tour content in a backstage.
+ Tour content supports image, many languages.
+ Easy to change tours styles or add a theme.
+ Play nicely with Turbolinks.
+ Friendly to non-developers.

## Example

![example](https://user-images.githubusercontent.com/19590194/64253419-dbe38d80-cf4f-11e9-9aab-b1e6058990ab.png)

## Demo

[Demo](https://intro-demo.herokuapp.com/): [Source](https://github.com/jinhucheung/intro-demo)

## Installation

Add `intro` to application's Gemfile:

```
gem 'intro'
```

And then execute:

```
$ bundle install
```

Copy migrations and configurations:

```
$ rails generate intro:install
```

Then do migrate:

```
$ bundle exec rake db:migrate
```

## Usage

### Inserting assets into view

Insert `intro_tags` into common layout, just before the closing body tag:

```
<%= intro_tags %>
</body>
</html>
```

`intro_tags` imports assets of intro and adds `_intro` global variable with options.

**Note**: `intro_tags` must be inserted into body tag for refreshing `_intro` variable if you need to use Turbolinks.

### Adding tour in backstage

Visit `http://localhost:3000/intro/admin` to backstage after starting server. In `config/initializers/intro.rb` file, you can get the default username and password for logining.

Then add tour and define content. After filling out the content, you need to publish tour.

### Customizing tour style

If the default style doesn't satisfy you, you need to run assets generator:

```
$ rails generate intro:assets
```

Then you would get the asset files:

```
app/assets/stylesheets/intro/shepherd/_variables.scss
app/assets/stylesheets/intro/shepherd/base.scss
```

Change them for your need.

### Configuring intro

see `config/initializers/intro.rb` for detail configuration.

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