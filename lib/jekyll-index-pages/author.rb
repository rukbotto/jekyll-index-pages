module JekyllIndexPages
  class Author < Jekyll::Generator
    priority :high

    def generate(site)
      authors = Hash.new { |hash, key| hash[key] = [] }
      site.posts.docs.each { |doc| authors[doc.data["author"]] << doc }
      site.data["authors"] = authors
    end
  end
end

