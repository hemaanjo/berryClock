import animate

var anim = animate.core(eledes)
anim.set_back_color(0x000000)
var pulse = animate.pulse(0xFF4444, 2, 1)
var osc1 = animate.oscillator(-3, 260, 5000, animate.COSINE)
osc1.set_cb(pulse, pulse.set_pos)

# animate color of pulse
var palette = animate.palette(animate.PALETTE_STANDARD_TAG, 30000)
palette.set_cb(pulse, pulse.set_color)

anim.start()


# submatrix TEST
var qlockWindow=eledes.create_segment(35,11*10)
var qmatrix = qlockWindow.create_matrix(11,10)

#for p: 0..((11*10)-1)
#	qlockWindow.set_pixel_color(p,0x0000aa)
#end	

#qlockWindow.clear_to(0x0000aa)