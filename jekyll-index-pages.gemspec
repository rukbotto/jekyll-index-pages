require File.expand_path("../lib/jekyll-index-pages/version", __FILE__)

Gem::Specification.new do |spec|
  spec.name       = "jekyll-index-pages"
  spec.version    = IndexPages::VERSION
  spec.date       = "2017-02-16"
  spec.author     = ["Jose Miguel Venegas Mendoza"]
  spec.email      = ["jvenegasmendoza@gmail.com"]
  spec.homepage   = "https://github.com/rukbotto/jekyll-index-pages"
  spec.license    = "MIT"

  spec.summary = "Index page generator for Jekyll sites."
  spec.description = <<-DESCRIPTION
    Generates paginated index pages for blog posts, categories, tags, authors
    and collections. It also let you generate a paginated blog post archive.
  DESCRIPTION

  spec.files = `git ls-files -z`.split("\x0").grep(/^(readme|license|spec)/i)

  spec.add_runtime_dependency("jekyll", "~> 3.3")

  spec.add_development_dependency("bundler", "~> 1.14")
  spec.add_development_dependency("rspec", "~> 3.5")
end
