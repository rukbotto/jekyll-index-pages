module JekyllIndexPages
  class IndexPage < Jekyll::Page
    def initialize(site, base, dir, config, label, layout, pager)
      @site = site
      @base = base
      @dir = dir
      @name = "index.html"

      title = config["title"] || ":label"
      excerpt = config["excerpt"] || ":label"

      self.process(@name)
      self.read_yaml(File.join(base, "_layouts"), "#{layout}.html")

      self.data["title"] = title.sub(":label", label)
      self.data["excerpt"] = excerpt.sub(":label", label)

      self.data["pager"] = Hash.new
      self.data["pager"]["docs"] = pager.docs.sort { |x, y| y.date <=> x.date }
      self.data["pager"]["total_pages"] = pager.total_pages
      self.data["pager"]["current_page"] = pager.current_page
      self.data["pager"]["prev_page"] = pager.prev_page
      self.data["pager"]["next_page"] = pager.next_page
      self.data["pager"]["prev_page_url"] =
        if (pager.prev_page > 0)
          File.join(dir.sub(%r{/\d+}, ""), pager.prev_page.to_s << "/")
        else
          ""
        end
      self.data["pager"]["next_page_url"] =
        if (pager.next_page > 0)
          File.join(dir.sub(%r{/\d+}, ""), pager.next_page.to_s << "/")
        else
          ""
        end
    end
  end
end
