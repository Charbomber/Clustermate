

-- generates a random tip of the day
local tipTable = {
  "Self-confidence is extremely important. Believe in yourself!",
  "MAP11 has two names.",
  "Flash Man is weak to Metal Blade, too.",
  "The remote is made up of more polygons than all of SM64!",
  "Apple Girlington only takes damage from Dark Sword and Ice Barrier!",
  "Synthstatica actually has a weakness to Energy Blast.",
  "Clip out of the map to see Dopefish!",
  "Watch for Rolling Rocks in 0x A Presses requires kidnapping bats.",
  "Don't pull a pull block into another pull block or else!",
  "Do a backflip and throw a spear down to make a handy pole.",
  "Winners don't do drugs!",
  "Keep your enemies close, and your friends closer.",
  "I am completely unrelated to Bob the Hampster.",
  "Trans rights!",
  "Killer Queen has already touched the 'New Cluster' button!",
  "Sugar is incredibly weak to poison!",
  "Try turning it off and then on again!",
  "Press the 'power button' to turn your 'computer' off!",
}


function TipOfDay()
  local tip = tipTable[math.random(#tipTable)]
  debugConsole("Tip Gotten, here it is: \""..tip..'"')
  return tip
end


debugConsole("tipoftheday.lua Loaded")
