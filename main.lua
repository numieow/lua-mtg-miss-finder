function main()

    -- deifne the paths of the files to read/write
    local havesURL = './data/haves.txt'
    local havenotsURL = './data/havenots.txt'
    local wantsURL = './data/wants.txt'
    local collectionURL = './data/collection.txt'


    -- Processing the collection file, building a table wth data of quantity and number of each card
    local collectionTable = {}
    local collectionFile = io.open(collectionURL, "rb")
    if collectionFile then
        for line in collectionFile:lines() do 
            print("\nLINE : ", line)
            print("BOOL : ", string.find(line, ".+%(.+"))
            if (string.find(line, ".+%(.+") ~= nil) then
                local info = string.match(line, "%d+%s.+%s%(%w+%)$")
                local number = string.match(info, "^%d+")
                local extension = string.sub(string.match(info, "%(%w+%)"), 2, -2)
                local name = string.sub(info, string.find(info, number) + 2, string.find(info, extension) - 2)
                print(info, number, extension, name)
                collectionTable[name] = {number = number, extension = extension}
            else 
                local info = string.match(line, "%d+%s%w+")
                local number = string.match(info, "^%d+")
                local name = string.sub(info, string.find(info, number) + 2, -1)
                print(info, number, name)
                collectionTable[name] = {number = number, extension = nil}
            end
        end
        collectionFile:close()
    else 
        print("Collection file not found !")
    end

    --line format : number name (extension)
    print("Hello guys !")
end

main()