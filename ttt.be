import animate

var funk = Leds(16*16,gpio.pin(gpio.WS2812, 0),Leds.WS2812_GRB, 1)
var anim = animate.core(funk)
anim.set_back_color(0x000000)
var pulse = animate.pulse(0xFF4444, 2, 1)
var osc1 = animate.oscillator(-3, 260, 5000, animate.COSINE)
osc1.set_cb(pulse, pulse.set_pos)

# animate color of pulse
var palette = animate.palette(animate.PALETTE_STANDARD_TAG, 30000)
palette.set_cb(pulse, pulse.set_color)

anim.start()
#tasmota.delay(5000)
#anim.remove()
#matrix.clear()
#load("autoexec")

import animate

var funk = Leds(16*16,gpio.pin(gpio.WS2812, 0),Leds.WS2812_GRB, 1)
var anim = animate.core(funk)
anim.set_back_color(0x000000)
var pulse = animate.pulse(0xFF4444, 2, 1)
var osc1 = animate.oscillator(-3, 260, 5000, animate.COSINE)
osc1.set_cb(pulse, pulse.set_pos)

# animate color of pulse
var palette = animate.palette(animate.PALETTE_STANDARD_TAG, 30000)
palette.set_cb(pulse, pulse.set_color)

anim.start()
#tasmota.delay(5000)
#anim.remove()
#matrix.clear()
#load("autoexec")

