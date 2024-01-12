function apSuccess()
    wifi.sta.disconnect()
    clockState = 2
    dofile("netconf.lua")
    successConnectTimer:register(500, tmr.ALARM_SINGLE, endPortal)
    successConnectTimer:start()
    connectattempt:register(1500, tmr.ALARM_SINGLE, myConnect)
    connectattempt:start()
end

function endPortal()
    enduser_setup.stop()
end

function restartPortal()
    enduser_setup.stop()
    connectattempt:register(1000, tmr.ALARM_SINGLE, myConnect)
    connectattempt:start()
end

function startAp() 
    wifi.sta.sethostname(hostname)
    wifi.sta.disconnect()
    clockState = 4
    wifi.setmode(wifi.STATIONAP)
    wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED,nil)
    wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, nil)
    wifi.ap.config({ssid=hostname, pwd="64sFJ9cC", auth=wifi.WPA2_PSK})
    enduser_setup.manual(true)
    enduser_setup.start(apSuccess,nil)
    successConnectTimer:register(60000, tmr.ALARM_SINGLE, restartPortal)
    successConnectTimer:start()
end

function myConnect()
successConnectTimer:stop()
connectattempt:stop()
wifi.setmode(wifi.STATION)
station_cfg = {}
station_cfg.ssid = ssid
station_cfg.pwd = pwd
station_cfg.save = false
station_cfg.auto = true
wifi.sta.config(station_cfg)
wifi.sta.sethostname(hostname)
wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, success)
wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED,nil)
clockState = 2
successConnectTimer:register(10000, tmr.ALARM_SINGLE, startAp)
successConnectTimer:start()
end

function sync()
    sntp.sync(
        ntp,
        function(sec, usec, server, info)
            clockState = 5
        end,
        function()
            clockState = 7
        end,
        1
    )
end

function disconnect(T)
    if (clockState > 3) then
        clockState = 6
    end
end

function success(T)
    successConnectTimer:stop()
    wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, disconnect)
    if (clockState > 3 ) then
        clockState = 7
    else
        clockState = 5
    end
    sync()
end

successConnectTimer = tmr.create()
connectattempt = tmr.create()
myConnect()
