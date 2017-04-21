module JekyllIndexPages
  class AuthorURL < URLTag
    def has_kind?(site, kind)
      site.data["authors"].key?(kind)
    end

    def filter_config(config)
      _, item = config.detect { |key, value| key == "authors" }
      item
    end
  end
end

Liquid::Template.register_tag("author_url", JekyllIndexPages::AuthorURL)
