local function main()

    -- define the paths of the files to read/write
    local havesURL = './data/haves.txt'
    local havenotsURL = './data/havenots.txt'
    local wantsURL = './data/wants.txt'
    local collectionURL = './data/collection.txt'

    -- gathering the utils module
    local utils = require("utils")


    -- Processing the collection file, building a table wth data of quantity and number of each card
    local collectionTable = utils.BuildTable(collectionURL)

    -- Going through the wants file, and checking if the cards are in the collection
    local wantsFile = io.open(wantsURL, "rb")
    local havenotsFile = io.open(havenotsURL, "a")
    local havesFile = io.open(havesURL, "a")

    if not havenotsFile or not havesFile then
        print("Error opening files !")
        return
    end

    if wantsFile then
        for line in wantsFile:lines() do
            if (string.find(line, ".+%(.+") ~= nil) then
                local info = string.match(line, "%d+%s.+%s%(%w+%)$")
                local wantsNumber = string.match(info, "^%d+")
                local wantsExtension = string.sub(string.match(info, "%(%w+%)"), 2, -2)
                local wantsName = string.sub(info, string.find(info, wantsNumber) + 2, string.find(info, wantsExtension) - 2)
                local wantsKey = utils.TrimString(wantsName)

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
                local wantsKey = utils.TrimString(wantsName)

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

main()