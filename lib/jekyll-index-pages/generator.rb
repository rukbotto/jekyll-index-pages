module JekyllIndexPages
  class Generator < Jekyll::Generator
    safe true

    def generate(site)
      config = site.config["index_pages"] || {}
      config.each do |kind, item|
        permalink = item["permalink"] || "/:label/"
        per_page = item['per_page'] || 10
        layout = item["layout"] || "#{kind}"

        next if !site.layouts.key? layout

        doc_group =
          case kind
          when "posts"
            { "posts" => site.posts.docs.reverse }
          when "categories"
            site.categories
          when "tags"
            site.tags
          else
            {}
          end

        doc_group.each do |label, docs|
          pagination = Pagination.new(docs, per_page)

          (0...pagination.total).each do |current|
            pagination.paginate(current)

            dir =
              File.join(
                permalink.sub(":label", Jekyll::Utils.slugify(label)),
                (current > 0) ? pagination.pager.current_page : ""
              )

            site.pages <<
              IndexPage.new(
                site,
                site.source,
                dir,
                item,
                label,
                layout,
                pagination.pager
              )
          end
        end
      end
    end
  end
end