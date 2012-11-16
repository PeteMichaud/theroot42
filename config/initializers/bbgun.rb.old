BBGun.configure do |c|
  c.custom_tags = [
    [/\[t\](.*?)\[\/t\]/,'<img src="\1" alt="@config[:image_alt]" class="thumb" />',true],
    [/\[thumb\](.*?)\[\/thumb\]/,'<img src="\1" alt="@config[:image_alt]" class="thumb" />',true],
    [/\[spoiler\](.*?)\[\/spoiler\]/,'<div class="spoiler"><div class="handle">Spoiler (Click to show)</div><div class="hidden">\1</div></div>',true],
  ]
end