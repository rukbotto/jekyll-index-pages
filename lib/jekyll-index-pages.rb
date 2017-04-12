require "i18n"
require "jekyll"
require "jekyll-index-pages/archive"
require "jekyll-index-pages/author"
require "jekyll-index-pages/collection"
require "jekyll-index-pages/generator"

module JekyllIndexPages
  autoload :Pagination, "jekyll-index-pages/pagination"
  autoload :IndexPage, "jekyll-index-pages/index-page"

  I18n.available_locales = [:en]
end
