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

      it "generates a post index page with a pager" do
        expect(site.pages[0].data["pager"]).to be_instance_of(Hash)
      end

      it "generates a post index page with six documents" do
        expect(site.pages[0].data["pager"]["docs"].length).to eq(6)
      end

      it "generates a post index page with recent documents first" do
        first = site.pages[0].data["pager"]["docs"][0]
        expect(first.date).to eq(Time.new(2001, 9, 26))

        second = site.pages[0].data["pager"]["docs"][1]
        expect(second.date).to eq(Time.new(1995, 1, 16))

        third = site.pages[0].data["pager"]["docs"][2]
        expect(third.date).to eq(Time.new(1993, 1, 03))

        fourth = site.pages[0].data["pager"]["docs"][3]
        expect(fourth.date).to eq(Time.new(1987, 9, 28))

        fifth = site.pages[0].data["pager"]["docs"][4]
        expect(fifth.date).to eq(Time.new(1966, 9, 8))

        sixth = site.pages[0].data["pager"]["docs"][5]
        expect(sixth.date).to eq(Time.new(1966, 9, 8))
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

        it "sorted by date, recent first" do
          first = page.data["pager"]["docs"][0]
          expect(first.date).to eq(Time.new(2001, 9, 26))

          second = page.data["pager"]["docs"][1]
          expect(second.date).to eq(Time.new(1995, 1, 16))
        end

        it "and next page url only" do
          expect(page.data["pager"]["prev_page_url"]).to eq("")
          expect(page.data["pager"]["next_page_url"]).to eq("/posts/2/")
        end
      end

      context "generates the second post index page" do
        let(:page) { site.pages[1] }

        it "with two documents" do
          expect(page.data["pager"]["docs"].length).to eq(2)
        end

        it "sorted by date, recent first" do
          first = page.data["pager"]["docs"][0]
          expect(first.date).to eq(Time.new(1993, 1, 03))

          second = page.data["pager"]["docs"][1]
          expect(second.date).to eq(Time.new(1987, 9, 28))
        end

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

  context "When a custom layout is provided in posts index page configuration" do
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
        expect(site.pages[0].output).to include("Custom Layout")
      end
    end
  end

  context "When a liquid file is provided as a layout in posts index page configuration" do
    let(:overrides) do
      {
        "index_pages" => {
          "posts" => {
            "layout" => "liquid-layout"
          }
        }
      }
    end

    describe "Generator.generate" do
      it "generates a post index page using the liquid layout" do
        expect(site.pages.length).to eq(1)
        expect(site.pages[0].output).to include("This is a liquid layout")
      end
    end
  end

  context "When custom data is provided in the configuration for posts index page" do
    let(:overrides) do
      {
        "index_pages" => {
          "posts" => {
            "layout" => "data-layout",
            "data" => {
              "custom" => "This is a custom data item"
            }
          }
        }
      }
    end

    describe "Generator.generate" do
      it "generates an index page containing the custom data items" do
        expect(site.pages.length).to eq(1)
        expect(site.pages[0].data["custom"]).to eq("This is a custom data item")
        expect(site.pages[0].output).to include("This is a custom data item")
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

      it "generates a post index page with four documents" do
        expect(site.pages[0].data["pager"]["docs"].length).to eq(4)
      end

      it "generates a post index page with recent documents first" do
        first = site.pages[0].data["pager"]["docs"][0]
        expect(first.date).to eq(Time.new(2371, 1, 1))

        second = site.pages[0].data["pager"]["docs"][1]
        expect(second.date).to eq(Time.new(2363, 1, 1))

        third = site.pages[0].data["pager"]["docs"][2]
        expect(third.date).to eq(Time.new(2351, 1, 1))

        fourth = site.pages[0].data["pager"]["docs"][3]
        expect(fourth.date).to eq(Time.new(2245, 1, 1))
      end
    end
  end

  context "When custom 'per page' setting for collection index pages is provided" do
    let(:overrides) do
      {
        "collections" => ["starships"],
        "index_pages" => {
          "custom" => {
            "per_page" => 2,
            "layout" => "custom-layout",
            "collection" => "starships"
          }
        }
      }
    end

    describe "Generator.generate" do
      context "generates the first index page for collection" do
        let(:page) { site.pages[0] }

        it "with two documents" do
          expect(page.data["pager"]["docs"].length).to eq(2)
        end

        it "sorted by date, recent first" do
          first = page.data["pager"]["docs"][0]
          expect(first.date).to eq(Time.new(2371, 1, 1))

          second = page.data["pager"]["docs"][1]
          expect(second.date).to eq(Time.new(2363, 1, 1))
        end

        it "and next page url only" do
          expect(page.data["pager"]["prev_page_url"]).to eq("")
          expect(page.data["pager"]["next_page_url"]).to eq("/starships/2/")
        end
      end

      context "generates the second index page for collection" do
        let(:page) { site.pages[1] }

        it "with two documents" do
          expect(page.data["pager"]["docs"].length).to eq(2)
        end

        it "sorted by date, recent first" do
          first = page.data["pager"]["docs"][0]
          expect(first.date).to eq(Time.new(2351, 1, 1))

          second = page.data["pager"]["docs"][1]
          expect(second.date).to eq(Time.new(2245, 1, 1))
        end

        it "and previous page url only" do
          expect(page.data["pager"]["prev_page_url"]).to eq("/starships/")
          expect(page.data["pager"]["next_page_url"]).to eq("")
        end
      end
    end
  end

  context "When two collections are provided in the configuration" do
    let(:overrides) do
      {
        "collections" => ["starships", "cast"],
        "index_pages" => {
          "starship" => {
            "layout" => "custom-layout",
            "collection" => "starships"
          },
          "cast" => {
            "layout" => "custom-layout",
            "collection" => "cast"
          }
        }
      }
    end

    describe "Generator.generate" do
      it "generates an index page for each collection" do
        expect(site.pages.length).to eq(2)
      end

      context "generates the index page for the first collection" do
        let(:page) { site.pages[0] }

        it "at /starships/" do
          expect(page.url).to eq("/starships/")
        end

        it "and having four documents" do
          expect(page.data["pager"]["docs"].length).to eq(4)
        end
      end

      context "generates the index page for the second collection" do
        let(:page) { site.pages[1] }

        it "at /cast/" do
          expect(page.url).to eq("/cast/")
        end

        it "and having two documents" do
          expect(page.data["pager"]["docs"].length).to eq(2)
        end
      end
    end
  end
end
