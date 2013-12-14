# Sprockets Better Errors [![Build Status](https://travis-ci.org/schneems/sprockets_better_errors.png?branch=master)](https://travis-ci.org/schneems/sprockets_better_errors)

## What

Errors, more of them, and better. For sprockets, specifically sprockets-rails. The goal of this library is to make it painfully obvious when you've done something wrong with the rails asset pipeline. Like what?

Let's say you're referencing an asset in your view

```erb
<%= stylesheet_link_tag "search" %>
```

This works in development but you'll find if you're precompiling your assets that it won't work in production. Why? By default sprockets is configured only to precompile `application.css`. Wouldn't it have been great if you could have been warned in development before you pushed to production and your site broke?

```
Asset filtered out and will not be served: add `config.assets.precompile += %w( search.js )` to `config/application.rb` and restart your server
```

That would be AMAZING! Well this gem adds these types of helpful errors!

## Compatibility

If you're using Rails 3.2 you will need to [enable the Rails 4 asset pipeline in Rails 3](https://discussion.heroku.com/t/using-the-rails-4-asset-pipeline-in-rails-3-apps-for-faster-deploys/205). Works out of the box with Rails 4.

## Install

In your `Gemfile` add:

```
gem 'sprockets_better_errors'
```

Then run:

```
$ bundle install
```

And add this line to your `config/environments/development.rb`:

```
config.assets.raise_production_errors = true
```

Now develop with some sprockets super powers!


## The Errors

We try to catch all mistakes but we're not perfect. Here's a list of the things we watch out for

### Raise On Dev asset not in Precompile List

This is one of the most common asset errors I see at Heroku. We covered this error in the "Why" section above. Incase you're skipping around here's the run down:

Let's say you're referencing an asset in your view

```erb
<%= stylesheet "search.css" %>
```

This works in development but you'll find if you're precompiling your assets that it won't work in production. Why? By default sprockets is configured only to precompile `application.css`. Wouldn't it have been great if you could have been warned in development before you pushed to production and your site broke?

```
Asset filtered out and will not be served: add `config.assets.precompile += %w( search.js )` to `config/application.rb` and restart your server
```

Add this gem and you get that error.

### Raise When Dependencies Improperly Used

This one may be a bit of an edge case for most people, but the difficulty in debugging (hours, days, weeks) is well worth the check.

If a dependency is used in an ERB asset that references another asset, it will not be updated when the reference asset is updated. The fix is to use `//= depend_on` or its cousin `//= depend_on_asset` however this is easy to forget. See rails/sprockets-rails#95 for more information.

Currently Rails/Sprockets hides this problem, and only surfaces it when the app is deployed with precompilation to production multiple times. We know that you will have this problem if you are referencing assets from within other assets and not declaring them as dependencies. This PR checks if you've declared a given file as a dependency before including it via `asset_path`. If not a helpful error is raised:

```
Asset depends on 'bootstrap.js' to generate properly but has not declared the dependency
Please add: `//= depend_on_asset "bootstrap.js"` to '/Users/schneems/Documents/projects/codetriage/app/assets/javascripts/application.js.erb'
```

Implementation is quite simple and limited to `helper.rb`, additional code is all around tests.


## Upstream

Why not add this code upstream? I already tried, there are several PR awaiting merge. If you found this Gem useful maybe give them a `:+1:`.

- [Raise On Dev asset not in Precompile list](https://github.com/rails/sprockets-rails/pull/84)
- [Raise on improper dependency use](https://github.com/rails/sprockets-rails/pull/96)
- Bonus, not mine: [Raise if ERB ](https://github.com/sstephenson/sprockets/pull/426)


## Tests

Here's a one liner to running tests

```
$ export RAILS_VERSION=4.0.0; bundle update; bundle exec rake test
```

## License

MIT
