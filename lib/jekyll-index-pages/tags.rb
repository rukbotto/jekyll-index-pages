module JekyllIndexPages
  class URLTag < Liquid::Tag
    STRING_SYNTAX = %r{^\"[[:alnum:]\- ]+\"$}u
    VARIABLE_SYNTAX = %r{^\(?[[:alnum:]\-\.\[\]]+\)?$}u

    def initialize(tag_name, markup, tokens)
      super
      @markup = markup.strip
      @tag_name = tag_name
    end

    def parse_params(context)
      input = ""
      if @markup.match(STRING_SYNTAX)
        input = @markup.gsub("\"", "")
      elsif @markup.match(VARIABLE_SYNTAX)
        input = Liquid::Variable.new(@markup).render(context)
      else
        raise ArgumentError, <<-eos
Invalid syntax for #{@tag_name} tag:

  #{@markup}

Valid syntax:

  {% #{@tag_name} "Name" %}

  or

  {% #{@tag_name} variable %}

eos
      end
    end

    def has_kind?(site, kind)
      false
    end

    def filter_config(config)
      nil
    end

    def render(context)
      site = context.registers[:site]
      master_config = site.config["index_pages"] || {}

      kind = parse_params(context)
      return "" if !has_kind?(site, kind)
      slug =
        I18n.transliterate(
          Jekyll::Utils.slugify(kind),
          :locale => I18n.locale
        )

      config = filter_config(master_config)
      permalink = config ? config["permalink"] : "/:label/"
      permalink.sub(":label", slug)
    end
  end
end
