local utils = {}

--[[
    Trims the string by removing all spaces and converting it to lowercase.

    @param str: string - The string to trim.
    @return: The trimmed string.
]]
function utils.TrimString(str)
    return (string.lower(string.gsub(str, "%s*", "")))
end

--[[
    Builds a table from a file string. 
    The lines must be written in this pattern : "number name (extension)" or "number name".
    The table will have items of this form : {name = name, number = number, extension = extension}.
    The keys are the names of the cards passed through the utils.TrimString function.

    @param fileURL: string - The path to the file that will be read.
    @returns: A table with the data of the file.
]]
function utils.BuildTable(fileURL)
    local file = io.open(fileURL, "rb")
    local collectionTable = {}
    if file then
        for line in file:lines() do 
            if (string.find(line, ".+%(.+") ~= nil) then
                local info = string.match(line, "%d+%s.+%s%(%w+%)$")
                local number = string.match(info, "^%d+")
                local extension = string.sub(string.match(info, "%(%w+%)"), 2, -2)
                local name = string.sub(info, string.find(info, number) + 2, string.find(info, extension) - 2)
                collectionTable[utils.TrimString(name)] = {name = name, number = number, extension = extension}
            else
                local info = string.match(line, "%d+%s.+")
                local number = string.match(info, "^%d+")
                local name = string.sub(info, #number + 2)
                collectionTable[utils.TrimString(name)] = {name = name, number = number, extension = nil}
            end
        end
        file:close()
    else
        print("File not found !")
    end
    return collectionTable
end

--[[
    Calculates the number of differences between two strings.
    A difference of 1 in length is counted as one, etc.

    @param str1: string - The first string to compare.
    @param str2: string - The second string to compare.
    @return: The number of differences between the two strings.
]]
function utils.StringDiff(str1, str2)
    local len1 = string.len(str1)
    local len2 = string.len(str2)
    local len = math.min(len1, len2)
    local diff = 0
    for i = 1, len do
        if string.sub(str1, i, i) ~= string.sub(str2, i, i) then
            diff = diff + 1
        end
    end
    return diff + math.abs(len1 - len2)
end

return utils