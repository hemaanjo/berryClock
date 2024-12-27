#Masks für QLOCK
mintext = 
{
0: 'Uhr',
5:'fünf nach',
10:'zehn nach',
15:'viertel nach',
20:'zwanzig nach',
25:'fünf vor halb',
30:'halb',
35:'fünf nach halb',
40:'zwanzig vor',
45:'viertel vor',
50:'zehn vor',
55:'fünf vor'
} 

hourtext = 
{
0:'zwölf',
1:'eins',
2:'zwei',
3:'drei',
4:'vier',
5:'fünf',
6:'sechs',
7:'sieben',
8:'acht',
9:'neun',
10:'zehn',
11:'elf'}

esist=[34,61,93,98,125]

minmask = {
0:[171,180,203],
5:[157,162,189,194,154,165,186,197],
10:[35,60,67,92,154,165,186,197],
15:[100,123,132,155,164,187,196,154,165,186,197],
20:[99,124,131,156,163,188,195,154,165,186,197],
25:[157,162,189,194,37,58,69,38,57,70,89],
30:[37,58,69,90],
35:[157,162,189,194,154,165,186,197,38,57,70,89],
40:[99,124,131,156,163,188,195,37,58,69],
45:[100,123,132,155,164,187,196,37,58,69],
50:[35,60,67,92,37,58,69],
55:[157,162,189,194,37,58,69]
}
hourmask = {
0:[138,149,170,181,202],
1:[39,56,71,88],
2:[152,167,184,199],
3:[40,55,72,87],
4:[151,168,183,200],
5:[153,166,185,198],
6:[41,54,73,86,105],
7:[42,53,74,85,106,117],
8:[150,169,182,201],
9:[84,107,116,139],
10:[43,52,75,84],
11:[121,134,153],
}

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
 print(h,m)
 print("Es ist " + mintext.find(m) + " " + hourtext.find(h))
 m1=hourmask
 m2=minmask
 fndm1=m
 fndm2=h
end

var matrixmask=[]

return matrixmask
end 

def ledMask(mask)
	var i = 0
	eledes.clear()
	while i<mask.size()
		print(mask[i])
		eledes.set_pixel_color(mask[i],0x00ff00)
		eledes.show()
		tasmota.delay(500)
		i+=1
	end
end
ledMask(timemask(gettime().hour()%12,gettime().min() / 5 * 5))

