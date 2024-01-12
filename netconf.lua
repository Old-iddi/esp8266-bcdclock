ssid = "<ssid>"
pwd = "<passwd>"
ntp = { "ru.pool.ntp.org", "192.168.1.1" }
hostname = "BCDClock-01"

-- my private file with wifi credentials
dofile("my.netconf.lua")
if file.exists("eus_params.lua") then
    p = dofile("eus_params.lua")
    ssid = p.wifi_ssid
    pwd = p.wifi_password
end
