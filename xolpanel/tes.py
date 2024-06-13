@bot.on(events.NewMessage(pattern="/start"))
async def start(event):
    await event.reply("Bot made by @darkanonc")


print("welcome")
