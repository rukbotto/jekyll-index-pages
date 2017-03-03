require "jekyll"
require "jekyll-index-pages/archive"
require "jekyll-index-pages/generator"

module JekyllIndexPages
  autoload :Pagination, "jekyll-index-pages/pagination"
  autoload :IndexPage, "jekyll-index-pages/index-page"
end
