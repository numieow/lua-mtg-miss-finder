# lua-miss-finder

## What it does : 

Yuo just got an interesting deck you want to build, but don't know exactly what cards you're missing ? With the cards you already own and the decklist, this script outputs 2 text files, with the haves.txt file containing the cards you already own, and the havenots.txt file containing the ones you don't !
You can now just copy and paste in your CardMarket wants to buy only the cards you need !

## How it works : 

In the data/ repository, you will find 4 files : haves, havenots, wants and collection.
The collection files will contain the relevant cards you already own.
The wants file will contain the entire decklist.

The haves and havenots files will cintain the cards you have and have not, after the script has run.

The correct format is as follows : 
```
1 Ghave, Guru of Spores (2X2)
1 Abrupt Decay
1 Ad Nauseam
1 Allosaurus Shepherd
...
```

You can now execute the main.lua script toget your lists ! 
