# KenBurnsEffect() - May 27th, 2009
#  Given a clip, zooms and pans clip with the Ken Burns Effect.
# 
# Requirements:
#  zoom.dll
#   http://forum.doom9.org/showthread.php?t=49429				-Original zoom thread
#   http://avisynth.org/warpenterprises/files/zoom_25_dll_20050122.zip		-Direct Download
#  CalcBox(), ZoomBoxIt()
#   http://forum.doom9.org/showthread.php?p=1111789#post1111789
# 
# Inputs:
#  clip c: input clip, needs to be RGB32() if useZoomBox = 0 or 1
# Optional Parameters:
## <Starting Position> ##
#  Mode 2 - Starting Alignment:
#   int startAlign: -9 to +9 (0=Do not use Align). Positive values - fit with no black borders, may crop clip. Negative values - fit with black borders, may letterbox clip.
#                1:top left.     2:top center.     3:top right. 
#                4:middle left.  5:middle center.  6:middle bottom. 
#                7:bottom left.  8:bottom center.  9:bottom right.
#
#  Mode 1 - Starting Box:
#   float startX1: upper left x cord
#   float startY1: upper left y cord
#   float startX2: lower right x cord
#   float startY2: lower right y cord
#               3 or 4 out of 4 points must be defined when using Mode 1
#               when omitting a single point, it will calculate the missing value, with the Aspect Ratio in mind.
#  
#  float startZoomFactor: 100 = 100%, ect... 
#                      Negative values is the zoom of the pixels, positive values is the zoom of the frame. 
#                      When converting AR, this isn't perfect.
#  float startPanX: shift the clip x pixels. Value in source pixels. - left, + right
#  float startPanY: shift the clip x pixels. Value in source pixels. - up, + down
#  float startAngle: Rotate clip so many degrees. Positive is Clockwise.
## </Starting Position> ##
#
## <Ending Position> ##
#  Mode 2 - Ending Alignment:
#   int endAlign: -9 to +9 (0=Do not use Align). Positive values - fit with no black borders, may crop clip. Negative values - fit with black borders, may letterbox clip.
#                1:top left.     2:top center.     3:top right. 
#                4:middle left.  5:middle center.  6:middle bottom. 
#                7:bottom left.  8:bottom center.  9:bottom right.
#
#  Mode 1 - Ending Box:
#   float endX1: upper left x cord
#   float endY1: upper left y cord
#   float endX2: lower right x cord
#   float endY2: lower right y cord
#               3 or 4 out of 4 points must be defined when using Mode 1
#               when omitting a single point, it will calculate the missing value, with the Aspect Ratio in mind.
#  
#  float endZoomFactor: 100 = 100%, ect... 
#                      Negative values is the zoom of the pixels, positive values is the zoom of the frame. 
#                      When converting AR, this isn't perfect.
#  float endPanX: shift the clip x pixels. Value in source pixels. - left, + right
#  float endPanY: shift the clip x pixels. Value in source pixels. - up, + down
#  float endAngle: Rotate clip so many degrees. Positive is Clockwise.
## </Ending Position> ##
#
#  int width: Output Width
#  int height: Output Height
#  int startFrame: starting frame of pan and zoom
#  int endFrame: ending frame of pan and zoom
#  bool KeepState: If using start/end Frame, it keeps the clip at the start & end zoom level. Default = true
#  string ResizeMethod: name of resize function. Default = BilinearResize
#  float SourceDAR: Display Aspect Ratio of the Source. If 0 then it uses the source aspect ratio.
#  float TargetDAR: Display Aspect Ratio of the Target. Useful for DVD's. If 0 then it uses the source aspect ratio.
#
#  int useZoomBox: 0 - Never, 1 - for static parts, 2 - for everything. default 2
#  float Speed: 1 is "normal". For high quality set to something like 0.25. For speed set to 5+. Relevant if useZoomBox=0 or 1.
#  int cubic: Type of zoom, pan & rotate.
#  int cubicX: Type of pan in the x direction.
#  int cubicY: Type of pan in the y direction.
#  int cubicA: Type of rotation.
#  int cubicZ: Type of zoom.
#  int color: Color of letterbox border. Default: $000000 (Black). Irrelevant if useZoomBox=0 or 1.
# 
# 
# Notes:
#  Clip should be deinterlaced for best visual quality.
#  Aspect ratio for output and box(x1,y1,x2,y2) should be the same, unless you want to distort the clip.
#  The aspect ratio for the 2 boxes as well as the output should to be the same.
#  Default behavior is to center clip by adding borders (Align=-5).
#  If you specify Align (Mode 2) and x1,y1,x2,y2 (Mode 1), Mode 1 will be used and the align will control the position of the zoomFactor.
#  Mode 1 (x1,y1,x2,y2) can take values from a crop operation. x2 and y2 must be negative though; so if x2 or y2 equals 0, replace 0 with -0.00001.

function KenBurnsEffect(clip c, 
\ int "startAlign", float "startX1", float "startY1", float "startX2", float "startY2", float "startZoomFactor", float "startPanX", float "startPanY", float "startAngle",
\ int   "endAlign", float   "endX1", float   "endY1", float   "endX2", float   "endY2", float   "endZoomFactor", float   "endPanX", float   "endPanY", float   "endAngle",
\ int "width", int "height", int "StartFrame", int "EndFrame", bool "KeepState", string "ResizeMethod", float "SourcePAR", float "SourceDAR", float "TargetPAR", float "TargetDAR",
\ int "useZoomBox", float "speed", int "cubic", int "cubicX", int "cubicY", int "cubicA", int "cubicZ", int "color")
{
	#Set Defaults
	startAlign = Default(startAlign, -5)
	endAlign = Default(endAlign, -5)
	startZoomFactor = Default(startZoomFactor, 100.0)
	endZoomFactor = Default(endZoomFactor, 100.0)
	startPanX = Default(startPanX, 0.0)
	startPanY = Default(startPanY, 0.0)
	endPanX = Default(endPanX, 0.0)
	endPanY = Default(endPanY, 0.0)
	startAngle = Default(startAngle, 0.0)
	endAngle = Default(endAngle, 0.0)
	width = Default(width, c.width())
	height = Default(height, c.height())
	length = c.framecount()-1
	StartFrame = Default(StartFrame, 0)
	EndFrame = Default(EndFrame, length)
	KeepState = Default(KeepState, True)
	ResizeMethod = Default(ResizeMethod, "BilinearResize")
	SourceAR = float(c.width())/float(c.height())
	TargetAR = float(width)/float(height)
	useZoomBox = Default(useZoomBox, 2)
	speed = Default(speed, 1)
	cubic = Default(cubic, 0)
	cubicX = Default(cubicX, cubic)
	cubicY = Default(cubicY, cubic)
	cubicZ = Default(cubicZ, cubic)
	cubicA = Default(cubicA, cubic)
	color = Default(color, $000000)
	
	#Calculate Defaults
	modzoom = Max(float(c.width())/float(width),float(c.height())/float(height))
	startZoomFactor = startZoomFactor<0 ? (absf(startZoomFactor)/100.0)*modzoom : (absf(startZoomFactor)/100.0)
	endZoomFactor = endZoomFactor<0 ? (absf(endZoomFactor)/100.0)*modzoom : (absf(endZoomFactor)/100.0)
	
	#Check For Any Unreasonable Inputs
	Assert1(startZoomFactor<>0, "KenBurnsEffect: startZoomFactor can not be zero.")
	Assert1(endZoomFactor<>0, "KenBurnsEffect: endZoomFactor can not be zero.")
	Assert1((Defined(startX1) && Defined(startY1) && (Defined(startX2) || Defined(startY2))) || !(Defined(startX1) && Defined(startY1) && Defined(startX2) && Defined(startY2)), "KenBurnsEffect: when using Mode 1, you must define startX1,startY1, startX2 and/or startY2")
	Assert1((Defined(endX1) && Defined(endY1) && (Defined(endX2) || Defined(endY2))) || !(Defined(endX1) && Defined(endY1) && Defined(endX2) && Defined(endY2)), "KenBurnsEffect: when using Mode 1, you must define endX1,endY1, endX2 and/or endY2")
	Assert1(startAlign<9 || startAlign>-9, "KenBurnsEffect: startAlign [" + String(startAlign) + "] should be between -9 and 9.")
	Assert1(endAlign<9 || endAlign>-9, "KenBurnsEffect: endAlign [" + String(endAlign) + "] should be between -9 and 9.")
	Assert1(IsRGB32(c) || useZoomBox==2, "KenBurnsEffect: Clip Needs To Be RGB32. Use ConvertToRGB32() or set useZoomBox=2")
	Assert1(!((cubic>0 || cubicX>0 || cubicY>0 || cubicZ>0 || cubicA>0) && useZoomBox==2), "KenBurnsEffect: Can not use the Cubic option when useZoomBox=2. Set useZoomBox to 0 or 1 or don't use cubic.")
	Assert1(endFrame-startFrame<=length, "KenBurnsEffect: Transition length[" + String(endFrame-startFrame) + "] greater then clip lenght[" + String(length) + "]")
	Assert1(startFrame<endFrame, "KenBurnsEffect: Starting Frame[" + String(startFrame) + "] greater then Ending Frame[" + String(endFrame) + "]")
	#Assert(useZoomBox == 0 && !(startAngle == 0), "KenBurnsEffect: You must set useZoomBox=0, if using startAngle [" + String(startAngle) + "]")
	#Assert(useZoomBox == 0 && !(endAngle == 0), "KenBurnsEffect: You must set useZoomBox=0, if using endAngle [" + String(endAngle) + "]")
	
	
	#Do Some Magic
	Evals (CalcBox(c, 2, width, height, TargetAR, SourceAR, startZoomFactor, startPanX, startPanY, startAlign, startX1, startY1, startX2, startY2, SourcePAR, SourceDAR, TargetPAR, TargetDAR))
	Evals (CalcBox(c, 3, width, height, TargetAR, SourceAR, endZoomFactor, endPanX, endPanY, endAlign, endX1, endY1, endX2, endY2, SourcePAR, SourceDAR, TargetPAR, TargetDAR))
	
	
	#Check For Any Unreasonable Inputs
	Assert1(startX1<startX2, "KenBurnsEffect: Start X1[" + String(startX1) + "] point larger then Start X2 Point[" + String(startX2) + "]")
	Assert1(startY1<startY2, "KenBurnsEffect: Start Y1[" + String(startY1) + "] point larger then Start Y2 Point[" + String(startY2) + "]")
	Assert1(endX1<endX2, "KenBurnsEffect: End X1[" + String(endX1) + "] point larger then End X2 Point[" + String(endX2) + "]")
	Assert1(endY1<endY2, "KenBurnsEffect: End Y1[" + String(endY1) + "] point larger then End Y2 Point[" + String(endY2) + "]")	

	
	#non pan frames 
	start = useZoomBox>0 && startFrame>0 ? KeepState ? c.Trim1(0, -startFrame).ZoomBoxIt(width, height, ResizeMethod, startX1, startY1, startX2, startY2, color) : c.Trim1(0, -startFrame) : nop()
	end = useZoomBox>0 && endFrame<length ? KeepState ? c.Trim1(endFrame+1, 0).ZoomBoxIt(width, height, ResizeMethod, endX1, endY1, endX2, endY2, color) : c.Trim1(endFrame+1, 0) : nop()
	#zoom and pan frames
	cAlt = c.Trim1(startFrame, endFrame)
	cAlt = useZoomBox==2 ? Animate2(0, cAlt.framecount()-1, "ZoomBoxIt", cAlt, width, height, ResizeMethod, float(startX1),float(startY1), float(startX2),float(startY2), color, cAlt, width, height, ResizeMethod, float(endX1),float(endY1),  float(endX2),float(endY2), color) :nop()

	
	#add in static frames
	cAlt = useZoomBox==2 && startFrame>0 ? start + cAlt : cAlt
	cAlt = useZoomBox==2 && endFrame<length ? cAlt + end : cAlt
	
	#get center of start rectangle from first box
	startCenterX = startX1+((startX2-startX1)/2.0)-0.5
	startCenterY = startY1+((startY2-startY1)/2.0)-0.5
	
	#get center of end rectangle from second box
	endCenterX = endX1+((endX2-endX1)/2.0)-0.5
	endCenterY = endY1+((endY2-endY1)/2.0)-0.5
	
	#Speed Logic pt 1 - Resize clip 
	width = float(width)/speed
	height = float(height)/speed	
	
	#get starting zoom factor from first box
	startZoomFactorX = width/float(startX2-startX1)
	startZoomFactorY = height/float(startY2-startY1)
	
	#get ending zoom factor from second box
	endZoomFactorX = width/float(endX2-endX1)
	endZoomFactorY = height/float(endY2-endY1)
	
	
	#Pan starting and ending x point
	srcxSE = SplineCalc(c, cubicX, startFrame, startCenterX, endFrame, endCenterX)
	
	#Pan starting and ending y point
	srcySE = SplineCalc(c, cubicY, startFrame, startCenterY, endFrame, endCenterY)
	
	#Zoom X
	factor_x_SE = SplineCalc(c, cubicZ, startFrame, startZoomFactorX, endFrame, endZoomFactorX)
	
	#Zoom Y
	factor_y_SE = SplineCalc(c, cubicZ, startFrame, startZoomFactorY, endFrame, endZoomFactorY)
	
	#Rotation
	angleSE = SplineCalc(c, cubicA, startFrame, startAngle, endFrame, endAngle)
	
	
	#non pan frames 
	start = useZoomBox==0 ? c.Zoom(srcx=String(startCenterX), srcy=String(startCenterY), factorx=String(startZoomFactorX), factory=String(startZoomFactorY), width=round(width), height=round(height), angle=String(startAngle)).Trim1(0, -startFrame) : start
	end = useZoomBox==0   ? c.Zoom(srcx=String(endCenterX), srcy=String(endCenterY), factorx=String(endZoomFactorX), factory=String(endZoomFactorY), width=round(width), height=round(height), angle=String(endAngle)).Trim1(endFrame+1, 0) : end
	
	#Do the zoom/pan
	c = useZoomBox<2 ? c.Zoom(srcx=srcxSE, srcy=srcySE, factorx=factor_x_SE, factory=factor_y_SE, width=round(width), height=round(height), angle=angleSE).Trim1(startFrame, endFrame) : nop()
	
	#speed Logic pt 2 - Scale back up or down depending on speed set
	c = useZoomBox==1 ? Evals(ResizeMethod + "(c, " + String(round(width*speed)) + ", " + String(round(height*speed)) + ")" ) : c
		
	#Add in static frames
	c = useZoomBox<2 && startFrame>0 ? start + c : c
	c = useZoomBox<2 && endFrame<length ? c + end : c
	
	#speed Logic pt 2 - Scale back up or down depending on speed set
	c = useZoomBox==0 ? Evals(ResizeMethod + "(c, " + String(round(width*speed)) + ", " + String(round(height*speed)) + ")" ) : c
	useZoomBox==2 ? cAlt :c
}

# ZoomBox() - June 12st, 2008
#  Put a "box" around a clip. Box can be used to zoom in or out. Accepts Any Colorspace. Can correct for DAR (Display Aspect Ratio).
# 
# 
# Inputs
#   clip c: Accepts Any Colorspace.
#  Optional Parameters:
#   int width: output width
#   int height: output height
#   string ResizeMethod: name of resize function. Default = BilinearResize
#   float ModAR: Set the Output Aspect Ratio. If 0 then it uses the source aspect ratio (needed for animate).
# 
#  Mode 2 - Align clip
#   int Align: -9 to +9 (0=Do not use Align). Positive values - fit with no black borders, may crop clip. Negative values - fit with black borders, may letterbox clip.
#                1:top left.     2:top center.     3:top right. 
#                4:middle left.  5:middle center.  6:middle bottom. 
#                7:bottom left.  8:bottom center.  9:bottom right.
# 
#  Mode 1 - Coordinates for ZoomBox:
#   float x1: upper left x cord
#   float y1: upper left y cord
#   float x2: lower right x cord
#   float y2: lower right y cord
#               3 or 4 out of 4 points must be defined when using Mode 1
#               when omitting a single point, it will calculate the missing value, with the Aspect Ratio in mind.
#  
#  float zoomFactor: 100 = 100%, ect... 
#                      Negative values is the zoom of the pixels, positive values is the zoom of the frame. 
#                      When converting AR, this isn't perfect.
#  float panX: shift the clip x pixels. Value in source pixels. - left, + right
#  float panY: shift the clip x pixels. Value in source pixels. - up, + down
#  int color: Color of letterbox border. Default: $000000 (Black).
# 
# 
# Notes
#  Clip should be deinterlaced for best visual quality.
#  Aspect ratio for output and box(x1,y1,x2,y2) should be the same, unless you want to distort the clip.
#  Default behavor is to center clip by adding borders (Align=-5).
#  Useful for resizing clip sources (like pictures) to match the dimension of another clip.
#  If you specify Align (Mode 2) and x1,y1,x2,y2 (Mode 1), Mode 1 will be used and the align will controll the position of the zoomFactor.
#  Mode 1 (x1,y1,x2,y2) can take values from a crop opperation. x2 and y2 must be negative though; so if x2 or y2 equals 0, replace 0 with -0.00001.

Function ZoomBox(clip c, int "width", int "height", string "ResizeMethod",
\ float "SourcePAR", float "SourceDAR", float "TargetPAR", float "TargetDAR",
\ int "Align", float "x1", float "y1", float "x2", float "y2", float "zoomFactor", float "panX", float "panY", 
\ int "color")
{
	#Set Defaults
	width = Default(width, c.width())
	height = Default(height, c.height())
	ResizeMethod = Default(ResizeMethod, "BilinearResize")
	SourceAR = float(c.width())/float(c.height())
	TargetAR = float(width)/float(height)
	Align = Default(Align, -5) #Align=-5 (center and add borders to fit).
	zoomFactor = Default(zoomFactor, 100.0)
	panX = Default(panX, 0)
	panY = Default(panY, 0)
	color = Default(color, $000000)

	modzoom = Max(float(c.width())/float(width),float(c.height())/float(height))
	zoomFactor = zoomFactor<0 ? (absf(zoomFactor)/100.0)*modzoom : (absf(zoomFactor)/100.0)
	
	#Check Inputs
	Assert1(zoomFactor<>0, "ZoomBox: zoomFactor can not be zero.")
	Assert1((Defined(x1) && Defined(y1) && (Defined(x2) || Defined(y2))) || !(Defined(x1) && Defined(y1) && Defined(x2) && Defined(y2)), "ZoomBox: when using Mode 1, you must define x1,y1, x2 and/or y2")
	Assert1(Align<9 || Align>-9, "ZoomBox: Align [" + String(Align) + "] should be between -9 and 9.")
	
	#Do Some Magic
	Evals (CalcBox(c, 1, width, height, TargetAR, SourceAR, zoomFactor, panX, panY, Align, x1, y1, x2, y2, SourcePAR, SourceDAR, TargetPAR, TargetDAR))

	BoxAR = float(x2-x1)/float(y2-y1)
	#Check for any unreasonable inputs before resize opperation
	Assert1(x1<x2, "ZoomBox: x1[" + String(x1) + "] point larger then x2 Point[" + String(x2) + "]")
	Assert1(y1<y2, "ZoomBox: y1[" + String(y1) + "] point larger then y2 Point[" + String(y2) + "]")
	

	ZoomBoxIt(c, width, height, ResizeMethod, x1, y1, x2, y2, color)
}

Function ZoomBoxIt(clip c, int width, int height, string ResizeMethod, float x1, float y1, float x2, float y2, int color)
{
	#Pad clip so resizer interpolates from border when zooming out.
	#Conditional Borders... only add if it's going to be used. Border size is size of input frame. Prevents "streaking" when zooming out alot.
	borderLeft   = x1 < 0 ? c.width()/2*2:0
	borderTop    = y1 < 0 ? c.height()/2*2:0
	borderRight  = x2 > c.width()/2*2 ? c.width()/2*2:0
	borderBottom = y2 > c.height()/2*2 ? c.height()/2*2:0
	c = c.AddBorders(borderLeft,borderTop,borderRight,borderBottom,color)
	
	#Do it! Yes there are only 2 lines that directly act upon the clip.
	Evals(ResizeMethod + "(c, " + String(round(width)) + ", " + String(round(height)) + ", src_left=" + String(x1+borderLeft) + ", src_top=" + String(y1+borderTop) + ", src_width=" + String(x2-x1) + ", src_height=" + String(y2-y1) + ")")	
}

Function CalcBox(clip c, int mode, int width, int height, float TargetAR, float SourceAR, float zoomFactor, float panX, float panY, float Align, float "x1", float "y1", float "x2", float "y2", float "SourcePAR", float "SourceDAR", float "TargetPAR", float "TargetDAR")
{
	#PAR/DAR Calculations
	SourceDAR = Defined(SourcePAR) ?
		\ SourcePAR==0 ? SourceAR : SourcePAR*SourceAR
	\ : Defined(SourceDAR) ? 
		\ SourceDAR==0 ? SourceAR : float(SourceDAR)
	\ : SourceAR
	TargetDAR =  Defined(TargetPAR) ?
		\ TargetPAR==0 ? TargetAR : TargetPAR*TargetAR
	\ : Defined(TargetDAR) ? 
		\ TargetDAR==0 ? TargetAR : float(TargetDAR)
	\ : TargetAR
	
	#Calc ModAR
	ModAR = SourceDAR*TargetAR/TargetDAR
	
	
	#If Align=5 or -5 then center clip. -5: Add borders. 5: Crop. "Mode 2"
	#Display Aspect Ratio = Final Output Ratio. No Change, Show All Pixels
	#Display Aspect Ratio > Final Output Ratio. Add Height or Crop Width 
	#Display Aspect Ratio < Final Output Ratio. Add Width or Crop Height 
	EvalString = 
	\   Align<>0 && ModAR==TargetAR ?
	\ "x1=0
	   x2=c.width()
	   y1=0
	   y2=c.height()"
	
	
	\ : (Align==-5 || Align==-4 || Align==-6) && ModAR>TargetAR ?
	\ "y1=0 - ((height*ModAR-width)/2.0)*(c.height()/float(width))
	   y2=c.height() + ((height*ModAR-width)/2.0)*(c.height()/float(width))
	   x1=0" + "
	   x2=c.width()"
	\ : (Align==5 || Align==2 || Align==8) && ModAR>TargetAR ?
	\ "x1=0 + ((height-width/ModAR)/2.0)*(c.width()/float(height))
	   x2=c.width() - ((height-width/ModAR)/2.0)*(c.width()/float(height))
	   y1=0
	   y2=c.height()" 
	\ : (Align==-5 || Align==-2 || Align==-8)  && ModAR<TargetAR ?
	\ "x1=0 - ((width/ModAR-height)/2.0)*(c.width()/float(height))
	   x2=c.width() + ((width/ModAR-height)/2.0)*(c.width()/float(height))
	   y1=0
	   y2=c.height()"
	\ : (Align==5 || Align==4 || Align==6)  && ModAR<TargetAR  ?
	\ "y1=0 + ((width-height*ModAR)/2.0)*(c.height()/float(width))
	   y2=c.height() - ((width-height*ModAR)/2.0)*(c.height()/float(width))
	   x1=0
	   x2=c.width()"
	
	
	\ : (Align==-1 || Align==-2 || Align==-3) && ModAR>TargetAR ?
	\ "y1=0
	   y2=c.height() + ((height*ModAR-width)/1.0)*(c.height()/float(width))
	   x1=0
	   x2=c.width()"
	\ : (Align==-1 || Align==-4 || Align==-7)  && ModAR<TargetAR ?
	\ "x1=0
	   x2=c.width() + ((width/ModAR-height)/1.0)*(c.width()/float(height))
	   y1=0
	   y2=c.height()"
	\ : (Align==-9 || Align==-8 || Align==-7) && ModAR>TargetAR ?
	\ "y1=0 - ((height*ModAR-width)/1.0)*(c.height()/float(width))
	   y2=c.height()
	   x1=0
	   x2=c.width()"
	\ : (Align==-9 || Align==-6 || Align==-3)  && ModAR<TargetAR ?
	\ "x1=0 - ((width/ModAR-height)/1.0)*(c.width()/float(height))
	   x2=c.width()
	   y1=0
	   y2=c.height()"
	
	
	\ : (Align==2 || Align==1 || Align==3) && ModAR<TargetAR  ?
	\ "y1=0
	   y2=c.height() - ((width-height*ModAR)/1.0)*(c.height()/float(width))
	   x1=0
	   x2=c.width()" 
	\ : (Align==8 || Align==7 || Align==9) && ModAR<TargetAR  ?
	\ "y1=0 + ((width-height*ModAR)/1.0)*(c.height()/float(width))
	   y2=c.height()
	   x1=0
	   x2=c.width()" 
	\ : (Align==4 || Align==1 || Align==7) && ModAR>TargetAR ?
	\ "x1=0
	   x2=c.width() - ((height-width/ModAR)/1.0)*(c.width()/float(height))
	   y1=0
	   y2=c.height()" 
	\ : (Align==6 || Align==3 || Align==9) && ModAR>TargetAR ?
	\ "x1=0 + ((height-width/ModAR)/1.0)*(c.width()/float(height))
	   x2=c.width()
	   y1=0
	   y2=c.height()"
	
	
	\ : ""
	Defined(x1) || Defined(y1) || Defined(x2) || Defined(y2) ? nop() : Evals(EvalString)

	#For non Align Input "Mode 1"
	x1tmp = Default(x1, 0)
	y1tmp = Default(y1, 0)
	x2tmp = Default(x2, c.width())
	y2tmp = Default(y2, c.height())
	
	#Take Crop Like Input
	x2tmp = x2tmp<=x1tmp && x2tmp<0 ? c.width() + x2tmp : x2tmp
	y2tmp = y2tmp<=y1tmp && y2tmp<0 ? c.height() + y2tmp : y2tmp
	
	#Set Optional parameters "Mode 1"
	test = 0
	test = Defined(x1) ? test+1 : test+0
	test = Defined(x2) ? test+1 : test+0
	test = Defined(y1) ? test+1 : test+0
	test = Defined(y2) ? test+1 : test+0
	Assert1(test>=3, "ZoomBox/KenBurnsEffect: At least 3 out of 4 x1, y1, x2, y2 points must be defined; or do not set any")
	
	y2t = !Defined(y2) && Defined(y1) && Defined(x1) && Defined(x2) ? y1tmp + ((x2tmp-x1tmp)/TargetAR)/(SourceAR/ModAR) : y2tmp
	x2t = !Defined(x2) && Defined(x1) && Defined(y1) && Defined(y2) ? x1tmp + ((y2tmp-y1tmp)*TargetAR)*(SourceAR/ModAR) : x2tmp
	y1t = !Defined(y1) && Defined(y2) && Defined(x1) && Defined(x2) ? y2tmp - ((x2tmp-x1tmp)/TargetAR)/(SourceAR/ModAR) : y1tmp
	x1t = !Defined(x1) && Defined(x2) && Defined(y1) && Defined(y2) ? x2tmp - ((y2tmp-y1tmp)*TargetAR)*(SourceAR/ModAR) : x1tmp
	
	#Calc Pan Factor
	x1 = x1t-panX
	y1 = y1t-panY
	x2 = x2t-panX
	y2 = y2t-panY
	
	#Calc Zoom Factor
	CenterX = (x2-x1)/2.0
	CenterY = (y2-y1)/2.0
	CenterY = (Align<0 && ModAR>TargetAR)? CenterY*(TargetAR/ModAR): (Align>0 && ModAR<TargetAR)? CenterY*(TargetAR/ModAR): CenterY 
	CenterX = (Align>0 && ModAR>TargetAR)? CenterX/(TargetAR/ModAR): (Align<0 && ModAR<TargetAR)? CenterX/(TargetAR/ModAR): CenterX
	
	Align = absf(Align)
	x1 = (Align==0 || Align==5 || Align==2 || Align==8) && zoomFactor<>1 ? CenterX-((CenterX-x1)/(zoomFactor)) : (Align==3 || Align==6 || Align==9) && zoomFactor<>1 ? CenterX*2.0-(CenterX*2.0-x1)/zoomFactor : x1
	y1 = (Align==0 || Align==5 || Align==4 || Align==6) && zoomFactor<>1 ? CenterY-((CenterY-y1)/(zoomFactor)) : (Align==7 || Align==8 || Align==9) && zoomFactor<>1 ? CenterY*2.0-(CenterY*2.0-y1)/zoomFactor : y1
	x2 = (Align==0 || Align==5 || Align==2 || Align==8) && zoomFactor<>1 ? CenterX+((x2-CenterX)/(zoomFactor)) : (Align==7 || Align==4 || Align==1) && zoomFactor<>1 ? 1.0/zoomFactor*CenterX+(x2-CenterX)/zoomFactor : x2
	y2 = (Align==0 || Align==5 || Align==4 || Align==6) && zoomFactor<>1 ? CenterY+((y2-CenterY)/(zoomFactor)) : (Align==3 || Align==2 || Align==1) && zoomFactor<>1 ? 1.0/zoomFactor*CenterY+(y2-CenterY)/zoomFactor : y2
	
	
	startString = "startX1=" + String(x1) + "
	startY1=" + String(y1) + "
	startX2=" + String(x2) + "
	startY2=" + String(y2) + ""
	
	endString = "endX1=" + String(x1) + "
	endY1=" + String(y1) + "
	endX2=" + String(x2) + "
	endY2=" + String(y2) + ""
	
	boxString = "x1=" + String(x1) + "
	y1=" + String(y1) + "
	x2=" + String(x2) + "
	y2=" + String(y2) + ""
	
	Return mode==1 ? boxString : mode==2 ? startString : mode==3 ? endString : ""
}


Function SplineCalc(clip c, int mode, int startFrame, float startF, int endFrame, float endF)
{
	splineString = mode==1 ?
	\ "spline(n, "
	\ + String(startFrame-1) + "," + String(startF) + ", "
	\ + String(startFrame) + "," + String(startF) + ", "
	\ + String(endFrame) + "," + String(endF) + ", "
	\ + String(endFrame+1) + "," + String(endF) + ", true)"
	
	\ : mode==2 ? "spline(n, "
	\ + String(startFrame) + "," + String(startF) + ", "
	\ + String(startFrame+(endFrame-startFrame)/3.0) + "," + String(startF) + ", "
	\ + String(endFrame-(endFrame-startFrame)/3.0) + "," + String(endF) + ", "
	\ + String(endFrame) + "," + String(endF) + ", true)"
	
	\ : mode==3 ? "spline(n, "
	\ + String(startFrame) + "," + String(startF) + ", "
	\ + String(startFrame+(endFrame-startFrame)/3.0) + "," + String(endF) + ", "
	\ + String(endFrame-(endFrame-startFrame)/3.0) + "," + String(startF) + ", "
	\ + String(endFrame) + "," + String(endF) + ", true)"
	
	\ : mode==4 ? "spline(n, "
	\ + String(startFrame) + "," + String(startF) + ", "
	\ + String((endFrame-startFrame)/2.0) + "," + String(startF) + ", "
	\ + String(endFrame) + "," + String(endF) + ", true)"
	
	\ : mode==5 ? "spline(n, "
	\ + String(startFrame) + "," + String(startF) + ", "
	\ + String((endFrame-startFrame)/2.0) + "," + String(endF) + ", "
	\ + String(endFrame) + "," + String(endF) + ", true)"
	
	\ : "spline(n, "
	\ + String(startFrame) + "," + String(startF) + ", "
	\ + String(endFrame) + "," + String(endF) + ", true)"
	Return splineString
}