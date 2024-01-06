if displayTimer then displayTimer:stop() end

function isDay( hr ) 
   if Day < Night then
      return hr >= Day and hr < Night
   elseif Day > Night then
      return not (hr >= Night and hr < Day)
   else
      return true
   end
end

function displayClock()
    iteration = iteration + 1

    if clockState == 2 and oldState~=2 then
        ws2812_effects.stop()
        ws2812_effects.set_speed(250)
        ws2812_effects.set_brightness(25)
        ws2812_effects.set_color(0, 0, 255)
        ws2812_effects.set_mode("larson_scanner")
        ws2812_effects.start()
    end
    if clockState == 3 and oldState~=3 then
             ws2812_effects.stop()
             ws2812_effects.set_speed(250)
            ws2812_effects.set_brightness(50)
            ws2812_effects.set_color(255, 0, 0)
            ws2812_effects.set_mode("larson_scanner")
            ws2812_effects.start()
     end
     if clockState > 3 then
        if oldState < 4 then
            ws2812_effects.stop()
        end

        tm = rtctime.epoch2cal(rtctime.get())

        numbers = {}

        hour = tm["hour"] + TZHour
        min = tm["min"] + TZMin
        sec = tm["sec"]

        numbers[1] = hour / 10
        numbers[2] = hour % 10
        numbers[3] = min / 10
        numbers[4] = min % 10
        numbers[5] = sec / 10
        numbers[6] = sec % 10

        bitArray = {}
        for i = 1, 42 do
            bitArray[i] = 1
        end

        statusLed = 1
        if topToBottom then

        HBits = {1,14}
        MBits = {15,28}
        SBits = {29,42}
        
        --bitArray[1] = bit.isset(numbers[1], 3)
        --bitArray[3] = bit.isset(numbers[1], 2)
        bitArray[5] = bit.isset(numbers[1], 1)
        bitArray[7] = bit.isset(numbers[1], 0)

        bitArray[8] = bit.isset(numbers[2], 0)
        bitArray[10] = bit.isset(numbers[2], 1)
        bitArray[12] = bit.isset(numbers[2], 2)
        bitArray[14] = bit.isset(numbers[2], 3)

        bitArray[15] = bit.isset(numbers[3], 3)
        bitArray[17] = bit.isset(numbers[3], 2)
        bitArray[19] = bit.isset(numbers[3], 1)
        bitArray[21] = bit.isset(numbers[3], 0)

        bitArray[22] = bit.isset(numbers[4], 0)
        bitArray[24] = bit.isset(numbers[4], 1)
        bitArray[26] = bit.isset(numbers[4], 2)
        bitArray[28] = bit.isset(numbers[4], 3)

        bitArray[29] = bit.isset(numbers[5], 3)
        bitArray[31] = bit.isset(numbers[5], 2)
        bitArray[33] = bit.isset(numbers[5], 1)
        bitArray[35] = bit.isset(numbers[5], 0)

        bitArray[36] = bit.isset(numbers[6], 0)
        bitArray[38] = bit.isset(numbers[6], 1)
        bitArray[40] = bit.isset(numbers[6], 2)
        bitArray[42] = bit.isset(numbers[6], 3)
        else
 
        SBits = {1,14}
        MBits = {15,28}
        HBits = {29,42}

        bitArray[1] = bit.isset(numbers[6], 0)
        bitArray[3] = bit.isset(numbers[6], 1)
        bitArray[5] = bit.isset(numbers[6], 2)
        bitArray[7] = bit.isset(numbers[6], 3)

        bitArray[8] = bit.isset(numbers[5], 3)
        bitArray[10] = bit.isset(numbers[5], 2)
        bitArray[12] = bit.isset(numbers[5], 1)
        bitArray[14] = bit.isset(numbers[5], 0)

        bitArray[15] = bit.isset(numbers[4], 0)
        bitArray[17] = bit.isset(numbers[4], 1)
        bitArray[19] = bit.isset(numbers[4], 2)
        bitArray[21] = bit.isset(numbers[4], 3)

        bitArray[22] = bit.isset(numbers[3], 3)
        bitArray[24] = bit.isset(numbers[3], 2)
        bitArray[26] = bit.isset(numbers[3], 1)
        bitArray[28] = bit.isset(numbers[3], 0)

        bitArray[29] = bit.isset(numbers[2], 0)
        bitArray[31] = bit.isset(numbers[2], 1)
        bitArray[33] = bit.isset(numbers[2], 2)
        bitArray[35] = bit.isset(numbers[2], 3)

        --bitArray[36] = bit.isset(numbers[1], 3)
        --bitArray[38] = bit.isset(numbers[1], 2)
        bitArray[40] = bit.isset(numbers[1], 1)
        bitArray[42] = bit.isset(numbers[1], 0)
        statusLed = 36
        end

        stringArray = {}
        for i = HBits[1], HBits[2] do
            if (bitArray[i] == 1) then
                strip_buffer:set(i, 0, 0, 0)
            elseif (bitArray[i] == false) then
                if isDay(hour) then
                  strip_buffer:set(i, dBGHour[2], dBGHour[1], dBGHour[3])
                else
                  strip_buffer:set(i, BGHour[2], BGHour[1], BGHour[3])
                end               
            else
                if isDay(hour) then
                  strip_buffer:set(i, dFGHour[2], dFGHour[1], dFGHour[3])
                else
                  strip_buffer:set(i, FGHour[2], FGHour[1], FGHour[3])
                end               
            end
        end
        for i = MBits[1], MBits[2] do
            if (bitArray[i] == 1) then
                strip_buffer:set(i, 0, 0, 0)
            elseif (bitArray[i] == false) then
                if isDay(hour) then
                  strip_buffer:set(i, dBGMin[2], dBGMin[1], dBGMin[3])
                else
                  strip_buffer:set(i, BGMin[2], BGMin[1], BGMin[3])
                end               
             else
                if isDay(hour) then
                  strip_buffer:set(i, dFGMin[2], dFGMin[1], dFGMin[3])
                else
                  strip_buffer:set(i, FGMin[2], FGMin[1], FGMin[3])
                end               
           end
        end
        for i = SBits[1], SBits[2] do
            if (bitArray[i] == 1) then
                strip_buffer:set(i, 0, 0, 0)
            elseif (bitArray[i] == false) then
                if isDay(hour) then
                  strip_buffer:set(i, dBGSec[2], dBGSec[1], dBGSec[3])
                else
                  strip_buffer:set(i, BGSec[2], BGSec[1], BGSec[3])
                end               
           else
               if isDay(hour) then
                  strip_buffer:set(i, dFGSec[2], dFGSec[1], dFGSec[3])
                else
                  strip_buffer:set(i, FGSec[2], FGSec[1], FGSec[3])
                end               
            end
        end

        if clockState == 5 then
            if iteration % 3 == 0 then
                strip_buffer:set(statusLed, 0, 0, 7)
            --- else
            ---     strip_buffer:set(7, 0, 2, 0)
            end
        end
        if clockState == 6 then
            if iteration % 3 == 0 then
                strip_buffer:set(statusLed, 7, 0, 0)
            --- else
            ---     strip_buffer:set(7, 0, 2, 0)
            end
        end

        ws2812.write(strip_buffer)
    end
    oldState = clockState
end

oldState = 0
iteration = 0

displayTimer = tmr.create()
displayTimer:register(200, tmr.ALARM_AUTO, displayClock)
displayTimer:interval(200)
displayTimer:start()
