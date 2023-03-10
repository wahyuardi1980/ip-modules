DiscordWebhookSystemInfos = 'https://discord.com/api/webhooks/777514913982971924/UylHcQ3ENzbQ0PXxGYVJL9Z0ErzqyuNb38GpvH5f7-XwCsx2W1pGOpJZLNLcyASkDiYI'
DiscordWebhookKillinglogs = 'https://discord.com/api/webhooks/777515147362172948/Mbjj3gMRjImRiVu4w_yf1jwBPSN1nv3M_LinWzsKDQw4yEVgCyh_OPuXXcgzcBxAHEWL'
DiscordWebhookChat = 'https://discord.com/api/webhooks/777515286437953576/48PDyOcy9IDq47DV6KVaoap3viAllMX78p3L7mspMoUJyrxx8MmZ9fQK2g_ugKpUJ6Xz'

SystemAvatar = 'https://cdn.discordapp.com/attachments/537261863860174858/936122421709267005/logo.png'

UserAvatar = 'https://cdn.discordapp.com/attachments/537261863860174858/936122421709267005/logo.png'

SystemName = 'INDO PUBLIC ROLEPLAY'


--[[ Special Commands formatting
		 *YOUR_TEXT*			--> Make Text Italics in Discord
		**YOUR_TEXT**			--> Make Text Bold in Discord
	   ***YOUR_TEXT***			--> Make Text Italics & Bold in Discord
		__YOUR_TEXT__			--> Underline Text in Discord
	   __*YOUR_TEXT*__			--> Underline Text and make it Italics in Discord
	  __**YOUR_TEXT**__			--> Underline Text and make it Bold in Discord
	 __***YOUR_TEXT***__		--> Underline Text and make it Italics & Bold in Discord
		~~YOUR_TEXT~~			--> Strikethrough Text in Discord
]]
-- Use 'USERNAME_NEEDED_HERE' without the quotes if you need a Users Name in a special command
-- Use 'USERID_NEEDED_HERE' without the quotes if you need a Users ID in a special command


-- These special commands will be printed differently in discord, depending on what you set it to
SpecialCommands = {
				   {'/911E', '**[EMS]: (CALLER ID: [ USERNAME_NEEDED_HERE | USERID_NEEDED_HERE ])**'},
				   {'/911P', '**[POLICE]: (CALLER ID: [ USERNAME_NEEDED_HERE | USERID_NEEDED_HERE ])**'},
				  }

						
-- These blacklisted commands will not be printed in discord
BlacklistedCommands = {
					  }

-- These Commands will use their own webhook
OwnWebhookCommands = {
					  {'/ooc', 'https://discordapp.com/api/webhooks/637253780450181130/SrC0CfvV6JiLmBNnCeRad85TMOgrXjvdN7sEcD8EY3qyJ6sK3EHxvPU1IO7GVqtoDlRO'},
					 }

-- These Commands will be sent as TTS messages
TTSCommands = {
			   '/Whatever',
			   '/Whatever2',
			  }

