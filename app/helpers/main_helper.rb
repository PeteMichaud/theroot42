module MainHelper

  def next_page_link
    if @page != :last && @comments_total > (@page + 1) * @page_size
      content_tag :a, href: t_path(params[:tag], @page+2), class: 'next_page', data: {page: @page+2} do
        "Next Page (#{@page+2})"
      end
    end
  end

  def prev_page_link
    if @page == :last
      if @page_size > @comments_total
        @page = 0
      else
        @page = (@comments_total.to_f / @page_size).ceil
      end
    end
    if @page > 0
      content_tag :a, href: t_path(params[:tag], @page), class: 'prev_page', data: {page: @page} do
        "Previous Page (#{@page})"
      end
    end
  end

end
