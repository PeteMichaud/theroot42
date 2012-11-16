module MainHelper

  def next_page_link path, total
    if @page != :last && total > (@page + 1) * @page_size
      content_tag :a, href: "#{path}/#{@page + 2}", class: 'next_page', data: {page: @page+2} do
        "Next Page (#{@page+2})"
      end
    end
  end

  def prev_page_link path, total
    if @page == :last
      if @page_size > total
        @page = 0
      else
        @page = (total.to_f / @page_size).ceil
      end
    end
    if @page > 0
      content_tag :a, href: "#{path}/#{@page}", class: 'prev_page', data: {page: @page} do
        "Previous Page (#{@page})"
      end
    end
  end


end
