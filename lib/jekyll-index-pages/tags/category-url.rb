module JekyllIndexPages
  class CategoryURL < Liquid::Tag
    def initialize(tag, text, tokens)
      super
      @text = text.strip
    end

    def render(context)
      site = context.registers[:site]

      config = site.config["index_pages"] || {}
      _, item = config.detect do |key, value|
        key == "categories"
      end

      permalink = item ? item["permalink"] : "/:label/"
      category, _ = site.categories.detect do |key, value|
        key == @text
      end

      if category
        category_slug =
          I18n.transliterate(
            Jekyll::Utils.slugify(category),
            :locale => I18n.locale
          )
        permalink.sub(":label", category_slug)
      else
        ""
      end
    end
  end
end

Liquid::Template.register_tag("category_url", JekyllIndexPages::CategoryURL)
