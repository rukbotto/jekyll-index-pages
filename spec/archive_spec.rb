require "spec_helper"

describe(JekyllIndexPages::Archive) do
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

  context("When no configuration is provided") do
    describe("Archive.generate") do
      it("skips archive generation") do
        expect(site.data["archive"]).to be_nil
      end
    end
  end

  context("When default configuration for archive index pages is provided") do
    let(:overrides) do
      {
        "index_pages" => {
          "archive" => {}
        }
      }
    end

    describe("Archive.generate") do
      it("generates a five year post archive") do
        expect(site.data["archive"].length).to eq(5)
      end

      it("each year containing only one post") do
        expect(site.data["archive"]["1966"].length).to eq(1)
        expect(site.data["archive"]["1987"].length).to eq(1)
        expect(site.data["archive"]["1993"].length).to eq(1)
        expect(site.data["archive"]["1995"].length).to eq(1)
        expect(site.data["archive"]["2001"].length).to eq(1)
      end
    end
  end
end
