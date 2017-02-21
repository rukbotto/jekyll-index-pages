module JekyllIndexPages
  class Pagination
    Pager = Struct.new(
      :docs,
      :total_pages,
      :current_page,
      :prev_page,
      :next_page
    )

    attr_reader :total, :pager

    def initialize(docs, per_page)
      @docs = docs
      @per_page = per_page
      @total = per_page > 0 ? (docs.length.to_f / per_page).ceil : 0
      @pager = Pager.new([], @total.to_s, "0", "0", "0")
    end

    def paginate(current)
      first = @per_page * current
      last = first + @per_page

      @pager.docs = @docs[first...last]
      @pager.current_page = (current + 1).to_s
      @pager.prev_page = (current > 0) ? current.to_s : ""
      @pager.next_page = (current < total - 1) ? (current + 2).to_s : ""
    end
  end
end
