pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
-- blockrush
-- by artridge

poke(0x5f80,1)

function print2(txt,_x,_y,col,bg)
	dirx={-1,1,0,0,1,1,-1,-1}
 diry={0,0,-1,1,-1,1,1,-1}
 for x=1,8 do
  for y=1,8 do
   print(txt,_x+dirx[x],_y+diry[y],bg)
  end
 end
 print(txt,_x,_y,col)
end

function lerp(pos,tar,perc)
 return (1-perc)*pos+perc*tar
end

index=0
logo="00000808080808080808080808080808080800000008080808080808080808080808080808080800080808080808080808080808080808080808080808080800000000000000000000000000000808080808080000070707070707070707070700080808080808000707070707070707070707070008080808080800070707070707070707070707000808080808080007070707000000000707070700080808080808000707070700000000070707070008080808080800070707070000000007070707000000000808080007070707070707070707070707070707080808000707070707070707070707070707070708080800070707070000000007070707000000000808080007070707000000000707070700080808080808000707070700000000070707070008080808080800000707070000000007070707000808080808080000000000000000000000000000080808080808080808080808080808080808080808080800080808080808080808080808080808080808000000080808080808080808080808080808080000"
::_::
cls()
x,y=0,0
for i=1,#logo,2 do
	local col,p=sub(logo,i,i+1),min(index,60)
	rx,ry=x+24+40*(60-p)/60,y+24-(60-p)
	rectfill(rx,ry,rx+4,ry+4,tonum(col))
	x+=4
	if x>=80*p/60 then
		x=0
		y+=4
	end
end
index+=1
if index<=120 then
	flip()
	goto _
end

function _init()
 menuitem(1,"clear data",
 	function()
 		for i=1,63 do 
 			poke(0x5f80+i,0b0000) 
 		end
 		cube=1
 	end
 )
 
 -- main functions
 _upd=updatestart
 _drw=drawstart
 
 -- player
 px,py=-8,-8
 pv=-1
 freezep=false
 wasonarr=0
 trailcounter=0
 props={}
 didwtp=false
 local val=peek(0x5f80+36)
 cube=val==0 and 1 or val
 cubes=combine(1,rng(32,38),48)
 canplayorbsound = true
 diddestroysound = false
 
 -- menu
 menuci=1
 menulvls=0
 fadeperc=0
 fadetarget=0
 isonblocks=false
 
 -- misc
 debug={}
 dirx,diry={-1,1,0,0},{0,0,-1,1}
	offsetx=0
	offsety=0
	
	-- effects
	shake=0
	particles={}
	framecounter=0
	tps={7,8,9,23,39}
	tpcol={{1,2},{11,3},{10,9},{12,13},{14,8}}
	numred=0
	tppartcountbefore=0
	spawnparticles=0
	mainoffsetx,mainoffsety=0,0
	
	-- tutorial
	l1tc=0
	diecounter=0
	
	timeouts={}
	
 music(0)
end

function _update()
 mapx=((menuci-1)%8)*16
 mapy=flr((menuci-1)/8)*16
 
 updatetransitions()
 _upd()
 
 for t in all(timeouts) do
 	t.t-=1
 	if t.t==0 then
 	 t.func()
 	 del(timeouts,t)
 	end
 end
end

function _draw()
	shakeit()

 _drw()
 
 cursor(8,8,8)
 for d in all(debug) do
  print(d)
 end
 
-- for i=0,15 do
--  pal(i,i+128,1)
-- end

--	local index=0
--	for y=0,128 do
--		for x=0,128 do
--			if (x%fadeperc)*(y%fadeperc)==0 then
--				pset(x-1,y-1,8)
--			end
--			
--			index+=1
--		end
--	end
	fadepal(fadeperc)
end
-->8
-- updates

function updatetransitions()
	if fadeperc!=fadetarget then
		fadeperc+=sgn(fadetarget-fadeperc)*0.1
	end
end

function updatestart()
	updateparticles()
	for i=0,5 do
		if btn(i) and fadetarget!=1 then
		 fadetarget=1
		 store(127,255,true)
			timeout(function()
				_upd=updatemenu
		  _drw=drawmenu
		  fadetarget=0
			end,10,1)
		end
	end
end

function updatemenu()
	particles={}
	shake=0
	numred=0
	wasonarr=0
	diecounter=0
	l1tc=0
	spawnparticles=0
	offsetx,offsety=0,0
	for t in all(timeouts) do
		if t.tpe==0 then
			del(timeouts,t)
		end
	end
	
	if btnp(❎) and fadetarget!=1 and not isonblocks then
		sfx(28,3)
  openlvl(menuci)
  store(127,menuci,true)
 else
 	if isonblocks then
 		if btnp(⬆️) then
 			isonblocks=false
 		end
 		if btnp(⬅️) then
 			local i=indexof(cubes,cube)-1
 			if (i>0) cube=cubes[i]
			end
			if btnp(➡️) then
				local i=indexof(cubes,cube)+1
				if (i<=#cubes) cube=cubes[i]
			end
   store(36,cube,true)
 	else
		 for i=1,4 do
		  if btnp(i-1) and fadeperc==0 then
		   menuci+=dirx[i]
		   local dy=diry[i]
		   if dy>0 then
		   	if menuci>24 then
		   		isonblocks=true
		   	end
		   	menuci+=dy*(menuci>24 and 0 or 8)
		   else
		    menuci+=dy*(menuci<9 and 0 or 8)
		   end
		  end
		 end
		end
		
	 if menuci>menulvls then
	 	menuci=1
	 elseif menuci<1 then
	 	menuci=32
	 end
	end
end

function updategame()
 updateparticles()
 updatetutorial()

 if btnp(🅾️) and fadetarget!=1 and (l1tc==0 or l1tc>=150) then
	 sfx(28,3)
	 fadetarget=1
		timeout(function()
			_upd=updatemenu
	  _drw=drawmenu
	  resetarrows()
	  fadetarget=0
		end,10,1)
 end
 
 local x=flr(px/8)+mapx
 local y=flr(py/8)+mapy
 local s=mget(x,y)

 if fget(s,2) then
  pv=-1
 elseif fget(s,1) then
 	die()
 end
 
 isonportal=false
 if indexof(tps,s)!=-1 then
 	isonportal=true
 end

 if (isonportal or s == 6) and canplayorbsound then
  sfx(29,3)
  canplayorbsound = false
 end

 if not isonportal and s != 6 then
  canplayorbsound = true
 end
 
 if s==4 then
 	sfx(25,3)
 	freezep=true
 	fadetarget=1
  timeout(function()
			_upd=updatemenu
	  _drw=drawmenu
	  store(lvl,1)
    store(126,255,true)
	  resetarrows()
	  fadetarget=0
		end,10,1)
 elseif s==5 then
 	sfx(26,3)
 	shake=0.06
 	if not get_data(lvl,2) then
 		shatter(10,px,py)
 	else
 		shatter(7,px,py)
 	end
  spawnplayer()
 	resetarrows()
 	resetlvl()
  store(lvl,2)
 end
 
 local spikes={24,25,41,40}
 local arrows={103,102,118,119}
 for i=1,4 do
  if pv==i-1 and s==spikes[i] then
   die()
  end
  if s==arrows[i] then
   pv=i-1
   wasonarr=10
   movedist=0
   if fget(mget(x+dirx[pv+1],y+diry[pv+1]),0) then
   	die()
   	wasonarr=0
   end
  end
 end
 
 if pv==-1 then
  for i=1,4 do
   if btnp(i-1) and not freezep then
    pv=i-1
    if not fget(mget(x+dirx[i],y+diry[i]),0) then
    	isblue=not isblue
    end
    for x=mapx,mapx+16 do
     for y=mapy,mapy+16 do
      if isblue then
      	if (mget(x,y)==22) mset(x,y,21)
      	if (mget(x,y)==19) mset(x,y,20)
      else
       if (mget(x,y)==21) mset(x,y,22)
      	if (mget(x,y)==20) mset(x,y,19)
      end
     end
    end
   end
  end
 end
 
 for num in all(props.num) do
  if pv!=-1 and movedist>0 and not props.numdone  then
	 	if px+dirx[pv+1]*8==num.c.x and py+diry[pv+1]*8==num.c.y then
	 	 local playsound=false
	 	 if props.numc+1==num.n then
	 	 	playsound=true
	 	 	props.numc+=1
	 	 	num.unlocked=true
	 	 	if count(props.num)==props.numc then
		 	 	for e in all(props.numend) do
		 	 		mset(e.x,e.y,42)
		 	 		shake=0.075
		 	 		shatter(5,(e.x-mapx)*8,(e.y-mapy)*8)
		 	 	end
		 	 	props.numdone=true
		 	 	playsound=false
		 	 	sfx(22,3)
	 	 	end
	 	 else
	 	 	props.numc=0
	 	 	numred=12
	 	 	shake=0.068
	 	 	playsound=false
	 	 	sfx(23,3)
	 	 	for num in all(props.num) do
	 	 	 num.unlocked=false
	 	 	end
	 	 end
	 	 
	 	 if playsound then
	 	 	sfx(min(15+props.numc,21),3)
	 	 end
	 	 
	 	end
	 end
 end

 local didrotate = false
 for bt in all(props.arrbut) do
  if px==bt.x and py==bt.y and pv==bt.v then
  	rotatearrows()
    didrotate = true
  end
 end

 if not freezep then
	 for i=1,4 do
	  if pv==i-1 then
	   local nb=mget(x+dirx[i],y+diry[i])
	  
	   if nb==10 and movedist>=3 then
	    mset(x+dirx[i],y+diry[i],26)
	    shatter(5,px+dirx[i]*8,py+diry[i]*8)
	   	shake=0.06
	   	sfx(7,3)
      diddestroysound = true
	   end
	   
	   nb=mget(x+dirx[i],y+diry[i])
	   if fget(nb,0) then
	   	pv=-1
	   	movedist=0
	   	if indexof(rng(51,58),nb)==-1 and indexof({12,13,28,29},s)==-1 and not didwtp and not didrotate and not diddestroysound then
	   		sfx(4,3)
	   	end
      diddestroysound = false
	   	didwtp=false
		  else
		   px+=dirx[i]*8
		   py+=diry[i]*8
		   movedist+=1
		  end
	  end
	 end
	end

 for i,tp in pairs(props.wtp) do
 	if px==tp[1].x and py==tp[1].y and pv==tp[1].v then
 	 px,py=tp[2].x,tp[2].y,tp[1].v
 	 wtpparts(px,py,tp[1].v)
 	 sfx(5,3)
 	 didwtp=true
 	 break
 	elseif px==tp[2].x and py==tp[2].y and pv==tp[2].v then
 	 px,py,pv=tp[1].x,tp[1].y,tp[2].v
 	 wtpparts(px,py,tp[2].v)
 	 sfx(5,3)
 	 didwtp=true
 	 break
 	end
 end
 
 tped=true
 if btnp(❎) and not freezep and pv==-1  then
  for i,t in pairs(props.ptp) do
   tp(i,t,props.ptp,s)
  end
  for i,t in pairs(props.btp) do
   tp(i,t,props.btp,s)
  end
  for i,t in pairs(props.rtp) do
   tp(i,t,props.rtp,s)
  end
  for i,t in pairs(props.gtp) do
   tp(i,t,props.gtp,s)
  end
  for i,t in pairs(props.ytp) do
   tp(i,t,props.ytp,s)
  end
 end
end

function tp(i,t,arr,s)
	local x1,y1=px,py
 if px==t.x and py==t.y and tped then
  px=arr[i==1 and 2 or 1].x
  py=arr[i==1 and 2 or 1].y
  tpanim(x1,y1,px,py,s)
  freezep=true
  tped=false
  sfx(3,3)
 end
end

function rotatearrows()
	sfx(27,3)
	shatter(11,px,py)
	local arrspr={102,119,103,118}
	for arr in all(arrows) do
		mset(arr.x,arr.y,
			arrspr[
				(indexof(
					arrspr,mget(arr.x,arr.y)
				))%4+1
			]
		)
	end
end

function store(i,val,n)
	if n then
		poke(0x5f80+i,val)
		return
	end
	local x=peek(0x5f80+i)
	if val==1 then
		poke(0x5f80+i,bor(x,0b0001))
	else
		poke(0x5f80+i,bor(x,0b0010))
	end
end

function drawgpio()
	local s=24448
	local e=24576
	for i=s,e do
		printh(tostr(peek(i)),'log.txt')
	end
end

function get_data(i,bit)
 local x=peek(0x5f80+i)
 if bit==1 then
 	return band(x,0b0001)!=0
 else
 	return band(x,0b0010)!=0
 end
end
-->8
-- draws

function fadepal(_perc)
 -- 0 means normal
 -- 1 is completely black
 
 local p=flr(mid(0,_perc,1)*100)
 
 local kmax,col,dpal,j,k
 dpal={0,1,1,2,1,13,6,4,4,9,3,13,1,13,14}

 for j=1,15 do
  col = j
  kmax=(p+(j*1.46))/22  
  for k=1,kmax do
   col=dpal[col]
  end
  pal(j,col,1)
 end
end

function drawstart()
	cls(5)
	
	local logo="0505050505050505050505050505050505050505050505050500000000000000000505050505050505050505050505050505050505050505050000000000000000000000000505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050500060606060606060613050505050505050505050505050505050505050505050006060606060606060606060613050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505000606060606060606130505050505050505050505050505050505050505050500060606060606060606060606130505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050505050006060606060606061305050505050505050505050505050505050505050505000606060606060606060606061305050505050505050505050505050505050505050505050505050505050000000000000000000000000000000000000000060606060606060605000000000000000000000000000000000000000000000006060606060606060606060605000000000000000000000000000000000000000505050505050505050006060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060613050505050505050500060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606130505050505050505000606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606061305050505050000000006060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060613050505050006060606060606061313131313131313131313050606060613131305060606060606060606060606060606061313131313131305060606061313130513131313131313050606060613131305060606061313130506060606130505050500060606060606060613050505050505050505050006060606130500000606060606060606060606060610101013050505050505000606060613050000130505050505050006060606130505000606060613050500060606061305050505000606060606060606130505050505050505050500060606061313050006060606060606060606060606100606130505050505050006060606131305001305050505050500060606061305050006060606130505000606060613050505050006060606060606061305050000000000050505000606060605000000060606060606060606060606061006060500000005050500060606060500000005000000000000000606060613050500060606061305050006060606130505050500060606060606060613050500060606061305050006060606131313050606060606060606060606061313130506060606130505000606060613131305060606060606060606060606130505000606060613050500060606061305050505000606060606060606130505000606060613050500060606061305050006060606060606060606060613050500060606061305050006060606130505000606060606060606060606061305050006060606130505000606060613050505050006060606060606061305050006060606130505000606060613050500060606060606060606060606130505000606060613050500060606061305050006060606060606060606060613050500060606061305050006060606130505050500060606060606060613050500060606060500000006060606130505000606060606060606060606061305050006060606130505000606060613050500060606060606060606060606130505000606060605000000060606060500000005051313130506060606130505051313130506060606060606061305050006060606060606060606060613050500060606061305050006060606130505000606060606060606060606061305050513131305060606060606060606060606130505050500060606061305050505050500060606060606060613050500060606060606060606060606130505000606060613050500060606061305050006060606060606060606060613050505050505000606060606060606060606061305050505000606060613050505050505000606060606060606130505000606060606060606060606061305050006060606130505000606060613050500060606060606060606060606130505050505050006060606060606060606060613050505050006060606130505000000000006060606060606061305050006060606060606060606060613050500060606061305050006060606130505000606060606060606060606061305050500000000060606060606060606060606130505050500060606061305050006060606131313050606060613050500060606060606060606060606130505000606060613050500060606061305050006060606060606060606060613050500060606061313130506060606060606061305050505000606060613050500060606061305050006060606130505000606060606060606060606061305050006060606130505000606060613050500060606060606060606060606130505000606060613050500060606060606060613050505050006060606130505000606060613050500060606061305050006060606060606060606060613050500060606061305050006060606130505000606060606060606060606061305050006060606130505000606060606060606130505050500060606061305050006060606130505000606060613050500060606060606060606060606130505000606060605000000060606060500000006060606060606060606060613050500060606061305050006060606060606061305050505000606060613050505131313131305050006060606130505051313131313131305060606061305050513131305060610060606060606100606131313131313130506060606130505000606060613050500060606061313131305050505050006060606130505050505050505050500060606061305050505050505050505000606060613050505050505000606100606060606061006061305050505050500060606061305050006060606130505000606060613050505050505050500060606061305050505050505050505000606060613050505050505050505050006060606130505050505050010101006060606060610101013050505050505000606060613050500060606061305050006060606130505050505050505000606060605000000000000000000000006060606050000000000000000000000060606060500000000000000060606060606060606060606050000000000000006060606050000000606060605000000060606061305050505050505050006060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060613050505050505050500060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606130505050505050505000606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606061305050505050505050006060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060613050505050505050505131313131313130506060606131313131313131313131305060606061313130506060606131313050606060606060606131313131313130506060606131313050606060602020208060606061313131313131313050505050505050505050505050505050500060606061305050505050505050505000606060613050500060606061305050006060606061010101305050505050500060606061305050006060606020808140606060613050505050505050505050505050505050505050505050505000606060613050505050505050505050006060606130505000606060613050500060606060610060613050505050505000606060613050500060606060208081406060606130505050505050505050505050505050505050505050505050006060606130505000000000005050500060606061305050006060606130505000606060606100606050000000000000006060606130505000606060608141414060606061305050505050505050505050505050505050505050505050500060606061305050006060606130505000606060613050500060606061305050006060606131313050606060606060606060606061305050006060606131313050606060613050505050505050505050505050505050505050505050505000606060613050500060606061305050006060606130505000606060613050500060606061305050006060606060606060606060613050500060606061305050006060606130505050505050505050505050505050505050505050505050006060606130505000606060613050500060606061305050006060606130505000606060613050500060606060606060606060606130505000606060613050500060606061305050505050505050505050505050505050505050500000000060606061305050006060606050000000606060613050500060606061305050006060606130505000606060606060606060606061305050006060606130505000606060613050505050505050505050505050505050505050500060610060606060613050505131313050606060606060606130505000606060613050500060606061305050513131313131313050606060613050505131313130505050006060606130505050505050505050505050505050505050505000606100606060606130505050505050006060606060606061305050006060606130505000606060613050505050505050505050006060606130505050505050505050500060606061305050505050505050505050505050505050505050006061006060606061305050505050500060606060606060613050500060606061305050006060606130505050505050505050500060606061305050505050505050505000606060613050505050505050505050505050505050505050500060610060606060613050500000000000606060606060606130505000606060613050500060606060500000000000000050505000606060613050505000000000505050006060606050000000505050505050505050505050505050505051313130506060606130505000606060613131305060606061305050006060606130505000606060606060606060606061305050006060606130505000606060613050500060606061313130513050505050505050505050505050505050505050500060606061305050006060606130505000606060613050500060606061305050006060606060606060606060613050500060606061305050006060606130505000606060613050000130505050505050505050505050505050505050505000606060613050500060606061305050006060606130505000606060613050500060606060606060606060606130505000606060613050500060606061305050006060606131305001305050505050505050505050505050505050505050006060606130505000606060613050500060606060500000006060606130505000606060606060606060606060500000006060606050000000606060613050500060606060500000013050505050505050505050505050505050505050500060606061305050006060606130505000606060606100606131313131305050006060606131313131313130513131305060606060707071206060606130505000606060613131313050505050505050505050505050505050505050505000606060613050500060606061305050006060606061006061305050505050500060606061305050505050500130500000606060607121213060606061305050006060606130505050505050505050505050505050505050505050505050006060606130505000606060613050500060606060610101013050505050505000606060613050505050505001313050006060606071212130606060613050500060606061305050505050505050505050505050505050505050505050500060606060500000006060606050000000606060606060606050000000000000006060606050000000000000005000000060606061213131306060606050000000606060613050505050505050505050505050505050505050505050505000606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606130505050505050505050505050505050505050505050505050006060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606061305050505050505050505050505050505050505050505050500060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060613050505050505050505050505050505050505050505050505000606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606060606130505050505050505050505050505050505050505050505050513131313131313050606060606060606131313131313131313131313131313050606060606060606060606061313131313131313131313131313130506060606131313130505050505050505050505050505050505050505050505050505050505050505050006060606060606061305050505050505050505050505050006060606060606060606060613050505050505050505050505050500101010101305050505050505050505050505050505050505050505050505050505050505050505050500060606060606060613050505050505050505050505050500060606060606060606060606130505050505050505050505050505000606060613050505050505050505050505050505050505050505050505050505050505050505050505000606060606060606130505050505050505050505050505000606060606060606060606061305050505050505050505050505050006060606130505050505050505050505050505050505050505050505050505050505050505050505050513131313131313130505050505050505050505050505050513131313131313131313131305050505050505050505050505050505131313130505050505050505050505050505050505"
	
	menuwires={}
	
	local x=0
	local y=0
	for i=1,#logo,2 do
		local col=sub(logo,i,i+1)
		if col=="10" then
			add(menuwires,{x=x+13,y=y+10})
		end
		pset(x+17,y+14,tonum(col))
		x+=1
		if x>=94 then
			x=0
			y+=1
		end
	end
	
	for w in all(menuwires) do
		if (rnd()<0.001) spawnwireparticle(w)
	end
	
	print("   press ❎ to start   ",18,88,7)
	print("-                     -",18,88,6)
	print("eddy rashed",42,102,7)
	print("oskar zanota",40,109,7)
	print("quentin rassat",36,116,7)
	
	drawparticles()
end

function drawmenu()
 cls(5)
 local i=1
 palt(14,true)
 palt(0,false)
 rect(18,32,109,91,6)
 line(51,32,75,32,5)
 print("levels",52,30,7)
 menulvls=0
 for _y=0,3 do
  for _x=0,7 do
   local x,y,found=_x*11-1,_y*13,false
   local mapx=((i-1)%8)*16
 		local mapy=(flr(i/(i%8==0 and 9 or 8)))*16
   for x2=mapx,mapx+15 do
    for y2=mapy,mapy+16 do
     found=mget(x2,y2)==16 and true or found
    end
   end
   if found then
   	local a,b=get_data(i,1),get_data(i,2)
   
	   print(i,x+23,y+40,(a and b) and 10 or 7)
	   if (i==menuci and not isonblocks) rect(x+21,y+38,x+31,y+50,7)
	   sspr(16,12,3,3,x+23,y+46)
	   sspr(20,12,3,3,x+27,y+46)
	   if (a) sspr(16,8,3,3,x+23,y+46)
	   if (b) sspr(20,8,3,3,x+27,y+46)
   	menulvls+=1
   end
   i+=1
  end
 end

	if not get_data(35,1) then
		color(7)
		print("⬆️",71,98)
		print("⬅️ ➡️ move",65,104)
		print("⬇️",71,110)
		print("❎ enter",22,101)
		print("🅾️ exit",22,108)
	else
		
		local x=64-9*8/2
		local y=100
		local index=0
		
		spr(89,x-8,y)
		spr(73,100,y)
		
		for s in all(cubes) do
			pal()
			palt(0,false)
			pal(4,6)
		
			spr(88,x,y-8)
			spr(72,x,y+8)
			spr(s,x,y)
			
			palt(4,true)
			if cube==s then
				if (isonblocks) pal(6,7)
				spr(27,x+1,y-5)
			end
			
			x+=8
			index+=1
		end
		pal()
		
	end
	
	
end

function drawgame()
 cls(5)
 palt(0,false)
 map(mapx,mapy)
 pal()
 spr(3,props.start.x,props.start.y)
 if (get_data(lvl,2)) then
  spr(17,props.crown.x,props.crown.y)
 end
 if (numred>0) numred-=1
 for b in all(props.num) do
 	if (b.unlocked) pal(7,11)
 	if (numred>0) pal(7,8)
 	spr(b.s,b.c.x,b.c.y)
 	pal()
 end
 
 drawparticles()
 palt(4,true)
 palt(0,false)
	if (not freezep) spr(cube,px,py)
	pal()
	
	if (menuci==30) line(0,0,0,128,5)
	
	drawtutorial()
end

function drawtutorial()
	if menuci==1 and l1tc>15 and not get_data(33,1)  then
		local cond=(l1tc/16)%1<0.5
		print("reach the chest to win",24,38,7)
		if inrange(l1tc,30,60) and cond then
			pal(4,2)
		end
		spr(4,props.chest.x,props.chest.y)

		
		if l1tc>75 then
			print("take the crown as a bonus",18,86,7)
		end
		if inrange(l1tc,105,135) and cond then
			pal(10,9)
		end
		spr(5,props.crown.x,props.crown.y)
		pal()
	end
	camera(0,0)
	if inrange(menuci,2,25) and diecounter>0 then
		diecounter-=1
		print("don't touch those!",28,getlowestlevelpoint(),7)
	end
	if isonportal and inrange(menuci,12,25) then
		print("press ❎ to teleport",24,getlowestlevelpoint(),7)
	end
	camera(shakex+mainoffsetx,shakey+mainoffsety)
end
-->8
-- gameplay

function initlvl()
 props={}
 props.ptp={}
 props.btp={}
 props.rtp={}
 props.gtp={}
 props.ytp={}
 props.wtp={}
 props.arrbut={}
 props.num={}
 props.numc=0
 props.numdone=false
 props.numend={}
 
 for _x=mapx,mapx+15 do
  for _y=mapy,mapy+15 do
   local s=mget(_x,_y)
   local arr={
   	x=_x*8-mapx*8,
   	y=_y*8-mapy*8
   }
   if s==16 then
    props.start=arr
   elseif s==5 then
    props.crown=arr
   elseif s==12 then
    for _x2=mapx,mapx+15 do
    	local s2=mget(_x2,_y)
     if s2==13 then
      arr.v=s==12 and 0 or 1
      arr.pc=rnd(50)
      arr.s=s
     	add(props.wtp,
     		{arr,
     			{
     				x=_x2*8-mapx*8,
     				y=_y*8-mapy*8,
     				v=(s2==12 and 0 or 1),
     				pc=rnd(50),
     				s=s2
     			}
     		}
     	)
     end
    end
   elseif s==28 then
    for _y2=mapy,mapy+15 do
    	local s2=mget(_x,_y2)
     if s2==29 then
      arr.v=s==28 and 3 or 2
      arr.pc=rnd(50)
      arr.s=s
     	add(props.wtp,
     		{arr,
     			{
     				x=_x*8-mapx*8,
     				y=_y2*8-mapy*8,
     				v=(s2==28 and 3 or 2),
     				pc=rnd(50),
     				s=s2
     			}
     		}
     	)
     end
    end
   elseif s==7 then
    add(props.ptp,arr)
   elseif s==23 then
    add(props.btp,arr)
   elseif s==39 then
    add(props.rtp,arr)
   elseif s==8 then
    add(props.gtp,arr)
   elseif s==9 then
    add(props.ytp,arr)
   elseif s>=44 and s<=47 then
   	arr.v=s-44
   	add(props.arrbut,arr)
   elseif s>=51 and s<=58 then
   	add(props.num,{
   		n=s-50,
   		s=s,
   		unlocked=false,
   		c=arr
   	})
   elseif s==59 then
   	add(props.numend,{
   		x=_x,
   		y=_y
   	})
   elseif s==4 then
   	props.chest=arr
   elseif s==5 then
   	props.star=arr
   end
  end
 end
 
-- assert(#props.ptp!=1,"missing second purple tp")
-- assert(#props.ptp<=2,"too many purple tps")
-- assert(#props.btp!=1,"missing second blue tp")
-- assert(#props.btp<=2,"too many blue tps")
-- assert(#props.rtp!=1,"missing second red tp")
-- assert(#props.rtp<=2,"too many red tps")
-- assert(#props.gtp!=1,"missing second green tp")
-- assert(#props.gtp<=2,"too many green tps")
--
-- assert(props.start,"missing start point in lvl "..lvl)
 px,py=props.start.x,props.start.y
end

function resetlvl()
 lvl=menuci
 pv=-1
 isblue=true
 movedist=0
 for x=mapx,mapx+16 do
  for y=mapy,mapy+16 do
   if (mget(x,y)==22) mset(x,y,21)
   if (mget(x,y)==19) mset(x,y,20)
   if (mget(x,y)==26) mset(x,y,10)
   if (mget(x,y)==42) mset(x,y,59)
  end
 end
 initlvl()
 particles={}
 arrows={}
 local arrspr={102,103,118,119}
 for _x=mapx,mapx+16 do
  for _y=mapy,mapy+16 do
  	if indexof(arrspr,mget(_x,_y))!=-1 then
  		add(arrows,{
  			x=_x,
  			y=_y,
  			s=mget(_x,_y)
  		})
  	end
  end
 end
 
 local width,height=0,0
 for x=mapx,mapx+15 do
 	if (mget(x,mapy+7)!=0) width+=1
 end
 for y=mapy,mapy+15 do
 	if (mget(mapx+7,y)!=0) height+=1
 end
 offsetx=0
 offsety=0
 if (width%2==0) offsetx=4
 if (height%2==0) offsety=4
 
 _upd=updategame
 _drw=drawgame
end

function resetarrows()
	for arr in all(arrows) do
		mset(arr.x,arr.y,arr.s)
	end
end

function die()
 sfx(6,3)
 shatter(7,px,py)
 shake=0.07
 resetarrows()
 resetlvl()
 if not get_data(34,1) then
 	diecounter=60
 	store(34,1,true)
 end
 spawnplayer()
end

function openlvl(lvl)
	if lvl==1 then
		l1tc=0
		if not get_data(33,1) then
		 freezep=true
		end
	end
	
	fadetarget=1
	timeout(function()
		store(35,1,true)
		resetlvl()
		freezep=true
		if (lvl!=1 or get_data(33,1)) then
			timeout(spawnplayer,8)
		end
		fadetarget=0
	end,10,1)
--	fadeperc=31
--	fadetarget=1
-- timeout(function()
-- 	resetlvl()
-- 	fadetarget=30
-- 	(function()
-- 		fadetarget=0
-- 		fadeperc=0
-- 	end,30)
-- end,30)
end

function updatetutorial()
	if menuci==1 and not get_data(33,1) then
		if l1tc<150 then
			l1tc+=1
		else
			store(33,1,true)
			spawnplayer()
		end
	end
end

function getlowestlevelpoint()
	for _y=mapy+15,mapy,-1 do
  for _x=mapx,mapx+15 do
  	local s=mget(_x,_y)
  	if s!=0 then
  		return (_y*8-mapy*8+2)-mainoffsety+4
  	end
  end
 end
end
-->8
-- tools

function assert(cond,msg)
 if not cond then
	 cursor(1,1,8)
	 print("runtime error:")
	 color(6)
  stop(msg)
 end
end

function indexof(arr,el)
	for k,v in pairs(arr) do
		if (v==el) return k
	end
	return -1
end

function rng(a,b)
	arr={}
	for i=a,b do
		add(arr,i)
	end
	return arr
end

function range(val1,val2)
 return rnd(val2-val1)+val1
end

function dist(x1,y1,x2,y2)
 return sqrt(((x1-x2)/16)^2+((y1-y2)/16)^2)*16
end

function inrange(v,l,g)
	return v>=l and v<=g
end

function sleep(n)
	for i=0,n do
		flip()
	end
end

function timeout(func,t,tpe)
	add(timeouts,{
		t=t,
		func=func,
		tpe=tpe
	})
end

function combine(...)
	local args={...}
	local combined={}
	for arr in all(args) do
		if type(arr)=='table' then
			for el in all(arr) do
				add(combined,el)
			end
		else
			add(combined,arr)
		end
	end
	return combined
end

function random(arr)
	return arr[flr(rnd()*#arr)+1]
end
-->8
-- particles and effects

--[[
	types:
		0: death shatter trail
		1: wire
		2: wall tp
		3: orb and portal
		4: portal animation
		5: crown
		6: spawn particles
]]--

function shakeit()

	mainoffsetx,mainoffsety=0,0
	if _upd==updategame then
	 local offsets="4000044440400404440400004440004400404004444440440400000044000000"
	 local i=menuci*2-1
	 mainoffsetx=tonum(sub(offsets,i,i))
	 mainoffsety=tonum(sub(offsets,i+1,i+1))
	end

 shakex=16-rnd(32)
 shakey=16-rnd(32)
 
 shakex=shakex*shake
 shakey=shakey*shake
 
 camera(shakex+mainoffsetx,shakey+mainoffsety)
 
 shake=shake*0.95
 if shake<0.05 then
  shake=0
 end
end

function updateparticles()
	if spawnparticles>0 then
		for i=0,2 do --spawnparticles>19 and 1 or 2 do
			spawnparticles-=1
			local p=lerp(3,1,(spawnparticles-20)/60)
			local x=range(4-p,4+p)
			local y=range(4-p,4+p)
			local sx,sy=(cube%16)*8,(cube\16)*8
			local col=sget(x+sx,y+sy)
--			local p=spawnparticles
--			local x=(35-p)%6+1
-- 		local y=flr((35-p)/6)+1
			add(particles,{
				x=px+x,
				y=py+y,
				dx=0,
				dy=0,
				col=col,--random({2,8})
				age=0,
				t=6,
				maxage=-1,
			})
		end
	end

	local rate=3
	local nparts=1
	local maxage=10
	local col=8
	local xo1,xo2,yo1,yo2=1,6,1,6
	if cube==32 then
		col=14
		--rate=1
		--nparts=3
		--maxage=120+rnd(60)
	elseif cube==33 then
		col=10
		maxage=10+rnd(3)
	elseif cube==34 then
		col=15
		rate=2
		maxage=3+rnd(7)
	elseif cube==35 then
		col=11
		rate=1
		nparts=2
		maxage=20+rnd(20)
	elseif cube==36 then
		col=12
		rate=2
		maxage=10+rnd(10)
	elseif cube==37 then
		col=2
	elseif cube==38 then
		col=1
		rate=1
		maxage=5+rnd(20)
	elseif cube==48 then
		col=13
	end
	col=wasonarr==0 and col or 11


	if (wasonarr>0) wasonarr-=1
	trailcounter+=1
	if not freezep and trailcounter>=rate then
	 trailcounter=0
	 for i=0,nparts do
			add(particles,{
				x=range(px+xo1,px+xo2),
				y=range(py+yo1,py+yo2),
				dx=0,
				dy=0,
				col=col,
				age=0,
				maxage=maxage,
				t=0
			})
		end
	end


	local generathors=8
	local wires={69,70,71,85,86,87,100,101,116,117}
	local wtp={12,13,28,29}
	for _x=mapx,mapx+15 do
  for _y=mapy,mapy+15 do
  	local s=mget(_x,_y)
  	if indexof(wires,s)!=-1 or indexof(wtp,s)!=-1 or indexof(tps,s)!=-1 or s==6 then
  		generathors+=1
  	end
  end
 end

	framecounter+=1
	for _x=mapx,mapx+15 do
  for _y=mapy,mapy+15 do
  	local s=mget(_x,_y)
  	local c={
   	x=_x*8-mapx*8,
   	y=_y*8-mapy*8
   }
  	
  	if indexof(wires,s)!=-1 and rnd()<1/generathors*0.06 then
  		spawnwireparticle(c)
  	end

  	local index=indexof(tps,s)
  	if index!=-1 then
 	 	local isontp=px==c.x and py==c.y
	  	if isontp and framecounter>10 or rnd()<1/generathors*0.08 then
	  		framecounter=0
	  		local _ang = rnd()
			  local _dx = sin(_ang)*0.2
			  local _dy = cos(_ang)*0.2
	  		add(particles,{
			  	x=c.x+4,
			  	y=c.y+4,
			  	spx=c.x+4,
			  	spy=c.y+4,
			  	dx=_dx,
			  	dy=_dy,
			  	t=3,
			  	age=0,
			  	maxage=30,
			  	col=tpcol[index][flr(rnd(2))+1]
			  })
			 end
  	end
  	
  	if s==6 then
  		local isonorb=px==c.x and py==c.y
  		if isonorb and framecounter>10 or rnd()<1/generathors*0.08 then
	  		framecounter=0
	  		local _ang = rnd()
			  local _dx = sin(_ang)*0.2
			  local _dy = cos(_ang)*0.2
	  		add(particles,{
			  	x=c.x+4,
			  	y=c.y+4,
			  	spx=c.x+4,
			  	spy=c.y+4,
			  	dx=_dx,
			  	dy=_dy,
			  	t=3,
			  	age=0,
			  	maxage=isonorb and 30 or 20,
			  	col=12
			  })
			 end
  	end
  end
 end
 
 for pair in all(props.wtp) do
 	for tp in all(pair) do
			local d={
	 		{1,0},
	 		{-1,0},
	 		{0,-1},
	 		{0,1}
	 	}
	 	local i=indexof(wtp,tp.s)
	 	tp.pc+=1
	 	if rnd()<1/generathors*0.2 then
	 		tp.pc=0
	 		local _dx=d[i][1]
	 		local _dy=d[i][2]
	 		add(particles,{
		  	x=(tp.x+4)+_dx*-3+(_dx==0 and range(-3,3) or 0),
		  	y=(tp.y+4)+_dy*-3+(_dy==0 and range(-3,3) or 0),
		  	dx=_dx*range(0.4,0.6),
		  	dy=_dy*range(0.4,0.6),
		  	t=2,
		  	age=0,
		  	maxage=15,
		  	col=12,
		  	start=rnd(7)
		  })
	 	end
	 end
 end

	tppartcount=0
	for p in all(particles) do
		p.age+=1
  if p.age>p.maxage and p.maxage!=-1 then
   del(particles,p)
  else
  	if not p.stop then
  		if p.t==2 then
  			p.dx*=0.98
  			p.dy*=0.98
  		end
  		if p.t==4 then
  			tppartcount+=1
  		 p.dx*=0.905
  			p.dy*=0.905
  			if p.age>7 then
  				p.dx+=(p.x<p.tx and 0.36 or -0.36)
  				p.dy+=(p.y<p.ty and 0.36 or -0.36)
  				if dist(p.x,p.y,p.tx,p.ty)<4 then
  					del(particles,p)
  				end
  			end
  		end
  		
  		if p.t==5 then
  		 p.dx*=0.905
  			p.dy*=0.905
  			if p.age>4 then
  				p.dx+=(p.x<p.tx and 0.36 or -0.36)
  				p.dy+=(p.y<p.ty and 0.36 or -0.36)
  			end
  			if dist(p.x,p.y,p.tx,p.ty)<8 then
 					del(particles,p)
 				end
  		end
  	
	  	p.x+=p.dx
	   p.y+=p.dy
	  end
  end
	end
	if tppartcount==0 and tppartcountbefore>0 then
		freezep=false
	end
	tppartcountbefore=tppartcount
end

function drawparticles()
	for p in all(particles) do
	
		local delcols={5,0,13}
 	if indexof(delcols,pget(p.x+p.dx,p.y+p.dy))!=-1 then
	 	if p.t!=4 and p.t!=5 then
	 		if p.t==3 then
	 			if dist(p.spx,p.spy,p.x,p.y)>3 then
	 			 p.stop=true
	 			end
	 		else
	 			p.stop=true
	 		end
	 	end
 	end
	
		if indexof({0,1,2,3,4,6},p.t)!=-1 then
		 if not (p.t==6 and p.col==4) then
		 	palt(0,false)
			 pset(p.x,p.y,p.col)
			end
		end
		
		if p.t==5 then
			palt(6,true)
			spr(5,p.x,p.y)
			pal()
		end
	end
end

function wtpparts(x,y,d)
	local _dx=dirx[d+1]
	local _dy=diry[d+1]
	for i=0,10 do
		add(particles,{
			x=(x+4)+_dx*-3+(_dx==0 and range(-3,3) or 0),
			y=(y+4)+_dy*-3+(_dy==0 and range(-3,3) or 0),
			dx=_dx*range(0.4,0.8),
			dy=_dy*range(0.4,0.8),
			t=2,
			age=0,
			maxage=10+rnd(10),
			col=12,
			start=rnd(7)
		})
	end
end

function shatter(col,x,y)
	for i=0,10 do
  local _ang = rnd()
  local _dx = sin(_ang)
  local _dy = cos(_ang)

  add(particles,{
  	x=x+4,
  	y=y+4,
  	dx=_dx,
  	dy=_dy,
  	t=0,
  	age=0,
  	maxage=6+rnd(22),
  	col=col
  })
 end
end

function tpanim(x1,y1,x2,y2,s)
	for i=0,10 do
  local _ang = rnd()
  local _dx = sin(_ang)*1.3
  local _dy = cos(_ang)*1.3
		
  add(particles,{
  	x=x1+4,
  	y=y1+4,
  	dx=_dx,
  	dy=_dy,
  	tx=x2+4,
  	ty=y2+4,
  	t=4,
  	age=0,
  	maxage=-1,
  	col=tpcol[indexof(tps,s)][flr(rnd()*2)+1]
  })
 end
end

function spawnplayer()
	freezep=true
	spawnparticles=60
	timeout(function()
		freezep=false
		for p in all(particles) do
			if (p.t==6) del(particles,p)
		end
	end,21,0)
end

function spawnwireparticle(c)
	local _ang = rnd()
 local _dx = sin(_ang)*0.3
 local _dy = cos(_ang)*0.3
	add(particles,{
 	x=c.x+4,
 	y=c.y+4,
 	dx=_dx,
 	dy=_dy,
 	t=1,
 	age=0,
 	maxage=20,
 	col=10
 })
end
__gfx__
00000000444444445dddddd5666666666666666666666666666666666662266666633666666996665dddddd50000000066666666666666660000000000000000
0000000049999984d555555066666666664444666666666666dddd6666211166663bbb66669aaa66d555d55000000000c66666666666666c0000000000000000
0070070049888824d555555066666666644aa4466a6666a66dd66dd66211226663bb336669aa9966d55d55500a0000a0cc666666666666cc0000000000000000
0007700049888824d555555066666666649a99466a6aa6a66d67c6d66212112663b3bb3669a9aa96d55d50500a0aa0a0cc666666666666cc0000000000000000
0007700049888824d555555066666666644444466aaaaaa66d6cc6d66211212663bb3b3669aa9a96d55555000aaaaaa0cc666666666666cc0000000000000000
0070070049888824d5555550666666666445d44668a88a866dd66dd6662211266633bb366699aa96dd55555008a88a80cc666666666666cc0000000000000000
0000000048222224d555555066666666644444466aaaaaa666dddd666611126666bbb36666aaa966d55055500aaaaaa0c66666666666666c0000000000000000
00000000444444445000000566666666666666666666666666666666666226666663366666699666500000050000000066666666666666660000000000000000
6666666666666666e4eeaeaeeffffffe82222228c777777cd111111d666dd66676666666666666676666666666666444666666666cccccc60000000000000000
6658866666666666494e8a8efeeeeee82888888e7ccccccd1ddddddc66dccc66776666666666667766666666466644446666666666cccc660000000000000000
6658888667666676444eaaaefeeeeee82888888e7ccccccd1ddddddc6dccdd667666666666666667666666664464444466666666666666660000000000000000
6658866667677676eeeeeeeefeeeeee82888888e7ccccccd1ddddddc6dcdccd66666666666666666666666664444444466666666666666660000000000000000
6656666667777776e0ee0e0efeeeeee82888888e7ccccccd1ddddddc6dccdcd66666666666666666666666664444444466666666666666660000000000000000
6656666666766766000e000efeeeeee82888888e7ccccccd1ddddddc66ddccd67666666666666667666666664444444466666666666666660000000000000000
6656666667777776000e000efeeeeee82888888e7ccccccd1ddddddc66cccd667766666666666677666666664444444466cccc66666666660000000000000000
6656666666666666eeeeeeeee88888828eeeeeefcdddddd1dcccccc7666dd666766666666666666766666666444444446cccccc6666666660000000000000000
444444444444444444444444444444444444444444444444444444446668866666666666777667776666666600000000666666666666666666bbbb6666666666
477777e4477777a4477777f4477777b4477777c44eeeee244ddddd14668eee6666666666676666766666666600000000666666666666666666bbbb6666666666
47eeee2447aaaa9447ffff9447bbbb3447cccc144e2222044d11110468ee886666666666666666666666666600000000bb666666666666bb6666666666666666
47eeee2447aaaa9447ffff9447bbbb3447cccc144e2222044d11110468e8ee8666666666666666666666666600000000bb666666666666bb6666666666666666
47eeee2447aaaa9447ffff9447bbbb3447cccc144e2222044d11110468ee8e8666666666666666666666666600000000bb666666666666bb6666666666666666
47eeee2447aaaa9447ffff9447bbbb3447cccc144e2222044d1111046688ee8666666666666666666666666600000000bb666666666666bb6666666666666666
4e2222244a9999944f9999944b3333344c111114420000044100000466eee8666766667666666666666666660000000066666666666666666666666666bbbb66
44444444444444444444444444444444444444444444444444444444666886667776677766666666666666660000000066666666666666666666666666bbbb66
4444444400000000000000005dddddd55dddddd55dddddd55dddddd55dddddd55dddddd55dddddd55dddddd55dddddd500000000000000000000000000000000
477777d40000000000000000d5555550d5555550d5555550d5555550d5555550d5555550d5555550d5555550d555555000000000000000000000000000000000
47dddd540000000000000000d5555550d5555750d5577550d5755750d5755750d5575750d5575750d5575750d5ddd75000000000000000000000000000000000
47dddd540000000000000000d5577550d5555550d5555550d5555550d5577550d5755550d5757550d5757550d5d7705000000000000000000000000000000000
47dddd540000000000000000d5577550d5555550d5555550d5555550d5577550d5555750d5555750d5575750d5d7705000000000000000000000000000000000
47dddd540000000000000000d5555550d5755550d5755750d5755750d5755750d5757550d5757550d5757550d570005000000000000000000000000000000000
4d5555540000000000000000d5555550d5555550d5555550d5555550d5555550d5555550d5555550d5555550d555555000000000000000000000000000000000
44444444000000000000000050000005500000055000000550000005500000055000000550000005500000055000000500000000000000000000000000000000
d55555505dddddddd555555055555550d55555556666666666666666666aa666ddddddddd555555500000000000000000000000000000000000000cccc000000
d5555550d5555555d555555055555550d55555556666666666666666666aa66655555555d5555555000000000000000000000000000000000000cccccccc0000
d5555550d5555555d555555055555550d55555556666666666666666666aa66655555555d5555555000000000000bbbbbbbb000000000000000cccccccccc000
d5555550d5555555d555555055555550d5555555666aaaaaaaaaa666666aa66655555555d5555555000000000bbbbbbbbbbbbbb00000000000cccccccccccc00
d5555550d5555555d555555055555550d5555555666aaaaaaaaaa666666aa66655555555d55555550000000bbbbbbbbbbbbbbbbbb00000000cccccccccccccc0
d5555550d5555555d555555055555550d5555555666aa666666aa666666aa66655555555d5555555000000bbbbbbbbbbbbbbbbbbbb0000000cccccccccccccc0
d5555550d5555555d555555055555550d5555555666aa666666aa666666aa66655555555d555555500000bbbbbbbbbbbbbbbbbbbbbb00000cccccccccccccccc
5000000550000000d55555500000000050000000666aa666666aa666666aa66655555555d555555500000bbbbbbbbbbbbbbbbbbbbbb00000cccccccccccccccc
ddddddd55dddddd5ddddddddddddddd5dddddddd666aa666666aa66666666666555555555555555000000bbbbbbbbbbbbbbbbbbbbbb00000cccccccccccccccc
55555550d55555505555555555555550d5555555666aa666666aa66666666666555555555555555000000bbbbbbbbbbbbbbbbbbbbbb00000cccccccccccccccc
55555550d55555505555555555555550d5555555666aa666666aa666666666665555555555555550000000bbbbbbbbbbbbbbbbbbbb0000000cccccccccccccc0
55555550d55555505555555555555550d5555555666aaaaaaaaaa666aaaaaaaa55555555555555500000000bbbbbbbbbbbbbbbbbb00000000cccccccccccccc0
55555550d55555505555555555555550d5555555666aaaaaaaaaa666aaaaaaaa5555555555555550000000000bbbbbbbbbbbbbb00000000000cccccccccccc00
55555550d55555505555555555555550d55555556666666666666666666666665555555555555550000000000000bbbbbbbb000000000000000cccccccccc000
55555550d55555505555555555555550d55555556666666666666666666666665555555555555550000000000000000000000000000000000000cccccccc0000
00000005d55555500000000055555550d5555555666666666666666666666666000000005555555000000000000000000000000000000000000000cccc000000
00000000000000000000000000000000666aa66666666666666bb666666bb6660000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000666aa66666666666666bbb6666bbb6660000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000666aa66666666666bbbbbbb66bbbbbbb0000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000aaaaaaaaaaaaaaaabbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000aaaaaaaaaaaaaaaabbbbbbb33bbbbbbb0000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000066666666666aa666333bbb3663bbb3330000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000066666666666aa666666bb366663bb6660000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000066666666666aa66666633666666336660000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000666aa666666aa666666bb66666bbbb660000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000666aa666666aa66666bbbb6666bbbb660000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000666aa666666aa6666bbbbbb666bbbb660000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000aaaaa666666aaaaabbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000aaaaa666666aaaaa33bbbb333bbbbbb30000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000666aa666666aa66666bbbb6663bbbb360000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000666aa666666aa66666bbbb66663bb3660000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000666aa666666aa66666333366666336660000000000000000000000000000000000000000000000000000000067006767
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000850000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000085000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000008534754485008500000000000000000000000000000000000000
00000000858585858585858585000000000000000000003443440000000000000000000000000000000000000000000000000000008585858585858585000000
00000000000000000000000000000000000000000000000000000000000000000000000000953030303030040194000000000000000000000000000000000000
0000009540b301303066303033940000000000000000346530309400000000000000000000858585000085850000000000000085348130303030303030940000
00000000000000008500000000000000000000000000000000000000000000000000000000953020303030303094000000000000000000000000000000000000
00000000848425053030303030940000000000000034653030304485000000000000000095c03030943466d09400000000009530303131503051516430940000
000000000000853450448500000000000000000085858585858585858500000000000000009530303015c1544500000000000000008585858585858500000000
00000000009530303030203030940000000000009533303060303053940000000000000095501530046530309400000000009530313130303030517430940000
00000000009574306630309400000000000000950130305131303030304400000000000000008425848525250000000000000000950130303031303094000000
00000085853430303030303030940000000000000084356401305445000000000000000095710431303030140000000000009530313001303030516530940000
00000000000035303030f294000000000000003430303030303030513030940000000000858534500430d1304485850000000000953030513030303094000000
00009550513076303030303030940000000000000000957430304500000000000000000000053030303030309400000000009530823030303030923091940000
0000000000003430303014000000000000009540313130306030305151309400000000343030d0a0c030a03030a0409400000000953175653030513094000000
00000084848405303030303030940000000000000000957430304400000000000000000095743030301571309400000000000095513082303031303030940000
000000000095403077300194000000000000003531313130303030205030940000003430303030a0643060303045840000000000955030305130303094000000
00000000009530666730302030940000000000000000003530a05094000000000000000095741540822464019400000000000095515151303030303051940000
00000000000035303030140000000000000000008484355651303030303094000095303030140530450530207594000000000000008484354045848400000000
000000000095303030303030309400000000000000000095b3458400000000000000000000840084840084840000000000000085053030303060303030940000
00000000000095303030749400000000000000000000008484848484848400000095703015807430247030804500000000000000000000008400000000000000
00000000000084848484848484000000000000000000009540940000000000000000000000000000000000000000000000009540513030308230303030940000
00000000000000848484840000000000000000000000000000000000000000000000848495302030948484840000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000084000000000000000000000000000000000000000000000000000084848484848484848484000000
00000000000000000000000000000000000000000000000000000000000000000000000095303030940000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000848484000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000008585850085858500858585008585000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000008585858585850000858585850000858585858500000000000000000000
00000000000000000000000000000000950130300430303004303030043072940000000000000000000000000000000000008585858500000000858585858500
00000000000000000000000000000000000000000000000085000000000000000000953030d130306394957130b39194953030a0929094850000000000000000
00008585858585858585858585850000000570303030303030303030306030940000000000000000000000000000000000953030303044000095747751307494
00000000000085000000000000000000000000858585853430448585000000000000953030303030140095305030450095303030304534534400858500000000
0095547575757575757575757564940095303030303015302030153030303094000000000000000000000000000000000034012030c192448534653030204794
00008585853433448500000000000000000095303030303030303030440000000000953020303030309495303030940095302030300430306304303044858500
0095743030303060303030603074940095303030544595303030442505757594000000000085858585858585000000009550a030d020c0313030303060305594
0095433030303030539400008585858500009530544525353030303030940000000095303020303030448525252500009530303030b330803033663030307794
009574306030303030603030307494000084252525858584250577307145840000000000347730303030d151940000000035303020d154458435643030301400
00000530303030301400003493303083940095305504300430302030309400000000955330303030307430303030440000843530301530303015303072153094
009574603030303030303030607494000095723030333024c2303030309400000000009530303020757520309400000000956730303074940095571530544694
009530303030303030449530303030450000953030a030a0a0304030309400000000008435c13030d220c2303030309400000084840035435194053014953094
00957430603030303030603030749400009543303030302483303030639400000000009530302001303060919400000000008484848484000000849531458400
009530304505303030700430203030440000953030a03030a0303030309400000085850000848405308330721530309400000000000000053004713030043094
00957430823030307130303030749400009530673076309435b373754500000000000095c0303020513030d09400000000000085858585000000853430448500
00953030043030303030b330923030409400953030a03030a0303030309400009530309400003465304525253430309400000085008595c23030303030307694
009574502081300130603030307494000095303030305344343030509400000000000095302030743030303094000000000034303074d1940095756530557594
009530305030303030a0a030303030450000953020813001a0142525250000009530304485349230300472309293140000009572247094355015306730452500
000025056030308260303030307494000000842584250530301484840000000000000095303030744082c1509400000000346530307430448534c0709120d094
003430302030303030453530303045000000953030a0a0a0a03030303094000095f2309292a03030763030306030719400009530243094008485252525340194
009574713030402081303060607494000000957024303076303044850000000000000000848484848484848400000000954071309120303030a0303030309194
95633030303030917394953070309400000000843530303030303030309400000005303030303015013030303091140000009530243094009570a03130303094
00957430603030923030603030749400000095300430304505303030440000000000000000000000000000000000000000353030303014848484058170911400
008435013030304584000084848400000000000000848435a0458484840000009543203030303024b315c0153030d09400853430043044850084353030153094
0095557575757575757575757565940000009530303030244014053074940000000000000000000000000000000000000095c0a03030c194009575756471d094
000000848484840000000000000000000000000000000095509400000000000095303030303045954024304425848400954030a030a030909400953014343094
00008484848484848484848484840000000000357130459530303030450000000000000000000000000000000000000000008484848484000000848484848400
00000000000000000000000000000000000000000000000084000000000000009530303030339400849530307394000000843580157145840000953030303094
00000000000000000000000000000000000000008484000084848484000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000084848484840000000084848400000000000084008400000000008484848400
__label__
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555500000000555555555555555555555555000000000000555555555555555555555555555555555555555555
55555555555555555555555555555555555555555066666666d55555555555555555555550666666666666d55555555555555555555555555555555555555555
55555555555555555555555555555555555555555066666666d55555555555555555555550666666666666d55555555555555555555555555555555555555555
55555555555555555555555555555555555555555066666666d55555555555555555555550666666666666d55555555555555555555555555555555555555555
55555555555555555555550000000000000000000066666666500000000000000000000000666666666666500000000000000000005555555555555555555555
5555555555555555555550666666666666666666666666666666666666666666666666666666666666666666666666666666666666d555555555555555555555
5555555555555555555550666666666666666666666666666666666666666666666666666666666666666666666666666666666666d555555555555555555555
5555555555555555555550666666666666666666666666666666666666666666666666666666666666666666666666666666666666d555555555555555555555
5555555555555555550000666666666666666666666666666666666666666666666666666666666666666666666666666666666666d555555555555555555555
55555555555555555066666666ddddddddddd56666ddd56666666666666666ddddddd56666ddd5ddddddd56666ddd56666ddd56666d555555555555555555555
55555555555555555066666666d555555555506666d5006666666666666aaad55555506666d500d55555506666d5506666d5506666d555555555555555555555
55555555555555555066666666d555555555506666dd506666666666666a66d55555506666dd50d55555506666d5506666d5506666d555555555555555555555
55555555555555555066666666d55000005550666650006666666666666a665000555066665000500000006666d5506666d5506666d555555555555555555555
55555555555555555066666666d5506666d5506666ddd5666666666666ddd56666d5506666ddd5666666666666d5506666d5506666d555555555555555555555
55555555555555555066666666d5506666d5506666d550666666666666d5506666d5506666d550666666666666d5506666d5506666d555555555555555555555
55555555555555555066666666d5506666d5506666d550666666666666d5506666d5506666d550666666666666d5506666d5506666d555555555555555555555
55555555555555555066666666d550666650006666d550666666666666d5506666d5506666d550666666666666d5506666500066665000555555555555555555
555555555555555555ddd56666d555ddd566666666d550666666666666d5506666d5506666d550666666666666d555ddd5666666666666d55555555555555555
55555555555555555555506666d555555066666666d550666666666666d5506666d5506666d550666666666666d5555550666666666666d55555555555555555
55555555555555555555506666d555555066666666d550666666666666d5506666d5506666d550666666666666d5555550666666666666d55555555555555555
55555555555555555555506666d550000066666666d550666666666666d5506666d5506666d550666666666666d5550000666666666666d55555555555555555
55555555555555555555506666d5506666ddd56666d550666666666666d5506666d5506666d550666666666666d5506666ddd566666666d55555555555555555
55555555555555555555506666d5506666d5506666d550666666666666d5506666d5506666d550666666666666d5506666d55066666666d55555555555555555
55555555555555555555506666d5506666d5506666d550666666666666d5506666d5506666d550666666666666d5506666d55066666666d55555555555555555
55555555555555555555506666d5506666d5506666d550666666666666d5506666500066665000666666666666d5506666d55066666666d55555555555555555
55555555555555555555506666d555ddddd5506666d555ddddddd56666d555ddd566a666666a66ddddddd56666d5506666d5506666dddd555555555555555555
55555555555555555555506666d555555555506666d555555555506666d555555066a666666a66d55555506666d5506666d5506666d555555555555555555555
55555555555555555555506666d555555555506666d555555555506666d5555550aaa666666aaad55555506666d5506666d5506666d555555555555555555555
5555555555555555555550666650000000000066665000000000006666500000006666666666665000000066665000666650006666d555555555555555555555
5555555555555555555550666666666666666666666666666666666666666666666666666666666666666666666666666666666666d555555555555555555555
5555555555555555555550666666666666666666666666666666666666666666666666666666666666666666666666666666666666d555555555555555555555
5555555555555555555550666666666666666666666666666666666666666666666666666666666666666666666666666666666666d555555555555555555555
5555555555555555555550666666666666666666666666666666666666666666666666666666666666666666666666666666666666d555555555555555555555
5555555555555555555555ddddddd56666ddddddddddd56666ddd56666ddd566666666ddddddd56666ddd5666622286666dddddddd5555555555555555555555
5555555555555555555555555555506666d555555555506666d5506666d55066666aaad55555506666d5506666288e6666d55555555555555555555555555555
5555555555555555555555555555506666d555555555506666d5506666d55066666a66d55555506666d5506666288e6666d55555555555555555555555555555
5555555555555555555555555555506666d550000055506666d5506666d55066666a66500000006666d55066668eee6666d55555555555555555555555555555
5555555555555555555555555555506666d5506666d5506666d5506666d5506666ddd5666666666666d5506666ddd56666d55555555555555555555555555555
5555555555555555555555555555506666d5506666d5506666d5506666d5506666d550666666666666d5506666d5506666d55555555555555555555555555555
5555555555555555555555555555506666d5506666d5506666d5506666d5506666d550666666666666d5506666d5506666d55555555555555555555555555555
5555555555555555555555555500006666d550666650006666d5506666d5506666d550666666666666d5506666d5506666d55555555555555555555555555555
5555555555555555555555555066a66666d555ddd566666666d5506666d5506666d555ddddddd56666d555dddd55506666d55555555555555555555555555555
5555555555555555555555555066a66666d555555066666666d5506666d5506666d555555555506666d555555555506666d55555555555555555555555555555
5555555555555555555555555066a66666d555555066666666d5506666d5506666d555555555506666d555555555506666d55555555555555555555555555555
5555555555555555555555555066a66666d550000066666666d5506666d55066665000000055506666d555000055506666500055555555555555555555555555
55555555555555555555555555ddd56666d5506666ddd56666d5506666d550666666666666d5506666d5506666d5506666ddd5d5555555555555555555555555
5555555555555555555555555555506666d5506666d5506666d5506666d550666666666666d5506666d5506666d5506666d500d5555555555555555555555555
5555555555555555555555555555506666d5506666d5506666d5506666d550666666666666d5506666d5506666d5506666dd50d5555555555555555555555555
5555555555555555555555555555506666d5506666d550666650006666d5506666666666665000666650006666d55066665000d5555555555555555555555555
5555555555555555555555555555506666d5506666d55066666a66ddddd5506666ddddddd5ddd56666777c6666d5506666dddd55555555555555555555555555
5555555555555555555555555555506666d5506666d55066666a66d55555506666d5555550d50066667ccd6666d5506666d55555555555555555555555555555
5555555555555555555555555555506666d5506666d55066666aaad55555506666d5555550dd5066667ccd6666d5506666d55555555555555555555555555555
5555555555555555555555555555506666500066665000666666665000000066665000000050006666cddd666650006666d55555555555555555555555555555
55555555555555555555555555555066666666666666666666666666666666666666666666666666666666666666666666d55555555555555555555555555555
55555555555555555555555555555066666666666666666666666666666666666666666666666666666666666666666666d55555555555555555555555555555
55555555555555555555555555555066666666666666666666666666666666666666666666666666666666666666666666d55555555555555555555555555555
55555555555555555555555555555066666666666666666666666666666666666666666666666666666666666666666666d55555555555555555555555555555
555555555555555555555555555555ddddddd566666666ddddddddddddddd5666666666666ddddddddddddddd56666dddd555555555555555555555555555555
5555555555555555555555555555555555555066666666d555555555555550666666666666d555555555555550aaaad555555555555555555555555555555555
5555555555555555555555555555555555555066666666d555555555555550666666666666d5555555555555506666d555555555555555555555555555555555
5555555555555555555555555555555555555066666666d555555555555550666666666666d5555555555555506666d555555555555555555555555555555555
55555555555555555555555555555555555555dddddddd5555555555555555dddddddddddd5555555555555555dddd5555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555

__gff__
0000010000000404040401000000000000000001000100040000000000000000000000000000000400000000000000000000000101010101010101010101000001010101010202020101010001000000010101010102020201010000000000000101010102020000010100000000000001010101020200000101000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001201400000000000120140000000050d060606000000050d060606
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005858585858005858000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005800000058000000580000000000000000435756105557421d03490000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000058585800585858585800000000000000585858585858005858000000000000595744004357490059574900000000005843030303030303400303490000000058585858585800585858000000
0000000000000000000000000000000000000000585858580000580000000000000000585858005858585800000000000000005910030340030303554649000000000059105546030303400303490000000000590c034003034458590d4900000000595603030303024603470303490000005975575756030340030303490000
0000000000005858005858000000000000000059100303034459044900000000000059100303405603030344580000000000000050030303030303034749000000000059030302030203470303490000000000590303470303030340034900000000590c0306030303470351030d490000005947510303030303030303490000
0000000000590403400303490000000000000000525003035540034400000000000059030503470303030304474900000000005903030d020c0306034100000000000000500303034703470305490000000000590303470603030310194900000000595757460303025603425757490000005947420303030303030303490000
00000000000050030303034900000000000000594703030303030305490000000000590303030203030303034749000000000059030303470303280303490000000000590c030303020302030d490000000000590303470303030302044900000000004852500303030303494848000000005956400303030303030303490000
00000000005910030303540000000000000000005003030354500354000000000000005003030303030306034749000000000059575702560319021845490000000000595702575756035557574900000000005903034703030303555749000000000059054703030303545858580000000059040a03100a0a0a030303490000
00000000000053055448000000000000000000594703034143560349000000000000590303030303020303035549000000000059030303030303290347490000000000597703030303030a0303490000000000590303470303030303034900000000005903550203030340030303490000005945510303030303030341000000
0000000000000048000000000000000000000059470303030303034900000000000059030303510303030303034900000000005903030303030304024749000000000059030303037702030303490000000000590303020303035450034900000000005976030303030347030303490000005947420303030303030303490000
0000000000000000000000000000000000000000484848484848480000000000000000484848590303035103034900000000000050460303030303054749000000000000530303030347045448000000000000590c030502034159030d4900000000000048485303035174030603490000005947420303030303030a54000000
0000000000000000000000000000000000000000000000000000000000000000000000000000004848480048480000000000005903555757515757575649000000000000004848484848480000000000000000005303030303474203034900000000000000005957574953030345490000005947420303030a03510549000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000048484848004848484800000000000000000000000000000000000000000000000048484848480048480000000000000000000048480059041c47490000000048004848484848004800000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000484848000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000058000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005858005800585858585800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005929495858005858000000
000000000058585800585858000000000000000000580000000000000000000000005858005800000000585800000000000059100340084057575757464900000000000000000000580000000000000000000000000000000000000000000000000000000000000000000000000000000000000000591c420303400303490000
000000005904031d420303034900000000000000430549000000585800000000005957574057495800590403440000000000590303030303030303034100000000000058585800430744585858580000000000000058585858585858000000000000000058585858585858580000000000000000000048590303031c03490000
0000000000525252430303034900000000000059470349585859040349000000004303030303405749430303034400000000594603030306030302034749000000005910030340030303471d471d4900000000005910031503030303490000000000005915031d03035557574900000000000000000000005003415252580000
00000000590303030303030a49000000000000005003400303445003490000005903030303032903400366030347440000005955020303030303030355490000000059030303030305034703020349000000000059030303030303034900000000000059180303030a03100a4900000000000000000000430303030347034900
000000005903035103030319490000000000004303030303030329034400000059030d02030203030303030303510c490000590c05030303190246030d49000000005903031c03030303020303034900000000005903030303150303490000000000005903030203030302044900000000000000000059030303020302034900
000000005903034003020303490000000000590c03035103030306030d490000005057740303030203030303034003490000590303030328030355025749000000000052524852506557645448480000000000005913030303025757490000000000005903030303030355410000000000000000000043030302030303034900
00000000590303060303030349000000000000530341585003030345540000005903100203030329030303030303194900005903030303025746455608490000000059030d400303020c07445858000000000000590303030303040549000000000000590303060303030319490000000000000000431d545303030351034900
000000005903030303030341000000000000005903470303030303540000000059030256030303030303030218030549000059460303030303027404034900000000590c031d030303035103030d4900000000005903030303030313490000000000005957461c030d510c054900000000000000435603444310034159034900
000000005903031c030303034900000000000059030210020a02574900000000590303032803517603030303030354000000595557020303034574030349000000005903030303030303400302044900000000000048484848484848000000000000000048484848480048480000000000000059470306032741501d40034900
000000005957575105511003490000000000005903030a030a03034900000000004848484848004848484848484800000000590303555757514751030349000000005903030303510303471c471c4900000000000000000000000000000000000000000000000000000000000000000000000058500303030303030303034900
00000000004848004800484800000000000000004848484848484800000000000000000000000000000000000000000000000048484848480048004848000000000000484848480048484848484800000000000000000000000000000000000000000000000000000000000000000000000059270303030a0a0a0a0304540000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000048530303544848530554000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004848000000004800000000
__sfx__
011a00000903212032190321c03219032120321c032190320b032140321b0321e0321b032140321e0321b0320d032140321c032200321c03214032200321c0320d032140321c032200321c03214032200321c032
011a00000903212032190321c0322c0121c0322a0121c0320b032140321b0321e0321b0321403234012330120d032140321c032200322c01220032280121c0320d032140321c032200321c03214032200321c032
011a0000150321e03225022280222c012280222f0122c0321703220032270322a032340122a032330122a0321803220032270322a0322a0322803227032280320d032140321c032310122f0121c032200321c032
010b00001975419753197550000000000000000000000000310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c00001105300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010600000c0540c055000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01100000132531d600132530000000000000001c20022200252002b2002e200322003420000000352001420000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000d65500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011a000009030090300903009030090300903009030090300b0300b0300b0300b0300b0300b0300b0300b0300d0300d0300d0300d0300d0300d0300d0300d0300d0300d0300d0300d0300d0300d0300d0300d030
011a000009030090300903009030090300903009030090300b0300b0300b0300b0300b0300b0300b0300b0300c0300c0300c0300c0300c0300c0300c0300c0300d0300d0300d0300d0300b0300b0300b0300b030
011a00001503015030150301503015030150301503015030170301703017030170301703017030170301703019030190301903019030190301903019030190301903019030190301903019030190301903019030
011a00001503015030150301503015030150301503015030170301703017030170301703017030170301703018030180301803018030180301803018030180301903019030190301903023030230302303023030
011a0000017530170001700017530d63301753017530d6000d6000170001753255000d633285002850028500017530170001700017530d63301753017530d6000d6000170001753255000d633285002850028500
011000001805000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000001c05000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000001f05000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000002405000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000002805000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000002b050000000000000000000001c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000003005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000001c050180501f0503005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000001c05018050140500105000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011400020c0440c045240000b0002d000310003100009000350000a00038000090003a0000a000000000000000000000003a0000d000380000d000360000d000310000d0002c0000e00026000100002100018000
011000000c04010040130401804000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0110000024040280402b0403004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000002504130002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000002404324043240000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010800001804418043180000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
01 000a0e44
00 000a0e44
00 010a0e44
02 020b0e44

