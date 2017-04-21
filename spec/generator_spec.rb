require "spec_helper"

describe JekyllIndexPages::Generator do
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
    describe "Generator.generate" do
      it "skips index page generation" do
        expect(site.pages.length).to eq(0)
      end
    end
  end

  context "When default configuration for post index pages is provided" do
    let(:overrides) do
      {
        "index_pages" => {
          "posts" => {}
        }
      }
    end

    describe "Generator.generate" do
      it "generates a single post index page" do
        expect(site.pages.length).to eq(1)
      end

      it "generates post index page with default title and excerpt" do
        expect(site.pages[0].data["title"]).to eq("posts")
        expect(site.pages[0].data["excerpt"]).to eq("posts")
      end

      it "generates a post index page at /posts/" do
        expect(site.pages[0].url).to eq("/posts/")
      end

      it "generates a post index page with six documents" do
        expect(site.pages[0].data["pager"]["docs"].length).to eq(6)
      end

      it "generates a post index page with recent documents first" do
        recent_doc = site.pages[0].data["pager"]["docs"][0]
        older_doc = site.pages[0].data["pager"]["docs"][1]
        expect(recent_doc.date).to be > older_doc.date
      end

      it "generates a post index page with a pager" do
        expect(site.pages[0].data["pager"]).to be_instance_of(Hash)
      end
    end
  end

  context "When custom title and excerpt for posts index page is provided" do
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

    describe "Generator.generate" do
      it "generates post index page with custom values" do
        expect(site.pages[0].data["title"]).to eq("Custom Title")
        expect(site.pages[0].data["excerpt"]).to eq("Custom excerpt")
      end
    end
  end

  context "When custom 'per page' setting for posts index page is provided" do
    let(:overrides) do
      {
        "index_pages" => {
          "posts" => {
            "per_page" => 2
          }
        }
      }
    end

    describe "Generator.generate" do
      context "generates the first post index page" do
        let(:page) { site.pages[0] }

        it "with two documents" do
          expect(page.data["pager"]["docs"].length).to eq(2)
        end

        it "and next page url only" do
          expect(page.data["pager"]["prev_page_url"]).to eq("")
          expect(page.data["pager"]["next_page_url"]).to eq("/posts/2/")
        end
      end

      context "generates the second post index page" do
        let(:page) { site.pages[1] }

        it "with previous and next page urls" do
          expect(page.data["pager"]["prev_page_url"]).to eq("/posts/")
          expect(page.data["pager"]["next_page_url"]).to eq("/posts/3/")
        end
      end

      context "generates the third post index page" do
        let(:page) { site.pages[2] }

        it "with previous page url only" do
          expect(page.data["pager"]["prev_page_url"]).to eq("/posts/2/")
          expect(page.data["pager"]["next_page_url"]).to eq("")
        end
      end
    end
  end

  context "When custom 'permalink' setting for posts index page is provided" do
    let(:overrides) do
      {
        "index_pages" => {
          "posts" => {
            "permalink" => "/custom-permalink/"
          }
        }
      }
    end

    describe "Generator.generate" do
      it "generates a post index page at /custom-permalink/" do
        expect(site.pages[0].url).to eq("/custom-permalink/")
      end
    end
  end

  context "When custom 'layout' setting for posts index page is provided" do
    let(:overrides) do
      {
        "index_pages" => {
          "posts" => {
            "layout" => "custom-layout"
          }
        }
      }
    end

    describe "Generator.generate" do
      it "generates a post index page using the custom layout" do
        expect(site.pages.length).to eq(1)
        expect(site.pages[0].content).to include("Custom Layout")
      end
    end
  end

  context "When default configuration for category index pages is provided" do
    let(:overrides) do
      {
        "index_pages" => {
          "categories" => {}
        }
      }
    end

    describe "Generator.generate" do
      it "generates two category index pages" do
        expect(site.pages.length).to eq(2)
      end

      it "generates a category index page at /science-fiction/" do
        expect(site.pages[0].url).to eq("/science-fiction/")
      end

      it "generates a category index page at /ciencia-ficcion/" do
        expect(site.pages[1].url).to eq("/ciencia-ficcion/")
      end
    end
  end

  context "When default configuration for tag index pages is provided" do
    let(:overrides) do
      {
        "index_pages" => {
          "tags" => {}
        }
      }
    end

    describe "Generator.generate" do
      it "generates three tag index pages" do
        expect(site.pages.length).to eq(3)
      end

      it "generates a tag index page at /star-trek/" do
        expect(site.pages[0].url).to eq("/star-trek/")
      end
    end
  end

  context "When default configuration for archive index pages is provided" do
    let(:overrides) do
      {
        "index_pages" => {
          "archive" => {}
        }
      }
    end

    describe "Generator.generate" do
      it "generates five archive index pages" do
        expect(site.pages.length).to eq(5)
      end

      it "generates the first archive index page at /1966/" do
        expect(site.pages[0].url).to eq("/1966/")
      end
    end
  end

  context "When default configuration for author index pages is provided" do
    let(:overrides) do
      {
        "index_pages" => {
          "authors" => {}
        }
      }
    end

    describe "Generator.generate" do
      it "generates five author index pages" do
        expect(site.pages.length).to eq(5)
      end

      it "generates the first author index page at /james-t-kirk/" do
        expect(site.pages[0].url).to eq("/james-t-kirk/")
      end
    end
  end

  context "When default configuration for collection index pages is provided" do
    let(:overrides) do
      {
        "collections" => ["starships"],
        "index_pages" => {
          "custom" => {
            "layout" => "custom-layout",
            "collection" => "starships"
          }
        }
      }
    end

    describe "Generator.generate" do
      it "generates a single collection index page" do
        expect(site.pages.length).to eq(1)
      end

      it "generates the first collection index page at /starships/" do
        expect(site.pages[0].url).to eq("/starships/")
      end
    end
  end
end
