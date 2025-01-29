class clockSeconds
	var sekunden
	var secColor
	var secMode
	def init()
	   self.sekunden=persist.sec
	   if !persist.has("QLsecColor")
		   persist.QLsecColor = 0x009900
		   persist.save()
	   end 
	   self.secColor = persist.QLsecColor
	   if !persist.has("QLsecMode")
		   #-
		   QLsecMode=0 : einzelne sekunden
		   QLsecMode=1 : sekunden hochzählen
				   QLsecMode=2 : sekunden AUS 
		   -#
		   persist.QLsecMode = 0
		   persist.save()
	   end 
	   self.secMode = persist.QLsecMode
	end 
   
	def clear()
	 for i:0..secidx.size()-1
	  eledes.set_pixel_color(secidx[i],0x000000)
	 end
	 eledes.show()
	end
   
	def every_second()
	   if self.sekunden==59
		   self.clear()
		   self.sekunden=0
	   else
		   self.sekunden = self.sekunden + 1
	   end
	   if persist.QLsecMode == 0
		   eledes.set_pixel_color(secidx[self.sekunden-1],0x000000,persist.allBrightness+self.sekunden)
	   end 
	   eledes.set_pixel_color(secidx[self.sekunden],self.secColor,persist.allBrightness+self.sekunden)
	   eledes.show()
	end
   end
   
   def showTimeMinutes()
	var CTime = gettime()
	persist.year = CTime.year
	persist.month = CTime.month
	persist.day = CTime.day
	persist.hour = CTime.hour()
	persist.min = CTime.min()
	persist.sec = CTime.sec()
	#cS.clear()
	cS.sekunden = persist.sec
	persist.dirty()
   
	if persist.min % 5 ==0
	   #print("FÜNF " + CTime.hours + ":" + CTime.mins + ":" + CTime.secs)
	   ledMask(timemask(persist.hour%12,persist.min / 5 * 5))
	   cS.clear()
	else
	   print("      Mins " + str(persist.min % 5))
	   for min: 0 .. 3
	   var col=0x005500
	   if min > (persist.min % 5) -1
		   col=0x000000
	   end
		   eledes.set_pixel_color(minidx[min],col,persist.allBrightness)
	end
	eledes.show() 
	end
   end
   
   tasmota.remove_driver(cS)
   tasmota.remove_cron("cron4clockMinutes")
   cS = clockSeconds()
   
   tasmota.add_cron("0 * * * * *", showTimeMinutes, "cron4clockMinutes")
   if !persist.has("CronJobMinutes")
	   persist.CronJobMinutes = "cron4clockMinutes"
	   persist.save()
   end 
   
   
   if persist.QLsecMode != 2
	tasmota.add_driver(cS)
   end
   showTimeMinutes()
   Qlock()
   