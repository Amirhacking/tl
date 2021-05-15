require('./Core/UtilsApi')
function PanelMenu(chatid ,Msgid, user_first, user)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	local Chat_id = chatid
	local U = '['..es_name(user_first)..'](tg://user?id='..es_name(user_first)..')'
	text = "`کاربر` "..U.." `به پنل مدیریتی گروه` *"..Chat_id.."* `خوش آمدید`"..EndMsg.."\n\n`توجه داشته باشید که` *(○➐ درصد)*  `تنظیمات مدیریت گروه شما از طریق ربات با` *^ پنل‌ ^* `قابل تنظیم میباشد` ، `شما میتوانید با دستور` *° راهنما °* `دستورات نوشتاری ربات را مشاهد کنید` 📱\n\n`برای حمایت از ما لطفا در نظرسنجی ربات شرکت کنید ♥️`\n\n⌚️ `آخرین بروز رسانی پنل :`\n"..os.date("%H:%M:%S")..""..EndInline
	keyboard = {}
	keyboard.inline_keyboard = {
	{
	{text = "♥️ "..tostring(redis:get(RedisIndex.."Likes")), callback_data="Like:"..Chat_id},
	{text = "💔 "..tostring(redis:get(RedisIndex.."DisLikes")), callback_data="Dislike:"..Chat_id}
	},
	{
	{text = Source_Start.."تنظیمات قفلی 🔐", callback_data="LockSettings:"..Chat_id},
	{text = Source_Start.."تنظیمات رسانه 🎞", callback_data="MuteSettings:"..Chat_id},
	},
	{
	{text = Source_Start.."تنظیمات سریع گروه 🌀", callback_data="LockSettingsFast:"..Chat_id}
	},
	{
	{text = Source_Start.."تنظیمات بیشتر ♾", callback_data="LockSettingsMore:"..Chat_id},
	{text = Source_Start.."پاکسازی 🗑", callback_data="Clean:"..Chat_id}
	},
	{
	{text = Source_Start..'آنتی اسپم و فلود 👁', callback_data = 'SpamSettings:'..Chat_id}
	},
	{
	{text = Source_Start..'اطلاعات گروه 📝', callback_data = 'MoreSettings:'..Chat_id},
	{text = Source_Start..'اد اجباری 🔖', callback_data = 'AddSettings:'..Chat_id}
	},
	{
	{text = Source_Start..'پشتیبانی ربات 🖥', callback_data = 'Manager:'..Chat_id}
	},
	{
	{text= Source_Start..'بستن پنل گروه 🔗' ,callback_data = 'ExitPanel:'..Chat_id}
	}
	}
	EditInline(text, Chat_id, Msgid, "md", keyboard)
end
function HelpCode(chatid ,Msgid, user_first, user)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	local Chat_id = chatid
	local U = '['..es_name(user_first)..'](tg://user?id='..es_name(user_first)..')'
	text = Source_Start.."`کاربر` "..U.." `به راهنمای ربات` *"..Chat_id.."* `خوش آمدید`"..EndMsg.."\n\n⌚️ `آخرین بروز رسانی پنل :`\n"..os.date("%H:%M:%S")..""..EndInline
	keyboard = {}
	keyboard.inline_keyboard = {
	{
	{text = Source_Start..'راهنمای مدیریتی 🔖', callback_data = 'Helpmod:'..Chat_id},
	{text = Source_Start..'راهنمای تنظیمی 🔧', callback_data = 'Helpset:'..Chat_id}
	},
	{
	{text = Source_Start..'راهنمای سرگرمی 🎮', callback_data = 'Helpfun:'..Chat_id}
	},
	{
	{text = Source_Start..'راهنمای پاکسازی 🗑', callback_data = 'Helpclean:'..Chat_id},
	{text = Source_Start..'راهنمای قفلی 🔐', callback_data = 'Helplock:'..Chat_id}
	},
	{
	{text= Source_Start..'بستن پنل راهنما 🔗' ,callback_data = 'ExitHelp:'..Chat_id}
	}
	}
	EditInline(text, Chat_id, Msgid, "md", keyboard)
end
function LockSettingsFast(chatid ,Msgid, user_first, user)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	local Chat_id = chatid
	local U = '['..es_name(user_first)..'](tg://user?id='..es_name(user_first)..')'
	text = Source_Start.."`کاربر` "..U.." `به تنظیمات سریع گروه` *"..Chat_id.."* `خوش آمدید`"..EndMsg.."\n\n⌚️ `آخرین بروز رسانی پنل :`\n"..os.date("%H:%M:%S")..""..EndInline
	keyboard = {}
	keyboard.inline_keyboard = {
	{
	{text = Source_Start.."قفل کامل تبلیغات", callback_data="Lockallads:"..Chat_id}
	},
	{
	{text = Source_Start.."قفل کامل رسانه", callback_data="Lockallmedia:"..Chat_id}
	},
	{
	{text = Source_Start.."باز کردن قفل ها", callback_data="UnlockallLock:"..Chat_id}
	},
	{
	{text = Source_Start..'بازگشت 🎈', callback_data = 'MenuSettings:'..Chat_id}
	}
	}
	EditInline(text, Chat_id, Msgid, "md", keyboard)
end
function Clean(chatid ,Msgid, user_first, user)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	local Chat_id = chatid
	local U = '['..es_name(user_first)..'](tg://user?id='..es_name(user_first)..')'
	text = Source_Start.."`کاربر` "..U.." `به پاکسازی ربات` *"..Chat_id.."* `خوش آمدید`"..EndMsg.."\n\n⌚️ `آخرین بروز رسانی پنل :`\n"..os.date("%H:%M:%S")..""..EndInline
	keyboard = {}
	keyboard.inline_keyboard = {
	{
	{text = Source_Start.."پاکسازی پیام ها گروه 🔖", callback_data="Clean:msg:"..Chat_id}
	},
	{
	{text = Source_Start.."پاکسازی رسانه ها گروه 🎥", callback_data="Clean:me:"..Chat_id}
	},
	{
	{text = Source_Start.."پاکسازی ↴", callback_data="Found:"..Chat_id},
	},
	{
	{text = Source_Start.."عکس ها 🎑", callback_data="Clean:ph:"..Chat_id},
	{text = Source_Start.."گیف ها 🃏", callback_data="Clean:gi:"..Chat_id}
	},
	{
	{text = Source_Start.."استیکر ها 🎨", callback_data="Clean:st:"..Chat_id},
	{text = Source_Start.."فیلم ها 🎬", callback_data="Clean:fi:"..Chat_id}
	},
	{
	{text = Source_Start.."ویس ها 🔊", callback_data="Clean:vo:"..Chat_id},
	{text = Source_Start.."آهنگ ها 🎼", callback_data="Clean:au:"..Chat_id}
	},
	{
	{text = Source_Start.."فایل 🗃", callback_data="Clean:fi:"..Chat_id},
	{text = Source_Start.."فیلم سلفی 📸", callback_data="Clean:se:"..Chat_id}
	},
	{
	{text = Source_Start..'بازگشت 🎈', callback_data = 'MenuSettings:'..Chat_id}
	}
	}
	EditInline(text, Chat_id, Msgid, "md", keyboard)
end
function CleanMsgs(chatid ,Msgid, text)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	keyboard = {}
	keyboard.inline_keyboard = {
	{{text = Source_Start.."بازگشت 🎈", callback_data="Clean:"..chat_id}}
	}
	EditInline(text, chatid, Msgid, "md", keyboard)
end
function LockSettingsMore(chatid ,Msgid, user_first, user)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	local Chat_id = chatid
	local U = '['..es_name(user_first)..'](tg://user?id='..es_name(user_first)..')'
	text = Source_Start.."`کاربر` "..U.." `به تنظیمات بیشتر گروه` *"..Chat_id.."* `خوش آمدید`"..EndMsg.."\n\n⌚️ `آخرین بروز رسانی پنل :`\n"..os.date("%H:%M:%S")..""..EndInline
	local delbot = redis:get(RedisIndex.."delbot"..Chat_id) and "فعال ✓" or "غیرفعال ✗"
	local a = redis:get(RedisIndex.."deltimebot"..Chat_id) or 60
	local delbottime = math.floor(a / 60)
	local b = redis:get(RedisIndex.."TimeMuteset"..Chat_id) or 3600
	local mutetime = math.floor(b / 60)
	mute_all = redis:get(RedisIndex..'mute_all:'..Chat_id)
	local All =  (mute_all == "Enable" and "فعال ✓" or "غیرفعال ✗")
	keyboard = {}
	keyboard.inline_keyboard = {
	{
	{text = Source_Start..'قفل گروه : '..All, callback_data = 'muteall:'..Chat_id}
	},
	{
	{text = Source_Start..'پاکسازی خودکار ربات : '..delbot, callback_data = 'Delbot:'..Chat_id}
	},
	{
	{text = Source_Start..'زمان پاکسازی خودکار ربات 🕘', callback_data = 'Found:'..Chat_id}
	},
	{
	{text = "↽", callback_data='delbotdown:'..Chat_id},
	{text = ""..delbottime.." ❲ دقیقه ❳", callback_data = 'Found:'..Chat_id},
	{text = "⇀", callback_data='delbotup:'..Chat_id}
	},
	{
	{text = Source_Start..'زمان سکوت', callback_data = 'Found:'..Chat_id}
	},
	{
	{text = "↽", callback_data='mutebotdown:'..Chat_id},
	{text = ""..mutetime.." ❲ دقیقه ❳", callback_data = 'Found:'..Chat_id},
	{text = "⇀", callback_data='mutebotup:'..Chat_id}
	},
	{
	{text = Source_Start..'بازگشت 🎈', callback_data = 'MenuSettings:'..Chat_id}
	}
	}
	EditInline(text, Chat_id, Msgid, "md", keyboard)
end
function SettingsLock(chatid, Msgid, user_first, user)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	local Chat_id = chatid
	lock_link = redis:get(RedisIndex..'lock_link:'..Chat_id)
	lock_join = redis:get(RedisIndex..'lock_join:'..Chat_id)
	lock_tag = redis:get(RedisIndex..'lock_tag:'..Chat_id)
	lock_username = redis:get(RedisIndex..'lock_username:'..Chat_id)
	lock_pin = redis:get(RedisIndex..'lock_pin:'..Chat_id)
	lock_arabic = redis:get(RedisIndex..'lock_arabic:'..Chat_id)
	lock_mention = redis:get(RedisIndex..'lock_mention:'..Chat_id)
	lock_edit = redis:get(RedisIndex..'lock_edit:'..Chat_id)
	lock_markdown = redis:get(RedisIndex..'lock_markdown:'..Chat_id)
	lock_webpage = redis:get(RedisIndex..'lock_webpage:'..Chat_id)
	lock_welcome = redis:get(RedisIndex..'welcome:'..Chat_id)
	lock_views = redis:get(RedisIndex..'lock_views:'..Chat_id)
	lock_tabchi = redis:get(RedisIndex..'lock_tabchi:'..Chat_id)
	local Link = (lock_link == "Warn") and "【✍🏻】" or ((lock_link == "Kick") and "【🚫】" or ((lock_link == "Mute") and "【🔇】" or ((lock_link == "Enable") and "【✓】" or "【✗】")))
	local Tags = (lock_tag == "Warn") and "【✍🏻】" or ((lock_tag == "Kick") and "【🚫】" or ((lock_tag == "Mute") and "【🔇】" or ((lock_tag == "Enable") and "【✓】" or "【✗】")))
	local User = (lock_username == "Warn") and "【✍🏻】" or ((lock_username == "Kick") and "【🚫】" or ((lock_username == "Mute") and "【🔇】" or ((lock_username == "Enable") and "【✓】" or "【✗】")))
	local Fa = (lock_arabic == "Warn") and "【✍🏻】" or ((lock_arabic == "Kick") and "【🚫】" or ((lock_arabic == "Mute") and "【🔇】" or ((lock_arabic == "Enable") and "【✓】" or "【✗】")))
	local Mention = (lock_mention == "Warn") and "【✍🏻】" or ((lock_mention == "Kick") and "【🚫】" or ((lock_mention == "Mute") and "【🔇】" or ((lock_mention == "Enable") and "【✓】" or "【✗】")))
	local Edit = (lock_edit == "Warn") and "【✍🏻】" or ((lock_edit == "Kick") and "【🚫】" or ((lock_edit == "Mute") and "【🔇】" or ((lock_edit == "Enable") and "【✓】" or "【✗】")))
	local Mar = (lock_markdown == "Warn") and "【✍🏻】" or ((lock_markdown == "Kick") and "【🚫】" or ((lock_markdown == "Mute") and "【🔇】" or ((lock_markdown == "Enable") and "【✓】" or "【✗】")))
	local Web = (lock_webpage == "Warn") and "【✍🏻】" or ((lock_webpage == "Kick") and "【🚫】" or ((lock_webpage == "Mute") and "【🔇】" or ((lock_webpage == "Enable") and "【✓】" or "【✗】")))
	local Views = (lock_views == "Warn") and "【✍🏻】" or ((lock_views == "Kick") and "【🚫】" or ((lock_views == "Mute") and "【🔇】" or ((lock_views == "Enable") and "【✓】" or "【✗】")))
	local Join =  (lock_join == "Enable" and "【✓】" or "【✗】")
	local Pin =  (lock_pin == "Enable" and "【✓】" or "【✗】")
	local Wel = (lock_welcome == "Enable" and "【✓】" or "【✗】")
	local Tabchi = (lock_tabchi == "Enable" and "【✓】" or "【✗】")
	local U = '['..es_name(user_first)..'](tg://user?id='..es_name(user_first)..')'
	text = Source_Start.."`کاربر` "..U.." `به تنظیمات قفلی گروه` *"..Chat_id.."* `خوش آمدید`"..EndMsg.."\n*راهنمای‌ ایموجی های موجود در این صفحه :*\n\n`✍🏻 = حالت اخطار\n🚫 = حالت اخراج\n🔇 = حالت سکوت\n✓ = فعال\n✗ = غیرفعال`\n\n⌚️ `آخرین بروز رسانی پنل :`\n"..os.date("%H:%M:%S")..""..EndInline
	keyboard = {}
	keyboard.inline_keyboard = {
	{
	{text = Source_Start.."لینک : "..Link, callback_data="locklink:"..Chat_id},
	{text = Source_Start.."ویرایش : "..Edit, callback_data="lockedit:"..Chat_id}
	},
	{
	{text = Source_Start.."نام کاربری : "..User, callback_data="lockusernames:"..Chat_id}
	},
	{
	{text = Source_Start.."تگ : "..Tags, callback_data="locktags:"..Chat_id},
	{text = Source_Start.."بازدید : "..Views, callback_data="lockviews:"..Chat_id}
	},
	{
	{text = Source_Start.."فراخوانی : "..Mention, callback_data="lockmention:"..Chat_id}
	},
	{
	{text = Source_Start.."ورود : "..Join, callback_data="lockjoin:"..Chat_id},
	{text = Source_Start.."عربی : "..Fa, callback_data="lockarabic:"..Chat_id}
	},
	{
	{text = Source_Start.."صفحات وب : "..Web, callback_data="lockwebpage:"..Chat_id},
	},
	{
	{text = Source_Start.."فونت : "..Mar, callback_data="lockmarkdown:"..Chat_id},
	{text = Source_Start.."تبچی : "..Tabchi, callback_data="locktabchi:"..Chat_id}
	},
	{
	{text = Source_Start.."خوشآمدگویی : "..Wel, callback_data="welcome:"..Chat_id},
	},
	{
	{text = Source_Start.."سنجاق : "..Pin, callback_data="lockpin:"..Chat_id},
	{text = Source_Start.."ربات ها 🔥", callback_data="lockbots:"..Chat_id}
	},
	{
	{text = Source_Start..'بازگشت 🎈', callback_data = 'MenuSettings:'..Chat_id}
	}
	}
	EditInline(text, Chat_id, Msgid, "md", keyboard)
end
function SettingsBots(chatid ,Msgid ,Bot, user_first, user)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	local Chat_id = chatid
	local user1 = '['..user..'](tg://user?id='..user..')'
	local Ch = '[🏷 کانال ما](https://telegram.me/'..channel_inline..')'
	text = Source_Start..'*کاربر* '..user1..' - `'..check_markdown(user_first)..'` *به تنظیمات پیشرفته قفل ربات گروه* `[ '..Chat_id..' ]` *خوشآمدید*'..EndMsg..'\n\n'..Ch
	keyboard = {}
	keyboard.inline_keyboard = {
	{{text = Source_Start.."قفل ربات : "..Bot, callback_data="Found:"..Chat_id}},
	{{text = Source_Start.."اخراج ربات 🚫", callback_data="lockbotskickbot:"..Chat_id}},
	{{text = Source_Start.."اخراج کاربر و ربات 🚫👦", callback_data="lockbotskickuser:"..Chat_id}},
	{{text = Source_Start.."غیرفعال ❌", callback_data="lockbotsdisable:"..Chat_id}},
	{{text = Source_Start.."بازگشت 🎈", callback_data="LockSettings:"..Chat_id}}
	}
	EditInline(text, Chat_id, Msgid, "md", keyboard)
end
function SettingsMute(chatid ,Msgid, user_first, user)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	local Chat_id = chatid
	mute_gif = redis:get(RedisIndex..'mute_gif:'..Chat_id)
	mute_photo = redis:get(RedisIndex..'mute_photo:'..Chat_id)
	mute_sticker = redis:get(RedisIndex..'mute_sticker:'..Chat_id)
	mute_contact = redis:get(RedisIndex..'mute_contact:'..Chat_id)
	mute_inline = redis:get(RedisIndex..'mute_inline:'..Chat_id)
	mute_game = redis:get(RedisIndex..'mute_game:'..Chat_id)
	mute_text = redis:get(RedisIndex..'mute_text:'..Chat_id)
	mute_keyboard = redis:get(RedisIndex..'mute_keyboard:'..Chat_id)
	mute_location = redis:get(RedisIndex..'mute_location:'..Chat_id)
	mute_document = redis:get(RedisIndex..'mute_document:'..Chat_id)
	mute_voice = redis:get(RedisIndex..'mute_voice:'..Chat_id)
	mute_audio = redis:get(RedisIndex..'mute_audio:'..Chat_id)
	mute_video = redis:get(RedisIndex..'mute_video:'..Chat_id)
	mute_video_note = redis:get(RedisIndex..'mute_video_note:'..Chat_id)
	mute_tgservice = redis:get(RedisIndex..'mute_tgservice:'..Chat_id)
	local Gif = (mute_gif == "Warn") and "【✍🏻】" or ((mute_gif == "Kick") and "【🚫】" or ((mute_gif == "Mute") and "【🔇】" or ((mute_gif == "Enable") and "【✓】" or "【✗】")))
	local Photo = (mute_photo == "Warn") and "【✍🏻】" or ((mute_photo == "Kick") and "【🚫】" or ((mute_photo == "Mute") and "【🔇】" or ((mute_photo == "Enable") and "【✓】" or "【✗】")))
	local Sticker = (mute_sticker == "Warn") and "【✍🏻】" or ((mute_sticker == "Kick") and "【🚫】" or ((mute_sticker == "Mute") and "【🔇】" or ((mute_sticker == "Enable") and "【✓】" or "【✗】")))
	local Contact = (mute_contact == "Warn") and "【✍🏻】" or ((mute_contact == "Kick") and "【🚫】" or ((mute_contact == "Mute") and "【🔇】" or ((mute_contact == "Enable") and "【✓】" or "【✗】")))
	local Inline = (mute_inline == "Warn") and "【✍🏻】" or ((mute_inline == "Kick") and "【🚫】" or ((mute_inline == "Mute") and "【🔇】" or ((mute_inline == "Enable") and "【✓】" or "【✗】")))
	local Game = (mute_game == "Warn") and "【✍🏻】" or ((mute_game == "Kick") and "【🚫】" or ((mute_game == "Mute") and "【🔇】" or ((mute_game == "Enable") and "【✓】" or "【✗】")))
	local Text = (mute_text == "Warn") and "【✍🏻】" or ((mute_text == "Kick") and "【🚫】" or ((mute_text == "Mute") and "【🔇】" or ((mute_text == "Enable") and "【✓】" or "【✗】")))
	local Key = (mute_keyboard == "Warn") and "【✍🏻】" or ((mute_keyboard == "Kick") and "【🚫】" or ((mute_keyboard == "Mute") and "【🔇】" or ((mute_keyboard == "Enable") and "【✓】" or "【✗】")))
	local Loc = (mute_location == "Warn") and "【✍🏻】" or ((mute_location == "Kick") and "【🚫】" or ((mute_location == "Mute") and "【🔇】" or ((mute_location == "Enable") and "【✓】" or "【✗】")))
	local Doc = (mute_document == "Warn") and "【✍🏻】" or ((mute_document == "Kick") and "【🚫】" or ((mute_document == "Mute") and "【🔇】" or ((mute_document == "Enable") and "【✓】" or "【✗】")))
	local Voice = (mute_voice == "Warn") and "【✍🏻】" or ((mute_voice == "Kick") and "【🚫】" or ((mute_voice == "Mute") and "【🔇】" or ((mute_voice == "Enable") and "【✓】" or "【✗】")))
	local Audio = (mute_audio == "Warn") and "【✍🏻】" or ((mute_audio == "Kick") and "【🚫】" or ((mute_audio == "Mute") and "【🔇】" or ((mute_audio == "Enable") and "【✓】" or "【✗】")))
	local Video = (mute_video == "Warn") and "【✍🏻】" or ((mute_video == "Kick") and "【🚫】" or ((mute_video == "Mute") and "【🔇】" or ((mute_video == "Enable") and "【✓】" or "【✗】")))
	local VSelf = (mute_video_note == "Warn") and "【✍🏻】" or ((mute_video_note == "Kick") and "【🚫】" or ((mute_video_note == "Mute") and "【🔇】" or ((mute_video_note == "Enable") and "【✓】" or "【✗】")))
	local Tgser =  (mute_tgservice == "Enable" and "【✓】" or "【✗】")
	local U = '['..es_name(user_first)..'](tg://user?id='..es_name(user_first)..')'
	text = Source_Start.."`کاربر` "..U.." `به تنظیمات رسانه گروه` *"..Chat_id.."* `خوش آمدید`"..EndMsg.."\n*راهنمای‌ ایموجی های موجود در این صفحه :*\n\n`✍🏻 = حالت اخطار\n🚫 = حالت اخراج\n🔇 = حالت سکوت\n✓ = فعال\n✗ = غیرفعال`\n\n⌚️ `آخرین بروز رسانی پنل :`\n"..os.date("%H:%M:%S")..""..EndInline
	keyboard = {}
	keyboard.inline_keyboard = {
	{
	{text = Source_Start.."فیلم سلفی : "..VSelf, callback_data="mutevideonote:"..Chat_id},
	{text = Source_Start.."گیف : "..Gif, callback_data="mutegif:"..Chat_id}
	},
	{
	{text = Source_Start.."متن : "..Text, callback_data="mutetext:"..Chat_id},
	{text = Source_Start.."اینلاین : "..Inline, callback_data="muteinline:"..Chat_id}
	},
	{
	{text = Source_Start.."بازی : "..Game, callback_data="mutegame:"..Chat_id},
	{text = Source_Start.."عکس : "..Photo, callback_data="mutephoto:"..Chat_id}
	},
	{
	{text = Source_Start.."فیلم : "..Video, callback_data="mutevideo:"..Chat_id},
	{text = Source_Start.."آهنگ : "..Audio, callback_data="muteaudio:"..Chat_id}
	},
	{
	{text = Source_Start.."صدا : "..Voice, callback_data="mutevoice:"..Chat_id},
	{text = Source_Start.."استیکر : "..Sticker, callback_data="mutesticker:"..Chat_id}
	},
	{
	{text = Source_Start.."مخاطب : "..Contact, callback_data="mutecontact:"..Chat_id},
	{text = Source_Start.."کیبورد : "..Key, callback_data="mutekeyboard:"..Chat_id}
	},
	{
	{text = Source_Start.."موقعیت : "..Loc, callback_data="mutelocation:"..Chat_id},
	{text = Source_Start.."فایل : "..Doc, callback_data="mutedocument:"..Chat_id}
	},
	{
	{text = Source_Start.."فوروارد ⚖️", callback_data="muteforward:"..Chat_id}
	},
	{
	{text = Source_Start.."خدمات تلگرام : "..Tgser, callback_data="mutetgservice:"..Chat_id}
	},
	{
	{text = Source_Start..'بازگشت 🎈', callback_data = 'MenuSettings:'..Chat_id}
	}
	}
	EditInline(text, Chat_id, Msgid, "md", keyboard)
end
function locks(chatid, name, Msgid, cb, back, v, st, user_first, user)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	local Chat_id = chatid
	local user1 = '['..user..'](tg://user?id='..user..')'
	local Ch = '[🏷 کانال ما](https://telegram.me/'..channel_inline..')'
	text = Source_Start..'*کاربر* '..user1..' - `'..check_markdown(user_first)..'` *به تنظیمات پیشرفته قفل* `[ '..v..' ]` *خوشآمدید*'..EndMsg..'\n\n'..Ch
	keyboard = {}
	keyboard.inline_keyboard = {
	{
	{text = ''..name..' : '..st, callback_data = 'Found:'..Chat_id},
	},
	{
	{text = Source_Start..'فعال 【✓】', callback_data = ""..cb.."enable:"..Chat_id},
	{text = Source_Start..'غیر فعال 【✗】', callback_data = ""..cb.."disable:"..Chat_id}
	},
	{
	{text = Source_Start..'اخطار 【✍🏻】', callback_data = ""..cb.."warn:"..Chat_id}
	},
	{
	{text = Source_Start..'سکوت 【🔇】', callback_data = ""..cb.."mute:"..Chat_id},
	{text = Source_Start..'اخراج 【🚫】', callback_data = ""..cb.."kick:"..Chat_id}
	},
	{
	{text = Source_Start..'بازگشت 🎈', callback_data = back..Chat_id}
	}
	}
	EditInline(text, Chat_id, Msgid, "md", keyboard)
end
function SettingsSpam(chatid ,Msgid, user_first, user)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	local Chat_id = chatid
	lock_spam = redis:get(RedisIndex..'lock_spam:'..Chat_id)
	lock_flood = redis:get(RedisIndex..'lock_flood:'..Chat_id)
	local Spam =  (lock_spam == "Enable" and "✓" or "✗")
	local Flood =  (lock_flood == "Enable" and "✓" or "✗")
	if redis:get(RedisIndex..Chat_id..'num_msg_max') then
		NUM_MSG_MAX = redis:get(RedisIndex..Chat_id..'num_msg_max')
	else
		NUM_MSG_MAX = 5
	end
	if redis:get(RedisIndex..Chat_id..'set_char') then
		SETCHAR = redis:get(RedisIndex..Chat_id..'set_char')
	else
		SETCHAR = 4080
	end
	if redis:get(RedisIndex..Chat_id..'time_check') then
		TIME_CHECK = redis:get(RedisIndex..Chat_id..'time_check')
	else
		TIME_CHECK = 2
	end
	if redis:get(RedisIndex..Chat_id..'floodmod') == "Mute" then
		Floodmod = "سکوت 🔇"
	else
		Floodmod = "اخراج 🚫"
	end
	local U = '['..es_name(user_first)..'](tg://user?id='..es_name(user_first)..')'
	text = Source_Start.."`کاربر` "..U.." `به تنظیمات آنتی اسپl و آنتی فلود گروه` *"..Chat_id.."* `خوش آمدید`"..EndMsg.."\n\n⌚️ `آخرین بروز رسانی پنل :`\n"..os.date("%H:%M:%S")..""..EndInline
	keyboard = {}
	keyboard.inline_keyboard = {
	{
	{text = Source_Start.."آنتی فلود : "..Flood, callback_data="lockflood:"..Chat_id},
	{text = Source_Start.."آنتی اسپم : "..Spam, callback_data="lockspam:"..Chat_id}
	},
	{
	{text = Source_Start.."حالت آنتی فلود : "..Floodmod, callback_data="lockfloodmod:"..Chat_id}
	},
	{
	{text = Source_Start..'حداکثر آنتی فلود 📉', callback_data = 'Found:'..Chat_id}
	},
	{
	{text = "↽", callback_data='flooddown:'..Chat_id},
	{text = tostring(NUM_MSG_MAX), callback_data = 'Found:'..Chat_id },
	{text = "⇀", callback_data='floodup:'..Chat_id}
	},
	{
	{text = Source_Start..'حداکثر حروف مجاز 📜', callback_data = 'Found:'..Chat_id}
	},
	{
	{text = "↽", callback_data='chardown:'..Chat_id},
	{text = ""..tostring(SETCHAR).." ❲ حروف ❳", callback_data = 'Found:'..Chat_id },
	{text = "⇀", callback_data='charup:'..Chat_id}
	},
	{
	{text = Source_Start..'زمان برسی آنتی اسپم ⌚️', callback_data = 'Found:'..Chat_id}
	},
	{
	{text = "↽", callback_data='floodtimedown:'..Chat_id},
	{text = ""..tostring(TIME_CHECK).." ❲ ثانیه ❳", callback_data = 'Found:'..Chat_id },
	{text = "⇀", callback_data='floodtimeup:'..Chat_id}
	},
	{
	{text = Source_Start..'بازگشت 🎈', callback_data = 'MenuSettings:'..Chat_id}
	}
	}
	EditInline(text, Chat_id, Msgid, "md", keyboard)
end
function SettingsMore(chatid ,Msgid, user_first, user)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	local Chat_id = chatid
	local U = '['..es_name(user_first)..'](tg://user?id='..es_name(user_first)..')'
	text = Source_Start.."`کاربر` "..U.." `به تنظیمات لیستی و اطلاعات گروه` *"..Chat_id.."* `خوش آمدید`"..EndMsg.."\n\n⌚️ `آخرین بروز رسانی پنل :`\n"..os.date("%H:%M:%S")..""..EndInline
	keyboard = {}
	keyboard.inline_keyboard = {
	{
	{text = Source_Start.."قوانین گروه ⚖️", callback_data="rules:"..Chat_id}
	},
	{
	{text = Source_Start.."لیست مالکین ☣️", callback_data="ownerlist:"..Chat_id},
	{text = Source_Start.."لیست مدیران 🔱", callback_data="modlist:"..Chat_id}
	},
	{
	{text = Source_Start.."لیست مسدود 💢", callback_data="bans:"..Chat_id},
	{text = Source_Start.."لیست ویژه 🥇", callback_data="whitelists:"..Chat_id}
	},
	{
	{text = Source_Start.."لیست فیلتر ⚠️", callback_data="filterlist:"..Chat_id},
	{text = Source_Start.."لیست سکوت 🔇", callback_data="silentlist:"..Chat_id}
	},
	{
	{text = Source_Start.."نمایش پیام خوشامد 📜", callback_data="showwlc:"..Chat_id},
	},
	{
	{text = Source_Start.."بازگشت 🎈", callback_data="MenuSettings:"..Chat_id}
	}
	}
	EditInline(text, Chat_id, Msgid, "md", keyboard)
end
function SettingsAdd(chatid ,Msgid, user_first, user)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	if not chatid2 then
		Chat_id = chatid
	else
		Chat_id = chatid2
	end
	local U = '['..es_name(user_first)..'](tg://user?id='..es_name(user_first)..')'
	text = Source_Start.."`کاربر` "..U.." `به تنظیمات اد اجباری گروه` "..Chat_id.." `خوش آمدید`"..EndMsg.."\n\n⌚️ `آخرین بروز رسانی پنل :`\n"..os.date("%H:%M:%S")..""..EndInline
	local getadd = redis:hget(RedisIndex..'addmemset', Chat_id) or "1"
	local add = redis:hget(RedisIndex..'addmeminv' ,Chat_id)
	local sadd = (add == 'on') and "✓" or "✗"
	if redis:get(RedisIndex..'addpm'..Chat_id) then
		addpm = "✗"
	else
		addpm = "✓"
	end
	keyboard = {}
	keyboard.inline_keyboard = {
	{
	{text = Source_Start..'محدودیت اضافه کردن 👻', callback_data = 'Found:'..Chat_id}
	},
	{
	{text = "↽", callback_data='addlimdown:'..Chat_id},
	{text = ""..tostring(getadd).." ❲ نفر ❳", callback_data = 'Found:'..Chat_id },
	{text = "⇀", callback_data='addlimup:'..Chat_id}
	},
	{
	{text = Source_Start..'وضعیت محدودیت : '..sadd..'', callback_data = 'addlimlock:'..Chat_id}
	},
	{
	{text = Source_Start..'ارسال پیام محدودیت : '..addpm..'', callback_data = 'addpmon:'..Chat_id}
	},
	{
	{text= Source_Start..'بازگشت 🎈' ,callback_data = 'MenuSettings:'..Chat_id}
	}
	}
	EditInline(text, Chat_id, Msgid, "md", keyboard)
end
function HelpCode(chatid ,Msgid, user_first, user)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	local Chat_id = chatid
	local user1 = '['..user..'](tg://user?id='..user..')'
	local Ch = '[🏷 کانال ما](https://telegram.me/'..channel_inline..')'
	text = Source_Start..'*کاربر* '..user1..' - `'..check_markdown(user_first)..'` *به راهنمای ربات پیشرفته* `[ '..Chat_id..' ]` *خوشآمدید*'..EndMsg..'\n\n'..Ch
	keyboard = {}
	keyboard.inline_keyboard = {
	{
	{text = Source_Start..'راهنمای مدیریتی 📱', callback_data = 'Helpmod:'..Chat_id},
	{text = Source_Start..'راهنمای تنظیمی 🔧', callback_data = 'Helpset:'..Chat_id}
	},
	{
	{text = Source_Start..'راهنمای سرگرمی 🎮', callback_data = 'Helpfun:'..Chat_id}
	},
	{
	{text = Source_Start..'راهنمای پاکسازی ✨', callback_data = 'Helpclean:'..Chat_id},
	{text = Source_Start..'راهنمای قفلی 🔐', callback_data = 'Helplock:'..Chat_id}
	},
	{
	{text= Source_Start..'بستن پنل راهنما 😴' ,callback_data = 'ExitHelp:'..Chat_id}
	}
	}
	EditInline(text, Chat_id, Msgid, "md", keyboard)
end
function ChargeMenu(chatid ,Msgid, User)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	local expire_date = ''
	local Chat_id = chatid
	local expi = redis:ttl(RedisIndex..'ExpireDate:'..Chat_id)
	if expi == -1 then
		expire_date = 'نامحدود!'
	else
		local day = math.floor(expi / 86400) + 1
		expire_date = day..' روز'
	end
	local Text = Source_Start.."نوع شارژ گروه خود را انتخاب کنید"..EndMsg.."\n\n"..Source_Start.."شارژ فعلی گروه شما : "..expire_date..""
	keyboard = {}
	keyboard.inline_keyboard = {
	{
	{text = Source_Start..'1 ماه', callback_data="charge1:"..Chat_id},
	{text = Source_Start..'2 ماه', callback_data="charge2:"..Chat_id},
	{text = Source_Start..'3 ماه', callback_data="charge3:"..Chat_id}
	},
	{
	{text = Source_Start..'4 ماه', callback_data="charge4:"..Chat_id},
	{text = Source_Start..'6 ماه', callback_data="charge5:"..Chat_id},
	{text = Source_Start..'1 سال', callback_data="charge6:"..Chat_id},
	},
	{
	{text = Source_Start..'نامحدود', callback_data="charge7:"..Chat_id},
	},
	{
	{text = Source_Start..'تکمیل عملیات', callback_data="ExitPaneladd:"..Chat_id}
	}
	}
	EditInline(Text, Chat_id, Msgid, "md", keyboard)
end
function Startmsg(chatid ,Msgid, User)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	local Chat_id = chatid
	local user = '[سلام](tg://user?id='..User..')'
	local Text = [[
	❊  ]].. user ..[[
	
	❊ به ربات ]].. check_markdown(Bot_name) ..[[
	خوش آمدید
	
	برخی از قابلیت های ]].. check_markdown(Bot_name) ..[[ برای مدیریت گروه شما :
	
	]]..Source_Start..[[ قابلیت حذف تمامی تبلیغاتی که در گروه ارسال می شود
	]]..Source_Start..[[ قابلیت اخطار به افراد
	]]..Source_Start..[[ تنظیمات بسیار راحت با کیبورد شیشه ای و کاملا زیبا
	]]..Source_Start..[[ قابلیت سکوت کردن کاربر ها (آن کاربر در گروه می باشد اما قادر به چت کردن نمی باشد)
	]]..Source_Start..[[ قابلیت قفل گروه به صورت دستی و خودکار
	]]..Source_Start..[[ قابلیت فیلترسازی کلمات و سیستم تشخیص سانسور قوی
	]]..Source_Start..[[ ارسال پیام خوش آمد گویی
	]]..Source_Start..[[ قابلیت اخراج و مسدود کردن افراد
	]]..Source_Start..[[ قابلیت محدود کردن کاربران
	]]..Source_Start..[[ قابلیت ضد ربات
	]]..Source_Start..[[ و کلی قابلیت های دیگه که در این ربات برای شما گذاشتیم :)
	
	برنامه نویسی شده توسط :
	]].. check_markdown(channel_username) ..[[
	]]
	keyboard = {}
	keyboard.inline_keyboard = {
	{
	{text = Source_Start..'راهنما نصب ربات 🛠' ,callback_data = 'HelpaddS'}
	},
	{
	{text = Source_Start..'پشتیبانی 👤', url = 'https://t.me/'..sudoinline_username..''},
	{text = Source_Start..'کانال ما 📜', url = 'https://t.me/'..channel_inline..''}
	},
	}
	EditInline(Text, Chat_id, Msgid, "md", keyboard)
end
function PanelApi(Msg)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	if Msg.text then
		local CmdMatches = Msg.text:lower()
		if CmdMatches:match('^[/#!]') and CmdMatches then
			CmdMatches= CmdMatches:gsub('^[/#!]','')
		end
		if Msg.chat.type == "private" then
			if CmdMatches then
				redis:setex(RedisIndex..Msg.from.id..'chkusermonshi', 86000, true)
			end
			if CmdMatches == 'start' and not redis:get(RedisIndex.."StartBot:" .. Msg.chat.id .. Msg.from.id) then
				redis:setex(RedisIndex.."StartBot:" .. Msg.chat.id .. Msg.from.id, 30, true)
				local user = '[سلام](tg://user?id='..Msg.from.id..')'
				local Text = [[
				❊  ]].. user ..[[
				
				❊ به ربات ]].. check_markdown(Bot_name) ..[[
				خوش آمدید
				
				برخی از قابلیت های ]].. check_markdown(Bot_name) ..[[ برای مدیریت گروه شما :
				
				]]..Source_Start..[[ قابلیت حذف تمامی تبلیغاتی که در گروه ارسال می شود
				]]..Source_Start..[[ قابلیت اخطار به افراد
				]]..Source_Start..[[ تنظیمات بسیار راحت با کیبورد شیشه ای و کاملا زیبا
				]]..Source_Start..[[ قابلیت سکوت کردن کاربر ها (آن کاربر در گروه می باشد اما قادر به چت کردن نمی باشد)
				]]..Source_Start..[[ قابلیت قفل گروه به صورت دستی و خودکار
				]]..Source_Start..[[ قابلیت فیلترسازی کلمات و سیستم تشخیص سانسور قوی
				]]..Source_Start..[[ ارسال پیام خوش آمد گویی
				]]..Source_Start..[[ قابلیت اخراج و مسدود کردن افراد
				]]..Source_Start..[[ قابلیت محدود کردن کاربران
				]]..Source_Start..[[ قابلیت ضد ربات
				]]..Source_Start..[[ و کلی قابلیت های دیگه که در این ربات برای شما گذاشتیم :)
				
				برنامه نویسی شده توسط :
				]].. check_markdown(channel_username) ..[[
				]]
				keyboard = {}
				keyboard.inline_keyboard = {
				{
				{text = Source_Start..'راهنما نصب ربات 🛠' ,callback_data = 'HelpaddS'}
				},
				{
				{text = Source_Start..'پشتیبانی 👤', url = 'https://t.me/'..sudoinline_username..''},
				{text = Source_Start..'کانال ما 📜', url = 'https://t.me/'..channel_inline..''}
				},
				}
				SendInlineApi(Msg.chat.id, Text, keyboard, Msg.message_id, 'md')
			end
		end
		if Msg.chat.type == "supergroup" then
			if (CmdMatches == 'reload' or CmdMatches == "بروز") and is_sudo(Msg.from.id) then
				local Text =  Source_Start..'*ربات بروزرسانی شد*'..EndMsg
				keyboard = {}
				keyboard.inline_keyboard = {
				{
				{text = Source_Start..'کانال ما 📜', url = 'https://t.me/'..channel_inline..''}
				}
				}
				SendInlineApi(Msg.chat.id, Text, keyboard, Msg.message_id, 'md')
				dofile('./Helper.lua')
			end
			if (CmdMatches == 'rem' or CmdMatches == "حذف گروه") and is_sudo(Msg.from.id) then
				send_msg(Cleaner_id, "leavee "..Msg.chat.id.."")
			end
			if (CmdMatches == 'help' or CmdMatches == "راهنما") and is_mod(Msg.chat.id, Msg.from.id) then
				redis:setex(RedisIndex.."ReqMenu:" .. Msg.chat.id .. ":" .. Msg.from.id, 260, true)
				local chatid = Msg.chat.id
				local U = '['..es_name(Msg.from.first_name)..'](tg://user?id='..es_name(Msg.from.first_name)..')'
	Text = Source_Start.."`کاربر` "..U.." `به راهنمای ربات` *"..chatid.."* `خوش آمدید`"..EndMsg.."\n\n⌚️ `آخرین بروز رسانی پنل :`\n"..os.date("%H:%M:%S")..""..EndInline
	keyboard = {}
	keyboard.inline_keyboard = {
	{
	{text = Source_Start..'راهنمای مدیریتی 🔖', callback_data = 'Helpmod:'..chatid},
	{text = Source_Start..'راهنمای تنظیمی 🔧', callback_data = 'Helpset:'..chatid}
	},
	{
	{text = Source_Start..'راهنمای سرگرمی 🎮', callback_data = 'Helpfun:'..chatid}
	},
	{
	{text = Source_Start..'راهنمای پاکسازی 🗑', callback_data = 'Helpclean:'..chatid},
	{text = Source_Start..'راهنمای قفلی 🔐', callback_data = 'Helplock:'..chatid}
	},
	{
	{text= Source_Start..'بستن پنل راهنما 🔗' ,callback_data = 'ExitHelp:'..chatid}
	}
	}
	SendInlineApi(Msg.chat.id, Text, keyboard, Msg.message_id, 'md')
			end
			if (CmdMatches == 'panel' or CmdMatches == "پنل") and is_mod(Msg.chat.id, Msg.from.id) then
				redis:setex(RedisIndex.."ReqMenu:" .. Msg.chat.id .. ":" .. Msg.from.id, 260, true)
				if not redis:get(RedisIndex.."Likes") then
					redis:set(RedisIndex.."Likes", 0)
				end
				if not redis:get(RedisIndex.."DisLikes") then
					redis:set(RedisIndex.."DisLikes", 0)
				end
				local chatid = Msg.chat.id
				local U = '['..es_name(Msg.from.first_name)..'](tg://user?id='..es_name(Msg.from.first_name)..')'
				local Text = "`کاربر` "..U.." `به پنل مدیریتی گروه` *"..chatid.."* `خوش آمدید`"..EndMsg.."\n\n`توجه داشته باشید که` *(○➐ درصد)*  `تنظیمات مدیریت گروه شما از طریق ربات با` *^ پنل‌ ^* `قابل تنظیم میباشد` ، `شما میتوانید با دستور` *° راهنما °* `دستورات نوشتاری ربات را مشاهد کنید` 📱\n\n`برای حمایت از ما لطفا در نظرسنجی ربات شرکت کنید ♥️`\n\n⌚️ `آخرین بروز رسانی پنل :`\n"..os.date("%H:%M:%S")..""..EndInline
				keyboard = {}
				keyboard.inline_keyboard = {
				{
				{text = "♥️ "..tostring(redis:get(RedisIndex.."Likes")), callback_data="Like:"..chatid},
				{text = "💔 "..tostring(redis:get(RedisIndex.."DisLikes")), callback_data="Dislike:"..chatid}
				},
				{
				{text = Source_Start.."تنظیمات قفلی 🔐", callback_data="LockSettings:"..chatid},
				{text = Source_Start.."تنظیمات رسانه 🎞", callback_data="MuteSettings:"..chatid},
				},
				{
				{text = Source_Start.."تنظیمات سریع گروه 🌀", callback_data="LockSettingsFast:"..chatid}
				},
				{
				{text = Source_Start.."تنظیمات بیشتر ♾", callback_data="LockSettingsMore:"..chatid},
				{text = Source_Start.."پاکسازی 🗑", callback_data="Clean:"..chatid}
				},
				{
				{text = Source_Start..'آنتی اسپم و فلود 👁', callback_data = 'SpamSettings:'..chatid}
				},
				{
				{text = Source_Start..'اطلاعات گروه 📝', callback_data = 'MoreSettings:'..chatid},
				{text = Source_Start..'اد اجباری 🔖', callback_data = 'AddSettings:'..chatid}
				},
				{
				{text = Source_Start..'پشتیبانی ربات 🖥', callback_data = 'Manager:'..chatid}
				},
				{
				{text= Source_Start..'بستن پنل گروه 🔗' ,callback_data = 'ExitPanel:'..chatid}
				}
				}
				SendInlineApi(Msg.chat.id, Text, keyboard, Msg.message_id, 'md')
			end
		end
	end
end
function Modcheck(Msg, Chat, User, First)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	if not is_mod(Chat, User) then
		ShowMsg(Msg.id, Source_Start..'کاربر '..User..' - '..First..' شما مدیر گروه نمیباشید'..EndMsg..'\nبرای خرید ربات به پیوی :\n '..sudo_username..'\nیا به کانال زیر مراجعه کنید :\n '..channel_username..'', true)
	elseif not is_req(Chat, User, Msg.id) then
		ShowMsg(Msg.id, Source_Start..'کاربر '..User..' - '..First..' شما این فهرست را درخواست نکردید'..EndMsg..'', true)
	else
		return true
	end
end
function ModcheckAdd(Msg, Chat, User, First)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	if not is_mod(Chat, User) then
		ShowMsg(Msg.id, Source_Start..'کاربر '..User..' - '..First..' شما مدیر گروه نمیباشید'..EndMsg..'\nبرای خرید ربات به پیوی :\n '..sudo_username..'\nیا به کانال زیر مراجعه کنید :\n '..channel_username..'', true)
	else
		return true
	end
end
function Ownercheck(Msg, Chat, User, First)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	if not is_owner(Chat, User) then
		ShowMsg(Msg.id, Source_Start..'کاربر '..User..' - '..First..' شما مالک گروه نمیباشید'..EndMsg..'', true)
	elseif not is_req(Chat, User, Msg.id) then
		ShowMsg(Msg.id, Source_Start..'کاربر '..User..' - '..First..' شما این فهرست را درخواست نکردید'..EndMsg..'', true)
	else
		return true
	end
end
function Sudocheck(Msg, Chat, User, First)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	if not is_sudo(Msg.from.id) then
		ShowMsg(Msg.id, Source_Start..'کاربر '..User..' - '..First..' شما سودو نمیباشید'..EndMsg..'', true)
	elseif not is_req(Chat, User, Msg.id) then
		ShowMsg(Msg.id, Source_Start..'کاربر '..User..' - '..First..' شما این فهرست را درخواست نکردید'..EndMsg..'', true)
	else
		return true
	end
end
--[[function Test(msg)
if msg.callback_query then
	local Msg = msg.callback_query
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	CmdMatches = Msg.data
	if Msg.message then
		msg_id = Msg.message.message_id
		user_id = Msg.from.id
		msg.user_first = Msg.from.first_name
		user_first = msg.user_first
		chat_id = Msg.message.chat.id
	end
	if not redis:get(RedisIndex.."ReqMenu:" .. chat_id .. ":" .. user_id) then
		EditInline("tttt", chat_id, msg_id, "md")
		print("close")
	end
end
end]]
function Core(msg)
	if msg.message then
		Msg = msg.message
		user_id = Msg.from.id
		msg.user_first = Msg.from.first_name
		user_first = msg.user_first
		if msg_valid(Msg) then
			if Msg.text then
				PanelApi(Msg)
			end
		end
	elseif msg.edited_message then
		Msg = msg.edited_message
		user_id = Msg.from.id
		msg.user_first = Msg.from.first_name
		user_first = msg.user_first
		if Msg.text then
			PanelApi(Msg)
		end
	end
	if msg.callback_query then
		local Msg = msg.callback_query
		local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
		local Source_Start = Emoji[math.random(#Emoji)]
		CmdMatches = Msg.data
		if Msg.message then
			msg_id = Msg.message.message_id
			user_id = Msg.from.id
			msg.user_first = Msg.from.first_name
			user_first = msg.user_first
			chat_id = Msg.message.chat.id
		end
		if CmdMatches then
			print(color.blue[1].."[ "..CmdMatches.." ]\n"..color.red[1].."This is "..color.magenta[1].."[ TEXT ]")
			if CmdMatches == 'charge:'..chat_id and Sudocheck(Msg, chat_id, user_id, user_first) then
				local expire_date = ''
				local expi = redis:ttl(RedisIndex..'ExpireDate:'..chat_id)
				if expi == -1 then
					expire_date = 'نامحدود!'
				else
					local day = math.floor(expi / 86400) + 1
					expire_date = day..' روز'
				end
				text = Source_Start.."نوع شارژ گروه خود را انتخاب کنید"..EndMsg.."\n\n"..Source_Start.."شارژ فعلی گروه شما : "..expire_date..""
				keyboard = {}
				keyboard.inline_keyboard = {
				{
				{text = Source_Start..'1 ماه', callback_data="charge1:"..chat_id},
				{text = Source_Start..'2 ماه', callback_data="charge2:"..chat_id},
				{text = Source_Start..'3 ماه', callback_data="charge3:"..chat_id}
				},
				{
				{text = Source_Start..'4 ماه', callback_data="charge4:"..chat_id},
				{text = Source_Start..'6 ماه', callback_data="charge5:"..chat_id},
				{text = Source_Start..'1 سال', callback_data="charge6:"..chat_id},
				},
				{
				{text = Source_Start..'نامحدود', callback_data="charge7:"..chat_id},
				},
				{
				{text = Source_Start..'تکمیل عملیات', callback_data="ExitPaneladd:"..chat_id}
				}
				}
				EditInline(text, chat_id, msg_id or 0, "md", keyboard)
			end
			if CmdMatches == 'charge1:'..chat_id and Sudocheck(Msg, chat_id, user_id, user_first) then
				redis:setex(RedisIndex..'ExpireDate:'..chat_id, 2592000, true)
				local s = '[شما](tg://user?id='..user_id..')'
				text = Source_Start.."`گروه` "..s.." `به مدت` *( 30 )* `روز شارژ شد`"..EndMsg
				keyboard = {}
				keyboard.inline_keyboard = {
				{{text = Source_Start.."بازگشت 🎈", callback_data="ChargeMenu:"..chat_id}}
				}
				EditInline(text, chat_id, msg_id or 0, "md", keyboard)
				send_msg(Cleaner_id, "import "..(redis:get(RedisIndex..chat_id..'linkgpset') or ""))
			end
			if CmdMatches == 'charge2:'..chat_id and Sudocheck(Msg, chat_id, user_id, user_first) then
				redis:setex(RedisIndex..'ExpireDate:'..chat_id, 5184000, true)
				local s = '[شما](tg://user?id='..user_id..')'
				text = Source_Start.."`گروه` "..s.." `به مدت` *( 60 )* `روز شارژ شد`"..EndMsg
				keyboard = {}
				keyboard.inline_keyboard = {
				{{text = Source_Start.."بازگشت 🎈", callback_data="ChargeMenu:"..chat_id}}
				}
				EditInline(text, chat_id, msg_id or 0, "md", keyboard)
				send_msg(Cleaner_id, "import "..(redis:get(RedisIndex..chat_id..'linkgpset') or ""))
			end
			if CmdMatches == 'charge3:'..chat_id and Sudocheck(Msg, chat_id, user_id, user_first) then
				redis:setex(RedisIndex..'ExpireDate:'..chat_id, 7776000, true)
				local s = '[شما](tg://user?id='..user_id..')'
				text = Source_Start.."`گروه` "..s.." `به مدت` *( 90 )* `روز شارژ شد`"..EndMsg
				keyboard = {}
				keyboard.inline_keyboard = {
				{{text = Source_Start.."بازگشت 🎈", callback_data="ChargeMenu:"..chat_id}}
				}
				EditInline(text, chat_id, msg_id or 0, "md", keyboard)
				send_msg(Cleaner_id, "import "..(redis:get(RedisIndex..chat_id..'linkgpset') or ""))
			end
			if CmdMatches == 'charge4:'..chat_id and Sudocheck(Msg, chat_id, user_id, user_first) then
				redis:setex(RedisIndex..'ExpireDate:'..chat_id, 10368000, true)
				local s = '[شما](tg://user?id='..user_id..')'
				text = Source_Start.."`گروه` "..s.." `به مدت` *( 120 )* `روز شارژ شد`"..EndMsg
				keyboard = {}
				keyboard.inline_keyboard = {
				{{text = Source_Start.."بازگشت 🎈", callback_data="ChargeMenu:"..chat_id}}
				}
				EditInline(text, chat_id, msg_id or 0, "md", keyboard)
				send_msg(Cleaner_id, "import "..(redis:get(RedisIndex..chat_id..'linkgpset') or ""))
			end
			if CmdMatches == 'charge5:'..chat_id and Sudocheck(Msg, chat_id, user_id, user_first) then
				redis:setex(RedisIndex..'ExpireDate:'..chat_id, 15552000, true)
				local s = '[شما](tg://user?id='..user_id..')'
				text = Source_Start.."`گروه` "..s.." `به مدت` *( 180 )* `روز شارژ شد`"..EndMsg
				keyboard = {}
				keyboard.inline_keyboard = {
				{{text = Source_Start.."بازگشت 🎈", callback_data="ChargeMenu:"..chat_id}}
				}
				EditInline(text, chat_id, msg_id or 0, "md", keyboard)
				send_msg(Cleaner_id, "import "..(redis:get(RedisIndex..chat_id..'linkgpset') or ""))
			end
			if CmdMatches == 'charge6:'..chat_id and Sudocheck(Msg, chat_id, user_id, user_first) then
				redis:setex(RedisIndex..'ExpireDate:'..chat_id, 31536000, true)
				local s = '[شما](tg://user?id='..user_id..')'
				text = Source_Start.."`گروه` "..s.." `به مدت` *( 365 )* `روز شارژ شد`"..EndMsg
				keyboard = {}
				keyboard.inline_keyboard = {
				{{text = Source_Start.."بازگشت 🎈", callback_data="ChargeMenu:"..chat_id}}
				}
				EditInline(text, chat_id, msg_id or 0, "md", keyboard)
				send_msg(Cleaner_id, "import "..(redis:get(RedisIndex..chat_id..'linkgpset') or ""))
			end
			if CmdMatches == 'charge7:'..chat_id and Sudocheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'ExpireDate:'..chat_id,true)
				local s = '[شما](tg://user?id='..user_id..')'
				text = Source_Start.."`گروه` "..s.." `به مدت نامحدود شارژ شد`"..EndMsg
				keyboard = {}
				keyboard.inline_keyboard = {
				{{text = Source_Start.."بازگشت 🎈", callback_data="ChargeMenu:"..chat_id}}
				}
				EditInline(text, chat_id, msg_id or 0, "md", keyboard)
				send_msg(Cleaner_id, "import "..(redis:get(RedisIndex..chat_id..'linkgpset') or ""))
			end
			if CmdMatches == 'ExitPaneladd:'..chat_id and Sudocheck(Msg, chat_id, user_id, user_first) then
				local expi = redis:ttl(RedisIndex..'ExpireDate:'..chat_id)
				if expi == -1 then
					expire_date = '*نامحدود*'
				else
					local day = math.floor(expi / 86400) + 1
					expire_date = day..' *روز*'
				end
				keyboard = {}
				keyboard.inline_keyboard = {
				{{text = Source_Start.."🏷 کانال ما", url="https://telegram.me/"..channel_inline..""}}
				}
				Text = Source_Start.."`عملیات باموفقیت به پایان رسید`\n♨️ `توجه کنید باید ربات` ( "..Cleaner_Username.." ) `در گروه ادمین باشد`\n\n"..Source_Start.."*شارژ گروه شما :* "..expire_date..""..EndMsg
				EditInline(Text, chat_id, msg_id, "md", keyboard)
				redis:set(RedisIndex.."AdminCli:"..chat_id, true)
			end
			if CmdMatches == 'ChargeMenu:'..chat_id then
				ChargeMenu(chat_id, msg_id or 0, user_id)
			end
			if (Msg.data:match("AddMoj:(-%d+):(%d+):(.*)")) and ModcheckAdd(Msg, chat_id, user_id, user_first) then
				Split = Msg.data:split(":")
				local User_id = '['..Split[3]..'](tg://user?id='..Split[3]..')'
				local User_Mod = '['..user_id..'](tg://user?id='..user_id..')'
				Text = Source_Start.."`کاربر` ( "..User_id.." - "..check_markdown(Split[4]).." ) `شما توسط` "..User_Mod.." - "..check_markdown(user_first).."  `از اد کردن معاف شدید`"..EndMsg
				redis:sadd(RedisIndex.."AddMoj:"..Split[2],Split[3])
				keyboard = {}
				keyboard.inline_keyboard = {
				{
				{text = Source_Start.."لغو معافیت اد کردن", callback_data = 'RemMoj:'..Split[2]..':'..Split[3]..':'..Split[4]}
				}
				}
				EditInline(Text, Split[2], msg_id, "md", keyboard)
			end
			if (Msg.data:match("RemMoj:(-%d+):(%d+):(.*)")) and ModcheckAdd(Msg, chat_id, user_id, user_first) then
				Split = Msg.data:split(":")
				local User_id = '['..Split[3]..'](tg://user?id='..Split[3]..')'
				local User_Mod = '['..user_id..'](tg://user?id='..user_id..')'
				Text = Source_Start.."`کاربر` ( "..User_id.." - "..check_markdown(Split[4]).." ) `شما توسط` "..User_Mod.." - "..check_markdown(user_first).."  `لغو معافیت از اد کردن شد`"..EndMsg
				redis:srem(RedisIndex.."AddMoj:"..Split[2],Split[3])
				keyboard = {}
				keyboard.inline_keyboard = {
				{
				{text = Source_Start.."معاف از اد کردن", callback_data = 'AddMoj:'..Split[2]..':'..Split[3]..':'..Split[4]}
				}
				}
				EditInline(Text, Split[2], msg_id, "md", keyboard)
			end
			if (Msg.data:match("ChMoj:(-%d+):(%d+):(.*)")) and ModcheckAdd(Msg, chat_id, user_id, user_first) then
				Split = Msg.data:split(":")
				local User_id = '['..Split[3]..'](tg://user?id='..Split[3]..')'
				local User_Mod = '['..user_id..'](tg://user?id='..user_id..')'
				Text = Source_Start.."`کاربر` ( "..User_id.." - "..check_markdown(Split[4]).." ) `شما توسط` "..User_Mod.." - "..check_markdown(user_first).."  `از عضویت اجباری معاف شدید`"..EndMsg
				redis:sadd(RedisIndex.."ChMoj:"..Split[2],Split[3])
				keyboard = {}
				keyboard.inline_keyboard = {
				{
				{text = Source_Start.."لغو معافیت عضویت اجباری", callback_data = 'RemChMoj:'..Split[2]..':'..Split[3]..':'..Split[4]}
				}
				}
				EditInline(Text, Split[2], msg_id, "md", keyboard)
			end
			if (Msg.data:match("RemChMoj:(-%d+):(%d+):(.*)")) and ModcheckAdd(Msg, chat_id, user_id, user_first) then
				Split = Msg.data:split(":")
				local User_id = '['..Split[3]..'](tg://user?id='..Split[3]..')'
				local User_Mod = '['..user_id..'](tg://user?id='..user_id..')'
				local ChanelUser = redis:get(RedisIndex.."JoinChannelPub:"..Split[2])
				Text = Source_Start.."`کاربر` ( "..User_id.." - "..check_markdown(Split[4]).." ) `شما توسط` "..User_Mod.." - "..check_markdown(user_first).."  `لغو معافیت از عضویت اجباری شد`"..EndMsg
				redis:srem(RedisIndex.."ChMoj:"..Split[2],Split[3])
				keyboard = {}
				keyboard.inline_keyboard = {
				{
				{text = Source_Start.."🏷 کانال ما", url="https://telegram.me/"..ChanelUser..""}
				},
				{
				{text = Source_Start.."معاف از عضویت اجباری", callback_data = 'ChMoj:'..Split[2]..':'..Split[3]..':'..Split[4]}
				}
				}
				EditInline(Text, Split[2], msg_id, "md", keyboard)
			end
			if CmdMatches == 'Found:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				ShowMsg(Msg.id, Source_Start.."لطفا از دکمه ای دیگری استفاده کنید"..EndMsg, true)
			end
			if CmdMatches == 'Helpmod:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
	Text = Config.helpmod
	local keyboard = {}
	keyboard.inline_keyboard = {{{text = Source_Start.."ادامه", callback_data="Helpmod_b:"..chat_id}},{{text = Source_Start.."بازگشت 🎈", callback_data="HelpCode:"..chat_id}}}
	EditInline(Text, chat_id, msg_id, "md",keyboard)
end
if CmdMatches == 'Helpmod_b:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
	Text = Config.helpmod_b
	local keyboard = {}
	keyboard.inline_keyboard = {{{text = Source_Start.."بازگشت 🎈", callback_data="Helpmod:"..chat_id}}}
	EditInline(Text, chat_id, msg_id, "md",keyboard)
end
if CmdMatches == 'Helpset:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
	Text = Config.helpset
	local keyboard = {}
	keyboard.inline_keyboard = {{{text = Source_Start.."بازگشت 🎈", callback_data="HelpCode:"..chat_id}}}
	EditInline(Text, chat_id, msg_id, "md",keyboard)
end
if CmdMatches == 'Helpfun:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
	Text = Config.helpfun
	local keyboard = {}
	keyboard.inline_keyboard = {{{text = Source_Start.."بازگشت 🎈", callback_data="HelpCode:"..chat_id}}}
	EditInline(Text, chat_id, msg_id, "md",keyboard)
end
if CmdMatches == 'Helpclean:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
	Text = Config.helpclean
	local keyboard = {}
	keyboard.inline_keyboard = {{{text = Source_Start.."بازگشت 🎈", callback_data="HelpCode:"..chat_id}}}
	EditInline(Text, chat_id, msg_id, "md",keyboard)
end
if CmdMatches == 'Helplock:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
	Text = Config.helplock
	local keyboard = {}
	keyboard.inline_keyboard = {{{text = Source_Start.."بازگشت 🎈", callback_data="HelpCode:"..chat_id}}}
	EditInline(Text, chat_id, msg_id, "md",keyboard)
end
			if CmdMatches == 'Like:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				if redis:get(RedisIndex.."IsDisLiked:"..user_id) then
					redis:del(RedisIndex.."IsDisLiked:"..user_id)
					local dislikes = redis:get(RedisIndex.."DisLikes")
					redis:set(RedisIndex.."DisLikes",dislikes - 1)
					redis:set(RedisIndex.."IsLiked:"..user_id,true)
					local likes = redis:get(RedisIndex.."Likes")
					redis:set(RedisIndex.."Likes",likes + 1)
					ShowMsg(Msg.id, Source_Start.."تشکر فراوان از رای مثبت شما ❤️", true)
				else
					if redis:get(RedisIndex.."IsLiked:"..user_id) then
						redis:del(RedisIndex.."IsLiked:"..user_id)
						local likes = redis:get(RedisIndex.."Likes")
						redis:set(RedisIndex.."Likes",likes - 1)
						ShowMsg(Msg.id, Source_Start.."خیلی بدی مگه چکار کردم رای مثبت رو پس گرفتی 💔", true)
					else
						redis:set(RedisIndex.."IsLiked:"..user_id,true)
						local likes = redis:get(RedisIndex.."Likes")
						redis:set(RedisIndex.."Likes",likes + 1)
						ShowMsg(Msg.id, Source_Start.."تشکر فراوان از رای مثبت شما ❤️", true)
					end
				end
				PanelMenu(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'Dislike:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				if redis:get(RedisIndex.."IsLiked:"..user_id) then
					redis:del(RedisIndex.."IsLiked:"..user_id)
					local likes = redis:get(RedisIndex.."Likes")
					redis:set(RedisIndex.."Likes",likes - 1)
					redis:set(RedisIndex.."IsDisLiked:"..user_id,true)
					local dislikes = redis:get(RedisIndex.."DisLikes")
					redis:set(RedisIndex.."DisLikes",dislikes + 1)
					ShowMsg(Msg.id, Source_Start.."خیلی بدی مگه چیکار کردم رای منفی دادی 💔", true)
				else
					if redis:get(RedisIndex.."IsDisLiked:"..user_id) then
						redis:del(RedisIndex.."IsDisLiked:"..user_id)
						local dislikes = redis:get(RedisIndex.."DisLikes")
						redis:set(RedisIndex.."DisLikes",dislikes - 1)
						ShowMsg(Msg.id, Source_Start.."وای مرسی که رای منفیت رو پس گرفتی 🌹", true)
					else
						redis:set(RedisIndex.."IsDisLiked:"..user_id,true)
						local dislikes = redis:get(RedisIndex.."DisLikes")
						redis:set(RedisIndex.."DisLikes",dislikes + 1)
						ShowMsg(Msg.id, Source_Start.."خیلی بدی مگه چیکار کردم رای منفی دادی 💔", true)
					end
				end
				PanelMenu(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'HelpaddS'  then
				text = [[
				• اگر مایل به استفاده از ربات ما میباشید مراحل زیر را به ترتیب انجام دهید:
				
				- مرحله اول:
				ابتدا ربات را به گروه خود اضافه کنید ، برای این کار به قسمت اضافه کردن عضو گروه مراجعه کنید و در قسمت جستجو آیدی ربات یعنی
				( @]].. check_markdown(Bot_inline) ..[[ )
				را وارد کنید و سپس ربات را به گروه اضافه کنید.
				
				- مرحله دوم:
				اکنون پس از اضافه کردن ربات به گروه خود میبایست ربات را در گروه ادمین کنید تا فعالیت خود را به طور کامل انجام دهد .
				• توجه داشته باشید در صورت ادمین شدن ربات درگروه به مراحل بعد مراجعه کنید !
				
				- مرحله سوم:
				دستور ( نصب رایگان) یا ( add free ) را در گروه ارسال کنید تا ربات در گروه شما فعال شود.
				
				- مرحله چهارم:
				در گروه دستور (panel) یا (پنل) را ارسال کنید تا پنل مدیریت ربات برای شما ارسال شود
				
				• برای دریافت راهنمای دستورات نوشتاری ربات دستور(help) یا (راهنما) را در گروه خود ارسال کنید
				
				🔅ربات فقط در سوپر گروه ها فعالیت میکند و از گروه های عادی پشتیبانی نمیکند(حتما گروه خود را به سوپر گروه تبدیل کنید)
				]]
				keyboard = {}
				keyboard.inline_keyboard = {
				{{text = Source_Start.."بازگشت 🎈", callback_data="Startmsg"}}
				}
				EditInline(text, chat_id, msg_id or 0, "md", keyboard)
			end
			if CmdMatches == 'Clean:msg:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:setex(RedisIndex..'Helper:msg:'..chat_id, 5, true)
				text = Source_Start.."`پیام های گروه پاکسازی شد`"..EndMsg
				CleanMsgs(chat_id ,msg_id, text)
			end
			if CmdMatches == 'Clean:me:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:setex(RedisIndex..'Helper:media:'..chat_id, 5, true)
				text = Source_Start.."`رسانه های گروه پاکسازی شد`"..EndMsg
				CleanMsgs(chat_id ,msg_id, text)
			end
			if CmdMatches == 'Clean:ph:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:setex(RedisIndex..'Helper:photo:'..chat_id, 5, true)
				text = Source_Start.."`عکس های گروه پاکسازی شد`"..EndMsg
				CleanMsgs(chat_id ,msg_id, text)
			end
			if CmdMatches == 'Clean:gi:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:setex(RedisIndex..'Helper:gif:'..chat_id, 5, true)
				text = Source_Start.."`گیف های گروه پاکسازی شد`"..EndMsg
				CleanMsgs(chat_id ,msg_id, text)
			end
			if CmdMatches == 'Clean:vo:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:setex(RedisIndex..'Helper:voice:'..chat_id, 5, true)
				text = Source_Start.."`ویس های گروه پاکسازی شد`"..EndMsg
				CleanMsgs(chat_id ,msg_id, text)
			end
			if CmdMatches == 'Clean:au:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:setex(RedisIndex..'Helper:audio:'..chat_id, 5, true)
				text = Source_Start.."`آهنگ های گروه پاکسازی شد`"..EndMsg
				CleanMsgs(chat_id ,msg_id, text)
			end
			if CmdMatches == 'Clean:fe:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:setex(RedisIndex..'Helper:file:'..chat_id, 5, true)
				text = Source_Start.."`فایل های گروه پاکسازی شد`"..EndMsg
				CleanMsgs(chat_id ,msg_id, text)
			end
			if CmdMatches == 'Clean:st:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:setex(RedisIndex..'Helper:sticker:'..chat_id, 5, true)
				text = Source_Start.."`استیکر های گروه پاکسازی شد`"..EndMsg
				CleanMsgs(chat_id ,msg_id, text)
			end
			if CmdMatches == 'Clean:fi:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:setex(RedisIndex..'Helper:film:'..chat_id, 5, true)
				text = Source_Start.."`فیلم های گروه پاکسازی شد`"..EndMsg
				CleanMsgs(chat_id ,msg_id, text)
			end
			if CmdMatches == 'Clean:se:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:setex(RedisIndex..'Helper:self:'..chat_id, 5, true)
				text = Source_Start.."`فیلم سلفی های گروه پاکسازی شد`"..EndMsg
				CleanMsgs(chat_id ,msg_id, text)
			end
			if CmdMatches == 'MenuSettings:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				PanelMenu(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'Startmsg' then
				Startmsg(chat_id, msg_id or 0, user_id)
			end
			if CmdMatches == 'Lockallads:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_link:'..chat_id, 'Enable')
				redis:set(RedisIndex..'lock_username:'..chat_id, 'Enable')
				redis:set(RedisIndex..'lock_mention:'..chat_id, 'Enable')
				redis:set(RedisIndex..'lock_spam:'..chat_id, 'Enable')
				redis:set(RedisIndex..'lock_flood:'..chat_id, 'Enable')
				redis:set(RedisIndex..'lock_webpage:'..chat_id, 'Enable')
				redis:set(RedisIndex..'lock_bots:'..chat_id, 'Enable')
				redis:set(RedisIndex..'mute_forward:'..chat_id, 'Enable')
				ShowMsg(Msg.id, Source_Start.."تمامی قفلای تبلیغات فعال شدند"..EndMsg, true)
			end
			if CmdMatches == 'Lockallmedia:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_gif:'..chat_id, 'Enable')
				redis:set(RedisIndex..'mute_photo:'..chat_id, 'Enable')
				redis:set(RedisIndex..'mute_sticker:'..chat_id, 'Enable')
				redis:set(RedisIndex..'mute_document:'..chat_id, 'Enable')
				redis:set(RedisIndex..'mute_voice:'..chat_id, 'Enable')
				redis:set(RedisIndex..'mute_audio:'..chat_id, 'Enable')
				redis:set(RedisIndex..'mute_video:'..chat_id, 'Enable')
				redis:set(RedisIndex..'mute_video_note:'..chat_id, 'Enable')
				ShowMsg(Msg.id, Source_Start.."تمامی قفلای رسانه فعال شدند"..EndMsg, true)
			end
			if CmdMatches == 'UnlockallLock:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:del(RedisIndex..'lock_link:'..chat_id)
				redis:del(RedisIndex..'lock_join:'..chat_id)
				redis:del(RedisIndex..'lock_tag:'..chat_id)
				redis:del(RedisIndex..'lock_username:'..chat_id)
				redis:del(RedisIndex..'lock_arabic:'..chat_id)
				redis:del(RedisIndex..'lock_english:'..chat_id)
				redis:del(RedisIndex..'lock_mention:'..chat_id)
				redis:del(RedisIndex..'lock_edit:'..chat_id)
				redis:del(RedisIndex..'lock_spam:'..chat_id)
				redis:del(RedisIndex..'lock_flood:'..chat_id)
				redis:del(RedisIndex..'lock_markdown:'..chat_id)
				redis:del(RedisIndex..'lock_webpage:'..chat_id)
				redis:del(RedisIndex..'welcome:'..chat_id)
				redis:del(RedisIndex..'lock_views:'..chat_id)
				redis:del(RedisIndex..'lock_bots:'..chat_id)
				redis:del(RedisIndex..'lock_tabchi:'..chat_id)
				redis:del(RedisIndex..'mute_all:'..chat_id)
				redis:del(RedisIndex..'mute_gif:'..chat_id)
				redis:del(RedisIndex..'mute_photo:'..chat_id)
				redis:del(RedisIndex..'mute_sticker:'..chat_id)
				redis:del(RedisIndex..'mute_contact:'..chat_id)
				redis:del(RedisIndex..'mute_inline:'..chat_id)
				redis:del(RedisIndex..'mute_game:'..chat_id)
				redis:del(RedisIndex..'mute_text:'..chat_id)
				redis:del(RedisIndex..'mute_keyboard:'..chat_id)
				redis:del(RedisIndex..'mute_forward:'..chat_id)
				redis:del(RedisIndex..'mute_forwarduser:'..chat_id)
				redis:del(RedisIndex..'mute_location:'..chat_id)
				redis:del(RedisIndex..'mute_document:'..chat_id)
				redis:del(RedisIndex..'mute_voice:'..chat_id)
				redis:del(RedisIndex..'mute_audio:'..chat_id)
				redis:del(RedisIndex..'mute_video:'..chat_id)
				redis:del(RedisIndex..'mute_video_note:'..chat_id)
				redis:del(RedisIndex..'mute_tgservice:'..chat_id)
				ShowMsg(Msg.id, Source_Start.."تمامی قفل ها ربات باز شد"..EndMsg, true)
			end
			if CmdMatches == 'LockSettingsFast:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				LockSettingsFast(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'Clean:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				Clean(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'LockSettings:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				SettingsLock(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'LockSettingsMore:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				LockSettingsMore(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'MuteSettings:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				SettingsMute(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'SpamSettings:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				SettingsSpam(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'MoreSettings:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				SettingsMore(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'AddSettings:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				SettingsAdd(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'HelpCode:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				HelpCode(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'locklink:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local st = (lock_link == 'Warn') and "اخطار" or ((lock_link == 'Kick') and "اخراج" or ((lock_link == 'Mute') and "سکوت" or ((lock_link == 'Enable') and "فعال" or "غیرفعال")))
				locks(chat_id,Source_Start..'قفل لینک',msg_id,'link','LockSettings:','لینک',st, user_first, user_id)
			end
			if CmdMatches == 'linkenable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_link:'..chat_id, 'Enable')
				local st = "فعال"
				locks(chat_id,Source_Start..'قفل لینک',msg_id,'link','LockSettings:','لینک',st, user_first, user_id)
			end
			if CmdMatches == 'linkdisable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:del(RedisIndex..'lock_link:'..chat_id)
				local st = "غیرفعال"
				locks(chat_id,Source_Start..'قفل لینک',msg_id,'link','LockSettings:','لینک',st, user_first, user_id)
			end
			if CmdMatches == 'linkwarn:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_link:'..chat_id, 'Warn')
				local st = "اخطار"
				locks(chat_id,Source_Start..'قفل لینک',msg_id,'link','LockSettings:','لینک',st, user_first, user_id)
			end
			if CmdMatches == 'linkmute:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_link:'..chat_id, 'Mute')
				local st = "سکوت"
				locks(chat_id,Source_Start..'قفل لینک',msg_id,'link','LockSettings:','لینک',st, user_first, user_id)
			end
			if CmdMatches == 'linkkick:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_link:'..chat_id, 'Kick')
				local st = "اخراج"
				locks(chat_id,Source_Start..'قفل لینک',msg_id,'link','LockSettings:','لینک',st, user_first, user_id)
			end
			if CmdMatches == 'lockviews:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local st = (lock_views == 'Warn') and "اخطار" or ((lock_views == 'Kick') and "اخراج" or ((lock_views == 'Mute') and "سکوت" or ((lock_views == 'Enable') and "فعال" or "غیرفعال")))
				locks(chat_id,Source_Start..'قفل بازدید',msg_id,'views','LockSettings:','بازدید',st, user_first, user_id)
			end
			if CmdMatches == 'viewsenable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_views:'..chat_id, 'Enable')
				local st = "فعال"
				locks(chat_id,Source_Start..'قفل بازدید',msg_id,'views','LockSettings:','بازدید',st, user_first, user_id)
			end
			if CmdMatches == 'viewsdisable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:del(RedisIndex..'lock_views:'..chat_id)
				local st = "غیرفعال"
				locks(chat_id,Source_Start..'قفل بازدید',msg_id,'views','LockSettings:','بازدید',st, user_first, user_id)
			end
			if CmdMatches == 'viewswarn:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_views:'..chat_id, 'Warn')
				local st = "اخطار"
				locks(chat_id,Source_Start..'قفل بازدید',msg_id,'views','LockSettings:','بازدید',st, user_first, user_id)
			end
			if CmdMatches == 'viewsmute:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_views:'..chat_id, 'Mute')
				local st = "سکوت"
				locks(chat_id,Source_Start..'قفل بازدید',msg_id,'views','LockSettings:','بازدید',st, user_first, user_id)
			end
			if CmdMatches == 'viewskick:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_views:'..chat_id, 'Kick')
				local st = "اخراج"
				locks(chat_id,Source_Start..'قفل بازدید',msg_id,'views','LockSettings:','بازدید',st, user_first, user_id)
			end
			if CmdMatches == 'lockedit:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local st = (lock_edit == 'Warn') and "اخطار" or ((lock_edit == 'Kick') and "اخراج" or ((lock_edit == 'Mute') and "سکوت" or ((lock_edit == 'Enable') and "فعال" or "غیرفعال")))
				locks(chat_id,Source_Start..'قفل ویرایش پیام',msg_id,'edit','LockSettings:','ویرایش پیام',st, user_first, user_id)
			end
			if CmdMatches == 'editenable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_edit:'..chat_id, 'Enable')
				local st = "فعال"
				locks(chat_id,Source_Start..'قفل ویرایش پیام',msg_id,'edit','LockSettings:','ویرایش پیام',st, user_first, user_id)
			end
			if CmdMatches == 'editdisable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:del(RedisIndex..'lock_edit:'..chat_id)
				local st = "غیرفعال"
				locks(chat_id,Source_Start..'قفل ویرایش پیام',msg_id,'edit','LockSettings:','ویرایش پیام',st, user_first, user_id)
			end
			if CmdMatches == 'editwarn:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_edit:'..chat_id, 'Warn')
				local st = "اخطار"
				locks(chat_id,Source_Start..'قفل ویرایش پیام',msg_id,'edit','LockSettings:','ویرایش پیام',st, user_first, user_id)
			end
			if CmdMatches == 'editmute:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_edit:'..chat_id, 'Mute')
				local st = "سکوت"
				locks(chat_id,Source_Start..'قفل ویرایش پیام',msg_id,'edit','LockSettings:','ویرایش پیام',st, user_first, user_id)
			end
			if CmdMatches == 'editkick:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_edit:'..chat_id, 'Kick')
				local st = "اخراج"
				locks(chat_id,Source_Start..'قفل ویرایش پیام',msg_id,'edit','LockSettings:','ویرایش پیام',st, user_first, user_id)
			end
			if CmdMatches == 'locktags:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local st = (lock_tag == 'Warn') and "اخطار" or ((lock_tag == 'Kick') and "اخراج" or ((lock_tag == 'Mute') and "سکوت" or ((lock_tag == 'Enable') and "فعال" or "غیرفعال")))
				locks(chat_id,Source_Start..'قفل تگ',msg_id,'tag','LockSettings:','تگ',st, user_first, user_id)
			end
			if CmdMatches == 'tagenable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_tag:'..chat_id, 'Enable')
				local st = "فعال"
				locks(chat_id,Source_Start..'قفل تگ',msg_id,'tag','LockSettings:','تگ',st, user_first, user_id)
			end
			if CmdMatches == 'tagdisable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:del(RedisIndex..'lock_tag:'..chat_id)
				local st = "غیرفعال"
				locks(chat_id,Source_Start..'قفل تگ',msg_id,'tag','LockSettings:','تگ',st, user_first, user_id)
			end
			if CmdMatches == 'tagwarn:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_tag:'..chat_id, 'Warn')
				local st = "اخطار"
				locks(chat_id,Source_Start..'قفل تگ',msg_id,'tag','LockSettings:','تگ',st, user_first, user_id)
			end
			if CmdMatches == 'tagmute:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_tag:'..chat_id, 'Mute')
				local st = "سکوت"
				locks(chat_id,Source_Start..'قفل تگ',msg_id,'tag','LockSettings:','تگ',st, user_first, user_id)
			end
			if CmdMatches == 'tagkick:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_tag:'..chat_id, 'Kick')
				local st = "اخراج"
				locks(chat_id,Source_Start..'قفل تگ',msg_id,'tag','LockSettings:','تگ',st, user_first, user_id)
			end
			if CmdMatches == 'lockusernames:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local st = (lock_username == 'Warn') and "اخطار" or ((lock_username == 'Kick') and "اخراج" or ((lock_username == 'Mute') and "سکوت" or ((lock_username == 'Enable') and "فعال" or "غیرفعال")))
				locks(chat_id,Source_Start..'قفل نام کاربری',msg_id,'usernames','LockSettings:','نام کاربری',st, user_first, user_id)
			end
			if CmdMatches == 'usernamesenable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_username:'..chat_id, 'Enable')
				local st = "فعال"
				locks(chat_id,Source_Start..'قفل نام کاربری',msg_id,'usernames','LockSettings:','نام کاربری',st, user_first, user_id)
			end
			if CmdMatches == 'usernamesdisable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:del(RedisIndex..'lock_username:'..chat_id)
				local st = "غیرفعال"
				locks(chat_id,Source_Start..'قفل نام کاربری',msg_id,'usernames','LockSettings:','نام کاربری',st, user_first, user_id)
			end
			if CmdMatches == 'usernameswarn:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_username:'..chat_id, 'Warn')
				local st = "اخطار"
				locks(chat_id,Source_Start..'قفل نام کاربری',msg_id,'usernames','LockSettings:','نام کاربری',st, user_first, user_id)
			end
			if CmdMatches == 'usernamesmute:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_username:'..chat_id, 'Mute')
				local st = "سکوت"
				locks(chat_id,Source_Start..'قفل نام کاربری',msg_id,'usernames','LockSettings:','نام کاربری',st, user_first, user_id)
			end
			if CmdMatches == 'usernameskick:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_username:'..chat_id, 'Kick')
				local st = "اخراج"
				locks(chat_id,Source_Start..'قفل نام کاربری',msg_id,'usernames','LockSettings:','نام کاربری',st, user_first, user_id)
			end
			if CmdMatches == 'lockmention:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local st = (lock_mention == 'Warn') and "اخطار" or ((lock_mention == 'Kick') and "اخراج" or ((lock_mention == 'Mute') and "سکوت" or ((lock_mention == 'Enable') and "فعال" or "غیرفعال")))
				locks(chat_id,Source_Start..'قفل منشن',msg_id,'mention','LockSettings:','منشن',st, user_first, user_id)
			end
			if CmdMatches == 'mentionenable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_mention:'..chat_id, 'Enable')
				local st = "فعال"
				locks(chat_id,Source_Start..'قفل منشن',msg_id,'mention','LockSettings:','منشن',st, user_first, user_id)
			end
			if CmdMatches == 'mentiondisable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:del(RedisIndex..'lock_mention:'..chat_id)
				local st = "غیرفعال"
				locks(chat_id,Source_Start..'قفل منشن',msg_id,'mention','LockSettings:','منشن',st, user_first, user_id)
			end
			if CmdMatches == 'mentionkick:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_mention:'..chat_id, 'Kick')
				local st = "اخراج"
				locks(chat_id,Source_Start..'قفل منشن',msg_id,'mention','LockSettings:','منشن',st, user_first, user_id)
			end
			if CmdMatches == 'mentionwarn:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_mention:'..chat_id, 'Warn')
				local st = "اخطار"
				locks(chat_id,Source_Start..'قفل منشن',msg_id,'mention','LockSettings:','منشن',st, user_first, user_id)
			end
			if CmdMatches == 'mentionmute:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_mention:'..chat_id, 'Mute')
				local st = "سکوت"
				locks(chat_id,Source_Start..'قفل منشن',msg_id,'mention','LockSettings:','منشن',st, user_first, user_id)
			end
			if CmdMatches == 'mentionkick:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_mention:'..chat_id, 'Kick')
				local st = "اخراج"
				locks(chat_id,Source_Start..'قفل منشن',msg_id,'mention','LockSettings:','منشن',st, user_first, user_id)
			end
			if CmdMatches == 'lockarabic:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local st = (lock_arabic == 'Warn') and "اخطار" or ((lock_arabic == 'Kick') and "اخراج" or ((lock_arabic == 'Mute') and "سکوت" or ((lock_arabic == 'Enable') and "فعال" or "غیرفعال")))
				locks(chat_id,Source_Start..'قفل فارسی',msg_id,'farsi','LockSettings:','فارسی',st, user_first, user_id)
			end
			if CmdMatches == 'farsienable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_arabic:'..chat_id, 'Enable')
				local st = "فعال"
				locks(chat_id,Source_Start..'قفل فارسی',msg_id,'farsi','LockSettings:','فارسی',st, user_first, user_id)
			end
			if CmdMatches == 'farsidisable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:del(RedisIndex..'lock_arabic:'..chat_id)
				local st = "غیرفعال"
				locks(chat_id,Source_Start..'قفل فارسی',msg_id,'farsi','LockSettings:','فارسی',st, user_first, user_id)
			end
			if CmdMatches == 'farsiwarn:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_arabic:'..chat_id, 'Warn')
				local st = "اخطار"
				locks(chat_id,Source_Start..'قفل فارسی',msg_id,'farsi','LockSettings:','فارسی',st, user_first, user_id)
			end
			if CmdMatches == 'farsimute:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_arabic:'..chat_id, 'Mute')
				local st = "سکوت"
				locks(chat_id,Source_Start..'قفل فارسی',msg_id,'farsi','LockSettings:','فارسی',st, user_first, user_id)
			end
			if CmdMatches == 'farsikick:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_arabic:'..chat_id, 'Kick')
				local st = "اخراج"
				locks(chat_id,Source_Start..'قفل فارسی',msg_id,'farsi','LockSettings:','فارسی',st, user_first, user_id)
			end
			if CmdMatches == 'lockwebpage:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local st = (lock_webpage == 'Warn') and "اخطار" or ((lock_webpage == 'Kick') and "اخراج" or ((lock_webpage == 'Mute') and "سکوت" or ((lock_webpage == 'Enable') and "فعال" or "غیرفعال")))
				locks(chat_id,Source_Start..'قفل وبسایت',msg_id,'web','LockSettings:','وبسایت',st, user_first, user_id)
			end
			if CmdMatches == 'webenable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_webpage:'..chat_id, 'Enable')
				local st = "فعال"
				locks(chat_id,Source_Start..'قفل وبسایت',msg_id,'web','LockSettings:','وبسایت',st, user_first, user_id)
			end
			if CmdMatches == 'webdisable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:del(RedisIndex..'lock_webpage:'..chat_id)
				local st = "غیرفعال"
				locks(chat_id,Source_Start..'قفل وبسایت',msg_id,'web','LockSettings:','وبسایت',st, user_first, user_id)
			end
			if CmdMatches == 'webwarn:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_webpage:'..chat_id, 'Warn')
				local st = "اخطار"
				locks(chat_id,Source_Start..'قفل وبسایت',msg_id,'web','LockSettings:','وبسایت',st, user_first, user_id)
			end
			if CmdMatches == 'webmute:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_webpage:'..chat_id, 'Mute')
				local st = "سکوت"
				locks(chat_id,Source_Start..'قفل وبسایت',msg_id,'web','LockSettings:','وبسایت',st, user_first, user_id)
			end
			if CmdMatches == 'webkick:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_webpage:'..chat_id, 'Kick')
				local st = "اخراج"
				locks(chat_id,Source_Start..'قفل وبسایت',msg_id,'web','LockSettings:','وبسایت',st, user_first, user_id)
			end
			if CmdMatches == 'lockmarkdown:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local st = (lock_markdown == 'Warn') and "اخطار" or ((lock_markdown == 'Kick') and "اخراج" or ((lock_markdown == 'Mute') and "سکوت" or ((lock_markdown == 'Enable') and "فعال" or "غیرفعال")))
				locks(chat_id,Source_Start..'قفل فونت',msg_id,'markdown','LockSettings:','فونت',st, user_first, user_id)
			end
			if CmdMatches == 'markdownenable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_markdown:'..chat_id, 'Enable')
				local st = "فعال"
				locks(chat_id,Source_Start..'قفل فونت',msg_id,'markdown','LockSettings:','فونت',st, user_first, user_id)
			end
			if CmdMatches == 'markdowndisable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:del(RedisIndex..'lock_markdown:'..chat_id)
				local st = "غیرفعال"
				locks(chat_id,Source_Start..'قفل فونت',msg_id,'markdown','LockSettings:','فونت',st, user_first, user_id)
			end
			if CmdMatches == 'markdownwarn:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_markdown:'..chat_id, 'Warn')
				local st = "اخطار"
				locks(chat_id,Source_Start..'قفل فونت',msg_id,'markdown','LockSettings:','فونت',st, user_first, user_id)
			end
			if CmdMatches == 'markdownmute:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_markdown:'..chat_id, 'Mute')
				local st = "سکوت"
				locks(chat_id,Source_Start..'قفل فونت',msg_id,'markdown','LockSettings:','فونت',st, user_first, user_id)
			end
			if CmdMatches == 'markdownkick:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_markdown:'..chat_id, 'Kick')
				local st = "اخراج"
				locks(chat_id,Source_Start..'قفل فونت',msg_id,'markdown','LockSettings:','فونت',st, user_first, user_id)
			end
			if CmdMatches == 'mutevideonote:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local st = (mute_video_note == 'Warn') and "اخطار" or ((mute_video_note == 'Kick') and "اخراج" or ((mute_video_note == 'Mute') and "سکوت" or ((mute_video_note == 'Enable') and "فعال" or "غیرفعال")))
				locks(chat_id,Source_Start..'قفل فیلم سلفی',msg_id,'note','MuteSettings:','فیلم سلفی',st, user_first, user_id)
			end
			if CmdMatches == 'noteenable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_video_note:'..chat_id, 'Enable')
				local st = "فعال"
				locks(chat_id,Source_Start..'قفل فیلم سلفی',msg_id,'note','MuteSettings:','فیلم سلفی',st, user_first, user_id)
			end
			if CmdMatches == 'notedisable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:del(RedisIndex..'mute_video_note:'..chat_id)
				local st = "غیرفعال"
				locks(chat_id,Source_Start..'قفل فیلم سلفی',msg_id,'note','MuteSettings:','فیلم سلفی',st, user_first, user_id)
			end
			if CmdMatches == 'notewarn:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_video_note:'..chat_id, 'Warn')
				local st = "اخطار"
				locks(chat_id,Source_Start..'قفل فیلم سلفی',msg_id,'note','MuteSettings:','فیلم سلفی',st, user_first, user_id)
			end
			if CmdMatches == 'notemute:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_video_note:'..chat_id, 'Mute')
				local st = "سکوت"
				locks(chat_id,Source_Start..'قفل فیلم سلفی',msg_id,'note','MuteSettings:','فیلم سلفی',st, user_first, user_id)
			end
			if CmdMatches == 'notekick:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_video_note:'..chat_id, 'Kick')
				local st = "اخراج"
				locks(chat_id,Source_Start..'قفل فیلم سلفی',msg_id,'note','MuteSettings:','فیلم سلفی',st, user_first, user_id)
			end
			if CmdMatches == 'mutegif:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local st = (mute_gif == 'Warn') and "اخطار" or ((mute_gif == 'Kick') and "اخراج" or ((mute_gif == 'Mute') and "سکوت" or ((mute_gif == 'Enable') and "فعال" or "غیرفعال")))
				locks(chat_id,Source_Start..'قفل گیف',msg_id,'gif','MuteSettings:','گیف',st, user_first, user_id)
			end
			if CmdMatches == 'gifenable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_gif:'..chat_id, 'Enable')
				local st = "فعال"
				locks(chat_id,Source_Start..'قفل گیف',msg_id,'gif','MuteSettings:','گیف',st, user_first, user_id)
			end
			if CmdMatches == 'gifdisable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:del(RedisIndex..'mute_gif:'..chat_id)
				local st = "غیرفعال"
				locks(chat_id,Source_Start..'قفل گیف',msg_id,'gif','MuteSettings:','گیف',st, user_first, user_id)
			end
			if CmdMatches == 'gifwarn:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_gif:'..chat_id, 'Warn')
				local st = "اخطار"
				locks(chat_id,Source_Start..'قفل گیف',msg_id,'gif','MuteSettings:','گیف',st, user_first, user_id)
			end
			if CmdMatches == 'gifmute:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_gif:'..chat_id, 'Mute')
				local st = "سکوت"
				locks(chat_id,Source_Start..'قفل گیف',msg_id,'gif','MuteSettings:','گیف',st, user_first, user_id)
			end
			if CmdMatches == 'gifkick:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_gif:'..chat_id, 'Kick')
				local st = "اخراج"
				locks(chat_id,Source_Start..'قفل گیف',msg_id,'gif','MuteSettings:','گیف',st, user_first, user_id)
			end
			if CmdMatches == 'mutetext:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local st = (mute_text == 'Warn') and "اخطار" or ((mute_text == 'Kick') and "اخراج" or ((mute_text == 'Mute') and "سکوت" or ((mute_text == 'Enable') and "فعال" or "غیرفعال")))
				locks(chat_id,Source_Start..'قفل متن',msg_id,'text','MuteSettings:','متن',st, user_first, user_id)
			end
			if CmdMatches == 'textenable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_text:'..chat_id, 'Enable')
				local st = "فعال"
				locks(chat_id,Source_Start..'قفل متن',msg_id,'text','MuteSettings:','متن',st, user_first, user_id)
			end
			if CmdMatches == 'textdisable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:del(RedisIndex..'mute_text:'..chat_id)
				local st = "غیرفعال"
				locks(chat_id,Source_Start..'قفل متن',msg_id,'text','MuteSettings:','متن',st, user_first, user_id)
			end
			if CmdMatches == 'textwarn:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_text:'..chat_id, 'Warn')
				local st = "اخطار"
				locks(chat_id,Source_Start..'قفل متن',msg_id,'text','MuteSettings:','متن',st, user_first, user_id)
			end
			if CmdMatches == 'textmute:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_text:'..chat_id, 'Mute')
				local st = "سکوت"
				locks(chat_id,Source_Start..'قفل متن',msg_id,'text','MuteSettings:','متن',st, user_first, user_id)
			end
			if CmdMatches == 'textkick:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_text:'..chat_id, 'Kick')
				local st = "اخراج"
				locks(chat_id,Source_Start..'قفل متن',msg_id,'text','MuteSettings:','متن',st, user_first, user_id)
			end
			if CmdMatches == 'muteinline:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local st = (mute_inline == 'Warn') and "اخطار" or ((mute_inline == 'Kick') and "اخراج" or ((mute_inline == 'Mute') and "سکوت" or ((mute_inline == 'Enable') and "فعال" or "غیرفعال")))
				locks(chat_id,Source_Start..'قفل دکمه شیشه ای',msg_id,'inline','MuteSettings:','دکمه شیشه ای',st, user_first, user_id)
			end
			if CmdMatches == 'inlineenable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_inline:'..chat_id, 'Enable')
				local st = "فعال"
				locks(chat_id,Source_Start..'قفل دکمه شیشه ای',msg_id,'inline','MuteSettings:','دکمه شیشه ای',st, user_first, user_id)
			end
			if CmdMatches == 'inlinedisable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:del(RedisIndex..'mute_inline:'..chat_id)
				local st = "غیرفعال"
				locks(chat_id,Source_Start..'قفل دکمه شیشه ای',msg_id,'inline','MuteSettings:','دکمه شیشه ای',st, user_first, user_id)
			end
			if CmdMatches == 'inlinewarn:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_inline:'..chat_id, 'Warn')
				local st = "اخطار"
				locks(chat_id,Source_Start..'قفل دکمه شیشه ای',msg_id,'inline','MuteSettings:','دکمه شیشه ای',st, user_first, user_id)
			end
			if CmdMatches == 'inlinemute:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_inline:'..chat_id, 'Mute')
				local st = "سکوت"
				locks(chat_id,Source_Start..'قفل دکمه شیشه ای',msg_id,'inline','MuteSettings:','دکمه شیشه ای',st, user_first, user_id)
			end
			if CmdMatches == 'inlinekick:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_inline:'..chat_id, 'Kick')
				local st = "اخراج"
				locks(chat_id,Source_Start..'قفل دکمه شیشه ای',msg_id,'inline','MuteSettings:','دکمه شیشه ای',st, user_first, user_id)
			end
			if CmdMatches == 'mutegame:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local st = (mute_game == 'Warn') and "اخطار" or ((mute_game == 'Kick') and "اخراج" or ((mute_game == 'Mute') and "سکوت" or ((mute_game == 'Enable') and "فعال" or "غیرفعال")))
				locks(chat_id,Source_Start..'قفل بازی',msg_id,'game','MuteSettings:','بازی',st, user_first, user_id)
			end
			if CmdMatches == 'gameenable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_game:'..chat_id, 'Enable')
				local st = "فعال"
				locks(chat_id,Source_Start..'قفل بازی',msg_id,'game','MuteSettings:','بازی',st, user_first, user_id)
			end
			if CmdMatches == 'gamedisable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:del(RedisIndex..'mute_game:'..chat_id)
				local st = "غیرفعال"
				locks(chat_id,Source_Start..'قفل بازی',msg_id,'game','MuteSettings:','بازی',st, user_first, user_id)
			end
			if CmdMatches == 'gamewarn:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_game:'..chat_id, 'Warn')
				local st = "اخطار"
				locks(chat_id,Source_Start..'قفل بازی',msg_id,'game','MuteSettings:','بازی',st, user_first, user_id)
			end
			if CmdMatches == 'gamemute:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_game:'..chat_id, 'Mute')
				local st = "سکوت"
				locks(chat_id,Source_Start..'قفل بازی',msg_id,'game','MuteSettings:','بازی',st, user_first, user_id)
			end
			if CmdMatches == 'gamekick:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_game:'..chat_id, 'Kick')
				local st = "اخراج"
				locks(chat_id,Source_Start..'قفل بازی',msg_id,'game','MuteSettings:','بازی',st, user_first, user_id)
			end
			if CmdMatches == 'mutephoto:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local st = (mute_photo == 'Warn') and "اخطار" or ((mute_photo == 'Kick') and "اخراج" or ((mute_photo == 'Mute') and "سکوت" or ((mute_photo == 'Enable') and "فعال" or "غیرفعال")))
				locks(chat_id,Source_Start..'قفل عکس',msg_id,'photo','MuteSettings:','عکس',st, user_first, user_id)
			end
			if CmdMatches == 'photoenable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_photo:'..chat_id, 'Enable')
				local st = "فعال"
				locks(chat_id,Source_Start..'قفل عکس',msg_id,'photo','MuteSettings:','عکس',st, user_first, user_id)
			end
			if CmdMatches == 'photodisable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:del(RedisIndex..'mute_photo:'..chat_id)
				local st = "غیرفعال"
				locks(chat_id,Source_Start..'قفل عکس',msg_id,'photo','MuteSettings:','عکس',st, user_first, user_id)
			end
			if CmdMatches == 'photowarn:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_photo:'..chat_id, 'Warn')
				local st = "اخطار"
				locks(chat_id,Source_Start..'قفل عکس',msg_id,'photo','MuteSettings:','عکس',st, user_first, user_id)
			end
			if CmdMatches == 'photomute:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_photo:'..chat_id, 'Mute')
				local st = "سکوت"
				locks(chat_id,Source_Start..'قفل عکس',msg_id,'photo','MuteSettings:','عکس',st, user_first, user_id)
			end
			if CmdMatches == 'photokick:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_photo:'..chat_id, 'Kick')
				local st = "اخراج"
				locks(chat_id,Source_Start..'قفل عکس',msg_id,'photo','MuteSettings:','عکس',st, user_first, user_id)
			end
			if CmdMatches == 'mutevideo:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local st = (mute_video == 'Warn') and "اخطار" or ((mute_video == 'Kick') and "اخراج" or ((mute_video == 'Mute') and "سکوت" or ((mute_video == 'Enable') and "فعال" or "غیرفعال")))
				locks(chat_id,Source_Start..'قفل فیلم',msg_id,'video','MuteSettings:','فیلم',st, user_first, user_id)
			end
			if CmdMatches == 'videoenable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_video:'..chat_id, 'Enable')
				local st = "فعال"
				locks(chat_id,Source_Start..'قفل فیلم',msg_id,'video','MuteSettings:','فیلم',st, user_first, user_id)
			end
			if CmdMatches == 'videodisable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:del(RedisIndex..'mute_video:'..chat_id)
				local st = "غیرفعال"
				locks(chat_id,Source_Start..'قفل فیلم',msg_id,'video','MuteSettings:','فیلم',st, user_first, user_id)
			end
			if CmdMatches == 'videowarn:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_video:'..chat_id, 'Warn')
				local st = "اخطار"
				locks(chat_id,Source_Start..'قفل فیلم',msg_id,'video','MuteSettings:','فیلم',st, user_first, user_id)
			end
			if CmdMatches == 'videomute:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_video:'..chat_id, 'Mute')
				local st = "سکوت"
				locks(chat_id,Source_Start..'قفل فیلم',msg_id,'video','MuteSettings:','فیلم',st, user_first, user_id)
			end
			if CmdMatches == 'videokick:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_video:'..chat_id, 'Kick')
				local st = "اخراج"
				locks(chat_id,Source_Start..'قفل فیلم',msg_id,'video','MuteSettings:','فیلم',st, user_first, user_id)
			end
			if CmdMatches == 'muteaudio:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local st = (mute_audio == 'Warn') and "اخطار" or ((mute_audio == 'Kick') and "اخراج" or ((mute_audio == 'Mute') and "سکوت" or ((mute_audio == 'Enable') and "فعال" or "غیرفعال")))
				locks(chat_id,Source_Start..'قفل آهنگ',msg_id,'audio','MuteSettings:','آهنگ',st, user_first, user_id)
			end
			if CmdMatches == 'audioenable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_audio:'..chat_id, 'Enable')
				local st = "فعال"
				locks(chat_id,Source_Start..'قفل آهنگ',msg_id,'audio','MuteSettings:','آهنگ',st, user_first, user_id)
			end
			if CmdMatches == 'audiodisable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:del(RedisIndex..'mute_audio:'..chat_id)
				local st = "غیرفعال"
				locks(chat_id,Source_Start..'قفل آهنگ',msg_id,'audio','MuteSettings:','آهنگ',st, user_first, user_id)
			end
			if CmdMatches == 'audiowarn:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_audio:'..chat_id, 'Warn')
				local st = "اخطار"
				locks(chat_id,Source_Start..'قفل آهنگ',msg_id,'audio','MuteSettings:','آهنگ',st, user_first, user_id)
			end
			if CmdMatches == 'audiomute:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_audio:'..chat_id, 'Mute')
				local st = "سکوت"
				locks(chat_id,Source_Start..'قفل آهنگ',msg_id,'audio','MuteSettings:','آهنگ',st, user_first, user_id)
			end
			if CmdMatches == 'audiokick:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_audio:'..chat_id, 'Kick')
				local st = "اخراج"
				locks(chat_id,Source_Start..'قفل آهنگ',msg_id,'audio','MuteSettings:','آهنگ',st, user_first, user_id)
			end
			if CmdMatches == 'mutevoice:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local st = (mute_voice == 'Warn') and "اخطار" or ((mute_voice == 'Kick') and "اخراج" or ((mute_voice == 'Mute') and "سکوت" or ((mute_voice == 'Enable') and "فعال" or "غیرفعال")))
				locks(chat_id,Source_Start..'قفل ویس',msg_id,'voice','MuteSettings:','ویس',st, user_first, user_id)
			end
			if CmdMatches == 'voiceenable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_voice:'..chat_id, 'Enable')
				local st = "فعال"
				locks(chat_id,Source_Start..'قفل ویس',msg_id,'voice','MuteSettings:','ویس',st, user_first, user_id)
			end
			if CmdMatches == 'voicedisable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:del(RedisIndex..'mute_voice:'..chat_id)
				local st = "غیرفعال"
				locks(chat_id,Source_Start..'قفل ویس',msg_id,'voice','MuteSettings:','ویس',st, user_first, user_id)
			end
			if CmdMatches == 'voicewarn:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_voice:'..chat_id, 'Warn')
				local st = "اخطار"
				locks(chat_id,Source_Start..'قفل ویس',msg_id,'voice','MuteSettings:','ویس',st, user_first, user_id)
			end
			if CmdMatches == 'voicemute:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_voice:'..chat_id, 'Mute')
				local st = "سکوت"
				locks(chat_id,Source_Start..'قفل ویس',msg_id,'voice','MuteSettings:','ویس',st, user_first, user_id)
			end
			if CmdMatches == 'voicekick:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_voice:'..chat_id, 'Kick')
				local st = "اخراج"
				locks(chat_id,Source_Start..'قفل ویس',msg_id,'voice','MuteSettings:','ویس',st, user_first, user_id)
			end
			if CmdMatches == 'mutesticker:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local st = (mute_sticker == 'Warn') and "اخطار" or ((mute_sticker == 'Kick') and "اخراج" or ((mute_sticker == 'Mute') and "سکوت" or ((mute_sticker == 'Enable') and "فعال" or "غیرفعال")))
				locks(chat_id,Source_Start..'قفل استیکر',msg_id,'sticker','MuteSettings:','استیکر',st, user_first, user_id)
			end
			if CmdMatches == 'stickerenable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_sticker:'..chat_id, 'Enable')
				local st = "فعال"
				locks(chat_id,Source_Start..'قفل استیکر',msg_id,'sticker','MuteSettings:','استیکر',st, user_first, user_id)
			end
			if CmdMatches == 'stickerdisable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:del(RedisIndex..'mute_sticker:'..chat_id)
				local st = "غیرفعال"
				locks(chat_id,Source_Start..'قفل استیکر',msg_id,'sticker','MuteSettings:','استیکر',st, user_first, user_id)
			end
			if CmdMatches == 'stickerwarn:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_sticker:'..chat_id, 'Warn')
				local st = "اخطار"
				locks(chat_id,Source_Start..'قفل استیکر',msg_id,'sticker','MuteSettings:','استیکر',st, user_first, user_id)
			end
			if CmdMatches == 'stickermute:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_sticker:'..chat_id, 'Mute')
				local st = "سکوت"
				locks(chat_id,Source_Start..'قفل استیکر',msg_id,'sticker','MuteSettings:','استیکر',st, user_first, user_id)
			end
			if CmdMatches == 'stickerkick:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_sticker:'..chat_id, 'Kick')
				local st = "اخراج"
				locks(chat_id,Source_Start..'قفل استیکر',msg_id,'sticker','MuteSettings:','استیکر',st, user_first, user_id)
			end
			if CmdMatches == 'mutecontact:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local st = (mute_contact == 'Warn') and "اخطار" or ((mute_contact == 'Kick') and "اخراج" or ((mute_contact == 'Mute') and "سکوت" or ((mute_contact == 'Enable') and "فعال" or "غیرفعال")))
				locks(chat_id,Source_Start..'قفل مخاطب',msg_id,'contact','MuteSettings:','مخاطب',st, user_first, user_id)
			end
			if CmdMatches == 'contactenable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_contact:'..chat_id, 'Enable')
				local st = "فعال"
				locks(chat_id,Source_Start..'قفل مخاطب',msg_id,'contact','MuteSettings:','مخاطب',st, user_first, user_id)
			end
			if CmdMatches == 'contactdisable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:del(RedisIndex..'mute_contact:'..chat_id)
				local st = "غیرفعال"
				locks(chat_id,Source_Start..'قفل مخاطب',msg_id,'contact','MuteSettings:','مخاطب',st, user_first, user_id)
			end
			if CmdMatches == 'contactwarn:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_contact:'..chat_id, 'Warn')
				local st = "اخطار"
				locks(chat_id,Source_Start..'قفل مخاطب',msg_id,'contact','MuteSettings:','مخاطب',st, user_first, user_id)
			end
			if CmdMatches == 'contactmute:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_contact:'..chat_id, 'Mute')
				local st = "سکوت"
				locks(chat_id,Source_Start..'قفل مخاطب',msg_id,'contact','MuteSettings:','مخاطب',st, user_first, user_id)
			end
			if CmdMatches == 'contactkick:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_contact:'..chat_id, 'Kick')
				local st = "اخراج"
				locks(chat_id,Source_Start..'قفل مخاطب',msg_id,'contact','MuteSettings:','مخاطب',st, user_first, user_id)
			end
			if CmdMatches == 'muteforward:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				Chat_id = chat_id
				mute_forwardch = redis:get(RedisIndex..'mute_forward:'..Chat_id)
				mute_forwarduser = redis:get(RedisIndex..'mute_forwarduser:'..Chat_id)
				local FwdCh = (mute_forwardch == "Warn") and "【✍🏻】" or ((mute_forwardch == "Kick") and "【🚫】" or ((mute_forwardch == "Mute") and "【🔇】" or ((mute_forwardch == "Enable") and "【✓】" or "【✗】")))
				local FwdUser = (mute_forwarduser == "Warn") and "【✍🏻】" or ((mute_forwarduser == "Kick") and "【🚫】" or ((mute_forwarduser == "Mute") and "【🔇】" or ((mute_forwarduser == "Enable") and "【✓】" or "【✗】")))
				text = Source_Start..'*به تنظیمات قفل فوروارد خوش آمدید*\n*راهنمای ایموجی :*\n\n✍🏻 = `حالت اخطار`\n🚫 = `حالت اخراج`\n🔇 = `حالت سکوت`\n✓ = `فعال`\n✗ = `غیرفعال`'
				keyboard = {}
				keyboard.inline_keyboard = {
				{{text = Source_Start.."فوروارد کانال :"..FwdCh, callback_data="muteforwardch:"..Chat_id}},
				{{text = Source_Start.."فوروارد کاربر :"..FwdUser, callback_data="muteforwarduser:"..Chat_id}},
				{{text = Source_Start.."بازگشت 🎈", callback_data="MuteSettings:"..Chat_id}}
				}
				EditInline(text, chat_id, msg_id, "md", keyboard)
			end
			if CmdMatches == 'muteforwardch:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local st = (mute_forwardch == 'Warn') and "اخطار" or ((mute_forwardch == 'Kick') and "اخراج" or ((mute_forwardch == 'Mute') and "سکوت" or ((mute_forwardch == 'Enable') and "فعال" or "غیرفعال")))
				locks(chat_id,'⇜ قفل فوروارد کانال',msg_id,'fwd','muteforward:','فوروارد کانال',st, user_first, user_id)
			end
			if CmdMatches == 'muteforwarduser:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local st = (mute_forwarduser == 'Warn') and "اخطار" or ((mute_forwarduser == 'Kick') and "اخراج" or ((mute_forwarduser == 'Mute') and "سکوت" or ((mute_forwarduser == 'Enable') and "فعال" or "غیرفعال")))
				locks(chat_id,'⇜ قفل فوروارد کاربر',msg_id,'fwduser','muteforward:','فوروارد کاربر',st, user_first, user_id)
			end
			if CmdMatches == 'fwdenable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_forward:'..chat_id, 'Enable')
				local st = "فعال"
				locks(chat_id,'⇜ قفل فوروارد کانال',msg_id,'fwd','muteforward:','فوروارد کانال',st, user_first, user_id)
			end
			if CmdMatches == 'fwddisable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:del(RedisIndex..'mute_forward:'..chat_id)
				local st = "غیرفعال"
				locks(chat_id,'⇜ قفل فوروارد کانال',msg_id,'fwd','muteforward:','فوروارد کانال',st, user_first, user_id)
			end
			if CmdMatches == 'fwdwarn:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_forward:'..chat_id, 'Warn')
				local st = "اخطار"
				locks(chat_id,'⇜ قفل فوروارد کانال',msg_id,'fwd','muteforward:','فوروارد کانال',st, user_first, user_id)
			end
			if CmdMatches == 'fwdmute:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_forward:'..chat_id, 'Mute')
				local st = "سکوت"
				locks(chat_id,'⇜ قفل فوروارد کانال',msg_id,'fwd','muteforward:','فوروارد کانال',st, user_first, user_id)
			end
			if CmdMatches == 'fwdkick:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_forward:'..chat_id, 'Kick')
				local st = "اخراج"
				locks(chat_id,'⇜ قفل فوروارد کانال',msg_id,'fwd','muteforward:','فوروارد کانال',st, user_first, user_id)
			end
			if CmdMatches == 'fwduserenable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_forwarduser:'..chat_id, 'Enable')
				local st = "فعال"
				locks(chat_id,'⇜ قفل فوروارد کاربر',msg_id,'fwduser','muteforward:','فوروارد کاربر',st, user_first, user_id)
			end
			if CmdMatches == 'fwduserdisable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:del(RedisIndex..'mute_forwarduser:'..chat_id)
				local st = "غیرفعال"
				locks(chat_id,'⇜ قفل فوروارد کاربر',msg_id,'fwduser','muteforward:','فوروارد کاربر',st, user_first, user_id)
			end
			if CmdMatches == 'fwduserwarn:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_forwarduser:'..chat_id, 'Warn')
				local st = "اخطار"
				locks(chat_id,'⇜ قفل فوروارد کاربر',msg_id,'fwduser','muteforward:','فوروارد کاربر',st, user_first, user_id)
			end
			if CmdMatches == 'fwdusermute:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_forwarduser:'..chat_id, 'Mute')
				local st = "سکوت"
				locks(chat_id,'⇜ قفل فوروارد کاربر',msg_id,'fwduser','muteforward:','فوروارد کاربر',st, user_first, user_id)
			end
			if CmdMatches == 'fwduserkick:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_forwarduser:'..chat_id, 'Kick')
				local st = "اخراج"
				locks(chat_id,'⇜ قفل فوروارد کاربر',msg_id,'fwduser','muteforward:','فوروارد کاربر',st, user_first, user_id)
			end
			if CmdMatches == 'mutelocation:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local st = (mute_location == 'Warn') and "اخطار" or ((mute_location == 'Kick') and "اخراج" or ((mute_location == 'Mute') and "سکوت" or ((mute_location == 'Enable') and "فعال" or "غیرفعال")))
				locks(chat_id,'⇜ قفل مکان',msg_id,'location','MuteSettings:','مکان',st, user_first, user_id)
			end
			if CmdMatches == 'locationenable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_location:'..chat_id, 'Enable')
				local st = "فعال"
				locks(chat_id,'⇜ قفل مکان',msg_id,'location','MuteSettings:','مکان',st, user_first, user_id)
			end
			if CmdMatches == 'locationdisable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:del(RedisIndex..'mute_location:'..chat_id)
				local st = "غیرفعال"
				locks(chat_id,'⇜ قفل مکان',msg_id,'location','MuteSettings:','مکان',st, user_first, user_id)
			end
			if CmdMatches == 'locationwarn:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_location:'..chat_id, 'Warn')
				local st = "اخطار"
				locks(chat_id,'⇜ قفل مکان',msg_id,'location','MuteSettings:','مکان',st, user_first, user_id)
			end
			if CmdMatches == 'locationmute:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_location:'..chat_id, 'Mute')
				local st = "سکوت"
				locks(chat_id,'⇜ قفل مکان',msg_id,'location','MuteSettings:','مکان',st, user_first, user_id)
			end
			if CmdMatches == 'locationkick:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_location:'..chat_id, 'Kick')
				local st = "اخراج"
				locks(chat_id,'⇜ قفل مکان',msg_id,'location','MuteSettings:','مکان',st, user_first, user_id)
			end
			if CmdMatches == 'mutedocument:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local st = (mute_document == 'Warn') and "اخطار" or ((mute_document == 'Kick') and "اخراج" or ((mute_document == 'Mute') and "سکوت" or ((mute_document == 'Enable') and "فعال" or "غیرفعال")))
				locks(chat_id,'⇜ قفل فایل',msg_id,'document','MuteSettings:','فایل',st, user_first, user_id)
			end
			if CmdMatches == 'documentenable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_document:'..chat_id, 'Enable')
				local st = "فعال"
				locks(chat_id,'⇜ قفل فایل',msg_id,'document','MuteSettings:','فایل',st, user_first, user_id)
			end
			if CmdMatches == 'documentdisable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:del(RedisIndex..'mute_document:'..chat_id)
				local st = "غیرفعال"
				locks(chat_id,'⇜ قفل فایل',msg_id,'document','MuteSettings:','فایل',st, user_first, user_id)
			end
			if CmdMatches == 'documentwarn:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_document:'..chat_id, 'Warn')
				local st = "اخطار"
				locks(chat_id,'⇜ قفل فایل',msg_id,'document','MuteSettings:','فایل',st, user_first, user_id)
			end
			if CmdMatches == 'documentmute:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_document:'..chat_id, 'Mute')
				local st = "سکوت"
				locks(chat_id,'⇜ قفل فایل',msg_id,'document','MuteSettings:','فایل',st, user_first, user_id)
			end
			if CmdMatches == 'documentkick:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_document:'..chat_id, 'Kick')
				local st = "اخراج"
				locks(chat_id,'⇜ قفل فایل',msg_id,'document','MuteSettings:','فایل',st, user_first, user_id)
			end
			if CmdMatches == 'mutekeyboard:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local st = (mute_keyboard == 'Warn') and "اخطار" or ((mute_keyboard == 'Kick') and "اخراج" or ((mute_keyboard == 'Mute') and "سکوت" or ((mute_keyboard == 'Enable') and "فعال" or "غیرفعال")))
				locks(chat_id,'⇜ قفل کیبورد شیشه ای',msg_id,'keyboard','MuteSettings:','کیبورد شیشه ای',st, user_first, user_id)
			end
			if CmdMatches == 'keyboardenable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_keyboard:'..chat_id, 'Enable')
				local st = "فعال"
				locks(chat_id,'⇜ قفل کیبورد شیشه ای',msg_id,'keyboard','MuteSettings:','کیبورد شیشه ای',st, user_first, user_id)
			end
			if CmdMatches == 'keyboarddisable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:del(RedisIndex..'mute_keyboard:'..chat_id)
				local st = "غیرفعال"
				locks(chat_id,'⇜ قفل کیبورد شیشه ای',msg_id,'keyboard','MuteSettings:','کیبورد شیشه ای',st, user_first, user_id)
			end
			if CmdMatches == 'keyboardwarn:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_keyboard:'..chat_id, 'Warn')
				local st = "اخطار"
				locks(chat_id,'⇜ قفل کیبورد شیشه ای',msg_id,'keyboard','MuteSettings:','کیبورد شیشه ای',st, user_first, user_id)
			end
			if CmdMatches == 'keyboardmute:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_keyboard:'..chat_id, 'Mute')
				local st = "سکوت"
				locks(chat_id,'⇜ قفل کیبورد شیشه ای',msg_id,'keyboard','MuteSettings:','کیبورد شیشه ای',st, user_first, user_id)
			end
			if CmdMatches == 'keyboardkick:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'mute_keyboard:'..chat_id, 'Kick')
				local st = "اخراج"
				locks(chat_id,'⇜ قفل کیبورد شیشه ای',msg_id,'keyboard','MuteSettings:','کیبورد شیشه ای',st, user_first, user_id)
			end
			if CmdMatches == 'lockjoin:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local chklock = redis:get(RedisIndex..'lock_join:'..chat_id)
				if chklock then
					text = 'قفل ورود غیرفعال شد'
					redis:del(RedisIndex..'lock_join:'..chat_id)
				else
					text = 'قفل ورود فعال شد'
					redis:set(RedisIndex..'lock_join:'..chat_id, 'Enable')
				end
				ShowMsg(Msg.id, Source_Start..text..EndMsg, true)
				SettingsLock(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'lockflood:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local chklock = redis:get(RedisIndex..'lock_flood:'..chat_id)
				if chklock then
					text = 'قفل پیام های مکرر غیرفعال شد'
					redis:del(RedisIndex..'lock_flood:'..chat_id)
				else
					text = 'قفل پیام های مکرر فعال شد'
					redis:set(RedisIndex..'lock_flood:'..chat_id, 'Enable')
				end
				ShowMsg(Msg.id, Source_Start..text..EndMsg, true)
				SettingsSpam(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'lockfloodmod:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local chklock = redis:get(RedisIndex..chat_id..'floodmod')
				if chklock then
					text = 'حالت فلود : اخراج کاربر'
					redis:del(RedisIndex..chat_id..'floodmod')
				else
					text = 'حالت فلود : سکوت کاربر'
					redis:set(RedisIndex..chat_id..'floodmod', "Mute")
				end
				ShowMsg(Msg.id, Source_Start..text..EndMsg, true)
				SettingsSpam(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'lockspam:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local chklock = redis:get(RedisIndex..'lock_spam:'..chat_id)
				if chklock then
					text = 'قفل هرزنامه غیرفعال شد'
					redis:del(RedisIndex..'lock_spam:'..chat_id)
				else
					text = 'قفل هرزنامه فعال شد'
					redis:set(RedisIndex..'lock_spam:'..chat_id, 'Enable')
				end
				ShowMsg(Msg.id, Source_Start..text..EndMsg, true)
				SettingsSpam(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'lockpin:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local chklock = redis:get(RedisIndex..'lock_pin:'..chat_id)
				if chklock then
					text = 'قفل سنجاق کردن غیرفعال شد'
					redis:del(RedisIndex..'lock_pin:'..chat_id)
				else
					text = 'قفل سنجاق کردن فعال شد'
					redis:set(RedisIndex..'lock_pin:'..chat_id, 'Enable')
				end
				ShowMsg(Msg.id, Source_Start..text..EndMsg, true)
				SettingsLock(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'lockbots:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				lock_bots = redis:get(RedisIndex..'lock_bots:'..chat_id)
				Bot = (lock_bots == "Pro") and "اخراج کاربر و ربات" or ((lock_bots == "Enable") and "اخراج ربات" or "غیرفعال")
				SettingsBots(chat_id, msg_id ,Bot, user_first, user_id)
			end
			if CmdMatches == 'lockbotskickbot:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_bots:'..chat_id, 'Enable')
				SettingsBots(chat_id, msg_id, "اخراج ربات", user_first, user_id)
			end
			if CmdMatches == 'lockbotsdisable:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:del(RedisIndex..'lock_bots:'..chat_id)
				SettingsBots(chat_id, msg_id, "غیرفعال", user_first, user_id)
			end
			if CmdMatches == 'lockbotskickuser:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				redis:set(RedisIndex..'lock_bots:'..chat_id, 'Pro')
				SettingsBots(chat_id, msg_id, "اخراج ربات و کاربر", user_first, user_id)
			end
			if CmdMatches == 'welcome:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local chklock = redis:get(RedisIndex..'welcome:'..chat_id)
				if chklock then
					text = 'خوش آمد گویی غیرفعال شد'
					redis:del(RedisIndex..'welcome:'..chat_id)
				else
					text = 'خوش آمد گویی فعال شد'
					redis:set(RedisIndex..'welcome:'..chat_id, 'Enable')
				end
				ShowMsg(Msg.id, Source_Start..text..EndMsg, true)
				SettingsLock(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'muteall:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local chkmute = redis:get(RedisIndex..'mute_all:'..chat_id)
				if chkmute then
					text = 'بیصدا کردن همه غیرفعال شد'
					redis:del(RedisIndex..'mute_all:'..chat_id)
				else
					text = 'بیصدا کردن همه فعال شد'
					redis:set(RedisIndex..'mute_all:'..chat_id, 'Enable')
				end
				ShowMsg(Msg.id, Source_Start..text..EndMsg, true)
				LockSettingsMore(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'mutetgservice:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local chkmute = redis:get(RedisIndex..'mute_tgservice:'..chat_id)
				if chkmute then
					text = 'بیصدا کردن خدمات تلگرام غیرفعال شد'
					redis:del(RedisIndex..'mute_tgservice:'..chat_id)
				else
					text = 'بیصدا کردن خدمات تلگرام فعال شد'
					redis:set(RedisIndex..'mute_tgservice:'..chat_id, 'Enable')
				end
				ShowMsg(Msg.id, Source_Start..text..EndMsg, true)
				SettingsMute(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'locktabchi:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local chkmute = redis:get(RedisIndex..'lock_tabchi:'..chat_id)
				if chkmute then
					text = 'قفل تبچی غیرفعال شد'
					redis:del(RedisIndex..'lock_tabchi:'..chat_id)
				else
					text = 'قفل تبچی فعال شد'
					redis:set(RedisIndex..'lock_tabchi:'..chat_id, 'Enable')
				end
				ShowMsg(Msg.id, Source_Start..text..EndMsg, true)
				SettingsLock(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'Delbot:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local chkmute = redis:get(RedisIndex.."delbot"..chat_id)
				if chkmute then
					text = 'پاکسازی خودکار ربات غیرفعال شد'
					redis:del(RedisIndex..'delbot'..chat_id)
				else
					text = 'پاکسازی خودکار ربات فعال شد'
					redis:set(RedisIndex..'delbot'..chat_id, true)
				end
				ShowMsg(Msg.id, Source_Start..text..EndMsg, true)
				LockSettingsMore(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'delbotup:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local flood_max = redis:get(RedisIndex.."deltimebot"..chat_id) or 60
				if tonumber(flood_max) < 300 then
					flood_max = tonumber(flood_max) + 60
					redis:set(RedisIndex.."deltimebot"..chat_id , flood_max)
					text = "زمان پاکسازی خودکار تنظیم شد : "..flood_max.." ثانیه"
					ShowMsg(Msg.id, Source_Start..text, true)
				end
				LockSettingsMore(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'delbotdown:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local flood_max = redis:get(RedisIndex.."deltimebot"..chat_id) or 60
				if tonumber(flood_max) > 60 then
					flood_max = tonumber(flood_max) - 60
					redis:set(RedisIndex.."deltimebot"..chat_id , flood_max)
					text = "زمان پاکسازی خودکار تنظیم شد : "..flood_max.." ثانیه"
					ShowMsg(Msg.id, Source_Start..text, true)
				end
				LockSettingsMore(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'mutebotup:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local flood_max = redis:get(RedisIndex.."TimeMuteset"..chat_id) or 3600
				if tonumber(flood_max) < 86400 then
					flood_max = tonumber(flood_max) + 600
					redis:set(RedisIndex.."TimeMuteset"..chat_id, flood_max)
					text = "زمان سکوت تنظیم شد : "..flood_max.." ثانیه"
					ShowMsg(Msg.id, Source_Start..text, true)
				end
				LockSettingsMore(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'mutebotdown:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local flood_max = redis:get(RedisIndex.."TimeMuteset"..chat_id) or 3600
				if tonumber(flood_max) > 600 then
					flood_max = tonumber(flood_max) - 600
					redis:set(RedisIndex.."TimeMuteset"..chat_id, flood_max)
					text = "زمان سکوت تنظیم شد : "..flood_max.." ثانیه"
					ShowMsg(Msg.id, Source_Start..text, true)
				end
				LockSettingsMore(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'floodup:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local flood_max = redis:get(RedisIndex..chat_id..'num_msg_max') or 5
				if tonumber(flood_max) < 30 then
					flood_max = tonumber(flood_max) + 1
					redis:set(RedisIndex..chat_id..'num_msg_max', flood_max)
					text = "حساسیت پیام های مکرر تنظیم شد به : "..flood_max
					ShowMsg(Msg.id, Source_Start..text, true)
				end
				SettingsSpam(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'flooddown:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local flood_max = redis:get(RedisIndex..chat_id..'num_msg_max') or 5
				if tonumber(flood_max) > 2 then
					flood_max = tonumber(flood_max) - 1
					redis:set(RedisIndex..chat_id..'num_msg_max', flood_max)
					text = "حساسیت پیام های مکرر تنظیم شد به : "..flood_max
					ShowMsg(Msg.id, Source_Start..text, true)
				end
				SettingsSpam(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'charup:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local char_max = redis:get(RedisIndex..chat_id..'set_char') or 4080
				if tonumber(char_max) < 4080 then
					char_max = tonumber(char_max) + 100
					redis:set(RedisIndex..chat_id..'set_char', char_max)
					text = "تعداد حروف مجاز تنظیم شد به : "..char_max
					ShowMsg(Msg.id, Source_Start..text, true)
				end
				SettingsSpam(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'chardown:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local char_max = redis:get(RedisIndex..chat_id..'set_char') or 4080
				if tonumber(char_max) > 100 then
					char_max = tonumber(char_max) - 100
					redis:set(RedisIndex..chat_id..'set_char', char_max)
					text = "تعداد حروف مجاز تنظیم شد به : "..char_max
					ShowMsg(Msg.id, Source_Start..text, true)
				end
				SettingsSpam(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'floodtimeup:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local check_time = redis:get(RedisIndex..chat_id..'time_check') or 2
				if tonumber(check_time) < 10 then
					check_time = tonumber(check_time) + 1
					redis:set(RedisIndex..chat_id..'time_check', check_time)
					text = "زمان بررسی پیام های مکرر تنظیم شد به : "..check_time
					ShowMsg(Msg.id, Source_Start..text, true)
				end
				SettingsSpam(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'floodtimedown:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local check_time = redis:get(RedisIndex..chat_id..'time_check') or 2
				if tonumber(check_time) > 2 then
					check_time = tonumber(check_time) - 1
					redis:set(RedisIndex..chat_id..'time_check', check_time)
					text = "زمان بررسی پیام های مکرر تنظیم شد به : "..check_time
					ShowMsg(Msg.id, Source_Start..text, true)
				end
				SettingsSpam(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'addlimup:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				getadd = redis:hget(RedisIndex..'addmemset', chat_id) or "1"
				if tonumber(getadd) < 10 then
					redis:hset(RedisIndex..'addmemset', chat_id, getadd + 1)
					text = "تنظیم محدودیت اضافه کردن کاربر به : "..getadd + 1
					ShowMsg(Msg.id, Source_Start..text, true)
				end
				SettingsAdd(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'addlimdown:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				getadd = redis:hget(RedisIndex..'addmemset', chat_id) or "1"
				if tonumber(getadd) > 1 then
					redis:hset(RedisIndex..'addmemset', chat_id, getadd - 1)
					text = "تنظیم محدودیت اضافه کردن کاربر به : "..getadd - 1
					ShowMsg(Msg.id, Source_Start..text, true)
				end
				SettingsAdd(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'addlimlock:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local chkmute = redis:hget(RedisIndex..'addmeminv', chat_id) == "on"
				if chkmute then
					text = "محدودیت اضافه کردن کاربر #غیرفعال شد"
					redis:hset(RedisIndex..'addmeminv', chat_id, 'off')
					redis:del(RedisIndex.."AddMoj:"..chat_id)
				else
					text = "محدودیت اضافه کردن کاربر #فعال شد"
					redis:hset(RedisIndex..'addmeminv', chat_id, 'on')
				end
				ShowMsg(Msg.id, Source_Start..text..EndMsg, true)
				SettingsAdd(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'addpmon:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local chkmute = redis:get(RedisIndex.."addpm"..chat_id)
				if not chkmute then
					text = "ارسال پیام محدودیت کاربر #غیرفعال شد"
					redis:set(RedisIndex..'addpm'..chat_id, true)
				else
					text = "ارسال پیام محدودیت کاربر #فعال شد"
					redis:del(RedisIndex..'addpm'..chat_id)
				end
				ShowMsg(Msg.id, Source_Start..text..EndMsg, true)
				SettingsAdd(chat_id, msg_id, user_first, user_id)
			end
			if CmdMatches == 'ownerlist:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local list = redis:smembers(RedisIndex..'Owners:'..chat_id)
				text = Source_Start..'*لیست مالکین گروه :*\n'
				for k,v in pairs(list) do
					local user_name = redis:get(RedisIndex..'user_name:'..v)
					text = text..k.."- `" ..v.. "` - "..check_markdown(user_name).."\n"
				end
				if #list == 0 then
					text = Source_Start.."`در حال حاضر هیچ مالکی برای گروه انتخاب نشده است`"..EndMsg
				end
				keyboard = {}
				keyboard.inline_keyboard = {
				{
				{text = Source_Start.."برکناری تمام مالکین", callback_data="cleanowners:"..chat_id}
				},
				{
				{text = Source_Start.."بازگشت 🎈", callback_data="MoreSettings:"..chat_id}
				}
				}
				EditInline(text, chat_id, msg_id, "md" ,keyboard)
			end
			if CmdMatches == 'modlist:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local list = redis:smembers(RedisIndex..'Mods:'..chat_id)
				text = Source_Start..'*لیست مدیران گروه :*\n'
				for k,v in pairs(list) do
					local user_name = redis:get(RedisIndex..'user_name:'..v) or "----"
					text = text..k.."- `" ..v.. "` - "..check_markdown(user_name).."\n"
				end
				if #list == 0 then
					text = Source_Start.."`در حال حاضر هیچ مدیری برای گروه انتخاب نشده است`"..EndMsg
				end
				keyboard = {}
				keyboard.inline_keyboard = {
				{
				{text = Source_Start.."برکناری تمام مدیران", callback_data="cleanmods:"..chat_id}
				},
				{
				{text = Source_Start.."بازگشت 🎈", callback_data="MoreSettings:"..chat_id}
				}
				}
				EditInline(text, chat_id, msg_id, "md" ,keyboard)
			end
			if CmdMatches == 'silentlist:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local list = redis:smembers(RedisIndex..'Silentlist:'..chat_id)
				text = Source_Start..'*لیست سکوت گروه :*\n'
				for k,v in pairs(list) do
					local user_name = redis:get(RedisIndex..'user_name:'..v) or "----"
					text = text..k.."- `" ..v.. "` - "..check_markdown(user_name).."\n"
				end
				if #list == 0 then
					text = Source_Start.."`در حال حاضر هیچ کاربری در لیست سکوت گروه وجود ندارد`"..EndMsg
				end
				keyboard = {}
				keyboard.inline_keyboard = {
				{
				{text = Source_Start.."بازگشت 🎈", callback_data="MoreSettings:"..chat_id}
				}
				}
				EditInline(text, chat_id, msg_id, "md" ,keyboard)
			end
			if CmdMatches == 'bans:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local list = redis:smembers(RedisIndex.."Banned:"..chat_id)
				text = Source_Start..'*لیست کاربران محروم شده از گروه :*\n'
				for k,v in pairs(list) do
					local user_name = redis:get(RedisIndex..'user_name:'..v) or "----"
					text = text..k.."- `" ..v.. "` - "..check_markdown(user_name).."\n"
				end
				if #list == 0 then
					text = Source_Start.."*هیچ کاربری از این گروه محروم نشده*"..EndMsg
				end
				keyboard = {}
				keyboard.inline_keyboard = {
				{
				{text = Source_Start.."پاک کردن لیست مسدود ", callback_data="cleanbans:"..chat_id}
				},
				{
				{text = Source_Start.."بازگشت 🎈", callback_data="MoreSettings:"..chat_id}
				}
				}
				EditInline(text, chat_id, msg_id, "md" ,keyboard)
			end
			if CmdMatches == 'whitelists:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local list = redis:smembers(RedisIndex.."Whitelist:"..chat_id)
				text = Source_Start..'`کاربران لیست ویژه :`\n'
				for k,v in pairs(list) do
					local user_name = redis:get(RedisIndex..'user_name:'..v) or "----"
					text = text..k.."- `" ..v.. "` - "..check_markdown(user_name).."\n"
				end
				if #list == 0 then
					text = Source_Start.."*هیچ کاربری در لیست ویژه وجود ندارد*"..EndMsg
				end
				local keyboard = {}
				keyboard.inline_keyboard = {
				{
				{text = Source_Start.."حذف لیست ویژه", callback_data="cleanwhitelists:"..chat_id}
				},
				{
				{text = Source_Start.."بازگشت 🎈", callback_data="MoreSettings:"..chat_id}
				}
				}
				EditInline(text, chat_id, msg_id, "md" ,keyboard)
			end
			if CmdMatches == 'filterlist:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local names = redis:hkeys(RedisIndex..'filterlist:'..chat_id)
				text = Source_Start..'`لیست کلمات فیلتر شده :`\n'
				local b = 1
				for i = 1, #names do
					text = text .. b .. ". " .. names[i] .. "\n"
					b = b + 1
				end
				if #names == 0 then
					text = Source_Start.."`لیست کلمات فیلتر شده خالی است`"..EndMsg
				end
				keyboard = {}
				keyboard.inline_keyboard = {
				{
				{text = Source_Start.."پاک کردن", callback_data="cleanfilterlist:"..chat_id}
				},
				{
				{text = Source_Start.."بازگشت 🎈", callback_data="MoreSettings:"..chat_id}
				}
				}
				EditInline(text, chat_id, msg_id, "md" ,keyboard)
			end
			if CmdMatches == 'rules:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local rules = redis:get(RedisIndex..chat_id..'rules')
				if not rules then
					text = Source_Start.."قوانین ثبت نشده است"..EndMsg
				elseif rules then
					text = Source_Start..'قوانین گروه :\n'..rules
				end
				keyboard = {}
				keyboard.inline_keyboard = {
				{
				{text = Source_Start.."پاک کردن", callback_data="cleanrules:"..chat_id}
				},
				{
				{text = Source_Start.."بازگشت 🎈", callback_data="MoreSettings:"..chat_id}
				}
				}
				EditInline(text, chat_id, msg_id, "md" ,keyboard)
			end
			if CmdMatches == 'showwlc:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local wlc = redis:get(RedisIndex..'welcome:'..chat_id)
				if not wlc then
					text = Source_Start.."پیام خوشامد تنظیم نشده است"..EndMsg
				else
					text = Source_Start..'پیام خوشامد:\n'..wlc
				end
				local keyboard = {}
				keyboard.inline_keyboard = {
				{
				{text = Source_Start.."حذف پیام خوشامد", callback_data="cleanwlcmsg:"..chat_id}
				},
				{
				{text = Source_Start.."بازگشت 🎈", callback_data="MoreSettings:"..chat_id}
				}
				}
				EditInline(text, chat_id, msg_id, "md" ,keyboard)
			end
			if CmdMatches == 'cleanowners:'..chat_id and Ownercheck(Msg, chat_id, user_id, user_first) then
				local list = redis:smembers(RedisIndex..'Owners:'..chat_id)
				if #list == 0 then
					text = Source_Start.."`مالکی برای گروه انتخاب نشده است`"..EndMsg
				else
					redis:del(RedisIndex.."Owners:"..chat_id)
					text = Source_Start.."`تمامی مالکان گروه تنزیل مقام شدند`"..EndMsg
				end
				keyboard = {}
				keyboard.inline_keyboard = {
				{
				{text = Source_Start.."بازگشت 🎈", callback_data="ownerlist:"..chat_id}
				}
				}
				EditInline(text, chat_id, msg_id, "md" ,keyboard)
			end
			if CmdMatches == 'cleanmods:'..chat_id and Ownercheck(Msg, chat_id, user_id, user_first) then
				local list = redis:smembers(RedisIndex..'Mods:'..chat_id)
				if #list == 0 then
					text = Source_Start.."هیچ مدیری برای گروه انتخاب نشده است"..EndMsg
				else
					redis:del(RedisIndex.."Mods:"..chat_id)
					text = Source_Start.."`تمام مدیران گروه تنزیل مقام شدند`"..EndMsg
				end
				keyboard = {}
				keyboard.inline_keyboard = {
				{
				{text = Source_Start.."بازگشت 🎈", callback_data="modlist:"..chat_id}
				}
				}
				EditInline(text, chat_id, msg_id, "md" ,keyboard)
			end
			if CmdMatches == 'cleanbans:'..chat_id and Ownercheck(Msg, chat_id, user_id, user_first) then
				local list = redis:smembers(RedisIndex..'Banned:'..chat_id)
				if #list == 0 then
					text = Source_Start.."*هیچ کاربری از این گروه محروم نشده*"..EndMsg
				else
					redis:del(RedisIndex.."Banned:"..chat_id)
					text = Source_Start.."*تمام کاربران محروم شده از گروه از محرومیت خارج شدند*"..EndMsg
				end
				keyboard = {}
				keyboard.inline_keyboard = {
				{
				{text = Source_Start.."بازگشت 🎈", callback_data="bans:"..chat_id}
				}
				}
				EditInline(text, chat_id, msg_id, "md" ,keyboard)
			end
			if CmdMatches == 'cleanwhitelists:'..chat_id and Ownercheck(Msg, chat_id, user_id, user_first) then
				local list = redis:smembers(RedisIndex..'Whitelist:'..chat_id)
				if #list == 0 then
					text = Source_Start.."*لیست ویژه خالی می باشد*"..EndMsg
				else
					text = Source_Start.."لیست ویژه حذف شد"..EndMsg
					redis:del(RedisIndex.."Whitelist:"..chat_id)
				end
				local keyboard = {}
				keyboard.inline_keyboard = {
				
				{
				{text = Source_Start.."بازگشت 🎈", callback_data="whitelists:"..chat_id}
				}
				}
				EditInline(text, chat_id, msg_id, "md" ,keyboard)
			end
			if CmdMatches == 'cleanfilterlist:'..chat_id and Ownercheck(Msg, chat_id, user_id, user_first) then
				local names = redis:hkeys(RedisIndex..'filterlist:'..chat_id)
				if #names == 0 then
					text = Source_Start.."`لیست کلمات فیلتر شده خالی است`"..EndMsg
				else
					redis:del(RedisIndex..'filterlist:'..chat_id)
					text = Source_Start.."`لیست کلمات فیلتر شده پاک شد`"..EndMsg
				end
				keyboard = {}
				keyboard.inline_keyboard = {
				{
				{text = Source_Start.."بازگشت 🎈", callback_data="filterlist:"..chat_id}
				}
				}
				EditInline(text, chat_id, msg_id, "md" ,keyboard)
			end
			if CmdMatches == 'cleanrules:'..chat_id and Ownercheck(Msg, chat_id, user_id, user_first) then
				local rules = redis:get(RedisIndex..chat_id..'rules')
				if not rules then
					text = Source_Start.."قوانین گروه ثبت نشده"..EndMsg
				else
					text = Source_Start.."قوانین گروه پاک شد"..EndMsg
					redis:del(RedisIndex..chat_id..'rules')
				end
				keyboard = {}
				keyboard.inline_keyboard = {
				{
				{text = Source_Start.."بازگشت 🎈", callback_data="rules:"..chat_id}
				}
				}
				EditInline(text, chat_id, msg_id, "md" ,keyboard)
			end
			if CmdMatches == 'cleanwlcmsg:'..chat_id and Ownercheck(Msg, chat_id, user_id, user_first) then
				local wlc = redis:get(RedisIndex..'welcome:'..chat_id)
				if not wlc then
					text = Source_Start.."پیام خوشامد تنظیم نشده است"..EndMsg
				else
					text = Source_Start..'پیام خوشامد حذف شد'..EndMsg
					redis:del(RedisIndex..'welcome:'..chat_id)
				end
				local keyboard = {}
				keyboard.inline_keyboard = {
				{
				{text = Source_Start.."بازگشت 🎈", callback_data="showwlc:"..chat_id}
				}
				}
				EditInline(text, chat_id, msg_id, "md" ,keyboard)
			end
			if CmdMatches == 'Tabchi:'..chat_id and redis:get(RedisIndex.."usertabchi:"..chat_id..user_id) then
				redis:hdel(RedisIndex..chat_id..':warntabchi', user_id, '0')
				user = '['..user_id..'](tg://user?id='..user_id..')'
				EditInline(Source_Start.."`کاربر` "..user.." - *"..es_name(user_first).."* `شناسای شد`"..EndMsg, chat_id, msg_id, "md")
			end
			if CmdMatches == 'ExitPanel:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				user = '['..user_id..'](tg://user?id='..user_id..')'
				EditInline(Source_Start.."`پنل مدیرتی ربات توسط` "..user.." - *"..es_name(user_first).."* `بسته شد`"..EndMsg, chat_id, msg_id, "md")
			end
			if CmdMatches == 'ExitHelp:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				user = '['..user_id..'](tg://user?id='..user_id..')'
				EditInline(Source_Start.."`پنل راهنمای ربات توسط` "..user.." - *"..es_name(user_first).."* `بسته شد`"..EndMsg, chat_id, msg_id, "md")
			end
			if CmdMatches == 'Manager:'..chat_id and Modcheck(Msg, chat_id, user_id, user_first) then
				local U = '['..es_name(user_first)..'](tg://user?id='..es_name(user_first)..')'
				local keyboard = {}
				keyboard.inline_keyboard = {
				{
				{text = Source_Start..'لینک گروه پشتیبانی 😮', url = ''..link_poshtibani..''}
				},
				{
				{text = Source_Start..'سازنده ربات 🧙‍', url = 'http://t.me/'..sudoinline_username..''},
				{text = Source_Start..'کانال ما 🏷', url = 'http://t.me/'..channel_inline..''}
				},
				{
				{text = Source_Start..'درگاه پرداخت 💵', url = ''..linkpardakht..''}
				},
				{
				{text = Source_Start.."بازگشت 🎈", callback_data = "MenuSettings:"..chat_id}
				}
				}
				EditInline(Source_Start.."`کاربر` "..U.." `به پشتیبانی ربات` *"..chat_id.."* `خوش آمدید`"..EndMsg.."\n\n⌚️ `آخرین بروز رسانی پنل :`\n"..os.date("%H:%M:%S")..""..EndInline, chat_id, msg_id, "md" ,keyboard)
			end
		end
	end
end
while whostart do
	local response = getUpdates(last_update)
	if response then
		for i,v in ipairs(response.result) do
			last_update = v.update_id
			last_update = last_update + 1
			Core(v)
			--function Test1()
			--	Test(v)
			--end
		end
	else
		error(" ربات روشن بود  !")
	end
	for i=1, #response.result do
		local msg = response.result[i]
		last_update = msg.update_id + 1
	end
	--Test1()
end