class onlySeconds
	var sec0
	var sec10
        var lastsec10
	var sekunden 
	def init()
		var CTime = gettime()
		self.sekunden = CTime.sec()
	end 

	def every_second()
		if self.sekunden>=58
			self.init()
                        if self.sekunden==0
                           Text2MT(gettime().hours + ":" + gettime().mins)
                           self.init()
                        end
		else
			self.sekunden = self.sekunden + 1
		end
		self.sec0 = self.sekunden % 10
		self.sec10 = self.sekunden - self.sec0
                if self.lastsec10 != self.sec10
                   self.lastsec10 = self.sec10
		   Letter2Matrix(" ").show(2)
		   Letter2Matrix(str(self.sec10)).show(2)
                end
		#matrix.clear()
		Letter2Matrix(" ").show(9)
		Letter2Matrix(str(self.sec0)).show(9)
	end
end

matrix.clear()
tasmota.remove_driver(cS)
cS=onlySeconds()
tasmota.add_driver(cS) 
