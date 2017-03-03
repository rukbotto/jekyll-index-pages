module JekyllIndexPages
  class Archive < Jekyll::Generator
    priority :high

    def generate(site)
      config = site.config["index_pages"] || {}
      return if !config.key?("archive")

      archive = Hash.new { |hash, key| hash[key] = [] }
      site.posts.docs.each { |doc| archive[doc.date.strftime("%Y")] << doc }
      site.data["archive"] = archive
    end
  end
end
