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
    list = comment.tag_list
    list.shift if h.params[:tag] == list.first
    list.map { |t| h.link_to t, h.t_path(t.parameterize) }.join(', ').html_safe
  end

end
