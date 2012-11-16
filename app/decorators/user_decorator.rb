class UserDecorator < Draper::Base
  decorates :user

  def render_avatar
    h.image_tag model.avatar.url unless model.avatar.url.nil?
    h.image_tag "/assets/#{Theroot::Application.config.default_avatar}"
  end

end
