require('./Core/UtilsCleaner')
function showedit(msg,data)
	if msg then
		if msg.date < os.time() - 60 then
			return false
		end
		if msg.send_state._ == "messageIsSuccessfullySent" then
			return false
		end
		local CmdMatches = msg.content.text
		local Import = msg.content.text
		if msg_type == 'text' and CmdMatches then
			if CmdMatches:match('^[/#]') then
				CmdMatches=  CmdMatches:gsub('^[/#]','')
			end
		end
		if CmdMatches then
			CmdMatches = CmdMatches:lower()
		end
		local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
		local Source_Start = Emoji[math.random(#Emoji)]
		if (CmdMatches == 'reload' or CmdMatches == 'بروز') and is_sudo(msg) then
			dofile('./Cleaner.lua')
			tdbot.sendMessage(msg.chat_id, msg.id, 1, Source_Start..'*ربات بروزرسانی شد*'..EndMsg, 1, 'md')
		end
		if Import and Import:match('^import (.*)') and is_sudo(msg) then
			local Matches = Import:match('^import (.*)')
			if Matches:match("^([https?://w]*.?telegram.me/joinchat/.*)$") or Matches:match("^([https?://w]*.?t.me/joinchat/.*)$") then
				local link = Matches
				if link:match('t.me') then
					link = string.gsub(link, 't.me', 'telegram.me')
				end
				tdbot.importChatInviteLink(link, dl_cb, nil)
				tdbot.sendMessage(msg.chat_id , msg.id, 1, Source_Start..' '..link..' '..EndMsg, 0, 'html')
			end
		end
		if CmdMatches and (CmdMatches:match('^leavee (-%d+)')) and is_sudo(msg) then
			local Matches = CmdMatches:match('^leavee (-%d+)')
			tdbot.changeChatMemberStatus(Matches, Cleaner_id, 'Left', dl_cb, nil)
			tdbot.sendMessage(msg.chat_id , msg.id, 1, Matches, 0, 'html')
		end
		if CmdMatches and (CmdMatches:match('^clean (.*)') or CmdMatches:match('^پاکسازی (.*)')) and is_mod(msg) then
			local CmdEn = {
			string.match(CmdMatches, "^(clean) (.*)$")
			}
			local CmdFa = {
			string.match(CmdMatches, "^(پاکسازی) (.*)$")
			}
			if CmdEn[2] == 'msgs' or CmdFa[2] == 'پیام ها' then
				function Clean_Msg(org,data)
					if data.messages and #data.messages>0 then
						for k,v in pairs(data.messages) do
							tdbot.deleteMessagesFromUser(org.chat_id,v.sender_user_id)
						end
						tdbot.getChatHistory(org.chat_id,org.msg_id,0,200, 0,Clean_Msg,{chat_id=org.chat_id,msg_id=org.msg_id})
					else
						tdbot.sendMessage(msg.chat_id, msg.id, 1, Source_Start..'`پیام های گروه پاکسازی شد`'..EndMsg..'', 1, 'md')
					end
				end
				tdbot.getChatHistory(msg.chat_id,msg.id, 0,200,0,Clean_Msg,{chat_id=msg.chat_id,msg_id=msg.id})
			end
			if CmdEn[2] == 'photos' or CmdFa[2] == 'عکس ها' then
				local function Clean(arg,data)
					if data.messages then
						for k,v in pairs(data.messages) do
							if v.content._ == "messagePhoto" then
								tdbot.deleteMessages(msg.chat_id, {[0] = v.id}, true, dl_cb, nil)
							end
						end
						if data.messages[0] then
							tdbot.getChatHistory(msg.chat_id, data.messages[0].id, 0,  200, 0, Clean, nil)
						end
					end
				end
				tdbot.sendMessage(msg.chat_id, msg.id, 1, Source_Start..'`عکس های گروه پاکسازی شد`'..EndMsg..'', 1, 'md')
				tdbot.getChatHistory(msg.chat_id, msg.id, 0,  200, 0, Clean, nil)
			end
			if CmdEn[2] == 'gifs' or CmdFa[2] == 'گیف ها' then
				local function Clean(arg,data)
					if data.messages then
						for k,v in pairs(data.messages) do
							if v.content._ == "messageAnimation" then
								tdbot.deleteMessages(msg.chat_id, {[0] = v.id}, true, dl_cb, nil)
							end
						end
						if data.messages[0] then
							tdbot.getChatHistory(msg.chat_id, data.messages[0].id, 0,  200, 0, Clean, nil)
						end
					end
				end
				tdbot.sendMessage(msg.chat_id, msg.id, 1, Source_Start..'`گیف های گروه پاکسازی شد`'..EndMsg..'', 1, 'md')
				tdbot.getChatHistory(msg.chat_id, msg.id, 0,  200, 0, Clean, nil)
			end
			if CmdEn[2] == 'stickers' or CmdFa[2] == 'استیکر ها' then
				local function Clean(arg,data)
					if data.messages then
						for k,v in pairs(data.messages) do
							if v.content._ == "messageSticker" then
								tdbot.deleteMessages(msg.chat_id, {[0] = v.id}, true, dl_cb, nil)
							end
						end
						if data.messages[0] then
							tdbot.getChatHistory(msg.chat_id, data.messages[0].id, 0,  200, 0, Clean, nil)
						end
					end
				end
				tdbot.sendMessage(msg.chat_id, msg.id, 1, Source_Start..'`استیکر های گروه پاکسازی شد`'..EndMsg..'', 1, 'md')
				tdbot.getChatHistory(msg.chat_id, msg.id, 0,  200, 0, Clean, nil)
			end
			if CmdEn[2] == 'videos' or CmdFa[2] == 'فیلم ها' then
				local function Clean(arg,data)
					if data.messages then
						for k,v in pairs(data.messages) do
							if v.content._ == "messageVideo" then
								tdbot.deleteMessages(msg.chat_id, {[0] = v.id}, true, dl_cb, nil)
							end
						end
						if data.messages[0] then
							tdbot.getChatHistory(msg.chat_id, data.messages[0].id, 0,  200, 0, Clean, nil)
						end
					end
				end
				tdbot.sendMessage(msg.chat_id, msg.id, 1, Source_Start..'`فیلم های گروه پاکسازی شد`'..EndMsg..'', 1, 'md')
				tdbot.getChatHistory(msg.chat_id, msg.id, 0,  200, 0, Clean, nil)
			end
			if CmdEn[2] == 'voices' or CmdFa[2] == 'ویس ها' then
				local function Clean(arg,data)
					if data.messages then
						for k,v in pairs(data.messages) do
							if v.content._ == "messageVoice" then
								tdbot.deleteMessages(msg.chat_id, {[0] = v.id}, true, dl_cb, nil)
							end
						end
						if data.messages[0] then
							tdbot.getChatHistory(msg.chat_id, data.messages[0].id, 0,  200, 0, Clean, nil)
						end
					end
				end
				tdbot.sendMessage(msg.chat_id, msg.id, 1, Source_Start..'`ویس های گروه پاکسازی شد`'..EndMsg..'', 1, 'md')
				tdbot.getChatHistory(msg.chat_id, msg.id, 0,  200, 0, Clean, nil)
			end
			if CmdEn[2] == 'audios' or CmdFa[2] == 'آهنگ ها' then
				local function Clean(arg,data)
					if data.messages then
						for k,v in pairs(data.messages) do
							if v.content._ == "messageAudio" then
								tdbot.deleteMessages(msg.chat_id, {[0] = v.id}, true, dl_cb, nil)
							end
						end
						if data.messages[0] then
							tdbot.getChatHistory(msg.chat_id, data.messages[0].id, 0,  200, 0, Clean, nil)
						end
					end
				end
				tdbot.sendMessage(msg.chat_id, msg.id, 1, Source_Start..'`آهنگ های گروه پاکسازی شد`'..EndMsg..'', 1, 'md')
				tdbot.getChatHistory(msg.chat_id, msg.id, 0,  200, 0, Clean, nil)
			end
			if CmdEn[2] == 'documents' or CmdFa[2] == 'فایل ها' then
				local function Clean(arg,data)
					if data.messages then
						for k,v in pairs(data.messages) do
							if v.content._ == "messageDocument" then
								tdbot.deleteMessages(msg.chat_id, {[0] = v.id}, true, dl_cb, nil)
							end
						end
						if data.messages[0] then
							tdbot.getChatHistory(msg.chat_id, data.messages[0].id, 0,  200, 0, Clean, nil)
						end
					end
				end
				tdbot.sendMessage(msg.chat_id, msg.id, 1, Source_Start..'`فایل های گروه پاکسازی شد`'..EndMsg..'', 1, 'md')
				tdbot.getChatHistory(msg.chat_id, msg.id, 0,  200, 0, Clean, nil)
			end
			if CmdEn[2] == 'videonotes' or CmdFa[2] == 'فیلم سلفی ها' then
				local function Clean(arg,data)
					if data.messages then
						for k,v in pairs(data.messages) do
							if v.content._ == "messageVideoNote" then
								tdbot.deleteMessages(msg.chat_id, {[0] = v.id}, true, dl_cb, nil)
							end
						end
						if data.messages[0] then
							tdbot.getChatHistory(msg.chat_id, data.messages[0].id, 0,  200, 0, Clean, nil)
						end
					end
				end
				tdbot.sendMessage(msg.chat_id, msg.id, 1, Source_Start..'`فیلم سلفی های گروه پاکسازی شد`'..EndMsg..'', 1, 'md')
				tdbot.getChatHistory(msg.chat_id, msg.id, 0,  200, 0, Clean, nil)
			end
			if CmdEn[2] == 'media' or CmdFa[2] == 'رسانه' then
				local function Clean(arg,data)
					if data.messages then
						for k,v in pairs(data.messages) do
							if v.content._ == "messageAnimation" or v.content._ == "messageVideo" or v.content._ == "messageAudio" or v.content._ == "messageVoice" or v.content._ == "messageDocument" or v.content._ == "messagePhoto" or v.content._ == 'messageVideoNote' then
								tdbot.deleteMessages(msg.chat_id, {[0] = v.id}, true, dl_cb, nil)
							end
						end
						if data.messages[0] then
							tdbot.getChatHistory(msg.chat_id, data.messages[0].id, 0,  200, 0, Clean, nil)
						end
					end
				end
				tdbot.sendMessage(msg.chat_id, msg.id, 1, Source_Start..'`رسانه های گروه پاکسازی شد`'..EndMsg..'', 1, 'md')
				tdbot.getChatHistory(msg.chat_id, msg.id, 0,  200, 0, Clean, nil)
			end
		end
	end
end
function msg_valid(msg)
	if msg.date and msg.date < os.time() - 60 then
		print('\027[» OLD MESSAGE « \027[00m')
		return false
	end
	return true
end
function tdbot_update_callback(data)
	if (data._ == "updateNewMessage") or (data._ == "updateNewChannelMessage") then
		if msg_valid(data.message) then
			showedit(data.message,data)
			ApiDelMsg(data.message)
		end
	elseif (data._== "updateMessageEdited") then
		data = data
		local function edit(extra,result,success)
			showedit(result,data)
			Checks(result,data)
		end
		tdbot_function ({
		_ = "openChat",
		chat_id = data.chat_id
		}, dl_cb, nil)
		tdbot_function ({
		_ = "getMessage",
		chat_id = data.chat_id,
		message_id = data.message_id
		}, edit, nil)
		assert (tdbot_function ({
		_ = 'openMessageContent',
		chat_id = data.chat_id,
		message_id = data.message_id
		}, dl_cb, nil))
		tdbot_function ({
		_="getChats",
		offset_order="9223372036854775807",
		offset_chat_id=0,
		limit=20
		}, dl_cb, nil)
		
	end
end
