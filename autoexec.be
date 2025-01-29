print("load autoexec")
import persist

# prototypes ;-) eigentliche Instanzen/Objekte in globals
var eledes
var matrix
var Funk
var cS
def startup()
end 
class getlight
end
class gettime
end
class clockSeconds
end 

if !persist.has("allBrightness")
	persist.allBrightness = 50
	persist.save()
else	
	print("allBrightness found")
end

load("globals")
load("font")
load("buttons")
load("Qlock")

def defcolumn()
	var col=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
	return col
end

def columnidx(x)
	var idx=defcolumn()
        var physx = 15 - x 
        idx[0]=physx
	for j:1..15
	  var maty
	  if j % 2
	   maty=(j*16+x)
	  else
	   maty=(j*16)+physx
	  end
	  idx[j]=maty
	end
	return idx
end

def column(y,mask,colh,colf,noshow)
var cidx=columnidx(y)
for j:0..15
  var col
  if mask[j] == 0
   col=colh
  else
   col=colf
  end
  #matrix.set_matrix_pixel_color(j,cidx[j],col,persist.allBrightness)
  eledes.set_pixel_color(cidx[j],col,persist.allBrightness)
end
if noshow==nil
 matrix.show()
end
end

def line(x,mask,colh,colf)
for j:0..15
  var maty
  if x % 2
   maty=j
  else
   maty=15-j
  end
  var col
  if mask[j] == 0
   col=colh
  else
   col=colf
  end
  matrix.set_matrix_pixel_color(x,maty,col,persist.allBrightness)
end
matrix.show()
end

## Text2MT("SOFTWARE WITHOUT CHAT-GPT")

class tpart2mask
	var tpart09,tpart10
	def init(tpart,offset,splitAfter)
		var t10part,t09part
                self.tpart09=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
                self.tpart10=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
		t10part=(tpart -(tpart % 10))/10
		#print(t10part)
		var add1=0
		for i:0..15
			if i==splitAfter && splitAfter != -1
				add1=1
			end
			if i < t10part
				self.tpart10[i+offset+add1]=1
			end 
		end
		t09part=(tpart % 10)
		#print(t09part)
		add1=0
		for i:0..15
			if i==splitAfter && splitAfter != -1 
				add1=1
			end
			if i < t09part
				self.tpart09[i+offset+add1]=1
			end 
		end
	end
end

matrix.set_alternate(false)
for i:0..15
 for j:0..15
  matrix.set_matrix_pixel_color(i,j,0xaa0000,persist.allBrightness)
  matrix.show()
  tasmota.delay(persist.QLTypeSpeed/4)
 end
end

matrix.clear()

var sec = gettime().sec()
var LastSec=-1
var timerid
var OffsetLeft = 3
var firstCall=1
var orientation=column

def blank()
	if matrix.is_dirty()
		matrix.clear()
	end
end

def lichtzeitpegel()
	var col = getlight().rgb
	var Legende = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

	Legende[OffsetLeft+0]=1
	Legende[OffsetLeft+1]=1
	Legende[OffsetLeft+4]=1
	Legende[OffsetLeft+5]=1
	Legende[OffsetLeft+8]=1
	Legende[OffsetLeft+9]=1

	orientation(11,tpart2mask(persist.sec,OffsetLeft,5).tpart10,0x000000,col)
	orientation(12,tpart2mask(persist.sec,OffsetLeft,5).tpart09,0x000000,col)
	if LastSec <= 2 
         firstCall +=1
		#print(CTime.hours + ":" + CTime.mins + ":" + CTime.secs)
		orientation(7,tpart2mask(persist.min,OffsetLeft,5).tpart10,0x000000,col)
		orientation(8,tpart2mask(persist.min,OffsetLeft,5).tpart09,0x000000,col)
		orientation(3,tpart2mask(persist.hour,OffsetLeft,5).tpart10,0x000000,col)
		orientation(4,tpart2mask(persist.hour,OffsetLeft,5).tpart09,0x000000,col)
	end
	if orientation==column
		line(2,Legende,0x000000,getlight().rgb ^ 0x00aa00)
	else 
		column(2,Legende,0x000000,getlight().rgb ^ 0x00aa00)
	end
end	

#-
matrix.clear()
	 orientation(11,tpart2mask(persist.sec,OffsetLeft,5).tpart10,0x000000,0x00dd00)
	 orientation(12,tpart2mask(persist.sec,OffsetLeft,5).tpart09,0x000000,0x00dd00)
	 orientation(7,tpart2mask(persist.min,OffsetLeft,5).tpart10,0x000000,0x00dd00)
	 orientation(8,tpart2mask(persist.min,OffsetLeft,5).tpart09,0x000000,0x00dd00)
	 orientation(3,tpart2mask(persist.hour,OffsetLeft,5).tpart10,0x000000,0x00dd00)
	 orientation(4,tpart2mask(persist.hour,OffsetLeft,5).tpart09,0x000000,0x00dd00)
print("Licht-Zeit-Pegel ;-)")
-#

var display = lichtzeitpegel

class wait4time
 var year1970
 def init()
  var testYear = int(gettime().year)
  self.year1970 = testYear
 end
 def funk()
  #print(Funk)
  for i:0..Funk.size()-1
   if eledes.pixels_buffer()[Funk[i]*3] == 0
	eledes.pixels_buffer()[Funk[i]*3] = 0xaa
   else
	eledes.pixels_buffer()[Funk[i]*3] = 0
   end    
  end 
  eledes.show()
 end
 def every_second()
  self.init()
  if self.year1970 == 1970
   self.funk()
  else
   print(gettime().year + "." + gettime().month + "." + gettime().day)
   tasmota.remove_driver(cS)
   eledes.clear()
   startup()
  end 
 end
end

class clockSeconds
 var sekunden
 def init()
	var CTime = gettime()
	persist.year = CTime.year
	persist.month = CTime.month
	persist.day = CTime.day
	persist.hour = CTime.hour()
	persist.min = CTime.min()
	persist.sec = CTime.sec()
	self.sekunden = CTime.sec()
	#print("init")
 end 
 def every_second()
  var s = self.sekunden
  if s==59
   self.init()
  else
   self.sekunden = self.sekunden + 1
   persist.sec = self.sekunden
  end
  #print(self.sekunden)
  display()
 end
end

def startup()
 if !persist.has("startup")
	cS = clockSeconds()
	tasmota.add_driver(cS)
 else
	if persist.startup=="QLO"
		cS = clockSeconds()
		load("testCron")
	end 
	if persist.startup=="LZP"
		cS = clockSeconds()
		tasmota.add_driver(cS)
	end 
        if persist.startup=="SECT"
            tasmota.remove_cron("cron4clockMinutes")
            load("onlysecs")
        end
 end 	
end

cS = wait4time()
tasmota.add_driver(cS)

print("autoexec loaded")
