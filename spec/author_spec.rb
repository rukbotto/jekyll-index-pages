require "spec_helper"

describe JekyllIndexPages::Author do
  let(:overrides) { Hash.new }
  let(:site_config) do
    Jekyll.configuration(Jekyll::Utils.deep_merge_hashes({
      "source" => File.expand_path("../fixtures/index-page", __FILE__),
      "destination" => File.expand_path("../dest", __FILE__)
    }, overrides))
  end
  let(:site) { Jekyll::Site.new(site_config) }

  before(:each) do
    site.process
  end

  describe "Author.generate" do
    it "generates five author index pages" do
      expect(site.data["authors"].length).to eq(5)
    end

    it "generates a post listing page per author" do
      expect(site.data["authors"]["James T Kirk"].length).to be > 0
      expect(site.data["authors"]["Jean-Luc Picard"].length).to be > 0
      expect(site.data["authors"]["Benjamin Sisko"].length).to be > 0
      expect(site.data["authors"]["Kathryn Janeway"].length).to be > 0
      expect(site.data["authors"]["Jonathan Archer"].length).to be > 0
    end
  end
end
