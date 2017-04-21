module JekyllIndexPages
  class TagURL < URLTag
    def has_kind?(site, kind)
      site.tags.key?(kind)
    end

    def filter_config(config)
      _, item = config.detect { |key, value| key == "tags" }
      item
    end
  end
end

Liquid::Template.register_tag("tag_url", JekyllIndexPages::TagURL)
