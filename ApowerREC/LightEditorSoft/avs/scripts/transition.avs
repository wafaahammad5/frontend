Function Trans_wx(clip c1,clip c2, string "action", int "duration") {
    action = Default(action, "TransAccordSingleCloseHor")
    duration = Default(duration, 2)
    
    duration = duration*FrameRate/20
    Apply(action, c1,c2, duration)
}



function TransAccordSingleCloseHor(clip c1, clip c2, int duration)
{
    c1.TransAccord(c2,duration,"vert",False,False)

}
function TransAccordSingleCloseVert(clip c1, clip c2, int duration)
{
    c1.TransAccord(c2,duration,"hor",False,False)

}


function TransAccordTwinsCloseHor(clip c1, clip c2, int duration)
{
	c1.TransAccord(c2,duration,"vert",True,False)
}

function TransAccordTwinsCloseVert(clip c1, clip c2, int duration)
{

	c1.TransAccord(c2,duration,"hor",True,False)
}
#枚举与文件名不一致
function TransBubblesDynamic(clip c1, clip c2, int duration)
{
 
	c1.TransBubbles(c2,duration,False)
}

function TransCentralDisappear(clip c1, clip c2, int duration)
{
 
	c1.TransCentral(c2,duration,False,true,0)
}

function TransCentralEmerge(clip c1, clip c2, int duration)
{
 
	c1.TransCentral(c2,duration,True,true,0)
}
#TransCentralTurn 
function TransCentralTurnClockwise(clip c1, clip c2, int duration)
{
 
	c1.TransCentral(c2,duration,True,true,-1)
}

function TransCentralTurnClockwiseDisappear(clip c1, clip c2, int duration)
{
  
	c1.TransCentral(c2,duration,False,true,-1)
}


function TransCrumpleClose(clip c1, clip c2, int duration)
{
 
	c1.TransCrumple(c2,duration,"fan",False)
}
function TransCrumpleOpen(clip c1, clip c2, int duration)
{
 
	c1.TransCrumple(c2,duration,"fan",True)
}
function TransDiscoClockwiseEmerge(clip c1, clip c2, int duration)
{
 
	c1.TransDisco(c2,duration,48,-1,True)
}
function TransDiscoEmerge(clip c1, clip c2, int duration)
{
 
	c1.TransDisco(c2,duration,48,0,True)
}
function TransDoorClose(clip c1, clip c2, int duration)
{
 
	c1.TransDoor(c2,duration,True,False)
}

        

function TransDoorOpen(clip c1, clip c2, int duration)
{
 
	c1.TransDoor(c2,duration,True,True)
}
function TransFlipPageDown(clip c1, clip c2, int duration)
{
 
	c1.TransFlipPage(c2,duration,"down")
}
function TransFlipPageRight(clip c1, clip c2, int duration)
{
  
	c1.TransFlipPage(c2,duration,"right")
}
function TransFunnelDown(clip c1, clip c2, int duration)
{
 
	c1.TransFunnel(c2,duration,"down")
}
function TransFunnelLeft(clip c1, clip c2, int duration)
{
 
	c1.TransFunnel(c2,duration,"left")
}
function TransFunnelRight(clip c1, clip c2, int duration)
{
 
	c1.TransFunnel(c2,duration,"right")
}
function TransFunnelUp(clip c1, clip c2, int duration)
{
 
	c1.TransFunnel(c2,duration,"up")
}
function TransHFlipNoTurn(clip c1, clip c2, int duration)
{
    c1.TransAccord(c2,duration,"hor",False,False)
}
function TransMarbles(clip c1, clip c2, int duration)
{
 
	c1.TransMarbles(c2,duration,40, 16,true)
}


#maximum radius of discs

function TransPaintBricks(clip c1, clip c2, int duration)
{
    c1.TransAccord(c2,duration,"hor",False,False)
}
function TransPaintFence(clip c1, clip c2, int duration)
{
 
	c1.TransPaint(c2,duration,"fence")
}
function TransPaintStrokes(clip c1, clip c2, int duration)
{
    c1.TransAccord(c2,duration,"hor",False,False)
}
function TransPushDown(clip c1, clip c2, int duration)
{
 
	c1.TransPush(c2,duration,"down")
}
function TransPushLeft(clip c1, clip c2, int duration)
{
 
	c1.TransPush(c2,duration,"left")
}

function TransMarbles(clip c1, clip c2, int duration)
{
    c1.TransAccord(c2,duration,"hor",False,False)
}
function TransPushUp(clip c1, clip c2, int duration)
{
 
	c1.TransPush(c2,duration,"up")
}
#Wave length Wave amplitude
function TransRippleCenter(clip c1, clip c2, int duration)
{
 
	c1.TransRipple(c2,duration,28,2,"center")
}
function TransRippleNW(clip c1, clip c2, int duration)
{
 
	c1.TransRipple(c2,duration,28,2,"nw")
}
function TransRollRight(clip c1, clip c2, int duration)
{
    c1.TransAccord(c2,duration,"hor",False,False)
}
function TransRollDown(clip c1, clip c2, int duration)
{
    c1.TransAccord(c2,duration,"hor",False,False)
}
function TransRollOutSE(clip c1, clip c2, int duration)
{
 
	c1.TransRoll(c2,duration,4,True)
}
function TransRollOutNE(clip c1, clip c2, int duration)
{
 
	c1.TransRoll(c2,duration,2,True)
}



       

function TransScratchHline(clip c1, clip c2, int duration)
{
 
	c1.TransScratch(c2,duration,"hline")
}
function TransScratchRain(clip c1, clip c2, int duration)
{
 
	c1.TransScratch(c2,duration,"rain")
}
function TransScratchVline(clip c1, clip c2, int duration)
{
 
	c1.TransScratch(c2,duration,"vline")
}
function TransSlideInCenter(clip c1, clip c2, int duration)
{
 
	c1.TransSlide(c2,duration,0,False)
}
function TransSlideInEast(clip c1, clip c2, int duration)
{
 
	c1.TransSlide(c2,duration,3,False)
}
function TransSlideInNE(clip c1, clip c2, int duration)
{
 
	c1.TransSlide(c2,duration,2,False)
}
function TransSlideInNW(clip c1, clip c2, int duration)
{
 
	c1.TransSlide(c2,duration,8,False)
}


          
function TransSlideInSE(clip c1, clip c2, int duration)
{
 
	c1.TransSlide(c2,duration,4,False)
}
function TransSlideInSW(clip c1, clip c2, int duration)
{
 
	c1.TransSlide(c2,duration,6,False)
}
function TransSlideInWest(clip c1, clip c2, int duration)
{
 
	c1.TransSlide(c2,duration,7,False)
}
function TransSpriteDown(clip c1, clip c2, int duration)
{
 
	c1.TransSprite(c2,duration,"down")
}
function TransSpriteLeft(clip c1, clip c2, int duration)
{
 
	c1.TransSprite(c2,duration,"left")
}
function TransSpriteRight(clip c1, clip c2, int duration)
{
 
	c1.TransSprite(c2,duration,"right")
}

function TransSpriteUp(clip c1, clip c2, int duration)
{
 
	c1.TransSprite(c2,duration,"up")
}

 
 
function TransSwingInOneDoorFirstCorner(clip c1, clip c2, int duration)
{
 
	c1.TransSwing(c2,duration,False,1,1,True)
}

function TransSwingInTwoDoorsFirstCorner(clip c1, clip c2, int duration)
{
 
	c1.TransSwing(c2,duration,False,2,1,True)
}

     

function TransSwingInTwoDoorsSecondCorner(clip c1, clip c2, int duration)
{
 
	c1.TransSwing(c2,duration,False,2,2,True)
}

function TransSwingInTwoDoorsThirdCorner(clip c1, clip c2, int duration)
{
 
	c1.TransSwing(c2,duration,False,2,3,True)
}

function TransSwingInTwoDoorsFourthCorner(clip c1, clip c2, int duration)
{
 
	c1.TransSwing(c2,duration,False,2,4,True)
}

function TransSwingInFourDoorsFirstCorner(clip c1, clip c2, int duration)
{
 
	c1.TransSwing(c2,duration,False,4,1,True)
}
function TransSwingInFourDoorsSecondCorner(clip c1, clip c2, int duration)
{
 
	c1.TransSwing(c2,duration,False,4,2,True)
}

function TransSwingInfourDoorsThirdCorner(clip c1, clip c2, int duration)
{
 
	c1.TransSwing(c2,duration,False,4,3,True)
}
function TransSwingInFourDoorsFourthCorner(clip c1, clip c2, int duration)
{
 
	c1.TransSwing(c2,duration,False,4,4,True)
}

           



function TransWeaveVert(clip c1, clip c2, int duration)
{
 
	c1.TransWeave(c2,duration,"vert")
}
#width of slats or of pattern
function TransVenetianBlindsDiam(clip c1, clip c2, int duration)
{
 
	c1.TransVenetianBlinds(c2,duration,40,"diam")
}
function TransVenetianBlindsHOR(clip c1, clip c2, int duration)
{
 
	c1.TransVenetianBlinds(c2,duration,40,"hor")
}
function TransVenetianBlindsVert(clip c1, clip c2, int duration)
{
  
	c1.TransVenetianBlinds(c2,duration,40,"vert")
}
function TransVFlipNoTurn(clip c1, clip c2, int duration)
{
    c1.TransAccord(c2,duration,"hor",False,False)
}
 

function TransWeaveHOR(clip c1, clip c2, int duration)
{
   
	c1.TransWeave(c2,duration,"hor")
}
function TransWeaveJigsawPuzzle(clip c1, clip c2, int duration)
{
 
	c1.TransWeave(c2,duration,"jigsaw")
}
function TransVenetianBlindsCheq(clip c1, clip c2, int duration)
{
 
	c1.TransVenetianBlinds(c2,duration,40,"cheq")
}     
     