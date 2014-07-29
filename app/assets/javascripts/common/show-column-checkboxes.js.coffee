$ ->
  $('.show-column-checkboxes').affix(
    offset:
      top: ->
        $('header').outerHeight(true) + $('.trip-header').outerHeight(true)
      bottom: ->
        $('footer').outerHeight(true)
  )

