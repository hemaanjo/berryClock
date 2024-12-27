# WebButtons
import webserver
import string

class ClockButtons:Driver
	def web_add_main_button()
		webserver.content_send(
			"<p><button onclick='la(\"&LZP=1\");'>Lichtzeitpegel</button></p>"
          + "<p><button onclick='la(\"&QLO=1\");'>QLock</button></p>")
    end

    def web_sensor()
        var cmd = nil
        if webserver.has_arg("LZP")
            print("Lichtzeitpegel")
			persist.startup="LZP"
			persist.dirty()
        elif webserver.has_arg("QLO")
            print("QLock")  
			persist.startup="QLO"
			persist.dirty()
        end 
    end
 end  

myDriver = ClockButtons()
tasmota.add_driver(myDriver)
