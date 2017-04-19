module JekyllIndexPages
  class TagURL < Liquid::Tag
    STRING_SYNTAX = %r{^\"[[:alnum:]\-]+\"$}u
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
Invalid syntax for tag_url tag:

  #{@markup}

Valid syntax:

  {% tag_url "Tag name" %}

  or

  {% tag_url name_in_variable %}

eos
      end

      site = context.registers[:site]

      tag, _ = site.tags.detect { |key, value| key == input }
      return "" if !tag
      tag_slug =
        I18n.transliterate(
          Jekyll::Utils.slugify(tag),
          :locale => I18n.locale
      )

      config = site.config["index_pages"] || {}
      _, item = config.detect { |key, value| key == "tags" }
      permalink = item ? item["permalink"] : "/:label/"
      permalink.sub(":label", tag_slug)
    end
  end
end

Liquid::Template.register_tag("tag_url", JekyllIndexPages::TagURL)
