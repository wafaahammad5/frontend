
Function Overlay_wx(clip c, string overlay, int "start", int "end") {
    start = Default(start, 0)
	end = Default(end, 200000000)

	start=start*FrameRate/20
	end = end*FrameRate/20
    end = Min(end, c.framecount - 1)
    end > start ? c.ApplyRange(start, end, "Layer", Image_wx(overlay)) : c
}

Function Overlay_Video_wx(clip c, string overlay, int "start", int "end", string "mask_frag") {
    start = Default(start, 0)
	end = Default(end, 200000000)
	mask_frag = Default(mask_frag, "")

	start=start*FrameRate/20
	end = end*FrameRate/20
    end = Min(end, c.framecount - 1)

    end > start ? c.Private_Overlay_Video_wx(overlay, start, end, mask_frag) : c
}

Function Private_Overlay_Video_wx(clip c, string overlay, int start, int end, string mask_frag) {
    lay = FFVideoSource(overlay).LoopFrames(round(end - start)).BilinearResize(c.width, c.height).ConvertToRGB32()

    startclip = c.Trim1(0, round(start)-1)
    endclip = c.Trim1(round(start), 0)

    startclip + endclip.GlLayer(lay, 0, round(end - start), shader = mask_frag)
}
