$ ->
  $('.fileupload').fileupload
    dataType: 'script'

    add: (e, data) ->
      return unless data.files[0]

      types = /(\.|\/)(gif|jpe?g|png|bmp)$/i
      file = data.files[0]

      if !(types.test(file.type) || types.test(file.name))
        alert(file.name + " must be GIF, JPEG, BMP or PNG file")
        return

      max_size = parseInt($('.fileupload-form').data('maxuploadsize') || '10485760')
      if file.size > max_size
        alert(file.name + " size should be no more than #{max_size / 1000000} MB")
        return

      reader = new FileReader();
      jcrop_api = null
      reader.onload = (e) ->
        $('#photo-preview-modal .modal-body').html(
          "<img src='#{e.target.result}' id='image-preview-place' style='display: none;' />"
        )

        $('#photo-preview-modal').modal()

      reader.readAsDataURL(data.files[0]);

      $('#upload_photo_button').off('click').on 'click', ->
        data.formData = jcrop_api.tellSelect()
        data.submit()

        $('#photo-preview-modal').modal('hide')

      $('#photo-preview-modal').on 'hidden.bs.modal', ->
        jcrop_api.destroy() if jcrop_api

      $('#photo-preview-modal').on 'shown.bs.modal', ->
        res = parseInt ($('#photo-preview-modal .modal-body').width())

        imageWidth = $('#image-preview-place').innerWidth()
        imageHeight = $('#image-preview-place').innerHeight()
        $('#image-preview-place').Jcrop(
          {
            boxWidth: res, aspectRatio: 1, keySupport: false, minSize: [100, 100],
            setSelect: [0, 0, Math.min(imageWidth, imageHeight), Math.min(imageWidth, imageHeight)]
          }
        );

        jcrop_api = $('#image-preview-place').data('Jcrop');

  wrapper = $('.progress-wrapper')
  progress_bar = $('.progress-bar')

  $('.fileupload').on 'fileuploadstart', ->
    wrapper.show()

  $('.fileupload').on 'fileuploaddone', ->
    wrapper.hide()
    progress_bar.width(0)

  $('.fileupload').on 'fileuploadprogressall', (e, data) ->
    progress = parseInt(data.loaded / data.total * 100, 10);
    progress_bar.css('width', progress + '%')

  $('.fileupload-form a.upload-link').click ->
    $(this).closest('.fileupload-form').find('input').click()
    return false

  $('.delete-image').click ->
    return true if $(this).attr('data-confirm')
    $(this).closest('form').submit()
