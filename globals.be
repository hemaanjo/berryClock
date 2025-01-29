# indices basieren auf EXCEL File QLOCK
# Tabelle Matrix X=3 Y=4 

print("load globals")
#var secidx=[128,159,160,191,192,223,224,255,254,253,252,251,250,249,248,247,246,245,244,243,242,241,240,239,208,207,176,175,144,143,112,111,80,79,48,47,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,31,32,63,64,95,96,127]
var secidx=[7,6,5,4,3,2,1,0,31,32,63,64,95,96,127,128,159,160,191,192,223,224,255,254,253,252,251,250,249,248,247,246,245,244,243,242,241,240,239,208,207,176,175,144,143,112,111,80,79,48,47,16,15,14,13,12,11,10,9,8]

#var minidx=[225,238,17,30]
var minidx=[30,225,238,17]


#var esist=[35,60,92,99,124]
var esist=[50,51,53,54,55]

#-
minmask={
0:[172,179,204],
5:[156,163,188,195,153,166,185,198],
10:[36,59,68,91,153,166,185,198],
15:[101,122,133,154,165,186,197,153,166,185,198],
20:[100,123,132,155,164,187,196,153,166,185,198],
25:[156,163,188,195,38,57,70,39,56,71,88],
30:[39,56,71,88],
35:[156,163,188,195,153,166,185,198,39,56,71,88],
40:[100,123,132,155,164,187,196,38,57,70],
45:[101,122,133,154,165,186,197,38,57,70],
50:[36,59,68,91,38,57,70],
55:[156,163,188,195,38,57,70],
99:[0]}
hourmask={
0:[139,148,171,180,203],
1:[40,55,72,87],
2:[151,168,183,200],
3:[41,54,73,86],
4:[150,169,182,201],
5:[152,167,184,199],
6:[42,53,74,85,106],
7:[43,52,75,84,107,116],
8:[149,170,181,202],
9:[83,108,115,140],
10:[44,51,76,83],
11:[120,135,152],
99:[0]}
Funk=[89,102,121,134]
-#

minmask={
0:[196,195,194],
5:[58,59,60,61,101,100,99,98],
10:[77,76,75,74,101,100,99,98],
15:[87,88,89,90,91,92,93,101,100,99,98],
20:[72,71,70,69,68,67,66,101,100,99,98],
25:[58,59,60,61,109,108,107,114,115,116,117],
30:[114,115,116,117],
35:[58,59,60,61,101,100,99,98,114,115,116,117],
40:[72,71,70,69,68,67,66,109,108,107],
45:[87,88,89,90,91,92,93,109,108,107],
50:[77,76,75,74,109,108,107],
55:[58,59,60,61,109,108,107],
99:[0]}
hourmask={
0:[185,186,187,188,189],
1:[141,140,139,138],
2:[133,132,131,130],
3:[146,147,148,149],
4:[154,155,156,157],
5:[122,123,124,125],
6:[173,172,171,170,169],
7:[178,179,180,181,182,183],
8:[165,164,163,162],
9:[202,201,200,199],
10:[205,204,203,202],
11:[120,121,122],
99:[0]}
Funk=[106,105,104,103]

var eledes = Leds(16*16,gpio.pin(gpio.WS2812, 0))
var matrix = eledes.create_matrix(16,16)
var brightness = 50
var timerdelay = 200

class getlight
	var brightness,hue,sat,rgb
	def init()
		import string
		import json
		var gl = light.get()
		gl= string.tolower(json.dump(gl,'format'))
		gl = string.replace(gl,"\"","")
		gl = string.replace(gl,"{","")
		gl = string.replace(gl,"}","")
		var splgl = string.split(gl,",")
		var i=0
		while i<splgl.size()
			var it = splgl[i]
			#print(i,it)
			var ittem = string.split(it,":")
			var j=0
			while j<ittem.size()
				#print(j,"/" + string.replace(ittem[0]," ","") + "/")
				if string.find(ittem[0],"rgb") >= 0 
					self.rgb = string.replace(ittem[1],"\n","")
					self.rgb = int("0x"+string.replace(ittem[1]," ",""))
				end
				if string.find(ittem[0],"bri") >= 0 
					self.brightness = string.replace(ittem[1],"\n","")
					self.brightness = int(string.replace(ittem[1]," ",""))
				end
				if string.find(ittem[0],"hue") >= 0 
					self.hue = string.replace(ittem[1],"\n","")
					self.hue = int(string.replace(ittem[1]," ",""))
				end
				j +=1
			end
			i +=1
		end
	end
end

class gettime
	var secs,mins,hours,day,month,year
	def init()
		import string
		import json
		var tasTimeInfo = tasmota.cmd("Status 7")
		var tasDate
		var tasTime
		var tPos = 0
		tasTimeInfo = string.tolower(json.dump(tasTimeInfo,'format'))
		tPos = string.find(tasTimeInfo,"local")+5
		tasTimeInfo = string.split(tasTimeInfo,tPos)[1]
		tasTimeInfo = string.split(tasTimeInfo,",")[0]
		tasTimeInfo = string.replace(tasTimeInfo,": ","")
		tasTimeInfo = string.replace(tasTimeInfo,"\"","")
		tasDate = string.split(tasTimeInfo,"t")
		tasTime = tasDate[1]
		tasDate = tasDate[0]
		print("TIME",tasDate, tasTime)

		tasDate = string.split(tasDate,"-")
		tasTime = string.split(tasTime,":")
		self.year = tasDate[0]
		self.month = tasDate[1]
		self.day = tasDate[2]
		self.hours = tasTime[0]
		self.mins = tasTime[1]
		self.secs = tasTime[2]
#		print(self.year)
#		print(self.month)
#		print(self.day)
#		print(self.hours)
#		print(self.mins)
#		print(self.secs)

	end
	def sec()
		return int(self.secs)
	end
	def min()
		return int(self.mins)
	end
	def hour()
		return int(self.hours)
	end

end
print("globals loaded")
