Import("MotionEffect.avs")

Function wm_image_motion_wx2(string path, int "left", int "top", int "width", int "height", int "start", int "end", string "motion", int "motion_frames", string "format") {


    left = Default(left, 0)
    top = Default(top, 0)
    width = Default(width, FrameWidth)
	height = Default(height, FrameHeight)
    start = Default(start, 0)
    end = Default(end, 200000000)
    motion = Default(motion, "None")
    motion_frames = Default(motion_frames, 2 * FrameRate)
	format = Default(format, "")

    start=start*FrameRate/20
    end=  end*FrameRate/20
    
    overclip=Image_wx(path, 1, width, height, format)
    baseclip = overclip.PointResize(FrameWidth,FrameHeight).ConvertToYV12.AverageBlur(10,10).ConvertToRGB32(matrix="Rec601", interlaced=false).loop(end)
    Apply("WM_Image_" + motion + "_wx", baseclip, overclip, left, top, width, height, start, end, motion_frames)
}


Function WM_Image_wx1(clip c, string path, int "left", int "top", int "width", int "height", int "start", int "end", string "motion", int "motion_frames", string "format") {
    left = Default(left, 0)
    top = Default(top, 0)
    width = Default(width, FrameWidth)
	height = Default(height, FrameHeight)
    start = Default(start, 0)
    end = Default(end, 200000000)
    motion = Default(motion, "None")
    motion_frames = Default(motion_frames, 2 * FrameRate)
    format = Default(format, "")
   

    start=start*FrameRate/20
    end= end*FrameRate/20
    end = Min(end, c.framecount - 1)
    end > start ? Apply("WM_Image_" + motion + "_wx", c, Image_wx(path, 1, width, height, format), left, top, width, height, start, end, motion_frames) : c
}


Function WM_Image_wx(clip c, string path, int "left", int "top", int "width", int "height", int "start", int "end", string "motion", int "motion_frames", string "format") {
    left = Default(left, 0)
    top = Default(top, 0)
    width = Default(width, FrameWidth)
	height = Default(height, FrameHeight)
    start = Default(start, 0)
    end = Default(end, 200000000)
    motion = Default(motion, "None")
    motion_frames = Default(motion_frames, 2 * FrameRate)
    format = Default(format, "")
   

    start=start*FrameRate/20
    end= end*FrameRate/20
    end = Min(end, c.framecount - 1)
    end > start ? Apply("WM_Image_" + motion + "_wx", c, Image_wx(path, 1, width, height, format), left, top, width, height, start, end, motion_frames) : c
}

# MotionEffect.CreateImageMotionEffect

Function WM_Image_None_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    c.ApplyRange(start, end, "Layer", ci, "add", 257, left, top)
}
Function WM_Image_None_tiny_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    c.ApplyRange(start, end, "Layer", ci, "add", 257, left, top)
}

###########################################
Function Private_WM_Image_Move_wx(clip c, clip ci, int start_x, int start_y, int end_x, int end_y, int start, int end, int motion_frames) {
    end_motion = start + motion_frames - 1
    end_motion = end_motion < end ? end_motion : end
    c.ApplyRange(start, end, "Animate1", start, end_motion, "FFImage_Move", ci, start_x, start_y, ci, end_x, end_y)
}

Function WM_Image_MoveLeft_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    start_x = FrameWidth
    start_y = top
    end_x = left
    end_y = top
    Private_WM_Image_Move_wx(c, ci, start_x, start_y, end_x, end_y, start, end, motion_frames)
}
Function WM_Image_MoveLeft_tiny_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    start_x = left+FrameWidth/10
    start_y = top
    end_x = left
    end_y = top
    Private_WM_Image_Move_wx(c, ci, start_x, start_y, end_x, end_y, start, end, motion_frames)
}

Function WM_Image_MoveRight_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    start_x = -width
    start_y = top
    end_x = left
    end_y = top
    Private_WM_Image_Move_wx(c, ci, start_x, start_y, end_x, end_y, start, end, motion_frames)
}
Function WM_Image_MoveRight_tiny_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    start_x = left-width/10
    start_y = top
    end_x = left
    end_y = top
    Private_WM_Image_Move_wx(c, ci, start_x, start_y, end_x, end_y, start, end, motion_frames)
}

Function WM_Image_MoveUp_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    start_x = left
    start_y = FrameHeight
    end_x = left
    end_y = top
    Private_WM_Image_Move_wx(c, ci, start_x, start_y, end_x, end_y, start, end, motion_frames)
}


Function WM_Image_MoveUp_tiny_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    start_x = left
    start_y =top+ FrameHeight/10
    end_x = left
    end_y = top
    Private_WM_Image_Move_wx(c, ci, start_x, start_y, end_x, end_y, start, end, motion_frames)
}

Function WM_Image_MoveDown_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    start_x = left
    start_y = -height
    end_x = left
    end_y = top
    Private_WM_Image_Move_wx(c, ci, start_x, start_y, end_x, end_y, start, end, motion_frames)
}

Function WM_Image_MoveDown_tiny_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    start_x = left
    start_y = top -height/10
    end_x = left
    end_y = top
    Private_WM_Image_Move_wx(c, ci, start_x, start_y, end_x, end_y, start, end, motion_frames)
}

Function WM_Image_MoveLeftUp_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    start_x = FrameWidth
    start_y = FrameHeight
    end_x = left
    end_y = top
    Private_WM_Image_Move_wx(c, ci, start_x, start_y, end_x, end_y, start, end, motion_frames)
}

Function WM_Image_MoveLeftUp_tiny_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    start_x = left + FrameWidth/10
    start_y = top +FrameHeight/10
    end_x = left
    end_y = top
    Private_WM_Image_Move_wx(c, ci, start_x, start_y, end_x, end_y, start, end, motion_frames)
}

Function WM_Image_MoveLeftDown_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    start_x = FrameWidth
    start_y = -height
    end_x = left
    end_y = top
    Private_WM_Image_Move_wx(c, ci, start_x, start_y, end_x, end_y, start, end, motion_frames)
}

Function WM_Image_MoveLeftDown_tiny_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    start_x =left+ FrameWidth/10
    start_y = top-height/10
    end_x = left
    end_y = top
    Private_WM_Image_Move_wx(c, ci, start_x, start_y, end_x, end_y, start, end, motion_frames)
}

Function WM_Image_MoveRightUp_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    start_x = -width
    start_y = FrameHeight
    end_x = left
    end_y = top
    Private_WM_Image_Move_wx(c, ci, start_x, start_y, end_x, end_y, start, end, motion_frames)
}

Function WM_Image_MoveRightUp_tiny_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    start_x = left-width/10
    start_y = top+FrameHeight/10
    end_x = left
    end_y = top
    Private_WM_Image_Move_wx(c, ci, start_x, start_y, end_x, end_y, start, end, motion_frames)
}


Function WM_Image_MoveRightDown_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    start_x = -width
    start_y = -height
    end_x = left
    end_y = top
    Private_WM_Image_Move_wx(c, ci, start_x, start_y, end_x, end_y, start, end, motion_frames)
}

Function WM_Image_MoveRightDown_tiny_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    start_x = left-width/10
    start_y = top-height
    end_x = left
    end_y = top
    Private_WM_Image_Move_wx(c, ci, start_x, start_y, end_x, end_y, start, end, motion_frames)
}

###########################################

Function WM_Image_ZoomOut_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    #~ start_factor = 1.25
    #~ end_factor = 0.75
    #~ start_x = left + int((1.0 - start_factor) / 2 * width)
    #~ start_y = top + int((1.0 - start_factor) / 2 * height)
    #~ start_w = int(start_factor * width)
    #~ start_h = int(start_factor * height)

    #~ end_motion = start + motion_frames - 1
    #~ end_motion = end_motion < end ? end_motion : end
    #~ c.ApplyRange(start, end, "Animate1", start, end_motion, "FFImage_Zoom", ci, end_factor * 100.0, start_w, start_h, start_x, start_y, ci, 100.0 / start_factor, start_w, start_h, start_x, start_y)

    WM_Image_ZoomOut_tiny_wx(c, ci, left, top, width, height, start, end, motion_frames)
}

Function WM_Image_ZoomIn_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    #~ start_factor = 0.5 * 100.0
    #~ end_factor = 1 * 100.0

    #~ end_motion = start + motion_frames - 1
    #~ end_motion = end_motion < end ? end_motion : end
    #~ c.ApplyRange(start, end, "Animate1", start, end_motion, "FFImage_ZoomIn", ci, start_factor, left, top, ci, end_factor, left, top)

    start_x = left+width/10
    start_y = top +height/10
    start_w = width*8/10
    start_h = height*8/10

    end_motion = start + motion_frames - 1
    end_motion = end_motion < end ? end_motion : end
    c.ApplyRange(start, end, "Animate1", start, end_motion, "FFImage_Zoom_tiny", ci, start_x,start_y,start_w, start_h,  ci,left, top,width,height)
}


Function WM_Image_ZoomOut_tiny_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    start_x = left-width/10
    start_y = top -height/10
    start_w = width*12/10
    start_h = height*12/10

    end_motion = start + motion_frames - 1
    end_motion = end_motion < end ? end_motion : end
    c.ApplyRange(start, end, "Animate1", start, end_motion, "FFImage_Zoom_tiny", ci, start_x,start_y,start_w, start_h,  ci,left, top,width,height)
}

Function WM_Image_ZoomIn_tiny_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    end_x = left-width/10
    end_y = top -height/10
    end_w = width*12/10
    end_h = height*12/10

    end_motion = start + motion_frames - 1
    end_motion = end_motion < end ? end_motion : end
    c.ApplyRange(start, end, "Animate1", start, end_motion, "FFImage_Zoom_tiny",  ci,left, top,width,height , ci, end_x,end_y,end_w, end_h)
}


###########################################
Function Private_WM_Image_RotateClock_wx(clip c, clip ci, int left, int top, int width, int height, int start, int end, int motion_frames, int start_angle, int end_angle) {
    clip_width = int(Sqrt(width * width + height * height))
    clip_width = clip_width % 4 != 0 ? clip_width + 4 - clip_width % 4 : clip_width

    over_width = (clip_width - width) / 2
    over_height = (clip_width - height) / 2

    ci = ci.AddBorders(over_width, over_height, over_width, over_height, $00000000)

    end_motion = start + motion_frames - 1
    end_motion = end_motion < end ? end_motion : end
    c.ApplyRange(start, end, "Animate1", start, end_motion, "FFImage_Rotate", ci, start_angle, left - over_width, top - over_height, ci, end_angle, left - over_width, top - over_height)
}

Function WM_Image_RotateClock45_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    start_angle = -45
    end_angle = 0
    Private_WM_Image_RotateClock_wx(c, ci, left, top, width, height, start, end, motion_frames, start_angle, end_angle)
}

Function WM_Image_RotateCounterClock45_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    start_angle = 45
    end_angle = 0
    Private_WM_Image_RotateClock_wx(c, ci, left, top, width, height, start, end, motion_frames, start_angle, end_angle)
}
