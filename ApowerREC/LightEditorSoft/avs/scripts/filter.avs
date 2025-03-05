

Function Filter_Shader_wx(clip c, string shader, int "start", int "end") {
    start = Default(start, 0)
    end = Default(end, 200000000)

    start = start*FrameRate/20
    end = end*FrameRate/20
    end = Min(end, c.framecount - 1)
    end >= start ? c.GlFilter(start, end, 0, 0, shader) : c
}

Function Filter_wx(clip c, string "action", int "start", int "end") {
    action = Default(action, "None")
    start = Default(start, 0)
    end = Default(end, 200000000)

    start = start
    end = end
    end = Min(end, c.framecount - 1)
    end >= start ? Apply("Filter_" + action + "_wx", c, start, end) : c
}



Function Filter_G_wx(clip c, int "start", int "end") {
    C.frei0r("G","",start,end)
}
Function Filter_Vertigo_wx(clip c, int "start", int "end") {
    C.frei0r("Vertigo","0.2",start,end)
}
Function Filter_Vignette_wx(clip c, int "start", int "end") {
    C.frei0r("vignette","",start,end)
}
Function Filter_Rgbnoise_wx(clip c, int "start", int "end") {
    C.frei0r("rgbnoise","0.2",start,end)
}
Function Filter_Distort0r_wx(clip c, int "start", int "end") {
    C.frei0r("distort0r","0.01",start,end)
}
Function Filter_Nervous_wx(clip c, int "start", int "end") {
    C.frei0r("nervous","",start,end)
}
Function Filter_Glow_wx(clip c, int "start", int "end") {
    C.frei0r("glow","1",start,end)
}
Function Filter_IIRblur_wx(clip c, int "start", int "end") {
    C.frei0r("IIRblur","",start,end)
}


# VideoFilter.AddFilterEffect

Function Filter_None_wx(clip c, int "start", int "end") {
    c
}

Function Filter_DiscoLightsAll_wx(clip c, int "start", int "end") {
    c.EffectDiscoLights(sf=start, ef=end, spot="all", dim=70)
}

Function Filter_DiscoLightsLarge_wx(clip c, int "start", int "end") {
    c.EffectDiscoLights(sf=start, ef=end, spot="large", dim=70)
}

Function Filter_DiscoLightsMedium_wx(clip c, int "start", int "end") {
    c.EffectDiscoLights(sf=start, ef=end, spot="medium", dim=70)
}

Function Filter_DiscoLightsSmall_wx(clip c, int "start", int "end") {
    c.EffectDiscoLights(sf=start, ef=end, spot="small", dim=70)
}

Function Filter_FiguredGlass_wx(clip c, int "start", int "end") {
    c.EffectFiguredGlass(sf=start, ef=end, mag=2)
}

Function Filter_RainHeavy_wx(clip c, int "start", int "end") {
    c.EffectRain(sf=start,ef=end,type="heavy",red=255,green=255,blue=255)
}

Function Filter_RainLight_wx(clip c, int "start", int "end") {
    c.EffectRain(sf=start,ef=end,type="light",red=255,green=255,blue=255)
}

Function Filter_RainMedium_wx(clip c, int "start", int "end") {
    c.EffectRain(sf=start,ef=end,type="med",red=255,green=255,blue=255)
}

Function Filter_Water_wx(clip c, int "start", int "end") {
    c.EffectWater(sf=start,ef=end)
}

Function Filter_WavesLeft_wx(clip c, int "start", int "end") {
    c.EffectWaves(sf=start,ef=end,dir="left")
}

Function Filter_WavesNE_wx(clip c, int "start", int "end") {
    c.EffectWaves(sf=start,ef=end,dir="ne")
}

Function Filter_WavesNW_wx(clip c, int "start", int "end") {
    c.EffectWaves(sf=start,ef=end,dir="nw")
}

Function Filter_WavesRight_wx(clip c, int "start", int "end") {
    c.EffectWaves(sf=start,ef=end,dir="right")
}

Function Filter_WavesSE_wx(clip c, int "start", int "end") {
    c.EffectWaves(sf=start,ef=end,dir="se")
}

Function Filter_WavesSW_wx(clip c, int "start", int "end") {
    c.EffectWaves(sf=start,ef=end,dir="sw")
}

Function Filter_ConezIncerted_wx(clip c, int "start", int "end") {
    bottom = int(FrameWidth / 2)
    base = bottom % 4 != 0 ? bottom + 4 - bottom % 4 : bottom
    top = int(FrameWidth)
    c.EffectConez(sf=start,ef=end,prog=false,base=base,top=top,shade=-50,bkgrnd=true)
}

Function Filter_Conez_wx(clip c, int "start", int "end") {
    bottom = int(FrameWidth / 2)
    base = bottom % 4 != 0 ? bottom - bottom % 4 : bottom
    top = int(FrameWidth)
    c.EffectConez(sf=start,ef=end,prog=false,base=top,top=base,shade=-50,bkgrnd=true)
}

Function Filter_Conez2To3_wx(clip c, int "start", int "end") {
    bottom = int(FrameWidth * 2 / 3)
    base = bottom % 4 != 0 ? bottom - bottom % 4 : bottom
    c.EffectConez(sf=start,ef=end,prog=false,base=base,top=base,shade=-50,bkgrnd=true)
}

Function Filter_Distorter_wx(clip c, int "start", int "end") {
    c.EffectDistorter(sf=start,ef=end)
}

Function Filter_FogConstant_wx(clip c, int "start", int "end") {
    c.EffectFog(sf=start,ef=end,startfog=30,endfog=30,density=50)
}

Function Filter_FogDecreasing_wx(clip c, int "start", int "end") {
    c.EffectFog(sf=start,ef=end,startfog=70,endfog=0,density=50)
}

Function Filter_FogIncreasing_wx(clip c, int "start", int "end") {
    c.EffectFog(sf=start,ef=end,startfog=0,endfog=70,density=50)
}

Function Filter_Ripples_wx(clip c, int "start", int "end") {
    c.EffectRipples2(sf=start,ef=end,amp=1,eamp=4)
}

Function Filter_RotationLeft10d_wx(clip c, int "start", int "end") {
    c.EffectRotation(sf=start,ef=end,id=10,fd=10,cc=0)
}

Function Filter_RotationRight10d_wx(clip c, int "start", int "end") {
    c.EffectRotation(sf=start,ef=end,id=-10,fd=-10,cc=0)
}

Function Filter_RotationLeftToRight10d_wx(clip c, int "start", int "end") {
    c.EffectRotation(sf=start,ef=end,id=10,fd=-10,cc=0)
}

Function Filter_RotationRightToLeft10d_wx(clip c, int "start", int "end") {
    c.EffectRotation(sf=start,ef=end,id=-10,fd=10,cc=0)
}

Function Filter_RotationRoundToRectangle_wx(clip c, int "start", int "end") {
    ir = int(FrameWidth > FrameHeight ? FrameHeight / 2 : FrameWidth / 2)
    fr = int(Sqrt(FrameWidth * FrameWidth + FrameHeight * FrameHeight) / 2)
    c.EffectRotation(sf=start,ef=end,id=-1,fd=0,ir=ir,fr=fr,cc=0)
}

Function Filter_RotationRectangleToRound_wx(clip c, int "start", int "end") {
    fr = int(FrameWidth > FrameHeight ? FrameHeight / 2 : FrameWidth / 2)
    ir = int(Sqrt(FrameWidth * FrameWidth + FrameHeight * FrameHeight) / 2)
    c.EffectRotation(sf=start,ef=end,id=0,fd=-1,ir=ir,fr=fr,cc=0)
}

Function Filter_SnowLight_wx(clip c, int "start", int "end") {
    c.EffectSnowFlakes(sf=start,ef=end,dense=30,drift=40,fall=20)
}

Function Filter_SnowMedium_wx(clip c, int "start", int "end") {
    c.EffectSnowFlakes(sf=start,ef=end,dense=50,drift=60,fall=40)
}

Function Filter_SnowHeavy_wx(clip c, int "start", int "end") {
    c.EffectSnowFlakes(sf=start,ef=end,dense=80,drift=80,fall=80)
}

Function Filter_Emboss_wx(clip c, int "start", int "end") {
    c.ApplyRange(start,end,"ChangeHUE",11)
}

Function Filter_OldPicture_wx(clip c, int "start", int "end") {
    c.ApplyRange(start,end,"ChangeHUE",10)
}

Function Filter_EdgeFeather_wx(clip c, int "start", int "end") {
    c.ApplyRange(start,end,"ChangeHUE",0)
}

Function Filter_Casting_wx(clip c, int "start", int "end") {
    c.ApplyRange(start,end,"ChangeHUE",1)
}

Function Filter_Freezing_wx(clip c, int "start", int "end") {
    c.ApplyRange(start,end,"ChangeHUE",2)
}

Function Filter_FrostedGlass_wx(clip c, int "start", int "end") {
    c.ApplyRange(start,end,"ChangeHUE",3)
}

Function Filter_EdgeLight_wx(clip c, int "start", int "end") {
    c.ApplyRange(start,end,"ChangeHUE",4)
}

Function Filter_EdgeLightGray_wx(clip c, int "start", int "end") {
    c.ApplyRange(start,end,"ChangeHUE",8).ApplyRange(start,end,"ShowBlue")
}

Function Filter_EdgeLightRed_wx(clip c, int "start", int "end") {
    c.ApplyRange(start,end,"ChangeHUE",6)
}

Function Filter_EdgeLightGreen_wx(clip c, int "start", int "end") {
    c.ApplyRange(start,end,"ChangeHUE",7)
}

Function Filter_EdgeLightBlue_wx(clip c, int "start", int "end") {
    c.ApplyRange(start,end,"ChangeHUE",8)
}

Function Filter_OverExposure_wx(clip c, int "start", int "end") {
    c.ApplyRange(start,end,"ChangeHUE",9)
}

Function Filter_Sketch_wx(clip c, int "start", int "end") {
    c.ApplyRange(start,end,"ChangeHUE",8).ApplyRange(start,end,"ShowBlue").ApplyRange(start,end,"Invert")
}

Function Filter_Negative_wx(clip c, int "start", int "end") {
    c.ApplyRange(start,end,"Invert")
}

Function Filter_VerticalStripes_wx(clip c, int "start", int "end") {
    c.ApplyRange(start,end,"AddGrainC",50,0,1.0,1.0,0,False,true)
}

Function Filter_VerticalStripesStatic_wx(clip c, int "start", int "end") {
    c.ApplyRange(start,end,"AddGrainC",50,0,1.0,1.0,0,True,true)
}

Function Filter_StaticNoiseGray_wx(clip c, int "start", int "end") {
    c.ConvertToYV12().ApplyRange(start,end,"StaticNoiseC",60,0,True,False).ConvertToRGB32()
}

Function Filter_StaticNoiseColor_wx(clip c, int "start", int "end") {
    c.ConvertToYV12().ApplyRange(start,end,"StaticNoiseC",60,0,False,True).ConvertToRGB32()
}

Function Filter_OilPainting_wx(clip c, int "start", int "end") {
    c
}

