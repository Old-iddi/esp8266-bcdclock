TZHour = 3
TZMin = 0
BGHour = { 3,0,0 }
BGMin = { 3,0,0 }
BGSec = { 3,0,0 }
FGHour = { 15,8,2 }
FGMin = { 15,8,2 }
FGSec = { 15,8,2 }

dBGHour = { 20,0,0 }
dBGMin = { 20,0,0 }
dBGSec = { 20,0,0 }
dFGHour = { 80,80,80 }
dFGMin = { 80,80,80 }
dFGSec = { 80,80,80 }

Day = 7
Night = 21

topToBottom = false


resyncH = 4
resyncM = 0
resyncS = 0


autoTZ = true
httpFallback = true

displayDate = false
displayWeekday = true

if file.exists("userConfig.lua") then
    dofile("userConfig.lua")
end
