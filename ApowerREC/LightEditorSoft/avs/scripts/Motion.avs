

Function Motion_wx(clip c, string action)
{
    endframe=Min(39*FrameRate/20,c.framecount-1)
    endframe>=1? Apply(action+"_wx",c,endframe):c
}

Function MoveLeft_wx(clip c, int endframe)
{
    c.KenBurnsEffect(startZoomFactor=120,endZoomFactor=120,StartAlign=4,EndAlign=6,startAngle=0,endAngle=0, EndFrame=endframe)
}

Function MoveRight_wx(clip c, int endframe)
{
    c.KenBurnsEffect(startZoomFactor=120,endZoomFactor=120,StartAlign=6,EndAlign=4,startAngle=0,endAngle=0,EndFrame=endframe)
}

Function MoveUp_wx(clip c, int endframe)
{
     c.KenBurnsEffect(startZoomFactor=120,endZoomFactor=120,StartAlign=2,EndAlign=8,startAngle=0,endAngle=0,EndFrame=endframe)
}
Function MoveDown_wx(clip c, int endframe)
{

	c.KenBurnsEffect(startZoomFactor=120,endZoomFactor=120,StartAlign=8,EndAlign=2,startAngle=0,endAngle=0,EndFrame=endframe)
}
Function MoveLeftUp_wx(clip c, int endframe)
{

	c.KenBurnsEffect(startZoomFactor=120,endZoomFactor=120,StartAlign=1,EndAlign=9,startAngle=0,endAngle=0,EndFrame=endframe)
}
Function MoveLeftDown_wx(clip c, int endframe)
{

	c.KenBurnsEffect(startZoomFactor=120,endZoomFactor=120,StartAlign=7,EndAlign=3,startAngle=0,endAngle=0,EndFrame=endframe)
}
Function MoveRightUp_wx(clip c, int endframe)
{

	c.KenBurnsEffect(startZoomFactor=120,endZoomFactor=120,StartAlign=3,EndAlign=7,startAngle=0,endAngle=0,EndFrame=endframe)
}

Function MoveRightDown_wx(clip c, int endframe)
{

	c.KenBurnsEffect(startZoomFactor=120,endZoomFactor=120,StartAlign=9,EndAlign=1,startAngle=0,endAngle=0,EndFrame=endframe)
}

Function ZoomOut_wx(clip c, int endframe)
{

	c.KenBurnsEffect(startZoomFactor=120,endZoomFactor=100,StartAlign=5,EndAlign=5,startAngle=0,endAngle=0,EndFrame=endframe)
}

Function ZoomIn_wx(clip c, int endframe)
{

	c.KenBurnsEffect(startZoomFactor=100,endZoomFactor=120,StartAlign=5,EndAlign=5,startAngle=0,endAngle=0,EndFrame=endframe)
}

Function None_wx(clip c, int endframe)
{

	c.loop(endframe)
}

Function RotateClock45_wx(clip c, int endframe)
{

	c.EffectRotation(sf=0,ef=endframe,id=45,fd=0,cc=0)
}
Function RotateCounterClock45_wx(clip c, int endframe)
{

	c.EffectRotation(sf=0,ef=endframe,id=-45,fd=0,cc=0)
}
#loop(352)
