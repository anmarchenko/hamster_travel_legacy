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

    swal({
      title: $('#confirmation_header').text(),
      text: message,
      confirmButtonText: $('#confirmation_ok').text(),
      cancelButtonText: $('#confirmation_cancel').text(),
      type: 'warning',
      showCancelButton: true
    }).then( ->
      console.log('confirmed')
      $.rails.confirmed(link)
    ,
      ->
        # dismissed
    )
