FONT ={32:"000000000000",
33:"000000be0000",
34:"001060106000",
35:"00227f227f22",
36:"003249ff4926",
37:"00462610c8c4",
38:"00669999a462",
39:"000000600000",
40:"0000007c8200",
41:"0000827c0000",
42:"008850205088",
43:"002020f82020",
44:"000080600000",
45:"000010101000",
46:"000080000000",
47:"008060100c02",
48:"007c8a92a27c",
49:"000084fe8000",
50:"0084c2a2928c",
51:"00448292926c",
52:"00302824fe20",
53:"005e92929262",
54:"007c92929264",
55:"000202f20a06",
56:"006c9292926c",
57:"004c9292926c",
58:"000000500000",
59:"000080500000",
60:"000008142241",
61:"002828282828",
62:"000041221408",
63:"000402a2120c",
64:"003c425a5a38",
65:"00fc121212fc",
66:"00fe9292926c",
67:"007c82828244",
68:"00fe8282827c",
69:"00fe92929282",
70:"00fe12121202",
71:"007c82929274",
72:"00fe101010fe",
73:"000082fe8200",
74:"00408282827e",
75:"00fe101028c6",
76:"00fe80808080",
77:"00fe040804fe",
78:"00fe081020fe",
79:"007c8282827c",
80:"00fe1212120c",
81:"007c82a2c2fc",
82:"00fe121212ec",
83:"004c92929264",
84:"000202fe0202",
85:"007e8080807e",
86:"003e4080403e",
87:"00fe402040fe",
88:"00c6281028c6",
89:"000608f00806",
90:"00c2a2928a86",
91:"0000fe828200",
92:"00020c106080",
93:"008282fe0000",
94:"",
95:"008080808080"
}

import string

def letter(zeichen)
var letterbyte = bytes().fromstring(zeichen)
var fontBytes = bytes(FONT.find(letterbyte[0]))
var bits=""
var i=0
#print("Letter=",zeichen)
#print(fontBytes)
#print("Breite=",fontBytes.size())
#print("Höhe=8") 
#print("--------") 
for j : 0..((8*fontBytes.size())-1)
 if (j % 8) == 0
   if j>0
     bits = bits + string.char(13)
   end  
   i = i + 1
   bits = bits + string.format("%i",i)
 end
 if str(fontBytes.getbits(j,1))=="0"
  bits = bits + " "
 end 
 if str(fontBytes.getbits(j,1))=="1"
  bits = bits + "X"
 end 
end
#print(bits)
#print("--------") 
var tt = string.split(bits,string.char(13))
print(tt)
return(bits)
end

class Letter2Matrix
var LC
var workingLetter
	def init(zeichen)  #,offset
                self.LC={0:[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                          1:[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                          2:[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                          3:[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                          4:[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                          5:[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
                }
    var letterbyte = bytes().fromstring(zeichen)
    var fontBytes = bytes(FONT.find(letterbyte[0]))
    var i = 0
    #var currLC = self.LC.find(i)
    var posInLC = 0
    #print("TTT")
    self.workingLetter = zeichen 
    for j : 0..((8*fontBytes.size())-1)
      if (j % 8) == 0
        if j>0
          i = i + 1
          #bits = bits + string.char(13)
          posInLC = 4
        end  
        #print(i,self.LC.find(i))
      end
      if str(fontBytes.getbits(j,1))=="1"
         self.LC.find(i)[posInLC]=1
      end 
      posInLC = posInLC + 1
    end
  end
  
  def LetterColumn(col)
    #print(self.workingLetter,col)
    return self.LC.find(col)
  end
end

def defcolumn()
  var col=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
  return col
end

def getcolumn(x)
	var mask=defcolumn()
	#print("getcolumn=",x)
	for j:0..15
	  var maty
	  if x % 2
	   maty=15-j
	  else
	   maty=j
	  end
	  if eledes.get_pixel_color(x*16+maty) != 0
		  mask[j]=1
	  end 
	end
	return mask
end	


def Text2MT(text)
var ttt = "" #Letter2Matrix(text)
var MATRIXWIDTH = 16
var CHARWIDTH = 6
var i = MATRIXWIDTH
var textwidth = CHARWIDTH * size(text)
var splittText = "dummy"
matrix.clear()
var TextChars = size(text)-1
print("TEXTPixelBreite=" , textwidth)
var run = 0
var shiftleft = 0
# hole 1. Buchstaben
splittText = string.split(text,1) 
ttt = Letter2Matrix(splittText[0])
# der Durchlauf des Textes "dauert" textwidth+16
while run < textwidth+16
  shiftleft=1
  # Alle 15-1 eins nach links
  while shiftleft<16
    #print("shift",shiftleft-1,"<=",shiftleft)
    column(shiftleft-1,getcolumn(shiftleft),0x0,0x0000aa)
    shiftleft = shiftleft+1
  end 
  if size(text) > 0
    column(15,ttt.LetterColumn(run%CHARWIDTH),0x0,0x0000aa)
  end 
    run = run + 1
  matrix.show()
  #tasmota.delay(1) #persist.QLTypeSpeed)
  if run%CHARWIDTH == 0 # hole nächsten Buchstaben
    text = splittText[1]
    if size(text) > 0
      splittText = string.split(text,1) 
      ttt = Letter2Matrix(splittText[0])
    else
      run=textwidth+16  
    end  
  end
  print(run,textwidth+16)
end
for clear : 0..15
  shiftleft=1
  # Alle 15-1 eins nach links
  while shiftleft<16
    #print("shift",shiftleft-1,"<=",shiftleft)
    column(shiftleft-1,getcolumn(shiftleft),0x0,0x0000aa)
    shiftleft = shiftleft+1
  end
  column(15,defcolumn(),0,0) 
end
#for txtChar : 0..TextChars
#  splittText = string.split(text,1)
#  ttt = Letter2Matrix(splittText[0])
#  print("---",splittText[0])
#  text = splittText[1]
#end
end #-Text2MT-#

#-
ttt="josef Dahlmanns"
spl=""
for i : 0..size(ttt)-1
 spl = string.split(ttt,1)
 print(i,spl[0])
 ttt = spl[1]
end
-#