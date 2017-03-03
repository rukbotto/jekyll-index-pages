module JekyllIndexPages
  class Author < Jekyll::Generator
    priority :high

    def generate(site)
      config = site.config["index_pages"] || {}
      return if !config.key?("authors")

      authors = Hash.new { |hash, key| authors[key] = [] }
      site.posts.docs.each { |doc| authors[doc.data["author"]] << doc }
      site.data["authors"] = authors
    end
  end
end

