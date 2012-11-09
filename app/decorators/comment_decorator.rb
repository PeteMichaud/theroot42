class CommentDecorator < Draper::Base
  decorates :comment
  decorates_association :user
  decorates_association :votes

  def poster_name
    model.user.name
  end

  def poster_location
    model.user.location
  end

  def render_tag_list
    list = comment.tags
    list.shift if h.params[:tag] == list.first.param_name
    list.map { |t| h.link_to t.name, h.t_path(t.param_name) }.join(', ').html_safe
  end

end
