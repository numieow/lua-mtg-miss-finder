function main()

    -- deifne the paths of the files to read/write
    local havesURL = './data/haves.txt'
    local havenotsURL = './data/havenots.txt'
    local wantsURL = './data/wants.txt'
    local collectionURL = './data/collection.txt'


    -- Processing the collection file, building a table wth data of quantity and number of each card
    local collectionTable = BuildTable(collectionURL)

    for key, value in pairs(collectionTable) do
        print("Clé : " .. key .. " -> " .. value.name .. " " ..  value.number .. (function() if value.extension then return " (" .. value.extension .. ")" else return "" end end)())
    end

    print("GOING THROUGH WANTS FILE")

    -- Going through the wants file, and checking if the cards are in the collection
    local wantsFile = io.open(wantsURL, "rb")
    local havenotsFile = io.open(havenotsURL, "a")
    local havesFile = io.open(havesURL, "a")
    if wantsFile then
        for line in wantsFile:lines() do
            if (string.find(line, ".+%(.+") ~= nil) then
                local info = string.match(line, "%d+%s.+%s%(%w+%)$")
                local wantsNumber = string.match(info, "^%d+")
                local wantsExtension = string.sub(string.match(info, "%(%w+%)"), 2, -2)
                local wantsName = string.sub(info, string.find(info, wantsNumber) + 2, string.find(info, wantsExtension) - 2)
                local wantsKey = TrimString(wantsName)

                if collectionTable[wantsKey] then
                    local collectionNumber = collectionTable[wantsKey].number
                    local collectionExtension = collectionTable[wantsKey].extension
                    if collectionNumber >= wantsNumber then
                        if collectionExtension == wantsExtension then
                            if havesFile then
                                havesFile:write(wantsNumber .. " " .. wantsName .. " (" .. collectionExtension .. ")\n")
                            end
                        else
                            if havenotsFile then
                                havenotsFile:write(wantsNumber .. " " .. wantsName .. " (" .. wantsExtension .. ")\n")
                            end
                        end
                    else
                        if collectionExtension == wantsExtension then
                            if havesFile then
                                havesFile:write((wantsNumber - collectionNumber) .. " " .. wantsName .. " (" .. collectionExtension .. ")\n")
                            end
                        else
                            if havenotsFile then
                                havenotsFile:write((wantsNumber - collectionNumber) .. " " .. wantsName .. " (" .. wantsExtension .. ")\n")
                            end
                        end
                    end
                else
                    if havenotsFile then
                        havenotsFile:write(wantsNumber .. " " .. wantsName .. " (" .. wantsExtension .. ")\n")
                    end
                end
            else
                local info = string.match(line, "%d+%s.+")
                local wantsNumber = string.match(info, "^%d+")
                local start, ending = string.find(info, wantsNumber)
                local wantsName = string.sub(info, ending + 2, -1)
                local wantsKey = TrimString(wantsName)

                print("Nom : " .. wantsName .. " et la clé : |" .. wantsKey .. "|")
                local a = StringDiff(wantsKey,"gaea'scradle")

                if collectionTable[wantsKey] then
                    local collectionNumber = collectionTable[wantsKey].number
                    local collectionExtension = collectionTable[wantsKey].extension
                    if collectionNumber >= wantsNumber then
                        if havesFile then
                            havesFile:write(wantsNumber .. " " .. wantsName .. (function() if collectionExtension then return " (" .. collectionExtension .. ")\n" else return "\n" end end)())
                        end
                    else
                        if havesFile then
                            havesFile:write(collectionNumber .. " " .. wantsName .. (function() if collectionExtension then return " (" .. collectionExtension .. ")\n" else return "\n" end end)())
                        end

                        if havenotsFile then
                            havenotsFile:write((wantsNumber - collectionNumber) .. " " .. wantsName .. (function() if collectionExtension then return " (" .. collectionExtension .. ")\n" else return "\n" end end)())
                        end
                    end
                else
                    if havenotsFile then
                        havenotsFile:write(wantsNumber .. " " .. wantsName .. "\n")
                    end
                end

            end
        end
    else
        print("Wants file not found !")
    end
end



function BuildTable(fileURL)
    local file = io.open(fileURL, "rb")
    local collectionTable = {}
    if file then
        for line in file:lines() do 
            if (string.find(line, ".+%(.+") ~= nil) then
                local info = string.match(line, "%d+%s.+%s%(%w+%)$")
                local number = string.match(info, "^%d+")
                local extension = string.sub(string.match(info, "%(%w+%)"), 2, -2)
                local name = string.sub(info, string.find(info, number) + 2, string.find(info, extension) - 2)
                print("|" .. TrimString(name) .. "|")
                collectionTable[TrimString(name)] = {name = name, number = number, extension = extension}
            else
                local info = string.match(line, "%d+%s.+")
                local number = string.match(info, "^%d+")
                local name = string.sub(info, #number + 2)
                collectionTable[TrimString(name)] = {name = name, number = number, extension = nil}
            end
        end
        file:close()
    else
        print("File not found !")
    end
    return collectionTable
end

function TrimString(str)
    return (string.lower(string.gsub(str, "%s*", "")))
end

function StringDiff(str1, str2)
    local len1 = string.len(str1)
    local len2 = string.len(str2)
    local len = math.min(len1, len2)
    local diff = 0
    for i = 1, len do
        if string.sub(str1, i, i) ~= string.sub(str2, i, i) then
            print("DIFF : " .. string.sub(str1, i, i))
            diff = diff + 1
        end
    end
    return diff + math.abs(len1 - len2)
end

main()