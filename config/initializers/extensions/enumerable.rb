module Enumerable
  def map_string
    out = []
    each { |e| out << yield(e) }
    out.join.html_safe
  end

  def map_string_with_index
    out = []
    each_with_index { |e,i| out << yield(e,i) }
    out.join.html_safe
  end


end