require "spec_helper"

describe JekyllIndexPages::TagURL do
  let(:overrides) { Hash.new }
  let(:site_config) do
    Jekyll.configuration(Jekyll::Utils.deep_merge_hashes({
      "source" => File.expand_path("../fixtures/index-page", __FILE__),
      "destination" => File.expand_path("../dest", __FILE__)
    }, overrides))
  end
  let(:site) { Jekyll::Site.new(site_config) }
  let(:payload) { site.site_payload }
  let(:info) do
    {
      :registers => { :site => site, :page => payload["page"] }
    }
  end

  before(:each) do
    site.process
  end

  context "When no text is provided" do
    let(:template) { Liquid::Template.parse("{% tag_url %}") }

    describe "TagURL.render" do
      it "returns an empty string" do
        expect(template.render(payload, info)).to eq("")
      end
    end
  end

  context "When a valid tag name is provided" do
    let(:template) do
      Liquid::Template.parse("{% tag_url ciencia-ficción %}")
    end

    describe "TagURL.render" do
      it "returns a valid tag page URL" do
        expect(template.render(payload, info)).to eq("/ciencia-ficcion/")
      end
    end

    context "and a custom tag permalink is provided" do
      let(:overrides) do
        {
          "index_pages" => {
            "tags" => {
              "permalink" => "/custom/:label/"
            }
          }
        }
      end

      describe "TagURL.render" do
        it "returns a valid tag page URL" do
          expect(template.render(payload, info)).to eq("/custom/ciencia-ficcion/")
        end
      end
    end
  end
end
