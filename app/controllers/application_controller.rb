class ApplicationController < ActionController::Base
  
  # Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :exception
  
  # Set up meta tags
  before_action :prepare_meta_tags, if: "request.get?"
  
  include SessionsHelper
  include FlashHelper
  
  before_filter :set_user_time_zone
  
  def set_flash(result, type: 'info', object: nil, controller: controller_path)
    if object
      flash[:from] = action_name
      flash[:result] = result
      flash[:type] = type
      flash[:object_type] = object.class.name
      flash[:object_id] = object.id
      flash[:controller] = controller
    else
      flash[:from] = nil
      flash[:result] = result
      flash[:type] = type
      flash[:controller] = :shared
    end
  end
  
  def set_user_time_zone
    if current_user.blank? || current_user.time_zone.blank?
      Time.zone = 'UTC'
    else
      Time.zone =  current_user.time_zone
    end
  end
  
  def prepare_meta_tags(options={})
    site_name   = "Crucendo"
    title       = options[:title] || "Crucendo"
    description = options[:description] || "Wanting to improve is a no-brainer. Taking the necessary action is another story. Crucendo provides a unique approach to motivation and improvement. Begin now."
    image       = options[:image] || view_context.image_url("crucendo-social.png")
    current_url = request.url
    type        = options[:type] || "website"

    # Let's prepare a nice set of defaults
    defaults = {
      site:         site_name,
      title:        title,
      reverse:      true,
      image:        image,
      description:  description,
      keywords:     %w[self-esteem confidence motivational motivate improve awareness motivation health positivity mindset],
      twitter: {
        site_name: site_name,
        site: '@crucendoapp',
        title: title,
        card: 'summary',
        description: description,
        image: image
      },
      og: {
        url: current_url,
        site_name: site_name,
        title: title,
        image: image,
        description: description,
        type: type
      }
    }

    options.reverse_merge!(defaults)
    set_meta_tags options
  end
  
  private
  
    # Confirms an admin user
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
  
    # Confirms a logged-in user
    def logged_in_user
      unless logged_in?
        set_flash :link_error, type: :warning
        redirect_to root_url
      end
    end
    
    # Set current user
    def set_current_user
      redirect_to root_url unless @user = current_user
    end
end
