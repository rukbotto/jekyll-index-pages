require "spec_helper"

describe(JekyllIndexPages::IndexPage) do
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
  let(:pager) do
    pagination = JekyllIndexPages::Pagination.new(site.posts.docs.reverse, 2)
    pagination.paginate(0)
    pagination.pager
  end

  before(:each) do
    site.process
  end

  context("When no configuration is provided") do
    let(:config) { {} }
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
    let(:docs) { page.data["docs"] }

    describe("IndexPage.initialize") do
      describe("creates the first index page") do
        it("with default values") do
          expect(page.data["title"]).to eq("posts")
          expect(page.data["excerpt"]).to eq("posts")
        end

        it("listing the first two posts") do
          expect(docs.length).to eq(2)
        end

        it("with a pager") do
          expect(page.data["pager"]).to be_instance_of(Hash)
        end
      end
    end
  end

  context("When configuration is provided") do
    let(:config) do
      {
        "title" => "Star Trek Index",
        "excerpt" => "Star Trek Index"
      }
    end
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
    let(:docs) { page.data["docs"] }

    describe("IndexPage.initialize") do
      it("creates the first index page with custom values") do
        expect(page.data["title"]).to eq("Star Trek Index")
        expect(page.data["excerpt"]).to eq("Star Trek Index")
      end
    end
  end
end
