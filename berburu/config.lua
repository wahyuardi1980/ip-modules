AOD = {}

AOD.HuntAnimals = { 'a_c_deer', 'a_c_coyote', 'a_c_boar' }
AOD.SpawnDistanceRadius = math.random(3, 6) --disance animal spawns from bait
-- AOD.HuntingZones = { 'CMSW', 'SANCHIA', 'MTGORDO', 'MTJOSE', 'RC' } --add valid zones here
AOD.SpawnChance = 0.5                       -- 10 percent chance use values .01 - 1.0
AOD.DistanceFromBait = 25.0                 -- distance from player to spawn bait
AOD.DistanceTooCloseToAnimal = 15.0
AOD.HuntingWeapon = `WEAPON_MUSKET`         --set to nil for no requirement
AOD.HuntAnyWhere = false
AOD.UseBlip = true                          -- set to true for the animal to have a blip on the map
AOD.BlipText = 'Hewan Berburu'
AOD.HuntingArea = vector3(-1170.46, 4567.51, 141.6)
--Rewards for butchering animals
AOD.BoarMeat = math.random(5) -- amount of meat to receive from Boars
AOD.BoarSkin = 2
AOD.DeerSkin = 1
AOD.DeerMeat = math.random(5)
AOD.CoyoteFur = 1
AOD.CoyoteMeat = math.random(5)

AOD.Strings = {
    ESXClient = 'esx:getSharedObject',
    ESXServer = 'esx:getSharedObject',
    NotValidZone = 'Tidak Bisa Memasang Umpan DiArea Ini!',
    ExploitDetected = 'Anda mencoba mengeksploitasi, tolong jangan lakukan ini',
    DontSpam = 'Anda dikenakan biaya satu umpan untuk spamming',
    WaitToBait = 'Anda harus menunggu lebih lama untuk menempatkan umpan',
    PlacingBait = 'Memasang Umpan',
    BaitPlaced = 'Umpan Telah Diletakkan.. Sekarang Saatnya Menunggu',
    Roadkill = 'Lebih terlihat seperti roadkill sekarang',
    NoAnimal = 'No Animal nearby',
    NotDead = 'Binatang Itu Tidak Mati',
    NotYours = 'Not your animal',
    WTF = 'What are you doing?',
    Harvest = 'Menyembelih Hewan',
    Butchered = 'Animal butchered'
}
