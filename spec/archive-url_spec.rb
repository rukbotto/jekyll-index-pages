require "spec_helper"

describe JekyllIndexPages::ArchiveURL do
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
    let(:template) { Liquid::Template.parse("{% archive_url %}") }

    describe "ArchiveURL.render" do
      it "raises ArgumentError" do
        expect { template.render!(payload, info) }.to raise_error(ArgumentError)
      end
    end
  end

  context "When a valid year is provided" do
    let(:template) do
      Liquid::Template.parse("{% archive_url \"1966\" %}")
    end

    describe "ArchiveURL.render" do
      it "returns a valid archive page URL" do
        expect(template.render!(payload, info)).to eq("/1966/")
      end
    end

    context "and a custom archive permalink is provided" do
      let(:overrides) do
        {
          "index_pages" => {
            "archive" => {
              "permalink" => "/custom/:label/"
            }
          }
        }
      end

      describe "ArchiveURL.render" do
        it "returns a valid archive page URL" do
          expect(template.render!(payload, info)).to eq("/custom/1966/")
        end
      end
    end
  end

  context "When a valid year is provided as a variable" do
    let(:template) do
      Liquid::Template.parse <<-eos
{% assign year = "1966" %}
{% archive_url year %}
eos
    end

    describe "ArchiveURL.render" do
      it "returns a valid archive page URL" do
        expect(template.render!(payload, info)).to eq("\n/1966/\n")
      end
    end

    context "and a custom author permalink is provided" do
      let(:overrides) do
        {
          "index_pages" => {
            "archive" => {
              "permalink" => "/custom/:label/"
            }
          }
        }
      end

      describe "ArchiveURL.render" do
        it "returns a valid archive page URL" do
          expect(template.render!(payload, info)).to eq("\n/custom/1966/\n")
        end
      end
    end
  end
end
