$(document).on "page:change page:restore", ->
  
  $.rails.allowAction = (link) ->
    return true unless link.attr('data-confirm')
    $.rails.showConfirmDialog(link) 
    false 

  $.rails.confirmed = (link) ->
    link.removeAttr('data-confirm')
    link.trigger('click.rails')

  $.rails.showConfirmDialog = (link) ->
    message = link.attr 'data-confirm'
    html = 
    """
      <div class="modal fade">
        <div class="modal-dialog">
          <div class="modal-content confirm-modal">
            <div class="modal-header">
              <button type="button" class="modal-button-left close-icon" 
                data-dismiss="modal" aria-hidden="true"><span></span></button>
              <button type="button" class="modal-button-right check-icon" 
                data-dismiss="modal" aria-hidden="true"><span></span></button>
              <h4 class="modal-title">Are you sure?</h4>
            </div>
            <div class="modal-body">#{message}</div>
          </div>
        </div>
      </div>
    """
    $(html).modal()
      .on 'shown.bs.modal', ->
        $(this).find('.check-icon').on 'click', -> 
          $.rails.confirmed(link)
      .on 'hidden.bs.modal', -> 
        $(@).remove()