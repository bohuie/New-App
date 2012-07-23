module ApplicationHelper

  # returns full title on per-page basis
  def full_title( page_title )
    base_title = 'New App'
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
  
  def status_image(bool, labels = ['Active', 'Inactive'])
    if bool
      html_class = "label label-success"
      html_label = labels[0]
    else
      html_class = "label label-important"
      html_label = labels[1]
    end
    content_tag("span", html_label, :class => html_class)    
  end  
end
