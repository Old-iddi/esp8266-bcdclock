ssid = ""
pwd = ""
ntp = { "ntp.msk-ix.ru","ru.pool.ntp.org" }
hostname = "BCDClock-06"

-- my private file with wifi credentials
if file.exists("my.netconf.lua") then
    dofile("my.netconf.lua")
end
if file.exists("eus_params.lua") then
    p = dofile("eus_params.lua")
    ssid = p.wifi_ssid
    pwd = p.wifi_password
end
