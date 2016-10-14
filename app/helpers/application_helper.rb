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
  
  # allow link_to_if to work with html blocks
  def link_to_if(*args,&block)
    args.insert 1, capture(&block) if block_given?
    super *args
  end
  
  def when_did_it_happen(date)
    date > 6.days.ago ? local_relative_time(date, 'weekday') : local_date(date, '%B %e, %Y')
  end
end