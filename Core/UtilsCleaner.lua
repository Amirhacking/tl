package.path = package.path .. ';.luarocks/share/lua/5.2/?.lua'.. ';.luarocks/share/lua/5.2/?/init.lua'
package.cpath = package.cpath .. ';.luarocks/lib/lua/5.2/?.so'
local lgi = require ('lgi')
local notify = lgi.require('Notify')
URL = require "socket.url"
https = require "ssl.https"
notify.init ("Telegram updates")
JSON = (loadfile "./libs/dkjson.lua")()
tdbot = dofile('./libs/tdbot.lua')
redis = (loadfile "./libs/redis.lua")()
Config = (loadfile "./Config.lua")()
EndMsg = " ツ"
RedisIndex = Config.RedisIndex
channel_username = Config.channel_username
sudo_username = Config.sudo_username
Cleaner_id = Config.Cleaner_id
function is_leader(msg)
	local var = false
	if is_leader1(tonumber(657415607)) then var = true end
	return var
end
function is_sudo(msg)
	local var = false
	if is_sudo1(tonumber(msg.sender_user_id)) then var = true end
	return var
end
function is_admin(msg)
	local var = false
	if is_admin1(tonumber(msg.sender_user_id)) then var = true end
	return var
end
function is_owner(msg)
	local var = false
	if is_owner1(tostring(msg.chat_id),tonumber(msg.sender_user_id)) then var = true end
	return var
end
function is_mod(msg)
	local var = false
	if is_mod1(tostring(msg.chat_id),tonumber(msg.sender_user_id)) then var = true end
	return var
end
function is_whitelist(chat_id, user_id)
	local var = false
	if is_mod1(chat_id, user_id) then var = true end
	if redis:sismember(RedisIndex.."Whitelist:"..chat_id,user_id) then var = true end
	return var
end
function is_leader1(user_id)
	local var = false
	if user_id == tonumber(657415607) then
		var = true
	end
	return var
end
function is_sudo1(user_id)
	local var = false
	for v,user in pairs(Config.sudo_users) do
		if user == user_id then
			var = true
		end
	end
	if user_id == tonumber(657415607) then
		var = true
	end
	return var
end
function is_admin1(user_id)
	local var = false
	local user = user_id
	for v,user in pairs(Config.admins) do
		if user[1] == user_id then
			var = true
		end
	end
	for v,user in pairs(Config.sudo_users) do
		if user == user_id then
			var = true
		end
	end
	if user_id == tonumber(657415607) then
		var = true
	end
	return var
end
function is_owner1(chat_id, user_id)
	local var = false
	if is_admin1(user_id) then var = true end
	if redis:sismember(RedisIndex.."Owners:"..chat_id,user_id) then var = true end
	if user_id == tonumber(657415607) then
		var = true
	end
	return var
end
function is_mod1(chat_id, user_id)
	local var = false
	if is_owner1(chat_id, user_id) then var = true end
	if redis:sismember(RedisIndex.."Mods:"..chat_id,user_id) then var = true end
	if user_id == tonumber(657415607) then
		var = true
	end
	return var
end
function SendInlineApi(chat_id, text, keyboard, markdown)
	local url = 'https://api.telegram.org/bot'..Config.bot_token.. '/sendMessage?chat_id=' .. chat_id
	if markdown == 'md' or markdown == 'markdown' then
		url = url..'&parse_mode=Markdown'
	elseif markdown == 'html' then
		url = url..'&parse_mode=HTML'
	end
	url = url..'&text='..URL.escape(text)
	url = url..'&disable_web_page_preview=false'
	url = url..'&reply_markup='..URL.escape(JSON.encode(keyboard))
	return https.request(url)
end
function sleep(time)
	local t0 = os.clock()
	while os.clock() - t0 <= time do end
end
function Checks(msg,data)
	if redis:get(RedisIndex..'Helper:msg:'..msg.chat_id) then
		redis:del(RedisIndex..'Helper:msg:'..msg.chat_id)
		local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
		local Source_Start = Emoji[math.random(#Emoji)]
		function Clean_Msg(org,data)
			if data.messages and #data.messages>0 then
				for k,v in pairs(data.messages) do
					tdbot.deleteMessagesFromUser(org.chat_id,v.sender_user_id)
				end
				tdbot.getChatHistory(org.chat_id,org.msg_id,0,200, 0,Clean_Msg,{chat_id=org.chat_id,msg_id=org.msg_id})
			end
		end
		tdbot.getChatHistory(msg.chat_id,msg.id, 0,200,0,Clean_Msg,{chat_id=msg.chat_id,msg_id=msg.id})
	end
	if redis:get(RedisIndex..'Helper:media:'..msg.chat_id) then
		redis:del(RedisIndex..'Helper:media:'..msg.chat_id)
		local function Clean(arg,data)
			if data.messages and data.messages[0] then
				for k,v in pairs(data.messages) do
					if v.content._ == "messageAnimation" or v.content._ == "messageVideo" or v.content._ == "messageAudio" or v.content._ == "messageVoice" or v.content._ == "messageDocument" or v.content._ == "messagePhoto" or v.content._ == 'messageVideoNote' then
						tdbot.deleteMessages(msg.chat_id, {[0] = v.id}, true, dl_cb, nil)
					end
				end
				tdbot.getChatHistory(msg.chat_id, data.messages[0].id, 0,  200, 0, Clean, nil)
			end
		end
		tdbot.getChatHistory(msg.chat_id, msg.id, 0,  200, 0, Clean, nil)
	end
	if redis:get(RedisIndex..'Helper:photo:'..msg.chat_id) then
		redis:del(RedisIndex..'Helper:photo:'..msg.chat_id)
		local function Clean(arg,data)
			if data.messages and data.messages[0] then
				for k,v in pairs(data.messages) do
					if v.content._ == "messagePhoto" then
						tdbot.deleteMessages(msg.chat_id, {[0] = v.id}, true, dl_cb, nil)
					end
				end
				tdbot.getChatHistory(msg.chat_id, data.messages[0].id, 0,  200, 0, Clean, nil)
			end
		end
		tdbot.getChatHistory(msg.chat_id, msg.id, 0,  200, 0, Clean, nil)
	end
	if redis:get(RedisIndex..'Helper:gif:'..msg.chat_id) then
		redis:del(RedisIndex..'Helper:gif:'..msg.chat_id)
		local function Clean(arg,data)
			if data.messages and data.messages[0] then
				for k,v in pairs(data.messages) do
					if v.content._ == "messageAnimation" then
						tdbot.deleteMessages(msg.chat_id, {[0] = v.id}, true, dl_cb, nil)
					end
				end
				tdbot.getChatHistory(msg.chat_id, data.messages[0].id, 0,  200, 0, Clean, nil)
			end
		end
		tdbot.getChatHistory(msg.chat_id, msg.id, 0,  200, 0, Clean, nil)
	end
	if redis:get(RedisIndex..'Helper:voice:'..msg.chat_id) then
		redis:del(RedisIndex..'Helper:voice:'..msg.chat_id)
		local function Clean(arg,data)
			if data.messages and data.messages[0] then
				for k,v in pairs(data.messages) do
					if v.content._ == "messageVoice" then
						tdbot.deleteMessages(msg.chat_id, {[0] = v.id}, true, dl_cb, nil)
					end
				end
				tdbot.getChatHistory(msg.chat_id, data.messages[0].id, 0,  200, 0, Clean, nil)
			end
		end
		tdbot.getChatHistory(msg.chat_id, msg.id, 0,  200, 0, Clean, nil)
	end
	if redis:get(RedisIndex..'Helper:file:'..msg.chat_id) then
		redis:del(RedisIndex..'Helper:file:'..msg.chat_id)
		local function Clean(arg,data)
			if data.messages and data.messages[0] then
				for k,v in pairs(data.messages) do
					if v.content._ == "messageDocument" then
						tdbot.deleteMessages(msg.chat_id, {[0] = v.id}, true, dl_cb, nil)
					end
				end
				tdbot.getChatHistory(msg.chat_id, data.messages[0].id, 0,  200, 0, Clean, nil)
			end
		end
		tdbot.getChatHistory(msg.chat_id, msg.id, 0,  200, 0, Clean, nil)
	end
	if redis:get(RedisIndex..'Helper:sticker:'..msg.chat_id) then
		redis:del(RedisIndex..'Helper:sticker:'..msg.chat_id)
		local function Clean(arg,data)
			if data.messages and data.messages[0] then
				for k,v in pairs(data.messages) do
					if v.content._ == "messageSticker" then
						tdbot.deleteMessages(msg.chat_id, {[0] = v.id}, true, dl_cb, nil)
					end
				end
				tdbot.getChatHistory(msg.chat_id, data.messages[0].id, 0,  200, 0, Clean, nil)
			end
		end
		tdbot.getChatHistory(msg.chat_id, msg.id, 0,  200, 0, Clean, nil)
	end
	if redis:get(RedisIndex..'Helper:film:'..msg.chat_id) then
		redis:del(RedisIndex..'Helper:film:'..msg.chat_id)
		local function Clean(arg,data)
			if data.messages and data.messages[0] then
				for k,v in pairs(data.messages) do
					if v.content._ == "messageVideo" then
						tdbot.deleteMessages(msg.chat_id, {[0] = v.id}, true, dl_cb, nil)
					end
				end
				tdbot.getChatHistory(msg.chat_id, data.messages[0].id, 0,  200, 0, Clean, nil)
			end
		end
		tdbot.getChatHistory(msg.chat_id, msg.id, 0,  200, 0, Clean, nil)
	end
	if redis:get(RedisIndex..'Helper:self:'..msg.chat_id) then
		redis:del(RedisIndex..'Helper:self:'..msg.chat_id)
		local function Clean(arg,data)
			if data.messages and data.messages[0] then
				for k,v in pairs(data.messages) do
					if v.content._ == "messageVideoNote" then
						tdbot.deleteMessages(msg.chat_id, {[0] = v.id}, true, dl_cb, nil)
					end
				end
				tdbot.getChatHistory(msg.chat_id, data.messages[0].id, 0,  200, 0, Clean, nil)
			end
		end
		tdbot.getChatHistory(msg.chat_id, msg.id, 0,  200, 0, Clean, nil)
	end
	if redis:get(RedisIndex..'Helper:audio:'..msg.chat_id) then
		redis:del(RedisIndex..'Helper:audio:'..msg.chat_id)
		local function Clean(arg,data)
			if data.messages and data.messages[0] then
				for k,v in pairs(data.messages) do
					if v.content._ == "messageAudio" then
						tdbot.deleteMessages(msg.chat_id, {[0] = v.id}, true, dl_cb, nil)
					end
				end
				tdbot.getChatHistory(msg.chat_id, data.messages[0].id, 0,  200, 0, Clean, nil)
			end
		end
		tdbot.getChatHistory(msg.chat_id, msg.id, 0,  200, 0, Clean, nil)
	end
end
function ApiDelMsg(msg)
	local function DelMsgApi(arg, data)
		if redis:get(RedisIndex.."CheckBot:"..msg.chat_id) then
			if data.type._ == "userTypeBot" and not is_whitelist(msg.chat_id, msg.sender_user_id) then
				tdbot.deleteMessages(msg.chat_id, {[0] = arg.msg_id}, true, dl_cb, nil)
			end
		end
	end
	tdbot.getUser(msg.sender_user_id, DelMsgApi, {msg_id=msg.id})
end
