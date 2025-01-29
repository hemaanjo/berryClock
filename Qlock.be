print("load Qlock")
#Masks für QLOCK
mintext = {0: 'Uhr',5:'fünf nach',10:'zehn nach',15:'viertel nach',20:'zwanzig nach',25:'fünf vor halb',30:'halb',35:'fünf nach halb',40:'zwanzig vor',45:'viertel vor',50:'zehn vor',55:'fünf vor'} 
hourtext = {0:'zwölf',1:'eins',2:'zwei',3:'drei',4:'vier',5:'fünf',6:'sechs',7:'sieben',8:'acht',9:'neun',10:'zehn',11:'elf'}

if !persist.has("QLTypeSpeed")
	persist.QLTypeSpeed = 100
	persist.save()
end

def timemask(h,m)
	var i=0
	var m1,m2
	var fndm1,fndm2 
	var cutLast=0
	if m==0
		print("Es ist " + hourtext.find(h) + " " + mintext.find(m))
		m1=hourmask
		m2=minmask
		fndm1=h
		fndm2=m
		if h==1
			cutLast=1
		end 
	else
		if m>=25
			if h<11
				h += 1
			else
				h = 0
			end  
		end
		print("Es ist " + mintext.find(m) + " " + hourtext.find(h))
		m1=minmask
		m2=hourmask
		fndm1=m
		fndm2=h
	end

	var matrixmask=[]
	while i<esist.size()
		matrixmask.insert(matrixmask.size(),esist[i])
		i+=1
	end
	i=0

	while i<(m1.find(fndm1).size()-cutLast)
		matrixmask.insert(matrixmask.size(),m1.find(fndm1)[i])
		i+=1
	end
	i=0
	while i<(m2.find(fndm2).size())
		matrixmask.insert(matrixmask.size(),m2.find(fndm2)[i])
		i+=1
	end
	#print(matrixmask)
return matrixmask
end 

def ledUNMask(mask)
	var i = 0
	while i<mask.size()
		eledes.set_pixel_color(mask[i],0x000000)
		i+=1
	end
	eledes.show()
end

def ledMask(mask)
	var i = 0
	eledes.clear()
	while i<mask.size()
		#print(mask[i])
		eledes.set_pixel_color(mask[i],0x00ff00,persist.allBrightness)
		eledes.show()
		tasmota.delay(persist.QLTypeSpeed)
		i+=1
	end
end

def Qlock()
var lh
var lm
if lh!=persist.hour%12 || lm!=persist.min / 5 * 5
	ledMask(timemask(persist.hour%12,persist.min / 5 * 5))
	lh=persist.hour%12 
	lm=persist.min / 5 * 5
end 	
end

print("Qlock loaded")

