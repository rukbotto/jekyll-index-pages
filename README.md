# Jekyll Index Pages

[![Build Status](https://travis-ci.org/rukbotto/jekyll-index-pages.svg?branch=master)](https://travis-ci.org/rukbotto/jekyll-index-pages)

Index page generator for Jekyll sites. Generates paginated index pages for blog posts, categories and tags. It can also generate a paginated yearly archive, author and collection pages.

## Installation

Add this line to your Gemfile:

```ruby
gem "jekyll-index-pages"
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install jekyll-index-pages
```

Finally add this line to `gems` setting in your `_config.yml` file:

```yaml
gems:
  - jekyll-index-pages
```

## Usage

### Configuring the plugin

If you want to generate index pages for your blog posts, you can add the following settings to your `_config.yml` file:

```yaml
index_pages:
  posts:
    title: Post Listing Page Title
    excerpt: Post listing page excerpt
    per_page: 20
    permalink: /blog/
    layout: blog
```

This will tell the plugin to generate index pages with given title and excerpt, using the layout named `_layouts/blog.html`. Each index page will contain up to 20 documents. First page can be accessed at `/blog/`. Subsequent pages can be accessed at `/blog/<page-num>/`.

> Documents are sorted automatically using document's `date` setting, the first being the most recent.

If you want to generate index pages for categories, add the `categories` setting to `index_page` section:

```yaml
index_pages:
  categories:
    ...
```

The same reasoning applies if you want to generate index pages for tags:

```yaml
index_pages:
  tags:
    ...
```

Yearly archive:

```yaml
index_pages:
  archive:
    ...
```

And author pages:

```yaml
index_pages:
  authors:
    ...
```

For collection index pages, you need to include the collection name:

```yaml
index_pages:
  custom_name:
    collection: collection_name
    ...
```

Default values for each setting are:

```yaml
title: :label
excerpt: :label
per_page: 10
permalink: /:label/
```

For categories and tags, `:label` variable refers to the category or tag name.  For posts, `:label` will always be equal to `posts`. For the archive, `:label` refers to any given year. For authors, `:label` is the author name. `:label` value is slugified when composing the permalink.

> Note there is no default value for layout. You must always specify this setting otherwise pages will be generated blank, with no markup.

Because this plugin [transliterates](http://stackoverflow.com/a/20586777) the URL for generated pages, you need to define a language as follows:

```yaml
lang: en-US
```

Then get the specified locale file from <https://github.com/svenfuchs/rails-i18n/tree/master/rails/locale> and add it to the `_locales/` directory inside your site codebase.

### Including custom data into templates

To include custom data in the template, you must define a variable in the configuration under the `data` section:

```yaml
index_pages:
  posts:
    layout: blog
    data:
      custom: This is a custom data item
```

In this case, you can print the contents of the `custom` variable in the `_layouts/blog.html` layout like this:

```liquid
{{ page.custom }}
```

### Including documents and pagination into templates

To include the paginated documents in your layouts, you can use the `pager` variable as demonstrated next:

```liquid
{% assign pager = page.pager %}

{% for doc in pager.docs %}
  <h2>{{ doc.title }}</h2>
  {{ doc.excerpt }}
  <a href="{{ doc.url }}">Read more...</a>
{% endfor %}
```

Each document in `pager.docs` is a Jekyll document, so you can access all its variables as normally do when developing a layout.

To include the pagination, you can do the following:

```liquid
{% assign pager = page.pager %}

{% if pager.total_pages > 1 %}
  {% if pager.prev_page > 0 %}
  <a href="{{ pager.prev_page_url }}">Prev. page</a>
  {% endif %}
  <span>Page {{ pager.current_page }} of {{ pager.total_pages }}</span>
  {% if pager.next_page > 0 %}
  <a href="{{ pager.next_page_url }}">Next page</a>
  {% endif %}
{% endif %}
```

### Linking index pages

Sometimes you will need to link index pages, for example when building some kind of category navigation. For this particular use case, you can use `{% category_url %}`, `{% tag_url %}`, `{% author_url %}` and `{% archive_url %}` tags for getting the correct URL to a given index page.

```liquid
<a href="{% category_url "Category name" %}">Category name</a>
<a href="{% tag_url "Tag name" %}">Tag name</a>
<a href="{% author_url "Author Name" %}">Author Name</a>
<a href="{% archive_url "2001" %}">2001</a>
```

You can pass the argument directly as a string or as a variable.

The following example demonstrates how to create a basic category navigation:

```liquid
<ul>
  {% for category in site.categories %}
    <li><a href="{% category_url category[0] %}">{{ category[0] }}</a></li>
  {% endfor%}
</ul>
```

## Development

After checking out the repo, run `script/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `script/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/rukbotto/jekyll-index-pages.>

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
