module ApplicationHelper
  def tag_cloud tags, classes
    max = tags.sort_by(&:count).last
    tags.each do |tag|
      index = tag.count.to_f / max.count * (classes.size - 1)
      yield(tag, classes[index.round])
    end
  end

  def icon icon, title = nil
    content_tag :i, '', class: "icon-#{icon}", title: title
  end

  def icon_white icon, title = nil
    content_tag :i, '', class: "icon-white icon-#{icon}", title: title
  end

  def alert message, type, header = nil

    render partial: 'shared/alert',
           locals: {
               message_type:      type,
               header:            header,
               message:           message
           }

  end

  def error message, header = nil
    alert message, 'error', header
  end

  def warning message, header = nil
    alert message, 'warning', header
  end

  def info message, header = nil
    alert message, 'info', header
  end

  def success message, header = nil
    alert message, 'success', header
  end

  def alert_wrapper id = nil
    render layout: 'shared/layout/alert_wrapper', locals: {id: id} do
      yield
    end
  end

  def render_flash
    alert_wrapper do
      flash.map_string do |key, message|
        alert message, key
      end
    end
  end

end
