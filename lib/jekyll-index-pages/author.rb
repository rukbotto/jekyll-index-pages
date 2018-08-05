module JekyllIndexPages
  class Author < Jekyll::Generator
    priority :high

    def generate(site)
      authors = Hash.new { |hash, key| hash[key] = [] }
      authored_docs = site.posts.docs.select { |doc| doc.data.key?("author") }
      authored_docs.each { |doc| authors[doc.data["author"]] << doc }
      site.data["authors"] = authors
    end
  end
end

