# -*- encoding: utf-8 -*-
require File.expand_path("../lib/jekyll-index-pages/version", __FILE__)

Gem::Specification.new do |spec|
  spec.name     = "jekyll-index-pages"
  spec.version  = JekyllIndexPages::VERSION
  spec.authors  = ["Jose Miguel Venegas Mendoza"]
  spec.email    = ["jvenegasmendoza@gmail.com"]
  spec.homepage = "https://github.com/rukbotto/jekyll-index-pages"
  spec.license  = "MIT"

  spec.summary      = "Index page generator for Jekyll sites."
  spec.description  = <<-DESCRIPTION
    Index page generator for Jekyll sites. Generates paginated index pages for
    blog posts, categories and tags. It can also generate a paginated yearly
    archive, author and collection pages.
  DESCRIPTION

  spec.files          = `git ls-files`.split("\n")
  spec.executables    = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files     = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths  = ["lib"]

  spec.add_dependency("jekyll", "~> 3.3")

  spec.add_development_dependency("bundler", "~> 1.14")
  spec.add_development_dependency("rake", "~> 10.0")
  spec.add_development_dependency("rspec", "~> 3.5")
end
