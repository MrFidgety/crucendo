module ApplicationHelper
  
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "Crucendo"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
  
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = (column == sort_column) ? "current #{sort_direction}" : nil
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
  end
  
  # extend pluralize method to allow parent classes
  def pluralize(count, singular, plural = nil)
    count, counted = super.split(' ', 2)
    [content_tag(:span, count, class: 'pluralize-number'), 
      content_tag(:span, counted, class: 'pluralize-word')].join(' ').html_safe
  end
end
