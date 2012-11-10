class MainController < ApplicationController
  #before_filter :get_tag_list

  def index
    if params.has_key? :tag
      tag = Tag.find_by_param_name(params[:tag])
      if tag.present?
        @comments = CommentDecorator.decorate(Comment.tagged_with(tag))
      else
        redirect_to new_thread_path
      end
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
