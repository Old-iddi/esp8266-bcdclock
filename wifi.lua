function myConnect()

wifi.setmode(wifi.STATION)
station_cfg = {}
station_cfg.ssid = ssid
station_cfg.pwd = pwd
station_cfg.save = false
station_cfg.auto = true
wifi.sta.config(station_cfg)
wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, success)
wifi.eventmon.register(
    wifi.eventmon.STA_DISCONNECTED,nil
)
clockState = 2
end

function sync()
    sntp.sync(
        ntp,
        function(sec, usec, server, info)
            clockState = 4
        end,
        function()
            clockState = 6
        end,
        1
    )
end

function disconnect(T)
    if (clockState > 2) then
        clockState = 5
    end
end

function success(T)
    wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, disconnect)
    if (clockState >=3 ) then
        clockState = 6
    else
        clockState = 3
    end
    sync()
end

myConnect()
