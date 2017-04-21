require "spec_helper"

describe JekyllIndexPages::AuthorURL do
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
    let(:template) { Liquid::Template.parse("{% author_url %}") }

    describe "AuthorURL.render" do
      it "raises ArgumentError" do
        expect { template.render!(payload, info) }.to raise_error(ArgumentError)
      end
    end
  end

  context "When a valid author name is provided" do
    let(:template) do
      Liquid::Template.parse("{% author_url \"James T Kirk\" %}")
    end

    describe "AuthorURL.render" do
      it "returns a valid author page URL" do
        expect(template.render!(payload, info)).to eq("/james-t-kirk/")
      end
    end

    context "and a custom author permalink is provided" do
      let(:overrides) do
        {
          "index_pages" => {
            "authors" => {
              "permalink" => "/custom/:label/"
            }
          }
        }
      end

      describe "AuthorURL.render" do
        it "returns a valid author page URL" do
          expect(template.render!(payload, info)).to eq("/custom/james-t-kirk/")
        end
      end
    end
  end

  context "When valid author names are provided as a variable" do
    let(:template) do
      Liquid::Template.parse <<-eos
{% for author in site.data.authors %}
{% author_url author[0] %}
{% endfor %}
eos
    end

    describe "AuthorURL.render" do
      it "returns valid author page URLs" do
        expect(template.render!(payload, info)).to eq <<-eos

/james-t-kirk/

/jean-luc-picard/

/benjamin-sisko/

/kathryn-janeway/

/jonathan-archer/

eos
      end
    end

    context "and a custom author permalink is provided" do
      let(:overrides) do
        {
          "index_pages" => {
            "authors" => {
              "permalink" => "/custom/:label/"
            }
          }
        }
      end

      describe "AuthorURL.render" do
        it "returns valid author page URLs" do
          expect(template.render!(payload, info)).to eq <<-eos

/custom/james-t-kirk/

/custom/jean-luc-picard/

/custom/benjamin-sisko/

/custom/kathryn-janeway/

/custom/jonathan-archer/

eos
        end
      end
    end
  end
end
