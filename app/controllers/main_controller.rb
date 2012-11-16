class MainController < ApplicationController
  before_filter :get_page_size
  before_filter :get_page


  def index
    if params.has_key? :tag
        @comments, @tags, @comments_total = Comment.tagged_with(params[:tag], {
            delimiter: ',',
            as_param: true,
            get_tags: true,
            get_total: true,
            page: @page
        })
        @comments = CommentDecorator.decorate(@comments)
        redirect_to new_thread_path unless @comments.present?
    else
      @comments = Comment.limit(Theroot::Application.config.page_size).offset(@page).all
      @comments = CommentDecorator.decorate(@comments)
      @tags = []
    end

  end

  def home

  end

  def new

  end

  private

  def get_page
    @page = 0
    if params.has_key?(:page)
      if params[:page] == 'last'
        @page = :last
      else
        @page = params[:page].to_i - 1
        @page = 0 if @page < 0
      end
    end
  end

  def get_page_size
    @page_size = Theroot::Application.config.page_size
  end


end
