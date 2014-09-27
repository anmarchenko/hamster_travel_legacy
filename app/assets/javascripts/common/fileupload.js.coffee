$ ->
  $('.fileupload').fileupload
    dataType: 'script'

    add: (e, data) ->
      types = /(\.|\/)(gif|jpe?g|png|bmp)$/i
      file = data.files[0]

      if !(types.test(file.type) || types.test(file.name))
        alert(file.name + " must be GIF, JPEG, BMP or PNG file")
        return

      if file.size > 10485760
        alert(file.name + " size should be no more than 10 MB")
        return

      data.submit()

  $('.fileupload-form a.upload-link').click ->
    $(this).closest('.fileupload-form').find('input').click()
    return false

  $('.delete-image').click ->
    return true if $(this).attr('data-confirm')
    $(this).closest('form').submit()
