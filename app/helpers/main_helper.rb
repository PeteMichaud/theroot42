module MainHelper

  def next_page_link
    if @page != 'last' && @comments_total > (@page + 1) * @page_size
      content_tag :a, href: t_path(params[:tag], @page+2), class: 'next_page' do
        "Page #{@page+2}"
      end
    end
  end

end
