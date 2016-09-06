// $(function() {
//     var photo_processing, progress_bar, wrapper;
//     $('.fileupload').fileupload({
//         dataType: 'script',
//         add: function(e, data) {
//             var file, jcrop_api, max_size, reader, types;
//             if (!data.files[0]) {
//                 return;
//             }
//             types = /(\.|\/)(gif|jpe?g|png|bmp)$/i;
//             file = data.files[0];
//             if (!(types.test(file.type) || types.test(file.name))) {
//                 alert(file.name + " must be GIF, JPEG, BMP or PNG file");
//                 return;
//             }
//             max_size = parseInt($('.fileupload-form').data('maxuploadsize') || '10485760');
//             if (file.size > max_size) {
//                 alert(file.name + (" size should be no more than " + (max_size / 1000000) + " MB"));
//                 return;
//             }
//             reader = new FileReader();
//             jcrop_api = null;
//             reader.onload = function(e) {
//                 $('#photo-preview-modal .modal-body').html("<img src='" + e.target.result + "' id='image-preview-place' style='display: none;' />");
//                 return $('#photo-preview-modal').modal();
//             };
//             reader.readAsDataURL(data.files[0]);
//             $('#upload_photo_button').off('click').on('click', function() {
//                 data.formData = jcrop_api.tellSelect();
//                 data.submit();
//                 return $('#photo-preview-modal').modal('hide');
//             });
//             $('#photo-preview-modal').on('hidden.bs.modal', function() {
//                 if (jcrop_api) {
//                     return jcrop_api.destroy();
//                 }
//             });
//             return $('#photo-preview-modal').on('shown.bs.modal', function() {
//                 var imageHeight, imageWidth, res;
//                 res = parseInt($('#photo-preview-modal .modal-body').width());
//                 imageWidth = $('#image-preview-place').innerWidth();
//                 imageHeight = $('#image-preview-place').innerHeight();
//                 $('#image-preview-place').Jcrop({
//                     boxWidth: res,
//                     aspectRatio: 1,
//                     keySupport: false,
//                     minSize: [100, 100],
//                     setSelect: [0, 0, Math.min(imageWidth, imageHeight), Math.min(imageWidth, imageHeight)]
//                 });
//                 return jcrop_api = $('#image-preview-place').data('Jcrop');
//             });
//         }
//     });
//     wrapper = $('.progress-wrapper');
//     photo_processing = $('.photo-processing');
//     progress_bar = $('.progress-bar');
//     $('.fileupload').on('fileuploadstart', function() {
//         wrapper.show();
//         return photo_processing.show();
//     });
//     $('.fileupload').on('fileuploaddone', function() {
//         wrapper.hide();
//         return progress_bar.width(0);
//     });
//     $('.fileupload').on('fileuploadprogressall', function(e, data) {
//         var progress;
//         progress = parseInt(data.loaded / data.total * 100, 10);
//         return progress_bar.css('width', progress + '%');
//     });
//     $('.fileupload-form a.upload-link').click(function() {
//         $(this).closest('.fileupload-form').find('input').click();
//         return false;
//     });
//     return $('.delete-image').click(function() {
//         if ($(this).attr('data-confirm')) {
//             return true;
//         }
//         return $(this).closest('form').submit();
//     });
// });
