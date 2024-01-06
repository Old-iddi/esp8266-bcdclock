function myinit()
    dofile("config.lua")
    dofile("netconf.lua")
    dofile("clock.lua")
    dofile("wifi.lua")
end

clockState = 1
ws2812.init()
strip_buffer = ws2812.newBuffer(42, 3)
ws2812_effects.init(strip_buffer)
ws2812_effects.set_speed(100)
ws2812_effects.set_brightness(25)
ws2812_effects.set_color(255, 255, 255)
ws2812_effects.set_mode("static")
ws2812_effects.start()

mytimer = tmr.create()
mytimer:register(5000, tmr.ALARM_SINGLE, myinit)
mytimer:start()
