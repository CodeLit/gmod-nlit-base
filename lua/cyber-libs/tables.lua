local table = table
local tobool = tobool
local string = string
local type = type
local SortedPairs = SortedPairs

-- MultipleSort(table,'job','salary^') -- ^ обозначает, что сортируем по возрастанию
function MultipleSort(t, ...)
    local args = {...}

    table.sort(t, function(a, b)
        local function isHigher(i)
            local arg = args[i]
            if arg == nil then return end
            local bAscend = tobool(string.sub(arg, #arg) == '^')

            -- обрезаем символ
            if bAscend then
                arg = string.sub(arg, 1, #arg - 1)
            end

            -- кинуть безиндексовые значения в начало таблицы
            if a[arg] == nil then
                return bAscend
            elseif b[arg] == nil then
                return not bAscend
            end

            if type(a[arg]) ~= type(b[arg]) then return end

            if a[arg] > b[arg] then
                return not bAscend
            elseif a[arg] < b[arg] then
                return bAscend
            else
                return isHigher(i + 1)
            end
        end

        return isHigher(1)
    end)
end

function RemoveDuplicateValues(tbl)
    local hash = {}
    local result = {}

    for k, v in SortedPairs(tbl) do
        if (not hash[v]) then
            result[k] = v
            hash[v] = true
        end
    end

    return result
end
--
-- local tbl = {
-- 	{pay=900,cat='gg'},
-- 	{pay=200,cat='gh'},
-- 	{pay=100,cat='gs'},
-- 	{pay=600},
-- 	{pay=400},
-- 	{pay=300},
-- 	{pay=500,cat='кг'},
-- 	{pay=700,cat='кы'},
-- 	{pay=700,cat='км'},
-- }
--
-- MultipleSort(tbl,'cat^','pay')
--
-- np(tbl)