require('./Core/Utils')
function Core(msg)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	local LuaProFa = msg.content.text
	local LuaProEn = msg.content.text
	local LuaProLw = msg.content.text
	if LuaProLw then
		LuaProLw = LuaProLw:lower()
	end
	if LuaProEn then
		if LuaProEn:match('^[/#!]') then
			LuaProEn = LuaProEn:gsub('^[/#!]','')
		end
	end
	if LuaProLw then
		if LuaProLw:match('^[/#!]') then
			LuaProLw = LuaProLw:gsub('^[/#!]','')
		end
	end
	if tonumber(msg.from.id) == SUDO then
		if LuaProLw == "setsudo" or LuaProFa == "تنظیم سودو" then
			ReplySet(msg,"visudo")
		elseif LuaProLw == "remsudo" or LuaProFa == "حذف سودو" then
			ReplySet(msg,"desudo")
		elseif LuaProFa and (LuaProLw:match('^setsudo (.*)') or LuaProFa:match('^تنظیم سودو (.*)')) then
			local Matches = LuaProLw:match('^setsudo (.*)') or LuaProFa:match('^تنظیم سودو (.*)')
			UseridSet(msg, Matches ,"visudo")
		elseif LuaProFa and (LuaProLw:match('^remsudo (.*)') or LuaProFa:match('^حذف سودو (.*)')) then
			local Matches = LuaProLw:match('^remsudo (.*)') or LuaProFa:match('^حذف سودو (.*)')
			UseridSet(msg, Matches ,"desudo")
		end
	end
	if is_sudo(msg) then
		if LuaProLw == 'reload' or LuaProFa == 'بروز' then
			dofile('./Main.lua')
		elseif LuaProLw == 'reload' or LuaProFa == 'بروز' then
			dofile('./Core/Utils.lua')
		elseif LuaProLw == "setadmin" or LuaProFa == "تنظیم ادمین" then
			ReplySet(msg,"adminprom")
		elseif LuaProLw == "remadmin" or LuaProFa == "حذف ادمین" then
			ReplySet(msg,"admindem")
		elseif LuaProFa and (LuaProLw:match('^setadmin (.*)') or LuaProFa:match('^تنظیم ادمین (.*)')) then
			local Matches = LuaProLw:match('^setadmin (.*)') or LuaProFa:match('^تنظیم ادمین (.*)')
			UseridSet(msg, Matches ,"adminprom")
		elseif LuaProFa and (LuaProLw:match('^remadmin (.*)') or LuaProFa:match('^حذف ادمین (.*)')) then
			local Matches = LuaProLw:match('^remadmin (.*)') or LuaProFa:match('^حذف ادمین (.*)')
			UseridSet(msg, Matches ,"admindem")
		elseif LuaProLw == "sudolist" or LuaProFa == "لیست سودو" then
			return sudolist(msg)
		elseif LuaProLw == "codegift" or LuaProFa == "کدهدیه" then
			local code = {'1','2','3','4','5','6','7','8','9','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'}
			local charge = {2,5,8,10,11,14,16,18,20}
			local a = code[math.random(#code)]
			local b = code[math.random(#code)]
			local c = code[math.random(#code)]
			local d = code[math.random(#code)]
			local e = code[math.random(#code)]
			local f = code[math.random(#code)]
			local chargetext = charge[math.random(#charge)]
			local codetext = ""..a..b..c..d..e..f..""
			redis:sadd(RedisIndex.."CodeGift:", codetext)
			redis:hset(RedisIndex.."CodeGiftt:", codetext , chargetext)
			redis:setex(RedisIndex.."CodeGiftCharge:"..codetext,chargetext * 86400,true)
			local text = Source_Start.."`کد با موفقیت ساخته شد.\nکد :`\n*"..codetext.."*\n`دارای` *"..chargetext.."* `روز شارژ میباشد .`"..EndMsg
			local text2 = Source_Start.."`کدهدیه جدید ساخته شد.`\n`¤ این کدهدیه دارای` *"..chargetext.."* `روز شارژ میباشد !`\n`¤ طرز استفاده :`\n`¤ ابتدا دستور 'gift' راوارد نماید سپس کدهدیه را وارد کنید :`\n*"..codetext.."*\n`رو در گروه خود ارسال کند ,` *"..chargetext.."* `روز شارژ به گروه آن اضافه میشود !`\n`¤¤¤ توجه فقط یک نفر میتواند از این کد استفاده کند !`"..EndMsg
			tdbot.sendMessage(msg.chat_id, msg.id, 1, text, 1, 'md')
			tdbot.sendMessage(gp_sudo, msg.id, 1, text2, 1, 'md')
		elseif LuaProLw == "giftlist" or LuaProFa == "لیست کدهدیه" then
			local list = redis:smembers(RedisIndex.."CodeGift:")
			local text = '*💢 لیست کد هدیه های ساخته شده :*\n'
			for k,v in pairs(list) do
				local expire = redis:ttl(RedisIndex.."CodeGiftCharge:"..v)
				if expire == -1 then
					EXPIRE = "نامحدود"
				else
					local d = math.floor(expire / 86400 ) + 1
					EXPIRE = d..""
				end
				text = text..k.."- `• کدهدیه :`\n[ *"..v.."* ]\n`• شارژ :`\n*"..EXPIRE.."*\n\n❦❧❦❧❦❧❦❧❦❧\n"
			end
			if #list == 0 then
				text = Source_Start..'`هیچ کد هدیه , ساخته نشده است`'..EndMsg
			end
			tdbot.sendMessage(msg.chat_id, msg.id, 1, text, 1, 'md')
		elseif LuaProLw == "full" or LuaProFa == "نامحدود" then
			local linkgp = redis:get(RedisIndex..msg.to.id..'linkgpset')
			local mods = redis:smembers(RedisIndex..'Mods:'..msg.to.id)
			local owners = redis:smembers(RedisIndex..'Owners:'..msg.to.id)
			message = '\n'
			for k,v in pairs(owners) do
				local user_name = redis:get(RedisIndex..'user_name:'..v) or "---"
				message = message ..k.. '- '..check_markdown(user_name)..' [' ..v.. '] \n'
			end
			message2 = '\n'
			for k,v in pairs(mods) do
				local user_name = redis:get(RedisIndex..'user_name:'..v) or "---"
				message2 = message2 ..k.. '- '..check_markdown(user_name)..' [' ..v.. '] \n'
			end
			if not linkgp then
				tdbot.sendMessage(msg.chat_id, msg.id, 1, Source_Start..'`لطفا قبل از شارژ گروه لینک گروه را تنظیم کنید`'..EndMsg..'\n*"تنظیم لینک"\n"setlink"*', 1, 'md')
			else
				redis:set(RedisIndex..'ExpireDate:'..msg.to.id,true)
				if not redis:get(RedisIndex..'CheckExpire::'..msg.to.id) then
					redis:set(RedisIndex..'CheckExpire::'..msg.to.id,true)
				end
				tdbot.sendMessage(gp_sudo, msg.id, 1, "*♨️ گزارش \nگروهی به لیست گروه ای مدیریتی ربات اضافه شد ➕*\n\n🔺 *مشخصات شخص اضافه کننده :*\n\n_>نام ؛_ "..check_markdown(msg.from.first_name or "").."\n_>نام کاربری ؛_ @"..check_markdown(msg.from.username or "").."\n_>شناسه کاربری ؛_ `"..msg.from.id.."`\n\n🔺 *مشخصات گروه اضافه شده :*\n\n_>نام گروه ؛_ "..check_markdown(msg.to.title).."\n_>شناسه گروه ؛_ `"..msg.to.id.."`\n>_مقدار شارژ انجام داده ؛_ `نامحدود !`\n_>لینک گروه ؛_\n"..check_markdown(linkgp).."\n_>لیست مالک گروه ؛_ "..message.."\n_>لیست مدیران گروه؛_ "..message2.."\n\n🔺* دستور های پیشفرض برای گروه :*\n\n_برای وارد شدن به گروه ؛_\n/join `"..msg.to.id.."`\n_حذف گروه از گروه های ربات ؛_\n/rem `"..msg.to.id.."`\n_خارج شدن ربات از گروه ؛_\n/leave `"..msg.to.id.."`", 1, 'md')
				tdbot.sendMessage(msg.to.id, msg.id, 1, Source_Start..'`ربات بدون محدودیت فعال شد !` *( نامحدود )*'..EndMsg, 1, 'md')
			end
		elseif LuaProLw == "time sv" or LuaProFa == "ساعت سرور" then
			tdbot.sendMessage(msg.to.id, msg.id, 1, Source_Start..'`ساعت سرور :`\n'..os.date("%H:%M:%S")..''..EndMsg, 1, 'md')
		elseif LuaProLw == "testspeed" or LuaProFa == "سرعت سرور" then
			local io = io.popen("speedtest --share"):read("*all")
			link = io:match("http://www.speedtest.net/result/%d+.png")
			local file = download_to_file(link,'speed.png')
			tdbot.sendPhoto(msg.to.id, msg.id, file, 0, {}, 0, 0, Source_Start..""..channel_username..""..EndMsg, 0, 0, 1, nil, dl_cb, nil)
		elseif LuaProFa and (LuaProLw:match('^charge (%d+)') or LuaProFa:match('^شارژ (%d+)')) then
			local Matches = LuaProLw:match('^charge (%d+)') or LuaProFa:match('^شارژ (%d+)')
			local linkgp = redis:get(RedisIndex..msg.to.id..'linkgpset')
			local mods = redis:smembers(RedisIndex..'Mods:'..msg.to.id)
			local owners = redis:smembers(RedisIndex..'Owners:'..msg.to.id)
			message = '\n'
			for k,v in pairs(owners) do
				local user_name = redis:get(RedisIndex..'user_name:'..v) or "---"
				message = message ..k.. '- '..check_markdown(user_name)..' [' ..v.. '] \n'
			end
			message2 = '\n'
			for k,v in pairs(mods) do
				local user_name = redis:get(RedisIndex..'user_name:'..v) or "---"
				message2 = message2 ..k.. '- '..check_markdown(user_name)..' [' ..v.. '] \n'
			end
			if not linkgp then
				text = Source_Start..'`لطفا قبل از شارژ گروه لینک گروه را تنظیم کنید`'..EndMsg..'\n*"تنظیم لینک"\n"setlink"*'
				tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
			elseif tonumber(Matches) > 0 and tonumber(Matches) < 1001 then
				local extime = (tonumber(Matches) * 86400)
				redis:setex(RedisIndex..'ExpireDate:'..msg.to.id, extime, true)
				if not redis:get(RedisIndex..'CheckExpire::'..msg.to.id) then
					redis:set(RedisIndex..'CheckExpire::'..msg.to.id)
				end
				tdbot.sendMessage(gp_sudo, msg.id, 1, "*♨️ گزارش \nگروهی به لیست گروه ای مدیریتی ربات اضافه شد ➕*\n\n🔺 *مشخصات شخص اضافه کننده :*\n\n_>نام ؛_ "..check_markdown(msg.from.first_name or "").."\n_>نام کاربری ؛_ @"..check_markdown(msg.from.username or "").."\n_>شناسه کاربری ؛_ `"..msg.from.id.."`\n\n🔺 *مشخصات گروه اضافه شده :*\n\n_>نام گروه ؛_ "..check_markdown(msg.to.title).."\n_>شناسه گروه ؛_ `"..msg.to.id.."`\n>_مقدار شارژ انجام داده ؛_ `"..Matches.."`\n_>لینک گروه ؛_\n"..check_markdown(linkgp).."\n_>لیست مالک گروه ؛_ "..message.."\n_>لیست مدیران گروه؛_ "..message2.."\n\n🔺* دستور های پیشفرض برای گروه :*\n\n_برای وارد شدن به گروه ؛_\n/join `"..msg.to.id.."`\n_حذف گروه از گروه های ربات ؛_\n/rem `"..msg.to.id.."`\n_خارج شدن ربات از گروه ؛_\n/leave `"..msg.to.id.."`", 1, 'md')
				tdbot.sendMessage(msg.to.id, msg.id, 1, Source_Start..'`گروه به مدت` *'..Matches..'* `روز شارژ شد.`'..EndMsg, 1, 'md')
			else
				tdbot.sendMessage(msg.to.id, msg.id, 1, Source_Start..'*تعداد روزها باید عددی از 1 تا 1000 باشد.*'..EndMsg, 1, 'md')
			end
		elseif LuaProFa and LuaProLw:match('^joinch (.*)') then
			local CmdEn = {
			string.match(LuaProLw, "^(joinch) (.*)$")
			}
			if CmdEn[2] == "on" then
				redis:del(RedisIndex.."JoinEnabel"..msg.chat_id)
				text = Source_Start.."`جوین اجباری در این گروه` #فعال `شد.`"..EndMsg
				tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
			elseif CmdEn[2] == "off" then
				redis:set(RedisIndex.."JoinEnabel"..msg.chat_id, true)
				text = Source_Start.."`جوین اجباری در این گروه` #غیرفعال `شد.`"..EndMsg
				tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
			end
		elseif LuaProLw == 'add' or LuaProFa == "نصب" then
			local function CheckAdmin(arg,data)
				if data.status.can_change_info and data.status.can_delete_messages and data.status.can_restrict_members and data.status.can_promote_members and data.status.can_pin_messages then
					if redis:get(RedisIndex.."CheckBot:"..msg.chat_id) then
						Text = Source_Start..'`ربات در` #لیست `گروه ربات از قبل بود`'..EndMsg
						keyboard = {}
						keyboard.inline_keyboard = {
						{
						{text = Source_Start..'کانال ما 📜', url = 'https://t.me/'..channel_inline..''}
						}
						}
					else
						local user = '['..msg.from.id..'](tg://user?id='..msg.from.id..')'
						redis:setex(RedisIndex.."ReqMenu:" .. msg.chat_id .. ":" .. msg.from.id, 260, true)
						Text = Source_Start..'*گروه* '..msg.chat_id..' *به مدت [2] روز شارژ برای تست کامل توسط* '..user..' - '..check_markdown(msg.from.first_name)..' *به لیست گروه های ربات اضافه شد*'..EndMsg
						redis:set(RedisIndex.."CheckBot:"..msg.chat_id ,true)
						redis:set(RedisIndex..'ExpireDate:'..msg.chat_id,true)
						redis:setex(RedisIndex..'ExpireDate:'..msg.chat_id, 172800, true)
						if not redis:get(RedisIndex..'CheckExpire::'..msg.chat_id) then
							redis:set(RedisIndex..'CheckExpire::'..msg.chat_id,true)
						end
						redis:sadd(RedisIndex.."Group" ,msg.chat_id)
						set_config(msg)
						redis:set(RedisIndex.."Gpnameset"..msg.to.id ,msg.to.title)
						local function callback_link (arg, data)
							if data.invite_link then
								redis:set(RedisIndex..msg.to.id..'linkgpset', data.invite_link)
							end
						end
						tdbot.exportChatInviteLink(msg.to.id, callback_link, nil)
						keyboard = {}
						keyboard.inline_keyboard = {
						{
						{text = Source_Start..'شارژ گروه', callback_data = 'charge:'..msg.chat_id},
						},
						}
					end
					SendInlineApi(msg.chat_id, Text, keyboard, 'md')
				else
					change = data.status.can_change_info and '[✓]' or '[✘]'
					delete = data.status.can_delete_messages and '[✓]' or '[✘]'
					restrict =  data.status.can_restrict_members and '[✓]' or '[✘]'
					promote = data.status.can_promote_members and '[✓]' or '[✘]'
					pin = data.status.can_pin_messages and '[✓]' or '[✘]'
					text = Source_Start..'*دسترسی ربات کامل نمیباشد*'..EndMsg..'\n\n'..Source_Start..'*دسترسی های ربات :*\n`اخراج و محدود کردن : '..restrict..'\nتغییر اطلاعات گروه : '..change..'\nارتقا به ادمین : '..promote..'\nسنجاق پیام : '..pin..'\nحذف پیام : '..delete..'`'
				end
				tdbot.sendMessage(msg.chat_id, msg.id, 1, text, 1, 'md')
			end
			tdbot.getChatMember(msg.chat_id, Config.Api_Id, CheckAdmin)
		elseif LuaProLw == 'rem' or LuaProFa == "حذف گروه" then
			if redis:get(RedisIndex..'CheckExpire::'..msg.to.id) then
				redis:del(RedisIndex..'CheckExpire::'..msg.to.id)
			end
			redis:del(RedisIndex..'ExpireDate:'..msg.to.id)
			modrem(msg)
		elseif LuaProFa and (LuaProLw:match('^leave (-%d+)') or LuaProFa:match('^خروج (-%d+)')) then
			local Matches = LuaProLw:match('^leave (-%d+)') or LuaProFa:match('^خروج (-%d+)')
			tdbot.sendMessage(Matches, 0, 1, Source_Start..'ربات با دستور سودو از گروه خارج شد.\nبرای اطلاعات بیشتر با سودو تماس بگیرید.'..EndMsg..'\n`سودو ربات :` '..check_markdown(sudo_username), 1, 'md')
			tdbot.changeChatMemberStatus(Matches, our_id, 'Left', dl_cb, nil)
			tdbot.sendMessage(gp_sudo, msg.id, 1, Source_Start..'ربات با موفقیت از گروه '..Matches..' خارج شد.'..EndMsg..'\nتوسط : @'..check_markdown(msg.from.username or '')..' | `'..msg.from.id..'`', 1,'md')
		elseif LuaProFa and (LuaProLw:match('^rem (-%d+)') or LuaProFa:match('^حذف گروه (-%d+)')) then
			local Matches = LuaProLw:match('^rem (-%d+)') or LuaProFa:match('^حذف گروه (-%d+)')
			tdbot.sendMessage(Matches, 0, 1, Source_Start..'گروه از لیست گروه های مدیرتی ربات خارج شد\nبرای اطلاعات بیشتر با سودو تماس بگیرید.'..EndMsg..'\n`سودو ربات :` '..check_markdown(sudo_username), 1, 'md')
			botrem(msg)
			tdbot.changeChatMemberStatus(Matches, our_id, 'Left', dl_cb, nil)
			tdbot.sendMessage(gp_sudo, msg.id, 1, Source_Start..'ربات با موفقیت از گروه '..Matches..' لغو نصب شد'..EndMsg..'\nتوسط : @'..check_markdown(msg.from.username or '')..' | `'..msg.from.id..'`', 1,'md')
		elseif LuaProFa and (LuaProLw:match('^charge (-%d+) (%d+)') or LuaProFa:match('^شارژ (-%d+) (%d+)')) then
			local Matches = LuaProLw:match('^charge (-%d+)') or LuaProFa:match('^شارژ (-%d+)')
			local Matches2 = LuaProLw:match('^charge (-%d+) (%d+)') or LuaProFa:match('^شارژ (-%d+) (%d+)')
			if string.match(Matches, '^-%d+$') then
				if tonumber(Matches2) > 0 and tonumber(Matches2) < 1001 then
					local extime = (tonumber(Matches2) * 86400)
					redis:setex(RedisIndex..'ExpireDate:'..Matches, extime, true)
					if not redis:get(RedisIndex..'CheckExpire::'..msg.to.id) then
						redis:set(RedisIndex..'CheckExpire::'..msg.to.id,true)
					end
					tdbot.sendMessage(gp_sudo, 0, 1, "*♨️ گزارش \nگروهی به لیست گروه ای مدیریتی ربات اضافه شد ➕*\n\n🔺 *مشخصات شخص اضافه کننده :*\n\n_>نام ؛_ "..check_markdown(msg.from.first_name or "").."\n_>نام کاربری ؛_ @"..check_markdown(msg.from.username or "").."\n_>شناسه کاربری ؛_ `"..msg.from.id.."`\n\n🔺 *مشخصات گروه اضافه شده :*\n\n_>نام گروه ؛_ "..check_markdown(msg.to.title).."\n_>شناسه گروه ؛_ `"..Matches.."`\n>_مقدار شارژ انجام داده ؛_ `"..Matches2.."`\n🔺* دستور های پیشفرض برای گروه :*\n\n_برای وارد شدن به گروه ؛_\n/join `"..Matches.."`\n_حذف گروه از گروه های ربات ؛_\n/rem `"..Matches.."`\n_خارج شدن ربات از گروه ؛_\n/leave `"..Matches.."`", 1, 'md')
					tdbot.sendMessage(Matches, 0, 1, Source_Start..'ربات توسط ادمین به مدت `'..Matches2..'` روز شارژ شد\nبرای مشاهده زمان شارژ گروه دستور /expire استفاده کنید...'..EndMsg,1 , 'md')
				else
					tdbot.sendMessage(msg.to.id, msg.id, 1, Source_Start..'*تعداد روزها باید عددی از 1 تا 1000 باشد.*'..EndMsg, 1, 'md')
				end
			end
		elseif LuaProFa and (LuaProLw:match('^setforward (.*)') or LuaProFa:match('^تنظیم فوروارد (.*)')) and msg.reply_id then
			local Matches = LuaProLw:match('^setforward (.*)') or LuaProFa:match('^تنظیم فوروارد (.*)')
			if redis:get(RedisIndex.."ForwardMsg_Cmd"..Matches) then
				tdbot.sendMessage(msg.chat_id , msg.id, 1, "*دستور* `'"..Matches.."'` *از قبل در لیست فوروارد وجود داشت*", 0, 'md')
			end
			redis:set(RedisIndex.."ForwardMsg_Cmd"..Matches, Matches)
			redis:set(RedisIndex..'ForwardMsg_Reply'..Matches, msg.reply_id)
			redis:set(RedisIndex..'ForwardMsg_Gp'..Matches, msg.chat_id)
			redis:sadd(RedisIndex.."ForwardMsg_List", Matches)
			tdbot.sendMessage(msg.chat_id , msg.id, 1, "*پیامی که روی آن ریپلای کردید توسط* `"..msg.from.id.."` - @"..check_markdown(msg.from.username or '').." *روی دستور* `'"..Matches.."'` *تنظیم شد*", 0, 'md')
		elseif LuaProFa and (LuaProLw:match('^delforward (.*)') or LuaProFa:match('^حذف فوروارد (.*)')) then
			local Matches = LuaProLw:match('^delforward (.*)') or LuaProFa:match('^حذف فوروارد (.*)')
			if not redis:get(RedisIndex.."ForwardMsg_Cmd"..Matches) then
				tdbot.sendMessage(msg.chat_id , msg.id, 1, "*دستور* `'"..Matches.."'` *در لیست فوروارد وجود ندارد*", 0, 'md')
			end
			redis:del(RedisIndex.."ForwardMsg_Cmd"..Matches)
			redis:del(RedisIndex..'ForwardMsg_Reply'..Matches)
			redis:del(RedisIndex..'ForwardMsg_Gp'..Matches)
			redis:srem(RedisIndex.."ForwardMsg_List", Matches)
			tdbot.sendMessage(msg.chat_id , msg.id, 1, "*دستور* `'"..Matches.."'` *توسط* `"..msg.from.id.."` - @"..check_markdown(msg.from.username or '').." *از لیست فوروارد حذف شد*", 0, 'md')
		elseif LuaProLw == "forwardlist" or LuaProFa == "لیست فوروارد" then
			forwardlist(msg)
		end
	end
	if LuaProFa and (LuaProLw:match('^clean (.*)') or LuaProFa:match('^پاکسازی (.*)')) and is_JoinChannel(msg) then
		local CmdEn = {
		string.match(LuaProLw, "^(clean) (.*)$")
		}
		local CmdFa = {
		string.match(LuaProFa, "^(پاکسازی) (.*)$")
		}
		if is_sudo(msg) then
			if CmdEn[2] == 'gbans' or CmdFa[2] == 'لیست سوپر مسدود' then
				local list = redis:smembers(RedisIndex..'GBanned')
				if #list == 0 then
					text = Source_Start.."*هیچ کاربری از گروه های ربات محروم نشده*"..EndMsg
					tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
				end
				redis:del(RedisIndex..'GBanned')
				text = Source_Start.."*تمام کاربرانی که از گروه های ربات محروم بودند از محرومیت خارج شدند*"..EndMsg
				tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
			end
		end
		if is_admin(msg) then
			if CmdEn[2] == 'owners' or CmdFa[2] == "مالکان" then
				local list = redis:smembers(RedisIndex..'Owners:'..msg.to.id)
				if #list == 0 then
					text = Source_Start.."`مالکی برای گروه انتخاب نشده است`"..EndMsg
					tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
				end
				redis:del(RedisIndex.."Owners:"..msg.to.id)
				text = Source_Start.."`تمامی مالکان گروه تنزیل مقام شدند`"..EndMsg
				tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
			end
		end
		if is_owner(msg) then
			if msg.to.type == "channel" then
				if CmdEn[2] == 'bots' or CmdFa[2] == 'ربات ها' then
					local function GetBots(arg, data)
						if data.members then
							for k,v in pairs (data.members) do
								if not is_mod1(msg.to.id, v.user_id) then
									kick_user(v.user_id, msg.to.id)
								end
							end
						end
					end
					for i = 1, 5 do
						tdbot.getChannelMembers(msg.to.id, 0, 100000000000, 'Bots', GetBots, {msg=msg})
					end
					return tdbot.sendMessage(msg.to.id, msg.id, 0, Source_Start.."`تمام ربات ها از گروه حذف شدند`"..EndMsg, 0, "md")
				elseif CmdEn[2] == 'deleted' or CmdFa[2] == 'اکانت های دلیت شده' then
					local function GetDeleted(arg, data)
						if data.members then
							for k,v in pairs (data.members) do
								local function GetUser(arg, data)
									if data.type and data.type._ == "userTypeDeleted" then
										kick_user(data.id, msg.to.id)
									end
								end
								tdbot.getUser(v.user_id, GetUser, {msg=arg.msg})
							end
						end
					end
					for i = 1, 2 do
						tdbot.getChannelMembers(msg.to.id, 0, 100000000000, 'Recent', GetDeleted, {msg=msg})
					end
					for i = 1, 1 do
						tdbot.getChannelMembers(msg.to.id, 0, 100000000000, 'Search', GetDeleted, {msg=msg})
					end
					return tdbot.sendMessage(msg.to.id, msg.id, 0, Source_Start.."`تمام اکانت های دلیت ‌شده از گروه حذف شدند`"..EndMsg, 0, "md")
				end
			end
			if msg.to.type ~= 'pv' then
				if CmdEn[2] == 'bans' or CmdFa[2] == 'لیست مسدود' then
					local list = redis:smembers(RedisIndex..'Banned:'..msg.to.id)
					if #list == 0 then
						text = Source_Start.."*هیچ کاربری از این گروه محروم نشده*"..EndMsg
						tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
					end
					redis:del(RedisIndex.."Banned:"..msg.to.id)
					text = Source_Start.."*تمام کاربران محروم شده از گروه از محرومیت خارج شدند*"..EndMsg
					tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
				elseif CmdEn[2] == 'silentlist' or CmdFa[2] == 'لیست سکوت' then
					local function GetRestricted(arg, data)
						msg=arg.msg
						local i = 1
						local un = ''
						if data.total_count > 0 then
							i = 1
							k = 0
							local function getuser(arg, mdata)
								local ST = data.members[k].status
								if ST.can_add_web_page_previews == false and ST.can_send_media_messages == false and ST.can_send_messages == false and ST.can_send_other_messages == false and ST.is_member == true then
									unsilent_user(msg.to.id, data.members[k].user_id)
									i = i + 1
								end
								k = k + 1
								if k < data.total_count then
									tdbot.getUser(data.members[k].user_id, getuser, nil)
								else
									if i == 1 then
										return tdbot.sendMessage(msg.to.id, msg.id, 0, "*لیست کاربران سایلنت شده خالی است*", 0, "md")
									else
										return tdbot.sendMessage(msg.to.id, msg.id, 0, "*لیست کاربران سایلنت شده پاک شد*", 0, "md")
									end
								end
							end
							tdbot.getUser(data.members[k].user_id, getuser, nil)
						else
							return tdbot.sendMessage(msg.to.id, msg.id, 0, "*لیست کاربران سایلنت شده خالی است*", 0, "md")
						end
					end
					tdbot.getChannelMembers(msg.to.id, 0, 100000, 'Restricted', GetRestricted, {msg=msg})
				end
			end
			if CmdEn[2] == 'filterlist' or CmdFa[2] == "لیست فیلتر" then
				local names = redis:hkeys(RedisIndex..'filterlist:'..msg.to.id)
				if #names == 0 then
					text = Source_Start.."`لیست کلمات فیلتر شده خالی است`"..EndMsg
					tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
				end
				redis:del(RedisIndex..'filterlist:'..msg.to.id)
				text = Source_Start.."`لیست کلمات فیلتر شده پاک شد`"..EndMsg
				tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
			elseif CmdEn[2] == 'rules' or CmdFa[2] == "قوانین" then
				if not redis:get(RedisIndex..msg.to.id..'rules')then
					text = Source_Start.."`قوانین برای گروه ثبت نشده است`"..EndMsg
					tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
				end
				redis:del(RedisIndex..msg.to.id..'rules')
				text = Source_Start.."`قوانین گروه پاک شد`"
				tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
			elseif CmdEn[2] == 'welcome' or CmdFa[2] == "خوشامد" then
				if not redis:get(RedisIndex..'setwelcome:'..msg.chat_id) then
					text = Source_Start.."`پیام خوشآمد گویی ثبت نشده است`"..EndMsg
					tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
				end
				redis:del(RedisIndex..'setwelcome:'..msg.chat_id)
				text = Source_Start.."`پیام خوشآمد گویی پاک شد`"
				tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
			elseif  CmdEn[2] == 'warns' or CmdFa[2] == 'اخطار ها' then
				local hash = msg.to.id..':warn'
				redis:del(RedisIndex..hash)
				text = Source_Start.."`تمام اخطار های کاربران این گروه پاک شد`"..EndMsg
				tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
			end
		end
	end
	if is_admin(msg) then
		if LuaProLw == "gban" or LuaProFa == "سوپر مسدود" then
			ReplySet(msg,"banall")
		elseif LuaProLw == "ungban" or LuaProFa == "حذف سوپر مسدود" then
			ReplySet(msg,"unbanall")
		elseif LuaProLw == "setowner" or LuaProFa == 'مالک' then
			ReplySet(msg,"setowner")
		elseif LuaProLw == "remowner" or LuaProFa == "حذف مالک" then
			ReplySet(msg,"remowner")
		elseif LuaProFa and (LuaProLw:match('^gban (.*)') or LuaProFa:match('^سوپر مسدود (.*)')) then
			local Matches = LuaProLw:match('^gban (.*)') or LuaProFa:match('^سوپر مسدود (.*)')
			UseridSet(msg, Matches ,"banall")
		elseif LuaProFa and (LuaProLw:match('^ungban (.*)') or LuaProFa:match('^حذف سوپر مسدود (.*)')) then
			local Matches = LuaProLw:match('^ungban (.*)') or LuaProFa:match('^حذف سوپر مسدود (.*)')
			UseridSet(msg, Matches ,"unbanall")
		elseif LuaProFa and (LuaProLw:match('^setowner (.*)') or LuaProFa:match('^مالک (.*)')) then
			local Matches = LuaProLw:match('^setowner (.*)') or LuaProFa:match('^مالک (.*)')
			UseridSet(msg, Matches ,"setowner")
		elseif LuaProFa and (LuaProLw:match('^remowner (.*)') or LuaProFa:match('^حذف مالک (.*)')) then
			local Matches = LuaProLw:match('^remowner (.*)') or LuaProFa:match('^حذف مالک (.*)')
			UseridSet(msg, Matches ,"remowner")
		elseif LuaProLw == "adminlist" or LuaProFa == "لیست ادمین" then
			return adminlist(msg)
		elseif LuaProLw == "leave" or LuaProFa == "خروج" then
			tdbot.sendMessage(msg.to.id, msg.id, 1, Source_Start..'`ربات با موفقیت از گروه خارج شد.`'..EndMsg, 1,'md')
			tdbot.changeChatMemberStatus(msg.to.id, our_id, 'Left', dl_cb, nil)
		elseif LuaProLw == "chats" or LuaProFa == "لیست گروه ها" then
			return chat_list(msg)
		elseif LuaProLw == "config" or LuaProFa == "پیکربندی" then
			redis:setex(RedisIndex.."ConfigAdd"..msg.chat_id, 10, true)
			return set_config(msg)
		elseif LuaProFa and LuaProEn:match('^[Ss][Ee][Tt][Rr][Aa][Nn][Kk] (.*)')  then
			if msg.reply_id then
				assert (tdbot_function ({
				_ = "getMessage",
				chat_id = msg.to.id,
				message_id = msg.reply_id
				}, action_by_reply, {chat_id=msg.to.id,cmd="setrank",rank=string.sub(msg.text,9)}))
			end
		elseif LuaProFa and LuaProFa:match('^تنظیم مقام (.*)') then
			if msg.reply_id then
				assert (tdbot_function ({
				_ = "getMessage",
				chat_id = msg.to.id,
				message_id = msg.reply_id
				}, action_by_reply, {chat_id=msg.to.id,cmd="setrank",rank=string.sub(msg.text,21)}))
			end
		elseif LuaProLw == "delrank" or LuaProFa == "حذف مقام" then
			if msg.reply_id then
				assert (tdbot_function ({
				_ = "getMessage",
				chat_id = msg.to.id,
				message_id = msg.reply_id
				}, action_by_reply, {chat_id=msg.to.id,cmd="delrank"}))
			end
		elseif LuaProFa and (LuaProLw:match('^autoleave (.*)') or LuaProFa:match('^خروج خودکار (.*)')) then
			local CmdEn = {
			string.match(LuaProLw, "^(autoleave) (.*)$")
			}
			local CmdFa = {
			string.match(LuaProFa, "^(خروج خودکار) (.*)$")
			}
			local hash = 'auto_leave_bot'
			if CmdEn[2] == 'enable' or CmdFa[2] == "فعال" then
				redis:del(RedisIndex..hash)
				text = Source_Start..'*خروج خودکار فعال شد*'..EndMsg
				tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
			elseif CmdEn[2] == 'disable' or CmdFa[2] == "غیرفعال" then
				redis:set(RedisIndex..hash, true)
				text = Source_Start..'*خروج خودکار غیرفعال شد*'..EndMsg
				tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
			end
		elseif LuaProFa and (LuaProLw:match('^expire (-%d+)') or LuaProFa:match('^اعتبار (-%d+)')) then
			local Matches = LuaProLw:match('^expire (-%d+)') or LuaProFa:match('^اعتبار (-%d+)')
			if string.match(Matches, '^-%d+$') then
				local check_time = redis:ttl(RedisIndex..'ExpireDate:'..Matches)
				year = math.floor(check_time / 31536000)
				byear = check_time % 31536000
				month = math.floor(byear / 2592000)
				bmonth = byear % 2592000
				day = math.floor(bmonth / 86400)
				bday = bmonth % 86400
				hours = math.floor( bday / 3600)
				bhours = bday % 3600
				min = math.floor(bhours / 60)
				sec = math.floor(bhours % 60)
				if check_time == -1 then
					remained_expire = Source_Start..'`گروه به صورت نامحدود شارژ میباشد!`'..EndMsg
				elseif tonumber(check_time) > 1 and check_time < 60 then
					remained_expire = Source_Start..'`گروه به مدت` *'..sec..'* `ثانیه شارژ میباشد`'..EndMsg
				elseif tonumber(check_time) > 60 and check_time < 3600 then
					remained_expire = Source_Start..'`گروه به مدت` *'..min..'* `دقیقه و` *'..sec..'* _ثانیه شارژ میباشد`'..EndMsg
				elseif tonumber(check_time) > 3600 and tonumber(check_time) < 86400 then
					remained_expire = Source_Start..'`گروه به مدت` *'..hours..'* `ساعت و` *'..min..'* `دقیقه و` *'..sec..'* `ثانیه شارژ میباشد`'..EndMsg
				elseif tonumber(check_time) > 86400 and tonumber(check_time) < 2592000 then
					remained_expire = Source_Start..'`گروه به مدت` *'..day..'* `روز و` *'..hours..'* `ساعت و` *'..min..'* `دقیقه و` *'..sec..'* `ثانیه شارژ میباشد`'..EndMsg
				elseif tonumber(check_time) > 2592000 and tonumber(check_time) < 31536000 then
					remained_expire = Source_Start..'`گروه به مدت` *'..month..'* `ماه` *'..day..'* `روز و` *'..hours..'* `ساعت و` *'..min..'* `دقیقه و` *'..sec..'* `ثانیه شارژ میباشد`'..EndMsg
				elseif tonumber(check_time) > 31536000 then
					remained_expire = Source_Start..'`گروه به مدت` *'..year..'* `سال` *'..month..'* `ماه` *'..day..'* `روز و` *'..hours..'* `ساعت و` *'..min..'* `دقیقه و` *'..sec..'* `ثانیه شارژ میباشد`'..EndMsg
				end
				tdbot.sendMessage(msg.to.id, msg.id, 1, remained_expire, 1, 'md')
			end
		elseif LuaProLw == "gbanlist" or LuaProFa == "لیست سوپر مسدود" then
			return gbanned_list(msg)
		end
	end
	if is_owner(msg) and redis:get(RedisIndex.."CheckBot:"..msg.to.id) then
		if msg.text then
			local is_link = msg.text:match("^([https?://w]*.?telegram.me/joinchat/%S+)$") or msg.text:match("^([https?://w]*.?t.me/joinchat/%S+)$")
			if is_link and redis:get(RedisIndex..msg.to.id..'linkgp') then
				redis:set(RedisIndex..msg.to.id..'linkgpset', msg.text)
				text = Source_Start.."`لینک جدید ذخیره شد`"..EndMsg
				tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
			end
		end
		if (LuaProLw == "promote" or LuaProFa == "مدیر") and is_JoinChannel(msg) then
			ReplySet(msg,"promote")
		elseif (LuaProLw == "demote" or LuaProFa == "حذف مدیر") and is_JoinChannel(msg) then
			ReplySet(msg,"demote")
		elseif LuaProFa and (LuaProEn:match('^[Ss][Ee][Tt][Cc][Hh][Aa][Nn][Nn][Ee][Ll] (@.*)') or LuaProFa:match('^تنظیم کانال (@.*)')) and is_JoinChannel(msg) then
			local Matches = LuaProEn:match('^[Ss][Ee][Tt][Cc][Hh][Aa][Nn][Nn][Ee][Ll] (@.*)') or LuaProFa:match('^تنظیم کانال (@.*)')
			ChannelId = string.gsub(Matches, '@', "")
			redis:set(RedisIndex.."JoinChannelPub:"..msg.chat_id, ChannelId)
			tdbot.sendMessage(msg.chat_id , msg.id, 1, Source_Start.."`کانال` "..check_markdown(Matches).." `توسط` "..msg.from.id.." - "..check_markdown(msg.from.first_name).." `تنظیم شد`"..EndMsg, 0, 'md')
		elseif LuaProFa and (LuaProLw:match('^joinchannel (.*)') or LuaProFa:match('^عضویت اجباری (.*)')) and is_JoinChannel(msg) then
			local Ch = redis:get(RedisIndex.."JoinChannelPub:"..msg.chat_id)
			local CmdEn = {
			string.match(LuaProLw, "^(joinchannel) (.*)$")
			}
			local CmdFa = {
			string.match(LuaProFa, "^(عضویت اجباری) (.*)$")
			}
			if CmdEn[2] == "on" or CmdFa[2] == "فعال" then
				if Ch then
					redis:set(RedisIndex.."JoinChPub:"..msg.chat_id, true)
					tdbot.sendMessage(msg.chat_id , msg.id, 1, Source_Start.."`عضویت اجباری کانل توسط` "..msg.from.id.." - "..check_markdown(msg.from.first_name).." `برای کانال` @"..check_markdown(Ch).." `فعال شد`\n\n`توجه داشته باشید که باید ربات` @"..check_markdown(Bot_inline).." `را در کانال` @"..check_markdown(Ch).." `ادمین کنید در غیر این صورت این دستور به درستی کار نخواهد کرد`"..EndMsg, 0, 'md')
				else
					tdbot.sendMessage(msg.chat_id , msg.id, 1, Source_Start.."_لطفا ابتدا کانال خود را تنظیم کنید_"..EndMsg.."\n*برای مثال :*\n' `Setchannel` "..check_markdown(channel_username).." '\n' `تنظیم کانال` "..check_markdown(channel_username).." '", 0, 'md')
				end
			elseif CmdEn[2] == "off" or CmdFa[2] == "غیرفعال" then
				if Ch then
					redis:del(RedisIndex.."JoinChannelPub:"..msg.chat_id)
				end
				redis:del(RedisIndex.."ChMoj:"..msg.chat_id)
				redis:del(RedisIndex.."JoinChPub:"..msg.chat_id)
				tdbot.sendMessage(msg.chat_id , msg.id, 1, Source_Start.."`عضویت اجباری کانل توسط` "..msg.from.id.." - "..check_markdown(msg.from.first_name).."  `غیرفعال شد`"..EndMsg, 0, 'md')
			end
		elseif LuaProLw == "پشتیبانی" and is_JoinChannel(msg) then
			tdbot.sendMessage(msg.chat_id , msg.id, 1, Source_Start.."در خواست پشتیبانی شما ارسال شد..."..EndMsg, 0, 'md')
			tdbot.sendMessage(SUDO , 0, 1, "*گروه :* `"..msg.chat_id.."` *درخواست پشتیبانی دارد*\n*برای ورود از لینک زیر استفاده کنید*\n*لینک :* "..check_markdown(redis:get(RedisIndex..msg.to.id..'linkgpset')).."", 0, 'md')
		elseif LuaProFa and (LuaProLw:match('^promote (.*)') or LuaProFa:match('^مدیر (.*)')) and is_JoinChannel(msg) then
			local Matches = LuaProLw:match('^promote (.*)') or LuaProFa:match('^مدیر (.*)')
			UseridSet(msg, Matches ,"promote")
		elseif LuaProFa and (LuaProLw:match('^demote (.*)') or LuaProFa:match('^حذف مدیر (.*)')) and is_JoinChannel(msg) then
			local Matches = LuaProLw:match('^demote (.*)') or LuaProFa:match('^حذف مدیر (.*)')
			UseridSet(msg, Matches ,"demote")
		elseif (LuaProLw == 'setlink' or LuaProFa == "تنظیم لینک") and is_JoinChannel(msg) then
			redis:setex(RedisIndex..msg.to.id..'linkgp', 60, true)
			text = Source_Start..'`لطفا لینک گروه خود را ارسال کنید`'..EndMsg
			tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
		elseif LuaProFa and (LuaProLw:match('^setmute (%d+)') or LuaProFa:match('^تنظیم سکوت (%d+)')) and is_JoinChannel(msg) then
			local Matches = LuaProLw:match('^setmute (%d+)') or LuaProFa:match('^تنظیم سکوت (%d+)')
			local time = Matches * 60
			redis:set(RedisIndex.."TimeMuteset"..msg.to.id, time)
			text = Source_Start.."`زمان سکوت روی` *"..Matches.."* `دقیقه تنظیم شد`"..EndMsg
			tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
		elseif LuaProLw == "expire" or LuaProFa == "اعتبار" and msg.to.type == 'channel' or msg.to.type == 'chat' then
			local check_time = redis:ttl(RedisIndex..'ExpireDate:'..msg.to.id)
			year = math.floor(check_time / 31536000)
			byear = check_time % 31536000
			month = math.floor(byear / 2592000)
			bmonth = byear % 2592000
			day = math.floor(bmonth / 86400)
			bday = bmonth % 86400
			hours = math.floor( bday / 3600)
			bhours = bday % 3600
			min = math.floor(bhours / 60)
			sec = math.floor(bhours % 60)
			if check_time == -1 then
				remained_expire = Source_Start..'`گروه به صورت نامحدود شارژ میباشد!`'..EndMsg
			elseif tonumber(check_time) > 1 and check_time < 60 then
				remained_expire = Source_Start..'`گروه به مدت` *'..sec..'* `ثانیه شارژ میباشد`'..EndMsg
			elseif tonumber(check_time) > 60 and check_time < 3600 then
				remained_expire = Source_Start..'`گروه به مدت` *'..min..'* `دقیقه و` *'..sec..'* _ثانیه شارژ میباشد`'..EndMsg
			elseif tonumber(check_time) > 3600 and tonumber(check_time) < 86400 then
				remained_expire = Source_Start..'`گروه به مدت` *'..hours..'* `ساعت و` *'..min..'* `دقیقه و` *'..sec..'* `ثانیه شارژ میباشد`'..EndMsg
			elseif tonumber(check_time) > 86400 and tonumber(check_time) < 2592000 then
				remained_expire = Source_Start..'`گروه به مدت` *'..day..'* `روز و` *'..hours..'* `ساعت و` *'..min..'* `دقیقه و` *'..sec..'* `ثانیه شارژ میباشد`'..EndMsg
			elseif tonumber(check_time) > 2592000 and tonumber(check_time) < 31536000 then
				remained_expire = Source_Start..'`گروه به مدت` *'..month..'* `ماه` *'..day..'* `روز و` *'..hours..'* `ساعت و` *'..min..'* `دقیقه و` *'..sec..'* `ثانیه شارژ میباشد`'..EndMsg
			elseif tonumber(check_time) > 31536000 then
				remained_expire = Source_Start..'`گروه به مدت` *'..year..'* `سال` *'..month..'* `ماه` *'..day..'* `روز و` *'..hours..'* `ساعت و` *'..min..'* `دقیقه و` *'..sec..'* `ثانیه شارژ میباشد`'..EndMsg
			end
			tdbot.sendMessage(msg.to.id, msg.id, 1, remained_expire, 1, 'md')
		elseif (LuaProLw == "gift" or LuaProFa == "استفاده هدیه") and is_JoinChannel(msg) then
			redis:setex(RedisIndex.."Codegift:" .. msg.to.id , 260, true)
			tdbot.sendMessage(msg.chat_id, msg.id, 1, Source_Start.."`شما دو دقیقه برای استفاده از کدهدیه زمان دارید.`"..EndMsg, 1, 'md')
		end
	end
	if is_mod(msg) and redis:get(RedisIndex.."CheckBot:"..msg.to.id) then
		if msg.to.type ~= 'pv' then
			if (LuaProLw == "kick" or LuaProFa == "اخراج") and is_JoinChannel(msg) then
				ReplySet(msg,"kick")
			elseif (LuaProLw == "ban" or LuaProFa == "مسدود") and is_JoinChannel(msg) then
				ReplySet(msg,"ban")
			elseif (LuaProLw == "unban" or LuaProFa == "حذف مسدود") and is_JoinChannel(msg) then
				ReplySet(msg,"unban")
			elseif (LuaProLw == "mute" or LuaProFa == "سکوت") and is_JoinChannel(msg) then
				ReplySet(msg,"silent")
			elseif (LuaProLw == "unmute" or LuaProFa == "حذف سکوت") and is_JoinChannel(msg) then
				ReplySet(msg,"unsilent")
			elseif LuaProFa and (LuaProLw:match('^kick (.*)') or LuaProFa:match('^اخراج (.*)')) and is_JoinChannel(msg) then
				local Matches = LuaProLw:match('^kick (.*)') or LuaProFa:match('^اخراج (.*)')
				UseridSet(msg, Matches ,"kick")
			elseif LuaProFa and (LuaProLw:match('^ban (.*)') or LuaProFa:match('^مسدود (.*)')) and is_JoinChannel(msg) then
				local Matches = LuaProLw:match('^ban (.*)') or LuaProFa:match('^مسدود (.*)')
				UseridSet(msg, Matches ,"ban")
			elseif LuaProFa and (LuaProLw:match('^unban (.*)') or LuaProFa:match('^حذف مسدود (.*)')) and is_JoinChannel(msg) then
				local Matches = LuaProLw:match('^unban (.*)') or LuaProFa:match('^حذف مسدود (.*)')
				UseridSet(msg, Matches ,"unban")
			elseif LuaProFa and (LuaProLw:match('^mute (.*)') or LuaProFa:match('^سکوت (.*)')) and is_JoinChannel(msg) then
				local Matches = LuaProLw:match('^mute (.*)') or LuaProFa:match('^سکوت (.*)')
				UseridSet(msg, Matches ,"silent")
			elseif LuaProFa and (LuaProLw:match('^unmute (.*)') or LuaProFa:match('^حذف سکوت (.*)')) and is_JoinChannel(msg) then
				local Matches = LuaProLw:match('^unmute (.*)') or LuaProFa:match('^حذف سکوت (.*)')
				UseridSet(msg, Matches ,"unsilent")
			end
		end
		if (LuaProLw == "setvip" or LuaProFa == "ویژه") and is_JoinChannel(msg) then
			ReplySet(msg,"setwhitelist")
		elseif (LuaProLw == "remvip" or LuaProFa == "حذف ویژه") and is_JoinChannel(msg) then
			ReplySet(msg,"remwhitelist")
		elseif (LuaProLw == "warn" or LuaProFa == "اخطار") and is_JoinChannel(msg) then
			ReplySet(msg,"warn")
		elseif (LuaProLw == "unwarn" or LuaProFa == "حذف اخطار") and is_JoinChannel(msg) then
			ReplySet(msg,"unwarn")
		elseif LuaProFa and (LuaProLw:match('^setvip (.*)') or LuaProFa:match('^ویژه (.*)')) and is_JoinChannel(msg) then
			local Matches = LuaProLw:match('^setvip (.*)') or LuaProFa:match('^ویژه (.*)')
			UseridSet(msg, Matches ,"setwhitelist")
		elseif LuaProFa and (LuaProLw:match('^remvip (.*)') or LuaProFa:match('^حذف ویژه (.*)')) and is_JoinChannel(msg) then
			local Matches = LuaProLw:match('^remvip (.*)') or LuaProFa:match('^حذف ویژه (.*)')
			UseridSet(msg, Matches ,"remwhitelist")
		elseif LuaProFa and (LuaProLw:match('^warn (.*)') or LuaProFa:match('^اخطار (.*)')) and is_JoinChannel(msg) then
			local Matches = LuaProLw:match('^warn (.*)') or LuaProFa:match('^اخطار (.*)')
			UseridSet(msg, Matches ,"warn")
		elseif LuaProFa and (LuaProLw:match('^unwarn (.*)') or LuaProFa:match('^حذف اخطار (.*)')) and is_JoinChannel(msg) then
			local Matches = LuaProLw:match('^unwarn (.*)') or LuaProFa:match('^حذف اخطار (.*)')
			UseridSet(msg, Matches ,"unwarn")
		elseif LuaProFa and (LuaProLw:match('^lock (.*)') or LuaProFa:match('^قفل (.*)')) and is_JoinChannel(msg) then
			local CmdEn = {
			string.match(LuaProLw, "^(lock) (.*)$")
			}
			local CmdFa = {
			string.match(LuaProFa, "^(قفل) (.*)$")
			}
			if CmdEn[2] == "cmds" or CmdFa[2] == "دستورات" then
				tdbot.sendMessage(msg.to.id, msg.id, 1, Source_Start.."`قفل دستورات` *توسط* `"..msg.from.id.."` - @"..check_markdown(msg.from.username or '').." `فعال شد.`"..EndMsg, 1, 'md')
				redis:set(RedisIndex.."lock_cmd"..msg.chat_id,true)
			elseif CmdEn[2] == "gp" or CmdFa[2] == "گروه" then
				if redis:get(RedisIndex..'mute_all:'..msg.chat_id) == 'Enable' then
					tdbot.sendMessage(msg.chat_id , msg.id, 1, Source_Start.."*قفل* `گروه` *از قبل فعال بود.*"..EndMsg.."\n*حالت قفل :* `حذف پیام`", 0, 'md')
				else
					tdbot.sendMessage(msg.chat_id , msg.id, 1, Source_Start.."*قفل* `گروه` *توسط* `"..msg.from.id.."` - @"..check_markdown(msg.from.username or '').." *فعال شد.*"..EndMsg.."\n*حالت قفل :* `حذف پیام`", 0, 'md')
					redis:set(RedisIndex..'mute_all:'..msg.chat_id, 'Enable')
				end
			end
		elseif LuaProFa and (LuaProLw:match('^unlock (.*)') or LuaProFa:match('^بازکردن (.*)') or LuaProFa:match('^باز کردن (.*)')) and is_JoinChannel(msg) then
			local CmdEn = {
			string.match(LuaProLw, "^(unlock) (.*)$")
			}
			local CmdFa = {
			string.match(LuaProFa, "^(باز کردن) (.*)$")
			}
			local CmdFa = {
			string.match(LuaProFa, "^(بازکردن) (.*)$")
			}
			if CmdEn[2] == 'auto' or CmdFa[2] == 'خودکار' then
				if redis:get(RedisIndex.."atolct1"..msg.to.id) and redis:get(RedisIndex.."atolct2"..msg.to.id) then
					redis:del(RedisIndex.."atolct1"..msg.to.id)
					redis:del(RedisIndex.."atolct2"..msg.to.id)
					redis:del(RedisIndex.."lc_ato:"..msg.to.id)
					tdbot.sendMessage(msg.to.id, msg.id, 1, Source_Start..'`زمانبدی ربات برای قفل کردن خودکار گروه حذف شد`'..EndMsg, 1, 'md')
				else
					tdbot.sendMessage(msg.to.id, msg.id, 1, Source_Start..'`قفل خودکار از قبل غیرفعال بود`'..EndMsg, 1, 'md')
				end
			elseif CmdEn[2] == "gp" or CmdFa[2] == "گروه" then
				if redis:get(RedisIndex..'mute_all:'..msg.chat_id) then
					tdbot.sendMessage(msg.chat_id , msg.id, 1, Source_Start.."*قفل* `گروه` *توسط* `"..msg.from.id.."` - @"..check_markdown(msg.from.username or '').." *غیرفعال شد.*"..EndMsg.."", 0, 'md')
					redis:del(RedisIndex..'mute_all:'..msg.chat_id)
				else
					tdbot.sendMessage(msg.chat_id , msg.id, 1, Source_Start.."*قفل* `گروه` *از قبل فعال نبود.*"..EndMsg.."", 0, 'md')
				end
				redis:del(RedisIndex..'Lock_Gp:'..msg.to.id)
			elseif CmdEn[2] == "cmds" or CmdFa[2] == "دستورات" then
				tdbot.sendMessage(msg.to.id, msg.id, 1, Source_Start.."`قفل دستورات` *توسط* `"..msg.from.id.."` - @"..check_markdown(msg.from.username or '').." `غیرفعال شد.`"..EndMsg, 1, 'md')
				redis:del(RedisIndex.."lock_cmd"..msg.chat_id)
			end
		end
		if msg.to.type == "channel" then
			if (LuaProLw == "gpinfo" or LuaProFa == "اطلاعات گروه") and is_JoinChannel(msg) then
				local function group_info(arg, data)
					if data.description and data.description ~= "" then
						des = check_markdown(data.description)
					else
						des = ""
					end
					ginfo = Source_Start.."*اطلاعات گروه :*\n`تعداد مدیران :` *"..data.administrator_count.."*\n`تعداد اعضا :` *"..data.member_count.."*\n`تعداد اعضای حذف شده :` *"..data.banned_count.."*\n`تعداد اعضای محدود شده :` *"..data.restricted_count.."*\n`شناسه گروه :` *"..msg.to.id.."*\n`توضیحات گروه :` "..des
					tdbot.sendMessage(arg.chat_id, arg.msg_id, 1, ginfo, 1, 'md')
				end
				tdbot.getChannelFull(msg.to.id, group_info, {chat_id=msg.to.id,msg_id=msg.id})
			end
		end
		if LuaProFa and (LuaProEn:match('^[Ss][Ee][Tt][Ww][Ee][Ll][Cc][Oo][Mm][Ee] (.*)') or LuaProFa:match('^تنظیم خوشامد (.*)') or LuaProFa:match('^تنظیم خوشآمد (.*)')) and is_JoinChannel(msg) then
			local Matches = LuaProEn:match('^[Ss][Ee][Tt][Ww][Ee][Ll][Cc][Oo][Mm][Ee] (.*)') or LuaProFa:match('^تنظیم خوشامد (.*)') or LuaProFa:match('^تنظیم خوشآمد (.*)')
			redis:set(RedisIndex..'setwelcome:'..msg.chat_id, Matches)
			text = Source_Start.."`پیام خوشآمد گویی تنظیم شد به :`\n*"..check_markdown(Matches).."*\n\n*شما میتوانید از*\n_{gpname} نام گروه_\n_{name} ➣ نام کاربر جدید_\n_{username} ➣ نام کاربری کاربر جدید_\n_{time} ➣ ساعت_\n_`استفاده کنید`"..EndMsg
			tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
		elseif LuaProFa and (LuaProEn:match('^[Ss][Ee][Tt][Nn][Aa][Mm][Ee] (.*)') or LuaProFa:match('^تنظیم اسم (.*)')) and is_JoinChannel(msg) then
			local Matches = LuaProEn:match('^[Ss][Ee][Tt][Nn][Aa][Mm][Ee] (.*)') or LuaProFa:match('^تنظیم اسم (.*)')
			tdbot.changeChatTitle(msg.to.id, Matches)
		elseif LuaProFa and (LuaProLw:match('^res @(.*)') or LuaProFa:match('^کاربری @(.*)')) and is_JoinChannel(msg) then
			local Matches = LuaProLw:match('^res @(.*)') or LuaProFa:match('^کاربری @(.*)')
			tdbot_function ({
			_ = "searchPublicChat",
			username = Matches
			}, action_by_username, {chat_id=msg.to.id,username=Matches,cmd="res",msg=msg})
		elseif LuaProFa and (LuaProEn:match('^[Ss][Ee][Tt][Rr][Uu][Ll][Ee][Ss] (.*)') or LuaProFa:match('^تنظیم قوانین (.*)')) and is_JoinChannel(msg) then
			local Matches = LuaProEn:match('^[Ss][Ee][Tt][Rr][Uu][Ll][Ee][Ss] (.*)') or LuaProFa:match('^تنظیم قوانین (.*)')
			redis:set(RedisIndex..msg.to.id..'rules', Matches)
			text = Source_Start.."`قوانین گروه ثبت شد`"..EndMsg
			tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
		elseif LuaProFa and (LuaProLw:match('^whois (%d+)') or LuaProFa:match('^شناسه (%d+)')) and is_JoinChannel(msg) then
			local Matches = LuaProLw:match('^whois (%d+)') or LuaProFa:match('^شناسه (%d+)')
			tdbot_function ({
			_ = "getUser",
			user_id = Matches,
			}, action_by_id, {chat_id=msg.to.id,user_id=Matches,cmd="whois"})
		elseif (LuaProLw == "warnlist" or LuaProFa == "لیست اخطار") and is_JoinChannel(msg) then
			local list = Source_Start..'لیست اخطار :\n'
			local empty = list
			for k,v in pairs (redis:hkeys(RedisIndex..msg.to.id..':warn')) do
				local user_name = redis:get(RedisIndex..'user_name:'..v) or "---"
				local cont = redis:hget(RedisIndex..msg.to.id..':warn', v)
				if user_name then
					list = list..k..'- '..check_markdown(user_name)..' [`'..v..'`] \n*اخطار : '..(cont - 1)..'*\n'
				else
					list = list..k..'- `'..v..'` \n*اخطار : '..(cont - 1)..'*\n'
				end
			end
			if list == empty then
				text = Source_Start..'*لیست اخطار خالی است*'..EndMsg
				tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
			else
				tdbot.sendMessage(msg.chat_id , msg.id, 1, list, 0, 'md')
			end
		elseif (LuaProLw == 'setdow' or LuaProFa == 'تنظیم دانلود') and is_JoinChannel(msg) then
			if redis:get(RedisIndex..'Num1Time:'..msg.to.id) and not is_admin(msg) then
				tdbot.sendMessage(msg.chat_id, msg.id, 1, Source_Start.."`اجرای این دستور هر 1 ساعت یک بار ممکن است.`"..EndMsg, 1, 'md')
			else
				redis:setex(RedisIndex..'Num1Time:'..msg.to.id, 3600, true)
				redis:setex(RedisIndex..'AutoDownload:'..msg.to.id, 1200, true)
				local text = Source_Start..'*با موفقیت ثبت شد.*\n`مدیران و مالک گروه  میتواند به مدت 20 دقیقه از دستوراتی که نیاز به دانلود دارند استفاده کنند`\n*'..Source_Start..' نکته :* اجرای این دستور هر 1 ساعت یک بار ممکن است.'..EndMsg
				tdbot.sendMessage(msg.chat_id, msg.id, 1, text, 1, 'md')
			end
		elseif (LuaProLw == "del" or LuaProFa == "حذف") and is_JoinChannel(msg) and msg.reply_id then
			del_msg(msg.to.id, msg.reply_id)
			del_msg(msg.to.id, msg.id)
		elseif (LuaProLw == "pin" or LuaProFa == "سنجاق") and msg.reply_id and is_JoinChannel(msg) then
			local lock_pin = redis:get(RedisIndex..'lock_pin:'..msg.chat_id)
			if lock_pin == 'Enable' then
				if is_owner(msg) then
					tdbot.pinChannelMessage(msg.to.id, msg.reply_id, 1, dl_cb, nil)
					text = Source_Start.."`پیام سجاق شد`"..EndMsg
					tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
				elseif not is_owner(msg) then
					return
				end
			elseif not lock_pin then
				redis:set(RedisIndex..'pin_msg'..msg.chat_id, msg.reply_id)
				tdbot.pinChannelMessage(msg.to.id, msg.reply_id, 1, dl_cb, nil)
				text = Source_Start.."`پیام سجاق شد`"..EndMsg
				tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
			end
		elseif (LuaProLw == 'unpin' or LuaProFa == "حذف سنجاق") and is_JoinChannel(msg) then
			local lock_pin = redis:get(RedisIndex..'lock_pin:'..msg.chat_id)
			if lock_pin == 'Enable' then
				if is_owner(msg) then
					tdbot.unpinChannelMessage(msg.to.id, dl_cb, nil)
					text = Source_Start.."`پیام سنجاق شده پاک شد`"..EndMsg
					tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
				elseif not is_owner(msg) then
					return
				end
			elseif not lock_pin then
				tdbot.unpinChannelMessage(msg.to.id, dl_cb, nil)
				text = Source_Start.."`پیام سنجاق شده پاک شد`"..EndMsg
				tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
			end
		elseif LuaProFa and (LuaProLw:match('^lockgp (%d+) (%d+) (%d+)') or LuaProFa:match('^قفل گروه (%d+) (%d+) (%d+)')) and is_JoinChannel(msg) then
			local CmdEn = {
			string.match(LuaProLw, "^(lockgp) (%d+) (%d+) (%d+)$")
			}
			local CmdFa = {
			string.match(LuaProFa, "^(قفل گروه) (%d+) (%d+) (%d+)$")
			}
			local Matches1 = CmdEn[2] or CmdFa[2]
			local Matches2 = CmdEn[3] or CmdFa[3]
			local Matches3 = CmdEn[4] or CmdFa[4]
			local hour = string.gsub(Matches1, "h", "")
			local num1 = tonumber(hour) * 3600
			local minutes = string.gsub(Matches2, "m", "")
			local num2 = tonumber(minutes) * 60
			local second = string.gsub(Matches3, "s", "")
			local num3 = tonumber(second)
			local timelock = tonumber(num1 + num2 + num3)
			redis:setex(RedisIndex..'Lock_Gp:'..msg.to.id, timelock, true)
			tdbot.sendMessage(msg.to.id, msg.id, 1, Source_Start.."`گروه به مدت` *"..Matches1.."* `ساعت` *"..Matches2.."* `دقیقه` *"..Matches3.."* `ثانیه توسط` `"..msg.from.id.."` - @"..check_markdown(msg.from.username or '').." `قفل شد`"..EndMsg, 1, 'md')
		elseif LuaProFa and (LuaProLw:match('^lockgp (%d+)[mhs]') or LuaProFa:match('^قفل گروه (%d+)[mhs]')) and is_JoinChannel(msg) then
			local Matches = LuaProLw:match('^lockgp (.*)') or LuaProFa:match('^قفل گروه (.*)')
			if Matches:match('(%d+)h') then
				time_match = Matches:match('(%d+)h')
				time = time_match * 3600
			end
			if Matches:match('(%d+)s') then
				time_match = Matches:match('(%d+)s')
				time = time_match
			end
			if Matches:match('(%d+)m') then
				time_match = Matches:match('(%d+)m')
				time = time_match * 60
			end
			local timelock = tonumber(time)
			redis:setex(RedisIndex..'Lock_Gp:'..msg.to.id, timelock, true)
			tdbot.sendMessage(msg.chat_id, msg.id, 1, Source_Start.."`گروه به مدت` *"..time.."* `ثانیه توسط` `"..msg.from.id.."` - @"..check_markdown(msg.from.username or '').." `قفل شد`"..EndMsg, 1, 'md')
		elseif (LuaProLw == 'newlink' or LuaProFa == "لینک جدید") and is_JoinChannel(msg) then
			local function callback_link (arg, data)
				if not data.invite_link then
					return tdbot.sendMessage(msg.to.id, msg.id, 1, Source_Start.."`ربات ادمین گروه نیست`\n`با دستور` *setlink/* `لینک جدیدی برای گروه ثبت کنید"..EndMsg, 1, 'md')
				else
					redis:set(RedisIndex..msg.to.id..'linkgpset', data.invite_link)
					return tdbot.sendMessage(msg.to.id, msg.id, 1, Source_Start.."`لینک جدید ساخته شد`"..EndMsg, 1, 'md')
				end
			end
			tdbot.exportChatInviteLink(msg.to.id, callback_link, nil)
		elseif (LuaProLw == 'link' or LuaProFa == "لینک") and is_JoinChannel(msg) then
			local linkgp = redis:get(RedisIndex..msg.to.id..'linkgpset')
			if not linkgp then
				text = Source_Start.."`ابتدا با دستور` *newlink/* `لینک جدیدی برای گروه بسازید`\n`و اگر ربات سازنده گروه نیس با دستور` *setlink/* `لینک جدیدی برای گروه ثبت کنید`"..EndMsg
				tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
			end
			text = Source_Start.."<b>لینک گروه :</b>\n"..linkgp
			return tdbot.sendMessage(msg.chat_id, msg.id, 1, text, 1, 'html')
		elseif (LuaProLw == 'linkpv' or LuaProFa == "لینک خصوصی") and is_JoinChannel(msg) then
			if not redis:get(RedisIndex..msg.from.id..'chkusermonshi')  then
				tdbot.sendMessage(msg.chat_id, msg.id, 1, "`لطفا پیوی ربات پیام ازسال کنید سپس دستور را وارد نماید.`"..EndMsg, 1, 'md')
			else
				local linkgp = redis:get(RedisIndex..msg.to.id..'linkgpset')
				if not linkgp then
					text = Source_Start.."`ابتدا با دستور` *newlink/* `لینک جدیدی برای گروه بسازید`\n`و اگر ربات سازنده گروه نیس با دستور` *setlink/* `لینک جدیدی برای گروه ثبت کنید`"..EndMsg
					tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
				end
				tdbot.sendMessage(msg.sender_user_id, "", 1, "<b>لینک گروه </b> : <code>"..msg.to.title.."</code> :\n"..linkgp, 1, 'html')
				text = Source_Start.."`لینک گروه به چت خصوصی شما ارسال شد`"..EndMsg
				tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
			end
		elseif LuaProFa and (LuaProLw:match('^setchar (%d+)') or LuaProFa:match('^حداکثر حروف مجاز (%d+)')) and is_JoinChannel(msg) then
			local Matches = LuaProLw:match('^setchar (%d+)') or LuaProFa:match('^حداکثر حروف مجاز (%d+)')
			redis:set(RedisIndex..msg.to.id..'set_char', Matches)
			text = Source_Start.."`حداکثر حروف مجاز در پیام تنظیم شد به :` *[ "..Matches.." ]*"..EndMsg
			tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
		elseif LuaProFa and (LuaProLw:match('^setflood (%d+)') or LuaProFa:match('^تنظیم پیام مکرر (%d+)')) and is_JoinChannel(msg) then
			local Matches = LuaProLw:match('^setflood (%d+)') or LuaProFa:match('^تنظیم پیام مکرر (%d+)')
			if tonumber(Matches) < 1 or tonumber(Matches) > 50 then
				text = Source_Start.."`باید بین` *[2-50]* `تنظیم شود`"..EndMsg
				tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
			end
			local flood_max = Matches
			redis:set(RedisIndex..msg.to.id..'num_msg_max', flood_max)
			text = Source_Start..'`محدودیت پیام مکرر به` *'..tonumber(Matches)..'* `تنظیم شد.`'..EndMsg
			tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
		elseif LuaProFa and (LuaProLw:match('^setfloodtime (%d+)') or LuaProFa:match('^تنظیم زمان بررسی (%d+)')) and is_JoinChannel(msg) then
			local Matches = LuaProLw:match('^setfloodtime (%d+)') or LuaProFa:match('^تنظیم زمان بررسی (%d+)')
			if tonumber(Matches) < 2 or tonumber(Matches) > 10 then
				text = Source_Start.."`باید بین` *[2-10]* `تنظیم شود`"..EndMsg
				tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
			end
			local time_max = Matches
			redis:set(RedisIndex..msg.to.id..'time_check', time_max)
			text = Source_Start.."`حداکثر زمان بررسی پیام های مکرر تنظیم شد به :` *[ "..Matches.." ]*"..EndMsg
			tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
		elseif LuaProFa and (LuaProLw:match('^deltimebot (%d+)') or LuaProFa:match('^زمان پاکسازی ربات (%d+)')) and is_JoinChannel(msg) then
			local Matches = LuaProLw:match('^deltimebot (%d+)') or LuaProFa:match('^زمان پاکسازی ربات (%d+)')
			if tonumber(Matches) < 10 or tonumber(Matches) > 300 then
				text = Source_Start.."`باید بین` *[10 - 300]* `تنظیم شود`"..EndMsg
				tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
			else
				redis:set(RedisIndex.."deltimebot"..msg.chat_id , Matches)
				text = Source_Start.."`زمان پاکسازی پیام ربات تنظیم شد به هر` *[ "..Matches.." ]* `ثانیه`"..EndMsg
				tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
			end
		elseif LuaProFa and (LuaProLw:match('^setwarn (%d+)') or LuaProFa:match('^تنظیم اخطار (%d+)')) and is_JoinChannel(msg) then
			local Matches = LuaProLw:match('^setwarn (%d+)') or LuaProFa:match('^تنظیم اخطار (%d+)')
			if tonumber(Matches) < 1 or tonumber(Matches) > 20 then
				text = Source_Start.."`لطفا عددی بین [1-20] را انتخاب کنید`"..EndMsg
				tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
			else
				redis:set(RedisIndex..'max_warn:'..msg.to.id, Matches)
				text = Source_Start.."`حداکثر اخطار تنظیم شد به :` *[ "..Matches.." ]*"..EndMsg
				tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
			end
		elseif LuaProFa and (LuaProLw:match('^(lock auto) (%d+):(%d+)-(%d+):(%d+)$') or LuaProFa:match('^(قفل خودکار) (%d+):(%d+)-(%d+):(%d+)$')) and is_JoinChannel(msg) then
			local CmdEn = {
			string.match(LuaProLw, "^(lock auto) (%d+):(%d+)-(%d+):(%d+)$")
			}
			local CmdFa = {
			string.match(LuaProLw, "^(قفل خودکار) (%d+):(%d+)-(%d+):(%d+)$")
			}
			local Matches2 = CmdEn[2] or CmdFa[2]
			local Matches3 = CmdEn[3] or CmdFa[3]
			local Matches4 = CmdEn[4] or CmdFa[4]
			local Matches5 = CmdEn[5] or CmdFa[5]
			local End = Matches4..":"..Matches5
			local Start = Matches2..":"..Matches3
			if End == Start then
				tdbot.sendMessage(msg.to.id, msg.id, 1, Source_Start..'`آغاز قفل خودکار نمیتوانید با پایان آن یکی باشد`'..EndMsg, 1, 'md')
			else
				tdbot.sendMessage(msg.to.id, msg.id, 1, Source_Start..'`عملیات با موقیت انجام شد.\n\nگروه شما در ساعت` *'..Start..'* `الی` *'..End..'* `بصورت خودکار تعطیل خواهد شد.`'..EndMsg, 1, 'md')
				redis:set(RedisIndex.."atolct1"..msg.to.id,Start)
				redis:set(RedisIndex.."atolct2"..msg.to.id,End)
			end
		elseif LuaProFa and (LuaProLw:match('^mute (%d+)(.*)') or LuaProFa:match('^سکوت (%d+)(.*)')) and is_JoinChannel(msg) and msg.reply_id then
			local Matches = LuaProLw:match('^mute (%d+)') or LuaProFa:match('^سکوت (%d+)')
			local CmdEn = {
			string.match(LuaProLw, "^(mute) (%d+)(.*)$")
			}
			local CmdFa = {
			string.match(LuaProFa, "^(سکوت) (%d+)(.*)$")
			}
			local time = Matches
			if CmdEn[3] == "d" or CmdFa[3] == "روز" then
				local hour = tonumber(time) * 86400
				local timemute = tonumber(hour)
				local function Restricted(arg, data)
					if data.sender_user_id == our_id then
						return tdbot.sendMessage(msg.chat_id, "", 0, Source_Start.."*من نمیتوانم توانایی چت کردن رو از خودم بگیرم*"..EndMsg, 0, "md")
					end
					if is_mod1(msg.chat_id, data.sender_user_id) then
						return tdbot.sendMessage(msg.chat_id, "", 0, Source_Start.."*شما نمیتوانید توانایی چت کردن رو از مدیران،صاحبان گروه، و ادمین های ربات بگیرید*"..EndMsg, 0, "md")
					end
					tdbot.Restricted(msg.chat_id,data.sender_user_id,'Restricted',   {1,msg.date+timemute, 0, 0, 0,0})
					tdbot.sendMention(msg.chat_id,data.sender_user_id, data.id,Source_Start.."کاربر [ "..data.sender_user_id.." ]  به مدت "..time.." ساعت سکوت شد"..EndMsg,10,string.len(data.sender_user_id))
				end
				tdbot.getMessage(msg.chat_id, tonumber(msg.reply_to_message_id), Restricted, nil)
			elseif CmdEn[3] == "h" or CmdFa[3] == "ساعت" then
				local hour = tonumber(time) * 3600
				local timemute = tonumber(hour)
				local function Restricted(arg, data)
					if data.sender_user_id == our_id then
						return tdbot.sendMessage(msg.chat_id, "", 0, Source_Start.."*من نمیتوانم توانایی چت کردن رو از خودم بگیرم*"..EndMsg, 0, "md")
					end
					if is_mod1(msg.chat_id, data.sender_user_id) then
						return tdbot.sendMessage(msg.chat_id, "", 0, Source_Start.."*شما نمیتوانید توانایی چت کردن رو از مدیران،صاحبان گروه، و ادمین های ربات بگیرید*"..EndMsg, 0, "md")
					end
					tdbot.Restricted(msg.chat_id,data.sender_user_id,'Restricted',   {1,msg.date+timemute, 0, 0, 0,0})
					tdbot.sendMention(msg.chat_id,data.sender_user_id, data.id,Source_Start.."کاربر [ "..data.sender_user_id.." ]  به مدت "..time.." ساعت سکوت شد"..EndMsg,10,string.len(data.sender_user_id))
				end
				tdbot.getMessage(msg.chat_id, tonumber(msg.reply_to_message_id), Restricted, nil)
			elseif CmdEn[3] == "m" or CmdFa[3] == "دقیقه" then
				local minutes = tonumber(time) * 60
				local timemute = tonumber(minutes)
				local function Restricted(arg,data)
					if data.sender_user_id == our_id then
						return tdbot.sendMessage(msg.chat_id, "", 0, Source_Start.."*من نمیتوانم توانایی چت کردن رو از خودم بگیرم*"..EndMsg, 0, "md")
					end
					if is_mod1(msg.chat_id, data.sender_user_id) then
						return tdbot.sendMessage(msg.chat_id, "", 0, Source_Start.."*شما نمیتوانید توانایی چت کردن رو از مدیران،صاحبان گروه، و ادمین های ربات بگیرید*"..EndMsg, 0, "md")
					end
					tdbot.Restricted(msg.chat_id,data.sender_user_id,'Restricted',   {1,msg.date+timemute, 0, 0, 0,0})
					tdbot.sendMention(msg.chat_id,data.sender_user_id, data.id,Source_Start.."کاربر [ "..data.sender_user_id.." ]  به مدت "..time.." دقیقه سکوت شد"..EndMsg,10,string.len(data.sender_user_id))
				end
				tdbot.getMessage(msg.chat_id, tonumber(msg.reply_to_message_id), Restricted, nil)
			end
		elseif (LuaProLw == 'filterlist' or LuaProFa == "لیست فیلتر") and is_JoinChannel(msg) then
			return filter_list(msg)
		elseif (LuaProLw == "settings" or LuaProFa == "تنظیمات") and is_JoinChannel(msg) then
			return group_settings(msg)
		elseif LuaProFa and (LuaProLw:match('^filter (.*)') or LuaProFa:match('^فیلتر (.*)')) and is_JoinChannel(msg) then
			local Matches = LuaProLw:match('^filter (.*)') or LuaProFa:match('^فیلتر (.*)')
			return filter_word(msg, Matches)
		elseif LuaProFa and (LuaProLw:match('^unfilter (.*)') or LuaProFa:match('^حذف فیلتر (.*)')) and is_JoinChannel(msg) then
			local Matches = LuaProLw:match('^unfilter (.*)') or LuaProFa:match('^حذف فیلتر (.*)')
			return unfilter_word(msg, Matches)
		end
		----------- Fun -------------
		if msg.reply_id then
			if (LuaProLw == 'tophoto' or LuaProFa == 'تبدیل به عکس') and is_JoinChannel(msg) then
				if not redis:get(RedisIndex..'AutoDownload:'..msg.to.id) then
					tdbot.sendMessage(msg.chat_id, msg.id, 1, Source_Start..'*دانلود خودکار در گروه شما فعال نمیباشد*'..EndMsg..'\n*برای فعال سازی از دستور زیر استفاده کنید :*\n `"Setdow"` *&&* `"تنظیم دانلود"`', 1, 'md')
				end
				function tophoto(arg, data)
					function tophoto_cb(arg,data)
						if data.content.sticker then
							local file = data.content.sticker.sticker.path
							local secp = tostring(tcpath)..'/data/stickers/'
							local ffile = string.gsub(file, '-', '')
							local fsecp = string.gsub(secp, '-', '')
							local name = string.gsub(ffile, fsecp, '')
							local sname = string.gsub(name, 'webp', 'jpg')
							local pfile = 'Download/'..sname
							local pasvand = 'webp'
							local apath = tostring(tcpath)..'/data/stickers'
							if file_exif(tostring(name), tostring(apath), '') then
								os.rename(file, pfile)
								tdbot.sendPhoto(msg.to.id, msg.id, pfile, 0, {}, 0, 0, "₪ "..channel_username.."", 0, 0, 1, nil, dl_cb, nil)
							else
								tdbot.sendMessage(msg.to.id, msg.id, 1, Source_Start..'*لطفا دوباره استیکر مورد نظر خود را ارسال کنید*'..EndMsg, 1, 'md')
							end
						else
							tdbot.sendMessage(msg.to.id, msg.id, 1, Source_Start..'*استیکر نمیباشد.*'..EndMsg, 1, 'md')
						end
					end
					tdbot_function ({ _ = 'getMessage', chat_id = msg.chat_id, message_id = data.id }, tophoto_cb, nil)
				end
				tdbot_function ({ _ = 'getMessage', chat_id = msg.chat_id, message_id = msg.reply_id }, tophoto, nil)
			end
			if (LuaProLw == 'tosticker' or LuaProFa == 'تبدیل به استیکر') and is_JoinChannel(msg) then
				if not redis:get(RedisIndex..'AutoDownload:'..msg.to.id) then
					tdbot.sendMessage(msg.to.id, msg.id, 1, Source_Start..'*دانلود خودکار در گروه شما فعال نمیباشد*'..EndMsg..'\n*برای فعال سازی از دستور زیر استفاده کنید :*\n `"Setdow"` *&&* `"تنظیم دانلود"`', 1, 'md')
				end
				function tosticker(arg, data)
					function tosticker_cb(arg,data)
						if data.content._ == 'messagePhoto' then
							file = data.content.photo.id
							local pathf = tcpath..'/files/photos/'..file..'.jpg'
							if file_exif(file..'_(0).jpg', tcpath..'/files/photos', 'jpg') then
								pathf = tcpath..'/files/photos/'..file..'_(0).jpg'
							end
							local pfile = 'Download/'..file..'.webp'
							if file_exif(file..'.jpg', tcpath..'/files/photos', 'jpg') then
								os.rename(pathf, pfile)
								tdbot.sendSticker(msg.to.id, msg.id, pfile, 512, 512, 1, nil, nil, dl_cb, nil)
							else
								tdbot.sendMessage(msg.to.id, msg.id, 1, Source_Start..'*لطفا دوباره عکس مورد نظر خود را ارسال کنید*'..EndMsg, 1, 'md')
							end
						else
							tdbot.sendMessage(msg.to.id, msg.id, 1, Source_Start..'*عکس نمیباشد.*'..EndMsg, 1, 'md')
						end
					end
					tdbot_function ({ _ = 'getMessage', chat_id = msg.chat_id, message_id = data.id }, tosticker_cb, nil)
				end
				tdbot_function ({ _ = 'getMessage', chat_id = msg.chat_id, message_id = msg.reply_id }, tosticker, nil)
			end
		end
		if LuaProFa and (LuaProEn:match('^[Ee][Mm][Oo][Jj][Ii] (.*)') or LuaProFa:match('^شکلک (.*)')) and is_JoinChannel(msg) then
			local Matches = LuaProEn:match('^[Ee][Mm][Oo][Jj][Ii] (.*)') or LuaProFa:match('^شکلک (.*)')
			local url ='http://2wap.org/usf/text_sm_gen/sm_gen.php?text='..Matches
			local file = download_to_file(url,'Emoji.webp')
			tdbot.sendDocument(msg.to.id, file, channel_username, nil, msg.id, 0, 1, nil, dl_cb, nil)
		end
		if (LuaProLw == 'time' or LuaProFa == "ساعت" or LuaProFa == "زمان") and is_JoinChannel(msg) then
			local url ='http://2wap.org/usf/text_sm_gen/sm_gen.php?text='..os.date("%H:%M:%S")
			local file = download_to_file(url,'Time.webp')
			tdbot.sendDocument(msg.to.id, file, channel_username, nil, msg.id, 0, 1, nil, dl_cb, nil)
		end
		if LuaProFa and (LuaProEn:match('^[Gg][Ii][Ff] (.*)') or LuaProFa:match('^گیف (.*)')) and is_JoinChannel(msg) then
			local Matches = LuaProEn:match('^[Gg][Ii][Ff] (.*)') or LuaProFa:match('^گیف (.*)')
			local modes = {'memories-anim-logo','alien-glow-anim-logo','flash-anim-logo','flaming-logo','whirl-anim-logo','highlight-anim-logo','burn-in-anim-logo','shake-anim-logo','inner-fire-anim-logo','jump-anim-logo'}
			local text = URL.escape(Matches)
			local mod = {'Blinking+Text','No+Button','Dazzle+Text','Walk+of+Fame+Animated','Wag+Finger','Glitter+Text','Bliss','Flasher','Roman+Temple+Animated',}
			local set = mod[math.random(#mod)]
			local colors = {'00FF00','6699FF','CC99CC','CC66FF','0066FF','000000','CC0066','FF33CC','FF0000','FFCCCC','FF66CC','33FF00','FFFFFF','00FF00'}
			local bc = colors[math.random(#colors)]
			local colorss = {'00FF00','6699FF','CC99CC','CC66FF','0066FF','000000','CC0066','FF33CC','FFF200','FF0000','FFCCCC','FF66CC','33FF00','FFFFFF','00FF00'}
			local tc = colorss[math.random(#colorss)]
			local url2 = 'http://www.imagechef.com/ic/maker.jsp?filter=&jitter=0&tid='..set..'&color0='..bc..'&color1='..tc..'&color2=000000&customimg=&0='..Matches
			local title1 , res = http.request(url2)
			if res ~= 200 then return end
			if title1 then
				if json:decode(title1) then
					local jdat = json:decode(title1)
					local gif = jdat.resImage
					local file = download_to_file(gif,'Gif-Random.gif')
					tdbot.sendDocument(msg.to.id, file, ""..channel_username.."", nil, msg.id, 0, 1, nil, dl_cb, nil)
				end
			end
		end
		if LuaProFa and (LuaProEn:match('^[Ss][Hh][Oo][Rr][Tt] (.*)') or LuaProFa:match('^لینک کوتاه (.*)')) and is_JoinChannel(msg) then
			local Matches = LuaProEn:match('^[Ss][Hh][Oo][Rr][Tt] (.*)') or LuaProFa:match('^لینک کوتاه (.*)')
			if Matches:match("[Hh][Tt][Tt][Pp][Ss]://") then
				shortlink = Matches
			elseif not Matches:match("[Hh][Tt][Tt][Pp][Ss]://") then
				shortlink = "https://"..Matches
			end
			local yon = http.request('http://api.yon.ir/?url='..URL.escape(shortlink))
			local jdat = json:decode(yon)
			local bitly = https.request('https://api-ssl.bitly.com/v3/shorten?access_token=f2d0b4eabb524aaaf22fbc51ca620ae0fa16753d&longUrl='..URL.escape(shortlink))
			local data = json:decode(bitly)
			local u2s = http.request('http://u2s.ir/?api=1&return_text=1&url='..URL.escape(shortlink))
			local llink = http.request('http://llink.ir/yourls-api.php?signature=a13360d6d8&action=shorturl&url='..URL.escape(shortlink)..'&format=simple')
			local text = ' 🌐لینک اصلی :\n'..(data.data.long_url)..'\n\nلینکهای کوتاه شده با 6 سایت کوتاه ساز لینک : \n》کوتاه شده با bitly :\n___________________________\n'..((data.data.url) or '---')..'\n___________________________\n》کوتاه شده با u2s :\n'..(check_markdown(u2s) or '---')..'\n___________________________\n》کوتاه شده با llink : \n'..((llink) or '---')..'\n___________________________\n》لینک کوتاه شده با yon : \nyon.ir/'..((jdat.output) or '---')..'\n____________________'..Source_Start..(channel_username)..EndMsg
			tdbot.sendMessage(msg.chat_id, 0, 1, text, 1, 'html')
		end
		if LuaProFa and LuaProEn:match('^[Ff][Oo][Nn][Tt] (.*)') and is_JoinChannel(msg) then
			local Matches = LuaProEn:match('^[Ff][Oo][Nn][Tt] (.*)')
			if string.len(Matches) > 20 then
				tdbot.sendMessage(msg.chat_id, 0, 1, Source_Start.."`حداکثر حروف مجاز 20 کاراکتر انگلیسی و عدد است`"..EndMsg, 1, 'md')
			end
			local font_base = "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,0,9,8,7,6,5,4,3,2,1,.,_"
			local font_hash = "z,y,x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,Z,Y,X,W,V,U,T,S,R,Q,P,O,N,M,L,K,J,I,H,G,F,E,D,C,B,A,0,1,2,3,4,5,6,7,8,9,.,_"
			local fonts = FonTen
			local result = {}
			i=0
			for k=1,#fonts do
				i=i+1
				local tar_font = fonts[i]:split(",")
				local text = Matches
				local text = text:gsub("A",tar_font[1])
				local text = text:gsub("B",tar_font[2])
				local text = text:gsub("C",tar_font[3])
				local text = text:gsub("D",tar_font[4])
				local text = text:gsub("E",tar_font[5])
				local text = text:gsub("F",tar_font[6])
				local text = text:gsub("G",tar_font[7])
				local text = text:gsub("H",tar_font[8])
				local text = text:gsub("I",tar_font[9])
				local text = text:gsub("J",tar_font[10])
				local text = text:gsub("K",tar_font[11])
				local text = text:gsub("L",tar_font[12])
				local text = text:gsub("M",tar_font[13])
				local text = text:gsub("N",tar_font[14])
				local text = text:gsub("O",tar_font[15])
				local text = text:gsub("P",tar_font[16])
				local text = text:gsub("Q",tar_font[17])
				local text = text:gsub("R",tar_font[18])
				local text = text:gsub("S",tar_font[19])
				local text = text:gsub("T",tar_font[20])
				local text = text:gsub("U",tar_font[21])
				local text = text:gsub("V",tar_font[22])
				local text = text:gsub("W",tar_font[23])
				local text = text:gsub("X",tar_font[24])
				local text = text:gsub("Y",tar_font[25])
				local text = text:gsub("Z",tar_font[26])
				local text = text:gsub("a",tar_font[27])
				local text = text:gsub("b",tar_font[28])
				local text = text:gsub("c",tar_font[29])
				local text = text:gsub("d",tar_font[30])
				local text = text:gsub("e",tar_font[31])
				local text = text:gsub("f",tar_font[32])
				local text = text:gsub("g",tar_font[33])
				local text = text:gsub("h",tar_font[34])
				local text = text:gsub("i",tar_font[35])
				local text = text:gsub("j",tar_font[36])
				local text = text:gsub("k",tar_font[37])
				local text = text:gsub("l",tar_font[38])
				local text = text:gsub("m",tar_font[39])
				local text = text:gsub("n",tar_font[40])
				local text = text:gsub("o",tar_font[41])
				local text = text:gsub("p",tar_font[42])
				local text = text:gsub("q",tar_font[43])
				local text = text:gsub("r",tar_font[44])
				local text = text:gsub("s",tar_font[45])
				local text = text:gsub("t",tar_font[46])
				local text = text:gsub("u",tar_font[47])
				local text = text:gsub("v",tar_font[48])
				local text = text:gsub("w",tar_font[49])
				local text = text:gsub("x",tar_font[50])
				local text = text:gsub("y",tar_font[51])
				local text = text:gsub("z",tar_font[52])
				local text = text:gsub("0",tar_font[53])
				local text = text:gsub("9",tar_font[54])
				local text = text:gsub("8",tar_font[55])
				local text = text:gsub("7",tar_font[56])
				local text = text:gsub("6",tar_font[57])
				local text = text:gsub("5",tar_font[58])
				local text = text:gsub("4",tar_font[59])
				local text = text:gsub("3",tar_font[60])
				local text = text:gsub("2",tar_font[61])
				local text = text:gsub("1",tar_font[62])
				
				table.insert(result, text)
			end
			local result_text = "کلمه ی اولیه : "..Matches.."\nطراحی با "..tostring(#fonts).." فونت :\n ________________________\n\n "
			a=0
			for v=1,#result do
				a=a+1
				result_text = result_text..a.."- "..result[a].."\n\n"
			end
			tdbot.sendMessage(msg.chat_id, 0, 1, result_text.."💢💢💢💢💢💢💢💢💢💢\n"..Source_Start..""..channel_username..""..EndMsg, 1, 'html')
		end
		if LuaProFa and LuaProFa:match('^زیبانویس (.*)') and is_JoinChannel(msg) then
			local Matches = LuaProFa:match('^زیبانویس (.*)')
			if string.len(Matches) > 20 then
				tdbot.sendMessage(msg.chat_id, 0, 1, Source_Start.."`حداکثر حروف مجاز 20 کاراکتر فارسی و عدد است`"..EndMsg, 1, 'md')
			end
			local font_base = "ض,ص,ق,ف,غ,ع,ه,خ,ح,ج,ش,س,ی,ب,ل,ا,ن,ت,م,چ,ظ,ط,ز,ر,د,پ,و,ک,گ,ث,ژ,ذ,آ,ئ,.,_"
			local font_hash = "ض,ص,ق,ف,غ,ع,ه,خ,ح,ج,ش,س,ی,ب,ل,ا,ن,ت,م,چ,ظ,ط,ز,ر,د,پ,و,ک,گ,ث,ژ,ذ,آ,ئ,.,_"
			local fontsfa = FonTfa
			local resultfa = {}
			i=0
			for k=1,#fontsfa do
				i=i+1
				local tar_font = fontsfa[i]:split(",")
				local text = Matches
				local text = text:gsub("ض",tar_font[1])
				local text = text:gsub("ص",tar_font[2])
				local text = text:gsub("ق",tar_font[3])
				local text = text:gsub("ف",tar_font[4])
				local text = text:gsub("غ",tar_font[5])
				local text = text:gsub("ع",tar_font[6])
				local text = text:gsub("ه",tar_font[7])
				local text = text:gsub("خ",tar_font[8])
				local text = text:gsub("ح",tar_font[9])
				local text = text:gsub("ج",tar_font[10])
				local text = text:gsub("ش",tar_font[11])
				local text = text:gsub("س",tar_font[12])
				local text = text:gsub("ی",tar_font[13])
				local text = text:gsub("ب",tar_font[14])
				local text = text:gsub("ل",tar_font[15])
				local text = text:gsub("ا",tar_font[16])
				local text = text:gsub("ن",tar_font[17])
				local text = text:gsub("ت",tar_font[18])
				local text = text:gsub("م",tar_font[19])
				local text = text:gsub("چ",tar_font[20])
				local text = text:gsub("ظ",tar_font[21])
				local text = text:gsub("ط",tar_font[22])
				local text = text:gsub("ز",tar_font[23])
				local text = text:gsub("ر",tar_font[24])
				local text = text:gsub("د",tar_font[25])
				local text = text:gsub("پ",tar_font[26])
				local text = text:gsub("و",tar_font[27])
				local text = text:gsub("ک",tar_font[28])
				local text = text:gsub("گ",tar_font[29])
				local text = text:gsub("ث",tar_font[30])
				local text = text:gsub("ژ",tar_font[31])
				local text = text:gsub("ذ",tar_font[32])
				local text = text:gsub("ئ",tar_font[33])
				local text = text:gsub("آ",tar_font[34])
				table.insert(resultfa, text)
			end
			
			local result_textfa = "کلمه ی اولیه : "..Matches.."\nطراحی با "..tostring(#fontsfa).." فونت :\n______________________________\n"
			a=0
			for v=1,#resultfa do
				a=a+1
				result_textfa = result_textfa..a.."- "..resultfa[a].."\n\n"
			end
			tdbot.sendMessage(msg.chat_id, 0, 1, result_textfa.."💢💢💢💢💢💢💢💢💢💢\n"..Source_Start..""..channel_username..""..EndMsg, 1, 'html')
		end
		if LuaProFa and (LuaProEn:match('^[Ss][Ee][Tt][Tt][Aa][Gg] (.*)') or LuaProFa:match('^تنظیم تگ (.*)')) and is_JoinChannel(msg) then
			local Matches = LuaProEn:match('^[Ss][Ee][Tt][Tt][Aa][Gg] (.*)') or LuaProFa:match('^تنظیم تگ (.*)')
			local title = Matches
			redis:set(RedisIndex..msg.to.id..'setmusictag', title)
			redis:set(RedisIndex..msg.to.id..'setmusictag2', title)
			local text = Source_Start..'`تگ آهنگ تنظیم شد :`\n '..check_markdown(title)..''..EndMsg
			tdbot.sendMessage(msg.chat_id, 0, 1, text, 1, 'md')
		end
		if LuaProFa and (LuaProEn:match('^[Ll][Oo][Vv][Ee] (.*) (.*)') or LuaProFa:match('^عشق (.*) (.*)')) and is_JoinChannel(msg) then
			local ap = {
			string.match(LuaProEn, "^([Ll][Oo][Vv][Ee]) (.*) (.*)$")
			}
			local apf = {
			string.match(LuaProFa, "^(عشق) (.*) (.*)$")
			}
			local text1 = ap[2] or apf[2]
			local text2 = ap[3] or apf[3]
			local url = "http://www.iloveheartstudio.com/-/p.php?t=" .. text1 .. "%20%EE%BB%AE%20" .. text2 .. "&bc=FFFFFF&tc=000000&hc=ff0000&f=c&uc=true&ts=true&ff=PNG&w=500&ps=sq"
			local file = download_to_file(url, "love.webp")
			tdbot.sendDocument(msg.to.id, file, channel_username, nil, msg.id, 0, 1, nil, dl_cb, nil)
		end
		----------- Fun -------------
	end
	if redis:get(RedisIndex.."lock_cmd"..msg.chat_id) and not is_mod(msg) then return false end
	function Bt1()
		tdbot.sendDocument(msg.to.id, 'libs/Tosh.webp', "توش باشه", nil, msg.reply_id, 0, 1, nil, dl_cb, nil)
		tdbot.setAlarm(2,Bt2,nil)
	end
	function Bt2()
		tdbot.sendMessage(msg.chat_id, redis:get(RedisIndex.."BkonTosh"..msg.chat_id), 1, "حله داداچ ریختم توش 💦🤟🏻 ", 1, 'md')
		tdbot.setAlarm(1,Bt3,nil)
	end
	function Bt3()
		tdbot.sendMessage(msg.chat_id, redis:get(RedisIndex.."BkonToshR"..msg.chat_id), 1, "پاره شدی گلم 😹 اشکال نداره خوب میشی 😜💦", 1, 'md')
		redis:del(RedisIndex.."BkonTosh"..msg.chat_id)
		redis:del(RedisIndex.."BkonToshR"..msg.chat_id)
	end
	if LuaProFa == "بکنش" and is_JoinChannel(msg) and msg.reply_id then
		if not is_mod(msg) then
			tdbot.sendMessage(msg.chat_id, msg.id, 1, "جون توم بلدی 🤨 گفتم بو کون اومد 🤪 بده بکنیم پسرم 💦😜", 1, 'md')
		else
			function ToshBashe(arg, data)
				if is_admin(msg) then
					if is_admin1(data.sender_user_id) then
						tdbot.sendMessage(msg.chat_id, msg.id, 1, "تاحالا کسی کردت صدا سگ بدی ؟ 😡🖕🏻", 1, 'md')
					else
						Bt1()
						redis:set(RedisIndex.."BkonTosh"..msg.chat_id, msg.id)
						redis:set(RedisIndex.."BkonToshR"..msg.chat_id, msg.reply_id)
					end
				else
					if is_admin1(data.sender_user_id) then
						tdbot.sendMessage(msg.chat_id, msg.id, 1, "تاحالا کسی کردت صدا سگ بدی ؟ 😡🖕🏻", 1, 'md')
					elseif is_owner1(msg.chat_id, data.sender_user_id) then
						tdbot.sendMessage(msg.chat_id, msg.id, 1, "داداچ نمیشه که بابام میکنه منو 😢💦", 1, 'md')
					else
						Bt1()
						redis:set(RedisIndex.."BkonTosh"..msg.chat_id, msg.id)
						redis:set(RedisIndex.."BkonToshR"..msg.chat_id, msg.reply_id)
					end
				end
			end
			tdbot.getMessage(msg.chat_id, tonumber(msg.reply_to_message_id), ToshBashe, nil)
		end
	end
	if LuaProFa and (LuaProLw == "id"  or LuaProFa == "ایدی" or LuaProFa == "آیدی") and tonumber(msg.reply_to_message_id) == 0  and redis:get(RedisIndex.."CheckBot:"..msg.to.id) then
		if redis:get(RedisIndex.."lock_cmd"..msg.chat_id) and not is_mod(msg) then return else
			local function getpro(arg, data)
				local user_info_msgs = tonumber(redis:get(RedisIndex..'msgs:'..msg.sender_user_id..':'..msg.chat_id) or 0)
				local gap_info_msgs = tonumber(redis:get(RedisIndex..'msgs:'..msg.chat_id) or 0)
				if not data.photos[0] then
					tdbot.sendMessage(msg.chat_id, msg.id, 1, ''..Source_Start..'شناسه گروه : '..msg.chat_id..'\n'..Source_Start..'تعداد پیام های گروه : [ '..gap_info_msgs..' ]\n'..Source_Start..'شناسه شما : '..msg.sender_user_id..'\n'..Source_Start..'تعداد پیام های شما : [ '..user_info_msgs..' ]\n'..Source_Start..' نام کاربری : @'..msg.from.username or msg.from.first_name..'', 1, 'md')
				else
					tdbot.sendPhoto(msg.chat_id, msg.id, data.photos[0].sizes[1].photo.persistent_id, 0, {}, 0, 0, ''..Source_Start..'شناسه گروه : '..msg.chat_id..'\n'..Source_Start..'تعداد پیام های گروه : [ '..gap_info_msgs..' ]\n'..Source_Start..'شناسه شما : '..msg.sender_user_id..'\n'..Source_Start..'تعداد پیام های شما : [ '..user_info_msgs..' ]\n'..Source_Start..' نام کاربری : @'..msg.from.username or msg.from.first_name..'', 0, 0, 1, nil, dl_cb, nil)
				end
			end
			assert(tdbot_function ({
			_ = "getUserProfilePhotos",
			user_id = msg.sender_user_id,
			offset = 0,
			limit = 1
			}, getpro, nil))
		end
	elseif LuaProFa and (LuaProLw == "id" or LuaProFa == "ایدی" or LuaProFa == "آیدی") and tonumber(msg.reply_to_message_id) ~= 0 and is_mod(msg) and redis:get(RedisIndex.."CheckBot:"..msg.to.id) then
		if redis:get(RedisIndex.."lock_cmd"..msg.chat_id) and not is_mod(msg) then return else
			assert(tdbot_function ({
			_ = "getMessage",
			chat_id = msg.chat_id,
			message_id = msg.reply_to_message_id
			}, action_by_reply, {chat_id=msg.chat_id,cmd="id"}))
		end
	elseif (LuaProLw == "ping" or LuaProFa == "انلاینی"  or LuaProFa == "آنلاینی" ) and redis:get(RedisIndex.."CheckBot:"..msg.to.id) then
		tdbot.sendMention(msg.chat_id,msg.sender_user_id, msg.id,Source_Start..'ربات بروز و آماده به دستور است.'..EndMsg,7, tonumber(Slen("بروز")))
	elseif LuaProLw == "bot" or LuaProFa == "ربات" then
		if redis:get(RedisIndex..'laghab:'..tostring(msg.from.id)) then
			local laghab = redis:get(RedisIndex..'laghab:'..tostring(msg.from.id))
			local bota = {"آنلاینم "..laghab.." 😃✋","آنلاینم "..laghab.." فداتشم😊","آنلاینم "..laghab.." حواسم به گروه هست😎","آنلاینم "..laghab.." به عشق تو❤️","آنلاینم "..laghab.." جونم😍","چیه "..laghab.." اذیتم نکن😰","جانم "..laghab.." چیکارم داری😐","جانم "..laghab.." 😃"}
			local a = bota[math.random(#bota)]
			tdbot.sendMessage(msg.chat_id , msg.id, 1, a, 0, 'md')
		else
			local botb = {"آنلاینم "..check_markdown(msg.from.first_name).." 😃✋","آنلاینم "..check_markdown(msg.from.first_name).." فداتشم😊","آنلاینم "..check_markdown(msg.from.first_name).." حواسم به گروه هست😎","آنلاینم "..check_markdown(msg.from.first_name).." به عشق تو❤️","آنلاینم "..check_markdown(msg.from.first_name).." جونم😍","چیه "..check_markdown(msg.from.first_name).." اذیتم نکن😰","جانم "..check_markdown(msg.from.first_name).." چیکارم داری😐","جانم "..check_markdown(msg.from.first_name).." 😃"}
			local b = botb[math.random(#botb)]
			tdbot.sendMessage(msg.chat_id , msg.id, 1, b, 0, 'md')
		end
	elseif LuaProLw == "rules" or LuaProFa == "قوانین" then
		if not redis:get(RedisIndex..msg.to.id..'rules') then
			rules = Source_Start.."`قوانین ثبت نشده است`"..EndMsg
		else
			rules = Source_Start.."*قوانین گروه :*\n"..redis:get(RedisIndex..msg.to.id..'rules')
		end
		text = rules
		tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
	elseif LuaProFa and (LuaProLw:match('^id (.*)') or LuaProFa:match('^ایدی (.*)') or LuaProFa:match('^آیدی (.*)'))  and redis:get(RedisIndex.."CheckBot:"..msg.to.id) then
		local Matches = LuaProLw:match('^id (.*)') or LuaProFa:match('^ایدی (.*)') or LuaProFa:match('^آیدی (.*)')
		if Matches and is_mod(msg) then
			if msg.content.entities and msg.content.entities[0] and msg.content.entities[0].type._ == "textEntityTypeMentionName" then
				local function idmen(arg, data)
					if data.id then
						local user_name = "پیدا نشد"
						if data.username and data.username ~= "" then user_name = '@'..check_markdown(data.username) end
						local print_name = data.first_name
						if data.last_name and data.last_name ~= "" then print_name = print_name..' '..data.last_name end
						text = Source_Start.."*نام :* "..check_markdown(print_name).."\n"..Source_Start.."*ایدی :* `"..data.id.."`"
						return tdbot.sendMessage(msg.to.id, "", 0, text, 0, "md")
					end
				end
				tdbot.getUser(msg.content.entities[0].type.user_id, idmen)
			end
		end
	elseif (LuaProLw == "info" or LuaProFa == "اطلاعات") and redis:get(RedisIndex.."CheckBot:"..msg.to.id) then
		if tonumber(msg.reply_to_message_id) ~= 0 then
			assert (tdbot_function ({
			_ = "getMessage",
			chat_id = msg.chat_id,
			message_id = msg.reply_to_message_id
			}, info_by_reply, {chat_id=msg.chat_id}))
		end
		if tonumber(msg.reply_to_message_id) == 0 then
			assert (tdbot_function ({
			_ = "getUser",
			user_id = msg.sender_user_id,
			}, info_by_id, {chat_id=msg.chat_id,user_id=msg.sender_user_id,msgid=msg.id}))
		end
	elseif LuaProFa and (LuaProLw:match('^info (.*)') or LuaProFa:match('^اطلاعات (.*)')) and redis:get(RedisIndex.."CheckBot:"..msg.to.id) then
		local Matches = LuaProLw:match('^info (.*)') or LuaProFa:match('^اطلاعات (.*)')
		if Matches and string.match(Matches, '^%d+$') and tonumber(msg.reply_to_message_id) == 0 then
			assert (tdbot_function ({
			_ = "getUser",
			user_id = Matches,
			}, info_by_id, {chat_id=msg.chat_id,user_id=Matches,msgid=msg.id}))
		elseif Matches and not string.match(Matches, '^%d+$') and tonumber(msg.reply_to_message_id) == 0 then
			assert (tdbot_function ({
			_ = "searchPublicChat",
			username = Matches
			}, info_by_username, {chat_id=msg.chat_id,username=Matches,msgid=msg.id}))
		end
	elseif LuaProLw and redis:get(RedisIndex.."ForwardMsg_Cmd"..LuaProLw) then
		local For = redis:get(RedisIndex..'ForwardMsg_Reply'..LuaProLw)
		local Gps = redis:get(RedisIndex..'ForwardMsg_Gp'..LuaProLw)
		tdbot.forwardMessages(msg.chat_id, Gps, {[0] = For}, 1)
	end
	if (LuaProLw == 'add free' or LuaProFa == "نصب رایگان") and msg.to.type == "channel" then
		local function CheckAdmin(arg,data)
			if data.status.can_change_info and data.status.can_delete_messages and data.status.can_restrict_members and data.status.can_promote_members and data.status.can_pin_messages then
				if not redis:get(RedisIndex.."CheckBot:"..msg.chat_id) then
					if not redis:get(RedisIndex.."CheckAddOn:"..msg.chat_id) then
						local user = '['..msg.from.id..'](tg://user?id='..msg.from.id..')'
						redis:setex(RedisIndex.."ReqMenu:" .. msg.chat_id .. ":" .. msg.from.id, 260, true)
						Text = Source_Start..'*گروه* '..msg.chat_id..' *به مدت [2] روز شارژ برای تست کامل توسط* '..user..' - '..check_markdown(msg.from.first_name)..' *به لیست گروه های ربات اضافه شد*'..EndMsg
						redis:set(RedisIndex.."CheckBot:"..msg.chat_id ,true)
						redis:set(RedisIndex.."CheckAddOn:"..msg.chat_id ,true)
						redis:set(RedisIndex..'ExpireDate:'..msg.chat_id,true)
						redis:setex(RedisIndex..'ExpireDate:'..msg.chat_id, 172800, true)
						if not redis:get(RedisIndex..'CheckExpire::'..msg.chat_id) then
							redis:set(RedisIndex..'CheckExpire::'..msg.chat_id,true)
						end
						redis:sadd(RedisIndex.."Group" ,msg.chat_id)
						set_config(msg)
						redis:set(RedisIndex.."Gpnameset"..msg.to.id ,msg.to.title)
						local function callback_link (arg, data)
							if data.invite_link then
								redis:set(RedisIndex..msg.chat_id..'linkgpset', data.invite_link)
							end
						end
						tdbot.exportChatInviteLink(msg.chat_id, callback_link, nil)
						tdbot.sendMessage(Config.Cleaner_id, 0, 1,"import "..(redis:get(RedisIndex..msg.chat_id..'linkgpset') or ""), 1, 'md')
						keyboard = {}
						keyboard.inline_keyboard = {
						{
						{text = Source_Start..'کانال ما 📜', url = 'https://t.me/'..channel_inline..''}
						},
						}
						SendInlineApi(msg.chat_id, Text, keyboard, 'md')
					else
						tdbot.sendMessage(msg.chat_id, msg.id, 1, Source_Start.."*این گروه یک بار رایگان اد شده است*"..EndMsg, 1, 'md')
					end
				end
			else
				change = data.status.can_change_info and '[✓]' or '[✘]'
				delete = data.status.can_delete_messages and '[✓]' or '[✘]'
				restrict =  data.status.can_restrict_members and '[✓]' or '[✘]'
				promote = data.status.can_promote_members and '[✓]' or '[✘]'
				pin = data.status.can_pin_messages and '[✓]' or '[✘]'
				text = Source_Start..'*دسترسی ربات کامل نمیباشد*'..EndMsg..'\n\n'..Source_Start..'*دسترسی های ربات :*\n`اخراج و محدود کردن : '..restrict..'\nتغییر اطلاعات گروه : '..change..'\nارتقا به ادمین : '..promote..'\nسنجاق پیام : '..pin..'\nحذف پیام : '..delete..'`'
			end
			tdbot.sendMessage(msg.chat_id, msg.id, 1, text, 1, 'md')
		end
		tdbot.getChatMember(msg.chat_id, Config.Api_Id, CheckAdmin)
	end
end

function tdbot_update_callback (data)
	if (data._ == "updateNewMessage") then
		local msg = data.message
		local d = data.disable_notification
		local chat = chats[msg.chat_id]
		local hash = 'msgs:'..(msg.sender_user_id or 0)..':'..msg.chat_id
		local gaps = 'msgs:'..(msg.chat_id or 0)
		redis:incr(RedisIndex..hash)
		redis:incr(RedisIndex..gaps)
		if redis:get(RedisIndex..'markread') == 'on' then
			tdbot.viewMessages(msg.chat_id, {[0] = msg.id}, dl_cb, nil)
		end
		if ((not d) and chat) then
			if msg.content._ == "messageText" then
				do_notify (chat.title, msg.content.text)
			else
				do_notify (chat.title, msg.content._)
			end
		end
		if redis:get(RedisIndex.."checkpin"..msg.chat_id) then
			redis:del(RedisIndex.."checkpin"..msg.chat_id)
			tdbot.pinChannelMessage(msg.chat_id, msg.id, 1, dl_cb, nil)
		end
		if msg_valid(msg) then
			local AutoDownload = redis:get(RedisIndex..'AutoDownload:'..msg.chat_id)
			var_cb(msg, msg)
			if AutoDownload then
				file_cb(msg)
			end
			if msg.forward_info then
				if msg.forward_info._ == "messageForwardedFromUser" then
					msg.fwd_from_user = true
					
				elseif msg.forward_info._ == "messageForwardedPost" then
					msg.fwd_from_channel = true
				end
			end
			if msg.content._ == "messageText" then
				msg.text = msg.content.text
				msg.edited = false
				msg.pinned = false
			elseif msg.content._ == "messagePinMessage" then
				msg.pinned = true
			elseif msg.content._ == "messagePhoto" then
				msg.photo = true
			elseif msg.content._ == "messageVideo" then
				msg.video = true
				
			elseif msg.content._ == "messageVideoNote" then
				msg.video_note = true
				
			elseif msg.content._ == "messageAnimation" then
				msg.animation = true
				
			elseif msg.content._ == "messageVoice" then
				msg.voice = true
				
			elseif msg.content._ == "messageAudio" then
				msg.audio = true
				
			elseif msg.content._ == "messageSticker" then
				msg.sticker = true
				
			elseif msg.content._ == "messageContact" then
				msg.contact = true
				
			elseif msg.content._ == "messageDocument" then
				msg.document = true
				
			elseif msg.content._ == "messageLocation" then
				msg.location = true
			elseif msg.content._ == "messageGame" then
				msg.game = true
			elseif msg.content._ == "messageChatAddMembers" then
				for k,v in pairs(msg.content.member_user_ids) do
					msg.adduser = v
				end
				msg.tab = true
			elseif msg.content._ == "messageChatJoinByLink" then
				msg.joinuser = (msg.sender_user_id or 0)
			elseif msg.content._ == "messageChatDeleteMember" then
				msg.deluser = true
				
			end
		end
	elseif data._ == "updateMessageEdited" then
		local function edited_cb(arg, data)
			msg = data
			msg.media = {}
			msg.text = msg.content.text
			msg.media.caption = msg.content.caption
			msg.edited = true
			if msg_valid(msg) then
				var_cb(msg, msg)
			end
		end
		assert (tdbot_function ({ _ = "getMessage", chat_id = data.chat_id, message_id = data.message_id }, edited_cb, nil))
		assert (tdbot_function ({_ = "openChat", chat_id = data.chat_id}, dl_cb, nil))
	elseif data._ == "updateMessageSendSucceeded" then
		local msg = data.message
		local text = msg.content.text
		if text then
			if text:match("(.*)") then
				if redis:get(RedisIndex.."delbot"..msg.chat_id) then
					if redis:get(RedisIndex.."delbotcheck"..msg.chat_id) then
						redis:del(RedisIndex.."delbotcheck"..msg.chat_id)
						redis:sadd(RedisIndex.."MsgIdBoT"..msg.chat_id, msg.id)
					end
				end
			end
		end
	elseif (data._ == "updateChat") then
		chat = data.chat
		chats[chat.id] = chat
	elseif (data._ == "updateOption" and data.name == "my_id") then
		assert (tdbot_function ({_ = 'openMessageContent', chat_id = data.chat_id, message_id = data.message_id}, dl_cb, nil))
		assert (tdbot_function ({_ = "getChats", offset_order="9223372036854775807", offset_chat_id=0, limit=20}, dl_cb, nil))
	end
end