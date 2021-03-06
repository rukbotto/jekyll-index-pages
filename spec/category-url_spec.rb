require "spec_helper"

describe JekyllIndexPages::CategoryURL do
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
    let(:template) { Liquid::Template.parse("{% category_url %}") }

    describe "CategoryURL.render" do
      it "raises ArgumentError" do
        expect { template.render!(payload, info) }.to raise_error(ArgumentError)
      end
    end
  end

  context "When a valid category name is provided" do
    let(:template) do
      Liquid::Template.parse("{% category_url \"Ciencia ficción\" %}")
    end

    describe "CategoryURL.render" do
      it "returns a valid category page URL" do
        expect(template.render!(payload, info)).to eq("/ciencia-ficcion/")
      end
    end

    context "and a custom category permalink is provided" do
      let(:overrides) do
        {
          "index_pages" => {
            "categories" => {
              "permalink" => "/custom/:label/"
            }
          }
        }
      end

      describe "CategoryURL.render" do
        it "returns a valid category page URL" do
          expect(template.render!(payload, info)).to eq("/custom/ciencia-ficcion/")
        end
      end
    end
  end

  context "When valid category names are provided as a variable" do
    let(:template) do
      Liquid::Template.parse <<-eos
{% for category in site.categories %}
{% category_url category[0] %}
{% endfor %}
eos
    end

    describe "CategoryURL.render" do
      it "returns valid category page URLs" do
        expect(template.render!(payload, info)).to eq <<-eos

/science-fiction/

/ciencia-ficcion/

eos
      end
    end

    context "and a custom category permalink is provided" do
      let(:overrides) do
        {
          "index_pages" => {
            "categories" => {
              "permalink" => "/custom/:label/"
            }
          }
        }
      end

      describe "CategoryURL.render" do
        it "returns valid category page URLs" do
          expect(template.render!(payload, info)).to eq <<-eos

/custom/science-fiction/

/custom/ciencia-ficcion/

eos
        end
      end
    end
  end
end
