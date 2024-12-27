import persist

var eledes
var matrix
if !persist.has("allBrightness")
	persist.allBrightness = 50
	persist.save()
end

class getlight
end

class gettime
end

load("globals")
load("buttons")
load("Qlock")

def line(y,mask,colh,colf)
for j:0..15
  var maty
  if j % 2
   maty=15-y
  else
   maty=y
  end
  var col
  if mask[j] == 0
   col=colh
  else
   col=colf
  end
  matrix.set_matrix_pixel_color(j,maty,col)
end
matrix.show()
end

def column(x,mask,colh,colf)
for j:0..15
  var maty
  if x % 2
   maty=15-j
  else
   maty=j
  end
  var col
  if mask[j] == 0
   col=colh
  else
   col=colf
  end
  matrix.set_matrix_pixel_color(x,maty,col)
end
matrix.show()
end

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

def set_timer_modulo(delay,f,id)
  var now=tasmota.millis()
  #print(delay)
  tasmota.set_timer((now+delay/4+delay)/delay*delay-now, def() set_timer_modulo(delay,f,id) f() end, id)
end


matrix.set_alternate(false)
for i:0..15
 for j:0..15
  matrix.set_matrix_pixel_color(i,j,0xaa0000,persist.allBrightness)
 end
end
matrix.show()
tasmota.delay(5000)
matrix.clear()

print("Spalte 1")
for j:0..15
  matrix.set_matrix_pixel_color(1,j,0x0000ff,persist.allBrightness)
end
#set_timer_modulo(1000,showsec,tId)

print("Zeile 3")
for j:0..15
  if j % 2
   matrix.set_matrix_pixel_color(j,15-3,0x00ff00,persist.allBrightness)
  else
   matrix.set_matrix_pixel_color(j,3,0x00ff00,persist.allBrightness)
  end
end
matrix.show()

var sec = gettime().sec()
print(sec)
line(9,tpart2mask(sec,3,0).tpart10,0x000000,0x00dd00)
line(10,tpart2mask(sec,3,0).tpart09,0x000000,0x00dd00)

tasmota.delay(5000)
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
#var CTime = gettime()
var Legende = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

Legende[OffsetLeft+0]=1
Legende[OffsetLeft+1]=1
Legende[OffsetLeft+4]=1
Legende[OffsetLeft+5]=1
Legende[OffsetLeft+8]=1
Legende[OffsetLeft+9]=1

	orientation(11,tpart2mask(persist.sec,OffsetLeft,5).tpart10,0x000000,col)
	orientation(12,tpart2mask(persist.sec,OffsetLeft,5).tpart09,0x000000,col)
	#LastSec = CTime.sec()
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

matrix.clear()
	 orientation(11,tpart2mask(gettime().sec(),OffsetLeft,5).tpart10,0x000000,0x00dd00)
	 orientation(12,tpart2mask(gettime().sec(),OffsetLeft,5).tpart09,0x000000,0x00dd00)
	 orientation(7,tpart2mask(gettime().min(),OffsetLeft,5).tpart10,0x000000,0x00dd00)
	 orientation(8,tpart2mask(gettime().min(),OffsetLeft,5).tpart09,0x000000,0x00dd00)
	 orientation(3,tpart2mask(gettime().hour(),OffsetLeft,5).tpart10,0x000000,0x00dd00)
	 orientation(4,tpart2mask(gettime().hour(),OffsetLeft,5).tpart09,0x000000,0x00dd00)
print("Licht-Zeit-Pegel ;-)")

var display = lichtzeitpegel

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
  #var CTime = gettime()
  #print("SECS " + CTime.secs)
  # 
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

cS = "irgendwas"

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
end 	


