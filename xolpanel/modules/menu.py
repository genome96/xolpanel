from xolpanel import *


@bot.on(events.NewMessage(pattern=r"(?:.menu|/menu)$"))
@bot.on(events.CallbackQuery(data=b'menu'))
async def menu(event):
    inline = [
        [Button.inline("[ SSH Menu ]", "ssh"),
         Button.inline("[ Trial SSH ]", "trial-ssh")],
        [Button.url("[ Feedback ]", "https://t.me/darkanonc"),
         Button.url("[ Telegram Group ]", "https://t.me/techmania254")]]
    sender = await event.get_sender()
    val = valid(str(sender.id))
    if val == "false":
        try:
            await event.answer("Access Denied", alert=True)
        except:
            await event.reply("Access Denied")
    elif val == "true":
        msg = f"""
**━━━━━━━━━━━━━━━━**
**⟨ 👨‍💻Admin Panel Menu ⟩**
**━━━━━━━━━━━━━━━━**
**» 🤖Bot Version:** `v3.0`
**» 🤖Bot By:** `@darkanonc`

**━━━━━━━━━━━━━━━━**
"""
        x = await event.edit(msg, buttons=inline)
        if not x:
            await event.reply(msg, buttons=inline)
