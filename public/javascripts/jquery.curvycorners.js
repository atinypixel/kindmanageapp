/****************************************************************
*                                                              *
*  JQuery Curvy Corners by Mike Jolley                         *
*	 http://blue-anvil.com                                     *
*  ------------                                                *
*  Version 2.0 Beta                                            *
*                                                              *
*  Original by: Terry Riegel, Cameron Cooke and Tim Hutchison  *
*  Website: http://www.curvycorners.net                        *
*                                                              *
*  This library is free software; you can redistribute         *
*  it and/or modify it under the terms of the GNU              *
*  Lesser General Public License as published by the           *
*  Free Software Foundation; either version 2.1 of the         *
*  License, or (at your option) any later version.             *
*                                                              *
*  This library is distributed in the hope that it will        *
*  be useful, but WITHOUT ANY WARRANTY; without even the       *
*  implied warranty of MERCHANTABILITY or FITNESS FOR A        *
*  PARTICULAR PURPOSE. See the GNU Lesser General Public       *
*  License for more details.                                   *
*                                                              *
*  You should have received a copy of the GNU Lesser           *
*  General Public License along with this library;             *
*  Inc., 59 Temple Place, Suite 330, Boston,                   *
*  MA 02111-1307 USA                                           *
*                                                              *
****************************************************************/

/*
Differences from offical CC:
	- Boxes are not fixed size and will auto size to content
	- Backgrounds aligned to bottom won't work correctly so align to top if you need to tile
	

Usage:
	Will now autoMagically apply borders via the CSS declarations
	Safari, Mozilla, and Chrome all support rounded borders via
	
	-webkit-border-radius, and -moz-border-radius
	
	So instead of reinventing the wheel we will let these browsers render
	their borders natively. Firefox for Windows renders non-antialiased
	borders so they look a bit ugly. Google's Chrome will render its "ugly"
	borders as well. So if we let FireFox, Safari, and Chrome render their
	borders natively, then we only have to support IE for rounded borders.
	Opera is not supported currently. Fortunately IE will read CSS properties
	that it doesn't understand (both Firefox and Safari discard them)
	So we will add yet another CSS declaration that IE can find and apply
	the borders to (CCborderRadius)
	
	So to make curvycorners work with any major browser simply add the following
	CSS declarations and it should be good to go...
	
	.round { 
		-webkit-border-radius: 25px;
	    -moz-border-radius: 25px;
	    CCborderRadius: 25px;
	}
	
You can still use the direct syntax:

	$('.myBox').corner();

*/  
function styleit()
{
	for(var t = 0; t < document.styleSheets.length; t++)
	{
		var theRules = new Array();
		theRules = document.styleSheets[t].rules

		for(var i = 0; i < theRules.length; i++)
		{
		
			var allR = theRules[i].style.CCborderRadius    || 0;
			var tR   = theRules[i].style.CCborderRadiusTR  || allR;
			var tL   = theRules[i].style.CCborderRadiusTL  || allR;
			var bR   = theRules[i].style.CCborderRadiusBR  || allR;
			var bL   = theRules[i].style.CCborderRadiusBL  || allR;

			if (allR || tR || tR || bR || bL)
			{
				var s = theRules[i].selectorText;
				
				

				var settings = {					
					tl: { radius: makeInt(tL) },
					tr: { radius: makeInt(tR) },
					bl: { radius: makeInt(bL) },
					br: { radius: makeInt(bR) },
					antiAlias: true,
					autoPad: true,
					validTags: ["div"]
				};
				
				$(s).corner(settings); 

			}
		}
	}
}

function makeInt(num) {
	var re = new RegExp('([0-9]*)');
	var i = 0;
	if(isNaN(num)) {
		var a = re.exec(num);
		if(!isNaN(parseInt(a[1]))) {
			i = a[1];
		}
	}
	else {
		i = num;
	}	
	return i;
}

(function($) { 

	$(function(){
		if ($.browser.msie) styleit();
	});	
	
	$.fn.corner = function(options) {

		var settings = {
		  tl: { radius: 8 },
		  tr: { radius: 8 },
		  bl: { radius: 8 },
		  br: { radius: 8 },
		  antiAlias: true,
		  autoPad: true,
		  validTags: ["div"] 
		};
		if ( options && typeof(options) != 'string' )
			$.extend(settings, options);
	            
		return this.each(function() {
			if (!$(this).is('.hasCorners')) {
				applyCorners(this, settings);				
			}			
		}); 

  		// Apply the corners to the passed object!
		function applyCorners(box,settings)
		{
				
			// Setup Globals
			var $$ 						= $(box);
			this.topContainer 			= null;
			this.bottomContainer 		= null;
			this.shell            		= null;
			this.masterCorners 			= new Array();
			this.contentDIV 				= null;
		
			// Get CSS of box and define vars
			
			// Background + box colour
			this.x_bgi 				= $$.css("backgroundImage");																// Background Image
			this.x_bgi				= (x_bgi != "none" && x_bgi!="initial") ? x_bgi : "";
			this.x_bgr 				= $$.css("backgroundRepeat");																// Background repeat
			this.x_bgposX			= strip_px($$.css("backgroundPositionX")) ? strip_px($$.css("backgroundPositionX")) : 0; 	// Background position
			this.x_bgposY			= strip_px($$.css("backgroundPositionY")) ? strip_px($$.css("backgroundPositionY")) : 0; 	// Background position
			this.x_bgc 				= format_colour($$.css("backgroundColor"));													// Background Colour
			
			// Dimensions + positioning
			var x_height 			= $$.css("height");		 					// Height
			
			if(typeof x_height == 'undefined') x_height = 'auto';
			
			this.x_height       	= parseInt(((x_height != "" && x_height != "auto" && x_height.indexOf("%") == -1)? x_height.substring(0, x_height.indexOf("px")) : box.offsetHeight));
					
			if($.browser.msie && $.browser.version==6)
			{
				this.x_width	 		= strip_px(box.offsetWidth); 
			} 
			else 
			{
				this.x_width	 		= strip_px($$.css('width')); 
			}		

			this.xp_height      	= strip_px($$.parent().css("height")) ? strip_px($$.css("height")) : 'auto';				// Parent height
			
			// Borders
			this.x_bw		     	= strip_px($$.css("borderTopWidth")) ? strip_px($$.css("borderTopWidth")) : 0; 				// Border width
			this.x_bbw		     	= strip_px($$.css("borderBottomWidth")) ? strip_px($$.css("borderBottomWidth")) : 0; 		// Bottom Border width
			this.x_tbw		     	= strip_px($$.css("borderTopWidth")) ? strip_px($$.css("borderTopWidth")) : 0; 				// Top Border width
			this.x_lbw		     	= strip_px($$.css("borderLeftWidth")) ? strip_px($$.css("borderLeftWidth")) : 0; 			// Left Border width
			this.x_rbw		     	= strip_px($$.css("borderRightWidth")) ? strip_px($$.css("borderRightWidth")) : 0; 			// Right Border width
			this.x_bc		     	= format_colour($$.css("borderTopColor")); 													// Border colour
			this.x_bbc		     	= format_colour($$.css("borderBottomColor")); 												// Bottom Border colour
			this.x_tbc		     	= format_colour($$.css("borderTopColor")); 													// Top Border colour
			this.x_lbc		     	= format_colour($$.css("borderLeftColor")); 												// Left Border colour
			this.x_rbc		     	= format_colour($$.css("borderRightColor")); 												// Right Border colour
			this.borderString    	= this.x_bw + "px" + " solid " + this.x_bc;
      		this.borderStringB   	= this.x_bbw + "px" + " solid " + this.x_bbc;
						
			// Padding
			this.x_pad		      	= strip_px($$.css("paddingTop"));															// Padding
			this.x_tpad	 			= strip_px($$.css("paddingTop"));															// Padding top
			this.x_bpad 			= strip_px($$.css("paddingBottom"));														// Padding Bottom
			this.x_lpad			 	= strip_px($$.css("paddingLeft"));															// Padding Left		
			this.x_rpad			 	= strip_px($$.css("paddingRight"));															// Padding Right
			this.topPaddingP     	= strip_px($$.parent().css("paddingTop"));													// Parent top padding
			this.bottomPaddingP  	= strip_px($$.parent().css("paddingBottom"));												// Parent bottom padding
			
			// Margins
			this.x_tmargin	 		= strip_px($$.css("marginTop"));														// Margin top
			this.x_bmargin 			= strip_px($$.css("marginBottom"));														// Margin Bottom
		
			// Calc Radius
			this.topMaxRadius = Math.max(settings.tl ? settings.tl.radius : 0, settings.tr ? settings.tr.radius : 0);
			this.botMaxRadius = Math.max(settings.bl ? settings.bl.radius : 0, settings.br ? settings.br.radius : 0);
			
			// Add styles and class		
			$$.addClass('hasCorners').css({
				"padding":				"0", 
				"border":				"none",
				"backgroundColor":		"transparent", 
				"backgroundImage":		"none", 
				'overflow':				"visible"
			});
		
			if(box.style.position != "absolute") $$.css("position","relative");

       		$$.attr("id","ccoriginaldiv");

			// Ok we add an inner div to actually put things into this will allow us to keep the height			
			var newMainContainer = document.createElement("div");
			
			$(newMainContainer).css({"padding" : "0", width: '100%' }).attr('id','ccshell');			

       		//this.shell = $$.append(newMainContainer);
       		this.shell = newMainContainer;
       		
      		//this.x_width = strip_px($(this.shell).css('width'));

			/*
			Create top and bottom containers.
			These will be used as a parent for the corners and bars.
			*/
			for(var t = 0; t < 2; t++)
			{
				switch(t)
				{
					// Top
					case 0:
					
						// Only build top bar if a top corner is to be draw
						if(settings.tl || settings.tr)
						{
							var newMainContainer = document.createElement("div");
							
							$(newMainContainer).css({
								width: '100%',
								"font-size":		"1px", 
								overflow:			"hidden", 
								position:			"absolute", 
								height:				topMaxRadius + "px",
								top:				0 - topMaxRadius + "px",
								"marginLeft" :			- parseInt( this.x_lbw + this.x_lpad) + "px",
								"marginRight" :			- parseInt( this.x_rbw + this.x_rpad) + "px"
							}).attr('id','cctopcontainer');
							
							if($.browser.msie && $.browser.version==6) {
								$(newMainContainer).css({   	
									"paddingLeft" :			parseInt( this.x_lbw + this.x_lpad) + "px",
									"paddingRight" :		parseInt( this.x_rbw + this.x_rpad) + "px"
						        });
					        }
          
							this.topContainer = this.shell.appendChild(newMainContainer);

						}
					break;
					
					// Bottom
					case 1:
					
						// Only build bottom bar if a bottom corner is to be draw
						if(settings.bl || settings.br)
						{							
							var newMainContainer = document.createElement("div");
							
							$(newMainContainer).css({ 
								width: '100%',
								"font-size":		"1px", 
								"overflow":			"hidden", 
								"position":			"absolute", 
								height:				botMaxRadius + "px",
								bottom:				0 - botMaxRadius + "px",
								"marginLeft" :			- parseInt( this.x_lbw + this.x_lpad) + "px",
								"marginRight" :			- parseInt( this.x_rbw + this.x_rpad) + "px"
							}).attr('id','ccbottomcontainer');
							
							if($.browser.msie && $.browser.version==6) {
								$(newMainContainer).css({   	
									"paddingLeft" :			parseInt( this.x_lbw + this.x_lpad) + "px",
									"paddingRight" :		parseInt( this.x_rbw + this.x_rpad) + "px"
						        });
					        }
							
							this.bottomContainer = this.shell.appendChild(newMainContainer);	
						}
					break;
				}
			}


			// Create array of available corners
			var corners = ["tr", "tl", "br", "bl"];
			/*
			Loop for each corner
			*/
			for(var i in corners)
			{
				if(i > -1 < 4)
				{
					// Get current corner type from array
					var cc = corners[i];
					// Has the user requested the currentCorner be round?
					// Code to apply correct color to top or bottom
					if(cc == "tr" || cc == "tl")
					{
						var bwidth=this.x_bw;
						var bcolor=this.x_bc;
					} else {
						var bwidth=this.x_bbw;
						var bcolor=this.x_bbc;
					}
					
					// Yes, we need to create a new corner
					var newCorner = document.createElement("div");
					
					$(newCorner).css({
						position:"absolute",
						"font-size":"1px", 
						overflow:"hidden"
					}).height(settings[cc].radius + "px").width(settings[cc].radius + "px");
					
					// THE FOLLOWING BLOCK OF CODE CREATES A ROUNDED CORNER
					// ---------------------------------------------------- TOP
					// Get border radius
					var borderRadius = parseInt(settings[cc].radius - this.x_bw);
					// Cycle the x-axis
					for(var intx = 0, j = settings[cc].radius; intx < j; intx++)
					{
                      // Calculate the value of y1 which identifies the pixels inside the border
                      if((intx +1) >= borderRadius)
                        var y1 = -1;
                      else
                        var y1 = (Math.floor(Math.sqrt(Math.pow(borderRadius, 2) - Math.pow((intx+1), 2))) - 1);
                      // Only calculate y2 and y3 if there is a border defined
                      if(borderRadius != j)
                      {
                          if((intx) >= borderRadius)
                            var y2 = -1;
                          else
                            var y2 = Math.ceil(Math.sqrt(Math.pow(borderRadius,2) - Math.pow(intx, 2)));
                           if((intx+1) >= j)
                            var y3 = -1;
                           else
                            var y3 = (Math.floor(Math.sqrt(Math.pow(j ,2) - Math.pow((intx+1), 2))) - 1);
                      }
                      // Calculate y4
                      if((intx) >= j)
                        var y4 = -1;
                      else
                        var y4 = Math.ceil(Math.sqrt(Math.pow(j ,2) - Math.pow(intx, 2)));
                      // Draw bar on inside of the border with foreground colour
                      
                      if(y1 > -1) drawPixel(intx, 0, this.x_bgc, 100, (y1+1), newCorner, -1, settings[cc].radius, 0, this.x_bgi, this.x_width, this.x_height, this.x_bw, this.x_bgr);
                      // Only draw border/foreground antialiased pixels and border if there is a border defined
                      if(borderRadius != j)
                      {
                          // Cycle the y-axis
                          for(var inty = (y1 + 1); inty < y2; inty++)
                          {
                              // Draw anti-alias pixels
                              if(settings.antiAlias)
                              {
                                  // For each of the pixels that need anti aliasing between the foreground and border colour draw single pixel divs
                                  if(this.x_bgi != "")
                                  {
										var borderFract = (pixelFraction(intx, inty, borderRadius) * 100);
										if(borderFract < 30)
										{
											drawPixel(intx, inty, bcolor, 100, 1, newCorner, 0, settings[cc].radius, 0, this.x_bgi, this.x_width, this.x_height, this.x_bw, this.x_bgr);
										}
										else
										{
											drawPixel(intx, inty, bcolor, 100, 1, newCorner, -1, settings[cc].radius, 0, this.x_bgi, this.x_width, this.x_height, this.x_bw, this.x_bgr);
                                  		}
                                  	}
                                  	else
                                  	{
                                      	var pixelcolour = BlendColour(this.x_bgc, bcolor, pixelFraction(intx, inty, borderRadius));
                                     	drawPixel(intx, inty, pixelcolour, 100, 1, newCorner, 0, settings[cc].radius, 0, this.x_bgi, this.x_width, this.x_height, this.x_bw, this.x_bgr);
                                  	}
                              }
                          }
                          // Draw bar for the border
                          if(settings.antiAlias)
                          {
                              if(y3 >= y2)
                              {
                                 if (y2 == -1) y2 = 0;
                                 drawPixel(intx, y2, bcolor, 100, (y3 - y2 + 1), newCorner, 0, 0, 1, this.x_bgi, this.x_width, this.x_height, this.x_bw, this.x_bgr);
                              }
                          }
                          else
                          {
                              if(y3 >= y1)
                              {
                                  drawPixel(intx, (y1 + 1), bcolor, 100, (y3 - y1), newCorner, 0, 0, 1, this.x_bgi, this.x_width, this.x_height, this.x_bw, this.x_bgr);
                              }
                          }
                          // Set the colour for the outside curve
                          var outsideColour = bcolor;
                      }
                      else
                      {
                          // Set the colour for the outside curve
                          var outsideColour = this.x_bgc;
                          var y3 = y1;
                      }
                      // Draw aa pixels?
                      if(settings.antiAlias)
                      {
                          // Cycle the y-axis and draw the anti aliased pixels on the outside of the curve
                          for(var inty = (y3 + 1); inty < y4; inty++)
                          {
                              // For each of the pixels that need anti aliasing between the foreground/border colour & background draw single pixel divs
                              drawPixel(intx, inty, outsideColour, (pixelFraction(intx, inty , j) * 100), 1, newCorner, ((this.x_bw > 0)? 0 : -1), settings[cc].radius, 0, this.x_bgi, this.x_width, this.x_height, this.x_bw);
                          }
                      }
                  }
                  // END OF CORNER CREATION
                  // ---------------------------------------------------- END
                  
                  // We now need to store the current corner in the masterConers array
                  masterCorners[settings[cc].radius] = $(newCorner).clone();

                  /*
                  Now we have a new corner we need to reposition all the pixels unless
                  the current corner is the bottom right.
                  */
                  // Loop through all children (pixel bars)
                  for(var t = 0, k = newCorner.childNodes.length; t < k; t++)
                  {
                      // Get current pixel bar
                      var pixelBar = newCorner.childNodes[t];
                      
                      // Get current top and left properties
                      var pixelBarTop    = parseInt(pixelBar.style.top.substring(0, pixelBar.style.top.indexOf("px")));
                      var pixelBarLeft   = parseInt(pixelBar.style.left.substring(0, pixelBar.style.left.indexOf("px")));
                      var pixelBarHeight = parseInt(pixelBar.style.height.substring(0, pixelBar.style.height.indexOf("px")));
                     
                      // Reposition pixels
                      if(cc == "tl" || cc == "bl"){
                          pixelBar.style.left = settings[cc].radius -pixelBarLeft -1 + "px"; // Left
                      }
                      if(cc == "tr" || cc == "tl"){
                          pixelBar.style.top =  settings[cc].radius -pixelBarHeight -pixelBarTop + "px"; // Top
                      }
                      pixelBar.style.backgroundRepeat = this.x_bgr;

                      switch(cc)
                      {
                          case "tr":
 								
 								if($.browser.msie && $.browser.version==6) var offset = this.x_lpad + this.x_rpad + this.x_lbw + this.x_rbw;
 								else var offset = 0;
 								
                                pixelBar.style.backgroundPosition  = parseInt( this.x_bgposX - Math.abs( this.x_rbw - this.x_lbw + (this.x_width - settings[cc].radius + this.x_rbw) + pixelBarLeft) - settings.bl.radius - this.x_bw - settings.br.radius - this.x_bw) + offset + "px " + parseInt( this.x_bgposY - Math.abs(settings[cc].radius -pixelBarHeight -pixelBarTop - this.x_bw)) + "px";

                              break;
                          case "tl":
                              pixelBar.style.backgroundPosition = parseInt( this.x_bgposX - Math.abs((settings[cc].radius -pixelBarLeft -1)  - this.x_lbw)) + "px " + parseInt( this.x_bgposY - Math.abs(settings[cc].radius -pixelBarHeight -pixelBarTop - this.x_bw)) + "px";
                              break;
                          case "bl":

                                  pixelBar.style.backgroundPosition = parseInt( this.x_bgposX - Math.abs((settings[cc].radius -pixelBarLeft -1) - this.x_lbw )) + "px " + parseInt( this.x_bgposY - Math.abs(( this.x_height + (this.x_bw+this.x_tpad+this.x_bpad) - settings[cc].radius + pixelBarTop))) + "px";
              
                              break;
                          case "br":
								  // Added - settings.bl.radius - this.x_bw - settings.br.radius - this.x_bw to this and tr to offset background image due to neg margins.
								  if($.browser.msie && $.browser.version==6) var offset = this.x_lpad + this.x_rpad + this.x_lbw + this.x_rbw;
 									else var offset = 0;
 								
                                  pixelBar.style.backgroundPosition = parseInt( this.x_bgposX - Math.abs( this.x_rbw - this.x_lbw + (this.x_width - settings[cc].radius + this.x_rbw) + pixelBarLeft) - settings.bl.radius - this.x_bw - settings.br.radius - this.x_bw) + offset + "px " + parseInt( this.x_bgposY - Math.abs(( this.x_height + (this.x_bw+this.x_tpad+this.x_bpad) - settings[cc].radius + pixelBarTop))) + "px";
                      
                              break;
                      }
                  }












                  // Position the container
                  switch(cc)
                  {


                      case "tl":
                        if(newCorner.style.position == "absolute") newCorner.style.top  = "0px";
                        if(newCorner.style.position == "absolute") newCorner.style.left = "0px";
                        if(this.topContainer) temp= this.topContainer.appendChild(newCorner);
						$(temp).attr("id","cctl");


                        break;
                      case "tr":
                        if(newCorner.style.position == "absolute") newCorner.style.top  = "0px";
                        if(newCorner.style.position == "absolute") newCorner.style.right = "0px";
                        if(this.topContainer) temp= this.topContainer.appendChild(newCorner);
						$(temp).attr("id","cctr");

                        break;
                      case "bl":
                        if(newCorner.style.position == "absolute") newCorner.style.bottom  = "0px";
                        if(newCorner.style.position == "absolute") newCorner.style.left = "0px";
						if(this.bottomContainer) temp= this.bottomContainer.appendChild(newCorner);
						$(temp).attr("id","ccbl");

                        break;
                      case "br":
                        if(newCorner.style.position == "absolute") newCorner.style.bottom   = "0px";
                        if(newCorner.style.position == "absolute") newCorner.style.right = "0px";
						if(this.bottomContainer) temp= this.bottomContainer.appendChild(newCorner);
						$(temp).attr("id","ccbr");

                        break;
                  }





              }
          }









          /*
          The last thing to do is draw the rest of the filler DIVs.
          We only need to create a filler DIVs when two corners have
          diffrent radiuses in either the top or bottom container.
          */

          // Find out which corner has the bigger radius and get the difference amount
          var radiusDiff = new Array();
          radiusDiff["t"] = Math.abs(settings.tl.radius - settings.tr.radius)
          radiusDiff["b"] = Math.abs(settings.bl.radius - settings.br.radius);

          for(z in radiusDiff)
          {
              // FIX for prototype lib
              if(z == "t" || z == "b")
              {
                  if(radiusDiff[z])
                  {
                      // Get the type of corner that is the smaller one
                      var smallerCornerType = ((settings[z + "l"].radius < settings[z + "r"].radius)? z +"l" : z +"r");

                      // First we need to create a DIV for the space under the smaller corner
                      var newFiller = document.createElement("DIV");
                      newFiller.style.height = radiusDiff[z] + "px";
                      newFiller.style.width  =  settings[smallerCornerType].radius+ "px"
                      newFiller.style.position = "absolute";
                      newFiller.style.fontSize = "1px";
                      newFiller.style.overflow = "hidden";
                      newFiller.style.backgroundColor = this.x_bgc;
                      //newFiller.style.backgroundColor = get_random_color();

                      // Position filler
                      switch(smallerCornerType)
                      {
                          case "tl":
                              newFiller.style.bottom = "0px";
                              newFiller.style.left   = "0px";
                              newFiller.style.borderLeft = this.borderString;
                              temp=this.topContainer.appendChild(newFiller);
temp.id="cctlfiller";

                              break;

                          case "tr":
                              newFiller.style.bottom = "0px";
                              newFiller.style.right  = "0px";
                              newFiller.style.borderRight = this.borderString;
                              temp=this.topContainer.appendChild(newFiller);
temp.id="cctrfiller";

                              break;

                          case "bl":
                              newFiller.style.top    = "0px";
                              newFiller.style.left   = "0px";
                              newFiller.style.borderLeft = this.borderStringB;
                              temp=this.bottomContainer.appendChild(newFiller);
temp.id="ccblfiller";

                              break;

                          case "br":
                              newFiller.style.top    = "0px";
                              newFiller.style.right  = "0px";
                              newFiller.style.borderRight = this.borderStringB;
                              temp=this.bottomContainer.appendChild(newFiller);
temp.id="ccbrfiller";

                              break;
                      }
                  }














                  // Create the bar to fill the gap between each corner horizontally
                  var newFillerBar = document.createElement("div");
                  newFillerBar.style.position = "relative";
                  newFillerBar.style.fontSize = "1px";
                  newFillerBar.style.overflow = "hidden";
                  newFillerBar.style.backgroundColor = this.x_bgc;
                  newFillerBar.style.backgroundImage = this.x_bgi;
                  newFillerBar.style.backgroundRepeat= this.x_bgr;


                  switch(z)
                  {
                      case "t":
                          // Top Bar
                          if(this.topContainer)
                          {
                              // Edit by Asger Hallas: Check if settings.xx.radius is not false
                              if(settings.tl.radius && settings.tr.radius)
                              {
                                  newFillerBar.style.height      = 100 + topMaxRadius - this.x_bw + "px";
                                  newFillerBar.style.marginLeft  = settings.tl.radius - this.x_lbw + "px";
                                  newFillerBar.style.marginRight = settings.tr.radius - this.x_rbw + "px";
                                  newFillerBar.style.borderTop   = this.borderString;                                 
                                   
                                  if(this.x_bgi != "")
                                    newFillerBar.style.backgroundPosition  = parseInt( this.x_bgposX - (topMaxRadius - this.x_lbw - this.x_lbw)) + "px " + parseInt( this.x_bgposY ) + "px";
                                    //newFillerBar.style.backgroundPosition  = parseInt( this.x_bgposX - (topMaxRadius - this.x_lbw)) + "px " + parseInt( this.x_bgposY ) + "px";
                                    
									if($.browser.msie && $.browser.version==6) {
										$(newFillerBar).css({   	
											"marginLeft" :		- parseInt( this.x_lbw + this.x_rbw ) + "px",
											"marginRight" :		- parseInt( this.x_lbw + this.x_rbw ) + "px"
										});
										 if(this.x_bgi != "")
                                    		newFillerBar.style.backgroundPosition  = parseInt( this.x_bgposX - (topMaxRadius - this.x_lbw)) + "px " + parseInt( this.x_bgposY ) + "px";
					       			}

								
                                  temp=this.topContainer.appendChild(newFillerBar);
								  $(temp).attr("id","cctopmiddlefiller");

                                  // Repos the boxes background image
                                  $(this.shell).css("backgroundPosition", parseInt( this.x_bgposX ) + "px " + parseInt( this.x_bgposY - (topMaxRadius - this.x_lbw)) + "px");
                              }
                          }
                          break;
                      case "b":
                          if(this.bottomContainer)
                          {
                              // Edit by Asger Hallas: Check if settings.xx.radius is not false
                              if(settings.bl.radius && settings.br.radius)
                              {
                                  // Bottom Bar
                                  newFillerBar.style.height     = botMaxRadius - this.x_bw + "px";
                                  newFillerBar.style.marginLeft   = settings.bl.radius - this.x_bw + "px";
                                  newFillerBar.style.marginRight  = settings.br.radius - this.x_bw + "px";
                                  newFillerBar.style.borderBottom = this.borderStringB;
                                  if(this.x_bgi != "")
                                    newFillerBar.style.backgroundPosition  = parseInt( this.x_bgposX - (botMaxRadius - this.x_lbw - this.x_lbw)) + "px " + parseInt( this.x_bgposY - (this.x_height + this.x_tpad + this.x_bw + this.x_bpad - botMaxRadius )) + "px";
                                    //newFillerBar.style.backgroundPosition  = parseInt( this.x_bgposX - (botMaxRadius  - this.x_lbw )) + "px " + parseInt( this.x_bgposY - (this.x_height + this.x_tpad + this.x_bw + this.x_bpad - botMaxRadius )) + "px";
                                  
                                  if($.browser.msie && $.browser.version==6) {
										$(newFillerBar).css({   	
											"marginLeft" :		- parseInt( this.x_lbw + this.x_rbw ) + "px",
											"marginRight" :		- parseInt( this.x_lbw + this.x_rbw ) + "px"
										});
										
										if(this.x_bgi != "")
                                    		newFillerBar.style.backgroundPosition  = parseInt( this.x_bgposX - (botMaxRadius - this.x_lbw)) + "px " + parseInt( this.x_bgposY - (this.x_height + this.x_tpad + this.x_bw + this.x_bpad - botMaxRadius )) + "px";
					       			}
					       			
                                  temp=this.bottomContainer.appendChild(newFillerBar);
$(temp).attr("id","ccbottommiddlefiller");

                              }
                          }
                          break;
                  }
              }
          }


          // Create content container
          var contentContainer = document.createElement("div");
          var pd = 0;
          // Set contentContainer's properties
        //  contentContainer.style.position = "absolute";
          contentContainer.className      = "autoPadDiv";
          // Get padding amounts
          var topPadding = Math.abs( this.x_bw  + this.x_pad);
          var botPadding = Math.abs( this.x_bbw + this.x_pad);
          
          // Apply top padding
          if(topMaxRadius < this.boxPadding)
            {
            contentContainer.style.paddingTop = parseInt( pd + topPadding) + "px";
            } 
            else
            {
            contentContainer.style.paddingTop = "0";
          	//contentContainer.style.top = parseInt( pd + topPadding ) +"px";
          }
          
          // Apply Bottom padding
          if(botMaxRadius < this.x_pad)
            {contentContainer.style.paddingBottom = parseInt(botPadding - botMaxRadius) + "px";} else
            {contentContainer.style.paddingBottom = "0";}
          
          // Content container must fill vertically to show the border
          $(contentContainer).css({   	
			"marginLeft" :			- parseInt( this.x_lbw + this.x_lpad) + "px",
			"marginRight" :			- parseInt( this.x_rbw + this.x_rpad) + "px",			
			"marginTop" :			"-" + parseInt( this.x_tbw + (this.x_tpad - topMaxRadius)) + "px",
			"marginBottom" :		"-" + parseInt( this.x_bbw + (this.x_bpad - botMaxRadius)) + "px",
			"border" :				this.borderString,
			"borderTopWidth" :		"0",
			"borderBottomWidth" :	"0",
			"height" : 				"100%",
			"width" : "100%",
			"paddingLeft" :			parseInt( this.x_lpad) + "px",
			"paddingRight" :		parseInt( this.x_rpad) + "px",
			"paddingTop" :			parseInt( this.x_tbw + (this.x_tpad - topMaxRadius)) + "px",
			"paddingBottom" :      	parseInt( this.x_bbw + (this.x_bpad - botMaxRadius)) + "px"
          });
          
          // Origional container has background image
          $$.css({            
          	"paddingLeft" :			parseInt( this.x_lbw + this.x_lpad) + "px",
			"paddingRight" :		parseInt( this.x_rbw + this.x_rpad) + "px",
			"paddingTop" :			parseInt( this.x_tbw + (this.x_tpad - topMaxRadius)) + "px",
			"paddingBottom" :      	parseInt( this.x_bbw + (this.x_bpad - botMaxRadius)) + "px",
			"backgroundColor" : 	this.x_bgc,
			"backgroundImage" :		this.x_bgi,
			"backgroundPosition" : 	this.x_bw + 'px -' + parseInt(topMaxRadius - this.x_bw ) + "px",
			'margin-top':			parseInt(this.x_tmargin + topMaxRadius) + "px", 
			'margin-bottom':		parseInt(this.x_bmargin + botMaxRadius) + "px"
          });
         
          // IE does not like an empty box; without this it won't show the contentContainer
          if ($$.html() == "") $$.html('&nbsp;');
                    
          // Append contentContainer
          $$.wrapInner(contentContainer);          
          $$.prepend(this.shell);
                   
          // Because of this method of doing the corners we have magins above and below; the following prevents margin collapsing.
          $$.after('<div class="clear" style="height:0;line-height:0px;">&nbsp;</div>');
      }		
		
		/*
		This function draws the pixels
		*/	
		function drawPixel( intx, inty, colour, transAmount, height, newCorner, image, cornerRadius, isBorder, bgImage, x_width, x_height, x_bw, repeat ) {
			
			//var $$ = $(box);			
			
		    var pixel = document.createElement("div");
		    
		    $(pixel).css({	
		    	"height" :			height, 
		    	"width" :			"1px", 
		    	"position" :		"absolute", 
		    	"font-size" :		"1px", 
		    	"overflow" :		"hidden",
		    	"top" :				inty + "px",
		    	"left" :			intx + "px",
		    	"background-color" :colour
		    });
		    
		    // Max Top Radius
		    var topMaxRadius = Math.max(settings.tl ? settings.tl.radius : 0, settings.tr ? settings.tr.radius : 0);
		    
		    // Dont apply background image to border pixels
			if(image == -1 && bgImage !="")
			{
				$(pixel).css({
					"background-position":"-" + (x_width - (cornerRadius - intx) + x_bw) + "px -" + ((x_height + topMaxRadius + inty) -x_bw) + "px",
					"background-image":bgImage,
					"background-repeat":repeat					 
				});
			}
			else
			{
				if (!isBorder) $(pixel).addClass('hasBackgroundColor');
			}		    
		    if (transAmount != 100)
		    	$(pixel).css({opacity: (transAmount/100) });

		    newCorner.appendChild(pixel);
		};		
				
		
		// Utilities
		function BlendColour(Col1, Col2, Col1Fraction) 
		{
			
			var red1 = parseInt(Col1.substr(1,2),16);
			var green1 = parseInt(Col1.substr(3,2),16);
			var blue1 = parseInt(Col1.substr(5,2),16);
			var red2 = parseInt(Col2.substr(1,2),16);
			var green2 = parseInt(Col2.substr(3,2),16);
			var blue2 = parseInt(Col2.substr(5,2),16);
			
			if(Col1Fraction > 1 || Col1Fraction < 0) Col1Fraction = 1;
			
			var endRed = Math.round((red1 * Col1Fraction) + (red2 * (1 - Col1Fraction)));
			if(endRed > 255) endRed = 255;
			if(endRed < 0) endRed = 0;
			
			var endGreen = Math.round((green1 * Col1Fraction) + (green2 * (1 - Col1Fraction)));
			if(endGreen > 255) endGreen = 255;
			if(endGreen < 0) endGreen = 0;
			
			var endBlue = Math.round((blue1 * Col1Fraction) + (blue2 * (1 - Col1Fraction)));
			if(endBlue > 255) endBlue = 255;
			if(endBlue < 0) endBlue = 0;
			
			return "#" + IntToHex(endRed)+ IntToHex(endGreen)+ IntToHex(endBlue);
			
		}
	
		function IntToHex(strNum) 
		{			
			rem = strNum % 16;
			base = Math.floor(strNum / 16);
			
			baseS = MakeHex(base);
			remS = MakeHex(rem);
			
			return baseS + '' + remS;
		}
	
		function MakeHex(x)
		{
		  if((x >= 0) && (x <= 9))
		  {
		      return x;
		  }
		  else
		  {
		      switch(x)
		      {
		          case 10: return "A";
		          case 11: return "B";
		          case 12: return "C";
		          case 13: return "D";
		          case 14: return "E";
		          case 15: return "F";
		      }
		  }
		}
	
		/*
		For a pixel cut by the line determines the fraction of the pixel on the 'inside' of the
		line.  Returns a number between 0 and 1
		*/
		function pixelFraction(x, y, r)
		{
			var pixelfraction = 0;
			
			/*
			determine the co-ordinates of the two points on the perimeter of the pixel that the
			circle crosses
			*/
			var xvalues = new Array(1);
			var yvalues = new Array(1);
			var point = 0;
			var whatsides = "";
			
			// x + 0 = Left
			var intersect = Math.sqrt((Math.pow(r,2) - Math.pow(x,2)));
			
			if ((intersect >= y) && (intersect < (y+1)))
			{
				whatsides = "Left";
				xvalues[point] = 0;
				yvalues[point] = intersect - y;
				point =  point + 1;
			}
			// y + 1 = Top
			var intersect = Math.sqrt((Math.pow(r,2) - Math.pow(y+1,2)));
			
			if ((intersect >= x) && (intersect < (x+1)))
			{
				whatsides = whatsides + "Top";
				xvalues[point] = intersect - x;
				yvalues[point] = 1;
				point = point + 1;
			}
			// x + 1 = Right
			var intersect = Math.sqrt((Math.pow(r,2) - Math.pow(x+1,2)));
			
			if ((intersect >= y) && (intersect < (y+1)))
			{
				whatsides = whatsides + "Right";
				xvalues[point] = 1;
				yvalues[point] = intersect - y;
				point =  point + 1;
			}
			// y + 0 = Bottom
			var intersect = Math.sqrt((Math.pow(r,2) - Math.pow(y,2)));
			
			if ((intersect >= x) && (intersect < (x+1)))
			{
				whatsides = whatsides + "Bottom";
				xvalues[point] = intersect - x;
				yvalues[point] = 0;
			}
			
			/*
			depending on which sides of the perimeter of the pixel the circle crosses calculate the
			fraction of the pixel inside the circle
			*/
			switch (whatsides)
			{
			      case "LeftRight":
			      pixelfraction = Math.min(yvalues[0],yvalues[1]) + ((Math.max(yvalues[0],yvalues[1]) - Math.min(yvalues[0],yvalues[1]))/2);
			      break;
			
			      case "TopRight":
			      pixelfraction = 1-(((1-xvalues[0])*(1-yvalues[1]))/2);
			      break;
			
			      case "TopBottom":
			      pixelfraction = Math.min(xvalues[0],xvalues[1]) + ((Math.max(xvalues[0],xvalues[1]) - Math.min(xvalues[0],xvalues[1]))/2);
			      break;
			
			      case "LeftBottom":
			      pixelfraction = (yvalues[0]*xvalues[1])/2;
			      break;
			
			      default:
			      pixelfraction = 1;
			}
			
			return pixelfraction;
		}
  
  
		// This function converts CSS rgb(x, x, x) to hexadecimal
		function rgb2Hex(rgbColour)
		{
			try{
			
				// Get array of RGB values
				var rgbArray = rgb2Array(rgbColour);
				
				// Get RGB values
				var red   = parseInt(rgbArray[0]);
				var green = parseInt(rgbArray[1]);
				var blue  = parseInt(rgbArray[2]);
				
				// Build hex colour code
				var hexColour = "#" + IntToHex(red) + IntToHex(green) + IntToHex(blue);
			}
			catch(e){			
				alert("There was an error converting the RGB value to Hexadecimal in function rgb2Hex");
			}
			
			return hexColour;
		}
		
		// Returns an array of rbg values
		function rgb2Array(rgbColour)
		{
			// Remove rgb()
			var rgbValues = rgbColour.substring(4, rgbColour.indexOf(")"));
			
			// Split RGB into array
			var rgbArray = rgbValues.split(", ");
			
			return rgbArray;
		}	

		// Formats colours
		function format_colour(colour)
		{
			var returnColour = "#ffffff";
			
			// Make sure colour is set and not transparent
			if(colour != "" && colour != "transparent")
			{
				// RGB Value?
				if(colour.substr(0, 3) == "rgb")
				{
				  // Get HEX aquiv.
				  returnColour = rgb2Hex(colour);
				}
				else if(colour.length == 4)
				{
				  // 3 chr colour code add remainder
				  returnColour = "#" + colour.substring(1, 2) + colour.substring(1, 2) + colour.substring(2, 3) + colour.substring(2, 3) + colour.substring(3, 4) + colour.substring(3, 4);
				}
				else
				{
				  // Normal valid hex colour
				  returnColour = colour;
				}
			}
			
			return returnColour;
		}
		
		// Removes 'px' from string
		function strip_px(value) 
		{
			if (typeof(value)!='string') return value;
			return parseInt((( value != "auto" && value.indexOf("%") == -1 && value != "" && value.indexOf("px") !== -1)? Math.round(value.slice(0, value.indexOf("px"))) : 0))
		}
			
	};
})(jQuery);