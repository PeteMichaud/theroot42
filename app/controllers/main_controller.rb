class MainController < ApplicationController
  #before_filter :get_tag_list

  def index
    if params.has_key? :tag
      @comments = CommentDecorator.decorate(Comment.tagged_with(params[:tag]))
    else
      @comments = CommentDecorator.all
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
