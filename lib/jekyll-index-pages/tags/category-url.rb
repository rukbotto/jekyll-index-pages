module JekyllIndexPages
  class CategoryURL < URLTag
    def has_kind?(site, kind)
      site.categories.key?(kind)
    end

    def filter_config(config)
      _, item = config.detect { |key, value| key == "categories" }
      item
    end
  end
end

Liquid::Template.register_tag("category_url", JekyllIndexPages::CategoryURL)
