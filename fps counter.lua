local p2,p3,p4,p5=0,0,0,0
local ott=Runtime.getTime()
local stt={}
local saveDrawing=function()
	local a,r,g,b=Drawing.getAlpha(),Drawing.getColor()
	local sx,sy=Drawing.getScale()
	return function(aa)
		aa=tonumber(aa) or 0
		return Drawing.setAlpha(a*aa)
	end,
	function(rr,gg,bb)
		rr,gg,bb=tonumber(rr) or 255,tonumber(gg) or 255,tonumber(bb) or 255
		return Drawing.setColor(rr*(r/255),gg*(g/255),bb*(b/255))
	end,
	function(x,y)
		x,y=tonumber(x) or 0,tonumber(y) or 0
		return Drawing.setScale(x*sx,y*sy)
	end
end
local ths=function(s)
	local s3=s
	pcall(function()
		local s2,mn,t="","",{}
		if tonumber(s) then
			if tonumber(s)%1~=0 then
				local ts=tostring
				local s4,s5=ts(s),ts(s):reverse()
				while not s4:endsWith(".") do s4=s4:sub(1,-2) end
				while not s5:endsWith(".") do s5=s5:sub(1,-2) end
				s,s2=s4:sub(1,-2),s5:sub(1,-2)
			end
			--s,s2=math.modf(s)
			if (tonumber(s) or 0)<0 then mn="-" s=tostring(s):gsub(mn,"",1)end
			if (tonumber(s2) or 0)==0 then s2="" end
		end
		s=tostring(s):reverse()
		for v in string.gmatch(s,".") do table.insert(t,v)end
		for k in pairs(t) do if k%4==0 then table.insert(t,k,",") end end
		s3=mn..(table.concat(t):reverse()..(tostring(s2):gsub("0","",1)))
	end)
	return s3
end
function script:lateInit()
	stt=Util.optStorage(TheoTown.getStorage(),self:getDraft():getId())
	stt.ena=not not stt.ena
	stt.p0=tonumber(stt.p0) or 0
	stt.p1=tonumber(stt.p1) or 0
end
function script:settings()
	local function v0(v)
		if tonumber(v) then
			v=tonumber(v)
			if v%1<=0.25 then v=math.floor(v) end
			if v%1>0.25 or v%1<=0.75 then v=math.floor(v)+0.5 end
			if v%1>0.75 then v=math.floor(v)+1 end
			return v
		end
		return v
	end
	local tbl={
		{
			name="Enabled",
			value=stt.ena,
			onChange=function(v) stt.ena=v end
		}
	}
	if stt.ena then
		table.insert(tbl,{
			name="Position A",
			value=1,
			values={0,1,2},
			valueNames={"<",({"L","C","R"})[1+math.floor(stt.p0*2)],">"},
			onChange=function(v)
				if v==2 then stt.p0=stt.p0+0.5 end
				if v==0 then stt.p0=stt.p0-0.5 end
				while stt.p0>1 do stt.p0=stt.p0-1.5 end
				while stt.p0<0 do stt.p0=stt.p0+1.5 end
			end
		})
		table.insert(tbl,{
			name="Position B",
			value=1,
			values={0,1,2},
			valueNames={"/\\",({"T","C","B"})[1+math.floor(stt.p1*2)],"V"},
			onChange=function(v)
				if v==2 then stt.p1=stt.p1+0.5 end
				if v==0 then stt.p1=stt.p1-0.5 end
				while stt.p1>1 do stt.p1=stt.p1-1.5 end
				while stt.p1<0 do stt.p1=stt.p1+1.5 end
			end
		})
	end
	return tbl
end
local ww=0
function script:overlay()
	pcall(function() p2,p3,p4,p5=GUI.getRoot():getPadding() end)
	if not stt.ena then return end
	--local rt=GUI.getRoot()
	--local x,y,w,h=0,0,rt:getWidth(),rt:getHeight()
	local x,y,w,h=p2,p3,Drawing.getSize()
	w,h=w-p2-p4,h-p3-p5
	local setAlpha,setColor=saveDrawing()
	local text,ii=text,ii
	do
		local tt=Runtime.getTime()
		local i=tt-ott
		ott=Runtime.getTime()
		ii=math.floor(1000/i)
		text="FPS: "..ths(ii).." ("..i.."ms)",ii
	end
	local tw,th=Drawing.getTextSize(text,Font.SMALL)
	ww=tw+((ww-tw)*0.5) tw=ww
	setAlpha(0.6) setColor(255*(1-math.min(1,ii/10)),0,0)
	x,y=x+((w-tw)*stt.p0),y+((h-th)*stt.p1)
	Drawing.drawRect(x,y,tw,th)
	Drawing.setClipping(x+0.5,y+0.25,tw+0.5,th+0.5)
	setAlpha(1) setColor(255,255,255)
	Drawing.drawText(text,x,y,Font.SMALL)
	Drawing.resetClipping()
end
