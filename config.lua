TZHour = 3
TZMin = 0
BGHour = { 1,0,0 }
BGMin = { 1,0,0 }
BGSec = { 1,0,0 }
FGHour = { 7,4,1 }
FGMin = { 7,4,1 }
FGSec = { 7,4,1 }

dBGHour = { 20,0,0 }
dBGMin = { 20,0,0 }
dBGSec = { 20,0,0 }
dFGHour = { 80,80,80 }
dFGMin = { 80,80,80 }
dFGSec = { 80,80,80 }

DayOnWeekdays = { 8,7,7,7,7,7,8 }
NightOnWeekdays = { 21,21,21,21,21,21,21 }

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
