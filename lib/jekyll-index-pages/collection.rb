module JekyllIndexPages
  class Collection < Jekyll::Generator
    priority :high

    def generate(site)
      collections = Hash.new { |hash, key| hash[key] = [] }
      config = site.config["index_pages"] || {}
      config.each do |kind, item|
        next if kind.match(/posts|categories|tags|archive|authors/)
        next if !item.has_key?("collection")
        coll_name = item["collection"]
        collection = site.collections[coll_name]
        collection.docs.each { |doc| collections[coll_name] << doc }
      end
      site.data["collectionz"] = collections if config.length > 0
    end
  end
end
