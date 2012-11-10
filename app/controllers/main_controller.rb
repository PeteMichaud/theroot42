class MainController < ApplicationController
  #before_filter :get_tag_list

  def index
    if params.has_key? :tag
        @comments, @tags = Comment.tagged_with(params[:tag], {delimiter: ',', as_param: true, get_tags: true})
        @comments = CommentDecorator.decorate(@comments)
        redirect_to new_thread_path unless @comments.present?
    else
      @comments = CommentDecorator.all.limit(40)
    end

  end

  def home

  end

  def new

  end

  private

  def get_tag_list
    @tag_list = []
    @tag_list = TagList.from params[:tag] if params.has_key? :tag
  end

end
