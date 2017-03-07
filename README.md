# Jekyll Index Pages

Index page generator for Jekyll sites. Generates paginated index pages for blog
posts, categories and tags. It can also generate a paginated yearly archive,
author and collection pages.

## Installation

To perform a manual install, execute this command on your terminal:

```sh
$ gem install jekyll-index-pages
```

Or, if you happen to use Bundler, add this line to your Gemfile:

```ruby
gem "jekyll-index-pages"
```

Then add the gem to the `gems` setting in your `_config.yml` file:

```yaml
gems:
  - jekyll-index-pages
```

## Usage

### Configuring the plugin

If you want to generate index pages for your blog posts, you can add the
following settings to your `_config.yml` file:

```yaml
index_pages:
  posts:
    title: Post Listing Page Title
    excerpt: Post listing page excerpt
    per_page: 20
    permalink: /blog/
    layout: blog
```

This will tell the plugin to generate index pages with given title and excerpt,
using the layout named `_layouts/blog.html`. Each index page will contain up to
20 posts. First page can be accessed at `/blog/`. Subsequent pages can be
accessed at `/blog/<page-num>/`.

If you want to generate index pages for categories, add the `categories`
setting to `index_page` section:

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
layout: posts|categories|tags|authors|archive
```

For categories and tags, `:label` variable refers to the category or tag name.
For posts, `:label` will always be equal to `post`. For the archive, `:label`
refers to any given year. For authors, `:label` is the author name. `:label`
value is slugified when composing the permalink.

Default value for layout depends on the type of index page. For collection
index pages, the default layout is the same as the custon name used to define the
collection config:

```yaml
custom_name:
  layout: custom_name
  collection: collection_name
  ...
```

### Including documents and pagination into templates

To include the paginated documents in your layouts, you can use the `pager`
variable as demonstrated next:

```liquid
{% assign pager = page.pager %}

{% for doc in pager.docs %}
  <h2>{{ doc.title }}</h2>
  {{ doc.excerpt }}
  <a href="{{ doc.url }}">Read more...</a>
{% endfor %}
```

Each document in `pager.docs` is a Jekyll document, so you can access all its
variables as normally do when developing a layout.

To include the pagination, you can do the following:

```liquid
{% assign pager = page.pager %}

{% if pager.total_pages > 1 %}
  {% if pager.prev_page > 0 %}
  <a href="{{ pager.prev_page_url }}">Prev. page</a>
  {% endif %}
  <span>Page {{ pager.current_page }} of {{ pager.total_pages }}</span>
  {% if next_page > 0 %}
  <a href="{{ pager.next_page_url }}">Next page</a>
  {% endif %}
{% endif %}
```

## Contributing

1. Fork it (https://github.com/rukbotto/jekyll-index-pages/fork)
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request
