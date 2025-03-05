Import("wm_image.avs")

Function WM_Text_wx(clip c, string path, int "left", int "top", int "width", int "height", int "start", int "end", string "motion", float "motion_frames") {
    WM_Image_wx(c, path, left, top, width, height, start, end, motion, int(motion_frames*FrameRate))
}

Function WM_VideoText_wx(clip c, string path, int "left", int "top", int "width", int "height", int "start", int "end") {
    
    duration_f= (float(end-start))/20.0

    start=start*FrameRate/20
    end= end*FrameRate/20

    ci=TextVideo(path,duration_f).tinyresize(width,height).ConvertToRGB32
    
    mask= TextVideo(path+"mask.mp4",duration_f).tinyresize(width,height).ConvertToRGB32
    ci=ci.Mask(mask)
    
    #c.ApplyRange(start, end, "Layer", ci, "add", 257, left, top)

    startclip= c.Trim1(0,round(start)-1)
    endclip=c.Trim1(round(start),0)


    (start==0)?endclip.ApplyRange(0, round(end-start) ,"Layer",ci,"add",257,left,top): startclip+endclip.ApplyRange(0, round(end-start) ,"Layer",ci,"add",257,left,top)


}

# MotionEffect.CreateTextWarterMarkMoTionEffect

Function WM_Image_LeftRoll_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    start_x = FrameWidth
    start_y = top
    end_x = -width
    end_y = top
    motion_frames = end - start
    Private_WM_Image_Move_wx(c, ci, start_x, start_y, end_x, end_y, start, end, motion_frames)
}

Function WM_Image_RightRoll_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    start_x = -width
    start_y = top
    end_x = FrameWidth
    end_y = top
    motion_frames = end - start
    Private_WM_Image_Move_wx(c, ci, start_x, start_y, end_x, end_y, start, end, motion_frames)
}

Function WM_Image_UpRoll_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    start_x = left
    start_y = FrameHeight
    end_x = left
    end_y = -height
    motion_frames = end - start
    Private_WM_Image_Move_wx(c, ci, start_x, start_y, end_x, end_y, start, end, motion_frames)
}

Function WM_Image_DownRoll_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    start_x = left
    start_y = -height
    end_x = left
    end_y = FrameHeight
    motion_frames = end - start
    Private_WM_Image_Move_wx(c, ci, start_x, start_y, end_x, end_y, start, end, motion_frames)
}

###########################################

Function WM_Image_RotateClock360_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    start_angle = -360
    end_angle = 0
    Private_WM_Image_RotateClock_wx(c, ci, left, top, width, height, start, end, motion_frames, start_angle, end_angle)
}

Function WM_Image_RotateCounterClock360_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    start_angle = 360
    end_angle = 0
    Private_WM_Image_RotateClock_wx(c, ci, left, top, width, height, start, end, motion_frames, start_angle, end_angle)
}

###########################################
Function Private_WM_Image_PartToWhole_wx(clip c, clip ci, int start_x, int start_y, int start_crop_x, int start_crop_y, int start_crop_w, int start_crop_h, int end_x, int end_y, int end_crop_x, int end_crop_y, int end_crop_w, int end_crop_h, int start, int end, int motion_frames) {
    end_motion = start + motion_frames - 1
    end_motion = end_motion < end ? end_motion : end
    c.ApplyRange(start, end, "Animate1", start, end_motion, "FFImage_Roll", ci, start_x, start_y, start_crop_x, start_crop_y, start_crop_w, start_crop_h, ci, end_x, end_y, end_crop_x, end_crop_y, end_crop_w, end_crop_h)
}

Function WM_Image_LeftPartToWhole_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    start_x = left
    start_y = top
    start_crop_x = width
    start_crop_y = 0
    start_crop_w = 0
    start_crop_h = height
    end_x = left
    end_y = top
    end_crop_x = 0
    end_crop_y = 0
    end_crop_w = width
    end_crop_h = height
    Private_WM_Image_PartToWhole_wx(c, ci, start_x, start_y, start_crop_x, start_crop_y, start_crop_w, start_crop_h, end_x, end_y, end_crop_x, end_crop_y, end_crop_w, end_crop_h, start, end, motion_frames)
}

Function WM_Image_RightPartToWhole_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    start_x = left + width
    start_y = top
    start_crop_x = 0
    start_crop_y = 0
    start_crop_w = 0
    start_crop_h = height
    end_x = left
    end_y = top
    end_crop_x = 0
    end_crop_y = 0
    end_crop_w = width
    end_crop_h = height
    Private_WM_Image_PartToWhole_wx(c, ci, start_x, start_y, start_crop_x, start_crop_y, start_crop_w, start_crop_h, end_x, end_y, end_crop_x, end_crop_y, end_crop_w, end_crop_h, start, end, motion_frames)
}

Function WM_Image_UpPartToWhole_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    start_x = left
    start_y = top + height
    start_crop_x = 0
    start_crop_y = 0
    start_crop_w = width
    start_crop_h = 0
    end_x = left
    end_y = top
    end_crop_x = 0
    end_crop_y = 0
    end_crop_w = width
    end_crop_h = height
    Private_WM_Image_PartToWhole_wx(c, ci, start_x, start_y, start_crop_x, start_crop_y, start_crop_w, start_crop_h, end_x, end_y, end_crop_x, end_crop_y, end_crop_w, end_crop_h, start, end, motion_frames)
}

Function WM_Image_DownPartToWhole_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    start_x = left
    start_y = top
    start_crop_x = 0
    start_crop_y = height
    start_crop_w = width
    start_crop_h = 0
    end_x = left
    end_y = top
    end_crop_x = 0
    end_crop_y = 0
    end_crop_w = width
    end_crop_h = height
    Private_WM_Image_PartToWhole_wx(c, ci, start_x, start_y, start_crop_x, start_crop_y, start_crop_w, start_crop_h, end_x, end_y, end_crop_x, end_crop_y, end_crop_w, end_crop_h, start, end, motion_frames)
}

###########################################

Function WM_Image_FadeIO_wx(clip c, clip ci, int "left", int "top", int "width", int "height", int "start", int "end", int "motion_frames") {
    ci = ci.Loop(end - start).FadeIO(motion_frames, fps=FrameRate)
    
    co = (start == 0) ? c : c.Trim1(start, -0)
    co = co.ApplyRange(0, end - start, "Layer", ci, "add", 257, left, top)
    co = (start == 0) ? co : c.Trim1(0, -start) + co
    co
}
