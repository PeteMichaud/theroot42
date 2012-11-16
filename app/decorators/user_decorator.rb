class UserDecorator < Draper::Base
  decorates :user

  def render_avatar
    return h.image_tag model.avatar.url if model.avatar.file?
    h.image_tag "/assets/#{Theroot::Application.config.default_avatar}"
  end

end
