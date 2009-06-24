(function($){ 
	$.fn.extend({  
		elastic: function() {
			
			// We will clone these variables to create a div clone of the textarea.
			var mimics = new Array('paddingTop','paddingRight','paddingBottom','paddingLeft','fontSize','lineHeight','fontFamily','width','fontWeight');
			
			return this.each( function() {
				
				if ( this.type != 'textarea' )
					return false;
				
				var $textarea = $(this);
				var lineHeight = parseInt($textarea.css('lineHeight'),10) || parseInt($textarea.css('fontSize'),'10');
				var minheight = parseInt($textarea.css('height'),10) || lineHeight*3;
				var maxheight = parseInt($textarea.css('max-height'),10) || Number.MAX_VALUE;
				var goalheight = 0;
				var twin = null;
				var first = true;
				
				
				// Create a div twin of the textarea.
				// We are going to meassure the height of this, not the textarea.
				if ( !twin ) {
					$twin = $('<div />').css({'position': 'absolute','display':'none'}).appendTo($textarea.parent());
					$.each(mimics, function(){
						$twin.css(this.toString(),$textarea.css(this.toString()));
					});
				};
				
				function setHeight(height, overflow){
					curratedHeight = Math.floor(parseInt(height,10));
					if($textarea.height() != curratedHeight){
						$textarea.css({'height': curratedHeight + 'px','overflow':overflow});
					}
				}
				
				
				// This function will update the height of the textarea if necessary 
				function update() {
					
					// Get curated content from the textarea.
					var textareaContent = $textarea.val().replace(/<|>/g, ' ').replace(/\n/g, '<br />').replace(/&/g,"&amp;");
					var twinContent = $twin.html();
					
					if(textareaContent+'&nbsp;' != twinContent){
					
						// Add an extra white space so new rows are added when you are at the end of a row.
						$twin.html(textareaContent+'&nbsp;');
						
						// Change textarea height if twin plus the height of one line differs more than 3 pixel from textarea height
						if(Math.abs($twin.height()+lineHeight - $textarea.height()) > 3){
							
							var goalheight = $twin.height()+lineHeight;
							if(goalheight >= maxheight)
								setHeight(maxheight,'auto');
							else if(goalheight <= minheight)
								setHeight(minheight,'hidden');
							else
								setHeight(goalheight,'hidden');
							
							// Google Chrome bug.
							if(first){
								temp = $textarea.val();
								$textarea.val('');
								setTimeout(function() {
									$textarea.val(temp);
								}, 1);
								first = false;
							}
							
						}
						
					}
					
				}
				
				// Only run update when the textarea has focus
				$textarea.css({'overflow':'hidden'}).bind('focus',function() {
					self.periodicalUpdater = window.setInterval(function() {
						update();
					}, 50);
				}).bind('blur', function() {
					clearInterval(self.periodicalUpdater);
				});
				
				// Run update once when elastic is initialized
				update();
				
			});
			
        } 
    }); 
})(jQuery);