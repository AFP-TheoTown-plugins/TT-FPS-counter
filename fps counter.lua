local s=Util.optStorage(TheoTown.getStorage(),script:getDraft():getId())
local tt,ott=Runtime.getTime()
local p2,p3,p4,p5=0,0,0,0
local fps=0
if not tonumber(s.position) then s.position=0 end
if not tonumber(s.position0) then s.position0=0 end
if not tonumber(s.x) then s.x=0 end
if not tonumber(s.y) then s.y=0 end
function script:overlay() pcall(function() p2,p3,p4,p5=GUI.getRoot():getPadding() end) end
local function openUI()
	pcall(function() GUI.get("fpscounteroverlay"):delete() end)
	if not s.showFPSCounter then return end
	GUI.getRoot():addCanvas {
		id="fpscounteroverlay",
		onUpdate=function(self)
			local p=self:getParent()
			self:setPosition(-p2,-p3)
			self:setSize(p:getWidth(),p:getHeight())
			local c=GUI.get("roottoolbar")
			if not c then self:setChildIndex(p:countChildren()) return end
			if c:isVisible() then
				c=c:getChild(1)
				local y,h=c:getY(),c:getH()
				self:addH(-c:getH()-c:getY())
				self:addY(c:getH()+c:getY())
			end
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
			local x0,y0=x+p2+s.x,y+p3+s.y
			if tonumber(s.position)==1 then x0=x+p2+((w-p2-p4)/2)-(tw/2) end
			if tonumber(s.position)==2 then x0=x+w-tw-p4-s.x end
			if tonumber(s.position0)==1 then y0=y+h-th-p5-s.y end
			Drawing.setColor(0,0,0) Drawing.setAlpha(a*0.7)
			Drawing.drawRect(x0,y0,tw,th)
			Drawing.setColor(r,g,b) Drawing.setAlpha(a)
			Drawing.drawText(text,x0,y0,Font.SMALL)
			Drawing.setScale(sx,sy)
		end
	}:setTouchThrough(true)
end
function script:enterStage() openUI() end
if GUI then openUI() end
function script:settings()
	local tbl={
		{
			name="Show FPS counter",
			value=not not s.showFPSCounter,
			onChange=function(v) s.showFPSCounter=v end
		},
		{
			name="Position A",
			value=({"Left","Center","Right"})[s.position+1],
			values={"","<",({"Left","Center","Right"})[s.position+1],">"},
			onChange=function(v)
				s.position=tonumber(s.position) or 0
				if v=="<" then s.position=s.position-1 end
				if v==">" then s.position=s.position+1 end
				if s.position>2 then s.position=0 end
				if s.position<0 then s.position=2 end
			end
		},
		{
			name="Position B",
			value=s.position0,
			values={0,1},
			valueNames={"Top","Bottom"},
			onChange=function(v)
				s.position0=v
				if s.position0>1 then s.position0=0 end
				if s.position0<0 then s.position0=1 end
			end
		}
	}
	for _,k in pairs{"x","y"} do tbl[#tbl+1]={
		name="Offset "..k:upper(),
		value=s[k],
		desc="Set value for offset "..k..":",
		--values={"<<<","<<","<",s[k],">",">>",">>>"},
		onChange=function(v) s[k]=tonumber(v) or 0 end
	} end
	return tbl
end