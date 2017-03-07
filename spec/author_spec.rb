require "spec_helper"

describe(JekyllIndexPages::Author) do
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
    describe("Author.generate") do
      it("skips author index page generation") do
        expect(site.data["author"]).to be_nil
      end
    end
  end

  context("When default configuration is provided") do
    let(:overrides) do
      {
        "index_pages" => {
          "authors" => {}
        }
      }
    end

    describe("Author.generate") do
      it("generates five author index pages") do
        expect(site.data["authors"].length).to eq(5)
      end

      it("each page containing only one post") do
        expect(site.data["authors"]["James T Kirk"].length).to eq(1)
        expect(site.data["authors"]["Jean-Luc Picard"].length).to eq(1)
        expect(site.data["authors"]["Benjamin Sisko"].length).to eq(1)
        expect(site.data["authors"]["Kathryn Janeway"].length).to eq(1)
        expect(site.data["authors"]["Jonathan Archer"].length).to eq(1)
      end
    end
  end
end
