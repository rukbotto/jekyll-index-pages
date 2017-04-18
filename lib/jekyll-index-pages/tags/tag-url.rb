module JekyllIndexPages
  class TagURL < Liquid::Tag
    def initialize(tag, text, tokens)
      super
      @text = text.strip
    end

    def render(context)
      site = context.registers[:site]

      config = site.config["index_pages"] || {}
      _, item = config.detect do |key, value|
        key == "tags"
      end

      permalink = item ? item["permalink"] : "/:label/"
      tag, _ = site.tags.detect do |key, value|
        key == @text
      end

      if tag
        tag_slug =
          I18n.transliterate(
            Jekyll::Utils.slugify(tag),
            :locale => I18n.locale
        )
        permalink.sub(":label", tag_slug)
      else
        ""
      end
    end
  end
end

Liquid::Template.register_tag("tag_url", JekyllIndexPages::TagURL)
