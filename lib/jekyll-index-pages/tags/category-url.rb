module JekyllIndexPages
  class CategoryURL < Liquid::Tag
    STRING_SYNTAX = %r{^\"[[:alnum:] ]+\"$}u
    VARIABLE_SYNTAX = %r{^\(?[[:alnum:]\-\.\[\]]+\)?$}u

    def initialize(tag, markup, tokens)
      super
      @markup = markup.strip
    end

    def render(context)
      input = ""
      if @markup.match(STRING_SYNTAX)
        input = @markup.gsub("\"", "")
      elsif @markup.match(VARIABLE_SYNTAX)
        input = Liquid::Variable.new(@markup).render(context)
      else
        raise ArgumentError, <<-eos
Invalid syntax for category_url tag:

  #{@markup}

Valid syntax:

  {% category_url "Category name" %}

  or

  {% category_url name_in_variable %}

eos
      end

      site = context.registers[:site]

      category, _ = site.categories.detect { |key, value| key == input }
      return "" if !category
      category_slug =
        I18n.transliterate(
          Jekyll::Utils.slugify(category),
          :locale => I18n.locale
        )

      config = site.config["index_pages"] || {}
      _, item = config.detect { |key, value| key == "categories" }
      permalink = item ? item["permalink"] : "/:label/"
      permalink.sub(":label", category_slug)
    end
  end
end

Liquid::Template.register_tag("category_url", JekyllIndexPages::CategoryURL)
