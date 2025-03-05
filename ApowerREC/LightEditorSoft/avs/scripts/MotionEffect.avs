function FFImage_Move(clip base_clip,clip over_clip,int "x",int "y")
{
	#crop_x=x<0?-x:0
	#crop_y=y<0?-y:0
	#crop_w=(x<0 ? over_clip.width+x : x>base_clip.width-over_clip.width ? base_clip.width-x:over_clip.width)
	#crop_h=(y<0 ? over_clip.height+y : y>base_clip.height-over_clip.height ? base_clip.height-y:over_clip.height)
	
	#over_clip=((crop_w<=0||crop_h<=0||(crop_w==over_clip.width&&crop_h==over_clip.height)) ? over_clip : over_clip.Crop(crop_x,crop_y,crop_w,crop_h))
	#((crop_w!=over_clip.width||crop_h!=over_clip.height) ? over_clip.Crop(crop_x,crop_y,crop_w,crop_h) : over_clip)
	
	#crop_w<=0||crop_h<=0?base_clip:Layer(base_clip,over_clip,x=x<0?0:x,y=y<0?0:y)
	Layer(base_clip,over_clip,x=x,y=y)
}

function FFImage_Rotate(clip base_clip,clip over_clip,int "deg",int "x",int "y")
{
  over_clip=over_clip.Rotate(deg)
  Layer(base_clip,over_clip,x=x,y=y)
}


function FFImage_Zoom_tiny(clip base_clip,clip over_clip,int "x",int "y", int "width", int "height")
	{
		over_clip=over_clip.BilinearResize(width,height)
		Layer(base_clip,over_clip,x=x,y=y)
	}


function FFImage_ZoomIn(clip base_clip,clip over_clip,float "ZoomFactor",int "x",int "y")
{
  over_clip=over_clip.ZoomBox(zoomFactor=zoomFactor)
  Layer(base_clip,over_clip,x=x,y=y)
}
function FFImage_Zoom(clip base_clip,clip over_clip,float "ZoomFactor",int "w",int "h",int "x",int "y")
{
  over_clip=over_clip.ZoomBox(width=w,height=h,zoomFactor=zoomFactor)
  #over_clip=over_clip.LanczosResize(w,h)
  Layer(base_clip,over_clip,x=x,y=y)
}

function FFImage_Roll(clip base_clip,clip over_clip,int "x",int "y",int "crop_x",int "crop_y",int "crop_w",int "crop_h" )#,int "crop_x",int "crop_y",int "crop_w",int "crop_h" 
{
	over_clip=((crop_w==0||crop_h==0||(crop_w==over_clip.width&&crop_h==over_clip.height)) ? over_clip : over_clip.Crop(crop_x,crop_y,crop_w,crop_h))	
	crop_w==0||crop_h==0?base_clip:Layer(base_clip,over_clip,x=x,y=y)
}

function FFImage_Sin(clip base_clip,clip over_clip,float "angle",int "x",int "height")
{
	y=sin(angle)
	y=Int(height/2*(1-absf(y)))
	#y=Int(height/2*(1-y))
	Layer(base_clip,over_clip,x=x,y=y)
}