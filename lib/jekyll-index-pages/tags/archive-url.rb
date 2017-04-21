module JekyllIndexPages
  class ArchiveURL < URLTag
    def has_kind?(site, kind)
      site.data["archive"].key?(kind)
    end

    def filter_config(config)
      _, item = config.detect { |key, value| key == "archive" }
      item
    end
  end
end

Liquid::Template.register_tag("archive_url", JekyllIndexPages::ArchiveURL)
