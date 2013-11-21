$(document).ready(function(){
  $('.image-crop').each(function() {
    $(this).imagesLoaded(function($images, $proper, $broken){
      if($broken.length == 0){
        var cropRatio, aspectRatio, updateCrop,
        $this = $(this),
        $img = $('img', $this);

        cropRatio = parseFloat($this.attr('data-original-width')) / $img.width();
        aspectRatio = parseFloat($this.attr('data-aspect-ratio'));
        
        updateCrop = function(coords) {
          $('.crop-x', $this).val(Math.round(coords.x * cropRatio));
          $('.crop-y', $this).val(Math.round(coords.y * cropRatio));
          $('.crop-w', $this).val(Math.round(coords.w * cropRatio));
          $('.crop-h', $this).val(Math.round(coords.h * cropRatio));
        };

        $img.Jcrop({
          onChange: updateCrop,
          onSelect: updateCrop,
          setSelect: [0, 0, $img.width(), $img.height()],
          aspectRatio: aspectRatio
        });
      }
    });
  });
});