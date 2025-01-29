print("load font")
FONT ={32:"0000000000",
33:"0000be0000",
34:"1060106000",
35:"227f227f22",
36:"3249ff4926",
37:"462610c8c4",
38:"669999a462",
39:"0000600000",
40:"00007c8200",
41:"00827c0000",
42:"8850205088",
43:"2020f82020",
44:"0080600000",
45:"0010101000",
46:"0080000000",
47:"8060100c02",
48:"7c8a92a27c",
49:"0084fe8000",
50:"84c2a2928c",
51:"448292926c",
52:"302824fe20",
53:"5e92929262",
54:"7c92929264",
55:"0202f20a06",
56:"6c9292926c",
57:"4c9292926c",
58:"0000500000",
59:"0080500000",
60:"0008142241",
61:"2828282828",
62:"0041221408",
63:"0402a2120c",
64:"3c425a5a38",
65:"fc121212fc",
66:"fe9292926c",
67:"7c82828244",
68:"fe8282827c",
69:"fe92929282",
70:"fe12121202",
71:"7c82929274",
72:"fe101010fe",
73:"0082fe8200",
74:"408282827e",
75:"fe101028c6",
76:"fe80808080",
77:"fe040804fe",
78:"fe081020fe",
79:"7c8282827c",
80:"fe1212120c",
81:"7c82a2c2fc",
82:"fe121212ec",
83:"4c92929264",
84:"0202fe0202",
85:"7e8080807e",
86:"3e4080403e",
87:"fe402040fe",
88:"c6281028c6",
89:"0608f00806",
90:"c2a2928a86",
91:"00fe828200",
92:"020c106080",
93:"8282fe0000",
94:"",
95:"8080808080"
}

import string
# small letter 4x8 
def letters(zeichen)
var letterbyte = bytes().fromstring(zeichen)
var fontBytes = bytes("7c12127c")
var bits=""
var i=0
print("Letter=",zeichen)
print(fontBytes)
print("Breite=",fontBytes.size())
#print("Höhe=8") 
print("--------") 
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
print(bits)
print("--------") 
var tt = string.split(bits,string.char(13))
print(tt)
return(bits)
end

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
   bits = bits + string.format("%i",i)
   i = i + 1
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

def TextColor()
    	if !persist.has("TextColor")
  	  persist.TextColor = 0x0000EE
	  persist.save()
	end 
        return persist.TextColor
end

class Letter2Matrix
var LC
var workingLetter

	def init(zeichen,startAtRow)
            TextColor()
                self.LC={0:defcolumn(),
                          1:defcolumn(),
                          2:defcolumn(),
                          3:defcolumn(),
                          4:defcolumn(),
                          5:defcolumn()
                }
    var letterbyte = bytes().fromstring(zeichen)
    var fontBytes = bytes(FONT.find(letterbyte[0]))
    var i = 0
    #var currLC = self.LC.find(i)
    var posInLC = 3
    if startAtRow != nil
       posInLC = startAtRow
    end
    #print("TTT")
    self.workingLetter = zeichen 
    for j : 0..((8*fontBytes.size())-1)
      if (j % 8) == 0
        if j>0
          i = i + 1
          #bits = bits + string.char(13)
          posInLC = 3
          if startAtRow != nil
            posInLC = startAtRow
          end
        end  
        #print(i,self.LC.find(i))
      end
      if str(fontBytes.getbits(j,1))=="1"
         self.LC.find(i)[posInLC]=1
      end 
      posInLC = posInLC + 1
    end
  end

  def show(startColumn)
    for i : 0..5
      column(startColumn+i,self.LC.find(i),0x000000,TextColor())      
    end
  end
  
  def LetterColumn(col)
    #print(self.workingLetter,col)
    return self.LC.find(col)
  end
end

def getcolumn(x)
	var mask=defcolumn()
#	print("getcolumn=",x)
        var physx = 15 - x 
#	print("PHYSgetcolumn=",physx)
        if eledes.get_pixel_color(physx) != 0
         mask[0]=1
	end 
	for j:1..15
	  var maty
	  if j % 2
	   maty=(j*16+x)
	  else
	   maty=(j*16)+physx
	  end
#          print(j,maty)
	  if eledes.get_pixel_color(maty) != 0
		  mask[j]=1
	  end 
	end
	return mask
end

def Text2MT(text,startAtRow)
var ttt = "" #Letter2Matrix(text)
var MATRIXWIDTH = 16
var CHARWIDTH = 6
var i = MATRIXWIDTH
var textwidth = CHARWIDTH * size(text)
var splittText = "dummy"
matrix.clear()
var TextChars = size(text)-1
#print("TEXTPixelBreite=" , textwidth)
var run = 0
var shiftleft = 0
# hole 1. Buchstaben
splittText = string.split(text,1) 
ttt = Letter2Matrix(splittText[0],startAtRow)
# der Durchlauf des Textes "dauert" textwidth+16
while run < textwidth+16
  shiftleft=1
  # Alle 15-1 eins nach links
  while shiftleft<16
    #print("shift",shiftleft-1,"<=",shiftleft)
    column(shiftleft-1,getcolumn(shiftleft),0x0,TextColor(),false)
    shiftleft = shiftleft+1
  end 
  if size(text) > 0
    column(15,ttt.LetterColumn(run%CHARWIDTH),0x0,TextColor(),false)
  end 
    run = run + 1
    matrix.show()
  if run%CHARWIDTH == 0 # hole nächsten Buchstaben
    text = splittText[1]
    if size(text) > 0
      splittText = string.split(text,1) 
      ttt = Letter2Matrix(splittText[0],startAtRow)
    else
      run=textwidth+16  
    end  
  end
  #print(run,textwidth+16)
end
eledes.show()
for clear : 0..15
  shiftleft=1
  # Alle 15-1 eins nach links
  while shiftleft<16
    #print("shift",shiftleft-1,"<=",shiftleft)
    column(shiftleft-1,getcolumn(shiftleft),0x0,TextColor(),false)
    shiftleft = shiftleft+1
  end
  column(15,defcolumn(),0,0) 
end
end #-Text2MT-#

def textshow(text,startAtRow)
var ttt = "" #Letter2Matrix(text)
var MATRIXWIDTH = 16
var CHARWIDTH = 6
var textwidth = CHARWIDTH * size(text)
var splittText = "dummy"
var TextChars = size(text)-1
#print("TEXTPixelBreite=" , textwidth)
var run = 0
var shiftleft = 0
var completeBytePack = [0]
completeBytePack.remove(0)
for ltteridx: 0..size(text)
	# hole Buchstaben
	splittText = string.split(text,1) 
	ttt = Letter2Matrix(splittText[0],startAtRow)
	for i: 0..5
		completeBytePack.push(ttt.LC.find(i))
	end
	print("REST=" + splittText[1],size(splittText[1]) )
	if size(splittText[1]) > 0
	  text = splittText[1]
      splittText = string.split(text,1) 
      ttt = Letter2Matrix(splittText[0],startAtRow)
    end 
end
# completeBytePack is ready
for i: 0..completeBytePack.size()-1
	print(i,completeBytePack[i])
end
end #-textshow-#

print("font loaded")

