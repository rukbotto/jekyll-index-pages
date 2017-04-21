require "i18n"
require "jekyll"
require "jekyll-index-pages/archive"
require "jekyll-index-pages/author"
require "jekyll-index-pages/collection"
require "jekyll-index-pages/generator"
require "jekyll-index-pages/index-page"
require "jekyll-index-pages/pagination"
require "jekyll-index-pages/tags"
require "jekyll-index-pages/tags/archive-url"
require "jekyll-index-pages/tags/author-url"
require "jekyll-index-pages/tags/category-url"
require "jekyll-index-pages/tags/tag-url"

Jekyll::Hooks.register :site, :after_init do |site|
  if I18n.backend.send(:translations).empty?
    I18n.backend.load_translations(
      Dir[File.join(site.in_source_dir(),"_locales/*.yml")]
    )
  end
  I18n.locale = site.config["lang"]
end
