require "jekyll"
require "jekyll-index-pages/index-page-generator"

module IndexPages
  autoload :Pagination, "jekyll-index-pages/pagination"
  autoload :IndexPage, "jekyll-index-pages/index-page"
end
