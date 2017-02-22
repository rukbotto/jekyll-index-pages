require "spec_helper"

describe(JekyllIndexPages::Pagination) do
  context "When no documents and no results per page are provided" do
    let(:pagination) { JekyllIndexPages::Pagination.new([], 0) }
    let(:pager) { pagination.pager }

    describe "Pagination.initialize" do
      it "creates an empty pagination object" do
        expect(pagination.total).to eq(0)
      end
    end
  end

  context "When two documents and one result per page are provided" do
    let(:pagination) { JekyllIndexPages::Pagination.new([true, true], 1) }
    let(:pager) { pagination.pager }

    before(:each) do
      pagination.paginate(0)
    end

    describe "Pagination.initialize" do
      it "creates a pagination object with two documents" do
        expect(pagination.total).to eq(2)
      end
    end

    describe "Pagination.paginate" do
      it "creates a pager object with two pages, one document each" do
        expect(pager.docs.length).to eq(1)
        expect(pager.total_pages).to eq(2)
        expect(pager.current_page).to eq(1)
        expect(pager.prev_page).to eq(0)
        expect(pager.next_page).to eq(2)
      end
    end
  end

  context "When two documents and two result per page are provided" do
    let(:pagination) { JekyllIndexPages::Pagination.new([true, true], 2) }
    let(:pager) { pagination.pager }

    before(:each) do
      pagination.paginate(0)
    end

    describe "Pagination.paginate" do
      it "creates a pager object with a single two document page" do
        expect(pager.docs.length).to eq(2)
        expect(pager.total_pages).to eq(1)
        expect(pager.current_page).to eq(1)
        expect(pager.prev_page).to eq(0)
        expect(pager.next_page).to eq(0)
      end
    end
  end
end
