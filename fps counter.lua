local s=Util.optStorage(TheoTown.getStorage(),script:getDraft():getId())
local tt,ott=Runtime.getTime()
local p2,p3,p4,p5=0,0,0,0
local fps=0
if not tonumber(s.position) then s.position=0 end
function script:overlay() pcall(function() p2,p3,p4,p5=GUI.getRoot():getPadding() end) end
function script:enterStage()
	if true then
		pcall(function() GUI.get("fpscounteroverlay"):delete() end)
		GUI.getRoot():addCanvas {
			id="fpscounteroverlay",
			onUpdate=function(self)
				local p=self:getParent()
				self:setPosition(-p2,-p3)
				self:setSize(p:getWidth(),p:getHeight())
				self:setChildIndex(p:countChildren()+1)
			end,
			onDraw=function(self,x,y,w,h)
				ott=Runtime.getTime()
				fps=0
				local i=ott-tt
				fps=math.floor(1000/i)
				tt=Runtime.getTime()
				local r,g,b=Drawing.getColor()
				local a=Drawing.getAlpha()
				local sx,sy=Drawing.getScale()
				local s0=1
				Drawing.setScale(sx*s0,sy*s0)
				local sx2,sy2=Drawing.getScale()
				local text="FPS: "..fps
				--.." ("..(i/1000).."s)"
				local tw,th=Drawing.getTextSize(text,Font.SMALL)
				local x0,y0=x+p2,y+p3
				if tonumber(s.position)==1 then x0,y0=x+p2+((w-p2-p4)/2)-(tw/2),y+p3 end
				if tonumber(s.position)==2 then x0,y0=x+w-tw-p4,y+p3 end
				if tonumber(s.position)==3 then x0,y0=x+w-tw-p4,y+h-th-p5 end
				if tonumber(s.position)==4 then x0,y0=x+p2+((w-p2-p4)/2)-(tw/2),y+h-th-p5 end
				if tonumber(s.position)==5 then x0,y0=x+p2,y+h-th-p5 end
				Drawing.setColor(0,0,0) Drawing.setAlpha(a*0.7)
				Drawing.drawRect(x0,y0,tw,th)
				Drawing.setColor(r,g,b) Drawing.setAlpha(a)
				Drawing.drawText(text,x0,y0,Font.SMALL)
				Drawing.setScale(sx,sy)
			end
		}:setTouchThrough(true)
	end
end
function script:settings()
	return {
		{
			name="Show FPS counter",
			value=not not s.showFPSCounter,
			onChange=function(v) s.showFPSCounter=v end
		},
		{
			name="Position",
			value=({"TL","TC","TR","BR","BC","BL"})[s.position+1],
			values={"","<",({"TL","TC","TR","BR","BC","BL"})[s.position+1],">"},
			onChange=function(v)
				s.position=tonumber(s.position) or 0
				if v=="<" then s.position=s.position-1 end
				if v==">" then s.position=s.position+1 end
				if s.position>5 then s.position=0 end
				if s.position<0 then s.position=5 end
			end
		}
	}
end