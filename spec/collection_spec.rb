require "spec_helper"

describe JekyllIndexPages::Collection do
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

  context "When no configuration is provided" do
    describe "Collection.generate" do
      it "skips collection index pages generation" do
        expect(site.data["collectionz"]).to be_nil
      end
    end
  end

  context "When default configuration is provided" do
    let(:overrides) do
      {
        "collections" => ["starships"],
        "index_pages" => {
          "custom" => {
            "collection" => "starships"
          }
        }
      }
    end

    describe "Collection.generate" do
      it "generates a single index page for collection" do
        expect(site.data["collectionz"].length).to eq(1)
      end

      it "containing four documents" do
        expect(site.data["collectionz"]["starships"].length).to eq(4)
      end
    end
  end

  context "When two collections are provided in the configuration" do
    let(:overrides) do
      {
        "collections" => ["starships", "cast"],
        "index_pages" => {
          "starship" => {
            "collection" => "starships"
          },
          "cast" => {
            "collection" => "cast"
          }
        }
      }
    end

    describe "Collection.generate" do
      it "generates an index page for each collection" do
        expect(site.data["collectionz"].length).to eq(2)
      end

      it "the first having four documents" do
        expect(site.data["collectionz"]["starships"].length).to eq(4)
      end

      it "the second having two documents" do
        expect(site.data["collectionz"]["cast"].length).to eq(2)
      end
    end
  end
end
