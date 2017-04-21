require "spec_helper"

describe JekyllIndexPages::Archive do
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

  describe "Archive.generate" do
    it "generates a five year post archive" do
      expect(site.data["archive"].length).to eq(5)
    end

    it "generates a post listing page per year" do
      expect(site.data["archive"]["1966"].length).to be > 0
      expect(site.data["archive"]["1987"].length).to be > 0
      expect(site.data["archive"]["1993"].length).to be > 0
      expect(site.data["archive"]["1995"].length).to be > 0
      expect(site.data["archive"]["2001"].length).to be > 0
    end
  end
end
