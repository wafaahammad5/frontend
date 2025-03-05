Import("Motion.avs")
Import("zoom_pan.avs")
Import("transition.avs")
Import("filter.avs")
Import("overlay.avs")
Import("wm_text.avs")



SetMemoryMax(250)
#SetMemoryMax(round(SetMemoryMax(0)*2))

function Image_wx(string path, int "duration", int "width", int "height", string "format", int "angle", bool "hori", bool "vert", int "cache")
{	
    duration = Default(duration, 1)
    width = Default(width, FrameWidth)
	height = Default(height, FrameHeight)
	format = Default(format, "")
	duration = duration *FrameRate/20
   
	angle = Default(angle, 0)
	hori = Default(hori, false)
	vert = Default(vert, false)
    
    #ImageReader(path, fps = FrameRate, end = 0, width=width, height=height, use_DevIL = true, pixel_type = "RGB32").Loop(round(duration))
    rotate = (angle==90) ? 1
        \: (angle==180) ? 2
        \: (angle==270) ? 3
        \: 0
    flip_h = hori ? 8 : 0
    flip_v = vert ? 10 : 0
    WICImage(path, width=width, height=height, fps = FrameRate, rotate_flip = rotate + flip_h + flip_v, cache = cache).Loop(round(duration))
}

function Video_wx(string path, float "srcFrames", float "srcFps",float "clipStart", float "clipDuration", bool "flag", float "speed", bool "isMuted")
{
    clipStart = Default(clipStart, 0)
    clipDuration = Default(clipDuration, 0)
    speed = Default(speed, 1.0)
    isMuted = Default(isMuted, False)
    flag = Default(flag, false)

    #~ pair = flag == true ? lsopen(path, srcfps) : dshowopen(path, srcfps)
    

    #~ video= LWLibavVideoSource(path).ChangeFPS1(FrameRate)
    #~ audio= isMuted? BlankAudioOfVideo_wx(video):LWLibavAudioSource(path)
    video= FFVideoSource(path).ChangeFPS1(FrameRate)
    audio= isMuted? BlankAudioOfVideo_wx(video) : TinyAudio(path)
    audio=audio.ConvertAudioToFloat().ResampleAudio(SampleRate)

    audio = (ChannelLayout == "mono") ? audio.ConvertToMono()
    \: (audio.audiochannels >= 2) ? audio.GetChannel(1, 2)
    \: MonoToStereo(audio, audio)

    Video_wx1(video, audio, clipStart, clipDuration, speed, isMuted)
}

function Video_wx1(clip cv, clip ca, float "clipStart", float "clipDuration", float "speed", bool "isMuted")
{
    clipStart = Default(clipStart, 0)
    clipDuration = Default(clipDuration, 0)
    speed =Default(speed, 1.0)
    isMuted = Default(isMuted, False)

    v1 = cv
    a1 = ca

    v1 = (v1.framecount > 0) ? v1.Trim1(round(clipStart*FrameRate), round(-clipDuration*FrameRate)) : BlankVideo_wx(clipDuration*20, FrameWidth, FrameHeight)
    a1 = (a1.audiolength > 0) ? a1.AudioTrim1(clipStart,-clipDuration) : BlankAudio_wx(clipDuration*20)

    v1 = (speed == 1.0) ? v1 : v1.AssumeFPS(speed*FrameRate).ChangeFPS1(FrameRate)
    a1 = (speed == 1.0) ? a1 : a1.TimeStretch(tempo=speed*100,pitch=100)
    
  
    a1 = isMuted ? BlankAudioOfVideo_wx(a1) : a1

    vd = v1.framecount / v1.framerate
    a1 = a1.audioduration > vd ? a1.AudioTrim1(0, -vd)
        \: a1.audioduration < vd ? (a1 ++ BlankAudio_wx((vd - a1.audioduration + 1) * 20)).AudioTrim1(0, -vd)
        \: a1

    AudioDub(v1, a1)
}

##################################
## @ atrack  - audio track number. Default auto. If -2, ignore audio.
## @ fpsnum, fpsden - framerate. Default auto.
## @ stacked - if true, return Stack16 format.
##    (note, stacked=true requires a 16-bit color format)
## @ format  - force specified output pixel format. Default auto.
##    (see documentation for valid color formats)
##    (if stacked = true, default "YUV420P16")
## @ cache - if true (the default), create an index file.
##
function LibavSource2(string path, int "atrack", 
\          int "fpsnum", int "fpsden",
\          string "format", bool "stacked", bool "cache") 
{
    atrack   = Default(atrack, -1)
    fpsnum   = Default(fpsnum, 0)
    fpsden   = Default(fpsden,  1)
    stacked  = Default(stacked, false)
    cache    = Default(cache, true)

    format   = Default(format, "")

    FFmpegSource2(path, fpsnum=fpsnum, fpsden=fpsden, cache=cache, atrack=atrack)
}

function LibavOpen(string path, bool ismuted)
{ 
    ismuted   = Default(ismuted, false)
    #~ video= LWLibavVideoSource(path).ChangeFPS1(FrameRate)
    #~ audio= ismuted? BlankAudioOfVideo_wx(video):LWLibavAudioSource(path)
    video= FFVideoSource(path).ChangeFPS1(FrameRate)
    audio= ismuted? BlankAudioOfVideo_wx(video) : TinyAudio(path)
    audio= audio.ConvertAudioToFloat().ResampleAudio(SampleRate)
    audio = (ChannelLayout == "mono") ? audio.ConvertToMono()
    \: (audio.audiochannels >= 2) ? audio.GetChannel(1, 2)
    \: MonoToStereo(audio, audio)

    AudioDub(video,audio)
}

function LibavOpenA(string path)
{
    #~ source = LWLibavAudioSource(path)
    source = TinyAudio(path)

    a1 = source.KillVideo().ConvertAudioToFloat().ResampleAudio(SampleRate)
    a1 = (ChannelLayout == "mono") ? a1.ConvertToMono()
        \: (a1.audiochannels >= 2) ? a1.GetChannel(1, 2)
        \: MonoToStereo(a1, a1)

    a1
}

function Layer_Wx(clip c, string overpath, float c_start, float c_duration,  int x,int y,int w,int h, float over_start, float over_duration,int angleI, bool hori, bool vert, float angle, int sourcewidth, int sourceheight, string "mask", float "mask_x", float "mask_y", float "mask_w", float "mask_h", bool "mask_alpha_or_grayscale")
{
    v1 = LibavOpen(overpath,true)

    Layer_Wx1(c, v1, c_start, c_duration, x, y, w, h, over_start, over_duration, angleI, hori, vert, angle, sourcewidth, sourceheight, mask, mask_x, mask_y, mask_w, mask_h, mask_alpha_or_grayscale)
}

function Layer_Wx1(clip c, clip over, float c_start, float c_duration,  int x,int y,int w,int h, float over_start, float over_duration,int angleI, bool hori, bool vert, float angle, int sourcewidth, int sourceheight, string "mask", float "mask_x", float "mask_y", float "mask_w", float "mask_h", bool "mask_alpha_or_grayscale")
{
    v1 = over
        \.Trim1(round(over_start*FrameRate), round(over_duration*FrameRate+over_start*FrameRate))
        \.Rotate_wx(angleI, hori, vert)
        \.BilinearResize(sourcewidth, sourceheight)
        \.ConvertToRGB32()
        \.ImageMask(mask, mask_x, mask_y, mask_w, mask_h, mask_alpha_or_grayscale)
        \.Rotate(angle, width=w, height=h)

    start= c.Trim1(0,round(c_start*FrameRate)-1)
    end=c.Trim1(round(c_start*FrameRate),0)
    
    (c_start==0) ? end.ApplyRange(0, round(over_duration*FrameRate) ,"Layer",v1,"add",257,x,y) : start+end.ApplyRange(0, round(over_duration*FrameRate) ,"Layer",v1,"add",257,x,y)
}


Function Audio_wx(string path, float srcDuration, float "clipStart", float "clipDuration", float "tempo", float "pitch", float "volume", float "fadeIn", float "fadeOut")
{
	srcDuration = Default(srcDuration, 0)
	clipStart = Default(clipStart, 0)
	clipDuration = Default(clipDuration, 0)
	tempo = Default(tempo, 1)
	pitch = Default(pitch, 1)
	volume = Default(volume, 100)
	fadeIn = Default(fadeIn, 0)
	fadeOut = Default(fadeOut, 0)

    #~ c = bassopen(path)
    try {
        #~ source = LWLibavAudioSource(path)
        source = TinyAudio(path)
    } catch(err_msg) {
        source = BlankAudio_wx(srcDuration)
    }
    a1 = source.KillVideo().ConvertAudioToFloat().ResampleAudio(SampleRate)
    a1 = (ChannelLayout == "mono") ? a1.ConvertToMono()
        \: (a1.audiochannels >= 2) ? a1.GetChannel(1, 2)
        \: MonoToStereo(a1, a1)
    Audio_wx1(a1, srcDuration, clipStart, clipDuration, tempo, pitch, volume, fadeIn, fadeOut)
}

Function Audio_wx1(clip ca, float srcDuration, float "clipStart", float "clipDuration", float "tempo", float "pitch", float "volume", float "fadeIn", float "fadeOut")
{
	srcDuration = Default(srcDuration, 0)
	clipStart = Default(clipStart, 0)
	clipDuration = Default(clipDuration, 0)
	tempo = Default(tempo, 1)
	pitch = Default(pitch, 1)
	volume = Default(volume, 100)
	fadeIn = Default(fadeIn, 0)
	fadeOut = Default(fadeOut, 0)

    c = ca
    c = (c.audioduration >= srcDuration) ? c.AudioTrim1(0, -srcDuration)
        \: c.AudioTrim1(0, -c.audioduration) ++ BlankAudio_wx((srcDuration - c.audioduration) * 20)
    c = (clipStart == 0 && (clipDuration == 0 || clipDuration == srcDuration)) ? c
        \: c.AudioTrim1(clipStart * tempo, -clipDuration)
    c = (tempo == 1 && pitch == 1) ? c
        \: c.TimeStretch(tempo=tempo * 100.0, pitch=pitch * 100.0)

    Adjust_Audio_wx(c, volume, fadeIn, fadeOut)
}

Function Adjust_Audio_wx(clip ca, float "volume", float "fadeIn", float "fadeOut")
{
	volume = Default(volume, 100)
	fadeIn = Default(fadeIn, 0)
	fadeOut = Default(fadeOut, 0)

    c = ca
    c = (volume == 100) ? c
        \: c.Amplify(volume / 100.0)
    c = (fadeIn == 0) ? c
        \: c.FadeIn0(round(fadeIn * FrameRate))
    c = (fadeOut == 0) ? c
        \: c.FadeOut0(round(fadeOut * FrameRate))
    c
}

Function Rotate_wx(clip c, int v1, bool hori, bool vert)
{
    c= (v1==90) ? c.TurnRight
        \: (v1==180) ? c.Turn180
        \: (v1==270) ? c.TurnLeft
        \: c
    
    c= hori == true ? c.FlipHorizontal : c
    c= vert == true ? c.FlipVertical : c
    c
}

function Noise_wx(clip c, int "start", int "end")
{
    start = Default(start, 0.0)
	end = Default(end, 0.0)
	start = start *FrameRate/20
	end =end*FrameRate/20
	
    _crop.ConvertToYV12().ApplyRange(start,end,"StaticNoiseC",60,0,True,False).ConvertToRGB()
}

Function Hue_wx(clip c, float _hue)
{
    c.ConvertToYV12().Tweak(hue=_hue).ConvertToRGB32()
}

Function BaseBlankVideo_wx()
{
    channels = (ChannelLayout == "mono") ? 1 : 2
    return BlankClip(length=1, width=FrameWidth, height=FrameHeight, channels=channels,fps=framerate,pixel_type="RGB32").KillAudio()
}


Function BlankVideo_wx(float duration, int "width", int "height", int "color")
{
    width = Default(width, FrameWidth)
	height = Default(height, FrameHeight)
	color = Default(color, $FF000000)
    duration = duration*FrameRate/20
    #return baseBlankClip.Loop(int(duration))
    channels = (ChannelLayout == "mono") ? 1 : 2
    return BlankClip(length=round(duration), width=width, height=height, channels=channels,fps=framerate,pixel_type="RGB32",color=color,sample_type ="float").KillAudio()
}

Function BlankAudio_wx(float duration)
{
	duration = duration*FrameRate/20
    channels = (ChannelLayout == "mono") ? 1 : 2
    return BlankClip(length=round(duration), audio_rate=SampleRate, channels=channels, sample_type="float",  fps=FrameRate).KillVideo()
}

Function BlankAudioOfVideo_wx(clip c)
{
    channels = (ChannelLayout == "mono") ? 1 : 2
    return BlankClip(c, audio_rate=SampleRate, channels=channels, sample_type="float").KillVideo()
}

Function videofit_wx(clip c)
{
    c.TinyResize(FrameWidth, FrameHeight)
    #c.zoombox(FrameWidth, FrameHeight)
}

Function MixAudio_wx(clip c1, clip c2, float c1start, float c2start)
{
    c1=BlankAudio_wx(c1start)++c1
    c2=BlankAudio_wx(c2start)++c2
    return MixAudio(c1, c2)
}

Function Trim_wx(clip c, int start, int end)
{
    return c.Trim1(round(start*FrameRate/20), round(end*FrameRate/20))
}

Function AudioTrim_wx(clip c, float start, float end)
{
    return c.AudioTrim1((round(start*FrameRate))/float(FrameRate), (round(end*FrameRate))/float(FrameRate))
}

Function Zoom_wx(Clip clip, int "_startX1",int "_startX2", int "_startY1", int "_startY2", int "_endX1", int "_endX2", int "_endY1", int "_endY2", int "_StartFrame", int "_EndFrame")
{
    clip.KenBurnsEffect(startX1=_startX1,startX2=_startX2,startY1=_startY1,startY2=_startY2,endX1=_endX1,endX2=_endX2,endY1=_endY1,endY2=_endY2,StartFrame=round(_StartFrame*FrameRate/20),EndFrame=int(_EndFrame*FrameRate/20))
}

Function Transition_wx(clip c1, clip c2, float "transition_left", float "transition_right", string "method", string "arg")
{
    transition_left = Default(transition_left, 0)
    transition_right = Default(transition_right, 0)
    method = Default(method, "")
    arg = Default(arg, "")

    durl = int(round(transition_left * FrameRate))
    durr = int(round(transition_right * FrameRate))

    ((durl <= 0 && durr <= 0) || !c1.HasVideo || c1.framecount <= 0 || !c2.HasVideo || c2.framecount <= 0)
    \ ? c1 ++ c2
    \ : (method == ""
    \ ? Dissolve(c1, c2, durl + durr)
    \ : Transition(c1, c2, durl, durr, method, arg, 50))
}

function TA_Dissolve(clip at, clip bt, int ft)
{
    Dissolve(at,bt,ft)
}

function TA_Scratch_Merge(clip at, clip bt, int ft)
{
    # TransAll avisynth plugin created by V.C.Mohan
    TransScratch(at, bt,ft,"merge")
}

    function DissolveBlack(at,bt,ft)
    {
        fth=int(ft/2)
        wt=BlankClip(fth,at.width(),at.height(),"YV12",at.framerate(),color=$000000).killaudio()
        aw=Dissolve(Trim1(at,1,fth),wt,fth-1)
        bw=Dissolve(wt,Trim1(bt,fth,ft),fth)
        ct=aw.ConvertToYV12()+bw.ConvertToYV12()
        return ct.framecount()>ft ? Trim1(ct,1,ct.framecount()):ct
    }

function TA_Dissolve_Black(clip at, clip bt, int ft)
{
    DissolveBlack(at.killaudio(),bt.killaudio(),ft)
}

    function DissolveWhite(at,bt,ft)
    {
        fth=int(ft/2)
        wt=BlankClip(fth,at.width(),at.height(),"YV12",at.framerate(),color=$FFFFFF).killaudio()
        aw=Dissolve(Trim1(at,1,fth),wt,fth-1)
        bw=Dissolve(wt,Trim1(bt,fth,ft),fth)
        ct=aw.ConvertToYV12()+bw.ConvertToYV12()
        return ct.framecount()>ft ? Trim1(ct,1,ct.framecount()):ct
    }

function TA_Dissolve_White(clip at, clip bt, int ft)
{
    DissolveWhite(at.killaudio(),bt.killaudio(),ft)
}

function TA_Push_Left(clip at, clip bt, int ft)
{
    # TransAll avisynth plugin created by V.C.Mohan
    TransPush(at, bt,ft,"left")
}

function TA_Push_Right(clip at, clip bt, int ft)
{
    # TransAll avisynth plugin created by V.C.Mohan
    TransPush(at, bt,ft,"right")
}

function TA_Push_Down(clip at, clip bt, int ft)
{
    # TransAll avisynth plugin created by V.C.Mohan
    TransPush(at, bt,ft,"down")
}

function TA_Push_Up(clip at, clip bt, int ft)
{
    # TransAll avisynth plugin created by V.C.Mohan
    TransPush(at, bt,ft,"up")
}

function TA_Scratch_Dust(clip at, clip bt, int ft)
{
    # TransAll avisynth plugin created by V.C.Mohan
    TransScratch(at, bt,ft,"dust")
}

function TA_Central_In(clip at, clip bt, int ft)
{
    # TransAll avisynth plugin created by V.C.Mohan
    TransCentral(at,bt,ft)
}

function TA_Dias_Down(clip at, clip bt, int ft)
{
    # TransAll avisynth plugin created by V.C.Mohan

    diasblack=at.levels(0,1,255,0,0,true)
    half=int(ft/2)
    TransPush(at.trim1(0,half), diasblack.trim1(0,half),half+1,"down")++diasblack.trim1(0,-1)++TransPush(diasblack.trim1(0,half), bt.trim1(0,half),half+1,"up")
}

function TA_Dias_Up(clip at, clip bt, int ft)
{
    # TransAll avisynth plugin created by V.C.Mohan

    diasblack=at.levels(0,1,255,0,0,true)
    half=int(ft/2)
    TransPush(at.trim1(0,half), diasblack.trim1(0,half),half+1,"up")++diasblack.trim1(0,-1)++TransPush(diasblack.trim1(0,half), bt.trim1(0,half),half+1,"down")
}

function TA_Shuffle_Down(clip at, clip bt, int ft)
{
    # TransAll avisynth plugin created by V.C.Mohan
    TransShuffle(at, bt,ft,"down")
}

function TA_Slant_Wipe_NE(clip at, clip bt, int ft)
{
    # TransAll avisynth plugin created by V.C.Mohan 05-03-2006
    TransSlantWipe(at, bt,ft,"ne")
}

function TA_SlantRoll_Out_NE(clip at, clip bt, int ft)
{
    # TransAll avisynth plugin created by V.C.Mohan
    TransSlantRollOut(at, bt,ft,"ne",Min(at.width/4, at.height/4),127)
}

function TA_SlantRoll_Out(clip at, clip bt, int ft)
{
    # TransAll avisynth plugin created by V.C.Mohan
    TransSlantRollOut(at, bt,ft,"se",Min(at.width/4, at.height/4),127)
}

    function smartcrop (clip clip, int x, int y, int w, int h, int xo, int yo) 
    {
        black=BlankClip(width=clip.width, height=clip.height, color=$00000000, length=clip.framecount, pixel_type="rgb32").killaudio()
        c=Clip.ConvertToRGB32().Crop(x, y, w, h).ResetMask()
        Layer(black, c, "Add", 257, xo, yo)
    }

function TA_Split_Horisontal(clip at, clip bt, int ft)
{
    at=at.ConvertToRGB32()
    bt=bt.ConvertToRGB32()
    atwidth=at.width
    atheight=at.height
    #crack=int(rand(at.height-60,seed=false)/2)*2+30
    crack=int(at.width/4)*2
    at1=smartcrop(at,0,0,at.width,int(crack),0,0)
    at2=smartcrop(at,0,int(crack),at.width,int(at.height-crack),0,crack)
    #bt3=smartcrop(bt,0,int(bt.height/3)*2,bt.width,int(bt.height/3),0,int(bt.height/3)*2)

    at=Animate2(0,int(at.framecount),"layer",bt,at1,"add",257,0,0,at,at1,"add",0,0,int((crack*-1)))
    at=Animate2(0,int(bt.framecount),"layer",at,at2,"add",257,0,0,at,at2,"add",0,0,int((at.height-crack)))
    #bt=Animate2(int(at.framecount/3)*2,at.framecount-1,"layer",bt,bt3,"add",257,atwidth*-1,0,bt,bt3,"add",257,0,0)
    bt=bt.ConvertToYV12()
    at=at.ConvertToYV12()
    at
}

function TA_Split_Vertical(clip at, clip bt, int ft)
{
    at=at.ConvertToRGB32()
    bt=bt.ConvertToRGB32()
    atwidth=at.width
    atheight=at.height
    #crack=int(rand(at.height-60,seed=false)/2)*2+30
    crack=int(at.width/4)*2
    at1=smartcrop(at,0,0,int(crack),at.height,0,0)
    at2=smartcrop(at,int(at.width-crack),0,int(at.width-crack),int(at.height),int(at.width-crack),0)
    #bt3=smartcrop(bt,0,int(bt.height/3)*2,bt.width,int(bt.height/3),0,int(bt.height/3)*2)

    at=Animate2(0,int(at.framecount),"layer",bt,at1,"add",257,0,0,at,at1,"add",0,int((crack*-1)),0)
    at=Animate2(0,int(bt.framecount),"layer",at,at2,"add",257,0,0,at,at2,"add",0,int((at.width-crack)),0)
    #bt=Animate2(int(at.framecount/3)*2,at.framecount-1,"layer",bt,bt3,"add",257,atwidth*-1,0,bt,bt3,"add",257,0,0)
    bt=bt.ConvertToYV12()
    at=at.ConvertToYV12()
    at
}

function TA_Wipe_Left(clip at, clip bt, int ft)
{
    # TransAll avisynth plugin created by V.C.Mohan
    TransWipe(at, bt,ft,"left")
}

function TA_Wipe_Right(clip at, clip bt, int ft)
{
    # TransAll avisynth plugin created by V.C.Mohan
    TransWipe(at, bt,ft,"right")
}

function TA_Ripples_Center(clip at, clip bt, int ft)
{
    # TransAll avisynth plugin created by V.C.Mohan 05-03-2006
    ft < 9 ? Dissolve(at,bt,ft) : TransRipples(at,bt,ft,origin = "center",amp = 8, lambda =16)
}

