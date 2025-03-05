
function FFBlurBack1(clip source,int "width",int "height",float "out_aspect_ratio",int "origin")
{
	return source.Crop(430,310,100,100).AverageBlur(radY=10,radC=10).Tweak(Bright=20).LanczosResize(1280,720).ConvertToYUY2().Layer(source.ConvertToYUY2,"add",x=160,y=0).ConvertToYV12
}

function FFImage_Source2(string "source",float "fps")
{
	#图像文件路径
	source      = default(source,"")
	#帧率
	fps			= default(fps,25)
	
	f=ImageSource(file=source,fps=25,end=0,use_DevIL=false).ConvertToYV12().LanczosResize(960,720)

	return f
}

#根据输出视频长宽比、分辨率以及输入视频形成虚化背景的输出视频
function FFBlurBack(clip source,int "width",int "height",float "out_aspect_ratio",int "origin")
{
	w = width(source)
	h = height(source)
	in_aspect_ratio=float(w)/float(h)
	#是否需要重新调整source大小标识
	flag =((origin==0&&absf(out_aspect_ratio-in_aspect_ratio)>0.1)||(origin==1&&(w>width||h>height)))?true:false
	f=(flag?FFImage_Scale(source,in_aspect_ratio,width,height):source)
	
	w = flag?width(f):w
	h = flag?height(f):h
	
	width=(width!=0)?width:w
	height=(height!=0)?height:h
	x=(width-w)/2
	y=(height-h)/2
	x=(x%2==0?x:x-1)
	y=(y%2==0?y:y-1)
	
	flag=(origin==1&&(w!=width||h!=height))?true:flag
	
	f=(flag?FFOverlayAndBlur(f,width,height,x,y):((width!=w||height!=h)?LanczosResize(f, width, height):f))
	
	return f
}

#根据输出视频长宽比、分辨率以及输入视频形成单一背景的输出视频
function FFSingleBack(clip source,clip background,int "width",int "height",float "out_aspect_ratio",int "origin")
{
	w = width(source)
	h = height(source)
	in_aspect_ratio=float(w)/float(h)
	#是否需要重新调整source大小标识
	flag =((origin==0&&absf(out_aspect_ratio-in_aspect_ratio)>0.1)||(origin==1&&(w>width||h>height)))?true:false
	f=(flag?FFImage_Scale(source,in_aspect_ratio,width,height):source)
	
	w = flag?width(f):w
	h = flag?height(f):h
	
	width=(width!=0)?width:w
	height=(height!=0)?height:h
	x=(width-w)/2
	y=(height-h)/2
	x=(x%2==0?x:x-1)
	y=(y%2==0?y:y-1)
	
	flag=(origin==1&&(w!=width||h!=height))?true:flag
	
	f=(flag?FFOverlay(background,f,x,y):((width!=w||height!=h)?LanczosResize(f, width, height):f))
	
	return f
}

#背景图像填充效果
function FFImageFillBack(string "source",float "fps",int "width",int "height")
{
	f=FFImage_Source(source,fps)
	w = width(f)
	h = height(f)
	in_aspect_ratio=float(w)/float(h)
	out_aspect_ratio=float(width)/float(height)
	
	flag =absf(out_aspect_ratio-in_aspect_ratio)>0.1?true:false

	f=(flag?FFImage_Crop(f,out_aspect_ratio,w,h):f)
	
	w = width(f)
	h = height(f)
	
	width=(width!=0)?width:w
	height=(height!=0)?height:h
	
	flag =(w!=width||h!=height)?true:false
	
	f=(flag?LanczosResize(f, width, height):f)
	
	return f
}

#背景图像拉伸效果
function FFImageStrechBack(string "source",float "fps",int "width",int "height")
{
	f=FFImage_Source(source,fps)
	
	f=LanczosResize(f, width, height)
	
	return f
}

#通过（图像、分辨率、帧率）形成图像序列
function FFImage_Source(string "source",float "fps")
{
	#图像文件路径
	source      = default(source,"")
	#帧率
	fps			= default(fps,25)
	
	f=ImageSource(file=source,fps=fps,end=0,use_DevIL=false)
	w=width(f)
	h=height(f)
	f=((w%2!=0||h%2!=0)?LanczosResize(f, w%2==0?w:w-1, h%2==0?h:h-1):f)
	f=ConvertToYV12(f)

	return f
}


#根据输出分辨率以及输出图像的宽高比，求前景图像的分辨率
function FFImage_Scale(clip source,float "in_aspect_ratio",int "out_width",int "out_height")
{
  width=Int(out_height*in_aspect_ratio)
  height=Int(out_width / in_aspect_ratio)
  
  height=(width<=out_width?out_height:height)
  width=(height==out_height?width:out_width)
  
  width=width%2==0?width:width-1
  height=height%2==0?height:height-1
  
  f=LanczosResize(source, width, height)

  return f
}

#根据输出分辨率以及输出图像的宽高比，求前景图像的分辨率
function FFImage_Crop(clip source,float "out_aspect_ratio",int "in_width",int "in_height")
{
  width=Int(in_height*out_aspect_ratio)
  height=Int(in_width / out_aspect_ratio)
  
  height=(width<=in_width?in_height:height)
  width=(height==in_height?width:in_width)
  
  width=width%2==0?width:width-1
  height=height%2==0?height:height-1
  
  y=(in_height-height)/2
  x=(in_width-width)/2
  
  x=x%2==0?x:x-1
  y=y%2==0?y:y-1
  
  #Crop(f, x, y, w<100?w:100, h<100?h:100)
  f=Crop(source, x, y, width, height)

  return f
}

#顺时针90度
function FFImage_Rotate90FlipNone(clip source)
{
	return TurnRight(source)
}

#旋转180度
function FFImage_Rotate180FlipNone(clip source)
{
	return Turn180(source)
}

#逆时针90度
function FFImage_Rotate270FlipNone(clip source)
{
	return TurnLeft(source)
}

#水平翻转
function  RotateNoneFlipX(clip source)
{
	return FlipHorizontal(source)
}

#垂直翻转
function  RotateNoneFlipY(clip source)
{
	return FlipVertical(source)
}

#顺时针旋转90度，再水平翻转
function  Rotate90FlipX(clip source)
{
	f=TurnRight(source)
	return FlipHorizontal(f)
}

#顺时针旋转90度，再垂直翻转
function  Rotate90FlipY(clip source)
{
	f=TurnRight(source)
	return FlipVertical(f)
}

#模糊图像
function FFBlurImage(clip source,int "width",int "height")
{
	#宽
	width		=default(width,640)
	#高
	height		=default(height,480)
	
	#调亮20
	w=width(source)
	w=(w<=100?100:(w%2==0?w:w-1))
	h=height(source)
	h=(h<=100?100:(h%2==0?h:h-1))
	f=(w<=100||h<=100)?LanczosResize(source, w, h):source
	
	w=width(f)
	h=height(f)
    x=(w>100?w/2-50:0)
	y=(h>100?h/2-50:0)
	#y=h>100?h/2-50:0
	x=(x%2==0?x:x-1)
	y=(y%2==0?y:y-1)
	#width1=w>100?100:(w%4==0?w/2:w/2-1)
    #width1=w>100?100:(w%4==0?w:w-1)
	#height1=h>100?100:(h%4==0?h/2:h/2-1)
	#height1=h>100?100:(h%4==0?h:h-1)
	f=Crop(f, x, y, w<100?w:100, h<100?h:100)
	#模糊
	f=(w>100&&h>100?averageblur(f,10,10):f)
	f=f.Tweak(Bright=20)
	f=LanczosResize(f, width, height)
	return f
}

#重叠视频
function FFOverlay(clip clip, clip overlay, int "x", int "y")
{
	#x
	x		=default(x,0)
	#y
	y		=default(y,0)
	
	#f=Overlay(clip,overlay,x,y)
	f=Layer(clip.ConvertToYUY2,overlay.ConvertToYUY2,"add",x=x,y=y).ConvertToYV12
	return f
}

#重叠模糊视频
function FFOverlayAndBlur(clip over, int "back_width",int "back_height", int "x", int "y")
{
	#背景图像宽
	back_width=default(back_width,856)
	#背景图像高
	back_height=default(back_height,480)
	#前景在背景中的x坐标
	x		=default(x,108)
	#前景在背景中的y坐标
	y		=default(y,0)
	
	#模糊源图像
	f=FFBlurImage(over,back_width,back_height)
	#模糊图像与原图重叠
	f=FFOverlay(f,over,x,y)

	return f
}

#创建黑色视频序列
function FFBlackClip(int "frame_num",float "fps",int "width",int "height")
{
	#帧数
	frame_num	= default(frame_num,25)
	#帧率
	fps			= default(fps,25)
	#宽
	width		=default(width,640)
	#高
	height		=default(height,480)
	
	f=BlankClip(length=frame_num, width=width, height=height, fps=fps,pixel_type="YV12")
	
	f=KillAudio(f)
	#f=ConvertToYV12(f)
	return f
}

#创建纯色背景
function FFPureColorClip(int "frame_num",float "fps",int "width",int "height",int "color")
{
	#帧数
	frame_num	= default(frame_num,1)
	#帧率
	fps			= default(fps,25)
	#宽
	width		=default(width,640)
	#高
	height		=default(height,480)
	#颜色
	color       =default(color,$000000)
	
	f=BlankClip(length=frame_num, width=width, height=height, fps=fps,pixel_type="YV12",color=color)
	
	f=KillAudio(f)
	#f=ConvertToYV12(f)
	return f
}

#合并音视频
function FFMergeAudioVideo(clip video,clip audio,float "start",float "duration")
{
	#开始时间
	start		= default(start,0)
	#时长
	duration	= default(duration,60)
	
	try 
	{
		a=audio.AudioTrim1(start,duration)
	}
	catch(err_msg) 
	{
		a=audio
	}
	
	return AudioDubEx(video,a)
}

#加载音频文件
function FFAudioSource(string "source")
{
	#音频文件路径
	source      = default(source,"")

	a=BassAudioSource(source)
	#a=AssumeSampleRate(a,44100)
	
	return a
}

#重复视频
function FFLoopVideo(clip video,int "loop_times")
{
	#重复次数
	loop_times		= default(loop_times,1)
	
	video=loop(video,loop_times)
	return video
}

#重复音频
function FFLoopAudio(clip audio,int "loop_times")
{
	#重复次数
	loop_times		= default(loop_times,1)
	
	a=loop(audio,loop_times)
	return a
}


#通过（图像、分辨率、帧率）形成图像序列
function FFImage_Source1(string "source",float "fps",int "width",int "height")
{
	#图像文件路径
	source      = default(source,"")
	#帧率
	fps			= default(fps,25)
	#宽
	width		= default(width,0)
	#高
	height		= default(height,0)
	
	f=ImageReader(file=source,fps=fps,end=0)
	w = width(f)
	h = height(f)
	
	width=(width!=0)?width:w
	height=(height!=0)?height:h
	f=(width!=w||height!=h)?LanczosResize(f, width, height):f
	f=ConvertToYV12(f)
	
	return f
}









 

