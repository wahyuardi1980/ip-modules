ConfigQueue = {}

-- priority list can be any identifier. (hex steamid, steamid32, ip) Integer = power over other people with priority
-- a lot of the steamid converting websites are broken rn and give you the wrong steamid. I use https://steamid.xyz/ with no problems.
-- you can also give priority through the API, read the examples/readme.
ConfigQueue.Priority = {
    ["steam:1100001370e72cb"] = 1,
    ["steam:1100001370e72cb"] = 25,
    ["steam:11000014AD0CBB2"] = 2,
    ["ip:36.90.14.93"] = 84,
    ["ip:36.71.138.124"] = 85
}

-- require people to run steam
ConfigQueue.RequireSteam = true

-- "whitelist" only server
ConfigQueue.PriorityOnly = false

-- disables hardcap, should keep this true
ConfigQueue.DisableHardCap = true

-- will remove players from connecting if they don't load within: __ seconds; May need to increase this if you have a lot of downloads.
-- i have yet to find an easy way to determine whether they are still connecting and downloading content or are hanging in the loadscreen.
-- This may cause session provider errors if it is too low because the removed player may still be connecting, and will let the next person through...
-- even if the server is full. 10 minutes should be enough
ConfigQueue.ConnectTimeOut = 600

-- will remove players from queue if the server doesn't recieve a message from them within: __ seconds
ConfigQueue.QueueTimeOut = 90

-- will give players temporary priority when they disconnect and when they start loading in
ConfigQueue.EnableGrace = false

-- how much priority power grace time will give
ConfigQueue.GracePower = 5

-- how long grace time lasts in seconds
ConfigQueue.GraceTime = 480

ConfigQueue.AntiSpamTimer = 10
ConfigQueue.PleaseWait_1 = "Silahkan Tunggu "
ConfigQueue.PleaseWait_2 = " Detik. Untuk Terhubung Ke Server!"

-- on resource start, players can join the queue but will not let them join for __ milliseconds
-- this will let the queue settle and lets other resources finish initializing
ConfigQueue.JoinDelay = 30000

-- will show how many people have temporary priority in the connection message
ConfigQueue.ShowTemp = false

-- simple localization
ConfigQueue.Language = {
    joining = "\xF0\x9F\x8E\x89Otw Masuk...",
    connecting = "\xE2\x8F\xB3Connecting...",
    idrr = "\xE2\x9D\x97[Queue] Error: Couldn't retrieve any of your id's, try restarting.",
    err = "\xE2\x9D\x97[Queue] There was an error",
    pos = "\xF0\x9F\x90\x8CAnda %d/%d Di antrian \xF0\x9F\x95\x9C%s",
    connectingerr = "\xE2\x9D\x97[Queue] Error: Error adding you to connecting list",
    timedout = "\xE2\x9D\x97[Queue] Error: Timed out?",
    wlonly = "\xE2\x9D\x97[Queue] You must be whitelisted to join this server",
    steam = "\xE2\x9D\x97 [Queue] Error: Steam must be running"
}
