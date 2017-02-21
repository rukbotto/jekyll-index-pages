require "spec_helper"

describe(IndexPages::IndexPageGenerator) do
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
    describe("IndexPageGenerator.generate") do
      it("skips index page generation") do
        expect(site.pages.length).to eq(0)
      end
    end
  end

  context("When default configuration for post index pages is provided") do
    let(:overrides) do
      {
        "index_pages" => {
          "posts" => {}
        }
      }
    end

    describe("IndexPageGenerator.generate") do
      it("generates a single post index page") do
        expect(site.pages.length).to eq(1)
      end

      it("generates post index page with default title and excerpt") do
        expect(site.pages[0].data["title"]).to eq("posts")
        expect(site.pages[0].data["excerpt"]).to eq("posts")
      end

      it("generates a post index page at /posts/") do
        expect(site.pages[0].url).to eq("/posts/")
      end

      it("generates a post index page with five documents") do
        expect(site.pages[0].data["docs"].length).to eq(5)
      end

      it("generates a post index page with recent documents first") do
        recent_doc = site.pages[0].data["docs"][0]
        older_doc = site.pages[0].data["docs"][1]
        expect(recent_doc.date).to be > older_doc.date
      end

      it("generates a post index page with a pager") do
        expect(site.pages[0].data["pager"]).to be_instance_of(Hash)
      end
    end
  end

  context("When custom title and excerpt for posts index page is provided") do
    let(:overrides) do
      {
        "index_pages" => {
          "posts" => {
            "title" => "Custom Title",
            "excerpt" => "Custom excerpt"
          }
        }
      }
    end

    describe("IndexPageGenerator.generate") do
      it("generates post index page with custom values") do
        expect(site.pages[0].data["title"]).to eq("Custom Title")
        expect(site.pages[0].data["excerpt"]).to eq("Custom excerpt")
      end
    end
  end

  context("When custom 'per page' setting for posts index page is provided") do
    let(:overrides) do
      {
        "index_pages" => {
          "posts" => {
            "per_page" => 2
          }
        }
      }
    end

    describe("IndexPageGenerator.generate") do
      it("generates a post index page with two documents") do
        expect(site.pages[0].data["docs"].length).to eq(2)
      end

      it("generates three post index pages") do
        expect(site.pages[0].data["pager"]["total_pages"]).to eq("3")
      end
    end
  end

  context("When custom 'permalink' setting for posts index page is provided") do
    let(:overrides) do
      {
        "index_pages" => {
          "posts" => {
            "permalink" => "/custom-permalink/"
          }
        }
      }
    end

    describe("IndexPageGenerator.generate") do
      it("generates a post index page at /custom-permalink/") do
        expect(site.pages[0].url).to eq("/custom-permalink/")
      end
    end
  end

  context("When custom 'layout' setting for posts index page is provided") do
    let(:overrides) do
      {
        "index_pages" => {
          "posts" => {
            "layout" => "custom-layout"
          }
        }
      }
    end

    describe("IndexPageGenerator.generate") do
      it("generates a post index page using the custom layout") do
        expect(site.pages.length).to eq(1)
        expect(site.pages[0].content).to include("Custom Layout")
      end
    end
  end

  context("When default settings for category index pages is provided") do
    let(:overrides) do
      {
        "index_pages" => {
          "categories" => {}
        }
      }
    end

    describe("IndexPageGenerator.generate") do
      it("generates a single category index page") do
        expect(site.pages.length).to eq(1)
      end

      it("generates a category index page at /science-fiction/") do
        expect(site.pages[0].url).to eq("/science-fiction/")
      end
    end
  end

  context("When default settings for tag index pages is provided") do
    let(:overrides) do
      {
        "index_pages" => {
          "tags" => {}
        }
      }
    end

    describe("IndexPageGenerator.generate") do
      it("generates a single tag index page") do
        expect(site.pages.length).to eq(1)
      end

      it("generates a tag index page at /star-trek/") do
        expect(site.pages[0].url).to eq("/star-trek/")
      end
    end
  end
end
