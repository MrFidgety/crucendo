module FlashHelper
  def render_flash
    render 'shared/flash' if can_flash?
  end
  
  def can_flash?
    [:controller, :from, :type, :result].all? {|s| flash.key? s}
  end
  
  def flash_object
    flash[:object_type].classify.constantize.where(id: flash[:object_id]).first unless !flash[:object_type]
  end
  
  def flash_path
    File.join(flash[:controller].to_s, 'flash', flash[:from].to_s, flash[:result].to_s)
  end
  
  def flash_alert_result
    flash[:result]
  end
  
  def flash_alert_type
    flash[:type]
  end
end