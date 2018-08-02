require "spec_helper"

describe JekyllIndexPages::IndexPage do
  let(:site_config) do
    Jekyll.configuration({
      "source" => File.expand_path("../fixtures/index-page", __FILE__),
      "destination" => File.expand_path("../dest", __FILE__)
    })
  end
  let(:site) { Jekyll::Site.new(site_config) }
  let(:base) { site.source }
  let(:dir) { "/posts/" }
  let(:label) { "posts" }
  let(:layout) { "default" }
  let(:pagination) do
    JekyllIndexPages::Pagination.new(site.posts.docs.reverse, 2)
  end
  let(:pager) { pagination.pager }
  let(:page) do
    JekyllIndexPages::IndexPage.new(
      site,
      base,
      dir,
      config,
      label,
      layout,
      pager
    )
  end

  before(:each) do
    site.process
  end

  context "When no configuration is provided" do
    let(:config) { {} }

    describe "IndexPage.initialize" do
      context "creates the first index page" do
        let(:pager) do
          pagination.paginate(0)
          pagination.pager
        end

        it "with default title and excerpt" do
          expect(page.data["title"]).to eq("posts")
          expect(page.data["excerpt"]).to eq("posts")
        end

        it "with no additional data" do
          expect(page.data.length).to eq(3)
        end

        it "listing the first two posts" do
          expect(page.data["pager"]["docs"].length).to eq(2)
        end

        it "containing pagination data" do
          expect(page.data["pager"]["total_pages"]).to eq(3)
          expect(page.data["pager"]["current_page"]).to eq(1)
          expect(page.data["pager"]["prev_page"]).to eq(0)
          expect(page.data["pager"]["next_page"]).to eq(2)
        end

        it "and url for next page only" do
          expect(page.data["pager"]["prev_page_url"]).to eq("")
          expect(page.data["pager"]["next_page_url"]).to eq("/posts/2/")
        end
      end

      context "creates the second index page" do
        let(:dir) { "/posts/2" }
        let(:pager) do
          pagination.paginate(1)
          pagination.pager
        end

        it "containing urls for previous and next pages" do
          expect(page.data["pager"]["prev_page_url"]).to eq("/posts/")
          expect(page.data["pager"]["next_page_url"]).to eq("/posts/3/")
        end
      end

      context "creates the third index page" do
        let(:dir) { "/posts/3" }
        let(:pager) do
          pagination.paginate(2)
          pagination.pager
        end

        it "containing url for prev page only" do
          expect(page.data["pager"]["prev_page_url"]).to eq("/posts/2/")
          expect(page.data["pager"]["next_page_url"]).to eq("")
        end
      end
    end
  end

  context "When configuration is provided" do
    let(:config) do
      {
        "title" => "Star Trek Index",
        "excerpt" => "Star Trek Index",
        "data" => {
          "description" => "This is the Star Trek Index"
        }
      }
    end

    describe "IndexPage.initialize" do
      it "creates the first index page with the specified title, excerpt and data items" do
        expect(page.data["title"]).to eq("Star Trek Index")
        expect(page.data["excerpt"]).to eq("Star Trek Index")
        expect(page.data["description"]).to eq("This is the Star Trek Index")
      end
    end
  end

  context "When custom data is not provided as a Hash" do
    let(:config) do
      {
        "title" => "Star Trek Index",
        "excerpt" => "Star Trek Index",
        "data" => ["This is custom data item"]
      }
    end

    describe "IndexPage.initialize" do
      it "will not add any custom data to index page" do
        expect(page.data.length).to eq(3)
      end
    end
  end

  context "When custom data tries to override the page's original data" do
    let(:config) do
      {
        "title" => "Star Trek Index",
        "excerpt" => "Star Trek Index",
        "data" => {
          "title" => "This is another title",
          "excerpt" => "This is another excerpt",
          "pager" => nil
        }
      }
    end

    describe "IndexPage.initialize" do
      it "will preserve the original data" do
        expect(page.data["title"]).to eq("Star Trek Index")
        expect(page.data["excerpt"]).to eq("Star Trek Index")
        expect(page.data["pager"]).to be_instance_of(Hash)
      end
    end
  end
end
