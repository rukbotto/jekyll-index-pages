module JekyllIndexPages
  class Generator < Jekyll::Generator
    safe true

    Jekyll::Hooks.register :site, :after_init do |site|
      if I18n.backend.send(:translations).empty?
        I18n.backend.load_translations(
          Dir[File.join(site.in_source_dir(),"_locales/*.yml")]
        )
      end
      I18n.locale = site.config["lang"]
    end

    def generate(site)
      config = site.config["index_pages"] || {}
      config.each do |kind, item|
        permalink = item["permalink"] || "/:label/"
        per_page = item['per_page'] || 10
        layout = item["layout"] || "#{kind}"
        collection = item["collection"]

        next if !site.layouts.key? layout

        doc_group =
          case kind
          when "posts"
            { "posts" => site.posts.docs.reverse }
          when "categories"
            site.categories
          when "tags"
            site.tags
          when "archive"
            site.data["archive"]
          when "authors"
            site.data["authors"]
          else
            site.data["collectionz"] if collection
          end

        doc_group.each do |label, docs|
          pagination = Pagination.new(docs, per_page)

          (0...pagination.total).each do |current|
            pagination.paginate(current)

            pager = pagination.pager

            label_slug =
              I18n.transliterate(
                Jekyll::Utils.slugify(label),
                :locale => I18n.locale
              )
            dir =
              File.join(
                permalink.sub(":label", label_slug),
                (pager.current_page > 1) ? pager.current_page.to_s : ""
              )

            base =
              if site.in_theme_dir()
                site.in_theme_dir()
              else
                site.in_source_dir()
              end

            site.pages <<
              IndexPage.new(site, base, dir, item, label, layout, pager)
          end
        end
      end
    end
  end
end
