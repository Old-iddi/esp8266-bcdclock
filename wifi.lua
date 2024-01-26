function apSuccess()
    wifi.sta.disconnect()
    clockState = 2
    print("ap success")
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
    wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, nil)
    wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, nil)
    wifi.ap.config({ssid = hostname, pwd = "123321123", auth = wifi.WPA2_PSK})
    enduser_setup.manual(true)
    enduser_setup.start(apSuccess, nil)
    successConnectTimer:register(60000, tmr.ALARM_SINGLE, restartPortal)
    successConnectTimer:start()
end

function myConnect()
    successConnectTimer:stop()
    connectattempt:stop()
    wifi.setmode(wifi.STATION)
    wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, success)
    wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, nil)
    print("connecting to wifi")
    station_cfg = {}
    station_cfg.ssid = ssid
    station_cfg.pwd = pwd
    station_cfg.save = false
    station_cfg.auto = true
    wifi.sta.config(station_cfg)
    wifi.sta.sethostname(hostname)
    clockState = 2
    successConnectTimer:register(10000, tmr.ALARM_SINGLE, startAp)
    successConnectTimer:start()
end

function split(str, pat)
    local t = {} -- NOTE: use {n = 0} in Lua-5.0
    local fpat = "(.-)" .. pat
    local last_end = 1
    local s, e, cap = str:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(t, cap)
        end
        last_end = e + 1
        s, e, cap = str:find(fpat, last_end)
    end
    if last_end <= #str then
        cap = str:sub(last_end)
        table.insert(t, cap)
    end
    return t
end

function updateTZ()
    if autoTZ == true then
        http.get(
        "http://api.ip2location.io",
        nil,
        function(code, data)
            if (code < 0) then
                print("HTTP request failed")
            else
                string = sjson.decode(data).time_zone
                s = split(string, ":")
                TZHour = tonumber(s[1])
                TZMin = tonumber(s[2])
                if TZHour < 0 then
                    TZMin = -TZMin
                end
                print(TZHour .. " " .. TZMin)
                tzChanged = true
            end
        end
        )
    end
end

function updateTimeWeb()
    if httpFallback == true then
        http.get(
        "http://www.worldtimeapi.org/api/timezone/Etc/GMT",
        nil,
        function(code, data)
            if (code < 0) then
                print("HTTP request failed")
            else
                string = sjson.decode(data).unixtime
                rtctime.set(tonumber(string), 0)
                clockState = 5
                if tzChanged == false then
                    webTZ:register(5000, tmr.ALARM_SINGLE, updateTZ)
                    webTZ:start()
                end
                print("web time sync ok")
            end
        end
        )
    end
end

resyncCount = 1
tzChanged = false
doResync = true

function sync()
    print("sync")
    doResync = false
    resyncTimer:stop()
    sntp.sync(
        ntp,
        function(sec, usec, server, info)
            clockState = 5
            print("sync ok")
            webTime:stop()
            if tzChanged == false then
                webTZ:register(5000, tmr.ALARM_SINGLE, updateTZ)
                webTZ:start()
            end
            resyncEnable:register(2000, tmr.ALARM_SINGLE, function () doResync=true end )
            resyncEnable:start()
       end,
        function()
            if (clockState > 4) then
                clockState = 7
            else
                clockState = 3
            end
            resyncCount = resyncCount + 1
            if resyncCount == 3 then
                updateTimeWeb()
            end
            if resyncCount < 10 then
                resyncTimer:register(7000, tmr.ALARM_SINGLE, sync)
                resyncTimer:start()
                print("sheduled resync")
            else
                resyncCount = 1
                if clockState > 4 then
                    clockState = 5
                end
            end
            resyncEnable:register(2000, tmr.ALARM_SINGLE, function () doResync=true end )
            resyncEnable:start()
        end,
        0
    )
end

function disconnect(T)
    print("disconnect")
    if (clockState > 4) then
        clockState = 6
    end
end

function success(T)
    print("success")
    successConnectTimer:stop()
    wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, disconnect)
    if (clockState > 4) then
        clockState = 7
    else
        clockState = 3
    end
    resyncTimer:register(1000, tmr.ALARM_SINGLE, sync)
    resyncTimer:start()
end

successConnectTimer = tmr.create()
connectattempt = tmr.create()
resyncTimer = tmr.create()
webTZ = tmr.create()
webTime = tmr.create()
resyncEnable = tmr.create()
myConnect()
