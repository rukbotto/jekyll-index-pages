module JekyllIndexPages
  class Collection < Jekyll::Generator
    priority :high

    def generate(site)
      config = site.config["index_pages"] || {}
      config.each do |kind, item|
        case kind
        when "posts", "categories", "tags", "archive", "authors"
          next
        end
        next if !item.has_key?("collection")

        coll_name = item["collection"]
        collections = Hash.new { |hash, key| hash[key] = [] }
        _, collection = site.collections.detect do |key, value|
          key == coll_name
        end
        collection.docs.each { |doc| collections[coll_name] << doc }
        site.data["collectionz"] = collections
      end
    end
  end
end
