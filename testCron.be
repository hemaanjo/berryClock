var secidx=[128,159,160,191,192,223,224,255,254,253,252,251,250,249,248,247,246,245,244,243,242,241,240,239,208,207,176,175,144,143,112,111,80,79,48,47,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,31,32,63,64,95,96,127]
var minidx=[225,238,17,30]

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
  #var s = CTime.sec()
  
  if self.sekunden==59
   self.init()
  else
   self.sekunden = self.sekunden + 1
   persist.sec = self.sekunden
  end
  if self.sekunden==0
   eledes.set_pixel_color(secidx[59],0x000000)
  else
   eledes.set_pixel_color(secidx[self.sekunden-1],0x000000)
  end
  eledes.set_pixel_color(secidx[self.sekunden],0x009900)
  eledes.show()
 end
end

tasmota.remove_driver(cS)
cS = clockSeconds()

def showTimeMinutes()
var CTime = gettime()
 if int(CTime.mins) % 5 ==0
  print("FÜNF " + CTime.hours + ":" + CTime.mins + ":" + CTime.secs)
  ledMask(timemask(CTime.hour()%12,CTime.min() / 5 * 5))
 else
  print("      Mins " + str(CTime.min() % 5))
  for min: 0 .. 3
   var col=0x005500
   if min > (CTime.min() % 5) -1
    col=0x000000
   end
   eledes.set_pixel_color(minidx[min],col)
  end
  eledes.show() 
 end
end

tasmota.remove_cron("cron4clockMinutes")
tasmota.remove_driver(cS)
tasmota.add_cron("0 * * * * *", showTimeMinutes, "cron4clockMinutes")
tasmota.add_driver(cS)
