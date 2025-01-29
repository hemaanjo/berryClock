print("load buttons")
# WebButtons
import webserver
import string

class ClockButtons:Driver
	def web_add_main_button()
		webserver.content_send(
			"<p><button onclick='la(\"&LZP=1\");'>Lichtzeitpegel</button></p>"
          + "<p><button onclick='la(\"&QLO=1\");'>QLock</button></p>"
          + "<p><button onclick='la(\"&SHT=1\");'>akt. Zeit</button></p>"
          + "<p><button onclick='la(\"&SECT=1\");'>Sekunden</button></p>"
        )
    end

    def web_sensor()
        var cmd = nil
        if persist.has("CronJobMinutes")
	 persist.remove("CronJobMinutes")
        end 
        if webserver.has_arg("LZP")
            print("Lichtzeitpegel")
			persist.startup="LZP"
			persist.dirty()
                        tasmota.cmd("restart 1")
        elif webserver.has_arg("QLO")
            print("QLock")  
			persist.startup="QLO"
			persist.dirty()
                        tasmota.cmd("restart 1")
        elif webserver.has_arg("SHT")
            if cS != nil
               cmd = cS
               tasmota.remove_driver(cS)
            end 
            Text2MT(gettime().hours + ":" + gettime().mins)
            if cmd != nil
               tasmota.add_driver(cmd)
            end
        elif webserver.has_arg("SECT")
            if persist.has("CronJobMinutes")
               tasmota.remove_cron(persist.CronJobMinutes)
               persist.remove("CronJobMinutes")
            end
	    persist.startup="SECT"
	    persist.dirty()
            load("onlysecs")
        end 
    end
 end  

myDriver = ClockButtons()
tasmota.add_driver(myDriver)
print("buttons loaded")
