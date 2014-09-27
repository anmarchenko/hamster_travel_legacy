$ ->
  $.rails.allowAction = (link) ->
    return true unless link.attr('data-confirm')
    $.rails.showConfirmDialog(link)
    false

  $.rails.confirmed = (link) ->
    message = link.attr 'data-confirm'
    link.removeAttr('data-confirm')
    link.trigger('click')
    link.attr('data-confirm', message)

  $.rails.showConfirmDialog = (link) ->
    message = link.attr 'data-confirm'
    $("#confirm-modal").find(".modal-body").html(message)
    $("#confirm-modal").modal()
    $('#confirm-modal .confirm').off('click').on 'click', -> $.rails.confirmed(link)