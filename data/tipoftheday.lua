

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
}


function TipOfDay()
  return tipTable[math.random(#tipTable)]
end
