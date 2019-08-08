# Intro

Intro brings your rails application to new feature introduction and step-by-step users guide.

Intro injects dynamically-generated [Shepherd.js](https://github.com/shipshapecode/shepherd) code into  your application whenever user should see a guided tour.

+ Define tour content supports image in a backstage.

+ Easy to change tours styles or add a theme.

+ Play nicely with Turbolinks.

+ Friendly to non-developers.

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

Generate assets if you need to customize style of tours:

```
$ rails generate intro:assets
```

Then do migrate:

```
$ rails db:migrate
```

## Usage

### Adding intro to views

Insert `intro` into common layout, just before the closing body tag:

```
<%= intro_tag %>
</body>
</html>
```

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