# Jekyll Index Pages

Index page generator for Jekyll sites. Generates paginated index pages for blog
posts, categories and tags.

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

Default values for each setting are:

```yaml
index_pages:
  posts:
    title: posts
    excerpt: posts
    per_page: 10
    permalink: /posts/
    layout: posts
```

If you want to generate index pages for categories, add the `categories`
setting to `index_page` section:

```yaml
# Displaying default values
index_pages:
  categories:
    title: categories
    excerpt: categories
    per_page: 10
    permalink: /categories/
    layout: categories
```

Given the default values above, categories index pages can be accessed at
`/categories/<category-name-slug>/`.

The same reasoning applies if you want to generate index pages for tags:

```yaml
# Displaying default values
index_pages:
  tags:
    title: tags
    excerpt: tags
    per_page: 10
    permalink: /tags/
    layout: tags
```

Given the default values above, tags index pages can be accessed at
`/tags/<tag-name-slug>/`.

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
