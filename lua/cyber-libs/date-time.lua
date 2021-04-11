local os = os
local tonumber = tonumber
local string = string
local table = table
local GetConVar = GetConVar
local isstring = isstring
--- The module for working with dates. Shared module.
-- @module DateTime
local DateTime = {}
local Str = CW:Lib('string')

---	Today
-- @return today date in format YYYY-MM-DD
function DateTime:TodayDate()
    return os.date('%Y-%m-%d', os.time())
end

---	Now Stamp
-- @return current timestamp
function DateTime:NowStamp()
    return os.time()
end

--- Convertor Stamp to Date
function DateTime:GetDateFromStamp(timestamp)
    return os.date('%Y-%m-%d', timestamp)
end

--- Convertor Date to Stamp
function DateTime:GetStampFromDate(datestring)
    local tbl = {}
    tbl.day = tonumber(string.sub(datestring, 9, 10))
    tbl.month = tonumber(string.sub(datestring, 6, 7))
    tbl.year = tonumber(string.sub(datestring, 1, 4))

    return os.time(tbl), tbl
end

--- Convertor Stamp to DateTime
function DateTime:GetDateTimeFromStamp(timestamp)
    return os.date('%Y-%m-%d %H:%M:%S', timestamp)
end

--- Convertor DateTime to Stamp
function DateTime:GetStampFromDateTime(datetimestring)
    local tbl = {}
    tbl.day = tonumber(string.sub(datetimestring, 9, 10))
    tbl.month = tonumber(string.sub(datetimestring, 6, 7))
    tbl.year = tonumber(string.sub(datetimestring, 1, 4))
    tbl.hour = tonumber(string.sub(datetimestring, 12, 13))
    tbl.min = tonumber(string.sub(datetimestring, 15, 16))
    tbl.sec = tonumber(string.sub(datetimestring, 18, 19))

    return os.time(tbl), tbl
end

-- добавление падежей - https://lampa.io/p/%D0%BF%D0%B0%D0%B4%D0%B5%D0%B6%D0%B8-0000000027fd5085d75498af493848d1
function DateTime:GetNiceTranslatedTime(seconds, padezhCode)
    if CLIENT and not table.HasValue({'ru', 'uk'}, GetConVar('gmod_language'):GetString()) then
        return string.NiceTime(seconds)
    end

    if seconds > 60 * 59 then
        seconds = seconds + 60 * 59
    elseif seconds > 59 then
        seconds = seconds + 59
    end

    local fullTime = string.Explode(' ', string.NiceTime(seconds))
    local units, measure = tonumber(fullTime[1]), fullTime[2]

    if string.find(measure, 'hour') then
        measure = Str:GetNumEnding(units, 'часов', 'час', 'часа')
    elseif string.find(measure, 'day') then
        measure = Str:GetNumEnding(units, 'дней', 'день', 'дня')
    elseif string.find(measure, 'mounth') then
        measure = Str:GetNumEnding(units, 'месяцев', 'месяц', 'месяца')
    elseif string.find(measure, 'year') then
        measure = Str:GetNumEnding(units, 'лет', 'год', 'года')
    else
        if not padezhCode or padezhCode == 'im' or not isstring(padezhCode) then
            if string.find(measure, 'second') then
                measure = Str:GetNumEnding(units, 'секунд', 'секунда', 'секунды')
            elseif string.find(measure, 'minute') then
                measure = Str:GetNumEnding(units, 'минут', 'минута', 'минуты')
            end
        elseif padezhCode == 'ro' then
            if string.find(measure, 'second') then
                measure = Str:GetNumEnding(units, 'секунд', 'секунды', 'секунды')
            elseif string.find(measure, 'minute') then
                measure = Str:GetNumEnding(units, 'минут', 'минуты', 'минуты')
            end
        elseif padezhCode == 'vi' then
            if string.find(measure, 'second') then
                measure = Str:GetNumEnding(units, 'секунд', 'секунду', 'секунды')
            elseif string.find(measure, 'minute') then
                measure = Str:GetNumEnding(units, 'минут', 'минуту', 'минуты')
            end
        end
    end

    return units .. ' ' .. (measure or '')
end

return DateTime