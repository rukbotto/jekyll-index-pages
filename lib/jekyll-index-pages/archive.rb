module JekyllIndexPages
  class Archive < Jekyll::Generator
    priority :high

    def generate(site)
      archive = Hash.new { |hash, key| hash[key] = [] }
      site.posts.docs.each { |doc| archive[doc.date.strftime("%Y")] << doc }
      site.data["archive"] = archive
    end
  end
end
