lgi = require ('lgi')
notify = lgi.require('Notify')
notify.init ("Telegram updates")
chats = {}
tdbot = dofile('./libs/tdbot.lua')
serpent = (loadfile "./libs/serpent.lua")()
Config = (loadfile "./Config.lua")()
require('./libs/lua-redis')
URL = require "socket.url"
http = require "socket.http"
https = require "ssl.https"
ltn12 = require "ltn12"
json = (loadfile "./libs/JSON.lua")()
mimetype = (loadfile "./libs/mimetype.lua")()
redis = (loadfile "./libs/redis.lua")()
JSON = (loadfile "./libs/dkjson.lua")()
gp_sudo = Config.gp_sudo
RedisIndex = Config.RedisIndex
bot_token = Config.bot_token
channel_username = Config.channel_username
channel_inline = Config.channel_inline
sudo_username = Config.sudo_username
SUDO = Config.SUDO
Cleaner_id = Config.Cleaner_id
Bot_inline = Config.Bot_inline
EndMsg = " ツ"
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
function do_notify (user, msg)
	local n = notify.Notification.new(user, msg)
	n:show ()
end
function whoami()
	local usr = io.popen("whoami"):read('*a')
	usr = string.gsub(usr, '^%s+', '')
	usr = string.gsub(usr, '%s+$', '')
	usr = string.gsub(usr, '[\n\r]+', ' ')
	if usr:match("^root$") then
		tcpath = '/root/.telegram-bot/main'
	elseif not usr:match("^root$") then
		tcpath = '/home/'..usr..'/.telegram-bot/main'
	end
end
whoami()
function run_bash(str)
	local cmd = io.popen(str)
	local result = cmd:read('*all')
	return result
end
function index_function(user_id)
	for k,v in pairs(Config.admins) do
		if user_id == v[1] then
			print(k)
			return k
		end
	end
	return false
end
function getindex(t,id)
	for i,v in pairs(t) do
		if v == id then
			return i
		end
	end
	return nil
end
function already_sudo(user_id)
	for k,v in pairs(Config.sudo_users) do
		if user_id == v then
			return k
		end
	end
	return false
end
function sleep(time)
	local t0 = os.clock()
	while os.clock() - t0 <= time do end
end
function serialize_to_file(data, file, uglify)
	file = io.open(file, 'w+')
	local serialized
	if not uglify then
		serialized = serpent.block(data, {
		comment = false,
		name = '_'
		})
	else
		serialized = serpent.dump(data)
	end
	file:write(serialized)
	file:close()
end
function save_config( )
	serialize_to_file(Config, './Config.lua')
end
function get_http_file_name(url, headers)
	local file_name = url:match("[^%w]+([%.%w]+)$")
	file_name = file_name or url:match("[^%w]+(%w+)[^%w]+$")
	file_name = file_name or str:random(5)
	local content_type = headers["content-type"]
	local extension = nil
	if content_type then
		extension = mimetype.get_mime_extension(content_type)
	end
	if extension then
		file_name = file_name.."."..extension
	end
	local disposition = headers["content-disposition"]
	if disposition then
		file_name = disposition:match('filename=([^;]+)') or file_name
	end
	return file_name
end
function string.starts(String, Start)
	return Start == string.sub(String,1,string.len(Start))
end
function scandir(directory)
	local i, t, popen = 0, {}, io.popen
	for filename in popen('ls -a "'..directory..'"'):lines() do
		i = i + 1
		t[i] = filename
	end
	return t
end
function exi_filef(path, suffix)
	local files = {}
	local pth = tostring(path)
	local psv = tostring(suffix)
	for k, v in pairs(scandir(pth)) do
		if (v:match('.'..psv..'$')) then
			table.insert(files, v)
		end
	end
	return files
end
function file_exif(name, path, suffix)
	local fname = tostring(name)
	local pth = tostring(path)
	local psv = tostring(suffix)
	for k,v in pairs(exi_filef(pth, psv)) do
		if fname == v then
			return true
		end
	end
	return false
end
function download_to_file(url, file_name)
	local respbody = {}
	local options = {
	url = url,
	sink = ltn12.sink.table(respbody),
	redirect = true
	}
	local response = nil
	
	if url:starts('https') then
		options.redirect = false
		response = {https.request(options)}
	else
		response = {http.request(options)}
	end
	
	local code = response[2]
	local headers = response[3]
	local status = response[4]
	
	if code ~= 200 then return nil end
	
	file_name = file_name or get_http_file_name(url, headers)
	
	local file_path = "Download/"..file_name
	file = io.open(file_path, "w+")
	file:write(table.concat(respbody))
	file:close()
	
	return file_path
end
local function Scharbytes(s, i)
	local byte    = string.byte
	i = i or 1
	if type(s) ~= "string" then
	end
	if type(i) ~= "number" then
	end
	local c = byte(s, i)
	if c > 0 and c <= 127 then
		return 1
	elseif c >= 194 and c <= 223 then
		local c2 = byte(s, i + 1)
		if not c2 then
		end
		if c2 < 128 or c2 > 191 then
		end
		return 2
	elseif c >= 224 and c <= 239 then
		local c2 = byte(s, i + 1)
		local c3 = byte(s, i + 2)
		if not c2 or not c3 then
		end
		if c == 224 and (c2 < 160 or c2 > 191) then
		elseif c == 237 and (c2 < 128 or c2 > 159) then
		elseif c2 < 128 or c2 > 191 then
		end
		if c3 < 128 or c3 > 191 then
		end
		return 3
	elseif c >= 240 and c <= 244 then
		local c2 = byte(s, i + 1)
		local c3 = byte(s, i + 2)
		local c4 = byte(s, i + 3)
		if not c2 or not c3 or not c4 then
		end
		if c == 240 and (c2 < 144 or c2 > 191) then
		elseif c == 244 and (c2 < 128 or c2 > 143) then
		elseif c2 < 128 or c2 > 191 then
		end
		if c3 < 128 or c3 > 191 then
		end
		if c4 < 128 or c4 > 191 then
		end
		return 4
	else
	end
end
function Slen(s)
	if type(s) ~= "string" then
		for k,v in pairs(s) do print('"',tostring(k),'"',tostring(v),'"') end
	end
	local pos = 1
	local bytes = string.len(s)
	local length = 0
	while pos <= bytes do
		length = length + 1
		pos = pos + Scharbytes(s, pos)
	end
	return length
end
function string:split(sep)
	local sep, fields = sep or ":", {}
	local pattern = string.format("([^%s]+)", sep)
	self:gsub(pattern, function(c) fields[#fields+1] = c end)
	return fields
end
function msg_valid(msg)
	if msg.date and msg.date < os.time() - 60 then
		print('\027['..color.white[1]..' » OLD MESSAGE « \027[00m')
		return false
	end
	if is_banned((msg.sender_user_id or 0), msg.chat_id) then
		del_msg(msg.chat_id, tonumber(msg.id))
		kick_user((msg.sender_user_id or 0), msg.chat_id)
		return false
	end
	if is_gbanned((msg.sender_user_id or 0)) then
		del_msg(msg.chat_id, tonumber(msg.id))
		kick_user((msg.sender_user_id or 0), msg.chat_id)
		return false
	end
	return true
end
function file_cb(msg)
	if msg.content._ == "messagePhoto" then
		photo_id = ''
		local function get_cb(arg, data)
			if data.content then
				if data.content.photo.sizes[2] then
					photo_id = data.content.photo.sizes[2].photo.id
				else
					photo_id = data.content.photo.sizes[1].photo.id
				end
				tdbot.downloadFile(photo_id, 32, dl_cb, nil)
			end
		end
		tdbot.getMessage(msg.chat_id, msg.id, get_cb, nil)
	elseif msg.content._ == "messageVideo" then
		video_id = ''
		local function get_cb(arg, data)
			if data.content then
				video_id = data.content.video.video.id
				tdbot.downloadFile(video_id, 32, dl_cb, nil)
			end
		end
		tdbot.getMessage(msg.chat_id, msg.id, get_cb, nil)
	elseif msg.content._ == "messageAnimation" then
		anim_id, anim_name = '', ''
		local function get_cb(arg, data)
			if data.content then
				anim_id = data.content.animation.animation.id
				anim_name = data.content.animation.file_name
				tdbot.downloadFile(anim_id, 32, dl_cb, nil)
			end
		end
		tdbot.getMessage(msg.chat_id, msg.id, get_cb, nil)
	elseif msg.content._ == "messageVoice" then
		voice_id = ''
		local function get_cb(arg, data)
			if data.content then
				voice_id = data.content.voice.voice.id
				tdbot.downloadFile(voice_id, 32, dl_cb, nil)
			end
		end
		tdbot.getMessage(msg.chat_id, msg.id, get_cb, nil)
	elseif msg.content._ == "messageAudio" then
		audio_id, audio_name, audio_title = '', '', ''
		local function get_cb(arg, data)
			if data.content then
				audio_id = data.content.audio.audio.id
				audio_name = data.content.audio.file_name
				audio_title = data.content.audio.title
				tdbot.downloadFile(audio_id, 32, dl_cb, nil)
			end
		end
		tdbot.getMessage(msg.chat_id, msg.id, get_cb, nil)
	elseif msg.content._ == "messageSticker" then
		sticker_id = ''
		local function get_cb(arg, data)
			if data.content then
				sticker_id = data.content.sticker.sticker.id
				tdbot.downloadFile(sticker_id, 32, dl_cb, nil)
			end
		end
		tdbot.getMessage(msg.chat_id, msg.id, get_cb, nil)
	elseif msg.content._ == "messageDocument" then
		document_id, document_name = '', ''
		local function get_cb(arg, data)
			if data.content then
				document_id = data.content.document.document.id
				document_name = data.content.document.file_name
				tdbot.downloadFile(document_id, 32, dl_cb, nil)
			end
		end
		assert (tdbot_function ({ _ = "getMessage", chat_id = msg.chat_id, message_id = msg.id }, get_cb, nil))
	end
end
function gp_type(chat_id)
	local gp_type = "pv"
	local id = tostring(chat_id)
	if id:match("^-100") then
		gp_type = "channel"
	elseif id:match("-") then
		gp_type = "chat"
	end
	return gp_type
end
function string.new(str)
	local BadChars = {"%","$"}
	local rstr = ""
	for k in (string.gmatch(str, ".")) do
		for x, y in pairs(BadChars) do
			if (y == k) then
				if (k == "%") then
					k = "٪"
				elseif (k == "$") then
					k = "&&"
				end
				break
			end
		end
		rstr = rstr..k
	end
	return rstr
end
function print_msg(msg)
	text = color.green[1].."[From: "..(msg.from.first_name or msg.to.title).."]\n"..color.yellow[1].."["..os.date("%H:%M:%S").."]"..color.red[1].."[Type :"
	if msg.forwarded then
		text = color.magenta[1].."[Forwarded from:"..(msg.forwarded_from_user or msg.forwarded_from_chat).."]"..text
	end
	if msg.edited then
		text = color.magenta[1].."[Edited]"..text
	end
	if msg.text then
		text = text.."Text]\n"..color.default..msg.text
	else
		if msg.media.caption and msg.media.caption ~= "" then
			if msg.photo then
				text = text.."Photo]\n"..color.cyan[1].."Caption: "..color.default..msg.media.caption
			elseif msg.video then
				text = text.."Video]\n"..color.cyan[1].."Caption: "..color.default..msg.media.caption
			elseif msg.videonote then
				text = text.."Videonote]\n"..color.cyan[1].."Caption: "..color.default..msg.media.caption
			elseif msg.voice then
				text = text.."Voice]\n"..color.cyan[1].."Caption: "..color.default..msg.media.caption
			elseif msg.audio then
				text = text.."Audio]\n"..color.cyan[1].."Caption: "..color.default..msg.media.caption
			elseif msg.animation then
				text = text.."Gif]\n"..color.cyan[1].."Caption: "..color.default..msg.media.caption
			elseif msg.sticker then
				text = text.."Sticker]\n"..color.cyan[1].."Caption: "..color.default..msg.media.caption
			elseif msg.contact then
				text = text.."Contact]\n"..color.cyan[1].."Caption: "..color.default..msg.media.caption
			elseif msg.document then
				text = text.."File]\n"..color.cyan[1].."Caption: "..color.default..msg.media.caption
			elseif msg.location then
				text = text.."Location]\n"..color.cyan[1].."Caption: "..color.default..msg.media.caption
			end
		else
			if msg.photo then
				text = text.."Photo] "..color.default
			elseif msg.video then
				text = text.."Video] "..color.default
			elseif msg.videonote then
				text = text.."Videonote] "..color.default
			elseif msg.voice then
				text = text.."Voice] "..color.default
			elseif msg.audio then
				text = text.."Audio] "..color.default
			elseif msg.animation then
				text = text.."Gif] "..color.default
			elseif msg.sticker then
				text = text.."Sticker] "..color.default
			elseif msg.contact then
				text = text.."Contact] "..color.default
			elseif msg.document then
				text = text.."File] "..color.default
			elseif msg.location then
				text = text.."Location] "..color.default
			end
		end
	end
	if msg.pinned then
		text = color.green[1].."[From: "..(msg.from.first_name or msg.to.title).."]\n"..color.yellow[1].."["..os.date("%H:%M:%S").."]\n"..color.red[1].."Pinned a message in chat: "..color.default..msg.to.title
	end
	if msg.game then
		text = text.."Game] "..color.default
	end
	if msg.adduser then
		text = text.."AddUser]"..color.default
	end
	if msg.deluser then
		text = ""
	end
	if msg.joinuser then
		text = text.."JoinGroup]"..color.default
	end
	print(text)
end
function var_cb(msg, data)
	bot = {}
	msg.to = {}
	msg.from = {}
	msg.media = {}
	msg.id = msg.id
	msg.to.type = gp_type(data.chat_id)
	if data.content and data.content.caption then
		msg.media.caption = data.content.caption
	end
	
	if data.reply_to_message_id ~= 0 then
		msg.reply_id = data.reply_to_message_id
	else
		msg.reply_id = false
	end
	function get_gp(arg, data)
		if gp_type(msg.chat_id) == "channel" or gp_type(msg.chat_id) == "chat" then
			msg.to.id = msg.chat_id or 0
			msg.to.title = data.title
		else
			msg.to.id = msg.chat_id or 0
			msg.to.title = false
		end
	end
	assert (tdbot_function ({ _ = "getChat", chat_id = data.chat_id }, get_gp, nil))
	function botifo_cb(arg, data)
		bot.id = data.id
		our_id = data.id
		if data.username then
			bot.username = data.username
		else
			bot.username = false
		end
		if data.first_name then
			bot.first_name = data.first_name
		end
		if data.last_name then
			bot.last_name = data.last_name
		else
			bot.last_name = false
		end
		if data.first_name and data.last_name then
			bot.print_name = data.first_name..' '..data.last_name
		else
			bot.print_name = data.first_name
		end
		if data.phone_number then
			bot.phone = data.phone_number
		else
			bot.phone = false
		end
	end
	assert (tdbot_function({ _ = 'getMe'}, botifo_cb, {chat_id=msg.chat_id}))
	function get_user(arg, data)
		if data.id then
			msg.from.id = data.id
		else
			msg.from.id = 0
		end
		if data.username then
			msg.from.username = data.username
		else
			msg.from.username = false
		end
		if data.first_name then
			msg.from.first_name = data.first_name
		end
		if data.last_name then
			msg.from.last_name = data.last_name
		else
			msg.from.last_name = false
		end
		if data.first_name and data.last_name then
			msg.from.print_name = data.first_name..' '..data.last_name
		else
			msg.from.print_name = data.first_name
		end
		if data.phone_number then
			msg.from.phone = data.phone_number
		else
			msg.from.phone = false
		end
		print_msg(msg)
		Core(msg)
		Reload(msg)
		Msg_checks(msg)
		Mr_Mine(msg)
		Wel(msg)
		Lock_Bots(msg)
		function AlarmBot()
			assert (tdbot_function ({_="getChats",offset_order="9223372036854775807",offset_chat_id=0,limit=999999}, dl_cb, nil))
			local groups = redis:smembers(RedisIndex..'Group')
			if #groups ~= 0 then
				for k,v in pairs(groups) do
					tdbot.openChat(v)
				end
			end
			if redis:get(RedisIndex.."RunAlarmPro") then
				tdbot.setAlarm(20,AlarmBot,nil)
				ChecksBotPro(msg)
				redis:setex(RedisIndex.."CheckAlarm", 30, true)
			end
		end
		if not redis:get(RedisIndex.."CheckAlarm") then
			redis:del(RedisIndex.."RunAlarmPro")
			redis:setex(RedisIndex.."CheckAlarm", 10, true)
		end
		if not redis:get(RedisIndex.."RunAlarmPro") then
			redis:set(RedisIndex.."RunAlarmPro", true)
			redis:setex(RedisIndex.."CheckAlarm", 10, true)
			AlarmBot()
		end
	end
	assert (tdbot_function ({ _ = "getUser", user_id = (data.sender_user_id or 0)}, get_user, nil))
end
function Reload(msg)
local LuaProFa = msg.content.text
	local LuaProLw = msg.content.text
if LuaProLw then
		if LuaProLw:match('^[/#!]') then
			LuaProLw = LuaProLw:gsub('^[/#!]','')
		end
	end
if LuaProLw == 'reload' or LuaProFa == 'بروز' then
	dofile('./Core/Utils.lua')
end
end
function ReplySet(msg ,Cmd)
	if msg.reply_id then
		tdbot_function ({
		_ = "getMessage",
		chat_id = msg.to.id,
		message_id = msg.reply_id
		}, action_by_reply, {chat_id=msg.to.id,cmd=Cmd})
	end
end
function UseridSet(msg, Matches ,Cmd)
	if Matches and string.match(Matches, '^%d+$') then
		tdbot_function ({
		_ = "getUser",
		user_id = Matches,
		}, action_by_id, {chat_id=msg.to.id,user_id=Matches,cmd=Cmd,msg=msg})
	end
	if Matches and not string.match(Matches, '^%d+$') then
		tdbot_function ({
		_ = "searchPublicChat",
		username = Matches
		}, action_by_username, {chat_id=msg.to.id,username=Matches,cmd=Cmd,msg=msg})
	end
end
function info_by_reply(arg, data)
	if tonumber(data.sender_user_id) then
		function info_cb(arg, data)
			info_msg(data, arg)
		end
		assert (tdbot_function ({
		_ = "getUser",
		user_id = data.sender_user_id
		}, info_cb, {chat_id=data.chat_id,user_id=data.sender_user_id,msgid=data.id}))
	else
	end
end
function info_by_username(arg, data)
	if tonumber(data.id) then
		function info_cb(arg, data)
			if not data.id then return end
			info_msg(data, arg)
		end
		assert (tdbot_function ({
		_ = "getUser",
		user_id = data.id
		}, info_cb, {chat_id=arg.chat_id,user_id=data.id,msgid=arg.msgid}))
	end
end
function info_by_id(arg, data)
	if tonumber(data.id) then
		info_msg(data, arg)
	end
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
function Admin(chat_id, user_id, Administrator, right)
	local chat_member_status = {}
	if Administrator == 'Administrator' then
		chat_member_status = {
		can_be_edited = right and right[1] or 1,
		can_change_info = right and right[2] or 1,
		can_post_messages = right and right[3] or 1,
		can_edit_messages = right and right[4] or 1,
		can_delete_messages = right and right[5] or 1,
		can_invite_users = right and right[6] or 1,
		can_restrict_members = right and right[7] or 1,
		can_pin_messages = right and right[8] or 1,
		can_promote_members = right and right[9] or 1
		}
		chat_member_status._ = 'chatMemberStatus' .. Administrator
		assert (tdbot_function ({_ = 'changeChatMemberStatus',chat_id = chat_id,user_id = user_id,status = chat_member_status}, dl_cb, nil))
	end
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
function is_banned(chat_id, user_id)
	local var = false
	if redis:sismember(RedisIndex.."Banned:"..chat_id,user_id) then var = true end
	return var
end
function is_silent_user(userid, chatid, msg, func)
	function check_silent(arg, data)
		local var = false
		if data.members then
			for k,v in pairs(data.members) do
			if(v.user_id == userid)then var = true end
		end
	end
	if func then
		func(msg, var)
	end
end
tdbot.getChannelMembers(chatid, 0, 100000, 'Restricted', check_silent)
end
function is_gbanned(user_id)
	local var = false
	if redis:sismember(RedisIndex.."GBanned",user_id) then var = true end
	return var
end
function is_filter(msg, text)
	local var = false
	local filter = redis:hkeys(RedisIndex..'filterlist:'..msg.to.id)
	for k,v in pairs(filter) do
		if text:match(' '..string.new(v)..' ') or text:match('^'..string.new(v)..' ') or text:match(' '..string.new(v)..'$') or text:match('^'..string.new(v)..'$') then
			var = true
		end
	end
	return var
end
function kick_user(user_id, chat_id)
	if not tonumber(user_id) then return false end
	tdbot.changeChatMemberStatus(chat_id, user_id, 'Banned', {0}, dl_cb, nil)
end
function del_msg(chat_id, message_ids)
	local msgid = {[0] = message_ids}
	tdbot.deleteMessages(chat_id, msgid, true, dl_cb, nil)
end
function channel_unblock(chat_id, user_id)
	tdbot.changeChatMemberStatus(chat_id, user_id, 'Left', dl_cb, nil)
end
function silent_user(chat_id, user_id)
	tdbot.changeChatMemberStatus(chat_id, user_id, 'Restricted', {1, 0, 0, 0, 0, 0}, dl_cb, nil)
end
function unsilent_user(chat_id, user_id)
	tdbot.changeChatMemberStatus(chat_id, user_id, 'Restricted', {1, 0, 1, 1, 1, 1}, dl_cb, nil)
end
function Wel(msg)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	local function welcome_cb(arg, data)
		if redis:get(RedisIndex..'setwelcome:'..msg.chat_id) then
			welcome = redis:get(RedisIndex..'setwelcome:'..msg.chat_id)
		else
			welcome = Source_Start.."سلام {name} به گروه {gpname} خوشآمدید"..EndMsg
		end
		if data.username then
			user_name = "@"..data.username
		else
			user_name = ""
		end
		time = os.date("%H:%M:%S")
		welcome = welcome:gsub("{name}", (string.new(data.first_name) or '')..' '..(string.new(data.last_name) or ''))
		welcome = welcome:gsub("{username}", user_name)
		welcome = welcome:gsub("{time}", time)
		welcome = welcome:gsub("{gpname}", string.new(arg.gp_name))
		tdbot.sendMessage(arg.chat_id, arg.msg_id, 0, welcome, 0, "html")
		if redis:get(RedisIndex.."delbot"..msg.chat_id) then
			redis:set(RedisIndex.."delbotcheck"..msg.chat_id, true)
		end
	end
	if redis:get(RedisIndex.."CheckBot:"..msg.to.id) then
		if msg.adduser then
			if redis:get(RedisIndex..'welcome:'..msg.chat_id) == 'Enable' then
				tdbot.getUser(msg.adduser, welcome_cb, {chat_id=msg.chat_id,msg_id=msg.id,gp_name=msg.to.title})
			else
				return false
			end
		end
		if msg.joinuser then
			if redis:get(RedisIndex..'welcome:'..msg.chat_id) == 'Enable' then
				tdbot.getUser(msg.sender_user_id, welcome_cb, {chat_id=msg.chat_id,msg_id=msg.id,gp_name=msg.to.title})
			else
				return false
			end
		end
	end
end
function ChecksBotPro(msg)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	if redis:get(RedisIndex.."delbot"..msg.chat_id) and not redis:get(RedisIndex.."deltimebot2"..msg.chat_id) then
		local time = redis:get(RedisIndex.."deltimebot"..msg.chat_id) or 60
		redis:setex(RedisIndex.."deltimebot2"..msg.chat_id, time, true)
		local list = redis:smembers(RedisIndex.."MsgIdBoT"..msg.chat_id)
		for k,v in pairs(list) do
			del_msg(msg.chat_id, v)
			print(v)
			redis:del(RedisIndex.."MsgIdBoT"..msg.chat_id)
		end
	end
	if redis:get(RedisIndex.."atolct2"..msg.to.id) or redis:get(RedisIndex.."atolct2"..msg.to.id) then
		local time = os.date("%H%M")
		local time2 = redis:get(RedisIndex.."atolct1"..msg.to.id)
		time2 = time2.gsub(time2,":","")
		local time3 = redis:get(RedisIndex.."atolct2"..msg.to.id)
		time3 = time3.gsub(time3,":","")
		if tonumber(time3) < tonumber(time2) then
			if tonumber(time) <= 2359 and tonumber(time) >= tonumber(time2) then
				if not redis:get(RedisIndex.."lc_ato:"..msg.to.id) then
					redis:set(RedisIndex.."lc_ato:"..msg.to.id,true)
					tdbot.sendMessage(msg.to.id, 0, 1, Source_Start..'`قفل خودکار ربات فعال شد`\n`گروه تا ساعت` *'..redis:get(RedisIndex.."atolct2"..msg.to.id)..'* `تعطیل میباشد.`'..EndMsg, 1, 'md')
				end
			elseif tonumber(time) >= 0000 and tonumber(time) < tonumber(time3) then
				if not redis:get(RedisIndex.."lc_ato:"..msg.to.id) then
					tdbot.sendMessage(msg.to.id, 0, 1, Source_Start..'`قفل خودکار ربات فعال شد`\n`گروه تا ساعت` *'..redis:get(RedisIndex.."atolct2"..msg.to.id)..'* `تعطیل میباشد.`'..EndMsg, 1, 'md')
					redis:set(RedisIndex.."lc_ato:"..msg.to.id,true)
				end
			else
				if redis:get(RedisIndex.."lc_ato:"..msg.to.id) then
					redis:del(RedisIndex.."lc_ato:"..msg.to.id, true)
					tdbot.sendMessage(msg.to.id, 0, 1, Source_Start..'`قفل خودکار گروه به پایان رسید`'..EndMsg, 1, 'md')
				end
			end
		elseif tonumber(time3) > tonumber(time2) then
			if tonumber(time) >= tonumber(time2) and tonumber(time) < tonumber(time3) then
				if not redis:get(RedisIndex.."lc_ato:"..msg.to.id) then
					tdbot.sendMessage(msg.to.id, 0, 1, Source_Start..'`قفل خودکار ربات فعال شد`\n`گروه تا ساعت` *'..redis:get(RedisIndex.."atolct2"..msg.to.id)..'* `تعطیل میباشد.`'..EndMsg, 1, 'md')
					redis:set(RedisIndex.."lc_ato:"..msg.to.id,true)
				end
			else
				if redis:get(RedisIndex.."lc_ato:"..msg.to.id) then
					redis:del(RedisIndex.."lc_ato:"..msg.to.id, true)
					tdbot.sendMessage(msg.to.id, 0, 1, Source_Start..'`قفل خودکار گروه به پایان رسید`'..EndMsg, 1, 'md')
				end
			end
		end
	end
	if redis:get(RedisIndex.."lc_ato:"..msg.to.id) then
		local is_channel = msg.to.type == "channel"
		if not is_mod(msg) then
			if is_channel then
				del_msg(msg.to.id, tonumber(msg.id))
			end
		end
	end
	if redis:get(RedisIndex.."AdminCli:"..msg.to.id) then
		Admin(msg.chat_id, Cleaner_id, 'Administrator', {0, 1, 0, 0, 1, 1, 1, 1, 0})
		redis:del(RedisIndex.."AdminCli:"..msg.to.id)
	end
end
function Lock_Bots(msg)
local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
local Source_Start = Emoji[math.random(#Emoji)]
if msg.to.type ~= 'pv' then
			chat = msg.to.id
			user = msg.from.id
			function check_newmember(arg, data)
				if redis:get(RedisIndex.."CheckBot:"..msg.to.id) then
					lock_bots = redis:get(RedisIndex..'lock_bots:'..msg.chat_id)
				end
				if data.type._ == "userTypeBot" then
					if not is_mod(arg.msg) then
						tdbot.Restricted(msg.chat_id,msg.sender_user_id,'Restricted',   {1,msg.date+30, 0, 0, 0,0})
					end
					tdbot.Restricted(arg.chat_id,data.id,'Restricted',   {1,0, 0, 0, 0,0})
					if not is_owner(arg.msg) and lock_bots == 'Enable' then
						if tonumber(arg.count) > 0 then
							kick_user(data.id, arg.chat_id)
							if arg.count == arg.bots_count then
								kick_user(user, chat)
							end
						else
							kick_user(data.id, arg.chat_id)
						end
					elseif not is_owner(arg.msg) and lock_bots == 'Pro' then
						if tonumber(arg.count) > 0 then
							kick_user(data.id, arg.chat_id)
							tdbot.sendMention(chat,user, data.id,Source_Start..'کاربر '..user..' اضافه کردن ربات ممنوع است ربات '..data.id..' - '..data.username..' و شما از گروه ممنوع شدید'..EndMsg,8,string.len(user))
							if redis:get(RedisIndex.."delbot"..msg.chat_id) then
								redis:set(RedisIndex.."delbotcheck"..msg.chat_id, true)
							end
							kick_user(user, chat)
						else
							kick_user(data.id, arg.chat_id)
						end
					end
				end
				if data.username then
					user_name = '@'..check_markdown(data.username)
				else
					user_name = check_markdown(data.first_name)
				end
				if is_banned(data.id, arg.chat_id) then
					tdbot.sendMessage(arg.chat_id, arg.msg_id, 0, Source_Start.."*کاربر* `"..data.id.."` - "..user_name.." *از گروه (مسدود) است*"..EndMsg, 0, "md")
					kick_user(data.id, arg.chat_id)
				end
				if is_gbanned(data.id) then
					tdbot.sendMessage(arg.chat_id, arg.msg_id, 0, Source_Start.."*کاربر* `"..data.id.."` - "..user_name.." *از تمام گروه های ربات (مسدود) است*"..EndMsg, 0, "md")
					kick_user(data.id, arg.chat_id)
				end
			end
			if msg.tab then
				if msg.content.member_user_ids then
					idss = msg.content.member_user_ids
					bots_count = #idss
					for k,v in pairs(idss) do
						assert(tdbot_function ({
						_ = "getUser",
						user_id = v
						}, check_newmember, {chat_id=chat,msg_id=msg.id,user_id=user,msg=msg,count=k,bots_count=bots_count}))
					end
					
				end
			elseif msg.joinuser then
				assert(tdbot_function ({
				_ = "getUser",
				user_id = msg.joinuser
				}, check_newmember, {chat_id=chat,msg_id=msg.id,user_id=user,msg=msg}))
			end
		end
end
function Mr_Mine(msg)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	if msg.to.type ~= 'pv' then
		local gpst = redis:get(RedisIndex.."CheckBot:"..msg.to.id)
		local chex = redis:get(RedisIndex..'CheckExpire::'..msg.to.id)
		local exd = redis:get(RedisIndex..'ExpireDate:'..msg.to.id)
		if chex and not exd and msg.from.id ~= SUDO and not is_sudo(msg) then
			tdbot.sendMessage(msg.chat_id, msg.id, 1, Source_Start..'شارژ این گروه به اتمام رسید \n\nID: `'..msg.to.id..'`\n\nدر صورتی که میخواهید ربات این گروه را ترک کند از دستور زیر استفاده کنید\n\n/leave '..msg.to.id..'\nبرای جوین دادن توی این گروه میتونی از دستور زیر استفاده کنی:\n/jointo '..msg.to.id..'\n_________________\nدر صورتی که میخواهید گروه رو دوباره شارژ کنید میتوانید از کد های زیر استفاده کنید...\n\n*برای شارژ 1 ماهه:*\n/plan 1 '..msg.to.id..'\n\n*برای شارژ 3 ماهه:*\n/plan 2 '..msg.to.id..'\n\n*برای شارژ نامحدود:*\n/plan 3 '..msg.to.id, 1, 'md')
			tdbot.sendMessage(msg.chat_id, msg.id, 1, Source_Start..'*شارژ این گروه به پایان رسید. به دلیل عدم شارژ مجدد، گروه از لیست ربات حذف و ربات از گروه خارج میشود*'..EndMsg..'\n`سودو ربات :`'..check_markdown(sudo_username), 1, 'md')
			botrem(msg)
			tdbot.changeChatMemberStatus(msg.to.id, our_id, 'Left', dl_cb, nil)
			tdbot.sendMessage(Cleaner_id, 0, 1, "leave "..msg.chat_id.."", 1, 'md')
		else
			local expiretime = redis:ttl(RedisIndex..'ExpireDate:'..msg.to.id)
			local day = (expiretime / 86400)
			if tonumber(day) > 0.208 and not is_sudo(msg) and is_mod(msg) then
				warning(msg)
			end
		end
	end
	if msg.to.type == 'channel' and msg.content.text and redis:hget(RedisIndex.."CodeGiftt:", msg.content.text) then
		local b = redis:ttl(RedisIndex.."CodeGiftCharge:"..msg.content.text)
		local expire = math.floor(b / 86400 ) + 1
		local c = redis:ttl(RedisIndex..'ExpireDate:'..msg.to.id)
		local extime = math.floor(c / 86400 ) + 1
		redis:setex(RedisIndex..'ExpireDate:'..msg.to.id, tonumber(extime * 86400) + tonumber(expire * 86400), true)
		redis:del(RedisIndex.."Codegift:"..msg.to.id)
		redis:srem(RedisIndex.."CodeGift:" , msg.content.text)
		redis:hdel(RedisIndex.."CodeGiftt:", msg.content.text)
		local expire_date = ''
		local expi = redis:ttl(RedisIndex..'ExpireDate:'..msg.to.id)
		if expi == -1 then
			expire_date = 'نامحدود!'
		else
			local day = math.floor(expi / 86400) + 1
			expire_date = day..' روز'
		end
		local text = Source_Start.."`کدهدیه :`\n"..msg.content.text.."\n`استفاده شد توسط :`\n*مشخصات کاربر :*\n`꧁` @"..check_markdown(msg.from.username or '').." | "..check_markdown(msg.from.first_name).." `꧂`\n*ایدی گروه :*\n"..msg.chat_id.."\n*میزان شارژ هدیه :* `"..expire.."` *روز\nشارژ جدید گروه کاربر :* `"..expire_date.."`"
		tdbot.sendMessage(gp_sudo, msg.id, 1, text, 1, 'md')
		local text2 = Source_Start..'`انجام شد !`\n`به گروه شما` *'..expire..'* `روز شارژ هدیه اضافه شد`'..EndMsg
		tdbot.sendMessage(msg.chat_id, msg.id, 1, text2, 1, 'md')
	end
	local AddMoj = redis:sismember(RedisIndex.."AddMoj:"..msg.chat_id,msg.sender_user_id)
	if not is_mod(msg) and not AddMoj then
		local add_lock = redis:hget(RedisIndex..'addmeminv', msg.to.id)
		if add_lock == 'on' then
			local chsh = 'addpm'..msg.to.id
			local hsh = redis:get(RedisIndex..chsh)
			local chkpm = redis:get(RedisIndex..msg.from.id..'chkuserpm'..msg.to.id)
			if msg.from.username ~= '' then
				username = '@'..check_markdown(msg.from.username)
			else
				username = check_markdown(msg.from.print_name)
			end
			local setadd = redis:hget(RedisIndex..'addmemset', msg.to.id) or 10
			if msg.adduser then
				tdbot.getUser(msg.content.member_user_ids[0], function(TM, BD)
					if BD.type._ == 'userTypeBot' then
						if not hsh then
							tdbot.sendMessage(msg.to.id, 0, 1, Source_Start..'*کاربر* `'..msg.from.id..'` - '..username..' *شما یک ربات به گروه اضافه کردید لطفا یک کاربر اضافه کنید*'..EndMsg, 1, 'md')
							if redis:get(RedisIndex.."delbot"..msg.chat_id) then
								redis:set(RedisIndex.."delbotcheck"..msg.chat_id, true)
							end
						end
					end
					if #msg.content.member_user_ids > 0 then
						if not hsh then
							tdbot.sendMessage(msg.to.id, 0, 1, Source_Start..'*کاربر* `'..msg.from.id..'` - '..username..' *شما تعداد* `'..(#msg.content.member_user_ids + 1)..'` *کاربر را اضافه کردید اما فقط یک کاربر برای شما ذخیره شد لطفا کاربران رو تک به تک اضافه کنید تا محدودیت برای شما برداشته شود*'..EndMsg, 1, 'md')
							if redis:get(RedisIndex.."delbot"..msg.chat_id) then
								redis:set(RedisIndex.."delbotcheck"..msg.chat_id, true)
							end
						end
					end
					local chash = msg.content.member_user_ids[0]..'chkinvusr'..msg.from.id..'chat'..msg.to.id
					local chk = redis:get(RedisIndex..chash)
					if not chk then
						redis:set(RedisIndex..chash, true)
						local achash = 'addusercount'..msg.from.id
						local count = redis:hget(RedisIndex..achash, msg.to.id) or 0
						redis:hset(RedisIndex..achash, msg.to.id, (tonumber(count) + 1))
						local permit = redis:hget(RedisIndex..achash, msg.to.id)
						if tonumber(permit) < tonumber(setadd) then
							local less = tonumber(setadd) - tonumber(permit)
							if not hsh then
								tdbot.sendMessage(msg.to.id, 0, 1, Source_Start..'*کاربر* `'..msg.from.id..'` - '..username..' *شما تعداد* `'..permit..'` *کاربر را به این گروه اضافه کردید باید* `'..less..'` *کاربر دیگر برای رفع محدودیت چت اضافه کنید*'..EndMsg, 1, 'md')
								if redis:get(RedisIndex.."delbot"..msg.chat_id) then
									redis:set(RedisIndex.."delbotcheck"..msg.chat_id, true)
								end
							end
						elseif tonumber(permit) == tonumber(setadd) then
							if not hsh then
								tdbot.sendMessage(msg.to.id, 0, 1, Source_Start..'*کاربر* `'..msg.from.id..'` - '..username..' *شما اکنون میتوانید پیام ارسال کنید*'..EndMsg, 1, 'md')
								if redis:get(RedisIndex.."delbot"..msg.chat_id) then
									redis:set(RedisIndex.."delbotcheck"..msg.chat_id, true)
								end
							end
						end
					else
						if not hsh then
							tdbot.sendMessage(msg.to.id, 0, 1, Source_Start..'*کاربر* `'..msg.from.id..'` - '..username..' *شما قبلا این کاربر را به گروه اضافه کرده اید*'..EndMsg, 1, 'md')
							if redis:get(RedisIndex.."delbot"..msg.chat_id) then
								redis:set(RedisIndex.."delbotcheck"..msg.chat_id, true)
							end
						end
					end
					end, nil)
				end
				local permit = redis:hget(RedisIndex..'addusercount'..msg.from.id, msg.to.id) or 0
				if tonumber(permit) < tonumber(setadd) then
					tdbot.deleteMessages(msg.to.id, {[0] = msg.id}, true, dl_cb, nil)
					if not chkpm then
						redis:setex(RedisIndex..msg.from.id..'chkuserpm'..msg.to.id, 100, true)
						keyboard = {}
						keyboard.inline_keyboard = {
						{
						{text = Source_Start..'معاف از اد کردن' ,callback_data = 'AddMoj:'..msg.to.id..':'..msg.from.id..':'..msg.from.first_name}
						},
						}
						SendInlineApi(msg.to.id, Source_Start..'*کاربر* `'..msg.from.id..'` - '..username..' *شما باید* `'..setadd..'` *کاربر دیگر رابه به گروه دعوت کنید تا بتوانید پیام ارسال کنید*'..EndMsg, keyboard, 'md')
						if redis:get(RedisIndex.."delbot"..msg.chat_id) then
							redis:set(RedisIndex.."delbotcheck"..msg.chat_id, true)
						end
					end
					return
				end
			end
		end
	if tonumber(msg.sender_user_id) ~= 0 then
		if msg.from.username then
			user_name = '@'..msg.from.username
		else
			user_name = msg.from.print_name
		end
		redis:set(RedisIndex..'user_name:'..msg.from.id, user_name)
	end
end
function sudolist(msg)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	local sudo_users = Config.sudo_users
	text = Source_Start.."*لیست سودو های ربات :*\n"
	for i=1,#sudo_users do
		text = text..i.." - `"..sudo_users[i].."`\n"
	end
	tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
end
function adminlist(msg)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	local sudo_users = Config.sudo_users
	text = Source_Start.."*لیست ادمین های ربات :*\n"
	local compare = text
	local i = 1
	for v,user in pairs(Config.admins) do
		text = text..i..'- '..( user[2] or '' )..' ➣ `('..user[1]..')`\n'
		i = i +1
	end
	if compare == text then
		text = Source_Start..'`ادمینی برای ربات انتخاب نشده`'..EndMsg
	end
	tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
end
function chat_list(msg)
	local list = redis:smembers(RedisIndex..'Group')
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	local message = Source_Start..'لیست گروه های ربات :\n\n'
	if #list == 0 then
		message = Source_Start..'لیست گروهها خالی میباشد'..EndMsg
	end
	for k,v in pairs(list) do
		local check_time = redis:ttl(RedisIndex..'ExpireDate:'..v)
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
			remained_expire = 'گروه به صورت نامحدود شارژ میباشد!'
		elseif tonumber(check_time) > 1 and check_time < 60 then
			remained_expire = 'گروه به مدت '..sec..' ثانیه شارژ میباشد'
		elseif tonumber(check_time) > 60 and check_time < 3600 then
			remained_expire = 'گروه به مدت '..min..' دقیقه و '..sec..' ثانیه شارژ میباشد'
		elseif tonumber(check_time) > 3600 and tonumber(check_time) < 86400 then
			remained_expire = 'گروه به مدت '..hours..' ساعت و '..min..' دقیقه و '..sec..' ثانیه شارژ میباشد'
		elseif tonumber(check_time) > 86400 and tonumber(check_time) < 2592000 then
			remained_expire = 'گروه به مدت '..day..' روز و '..hours..' ساعت و '..min..' دقیقه و '..sec..' ثانیه شارژ میباشد'
		elseif tonumber(check_time) > 2592000 and tonumber(check_time) < 31536000 then
			remained_expire = 'گروه به مدت '..month..' ماه '..day..' روز و '..hours..' ساعت و '..min..' دقیقه و '..sec..' ثانیه شارژ میباشد'
		elseif tonumber(check_time) > 31536000 then
			remained_expire = 'گروه به مدت '..year..' سال '..month..' ماه '..day..' روز و '..hours..' ساعت و '..min..' دقیقه و '..sec..' ثانیه شارژ میباشد'
		end
		local GroupsName = redis:get(RedisIndex..'Gpnameset'..v)
		message = message..k..'-'..Source_Start..'نام گروه : '..GroupsName..'\n'..Source_Start..'آیدی : ' ..v.. '\n'..Source_Start..'اعتبار : '..remained_expire..'\n_______________\n'
	end
	local file = io.open("./Download/Gplist.txt", "w")
	file:write(message)
	file:close()
	MaT = Source_Start.."لیست گروه های ربات"..EndMsg
	tdbot.sendDocument(msg.to.id, "./Download/Gplist.txt", MaT, nil, msg.id, 0, 1, nil, dl_cb, nil)
end
function filter_list(msg)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	local names = redis:hkeys(RedisIndex..'filterlist:'..msg.to.id)
	filterlist = Source_Start..'`لیست کلمات فیلتر شده :`\n'
	local b = 1
	for i = 1, #names do
		filterlist = filterlist .. b .. ". " .. names[i] .. "\n"
		b = b + 1
	end
	if #names == 0 then
		filterlist = Source_Start.."`لیست کلمات فیلتر شده خالی است`"..EndMsg
	end
	tdbot.sendMessage(msg.chat_id, msg.id, 1, filterlist, 1, 'md')
end
function forwardlist(msg)
	local list = redis:smembers(RedisIndex..'ForwardMsg_List')
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	message = Source_Start..'*لیست دستورات فوروارد :*\n'
	for k,v in pairs(list) do
		message = message..k.."- "..v.."\n"
	end
	if #list == 0 then
		message = Source_Start.."`در حال حاضر هیچ دستور فورواردی تنظیم نشده است`"..EndMsg
	end
	tdbot.sendMessage(msg.chat_id , msg.id, 1, message, 0, 'md')
end
function modlist(msg)
	local list = redis:smembers(RedisIndex..'Mods:'..msg.to.id)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	if not redis:get(RedisIndex.."CheckBot:"..msg.to.id) then
		message = Source_Start..'`گروه در` #لیست `گروه ربات  نیست`'..EndMsg
	end
	message = Source_Start..'*لیست مدیران گروه :*\n'
	for k,v in pairs(list) do
		local user_name = redis:get(RedisIndex..'user_name:'..v) or "---"
		message = message..k.."- "..v.." [" ..check_markdown(user_name).. "]\n"
	end
	if #list == 0 then
		message = Source_Start.."`در حال حاضر هیچ مدیری برای گروه انتخاب نشده است`"..EndMsg
	end
	tdbot.sendMessage(msg.chat_id , msg.id, 1, message, 0, 'md')
end
function banned_list(msg)
	local list = redis:smembers(RedisIndex.."Banned:"..msg.to.id)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	if not redis:get(RedisIndex.."CheckBot:"..msg.to.id) then
		message = Source_Start..'`گروه در` #لیست `گروه ربات  نیست`'..EndMsg
	end
	message = Source_Start..'*لیست کاربران محروم شده از گروه :*\n'
	for k,v in pairs(list) do
		local user_name = redis:get(RedisIndex..'user_name:'..v) or "---"
		message = message..k.."- "..check_markdown(user_name).." [" ..v.. "]\n"
	end
	if #list == 0 then
		message = Source_Start.."*هیچ کاربری از این گروه محروم نشده*"..EndMsg
	end
	tdbot.sendMessage(msg.chat_id , msg.id, 1, message, 0, 'md')
end
function silent_users_list(msg)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	local function GetRestricted(arg, data)
		msg=arg.msg
		local i = 1
		message = Source_Start..'*لیست کاربران میوت شده :*\n'
		local un = ''
		if data.total_count > 0 then
			i = 1
			k = 0
			local function getuser(arg, mdata)
				local ST = data.members[k].status
				if ST.can_add_web_page_previews == false and ST.can_send_media_messages == false and ST.can_send_messages == false and ST.can_send_other_messages == false and ST.is_member == true then
					if mdata.username then
						un = '@'..mdata.username
					else
						un = mdata.first_name
					end
					message = message ..i.. '-'..'' ..data.members[k].user_id.. ' - '..check_markdown(un)..'\n'
					i = i + 1
				end
				k = k + 1
				if k < data.total_count then
					tdbot.getUser(data.members[k].user_id, getuser, nil)
				else
					if i == 1 then
						return tdbot.sendMessage(msg.to.id, msg.id, 1, Source_Start.."`لیست کاربران میوت شده خالی است`"..EndMsg, 0, "md")
					else
						return tdbot.sendMessage(msg.to.id, msg.id, 1, message, 0, "md")
					end
				end
			end
			tdbot.getUser(data.members[k].user_id, getuser, nil)
		else
			return tdbot.sendMessage(msg.to.id, msg.id, 1, Source_Start.."`لیست کاربران میوت شده خالی است`"..EndMsg, 0, "md")
		end
	end
	tdbot.getChannelMembers(msg.chat_id, 0, 100000, 'Restricted', GetRestricted, {msg=msg})
end
function whitelist(msg)
	local list = redis:smembers(RedisIndex.."Whitelist:"..msg.to.id)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	if not redis:get(RedisIndex.."CheckBot:"..msg.to.id) then
		message = Source_Start..'`گروه در` #لیست `گروه ربات  نیست`'..EndMsg
	end
	message = Source_Start..'`کاربران لیست ویژه :`\n'
	for k,v in pairs(list) do
		local user_name = redis:get(RedisIndex..'user_name:'..v) or "---"
		message = message..k.."- "..check_markdown(user_name).." [" ..v.. "]\n"
	end
	if #list == 0 then
		message = Source_Start.."*هیچ کاربری در لیست ویژه وجود ندارد*"..EndMsg
	end
	tdbot.sendMessage(msg.chat_id , msg.id, 1, message, 0, 'md')
end
function ownerlist(msg)
	local list = redis:smembers(RedisIndex..'Owners:'..msg.to.id)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	if not redis:get(RedisIndex.."CheckBot:"..msg.to.id) then
		message = Source_Start..'`گروه در` #لیست `گروه ربات  نیست`'..EndMsg
	end
	message = Source_Start..'*لیست مالکین گروه :*\n'
	for k,v in pairs(list) do
		local user_name = redis:get(RedisIndex..'user_name:'..v) or "---"
		message = message..k.."- "..v.." [" ..check_markdown(user_name).. "]\n"
	end
	if #list == 0 then
		message = Source_Start.."`در حال حاضر هیچ مالکی برای گروه انتخاب نشده است`"..EndMsg
	end
	tdbot.sendMessage(msg.chat_id , msg.id, 1, message, 0, 'md')
end
function botrem(msg)
	if redis:get(RedisIndex..'CheckExpire::'..msg.to.id) then
		redis:del(RedisIndex..'CheckExpire::'..msg.to.id)
	end
	if redis:get(RedisIndex..'ExpireDate:'..msg.to.id) then
		redis:del(RedisIndex..'ExpireDate:'..msg.to.id)
	end
	redis:srem(RedisIndex.."Group" ,msg.to.id)
	redis:del(RedisIndex.."Gpnameset"..msg.to.id)
	redis:del(RedisIndex.."CheckBot:"..msg.to.id)
	redis:del(RedisIndex.."Whitelist:"..msg.to.id)
	redis:del(RedisIndex.."Banned:"..msg.to.id)
	redis:del(RedisIndex.."Owners:"..msg.to.id)
	redis:del(RedisIndex.."Mods:"..msg.to.id)
	redis:del(RedisIndex..'filterlist:'..msg.to.id)
	redis:del(RedisIndex..msg.to.id..'rules')
	redis:del(RedisIndex..'setwelcome:'..msg.chat_id)
	redis:del(RedisIndex..'lock_link:'..msg.chat_id)
	redis:del(RedisIndex..'lock_join:'..msg.chat_id)
	redis:del(RedisIndex..'lock_tag:'..msg.chat_id)
	redis:del(RedisIndex..'lock_username:'..msg.chat_id)
	redis:del(RedisIndex..'lock_pin:'..msg.chat_id)
	redis:del(RedisIndex..'lock_arabic:'..msg.chat_id)
	redis:del(RedisIndex..'lock_mention:'..msg.chat_id)
	redis:del(RedisIndex..'lock_edit:'..msg.chat_id)
	redis:del(RedisIndex..'lock_spam:'..msg.chat_id)
	redis:del(RedisIndex..'lock_flood:'..msg.chat_id)
	redis:del(RedisIndex..'lock_markdown:'..msg.chat_id)
	redis:del(RedisIndex..'lock_webpage:'..msg.chat_id)
	redis:del(RedisIndex..'welcome:'..msg.chat_id)
	redis:del(RedisIndex..'views:'..msg.chat_id)
	redis:del(RedisIndex..'lock_bots:'..msg.chat_id)
	redis:del(RedisIndex..'mute_all:'..msg.chat_id)
	redis:del(RedisIndex..'mute_gif:'..msg.chat_id)
	redis:del(RedisIndex..'mute_photo:'..msg.chat_id)
	redis:del(RedisIndex..'mute_sticker:'..msg.chat_id)
	redis:del(RedisIndex..'mute_contact:'..msg.chat_id)
	redis:del(RedisIndex..'mute_inline:'..msg.chat_id)
	redis:del(RedisIndex..'mute_game:'..msg.chat_id)
	redis:del(RedisIndex..'mute_text:'..msg.chat_id)
	redis:del(RedisIndex..'mute_keyboard:'..msg.chat_id)
	redis:del(RedisIndex..'mute_forward:'..msg.chat_id)
	redis:del(RedisIndex..'mute_location:'..msg.chat_id)
	redis:del(RedisIndex..'mute_document:'..msg.chat_id)
	redis:del(RedisIndex..'mute_voice:'..msg.chat_id)
	redis:del(RedisIndex..'mute_audio:'..msg.chat_id)
	redis:del(RedisIndex..'mute_video:'..msg.chat_id)
	redis:del(RedisIndex..'mute_video_note:'..msg.chat_id)
	redis:del(RedisIndex..'mute_tgservice:'..msg.chat_id)
	redis:del(RedisIndex..msg.to.id..'set_char')
	redis:del(RedisIndex..msg.to.id..'num_msg_max')
	redis:del(RedisIndex..msg.to.id..'time_check')
end
function warning(msg)
	local expiretime = redis:ttl(RedisIndex..'ExpireDate:'..msg.to.id)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	if expiretime == -1 then
		return
	else
		if not redis:get(RedisIndex.."CheckTimeExpire"..msg.to.id) then
			local d = math.floor(expiretime / 86400) + 1
			if tonumber(d) == 1 and not is_sudo(msg) and is_mod(msg) then
				local function Creator(arg, data)
					for k,v in pairs(data.members) do
						if data.members[k].status._ == "chatMemberStatusCreator" then
							owner_id = v.user_id
							local function id_owner(arg, data)
								local M = '[مدیر گرامی](tg://user?id='..data.id..')'
								local Text = ""..M.." `از شارژ گروه شما کمتر از` *24* `ساعت باقی مانده است` 🎈\n\n`شما میتوانید از پنل زیر گروه خود را تمدید کنید 💰`\n\n`توجه داشته باشید اگر گروه خود را تمدید نکنید ربات بعد از 24 🕛 ساعت از گروه شما خارج میشود 💸`\n\n`اگر‌ مایل به تمدید گروه خود میباشید چند نکته را باید رعایت کنید 💢`\n\n*1* - _لطفا به درستی روی دکمه مورد نظر‌ کلیک کنید _\n*2* - _بعد از پرداخت از رسید خود عکس‌ گرفته و به پشتیبانی ربات ارسال کنید_\n\n ⚙*️ پشتیبانی ربات :*\n"..check_markdown(sudo_username).."\n*🏷 کانال ما :*\n"..check_markdown(channel_username)..""
								keyboard = {}
								keyboard.inline_keyboard = {
								{
								{text = Source_Start..'یک ماه '..Config.N1..' تومان' ,url = Config.L1}
								},
								{
								{text = Source_Start..'سه ماه '..Config.N2..' تومان' ,url = Config.L2}
								},
								{
								{text = Source_Start..'یک ساله '..Config.N3..' تومان' ,url = Config.L3}
								},
								}
								SendInlineApi(msg.chat_id, Text, keyboard, 'md')
								redis:set(RedisIndex.."checkpin"..msg.chat_id, true)
								redis:setex(RedisIndex.."CheckTimeExpire"..msg.to.id, 43200, true)
							end
							tdbot.getUser(owner_id, id_owner, {user_id=owner_id})
						end
					end
				end
				tdbot.getChannelMembers(msg.to.id, 0, 200, 'Administrators', Creator, {chat_id=msg.to.id})
			end
		end
	end
end
function modrem(msg)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	if redis:get(RedisIndex.."CheckBot:"..msg.to.id) then
		botrem(msg)
		tdbot.sendMessage(msg.chat_id , msg.id, 1, Source_Start..'*گروه* '..check_markdown(msg.to.title)..' *توسط* `'..msg.from.id..'` - @'..check_markdown(msg.from.username)..' *از لیست گروه های ربات حذف شد*'..EndMsg, 0, 'md')
	end
end
function filter_word(msg, word)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	if redis:hget(RedisIndex..'filterlist:'..msg.to.id, word) then
		tdbot.sendMessage(msg.chat_id , msg.id, 1, Source_Start.."`کلمه` *"..word.."* `از قبل فیلتر بود`"..EndMsg, 0, 'md')
	end
	redis:hset(RedisIndex..'filterlist:'..msg.to.id, word, "newword")
	tdbot.sendMessage(msg.chat_id , msg.id, 1, Source_Start.."`کلمه` *[ "..word.." ]* `توسط` *"..msg.from.id.."* - @"..check_markdown(msg.from.username).." `به لیست کلمات فیلتر شده اضافه شد`"..EndMsg, 0, 'md')
end
function unfilter_word(msg, word)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	if not redis:hget(RedisIndex..'filterlist:'..msg.to.id, word) then
		tdbot.sendMessage(msg.chat_id , msg.id, 1, Source_Start.."`کلمه` *"..word.."* `از قبل فیلتر نبود`"..EndMsg, 0, 'md')
	else
		redis:hdel(RedisIndex..'filterlist:'..msg.to.id, word)
		tdbot.sendMessage(msg.chat_id , msg.id, 1, Source_Start.."`کلمه` *[ "..word.." ]* `توسط` *"..msg.from.id.."* - @"..check_markdown(msg.from.username).." `از لیست کلمات فیلتر شده حذف شد`"..EndMsg, 0, 'md')
	end
end
function group_settings(msg)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	if redis:get(RedisIndex.."CheckBot:"..msg.to.id) then
		if redis:get(RedisIndex..msg.chat_id..'num_msg_max') then
			NUM_MSG_MAX = redis:get(RedisIndex..msg.chat_id..'num_msg_max')
		else
			NUM_MSG_MAX = 5
		end
		if redis:get(RedisIndex..msg.chat_id..'set_char') then
			SETCHAR = redis:get(RedisIndex..msg.chat_id..'set_char')
		else
			SETCHAR = 400
		end
		if redis:get(RedisIndex..msg.chat_id..'time_check') then
			TIME_CHECK = redis:get(RedisIndex..msg.chat_id..'time_check')
		else
			TIME_CHECK = 2
		end
	end
	lock_link = redis:get(RedisIndex..'lock_link:'..msg.chat_id)
	lock_join = redis:get(RedisIndex..'lock_join:'..msg.chat_id)
	lock_tag = redis:get(RedisIndex..'lock_tag:'..msg.chat_id)
	lock_username = redis:get(RedisIndex..'lock_username:'..msg.chat_id)
	lock_pin = redis:get(RedisIndex..'lock_pin:'..msg.chat_id)
	lock_arabic = redis:get(RedisIndex..'lock_arabic:'..msg.chat_id)
	lock_english = redis:get(RedisIndex..'lock_english:'..msg.chat_id)
	lock_mention = redis:get(RedisIndex..'lock_mention:'..msg.chat_id)
	lock_edit = redis:get(RedisIndex..'lock_edit:'..msg.chat_id)
	lock_spam = redis:get(RedisIndex..'lock_spam:'..msg.chat_id)
	lock_flood = redis:get(RedisIndex..'lock_flood:'..msg.chat_id)
	lock_markdown = redis:get(RedisIndex..'lock_markdown:'..msg.chat_id)
	lock_webpage = redis:get(RedisIndex..'lock_webpage:'..msg.chat_id)
	lock_welcome = redis:get(RedisIndex..'welcome:'..msg.chat_id)
	lock_views = redis:get(RedisIndex..'lock_views:'..msg.chat_id)
	lock_bots = redis:get(RedisIndex..'lock_bots:'..msg.chat_id)
	lock_tabchi = redis:get(RedisIndex..'lock_tabchi:'..msg.chat_id)
	mute_all = redis:get(RedisIndex..'mute_all:'..msg.chat_id)
	mute_gif = redis:get(RedisIndex..'mute_gif:'..msg.chat_id)
	mute_photo = redis:get(RedisIndex..'mute_photo:'..msg.chat_id)
	mute_sticker = redis:get(RedisIndex..'mute_sticker:'..msg.chat_id)
	mute_contact = redis:get(RedisIndex..'mute_contact:'..msg.chat_id)
	mute_inline = redis:get(RedisIndex..'mute_inline:'..msg.chat_id)
	mute_game = redis:get(RedisIndex..'mute_game:'..msg.chat_id)
	mute_text = redis:get(RedisIndex..'mute_text:'..msg.chat_id)
	mute_keyboard = redis:get(RedisIndex..'mute_keyboard:'..msg.chat_id)
	mute_forward = redis:get(RedisIndex..'mute_forward:'..msg.chat_id)
	mute_forwarduser = redis:get(RedisIndex..'mute_forwarduser:'..msg.chat_id)
	mute_location = redis:get(RedisIndex..'mute_location:'..msg.chat_id)
	mute_document = redis:get(RedisIndex..'mute_document:'..msg.chat_id)
	mute_voice = redis:get(RedisIndex..'mute_voice:'..msg.chat_id)
	mute_audio = redis:get(RedisIndex..'mute_audio:'..msg.chat_id)
	mute_video = redis:get(RedisIndex..'mute_video:'..msg.chat_id)
	mute_video_note = redis:get(RedisIndex..'mute_video_note:'..msg.chat_id)
	mute_tgservice = redis:get(RedisIndex..'mute_tgservice:'..msg.chat_id)
	L_floodmod = redis:get(RedisIndex..msg.to.id..'floodmod')
	local gif = (mute_gif == "Warn") and "اخطار" or ((mute_gif == "Kick") and "اخراج" or ((mute_gif == "Mute") and "سکوت" or ((mute_gif == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local photo = (mute_photo == "Warn") and "اخطار" or ((mute_photo == "Kick") and "اخراج" or ((mute_photo == "Mute") and "سکوت" or ((mute_photo == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local sticker = (mute_sticker == "Warn") and "اخطار" or ((mute_sticker == "Kick") and "اخراج" or ((mute_sticker == "Mute") and "سکوت" or ((mute_sticker == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local contact = (mute_contact == "Warn") and "اخطار" or ((mute_contact == "Kick") and "اخراج" or ((mute_contact == "Mute") and "سکوت" or ((mute_contact == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local inline = (mute_inline == "Warn") and "اخطار" or ((mute_inline == "Kick") and "اخراج" or ((mute_inline == "Mute") and "سکوت" or ((mute_inline == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local game = (mute_game == "Warn") and "اخطار" or ((mute_game == "Kick") and "اخراج" or ((mute_game == "Mute") and "سکوت" or ((mute_game == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local textt = (mute_text == "Warn") and "اخطار" or ((mute_text == "Kick") and "اخراج" or ((mute_text == "Mute") and "سکوت" or ((mute_text == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local keyboard = (mute_keyboard == "Warn") and "اخطار" or ((mute_keyboard == "Kick") and "اخراج" or ((mute_keyboard == "Mute") and "سکوت" or ((mute_keyboard == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local forward = (mute_forward == "Warn") and "اخطار" or ((mute_forward == "Kick") and "اخراج" or ((mute_forward == "Mute") and "سکوت" or ((mute_forward == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local forwarduser = (mute_forwarduser == "Warn") and "اخطار" or ((mute_forwarduser == "Kick") and "اخراج" or ((mute_forwarduser == "Mute") and "سکوت" or ((mute_forwarduser == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local views = (lock_views == "Warn") and "اخطار" or ((lock_views == "Kick") and "اخراج" or ((lock_views == "Mute") and "سکوت" or ((lock_views == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local location = (mute_location == "Warn") and "اخطار" or ((mute_location == "Kick") and "اخراج" or ((mute_location == "Mute") and "سکوت" or ((mute_location == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local document = (mute_document == "Warn") and "اخطار" or ((mute_document == "Kick") and "اخراج" or ((mute_document == "Mute") and "سکوت" or ((mute_document == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local voice = (mute_voice == "Warn") and "اخطار" or ((mute_voice == "Kick") and "اخراج" or ((mute_voice == "Mute") and "سکوت" or ((mute_voice == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local audio = (mute_audio == "Warn") and "اخطار" or ((mute_audio == "Kick") and "اخراج" or ((mute_audio == "Mute") and "سکوت" or ((mute_audio == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local video = (mute_video == "Warn") and "اخطار" or ((mute_video == "Kick") and "اخراج" or ((mute_video == "Mute") and "سکوت" or ((mute_video == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local video_note = (mute_video_note == "Warn") and "اخطار" or ((mute_video_note == "Kick") and "اخراج" or ((mute_video_note == "Mute") and "سکوت" or ((mute_video_note == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local link = (lock_link == "Warn") and "اخطار" or ((lock_link == "Kick") and "اخراج" or ((lock_link == "Mute") and "سکوت" or ((lock_link == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local tag = (lock_tag == "Warn") and "اخطار" or ((lock_tag == "Kick") and "اخراج" or ((lock_tag == "Mute") and "سکوت" or ((lock_tag == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local username = (lock_username == "Warn") and "اخطار" or ((lock_username == "Kick") and "اخراج" or ((lock_username == "Mute") and "سکوت" or ((lock_username == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local arabic = (lock_arabic == "Warn") and "اخطار" or ((lock_arabic == "Kick") and "اخراج" or ((lock_arabic == "Mute") and "سکوت" or ((lock_arabic == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local english = (lock_english == "Warn") and "اخطار" or ((lock_english == "Kick") and "اخراج" or ((lock_english == "Mute") and "سکوت" or ((lock_english == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local mention = (lock_mention == "Warn") and "اخطار" or ((lock_mention == "Kick") and "اخراج" or ((lock_mention == "Mute") and "سکوت" or ((lock_mention == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local edit = (lock_edit == "Warn") and "اخطار" or ((lock_edit == "Kick") and "اخراج" or ((lock_edit == "Mute") and "سکوت" or ((lock_edit == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local markdown = (lock_markdown == "Warn") and "اخطار" or ((lock_markdown == "Kick") and "اخراج" or ((lock_markdown == "Mute") and "سکوت" or ((lock_markdown == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local webpage = (lock_webpage == "Warn") and "اخطار" or ((lock_webpage == "Kick") and "اخراج" or ((lock_webpage == "Mute") and "سکوت" or ((lock_webpage == "Enable") and "MaTaDoRLock" or "MaTaDoRUnlock")))
	local bots =  (lock_bots == "Enable" and "MaTaDoRLock" or "MaTaDoRUnlock")
	local all =  (mute_all == "Enable" and "MaTaDoRLock" or "MaTaDoRUnlock")
	local tgservice =  (mute_tgservice == "Enable" and "MaTaDoRLock" or "MaTaDoRUnlock")
	local join =  (lock_join == "Enable" and "MaTaDoRLock" or "MaTaDoRUnlock")
	local pin =  (lock_pin == "Enable" and "MaTaDoRLock" or "MaTaDoRUnlock")
	local spam =  (lock_spam == "Enable" and "MaTaDoRLock" or "MaTaDoRUnlock")
	local flood =  (lock_flood == "Enable" and "MaTaDoRLock" or "MaTaDoRUnlock")
	local welcome = (lock_welcome == "Enable" and "MaTaDoRLock" or "MaTaDoRUnlock")
	local tabchi = (lock_tabchi == "Enable" and "MaTaDoRLock" or "MaTaDoRUnlock")
	local getadd = redis:hget(RedisIndex..'addmemset', msg.to.id) or "0"
	local add = redis:hget(RedisIndex..'addmeminv' ,msg.chat_id)
	local sadd = (add == 'on') and "فعال" or "غیرفعال"
	local delbottime = redis:get(RedisIndex.."deltimebot"..msg.chat_id) or 60
	local delbot = redis:get(RedisIndex.."delbot"..msg.to.id) and "فعال" or "غیرفعال"
	local mutetime = redis:get(RedisIndex.."TimeMuteset"..msg.to.id) or "ثبت نشده"
	L_lockgptime = redis:get(RedisIndex..'Lock_Gp:'..msg.to.id)
	local lockgptime = (L_lockgptime and "فعال" or "غیرفعال")
	local expire_date = ''
	local expi = redis:ttl(RedisIndex..'ExpireDate:'..msg.to.id)
	local floodmod = (L_floodmod == "Mute" and "سکوت کاربر" or "اخراج کاربر")
	if expi == -1 then
		expire_date = 'نامحدود!'
	else
		local day = math.floor(expi / 86400) + 1
		expire_date = day..' روز'
	end
	local t1 = redis:get(RedisIndex.."atolct1"..msg.chat_id)
	local t2 = redis:get(RedisIndex.."atolct2"..msg.chat_id)
	if t1 and t2 then
		stats1 = ''..t1..' && '..t2..''
	else
		stats1 = '`تنظیم نشده`'
	end
	text = "⇋ تنظیمات گروه ~> •("..check_markdown(msg.to.title)..")• :\n\n⌯ تنظیمات قفل •(پیشرفته)• ❦\n\n↜ لینک : ❲^"..link.."^❳\n↜ هشتگ : ❲^"..tag.."^❳\n↜‌ نام کاربری : ❲^"..username.."^❳\n↜ بازدید : ❲^"..views.."^❳\n↜ منشن : ❲^"..mention.."^❳\n↜ انگلیسی : ❲^"..english.."^❳\n↜ فارسی : ❲^"..arabic.."^❳\n↜ وب سایت : ❲^"..webpage.."^❳\n↜ فونت : ❲^"..markdown.."^❳\n↜ ربات : ❲^"..bots.."^❳\n\n⌯ تنظیمات رسانه •(پیشرفته)• ❦\n\n↜ گیف : ❲^"..gif.."^❳\n↜ عکس : ❲^"..photo.."^❳\n↜ فیلم : ❲^"..video.."^❳\n↜ سلفی : ❲^"..video_note.."^❳\n↜ آهنگ : ❲^"..audio.."^❳\n↜ ویس : ❲^"..voice.."^❳\n↜ متن : ❲^"..textt.."^❳\n↜ بازی : ❲^"..game.."^❳\n↜ استیکر : ❲^"..sticker.."^❳\n↜ مخاطب : ❲^"..contact.."^❳\n↜ مکان : ❲^"..location.."^❳\n↜ فایل : ❲^"..document.."^❳\n↜ دکمه شیشه ای : ❲^"..inline.."^❳\n↜ کیبورد : ❲^"..keyboard.."^❳\n↜ فوروارد کانال : ❲^"..forward.."^❳\n↜ فوروارد شخص : ❲^"..forwarduser.."^❳\n\n⌯ تنظیمات انتی اسپم •(پیشرفته)• ❦\n\n↜ آنتی فلود : ❲^"..flood.."^❳\n↜ آنتی اسپم : ❲^"..spam.."^❳\n↜ حالت آنتی فلود : ❲^"..floodmod.."^❳\n↜ حداکثر آنتی اسپم : "..SETCHAR.."\n↜ حداکثر آنتی فلود :"..NUM_MSG_MAX.."\n↜ زمان برسی آنتی فلود : "..TIME_CHECK.."\n\n⌯ •(تنظیمات بیشتر گروه)• ❦\n\n↜ قفل گروه  :‌ ❲^"..all.."^❳\n↜ قفل گروه زمانی :‌‌ "..lockgptime.."\n↜ قفل خودکار :  "..stats1.."\n↜زمان سکوت : "..mutetime.."\n↜ سرویس تلگرام :‌‌ ❲^"..tgservice.."^❳\n↜ ورود : ❲^"..join.."^❳\n↜ سنجاق پیام : ❲^"..pin.."^❳\n↜ خوشآمدگویی : ❲^"..welcome.."^❳\n↜ پاکسازی خودکار : ❲^"..delbot.."^❳\n↜ زمان پاکسازی خودکار‌ : "..delbottime.."\n↜ شناسایی تبچی : ❲^"..tabchi.."^❳\n↜ اد اجباری : ❲^"..sadd.."^❳\n↜ حداکثر اد اجباری : "..getadd.."\n↜ تاریخ انقضا : "..expire_date..""
	text = string.gsub(text, 'MaTaDoRUnlock', "غیرفعال")
	text = string.gsub(text, 'MaTaDoRLock', "فعال")
	text = string.gsub(text, 'اخطار', "اخطار")
	text = string.gsub(text, 'اخراج', "اخراج")
	text = string.gsub(text, 'سکوت', "سکوت")
	tdbot.sendMessage(msg.chat_id , msg.id, 1, text, 0, 'md')
end
function set_config(msg)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	local function config_cb(arg, data)
		for k,v in pairs(data.members) do
			local function config_mods(arg, data)
				redis:sadd(RedisIndex..'Mods:'..msg.chat_id,data.id)
			end
			assert (tdbot_function ({
			_ = "getUser",
			user_id = v.user_id
			}, config_mods, {user_id=v.user_id}))
			if data.members[k].status._ == "chatMemberStatusCreator" then
				owner_id = v.user_id
				local function config_owner(arg, data)
					redis:sadd(RedisIndex..'Owners:'..msg.chat_id, data.id)
					if redis:get(RedisIndex.."ConfigAdd"..msg.chat_id) then
						tdbot.sendMention(msg.chat_id,data.id, msg.id,Source_Start..'با موفقیت انجام شد تمام ادمین های گروه به مدیر ربات منتصب شدند و سازنده گروه به مقام مالک گروه منتصب شد.'..EndMsg,67, tonumber(Slen("سازنده گروه")))
					end
				end
				assert (tdbot_function ({
				_ = "getUser",
				user_id = owner_id
				}, config_owner, {user_id=owner_id}))
			end
		end
	end
	tdbot.getChannelMembers(msg.to.id, 0, 200, 'Administrators', config_cb, {chat_id=msg.to.id})
end
function is_JoinChannel(msg)
	local url  = https.request('https://api.telegram.org/bot'..bot_token..'/getchatmember?chat_id=@'..channel_inline..'&user_id='..msg.sender_user_id)
	if res ~= 200 then end
	local joinenabel = redis:get(RedisIndex.."JoinEnabel"..msg.chat_id)
	Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	Source_Start = Emoji[math.random(#Emoji)]
	Joinchanel = json:decode(url)
	if (not Joinchanel.ok or Joinchanel.result.status == "left" or Joinchanel.result.status == "kicked") and not joinenabel and not is_admin(msg) then
		keyboard = {}
		keyboard.inline_keyboard = {
		{{text = Source_Start.."🏷 کانال ما", url="https://telegram.me/"..channel_inline..""}}
		}
		SendInlineApi(msg.chat_id, Source_Start..'`مدیر گرامی لطفا برای اجرای دستور شما توسط ربات در کانال ما عضو شوید 🌺`', keyboard, 'md')
		if redis:get(RedisIndex.."delbot"..msg.chat_id) then
			redis:set(RedisIndex.."delbotcheck"..msg.chat_id, true)
		end
	else
		return true
	end
end
function JoinChannelPub(msg)
	local ChanelUser = redis:get(RedisIndex.."JoinChannelPub:"..msg.chat_id)
	local ChMoj = redis:sismember(RedisIndex.."ChMoj:"..msg.chat_id,msg.sender_user_id)
	local url  = https.request('https://api.telegram.org/bot'..bot_token..'/getchatmember?chat_id=@'..ChanelUser..'&user_id='..msg.sender_user_id)
	if res ~= 200 then end
	Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	Source_Start = Emoji[math.random(#Emoji)]
	Joinchanel = json:decode(url)
	if (not Joinchanel.ok or Joinchanel.result.status == "left" or Joinchanel.result.status == "kicked") and not is_mod(msg) and not ChMoj and not redis:get(RedisIndex.."CheckSendMsgJoin"..msg.chat_id..msg.from.id) then
		UserId = '['..msg.from.id..'](tg://user?id='..msg.from.id..')'
		del_msg(msg.chat_id, tonumber(msg.id))
		redis:setex(RedisIndex.."CheckSendMsgJoin"..msg.chat_id..msg.from.id, 60 ,true)
		keyboard = {}
		keyboard.inline_keyboard = {
		{{text = Source_Start.."🏷 کانال ما", url="https://telegram.me/"..ChanelUser..""}},
		{{text = Source_Start.."معاف از عضویت اجباری", callback_data = 'ChMoj:'..msg.chat_id..':'..msg.from.id..':'..msg.from.first_name}}
		}
		SendInlineApi(msg.chat_id, Source_Start.."`کاربر` "..UserId.." - "..check_markdown(msg.from.first_name).." `برای ارسال پیام در گروه باید در کانال ما عضو شوید` 🌺", keyboard, 'md')
		if redis:get(RedisIndex.."delbot"..msg.chat_id) then
			redis:set(RedisIndex.."delbotcheck"..msg.chat_id, true)
		end
	else
		return true
	end
end
function info_msg(data, arg)
	Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	Source_Start = Emoji[math.random(#Emoji)]
	if data.username then
		username = "@"..check_markdown(data.username)
	else
		username = ""
	end
	if data.first_name then
		firstname = check_markdown(data.first_name)
	else
		firstname = ""
	end
	if data.last_name then
		lastname = check_markdown(data.last_name)
	else
		lastname = ""
	end
	text = ""..Source_Start.."*نام :* `"..firstname.."`\n"..Source_Start.."*فامیلی :* `"..lastname.."`\n"..Source_Start.."*نام کاربری :* "..username.."\n"..Source_Start.."*آیدی :* `"..data.id.."`\n"
	if is_leader1(data.id) then
		text = text..Source_Start..'*مقام :* `سازنده سورس`\n'
	elseif is_sudo1(data.id) then
		text = text..Source_Start..'*مقام :* `سودو ربات`\n'
	elseif is_admin1(data.id) then
		text = text..Source_Start..'*مقام :* `ادمین ربات`\n'
	elseif is_owner1(arg.chat_id, data.id) then
		text = text..Source_Start..'*مقام :* `سازنده گروه`\n'
	elseif is_mod1(arg.chat_id, data.id) then
		text = text..Source_Start..'*مقام :* `مدیر گروه`\n'
	else
		text = text..Source_Start..'*مقام :* `کاربر عادی`\n'
	end
	uhash = 'user:'..data.id
	user = redis:hgetall(RedisIndex..uhash)
	um_hash = 'msgs:'..data.id..':'..arg.chat_id
	gaps = 'msgs:'..arg.chat_id
	hashss = 'laghab:'..tostring(data.id)
	laghab = redis:get(RedisIndex..hashss) or 'ثبت نشده'
	user_info_msgs = tonumber(redis:get(RedisIndex..um_hash) or 0)
	gap_info_msgs = tonumber(redis:get(RedisIndex..gaps) or 0)
	Percent_= tonumber(user_info_msgs) / tonumber(gap_info_msgs) * 100
	if Percent_ < 10 then
		Percent = '0'..string.sub(Percent_, 1, 4)
	elseif Percent_ >= 10 then
		Percent = string.sub(Percent_, 1, 5)
	end
	if tonumber(Percent) <= 10 then
		UsStatus = "ضعیف 😴"
	elseif tonumber(Percent) <= 20 then
		UsStatus = "معمولی 😊"
	elseif tonumber(Percent) <= 100 then
		UsStatus = "فعال 😎"
	end
	text = text..Source_Start..'*پیام های گروه :* `'..gap_info_msgs..'`\n'
	text = text..Source_Start..'*پیام های کاربر :* `'..user_info_msgs..'`\n'
	text = text..Source_Start..'*درصد پیام کاربر :* `('..Percent..'%)`\n'
	text = text..Source_Start..'*وضعیت کاربر :* `'..UsStatus..'`\n'
	text = text..Source_Start..'*لقب کاربر :* `'..laghab..'`'
	tdbot.sendMessage(arg.chat_id, arg.msgid, 0, text, 0, "md")
end
function action_by_reply(arg, data)
	Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	Source_Start = Emoji[math.random(#Emoji)]
	cmd = arg.cmd
	rank = arg.rank
	if not tonumber(data.sender_user_id) then return false end
	if data.sender_user_id then
		local function getUser(arg, Msg)
			user_name = check_markdown(Msg.first_name)
			if cmd == "warn" then
				warnhash = redis:hget(RedisIndex..arg.chat_id..':warn', Msg.id) or 1
				max_warn = tonumber(redis:get(RedisIndex..'max_warn:'..arg.chat_id) or 5)
				if tonumber(Msg.id) == our_id then
					tdbot.sendMessage(arg.chat_id, data.id, 0, Source_Start.."*من نمیتوانم به خودم اخطار دهم*"..EndMsg, 0, "md")
				elseif is_mod1(arg.chat_id, Msg.id) and not is_admin1(Msg.id)then
					tdbot.sendMessage(arg.chat_id, data.id, 0, Source_Start.."*شما نمیتوانید به مدیران،صاحبان گروه، و ادمین های ربات اخطار دهید*"..EndMsg, 0, "md")
				elseif is_admin1(Msg.id)then
					tdbot.sendMessage(arg.chat_id, data.id, 0, Source_Start.."*شما نمیتوانید به ادمین های ربات اخطار دهید*"..EndMsg, 0, "md")
				elseif tonumber(warnhash) == tonumber(max_warn) then
					kick_user(Msg.id, arg.chat_id)
					redis:hdel(RedisIndex..arg.chat_id..':warn', Msg.id, '0')
					tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." به دلیل دریافت اخطار بیش از حد اخراج شد"..EndMsg.."\nتعداد اخطار ها : "..warnhash.."/"..max_warn.."", 8, string.len(Msg.id))
				else
					redis:hset(RedisIndex..arg.chat_id..':warn', Msg.id, tonumber(warnhash) + 1)
					tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." شما یک اخطار دریافت کردید"..EndMsg.."\nتعداد اخطار های شما : "..warnhash.."/"..max_warn.."", 8, string.len(Msg.id))
				end
			elseif cmd == "unwarn" then
				warnhash = redis:hget(RedisIndex..arg.chat_id..':warn', Msg.id) or 1
				if not redis:hget(RedisIndex..arg.chat_id..':warn', Msg.id) then
					tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." هیچ اخطاری دریافت نکرده"..EndMsg, 8, string.len(Msg.id))
				else
					redis:hdel(RedisIndex..arg.chat_id..':warn', Msg.id, '0')
					tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."تمامی اخطار های "..Msg.id.." - "..user_name.." پاک شدند"..EndMsg, 18, string.len(Msg.id))
				end
			elseif cmd == "setwhitelist" then
				if redis:sismember(RedisIndex.."Whitelist:"..arg.chat_id,Msg.id) then
					tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از قبل در لیست ویژه بود"..EndMsg, 8, string.len(Msg.id))
				else
					redis:sadd(RedisIndex.."Whitelist:"..arg.chat_id,Msg.id)
					tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." به لیست ویژه اضافه شد"..EndMsg, 8, string.len(Msg.id))
				end
			elseif cmd == "remwhitelist" then
				if not redis:sismember(RedisIndex.."Whitelist:"..arg.chat_id,Msg.id) then
					tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از قبل در لیست ویژه نبود"..EndMsg, 8, string.len(Msg.id))
				else
					redis:srem(RedisIndex.."Whitelist:"..arg.chat_id,Msg.id)
					tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از لیست ویژه حذف شد"..EndMsg, 8, string.len(Msg.id))
				end
			elseif cmd == "setowner" then
				if redis:sismember(RedisIndex.."Owners:"..arg.chat_id,Msg.id) then
					tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از قبل مالک گروه بود"..EndMsg, 8, string.len(Msg.id))
				else
					redis:sadd(RedisIndex.."Owners:"..arg.chat_id,Msg.id)
					tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." به مقام مالک گروه منتصب شد"..EndMsg, 8, string.len(Msg.id))
				end
			elseif cmd == "promote" then
				if redis:sismember(RedisIndex.."Mods:"..arg.chat_id,Msg.id) then
					tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از قبل مدیر گروه بود"..EndMsg, 8, string.len(Msg.id))
				else
					redis:sadd(RedisIndex.."Mods:"..arg.chat_id,Msg.id)
					tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." به مقام مدیر گروه منتصب شد"..EndMsg, 8, string.len(Msg.id))
				end
			elseif cmd == "remowner" then
				if not redis:sismember(RedisIndex.."Owners:"..arg.chat_id,Msg.id) then
					tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از قبل مالک گروه نبود"..EndMsg, 8, string.len(Msg.id))
				else
					redis:srem(RedisIndex.."Owners:"..arg.chat_id,Msg.id)
					tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از مقام مالک گروه برکنار شد"..EndMsg, 8, string.len(Msg.id))
				end
			elseif cmd == "demote" then
				if not redis:sismember(RedisIndex.."Mods:"..arg.chat_id,Msg.id) then
					tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از قبل مدیر گروه نبود"..EndMsg, 8, string.len(Msg.id))
				else
					redis:srem(RedisIndex.."Mods:"..arg.chat_id,Msg.id)
					tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از مقام مدیر گروه برکنار شد"..EndMsg, 8, string.len(Msg.id))
				end
			elseif cmd == "ban" then
				if Msg.id == our_id then
					tdbot.sendMessage(arg.chat_id, data.id, 0, Source_Start.."*من نمیتوانم خودم رو از گروه محروم کنم*"..EndMsg, 0, "md")
				elseif is_mod1(arg.chat_id, Msg.id) then
					tdbot.sendMessage(arg.chat_id, data.id, 0, Source_Start.."*شما نمیتوانید مدیران،صاحبان گروه، و ادمین های ربات رو از گروه محروم کنید*"..EndMsg, 0, "md")
				elseif redis:sismember(RedisIndex.."Banned:"..arg.chat_id,Msg.id) then
					tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از گروه محروم بود"..EndMsg, 8, string.len(Msg.id))
				else
					redis:sadd(RedisIndex.."Banned:"..arg.chat_id,Msg.id)
					kick_user(Msg.id, arg.chat_id)
					tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از گروه محروم شد"..EndMsg, 8, string.len(Msg.id))
				end
			elseif cmd == "unban" then
				if not redis:sismember(RedisIndex.."Banned:"..arg.chat_id,Msg.id) then
					tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از گروه محروم نبود"..EndMsg, 8, string.len(Msg.id))
				else
					redis:srem(RedisIndex.."Banned:"..arg.chat_id,Msg.id)
					channel_unblock(arg.chat_id, Msg.id)
					tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از محرومیت گروه خارج شد"..EndMsg, 8, string.len(Msg.id))
				end
			elseif cmd == "silent" then
				if Msg.id == our_id then
					tdbot.sendMessage(arg.chat_id, data.id, 0, Source_Start.."*من نمیتوانم توانایی چت کردن رو از خودم بگیرم*"..EndMsg, 0, "md")
				elseif is_mod1(arg.chat_id, Msg.id) then
					tdbot.sendMessage(arg.chat_id, data.id, 0, Source_Start.."*شما نمیتوانید توانایی چت کردن رو از مدیران،صاحبان گروه، و ادمین های ربات بگیرید*"..EndMsg, 0, "md")
				else
					local function check_silent(msg, is_silent)
						local user_name = msg.user_name
						arg = msg.arg
						if is_silent then
							tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از قبل توانایی چت کردن رو نداشت"..EndMsg, 8, string.len(Msg.id))
						else
							silent_user(arg.chat_id, Msg.id)
							redis:sadd(RedisIndex.."Silentlist:"..arg.chat_id,Msg.id)
							tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." توانایی چت کردن رو از دست داد"..EndMsg, 8, string.len(Msg.id))
						end
					end
					is_silent_user(Msg.id, arg.chat_id, {arg=arg, user_name=user_name,id=Msg.id}, check_silent)
				end
			elseif cmd == "unsilent" then
				local function check_silent(msg, is_silent)
					local user_name = msg.user_name
					arg = msg.arg
					if not is_silent then
						tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از قبل توانایی چت کردن را داشت"..EndMsg, 8, string.len(Msg.id))
					else
						unsilent_user(arg.chat_id, Msg.id)
						redis:srem(RedisIndex.."Silentlist:"..arg.chat_id,Msg.id)
						tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." توانایی چت کردن رو به دست آورد"..EndMsg, 8, string.len(Msg.id))
					end
				end
				is_silent_user(Msg.id, arg.chat_id, {arg=arg, user_name=user_name,id=Msg.id}, check_silent)
			elseif cmd == "banall" then
				if Msg.id == our_id then
					tdbot.sendMessage(arg.chat_id, data.id, 0, Source_Start.."*من نمیتوانم خودم رو از تمام گروه های ربات محروم کنم*"..EndMsg, 0, "md")
				elseif is_admin1(Msg.id) then
					tdbot.sendMessage(arg.chat_id, data.id, 0, Source_Start.."*شما نمیتوانید ادمین های ربات رو از تمامی گروه های ربات محروم کنید*"..EndMsg, 0, "md")
				elseif is_gbanned(Msg.id) then
					tdbot.sendMessage(arg.chat_id, data.id, 0, Source_Start.."*کاربر* `"..Msg.id.."` - "..user_name.." *از گروه های ربات محروم بود*"..EndMsg, 0, "md")
				else
					redis:sadd(RedisIndex.."GBanned",Msg.id)
					kick_user(Msg.id, arg.chat_id)
					tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از تمام گروه های ربات محروم شد"..EndMsg, 8, string.len(Msg.id))
				end
			elseif cmd == "unbanall" then
				if not is_gbanned(Msg.id) then
					tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از گروه های ربات محروم نبود"..EndMsg, 8, string.len(Msg.id))
				else
					redis:srem(RedisIndex.."GBanned",Msg.id)
					tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از محرومیت گروه های ربات خارج شد"..EndMsg, 8, string.len(Msg.id))
				end
			elseif cmd == "kick" then
				if Msg.id == our_id then
					tdbot.sendMessage(arg.chat_id, data.id, 0, Source_Start.."*من نمیتوانم خودم رو از گروه اخراج کنم کنم*"..EndMsg, 0, "md")
				elseif is_mod1(arg.chat_id, Msg.id) then
					tdbot.sendMessage(arg.chat_id, data.id, 0, Source_Start.."*شما نمیتوانید مدیران،صاحبان گروه و ادمین های ربات رو اخراج کنید*"..EndMsg, 0, "md")
				else
					kick_user(Msg.id, arg.chat_id)
					sleep(1)
					channel_unblock(arg.chat_id, Msg.id)
				end
			elseif cmd == "adminprom" then
				if is_admin1(tonumber(Msg.id)) then
					tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از قبل ادمین ربات بود"..EndMsg, 8, string.len(Msg.id))
				else
					table.insert(Config.admins, {tonumber(Msg.id), user_name})
					save_config()
					tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." به مقام ادمین ربات منتصب شد"..EndMsg, 8, string.len(Msg.id))
				end
			elseif cmd == "admindem" then
				if not is_admin1(Msg.id) then
					tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از قبل ادمین ربات نبود"..EndMsg, 8, string.len(Msg.id))
				else
					table.remove(Config.admins, nameid)
					save_config()
					tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از مقام ادمین ربات برکنار شد"..EndMsg, 8, string.len(Msg.id))
				end
			elseif cmd == "visudo" then
				if already_sudo(tonumber(Msg.id)) then
					tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از قبل سودو ربات بود"..EndMsg, 8, string.len(Msg.id))
				else
					table.insert(Config.sudo_users, tonumber(Msg.id))
					save_config()
					tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." به مقام سودو ربات منتصب شد"..EndMsg, 8, string.len(Msg.id))
				end
			elseif cmd == "desudo" then
				if not already_sudo(Msg.id) then
					tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از قبل سودو ربات نبود"..EndMsg, 8, string.len(Msg.id))
				else
					table.remove(Config.sudo_users, getindex( Config.sudo_users, tonumber(Msg.id)))
					save_config()
					tdbot.sendMention(arg.chat_id, Msg.id, data.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از مقام سودو ربات برکنار شد"..EndMsg, 8, string.len(Msg.id))
				end
			elseif cmd == "id" then
				local function getpro(x, m)
					local user_info_msgs = tonumber(redis:get(RedisIndex..'msgs:'..Msg.id..':'..arg.chat_id) or 0)
					local gap_info_msgs = tonumber(redis:get(RedisIndex..'msgs:'..arg.chat_id) or 0)
					if not m.photos[0] then
						tdbot.sendMessage(arg.chat_id, data.id, 1, ''..Source_Start..'*شناسه گروه :* `'..arg.chat_id..'`\n'..Source_Start..'*تعداد پیام های گروه :* `[ '..gap_info_msgs..' ]`\n'..Source_Start..'*شناسه شما :* `'..data.id..'`\n'..Source_Start..'*تعداد پیام های شما :* `[ '..user_info_msgs..' ]`\n'..Source_Start..'*نام کاربری :* @'..check_markdown(Msg.username or user_name)..'', 1, 'md')
					else
						tdbot.sendPhoto(arg.chat_id, data.id, m.photos[0].sizes[1].photo.persistent_id, 0, {}, 0, 0, ''..Source_Start..'شناسه گروه : '..arg.chat_id..'\n'..Source_Start..'تعداد پیام های گروه : [ '..gap_info_msgs..' ]\n'..Source_Start..'شناسه شما : '..data.id..'\n'..Source_Start..'تعداد پیام های شما : [ '..user_info_msgs..' ]\n'..Source_Start..' نام کاربری : @'..Msg.username or user_name..'', 0, 0, 1, nil, dl_cb, nil)
					end
				end
				assert(tdbot_function ({
				_ = "getUserProfilePhotos",
				user_id = data.sender_user_id,
				offset = 0,
				limit = 1
				}, getpro, nil))
			elseif cmd == "setrank" then
				redis:set(RedisIndex.."laghab:"..Msg.id, rank)
				tdbot.sendMention(arg.chat_id,Msg.id, data.id,Source_Start.."مقام کاربر [ "..Msg.id.." ] تنظیم شد به : ( "..rank.." )"..EndMsg,15,string.len(Msg.id))
			elseif cmd == "delrank" then
				redis:del(RedisIndex.."laghab:"..Msg.id)
				tdbot.sendMention(arg.chat_id,Msg.id, data.id,Source_Start.."مقام کاربر [ "..Msg.id.." ] حذف شد"..EndMsg,15,string.len(Msg.id))
			end
		end
		tdbot.getUser(data.sender_user_id, getUser, {chat_id=data.chat_id,user_id=data.sender_user_id})
	end
end
function action_by_username(arg, data)
	Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	Source_Start = Emoji[math.random(#Emoji)]
	cmd = arg.cmd
	msg = arg.msg
	if not arg.username then return false end
	if data.id then
		local function getUser(arg, Msg)
			user_name = check_markdown(Msg.first_name)
			if not Msg.id then return end
			if cmd == "warn" then
				warnhash = redis:hget(RedisIndex..arg.chat_id..':warn', Msg.id) or 1
				max_warn = tonumber(redis:get(RedisIndex..'max_warn:'..arg.chat_id) or 5)
				if Msg.id == our_id then
					tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*من نمیتوانم به خودم اخطار دهم*"..EndMsg, 0, "md")
				elseif is_mod1(arg.chat_id, Msg.id) and not is_admin1(Msg.id)then
					tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*شما نمیتوانید به مدیران،صاحبان گروه، و ادمین های ربات اخطار دهید*"..EndMsg, 0, "md")
				elseif is_admin1(Msg.id)then
					tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*شما نمیتوانید به ادمین های ربات اخطار دهید*"..EndMsg, 0, "md")
				elseif tonumber(warnhash) == tonumber(max_warn) then
					kick_user(Msg.id, arg.chat_id)
					redis:hdel(RedisIndex..arg.chat_id..':warn', Msg.id, '0')
					tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." به دلیل دریافت اخطار بیش از حد اخراج شد"..EndMsg.."\nتعداد اخطار ها : "..warnhash.."/"..max_warn.."", 8, string.len(Msg.id))
				else
					redis:hset(RedisIndex..arg.chat_id..':warn', Msg.id, tonumber(warnhash) + 1)
					tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." شما یک اخطار دریافت کردید"..EndMsg.."\nتعداد اخطار های شما : "..warnhash.."/"..max_warn.."", 8, string.len(Msg.id))
				end
			elseif cmd == "unwarn" then
				warnhash = redis:hget(RedisIndex..arg.chat_id..':warn', Msg.id) or 1
				if not redis:hget(RedisIndex..arg.chat_id..':warn', Msg.id) then
					tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." هیچ اخطاری دریافت نکرده", 8, string.len(Msg.id))
				else
					redis:hdel(RedisIndex..arg.chat_id..':warn', Msg.id, '0')
					tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."تمامی اخطار های "..Msg.id.." - "..user_name.." پاک شدند"..EndMsg, 18, string.len(Msg.id))
				end
			elseif cmd == "setwhitelist" then
				if redis:sismember(RedisIndex.."Whitelist:"..arg.chat_id,Msg.id) then
					tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از قبل در لیست ویژه بود"..EndMsg, 8, string.len(Msg.id))
				else
					redis:sadd(RedisIndex.."Whitelist:"..arg.chat_id,Msg.id)
					tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." به لیست ویژه اضافه شد"..EndMsg, 8, string.len(Msg.id))
				end
			elseif cmd == "remwhitelist" then
				if not redis:sismember(RedisIndex.."Whitelist:"..arg.chat_id,Msg.id) then
					tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از قبل در لیست ویژه نبود"..EndMsg, 8, string.len(Msg.id))
				else
					redis:srem(RedisIndex.."Whitelist:"..arg.chat_id,Msg.id)
					tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از لیست ویژه حذف شد"..EndMsg, 8, string.len(Msg.id))
				end
			elseif cmd == "setowner" then
				if redis:sismember(RedisIndex.."Owners:"..arg.chat_id,Msg.id) then
					tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از قبل مالک گروه بود"..EndMsg, 8, string.len(Msg.id))
				else
					redis:sadd(RedisIndex.."Owners:"..arg.chat_id,Msg.id)
					tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." به مقام مالک گروه منتصب شد"..EndMsg, 8, string.len(Msg.id))
				end
			elseif cmd == "promote" then
				if redis:sismember(RedisIndex.."Mods:"..arg.chat_id,Msg.id) then
					tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از قبل مدیر گروه بود"..EndMsg, 8, string.len(Msg.id))
				else
					redis:sadd(RedisIndex.."Mods:"..arg.chat_id,Msg.id)
					tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." به مقام مدیر گروه منتصب شد"..EndMsg, 8, string.len(Msg.id))
				end
			elseif cmd == "remowner" then
				if not redis:sismember(RedisIndex.."Owners:"..arg.chat_id,Msg.id) then
					tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از قبل مالک گروه نبود"..EndMsg, 8, string.len(Msg.id))
				else
					redis:srem(RedisIndex.."Owners:"..arg.chat_id,Msg.id)
					tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از مقام مالک گروه برکنار شد"..EndMsg, 8, string.len(Msg.id))
				end
			elseif cmd == "demote" then
				if not redis:sismember(RedisIndex.."Mods:"..arg.chat_id,Msg.id) then
					tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از قبل مدیر گروه نبود"..EndMsg, 8, string.len(Msg.id))
				else
					redis:srem(RedisIndex.."Mods:"..arg.chat_id,Msg.id)
					tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از مقام مدیر گروه برکنار شد"..EndMsg, 8, string.len(Msg.id))
				end
			elseif cmd == "res" then
				tdbot.sendMessage(arg.chat_id, msg.id, 0, Source_Start.."`اطلاعات برای :` @"..check_markdown(Msg.username).."\n"..Source_Start.."`نام :` "..user_name.."\n"..Source_Start.."`ایدی :` *"..Msg.id.."*", 0, "md")
			elseif cmd == "ban" then
				if Msg.id == our_id then
					tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*من نمیتوانم خودم رو از گروه محروم کنم*"..EndMsg, 0, "md")
				elseif is_mod1(arg.chat_id, Msg.id) then
					tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*شما نمیتوانید مدیران،صاحبان گروه، و ادمین های ربات رو از گروه محروم کنید*"..EndMsg, 0, "md")
				elseif redis:sismember(RedisIndex.."Banned:"..arg.chat_id,Msg.id) then
					tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از گروه محروم بود"..EndMsg, 8, string.len(Msg.id))
				else
					redis:sadd(RedisIndex.."Banned:"..arg.chat_id,Msg.id)
					kick_user(Msg.id, arg.chat_id)
					tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از گروه محروم شد"..EndMsg, 8, string.len(Msg.id))
				end
			elseif cmd == "unban" then
				if not redis:sismember(RedisIndex.."Banned:"..arg.chat_id,Msg.id) then
					tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از گروه محروم نبود"..EndMsg, 8, string.len(Msg.id))
				else
					redis:srem(RedisIndex.."Banned:"..arg.chat_id,Msg.id)
					channel_unblock(arg.chat_id, Msg.id)
					tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از محرومیت گروه خارج شد"..EndMsg, 8, string.len(Msg.id))
				end
			elseif cmd == "silent" then
				if Msg.id == our_id then
					tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*من نمیتوانم توانایی چت کردن رو از خودم بگیرم*"..EndMsg, 0, "md")
				elseif is_mod1(arg.chat_id, Msg.id) then
					tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*شما نمیتوانید توانایی چت کردن رو از مدیران،صاحبان گروه، و ادمین های ربات بگیرید*"..EndMsg, 0, "md")
				else
					local function check_silent(msg, is_silent)
						local user_name = msg.user_name
						arg = msg.arg
						if is_silent then
							tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از قبل توانایی چت کردن رو نداشت"..EndMsg, 8, string.len(Msg.id))
						else
							silent_user(arg.chat_id, Msg.id)
							redis:sadd(RedisIndex.."Silentlist:"..arg.chat_id,Msg.id)
							tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." توانایی چت کردن رو از دست داد"..EndMsg, 8, string.len(Msg.id))
						end
					end
					is_silent_user(Msg.id, arg.chat_id, {arg=arg, user_name=user_name,id=Msg.id}, check_silent)
				end
			elseif cmd == "unsilent" then
				local function check_silent(msg, is_silent)
					local user_name = msg.user_name
					arg = msg.arg
					if not is_silent then
						tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از قبل توانایی چت کردن را داشت"..EndMsg, 8, string.len(Msg.id))
					else
						unsilent_user(arg.chat_id, Msg.id)
						redis:srem(RedisIndex.."Silentlist:"..arg.chat_id,Msg.id)
						tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." توانایی چت کردن رو به دست آورد"..EndMsg, 8, string.len(Msg.id))
					end
				end
				is_silent_user(Msg.id, arg.chat_id, {arg=arg, user_name=user_name,id=Msg.id}, check_silent)
			elseif cmd == "banall" then
				if Msg.id == our_id then
					tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*من نمیتوانم خودم رو از تمام گروه های ربات محروم کنم*"..EndMsg, 0, "md")
				elseif is_admin1(Msg.id) then
					tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*شما نمیتوانید ادمین های ربات رو از تمامی گروه های ربات محروم کنید*"..EndMsg, 0, "md")
				elseif is_gbanned(Msg.id) then
					tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از گروه های ربات محروم بود"..EndMsg, 8, string.len(Msg.id))
				else
					redis:sadd(RedisIndex.."GBanned",Msg.id)
					kick_user(Msg.id, arg.chat_id)
					tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از تمام گروه های ربات محروم شد"..EndMsg, 8, string.len(Msg.id))
				end
			elseif cmd == "unbanall" then
				if not is_gbanned(Msg.id) then
					tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از گروه های ربات محروم نبود"..EndMsg, 8, string.len(Msg.id))
				else
					redis:srem(RedisIndex.."GBanned",Msg.id)
					tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از محرومیت گروه های ربات خارج شد"..EndMsg, 8, string.len(Msg.id))
				end
			elseif cmd == "kick" then
				if Msg.id == our_id then
					tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*من نمیتوانم خودم رو از گروه اخراج کنم کنم*"..EndMsg, 0, "md")
				elseif is_mod1(arg.chat_id, Msg.id) then
					tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*شما نمیتوانید مدیران،صاحبان گروه و ادمین های ربات رو اخراج کنید*"..EndMsg, 0, "md")
				else
					kick_user(Msg.id, arg.chat_id)
					sleep(1)
					channel_unblock(arg.chat_id, Msg.id)
				end
			elseif cmd == "adminprom" then
				if is_admin1(tonumber(Msg.id)) then
					tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از قبل ادمین ربات بود"..EndMsg, 8, string.len(Msg.id))
				else
					table.insert(Config.admins, {tonumber(Msg.id), user_name})
					save_config()
					tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." به مقام ادمین ربات منتصب شد"..EndMsg, 8, string.len(Msg.id))
				end
			elseif cmd == "admindem" then
				if not is_admin1(Msg.id) then
					tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از قبل ادمین ربات نبود"..EndMsg, 8, string.len(Msg.id))
				else
					table.remove(Config.admins, nameid)
					save_config()
					tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از مقام ادمین ربات برکنار شد"..EndMsg, 8, string.len(Msg.id))
				end
			elseif cmd == "visudo" then
				if already_sudo(tonumber(Msg.id)) then
					tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از قبل سودو ربات بود"..EndMsg, 8, string.len(Msg.id))
				else
					table.insert(Config.sudo_users, tonumber(Msg.id))
					save_config()
					tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." به مقام سودو ربات منتصب شد"..EndMsg, 8, string.len(Msg.id))
				end
			elseif cmd == "desudo" then
				if not already_sudo(Msg.id) then
					tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از قبل سودو ربات نبود"..EndMsg, 8, string.len(Msg.id))
				else
					table.remove(Config.sudo_users, getindex( Config.sudo_users, tonumber(Msg.id)))
					save_config()
					tdbot.sendMention(arg.chat_id, Msg.id, msg.id, Source_Start.."کاربر "..Msg.id.." - "..user_name.." از مقام سودو ربات برکنار شد"..EndMsg, 8, string.len(Msg.id))
				end
			end
		end
		tdbot.getUser(data.id, getUser, {chat_id=arg.chat_id,user_id=data.id})
	end
end
function action_by_id(arg, data)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	cmd = arg.cmd
	if not tonumber(arg.user_id) then return false end
	if data.id then
		if data.username then
			user_name = '@'..check_markdown(data.username)
		else
			user_name = check_markdown(data.first_name)
		end
		if cmd == "warn" then
			if data.id == our_id then
				return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*من نمیتوانم به خودم اخطار دهم*"..EndMsg, 0, "md")
			end
			if is_mod1(arg.chat_id, data.id) and not is_admin1(msg.from.id)then
				return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*شما نمیتوانید به مدیران،صاحبان گروه، و ادمین های ربات اخطار دهید*"..EndMsg, 0, "md")
			end
			if is_admin1(data.id)then
				return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*شما نمیتوانید به ادمین های ربات اخطار دهید*"..EndMsg, 0, "md")
			end
			if tonumber(warnhash) == tonumber(max_warn) then
				kick_user(data.id, arg.chat_id)
				redis:hdel(RedisIndex..hashwarn, data.id, '0')
				return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*کاربر* `"..data.id.."` - "..user_name.." به دلیل دریافت اخطار بیش از حد اخراج شد\nتعداد اخطار ها : "..hashwarn.."/"..max_warn..""..EndMsg, 0, "md")
			else
				redis:hset(RedisIndex..hashwarn, data.id, tonumber(warnhash) + 1)
				return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*کاربر* `"..data.id.."` - "..user_name.." *شما یک اخطار دریافت کردید*\n*تعداد اخطار های شما : "..warnhash.."/"..max_warn.."*"..EndMsg, 0, "md")
			end
		end
		if cmd == "unwarn" then
			if not redis:hget(RedisIndex..hashwarn, data.id) then
				return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*کاربر* `"..data.id.."` - "..user_name.." *هیچ اخطاری دریافت نکرده*"..EndMsg, 0, "md")
			else
				redis:hdel(RedisIndex..hashwarn, data.id, '0')
				return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*تمامی اخطار های* `"..data.id.."` - "..user_name.." *پاک شدند*"..EndMsg, 0, "md")
			end
		end
		if cmd == "setwhitelist" then
			local list = redis:sismember(RedisIndex.."Whitelist:"..arg.chat_id,data.id)
			if list then
				return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل در لیست ویژه بود*"..EndMsg, 0, "md")
			end
			redis:sadd(RedisIndex.."Whitelist:"..arg.chat_id,data.id)
			return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*کاربر* `"..data.id.."` - "..user_name.." *به لیست ویژه اضافه شد*"..EndMsg, 0, "md")
		end
		if cmd == "remwhitelist" then
			local list = redis:sismember(RedisIndex.."Whitelist:"..arg.chat_id,data.id)
			if not list then
				return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل در لیست ویژه نبود*"..EndMsg, 0, "md")
			end
			redis:srem(RedisIndex.."Whitelist:"..arg.chat_id,data.id)
			return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*کاربر* `"..data.id.."` - "..user_name.." *از لیست ویژه حذف شد*"..EndMsg, 0, "md")
		end
		if cmd == "setowner" then
			local list = redis:sismember(RedisIndex.."Owners:"..arg.chat_id,data.id)
			if list then
				return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل مالک گروه بود*"..EndMsg, 0, "md")
			end
			redis:sadd(RedisIndex.."Owners:"..arg.chat_id,data.id)
			return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*کاربر* `"..data.id.."` - "..user_name.." *به مقام مالک گروه منتصب شد*"..EndMsg, 0, "md")
		end
		if cmd == "promote" then
			local list = redis:sismember(RedisIndex.."Mods:"..arg.chat_id,data.id)
			if list then
				return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل مدیر گروه بود*"..EndMsg, 0, "md")
			end
			redis:sadd(RedisIndex.."Mods:"..arg.chat_id,data.id)
			return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*کاربر* `"..data.id.."` - "..user_name.." *به مقام مدیر گروه منتصب شد*"..EndMsg, 0, "md")
		end
		if cmd == "remowner" then
			local list = redis:sismember(RedisIndex.."Owners:"..arg.chat_id,data.id)
			if not list then
				return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*کاربر* `"..data.id.."` - "..user_name.."*از قبل مالک گروه نبود*"..EndMsg, 0, "md")
			end
			redis:srem(RedisIndex.."Owners:"..arg.chat_id,data.id)
			return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*کاربر* `"..data.id.."` - "..user_name.." *از مقام مالک گروه برکنار شد*"..EndMsg, 0, "md")
		end
		if cmd == "demote" then
			local list = redis:sismember(RedisIndex.."Mods:"..arg.chat_id,data.id)
			if not list then
				return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل مدیر گروه نبود*"..EndMsg, 0, "md")
			end
			redis:srem(RedisIndex.."Mods:"..arg.chat_id,data.id)
			return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*کاربر* `"..data.id.."` - "..user_name.." *از مقام مدیر گروه برکنار شد*"..EndMsg, 0, "md")
		end
		if cmd == "kick" then
			if tonumber(data.id) == our_id then
				return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*من نمیتوانم خودم رو از گروه اخراج کنم*"..EndMsg, 0, "md")
			elseif is_mod1(arg.chat_id, userid) then
				tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*شما نمیتوانید مدیران،صاحبان گروه و ادمین های ربات رو اخراج کنید*"..EndMsg, 0, "md")
			else
				kick_user(data.id, arg.chat_id)
				sleep(1)
				channel_unblock(arg.chat_id, data.id)
			end
		end
		if cmd == "delall" then
			if is_mod1(arg.chat_id, data.id) then
				return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*شما نمیتوانید پیام های مدیران،صاحبان گروه و ادمین های ربات رو پاک کنید*"..EndMsg, 0, "md")
			else
				tdbot.deleteMessagesFromUser(arg.chat_id, data.id, dl_cb, nil)
				tdbot.sendMention(arg.chat_id,data.id, arg.id,Source_Start..'تمامی پیام های '..data.id..' پاک شد'..EndMsg,17,string.len(data.id))
			end
		end
		if cmd == "banall" then
			if tonumber(data.id) == our_id then
				return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*من نمیتوانم خودم رو از تمام گروه های ربات محروم کنم*"..EndMsg, 0, "md")
			end
			if is_admin1(data.id) then
				return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*شما نمیتوانید ادمین های ربات رو از گروه های ربات محروم کنید*"..EndMsg, 0, "md")
			end
			if is_gbanned(data.id) then
				tdbot.sendMention(arg.chat_id,data.id, arg.id,Source_Start..'کاربر '..data.id..' از گروه های ربات محروم بود'..EndMsg,8,string.len(data.id))
			end
			redis:sadd(RedisIndex.."GBanned",data.id)
			kick_user(data.id, arg.chat_id)
			tdbot.sendMention(arg.chat_id,data.id, arg.id,Source_Start..'کاربر '..data.id..' از تمام گروه هار ربات محروم شد'..EndMsg,8,string.len(data.id))
		end
		if cmd == "unbanall" then
			if not is_gbanned(data.id) then
				tdbot.sendMention(arg.chat_id,data.id, arg.id,Source_Start..'کاربر '..data.id..' از گروه های ربات محروم نبود'..EndMsg,8,string.len(data.id))
			end
			redis:srem(RedisIndex.."GBanned",data.id)
			tdbot.sendMention(arg.chat_id,data.id, arg.id,Source_Start..'کاربر '..data.id..' از محرومیت گروه های ربات خارج شد'..EndMsg,8,string.len(data.id))
		end
		if cmd == "ban" then
			if tonumber(data.id) == our_id then
				return tdbot.sendMessage(arg.chat_id, arg.id, 0, Source_Start.."*من نمیتوانم خودم رو از گروه محروم کنم*"..EndMsg, 0, "md")
			end
			if is_mod1(arg.chat_id, tonumber(data.id)) then
				return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*شما نمیتوانید مدیران،صاحبان گروه و ادمین های ربات رو از گروه محروم کنید*"..EndMsg, 0, "md")
			end
			if is_banned(data.id, arg.chat_id) then
				tdbot.sendMention(arg.chat_id,data.id, arg.id,Source_Start..'کاربر '..data.id..' از گروه محروم بود'..EndMsg,8,string.len(data.id))
			end
			redis:sadd(RedisIndex.."Banned:"..arg.chat_id,data.id)
			kick_user(data.id, arg.chat_id)
			tdbot.sendMention(arg.chat_id,data.id, arg.id,'کاربر '..data.id..' از گروه محروم شد'..EndMsg,8,string.len(data.id))
		end
		if cmd == "unban" then
			if not is_banned(data.id, arg.chat_id) then
				tdbot.sendMention(arg.chat_id,data.id, arg.id,Source_Start..'کاربر '..data.id..' از گروه محروم نبود'..EndMsg,8,string.len(data.id))
			end
			redis:srem(RedisIndex.."Banned:"..arg.chat_id,data.id)
			channel_unblock(arg.chat_id, data.id)
			tdbot.sendMention(arg.chat_id,data.id, arg.id,Source_Start..'کاربر  '..data.id..' از محرومیت گروه خارج شد'..EndMsg,8,string.len(data.id))
		end
		if cmd == "silent" then
			if tonumber(data.id) == our_id then
				return tdbot.sendMessage(arg.chat_id, arg.id, 0, Source_Start.."*من نمیتوانم توانایی چت کردن رو از خودم بگیرم*"..EndMsg, 0, "md")
			end
			if is_mod1(arg.chat_id, tonumber(data.id)) then
				return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*شما نمیتوانید توانایی چت کردن رو از مدیران،صاحبان گروه و ادمین های ربات بگیرید*"..EndMsg, 0, "md")
			end
			local function check_silentt(roo, is_silent)
				if is_silent then
					tdbot.sendMention(arg.chat_id,roo.id, arg.id,Source_Start..'کاربر '..roo.id..' از قبل توانایی چت کردن رو نداشت'..EndMsg,8,string.len(roo.id))
				end
				silent_user(arg.chat_id, roo.id)
				redis:sadd(RedisIndex.."Silentlist:"..arg.chat_id,roo.id)
				tdbot.sendMention(arg.chat_id,roo.id, arg.id,Source_Start..'کاربر '..roo.id..' توانایی چت کردن رو از دست داد'..EndMsg,8,string.len(roo.id))
			end
			is_silent_user(data.id, arg.chat_id, {id=data.id}, check_silentt)
		end
		if cmd == "unsilent" then
			local function check_silent(roo, is_silent)
				if not is_silent then
					return tdbot.sendMention(arg.chat_id,roo.id, arg.id,Source_Start..'کاربر '..roo.id..' از قبل توانایی چت کردن رو داشت'..EndMsg,8,string.len(roo.id))
				end
				unsilent_user(arg.chat_id, roo.id)
				redis:srem(RedisIndex.."Silentlist:"..arg.chat_id,roo.id)
				return tdbot.sendMention(arg.chat_id,roo.id, arg.id,Source_Start..'کاربر '..roo.id..' توانایی چت کردن رو به دست آورد'..EndMsg,8,string.len(roo.id))
			end
			is_silent_user(tonumber(data.id), arg.chat_id, {id=data.id}, check_silent)
		end
		if cmd == "whois" then
			if data.username then
				username = '@'..check_markdown(data.username)
			else
				username = 'ندارد'
			end
			return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start..'اطلاعات برای [ '..data.id..' ] :\n'..Source_Start..'یوزرنیم : '..username..'\n'..Source_Start..'نام : '..check_markdown(data.first_name), 0, "md")
		end
		if cmd == "adminprom" then
			if is_admin1(tonumber(data.id)) then
				return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل ادمین ربات بود*"..EndMsg, 0, "md")
			end
			table.insert(Config.admins, {tonumber(data.id), user_name})
			save_config()
			return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*کاربر* `"..data.id.."` - "..user_name.." *به مقام ادمین ربات منتصب شد*"..EndMsg, 0, "md")
		end
		if cmd == "admindem" then
			local nameid = index_function(tonumber(data.id))
			if not is_admin1(data.id) then
				return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل ادمین ربات نبود*"..EndMsg, 0, "md")
			end
			table.remove(Config.admins, nameid)
			save_config()
			return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*کاربر* `"..data.id.."` - "..user_name.." *از مقام ادمین ربات برکنار شد*"..EndMsg, 0, "md")
		end
		if cmd == "visudo" then
			if already_sudo(tonumber(data.id)) then
				return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل سودو ربات بود*"..EndMsg, 0, "md")
			end
			table.insert(Config.sudo_users, tonumber(data.id))
			save_config()
			return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*کاربر* `"..data.id.."` - "..user_name.." *به مقام سودو ربات منتصب شد*"..EndMsg, 0, "md")
		end
		if cmd == "desudo" then
			if not already_sudo(data.id) then
				return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*کاربر* `"..data.id.."` - "..user_name.." *از قبل سودو ربات نبود*"..EndMsg, 0, "md")
			end
			table.remove(Config.sudo_users, getindex( Config.sudo_users, tonumber(data.id)))
			save_config()
			return tdbot.sendMessage(arg.chat_id, "", 0, Source_Start.."*کاربر* `"..data.id.."` - "..user_name.." *از مقام سودو ربات برکنار شد*"..EndMsg, 0, "md")
		end
	end
end
function Delall(msg)
	local chat = msg.to.id
	local user = msg.from.id
	local is_channel = msg.to.type == "channel"
	if is_channel then
		del_msg(chat, tonumber(msg.id))
	elseif is_chat then
		kick_user(user, chat)
	end
end
function Warnall(msg,fa)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	local chat = msg.to.id
	local user = msg.from.id
	local is_channel = msg.to.type == "channel"
	local hashwarn = chat..':warn'
	local warnhash = redis:hget(RedisIndex..hashwarn, user) or 1
	local max_warn = tonumber(redis:get(RedisIndex..'max_warn:'..chat) or 5)
	if is_channel then
		del_msg(chat, tonumber(msg.id))
		if tonumber(warnhash) == tonumber(max_warn) then
			tdbot.sendMessage(chat, "", 0, Source_Start.."*کاربر* @"..check_markdown(msg.from.username or '').." `"..user.."` به دلیل دریافت اخطار بیش از حد اخراج شد\nتعداد اخطار ها : "..warnhash.."/"..max_warn.."\n*دلیل اخراج :* `ارسال "..fa.."`"..EndMsg, 0, "md")
			if redis:get(RedisIndex.."delbot"..msg.chat_id) then
				redis:set(RedisIndex.."delbotcheck"..msg.chat_id, true)
			end
			kick_user(user, chat)
			redis:hdel(RedisIndex..hashwarn, user, '0')
		else
			redis:hset(RedisIndex..hashwarn, user, tonumber(warnhash) + 1)
			tdbot.sendMessage(chat, "", 0, Source_Start.."*کاربر* @"..check_markdown(msg.from.username or '').." `"..user.."` *شما یک اخطار دریافت کردید*\n*تعداد اخطار های شما : "..warnhash.."/"..max_warn.."*\n*دلیل اخطار :* `ارسال "..fa.."`"..EndMsg, 0, "md")
			if redis:get(RedisIndex.."delbot"..msg.chat_id) then
				redis:set(RedisIndex.."delbotcheck"..msg.chat_id, true)
			end
		end
	elseif is_chat then
		kick_user(user, chat)
	end
end
function Silentall(msg,fa)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	local chat = msg.to.id
	local user = msg.from.id
	local is_channel = msg.to.type == "channel"
	timemutemsg = redis:get(RedisIndex.."TimeMuteset"..msg.to.id) or 3600
	local min = math.floor(timemutemsg / 60)
	if is_channel then
		del_msg(chat, tonumber(msg.id))
		tdbot.Restricted(msg.chat_id,msg.sender_user_id,'Restricted',   {1,msg.date+timemutemsg, 0, 0, 0,0})
		tdbot.sendMessage(chat, "", 0, Source_Start.."*کاربر :*\n@"..check_markdown(msg.from.username or '').." `["..user.."]`\n*به مدت* `"..min.."` *دقیقه درحالت سکوت قرار گرفت*\n_دلیل سکوت :_ `"..fa.."`"..EndMsg, 0, "md")
		if redis:get(RedisIndex.."delbot"..msg.chat_id) then
			redis:set(RedisIndex.."delbotcheck"..msg.chat_id, true)
		end
	elseif is_chat then
		kick_user(user, chat)
	end
end
function Kickall(msg,fa)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	local chat = msg.to.id
	local user = msg.from.id
	local is_channel = msg.to.type == "channel"
	if is_channel then
		del_msg(chat, tonumber(msg.id))
		tdbot.sendMessage(chat, "", 0, Source_Start.."*کاربر :*\n@"..check_markdown(msg.from.username or '').." `["..user.."]`\n*از گروه اخراج شد*\n_ دلیل اخراج :_ `"..fa.."`"..EndMsg, 0, "md")
		if redis:get(RedisIndex.."delbot"..msg.chat_id) then
			redis:set(RedisIndex.."delbotcheck"..msg.chat_id, true)
		end
		kick_user(user, chat)
		sleep(1)
		channel_unblock(user, chat)
	elseif is_chat then
		kick_user(user, chat)
	end
end
function Tabchi(msg)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	local chat = msg.to.id
	local user = msg.from.id
	local is_channel = msg.to.type == "channel"
	local hashwarn = chat..':warntabchi'
	local warnhash = redis:hget(RedisIndex..hashwarn, user) or 1
	local max_warn = tonumber(redis:get(RedisIndex..'max_warn_tabchi:'..chat) or 2)
	if is_channel then
		del_msg(chat, tonumber(msg.id))
		if tonumber(warnhash) == tonumber(max_warn) then
			tdbot.sendMessage(msg.chat_id, msg.id, 1, Source_Start.."*کاربر* `"..user.."` - @"..check_markdown(msg.from.username or msg.from.first_name).." *تبچی شناسای شد و از گروه محروم شد*"..EndMsg, 1, 'md')
			if redis:get(RedisIndex.."delbot"..msg.chat_id) then
				redis:set(RedisIndex.."delbotcheck"..msg.chat_id, true)
			end
			kick_user(user, chat)
			redis:hdel(RedisIndex..hashwarn, user, '0')
		else
			redis:hset(RedisIndex..hashwarn, user, tonumber(warnhash) + 1)
			if redis:get(RedisIndex.."BoTMode") == "CliMode" then
				if redis:get(RedisIndex.."TabchiUsername:"..chat) then
					redis:del(RedisIndex.."TabchiUsername:"..chat)
				end
				if redis:get(RedisIndex.."TabchiUserId:"..chat) then
					redis:del(RedisIndex.."TabchiUserId:"..chat)
				end
				local function inline_query_cb(arg, data)
					if data.results and data.results[0] then
						tdbot.sendInlineQueryResultMessage(msg.chat_id, msg.id, 0, 1, data.inline_query_id, data.results[0].id, dl_cb, nil)
					end
				end
				redis:set(RedisIndex.."TabchiUsername:"..chat, msg.from.username or msg.from.first_name)
				redis:set(RedisIndex.."TabchiUserId:"..chat, user)
				tdbot.getInlineQueryResults(Bot_idapi, msg.chat_id, 0, 0, "Tabchi:"..msg.chat_id, 0, inline_query_cb, nil)
			end
		end
	end
end
function Msg_checks(msg)
	local Emoji = {"↫ ","⇜ ","⌯ ","↜ "}
	local Source_Start = Emoji[math.random(#Emoji)]
	local chat = msg.to.id
	local user = msg.from.id
	local is_channel = msg.to.type == "channel"
	local is_chat = msg.to.type == "chat"
	if msg.text then
	if redis:get(RedisIndex.."JoinChPub:"..msg.chat_id) then
		JoinChannelPub(msg)
	end
	if not redis:get(RedisIndex.."CheckBot:"..msg.to.id) and not redis:get(RedisIndex..'auto_leave_bot') and not is_admin(msg) and msg.to.type == "channel" and not msg.is_post then
		tdbot.sendMessage(msg.to.id, "", 0, Source_Start.."*این گروه در لیست گروه های ربات ثبت نشده است !*\n`برای خرید ربات و اطلاعات بیشتر به ایدی زیر مراجعه کنید.`"..EndMsg.."\n\n"..check_markdown(sudo_username).."", 0, "md")
		tdbot.changeChatMemberStatus(chat, our_id, 'Left', dl_cb, nil)
	end
	end
	if not redis:get(RedisIndex..'autodeltime') then
		redis:setex(RedisIndex..'autodeltime', 14400, true)
		run_bash("rm -rf ~/.telegram-bot/main/data/stickers/*")
		run_bash("rm -rf ~/.telegram-bot/main/files/photos/*")
		run_bash("rm -rf ~/.telegram-bot/main/files/animations/*")
		run_bash("rm -rf ~/.telegram-bot/main/files/videos/*")
		run_bash("rm -rf ~/.telegram-bot/main/files/music/*")
		run_bash("rm -rf ~/.telegram-bot/main/files/voice/*")
		run_bash("rm -rf ~/.telegram-bot/main/files/temp/*")
		run_bash("rm -rf ~/.telegram-bot/main/data/temp/*")
		run_bash("rm -rf ~/.telegram-bot/main/files/documents/*")
		run_bash("rm -rf ~/.telegram-bot/main/data/profile_photos/*")
		run_bash("rm -rf ~/.telegram-bot/main/files/video_notes/*")
		run_bash("rm -rf ./Download/*")
	end
	if is_channel or is_chat then
		lock_link = redis:get(RedisIndex..'lock_link:'..msg.chat_id)
		lock_join = redis:get(RedisIndex..'lock_join:'..msg.chat_id)
		lock_tag = redis:get(RedisIndex..'lock_tag:'..msg.chat_id)
		lock_username = redis:get(RedisIndex..'lock_username:'..msg.chat_id)
		lock_pin = redis:get(RedisIndex..'lock_pin:'..msg.chat_id)
		lock_arabic = redis:get(RedisIndex..'lock_arabic:'..msg.chat_id)
		lock_english = redis:get(RedisIndex..'lock_english:'..msg.chat_id)
		lock_mention = redis:get(RedisIndex..'lock_mention:'..msg.chat_id)
		lock_edit = redis:get(RedisIndex..'lock_edit:'..msg.chat_id)
		lock_spam = redis:get(RedisIndex..'lock_spam:'..msg.chat_id)
		lock_flood = redis:get(RedisIndex..'lock_flood:'..msg.chat_id)
		lock_markdown = redis:get(RedisIndex..'lock_markdown:'..msg.chat_id)
		lock_webpage = redis:get(RedisIndex..'lock_webpage:'..msg.chat_id)
		lock_welcome = redis:get(RedisIndex..'welcome:'..msg.chat_id)
		lock_views = redis:get(RedisIndex..'lock_views:'..msg.chat_id)
		lock_bots = redis:get(RedisIndex..'lock_bots:'..msg.chat_id)
		lock_tabchi = redis:get(RedisIndex..'lock_tabchi:'..msg.chat_id)
		mute_all = redis:get(RedisIndex..'mute_all:'..msg.chat_id)
		mute_gif = redis:get(RedisIndex..'mute_gif:'..msg.chat_id)
		mute_photo = redis:get(RedisIndex..'mute_photo:'..msg.chat_id)
		mute_sticker = redis:get(RedisIndex..'mute_sticker:'..msg.chat_id)
		mute_contact = redis:get(RedisIndex..'mute_contact:'..msg.chat_id)
		mute_inline = redis:get(RedisIndex..'mute_inline:'..msg.chat_id)
		mute_game = redis:get(RedisIndex..'mute_game:'..msg.chat_id)
		mute_text = redis:get(RedisIndex..'mute_text:'..msg.chat_id)
		mute_keyboard = redis:get(RedisIndex..'mute_keyboard:'..msg.chat_id)
		mute_forward = redis:get(RedisIndex..'mute_forward:'..msg.chat_id)
		mute_forwarduser = redis:get(RedisIndex..'mute_forwarduser:'..msg.chat_id)
		mute_location = redis:get(RedisIndex..'mute_location:'..msg.chat_id)
		mute_document = redis:get(RedisIndex..'mute_document:'..msg.chat_id)
		mute_voice = redis:get(RedisIndex..'mute_voice:'..msg.chat_id)
		mute_audio = redis:get(RedisIndex..'mute_audio:'..msg.chat_id)
		mute_video = redis:get(RedisIndex..'mute_video:'..msg.chat_id)
		mute_video_note = redis:get(RedisIndex..'mute_video_note:'..msg.chat_id)
		mute_tgservice = redis:get(RedisIndex..'mute_tgservice:'..msg.chat_id)
		if msg.adduser or msg.joinuser or msg.deluser then
			if mute_tgservice == 'Enable' then
				del_msg(chat, tonumber(msg.id))
			end
		end
		if not is_mod(msg) and not is_whitelist(msg.from.id, msg.to.id) and msg.from.id ~= our_id then
			if msg.adduser or msg.joinuser then
				if lock_join == 'Enable' then
					function join_kick(arg, data)
						kick_user(data.id, msg.to.id)
					end
					if msg.adduser then
						tdbot.getUser(msg.adduser, join_kick, nil)
					elseif msg.joinuser then
						tdbot.getUser(msg.joinuser, join_kick, nil)
					end
				end
			end
		end
		if msg.pinned and is_channel then
			if lock_pin == 'Enable' then
				if is_owner(msg) then
					return
				end
				if tonumber(msg.from.id) == our_id then
					return
				end
				local pin_msg = redis:get(RedisIndex..'pin_msg'..msg.chat_id)
				if pin_msg then
					tdbot.pinChannelMessage(msg.to.id, pin_msg, 1, dl_cb, nil)
				elseif not pin_msg then
					tdbot.unpinChannelMessage(msg.to.id, dl_cb, nil)
					redis:del(RedisIndex..'pin_msg'..msg.chat_id)
				end
				tdbot.sendMessage(msg.to.id, msg.id, 0, Source_Start..'*آیدی کاربر :* `'..msg.from.id..'`\n*نام کاربری :* @'..check_markdown(msg.from.username or '')..'\n`شما اجازه دسترسی به سنجاق پیام را ندارید، به همین دلیل پیام قبلی مجدد سنجاق میگردد`'..EndMsg, 0, "md")
			end
		end
		if not is_mod(msg) and not is_whitelist(msg.from.id, msg.to.id) and msg.from.id ~= our_id then
			if redis:get(RedisIndex..'Lock_Gp:'..msg.to.id) then
				Delall(msg)
			end
			if msg.edited then
				if lock_edit == 'Enable' then Delall(msg) elseif lock_edit == 'Warn' then Warnall(msg,"ویرایش") elseif lock_edit == 'Mute' then Silentall(msg,"ویرایش") elseif lock_edit == 'Kick' then Kickall(msg,"ویرایش") end
			end
			if msg.views ~= 0 then
				if lock_views == 'Enable' then Delall(msg) elseif lock_views == 'Warn' then Warnall(msg,"ویو") elseif lock_views == 'Mute' then Silentall(msg,"ویو") elseif lock_views == 'Kick' then Kickall(msg,"ویو") end
			end
			if msg.fwd_from_channel then
				if mute_forward == 'Enable' then Delall(msg) elseif mute_forward == 'Warn' then Warnall(msg,"فوروارد کانال") elseif mute_forward == 'Mute' then Silentall(msg,"فوروارد کانال") elseif mute_forward == 'Kick' then Kickall(msg,"فوروارد کانال") end
			end
			if msg.fwd_from_user then
				if mute_forwarduser == 'Enable' then Delall(msg) elseif mute_forwarduser == 'Warn' then Warnall(msg,"فوروارد کاربر") elseif mute_forwarduser == 'Mute' then Silentall(msg,"فوروارد کاربر") elseif mute_forwarduser == 'Kick' then Kickall(msg,"فوروارد کاربر") end
			end
			if msg.fwd_from_user or msg.fwd_from_channel then
				if lock_tabchi == 'Enable' then
					Tabchi(msg)
				end
			end
			if msg.photo then
				if mute_photo == 'Enable' then Delall(msg) elseif mute_photo == 'Warn' then Warnall(msg,"عکس") elseif mute_photo == 'Mute' then Silentall(msg,"عکس") elseif mute_photo == 'Kick' then Kickall(msg,"عکس") end
			end
			if msg.video then
				if mute_video == 'Enable' then Delall(msg) elseif mute_video == 'Warn' then Warnall(msg,"فیلم") elseif mute_video == 'Mute' then Silentall(msg,"فیلم") elseif mute_video == 'Kick' then Kickall(msg,"فیلم") end
			end
			if msg.video_note then
				if mute_video_note == 'Enable' then Delall(msg) elseif mute_video_note == 'Warn' then Warnall(msg,"فیلم سلفی") elseif mute_video_note == 'Mute' then Silentall(msg,"فیلم سلفی") elseif mute_video_note == 'Kick' then Kickall(msg,"فیلم سلفی") end
			end
			if msg.document then
				if mute_document == 'Enable' then Delall(msg) elseif mute_document == 'Warn' then Warnall(msg,"فایل") elseif mute_document == 'Mute' then Silentall(msg,"فایل") elseif mute_document == 'Kick' then Kickall(msg,"فایل") end
			end
			if msg.sticker then
				if mute_sticker == 'Enable' then Delall(msg) elseif mute_sticker == 'Warn' then Warnall(msg,"استیکر") elseif mute_sticker == 'Mute' then Silentall(msg,"استیکر") elseif mute_sticker == 'Kick' then Kickall(msg,"استیکر") end
			end
			if msg.animation then
				if mute_gif == 'Enable' then Delall(msg) elseif mute_gif == 'Warn' then Warnall(msg,"گیف") elseif mute_gif == 'Mute' then Silentall(msg,"گیف") elseif mute_gif == 'Kick' then Kickall(msg,"گیف") end
			end
			if msg.contact then
				if mute_contact == 'Enable' then Delall(msg) elseif mute_contact == 'Warn' then Warnall(msg,"مخاطب") elseif mute_contact == 'Mute' then Silentall(msg,"مخاطب") elseif mute_contact == 'Kick' then Kickall(msg,"مخاطب") end
			end
			if msg.location then
				if mute_location == 'Enable' then Delall(msg) elseif mute_location == 'Warn' then Warnall(msg,"موقعیت مکانی") elseif mute_location == 'Mute' then Silentall(msg,"موقعیت مکانی") elseif mute_location == 'Kick' then Kickall(msg,"موقعیت مکانی") end
			end
			if msg.voice then
				if mute_voice == 'Enable' then Delall(msg) elseif mute_voice == 'Warn' then Warnall(msg,"ویس") elseif mute_voice == 'Mute' then Silentall(msg,"ویس") elseif mute_voice == 'Kick' then Kickall(msg,"ویس") end
			end
			if msg.content then
				if msg.reply_markup and  msg.reply_markup._ == "replyMarkupInlineKeyboard" then
					if mute_keyboard == 'Enable' then Delall(msg) elseif  mute_keyboard == 'Warn' then Warnall(msg,"کیبورد شیشه ای") elseif  mute_keyboard == 'Mute' then Silentall(msg,"کیبورد شیشه ای") elseif  mute_keyboard == 'Kick' then Kickall(msg,"کیبورد شیشه ای") end
				end
			end
			if tonumber(msg.via_bot_user_id) ~= 0 then
				if mute_inline == 'Enable' then Delall(msg) elseif mute_inline == 'Warn' then Warnall(msg,"دکمه شیشه ای") elseif mute_inline == 'Mute' then Silentall(msg,"دکمه شیشه ای") elseif mute_inline == 'Kick' then Kickall(msg,"دکمه شیشه ای") end
			end
			if msg.game then
				if mute_game == 'Enable' then Delall(msg) elseif mute_game == 'Warn' then Warnall(msg,"بازی") elseif mute_game == 'Mute' then Silentall(msg,"بازی") elseif mute_game == 'Kick' then Kickall(msg,"بازی") end
			end
			if msg.audio then
				if mute_audio == 'Enable' then Delall(msg) elseif mute_audio == 'Warn' then Warnall(msg,"آهنگ") elseif mute_audio == 'Mute' then Silentall(msg,"آهنگ") elseif mute_audio == 'Kick' then Kickall(msg,"آهنگ") end
			end
			if msg.media.caption then
				local link_caption = msg.media.caption:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or msg.media.caption:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or msg.media.caption:match("[Tt].[Mm][Ee]/") or msg.media.caption:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/")
				if link_caption and lock_link == 'Enable' then Delall(msg) elseif link_caption and lock_link == 'Warn' then Warnall(msg,"لینک") elseif link_caption and lock_link == 'Mute' then Silentall(msg,"لینک") elseif link_caption and lock_link == 'Kick' then Kickall(msg,"لینک") end
				local tag_caption = msg.media.caption:match("#")
				if tag_caption then
					if lock_tag == 'Enable' then Delall(msg) elseif lock_tag == 'Warn' then Warnall(msg,"تگ") elseif lock_tag == 'Mute' then Silentall(msg,"تگ") elseif lock_tag == 'Kick' then Kickall(msg,"تگ") end
				end
				local username_caption = msg.media.caption:match("@")
				if username_caption then
					if lock_username == 'Enable' then Delall(msg) elseif lock_username == 'Warn' then Warnall(msg,"تگ") elseif lock_username == 'Mute' then Silentall(msg,"تگ") elseif lock_username == 'Kick' then Kickall(msg,"تگ") end
				end
				if is_filter(msg, msg.media.caption) then
					Delall(msg)
				end
				local arabic_caption = msg.media.caption:match("[\216-\219][\128-\191]")
				if arabic_caption then
					if lock_arabic == 'Enable' then Delall(msg) elseif lock_arabic == 'Warn' then Warnall(msg,"فارسی") elseif lock_arabic == 'Mute' then Silentall(msg,"فارسی") elseif lock_arabic == 'Kick' then Kickall(msg,"فارسی") end
				end
				local english_caption = msg.media.caption:match("[A-Z]") or msg.media.caption:match("[a-z]")
				if english_caption then
					if lock_english == 'Enable' then Delall(msg) elseif lock_english == 'Warn' then Warnall(msg,"انگلیسی") elseif lock_english == 'Mute' then Silentall(msg,"انگلیسی") elseif lock_english == 'Kick' then Kickall(msg,"انگلیسی") end
				end
			end
			if msg.text and redis:get(RedisIndex.."CheckBot:"..msg.to.id) then
				local _nl, ctrl_chars = string.gsub(text, "%c", "")
				local _nl, real_digits = string.gsub(text, "%d", "")
				if not redis:get(RedisIndex..msg.to.id..'set_char') then
					sens = 4080
				else
					sens = tonumber(redis:get(RedisIndex..msg.to.id..'set_char'))
				end
				if lock_spam == 'Enable' then
					if  string.len(msg.text) > sens or ctrl_chars > sens or real_digits > sens then
						Delall(msg)
					end
				end
				local link_msg = msg.text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or msg.text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or msg.text:match("[Tt].[Mm][Ee]/") or msg.text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/")
				if link_msg then
					if lock_link == 'Enable' then Delall(msg) elseif lock_link == 'Warn' then Warnall(msg,"لینک") elseif lock_link == 'Mute' then Silentall(msg,"لینک") elseif lock_link == 'Kick' then Kickall(msg,"لینک") end
				end
				local tag_msg = msg.text:match("#")
				if tag_msg then
					if lock_tag == 'Enable' then Delall(msg) elseif lock_tag == 'Warn' then Warnall(msg,"تگ") elseif lock_tag == 'Mute' then Silentall(msg,"تگ") elseif lock_tag == 'Kick' then Kickall(msg,"تگ") end
				end
				local username_msg = msg.text:match("@")
				if username_msg then
					if lock_username == 'Enable' then Delall(msg) elseif lock_username == 'Warn' then Warnall(msg,"نام کاربری") elseif lock_username == 'Mute' then Silentall(msg,"نام کاربری") elseif lock_username == 'Kick' then Kickall(msg,"نام کاربری") end
				end
				if is_filter(msg, msg.text) then
					Delall(msg)
				end
				local arabic_msg = msg.text:match("[\216-\219][\128-\191]")
				if arabic_msg then
					if lock_arabic == 'Enable' then Delall(msg) elseif lock_arabic == 'Warn' then Warnall(msg,"فارسی") elseif lock_arabic == 'Mute' then Silentall(msg,"فارسی") elseif lock_arabic == 'Kick' then Kickall(msg,"فارسی") end
				end
				local english_msg = msg.text:match("[A-Z]") or msg.text:match("[a-z]")
				if english_msg then
					if lock_english == 'Enable' then Delall(msg) elseif lock_english == 'Warn' then Warnall(msg,"انگلیسی") elseif lock_english == 'Mute' then Silentall(msg,"انگلیسی") elseif lock_english == 'Kick' then Kickall(msg,"انگلیسی") end
				end
				if msg.text:match("(.*)") then
					if mute_text == 'Enable'  then Delall(msg) elseif mute_text == 'Warn' then Warnall(msg,"متن") elseif mute_text == 'Mute' then Silentall(msg,"متن") elseif mute_text == 'Kick' then Kickall(msg,"متن") end
				end
			end
			if mute_all == 'Enable' then
				Delall(msg)
			end
			if msg.content and msg.content.entities then
				for k,entity in pairs(msg.content.entities) do
					if entity.type._ == "textEntityTypeMentionName" then
						if lock_mention == 'Enable' then Delall(msg) elseif lock_mention == 'Warn' then Warnall(msg,"منشن") elseif lock_mention == 'Mute' then Silentall(msg,"منشن") elseif lock_mention == 'Kick' then Kickall(msg,"منشن") end
					end
					if entity.type._ == "textEntityTypeUrl" or entity.type._ == "textEntityTypeTextUrl" then
						if lock_webpage == 'Enable' then Delall(msg) elseif lock_webpage == 'Warn' then Warnall(msg,"سایت") elseif lock_webpage == 'Mute' then Silentall(msg,"سایت") elseif lock_webpage == 'Kick' then Kickall(msg,"سایت") end
					end
					if msg.content and entity.type._ == "textEntityTypeBold" or entity.type._ == "textEntityTypeCode" or entity.type._ == "textEntityTypePre" or entity.type._ == "textEntityTypeItalic" then
						if lock_markdown == 'Enable' then Delall(msg) elseif lock_markdown == 'Warn' then Warnall(msg,"فونت") elseif lock_markdown == 'Mute' then Silentall(msg,"فونت") elseif lock_markdown == 'Kick' then Kickall(msg,"فونت") end
					end
				end
			end
			if msg.to.type ~= 'pv' then
				if lock_flood == 'Enable' and not is_mod(msg) and not is_whitelist(msg.from.id, msg.to.id) and not msg.adduser and msg.from.id ~= our_id then
					TIME_CHECK = redis:get(RedisIndex..msg.to.id..'time_check') or 2
					local hash = 'user:'..user..':msgs'
					local msgs = tonumber(redis:get(RedisIndex..hash) or 0)
					local NUM_MSG_MAX = tonumber(redis:get(RedisIndex..msg.to.id..'num_msg_max') or 5)
					if msgs > NUM_MSG_MAX then
						if msg.from.username then
							user_name = "@"..msg.from.username
						else
							user_name = msg.from.first_name
						end
						if redis:get(RedisIndex..'sender:'..user..':flood') then
							return
						else
							local floodmod = redis:get(RedisIndex..msg.to.id..'floodmod')
							if floodmod == "Mute" then
								del_msg(chat, msg.id)
								tdbot.deleteMessagesFromUser(msg.to.id,  user)
								silent_user(chat, user)
								tdbot.sendMessage(chat, msg.id, 0, Source_Start.."*کاربر* `"..user.."` - "..user_name.." *به دلیل ارسال پیام های مکرر سکوت شد*"..EndMsg, 0, "md")
								if redis:get(RedisIndex.."delbot"..msg.chat_id) then
									redis:set(RedisIndex.."delbotcheck"..msg.chat_id, true)
								end
								redis:setex(RedisIndex..'sender:'..user..':flood', 30, true)
							else
								kick_user(user, chat)
								tdbot.deleteMessagesFromUser(msg.to.id,  user)
								tdbot.sendMessage(chat, msg.id, 0, Source_Start.."*کاربر* `"..user.."` - "..user_name.." *به دلیل ارسال پیام های مکرر اخراج شد*"..EndMsg, 0, "md")
								if redis:get(RedisIndex.."delbot"..msg.chat_id) then
									redis:set(RedisIndex.."delbotcheck"..msg.chat_id, true)
								end
								redis:setex(RedisIndex..'sender:'..user..':flood', 30, true)
							end
						end
					end
					redis:setex(RedisIndex..hash, TIME_CHECK, msgs+1)
				end
			end
		end
	end
end
FonTfa = {
"ضَِ,صَِ,قَِ,فَِ,غَِ,عَِ,هَِ,خَِ,حَِـَِ,جَِ,شَِـَِ,سَِــَِ,یَِ,بَِ,لَِ,اَِ,نَِ,تَِـ,مَِــَِ,چَِ,ظَِ,طَِ,زَِ,رَِ,دَِ,پَِـَِـ,وَِ,ڪَِــ,گَِــ,ثَِ,ژَِ,ذَِ,آ,ئَِ,.,_",
"ۘۘضــ, ۘۘصـ, ۘۘقـ, ۘۘفـ, ۘۘغـ, ۘۘعـ, ۘۘهـ, ۘۘخـ, ۘۘحـ, ۘۘجـ, ۘۘشـ,ۘۘسـ, ۘۘیـ, ۘۘبـ, ۘۘلـ, ۘۘا, ۘۘنـ, ۘۘتـ, ۘۘمـ, ۘۘچـ, ۘۘظـ, ۘۘطـ,ۘۘز, ۘۘر, ۘۘد, ۘۘپـ, ۘۘو, ۘۘڪـ, ۘۘگـ, ۘۘثـ, ۘۘژ, ۘۘذ, ۘۘآ, ۘۘئـ,.___",
"ضَِـٖٖـۘۘـُِ,صَِـُّ℘ـʘ͜͡,قـٖٖـۘۘـ,فـٖٖـۘۘـُِ,غَِـُّ℘ـʘ͜͡,عـٖٖـۘۘـ,هَِـٖٖـۘۘـُِ,خَِـَّ℘ـʘ͜͡,حـٖٖـۘۘـ,جـٖٖـۘۘـُِ,شَِـُّ℘ـʘ͜͡,سَـٖٖـۘۘـ,یـٖٖـۘۘـُِ,بَـَّ℘ـʘ͜͡,لـٖٖـۘۘـ,اۘۘ,نِّـُّ℘ـʘ͜͡,تَـٖٖـۘۘـ,مُِـٖٖـۘۘـُِ,چٍّـََ℘ـʘ͜͡,ظُّـٖٖـۘۘـ,طِّـٖٖـۘۘـُِ,‌زُِ,رُِ,دَّ,پـٖٖـۘۘـ,وّ,کُّـٖٖـۘۘـُِ,گـ℘ـʘ͜͡,ثَـٖٖـۘۘـ,ژ,ذُّ,℘آ,ئـٖٖـۘۘـ,.,_",
"ضــ,صــ,قــ,فــ,غــ,عــ,هــ,خــ,حــ,جــ,شــ,ســ,یـــ,بـــ,لــ,ا',نـــ,تـــ,مـــ,چــ,ظــ,طــ,زّ,رّ,دّ,پــ,,وّ,کــ,گــ,ثــ,ژّ,ذّ,آ,ئــ,.,_",
"ضـَِـٖٖـ,صۘۘـُِـ℘ـʘ͜͡,قٖٖ ,فۘۘـُِـٖٖـۘۘـُِـ,غِِ  ,عِّـِّـۘۘـُِـ,هََ,❢خــًٍـْْـ,حْْـــْْـ,جًٍــْْـ❢,شََـََـََـََـََ,سََـََـََـََـََ,یََ,بََـــْْــََ❅,لََــََـََــ,ا',ݩ,تـެـެِэٖٖ‍ٖٖ‍ٖٖ‍ٖٖ‍ٖٖـ,مٖٖــٍ͜ـۘۘــ,چۘۘـِ؁,ظٖٖــۘۘـ,طۘۘـُِـۘۘ,ز',়ر',دۘۘـ, پـِّ؁,وَِ,ڪـًّ,ِ؁,گٖٖــٍ͜ـۘۘــ,ثۘۘـِ؁,'ژ',ذ'ً,ًّ,়়آ,়়ئّّ'',.,_",
"ضَِـٖٖـۘۘـُِ,صَِـُّ℘ـʘ͜͡,قـٖٖـۘۘـ,فـٖٖـۘۘـُِ,غَِـُّ℘ـʘ͜͡,عـٖٖـۘۘـ,هَِـٖٖـۘۘـُِ,خَِـَّ℘ـʘ͜͡,حـٖٖـۘۘـ,جـٖٖـۘۘـُِ,شَِـُّ℘ـʘ͜͡,سَـٖٖـۘۘـ,یـٖٖـۘۘـُِ,بَـَّ℘ـʘ͜͡,لـٖٖـۘۘـ,اۘۘ,نِّـُّ℘ـʘ͜͡,تَـٖٖـۘۘـ,مُِـٖٖـۘۘـُِ,چٍّـََ℘ـʘ͜͡,ظُّـٖٖـۘۘـ,طِّـٖٖـۘۘـُِ,‌زُِ,رُِ,دَّ,پـٖٖـۘۘـ,وّ,کُّـٖٖـۘۘـُِ,گـ℘ـʘ͜͡,ثَـٖٖـۘۘـ,ژ,ذُّ,℘آ,ئـٖٖـۘۘـ,.,_",
"ض̈́ـ̈́ـ̈́ـ̈́ـ,ص̈́ـ̈́ـ̈́ـ̈́ـ,قـ̈́ـ̈́ـ̈́ـ,فـ̈́ـ̈́ـ̈́ـ̈́ـ,غ̈́ـ̈́ـ̈́ـ̈́ـ,ع̈́ـ̈́ـ̈́ـ̈́ـ,ه̈́ـ̈́ـ̈́ـ̈́ـ,خـ̈́ـ̈́ـ̈́ـ,ح̈́ـ̈́ـ̈́ـ̈́ـ,ج̈́ـ̈́ـ̈́ـ̈́ـ,شـ̈́ـ̈́ـ̈́ـ,سـ̈́ـ̈́ـ̈́ـ,ی̈́ـ̈́ـ̈́ـ̈́ـ,ب̈́ـ̈́ـ̈́ـ̈́ـ,ل̈́ـ̈́ـ̈́ـ̈́ـ,̈́ا,ن̈́ـ̈́ـ̈́ـ̈́ـ,ت̈́ـ̈́ـ̈́ـ̈́ـ,م̈́ـ̈́ـ̈́ـ̈́ـ,چـ̈́ـ̈́ـ̈́ـ,ظـ̈́ـ̈́ـ̈́ـ̈́ـ,ط̈́ـ̈́ـ̈́ـ̈́ـ,ز',ر',د',پ̈́ـ̈́ـ̈́ـ̈́ـ,̈́̈́و,کـ̈́ـ̈́ـ̈́ـ,گـ̈́ـ̈́ـ̈́ـ̈́ـ,ث̈́ـ̈́ـ̈́ـ̈́ـ,̈́ژ',ذ',آ',ئ̈́ـ̈́ـ̈́ـ,.,__",
"ضـٜٜـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜـٜ٘ـٍٍʘ͜͡ʘ͜͡ـٍٜ,ص۪۪ـؔٛـؒؔـ۪۪,ـقـ۪۪ـؒؔـ۪۪ـৃَـ,ـ؋ـ,غ,عـْْـْْـْْ✮ْْ,ه,ـפֿـ,ـפـ,جـٜ۪✶ًً◌,ش,ـωـ,ےٖٖ•,ب, لـؒؔـؒؔ℘,↭ٖٓا,نـ۪ٞ,تـ۪۪ـؒؔـ۪۪ـِْ,مـٰٰـٰٰ,چ,ظ,ط,ز✶ًً◌,ر√,ــدٍٕ,پـٜٜـٍٍـٜٜ℘͡ـٜٜ✮,ـפּـ,ڪ,❆گـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,ث,ژ^°√,ذ,آ,ئ,.,___",
"ِ↲ضـூ͜͡,صـۡۙـُُـ़,قـ്͜ــ,◌فــ͜͡ـ☆͜͡➬,غـٖٖـ,✞ٜ۪ـٜ۪ع,ـެِэٖٖ‍ٖٖ‍ٖٖ‍ٖٖ‍ٖٖهٖٖ,خـံີـؒؔ,حــٌ۝ؔؑـެِэٖٖ‍ٖٖ‍ٖ,جـَ͜❁,ــ͜͡ـشـ☆͜͡,سـٖٖـــ,يٰٰـٰٰـٰٰـ, ٰٰبـًٍ,لٜ۪ـٜ۪,ံີا,ެِэٖٖ‍ٖٖ‍ٖٖ‍ٖٖ‍ٖٖـݩ,تـََـََـََـ,مـؒؔ◌͜͡ࢪ,ـچـٌ۝ؔؑ,ظًّـެِэٖٖ‍ٖٖ‍ٖٖ‍ٖٖ‍ٖٖ,طٌِـٌ۝ؔؑ,ٖٖزံີ,ࢪ,ـَ͜د,پـٜٜـٜٓـٜٜـٜٓـٜٜـٜٜـٜٜـ,ۋ℘,ڪـٰٖـٰٰـٜٜـٜٓـٜٓـٜٓـٜٜ,گـٖٖـٖٖ,ثـؒؔ◌,ٌ۝ؔؑژِэٖٖ‍ٖٖ‍ٖٖ,ـْٜـذ,❀آ,ئٰٰـٰٰـًٍ,.,__",
"ضـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,صـٜ٘ـٍٜـٜۘـٜۘـٍٍـٜٜ,قـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,فـٜ٘ـٍٜـٜۘـٜۘـٍٍـٜٜ,غٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ, ٍٍ‍ٍٍعٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,ٍٍ‍ٍٍهٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,خـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,حـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,جـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,شـٜ٘ـٍٜـٜۘـٜۘـٍٍـٜٜ,سـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ, ًًیَِـََـََـََـَِ, بـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ, ًًلٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,ا', ًنََـٍٍـٜٜـٜۘـٜٓـٍٜ,تـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,مـٜ٘ـٍٜـٜۘـٜۘـٍٍـٜٜ,چـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,ظـٜ٘ـٍٜـٜۘـٜۘـٍٍـٜٜ,طـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,''ز,ر',  ًًد'', پـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,وٍٍ‍ٍ‍‍‍ ,ڪـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,گـٜ٘ـٍٜـٜۘـٜۘـٍٍـٜٜ,ثـٜ٘ـٍٜـٜۘـٜۘـٍٍـٜٜ,ًژ,ََذ,❢آ''',ئـٜٜـٍٍـٜٜـٜۘـٜٓـ,.,__",
"ضـ﹏ـ,صـ﹏ــ,قـ﹏ـ,فـ﹏ـ,غـ﹏ـ,عـ﹏ـ,هـ﹏ـ,خـ﹏ـ,حـ﹏ـ,جـ﹏ــ,شـ﹏ـ,سـ﹏ـ,یـ﹏ـ,بـ﹏ـ,لـ﹏ــ,ا',نـ﹏ـ,تـ﹏ـ,مـ﹏ـ,چـ﹏ـ,ظـ﹏ــ,طـ﹏ـ,ز,ر,د,پـ﹏ـ,و,کـ﹏ـ,گـ﹏ـ,ثـ﹏ــ,ژ,ذ,آ,ئـ﹏ــ,.,_",
"ضـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,صـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,قـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ‌,فـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,غـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,عـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ‌,هـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,خـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,حـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ‌,جـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,شـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,سـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ‌,یـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,بـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,لـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ‌,ا',نـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,تـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,مـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ‌,چـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,ظـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,طـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ‌,ز۪ٜ‌,ر۪ٜ,د۪ٜ,پـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,و',کـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,گـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ‌,ثـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,ژ۪ٜ,ذ۪ٜ,آ,ئـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,.,_",
"়়ضًَـ়ৃ,صَৃـ,়ۘـقٍٰـۘۘ,فََـۘۘ✾ُُ:,◌͜͡غ, عَؔـٍٍʘ͜͡ʘ,هـَ͜❁ٜ۪,خـِِ✿ٰٰ‌,حـٖٖ℘ـ,جـؒؔـؔؔـٖٖـؔـ,شـٜٜـٜٓـٜٜـٜٓـٜٜـٜٜـٜٜـ,سـٰٖـٰٰـٜٜـٜٓـٜٓـٜٓـٜٜـ,ـےٍٕ,بـــ✄ــ,ل҉ ـ,ٰံاًّ,۪۪نـ↭ٰٰـ۪۪,تـَ͜❁ٜ۪ـ,مــؒؔ✫ؒؔـ ҉๏̯̃๏ًٍ,چۘۘـ ۪۪ـٰٰـ,ظـؒؔـؔؔـٖٖـؔـ ــ,طُّـۘۘ↭,✵͜͡ز,رؒؔ◌͜͡◌,َؔد,پّـꯩ้ี,ٰۘوٰٖ,کـ͜͝ـ͜͝ـ,گـ͜͝ـ͜͝ـ,ث͜͝ـ❁۠۠ـ͜͝ـ۪ٜـ۪ٜ❀͜͡ـ,ژؒؔ❁,ـٜٜـٜٓـٜٜـٜٓـٜٜـٜٜـٜٜذ,✺آٍጀ,ٍጀئ,.__",
"ض✿ٰٰ‌✰ض۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,صـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,قـٍٍ℘͡ـٜٜ,فـَ͜ـ,غـَ͜✾ٖٖ,عुؔـ,℘͡ـهٜुـ,خـَ͜✾ٖٖ,ح͡ـٜٜ,ـجٍٍ℘,شـٖٖ,سـۘۘـُِ℘ـʘ͜,یـٖٖـۘۘـٖٖ,✺ًّ‏َؔب,,لۣۗـًٍـٍَـ,ٍٓ‍ؒؔا,ـنـؔؔ‌ؒؔ,ؒؔ✺تًّ‏َؔ«ۣۗ,مـٍَـٍٓ‍ؒؔـ۪۪ـؔؔ‌ؒؔـؒؔـؒؔـؒؔ,چـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜـ۪ٜ,ظ۪ٜ,ـ۪ٜط۪ٜـ۪ٜـ۪ٜ,ز۪ٜ,ر௸,ـدؒؔ,پِـَِـَِـَِـَِـَِـَِـَِـَ,◌͜͡و◌,ڪـَ͜✾ٖٖ,گٍٖـْْ❥ٍٍـٍٍ,ثْْـٍٍ,ژُُ,ـَ͜ذ,﷽آ,ئ҉ــ҉ۘۘ,ٓٓ,,ـَ͜,,.,__",
"ضـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,صـٜ٘ـٍٜـٜۘـٜۘـٍٍـٜٜ,قـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,فـٜ٘ـٍٜـٜۘـٜۘـٍٍـٜٜ,غٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ, ٍٍ‍ٍٍعٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,ٍٍ‍ٍٍهٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,خـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,حـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,جـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,شـٜ٘ـٍٜـٜۘـٜۘـٍٍـٜٜ,سـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ, ًًیَِـََـََـََـَِ, بـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ, ًًلٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,ا', ًنََـٍٍـٜٜـٜۘـٜٓـٍٜ,تـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,مـٜ٘ـٍٜـٜۘـٜۘـٍٍـٜٜ,چـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,ظـٜ٘ـٍٜـٜۘـٜۘـٍٍـٜٜ,طـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,''ز,ر',  ًًد'', پـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,وٍٍ‍ٍ‍‍‍ ,ڪـٜٜـٍٍـٜٜـٜۘـٜٓـٍٜ,گـٜ٘ـٍٜـٜۘـٜۘـٍٍـٜٜ,ثـٜ٘ـٍٜـٜۘـٜۘـٍٍـٜٜ,ًژ,ََذ,❢آ''',ئـٜٜـٍٍـٜٜـٜۘـٜٓـ,.,__",
"ضٖٖـۘۘ℘ـʘ͜͡,صـٖٖـۘۘ℘ـʘ͜͡,قـٖٖـۘۘ℘ـʘ͜͡,فـٖٖـۘۘ℘ـʘ͜͡,غـٖٖـۘۘ℘ـʘ͜͡,عـٖٖـۘۘ℘ـʘ͜͡,هـٖٖـۘۘ℘ـʘ͜͡,خـٖٖـۘۘ℘ـʘ͜͡,حـٖٖـۘۘ℘ـʘ͜͡,جـٖٖـۘۘ℘ـʘ͜͡,شـٖٖـۘۘ℘ـʘ͜͡,سـٖٖـۘۘ℘ـʘ͜͡,یـٖٖـۘۘ℘ـʘ͜͡,بـٖٖـۘۘ℘ـʘ͜͡,لـٖٖـۘۘ℘ـʘ͜͡,ا',نـٖٖـۘۘ℘ـʘ͜͡,تـٖٖـۘۘ℘ـʘ͜͡,مـٖٖـۘۘ℘ـʘ͜͡,چـٖٖـۘۘ℘ـʘ͜͡,ظـٖٖـۘۘ℘ـʘ͜͡,طـٖٖـۘۘ℘ـʘ͜͡,ز,ر,د,پـٖٖـۘۘ℘ـʘ͜͡,و,ڪـٖٖـۘۘ℘ـʘ͜͡,گـٖٖـۘۘ℘ـʘ͜͡,ۘثـٖٖـۘۘ℘ـʘ͜͡,ژ,ذ,آ,ئـٖٖـۘۘ℘ـʘ͜͡,.,_",
"ضـ෴ِْ,صـ෴ِْ,قـ෴ِْ,فـ෴ِْ,غـ෴ِْ,عـ෴ِْ,هـ෴ِْ,خـ෴ِْ,حـ෴ِْ,جـ෴ِْ,شـ෴ِْ,سـ෴ِْ,یـ෴ِْ,بـ෴ِْ,لـ෴ِْ,ا',نـ෴ِْ,تـ෴ِْ,مـ෴ِْ,چـ෴ِْ,ظـ෴ِْ,طـ෴ِْ,ز,ر,د,پـ෴ِْ,و,کـ෴ِْ,گـ෴ِْ,ثـ෴ِْ,ژ,ذ,آ',ئـ෴ِْ,.,__",
"ضـًٍʘًٍʘـ,صـًٍʘًٍʘـ,قـًٍʘًٍʘـ,فـًٍʘًٍʘـ,غـًٍʘًٍʘـ,عـًٍʘًٍʘـ,هـًٍʘًٍʘـ,خـًٍʘًٍʘـ,حـًٍʘًٍʘـ,جـًٍʘًٍʘـ,شـًٍʘًٍʘـ,سـًٍʘًٍʘـ,یـًٍʘًٍʘـ,بـًٍʘًٍʘـ,لـًٍʘًٍʘـ,أ,نـًٍʘًٍʘـ,تـًٍʘًٍʘـ,مـًٍʘًٍʘـ,چـًٍʘًٍʘـ,ظـًٍʘًٍʘـ,طـًٍʘًٍʘـ,زََ,رََ,دََ,پـًٍʘًٍʘـ,ٌۉ,,کـًٍʘًٍʘـ,گـًٍʘًٍʘـ,ثـًٍʘًٍʘـ,ژَِ,ذِِ,آ,ئـًٍʘًٍʘـ,.,__",
"ضـؒؔـٓٓـؒؔ◌͜͡◌,صـؒؔـٓٓـؒؔ◌͜͡◌,قـؒؔـٓٓـؒؔ◌͜͡◌,فـؒؔـٓٓـؒؔ◌͜͡◌,غـؒؔـٓٓـؒؔ◌͜͡◌,عـٓٓـؒؔ◌͜͡◌,هـؒؔـٓٓـؒؔ◌͜͡◌,خـؒؔـٓٓـؒؔ◌͜͡◌,حـؒؔـٓٓـؒؔ◌͜͡◌,جـؒؔـٓٓـؒؔ◌͜͡◌,شـؒؔـٓٓـؒؔ◌͜͡◌,سـؒؔـٓٓـؒؔ◌͜͡◌,یـؒؔـٓٓـؒؔ◌͜͡◌,بـؒؔـٓٓـؒؔ◌͜͡◌,لـؒؔـٓٓـؒؔ◌͜͡◌,ا',نـؒؔـٓٓـؒؔ◌͜͡◌,تـؒؔـٓٓـؒؔ◌͜͡◌,مـؒؔـٓٓـؒؔ◌͜͡◌,چـؒؔـٓٓـؒؔ◌͜͡◌,ظـؒؔـٓٓـؒؔ◌͜͡◌,طـؒؔـٓٓـؒؔ◌͜͡◌,ز,ر,د,پـؒؔـٓٓـؒؔ◌͜͡◌,و,کـؒؔـٓٓـؒؔ◌͜͡◌,گـؒؔـٓٓـؒؔ◌͜͡◌,ثـؒؔـٓٓـؒؔ◌͜͡◌,ژ,ذ,آ,ئـؒؔـٓٓـؒؔ◌͜͡◌,.,_",
"ضـًٍʘًٍʘـ,صـًٍʘًٍʘـ,قـًٍʘًٍʘـ,فـًٍʘًٍʘـ,غـًٍʘًٍʘـ,عـًٍʘًٍʘـ,هـًٍʘًٍʘـ,خـًٍʘًٍʘـ,حـًٍʘًٍʘـ,جـًٍʘًٍʘـ,شـًٍʘًٍʘـ,سـًٍʘًٍʘـ,یـًٍʘًٍʘـ,بـًٍʘًٍʘـ,لـًٍʘًٍʘـ,أ,نـًٍʘًٍʘـ,تـًٍʘًٍʘـ,مـًٍʘًٍʘـ,چـًٍʘًٍʘـ,ظـًٍʘًٍʘـ,طـًٍʘًٍʘـ,زََ,رََ,دََ,پـًٍʘًٍʘـ,ٌۉ,کـًٍʘًٍʘـ,گـًٍʘًٍʘـ,ثـًٍʘًٍʘـ,ژَِ,ذِِ,آ,ئـًٍʘًٍʘـ,.,_",
"ضـؒؔـٜٜঊٌٍـ↯ـٜٜـٍٍـ,صـؒؔـٜٜঊٌٍـ↯ـٜٜـٍٍـ,قـؒؔـٜٜঊٌٍـ↯ـٜٜـٍٍـ,فـؒؔـٜٜঊٌٍـ↯ـٜٜـٍٍـ,غـؒؔـٜٜঊٌٍـ↯ـٜٜـٍٍـ,عـؒؔـٜٜঊٌٍـ↯ـٜٜـٍٍـ,هـؒؔـٜٜঊٌٍـ↯ـٜٜـٍٍـ,خـؒؔـٜٜঊٌٍـ↯ـٜٜـٍٍـ,حـؒؔـٜٜঊٌٍـ↯ـٜٜـٍٍـ,جـؒؔـٜٜঊٌٍـ↯ـٜٜـٍٍـ,شـؒؔـٜٜঊٌٍـ↯ـٜٜـٍٍـ,سـؒؔـٜٜঊٌٍـ↯ـٜٜـٍٍـ,یـؒؔـٜٜঊٌٍـ↯ـٜٜـٍٍـ,بـؒؔـٜٜঊٌٍـ↯ـٜٜـٍٍـ,لـؒؔـٜٜঊٌٍـ↯ـٜٜـٍٍـ,اٍٍ,نـؒؔـٜٜঊٌٍـ↯ـٜٜـٍٍـ,تـؒؔـٜٜঊٌٍـ↯ـٜٜـٍٍـ,مـؒؔـٜٜঊٌٍـ↯ـٜٜـٍٍـ,چـؒؔـٜٜঊٌٍـ↯ـٜٜـٍٍـ,ظـؒؔـٜٜঊٌٍـ↯ـٜٜـٍٍـ,طـؒؔـٜٜঊٌٍـ↯ـٜٜـٍٍـ,ؒزٜٜ,↯رٜٜ,دٜٜঊٌٍ,پـؒؔـٜٜঊٌٍـ↯ـٜٜـٍٍـ,وٍঊٌٍ,کـؒؔـٜٜঊٌٍـ↯ــٜٜـٍٍ,گـؒؔـٜٜঊٌٍـ↯ـٜٜـٍٍـ,ثـؒؔـٜٜঊٌٍـ↯ـٜٜـٍٍـ,ژٍঊٌٍ,آ,ئـؒؔـٜٜঊٌٍـ↯ـٜٜـٍٍঊ,.,_",
"ضـؒؔـؒؔـَؔ௸,صـؒؔـؒؔـَؔ௸,قـؒؔـؒؔـَؔ௸,فـؒؔـؒؔـَؔ௸,غـؒؔـؒؔـَؔ௸,عـؒؔـؒؔـَؔ௸,ھـؒؔـؒؔـَؔ௸,خـؒؔـؒؔـَؔ௸,حـؒؔـؒؔـَؔ௸,جـؒؔـؒؔـَؔ௸,شـؒؔـؒؔـَؔ௸,سـؒؔـؒؔـَؔ௸,یـؒؔـؒؔـَؔ௸,بـؒؔـؒؔـَؔ௸,لـؒؔـؒؔـَؔ௸,ا,نـؒؔـؒؔـَؔ௸,تـؒؔـؒؔـَؔ௸,مـؒؔـؒؔـَؔ௸,چـؒؔـؒؔـَؔ௸,ظـؒؔـؒؔـَؔ௸,طـؒؔـؒؔـَؔ௸,ز,ر,د,پـؒؔـؒؔـَؔ௸,و,کـؒؔـؒؔـَؔ௸,گـؒؔـؒؔـَؔ௸,ثـؒؔـؒؔـَؔ௸,ژ,آ,ئـؒؔـؒؔـَؔ௸,.,_",
"ضــًٍـٍؓـٍ۪ـ۪ؔـٍ℘ًً,صــًٍـٍؓـٍ۪ـ۪ؔـٍ℘ًً,قــًٍـٍؓـٍ۪ـ۪ؔـٍ℘ًً,فــًٍـٍؓـٍ۪ـ۪ؔـٍ℘ًً,غــًٍـٍؓـٍ۪ـ۪ؔـٍ℘ًً,عــًٍـٍؓـٍ۪ـ۪ؔـٍ℘ًً,هــًٍـٍؓـٍ۪ـ۪ؔـٍ℘ًً,خــًٍـٍؓـٍ۪ـ۪ؔـٍ℘ًً,حــًٍـٍؓـٍ۪ـ۪ؔـٍ℘ًً,جــًٍـٍؓـٍ۪ـ۪ؔـٍ℘ًً,شــًٍـٍؓـٍ۪ـ۪ؔـٍ℘ًً,ســًٍـٍؓـٍ۪ـ۪ؔـٍ℘ًً,یــًٍـٍؓـٍ۪ـ۪ؔـٍ℘ًً,بــًٍـٍؓـٍ۪ـ۪ؔـٍ℘ًً,لــًٍـٍؓـٍ۪ـ۪ؔـٍ℘ًً,,اٍؓ℘ًً,نــًٍـٍؓـٍ۪ـ۪ؔـٍ℘ًً,تــًٍـٍؓـٍ۪ـ۪ؔـٍ℘ًً,مــًٍـٍؓـٍ۪ـ۪ؔـٍ℘ًً,چــًٍـٍؓـٍ۪ـ۪ؔـٍ℘ًً,ظــًٍـٍؓـٍ۪ـ۪ؔـٍ℘ًً,طــًٍـٍؓـٍ۪ـ۪ؔـٍ℘ًً,زًٍ,ر۪ؔ℘ًً,د۪ؔ,پــًٍـٍؓـٍ۪ـ۪ؔـٍ℘ًً,وٍؓ℘ًً,کــًٍـٍؓـٍ۪ـ۪ؔـٍ℘ًً,گــًٍـٍؓـٍ۪ـ۪ؔـٍ℘ًً,ثــًٍـٍؓـٍ۪ـ۪ؔـٍ℘ًً,ژٍؓ℘ًً,ٍذّ℘ًً,℘ًًآ,ئــًٍـٍؓـٍ۪ـ۪ؔـٍ℘ًً,.,_",
"ضٜٜــؕؕـٜٜـٜٜ✿,صٜٜــؕؕـٜٜـٜٜ✿,قٜٜــؕؕـٜٜـٜٜ✿,فٜٜــؕؕـٜٜـٜٜ✿,غــؕؕـٜٜـٜٜ✿,عٜٜــؕؕـٜٜـٜٜ✿,هٜٜــؕؕـٜٜـٜٜ✿,خــؕؕـٜٜـٜٜ✿,حٜٜــؕؕـٜٜـٜٜ✿,جــؕؕـٜٜـٜٜ✿,شٜٜــؕؕـٜٜـٜٜ✿,سٜٜــؕؕـٜٜـٜٜ✿,یٜٜــؕؕـٜٜـٜٜ✿,بــؕؕـٜٜـٜٜ✿,لــؕؕـٜٜـٜٜ✿,ٜٜا,نٜٜــؕؕـٜٜـٜٜ✿,تٜٜــؕؕـٜٜـٜٜ✿,مــؕؕـٜٜـٜٜ✿,چٜٜــؕؕـٜٜـٜٜ✿,ظٜٜــؕؕـٜٜـٜٜ✿,طــؕؕـٜٜـٜٜ✿,ٜٜزٜٜ✿,ٜٜرؕ✿,دٜٜ,پـٜٜــؕؕـٜٜـٜٜ✿,وٜٜ,کٜٜــؕؕـٜٜـٜٜ✿,گٜٜــؕؕـٜٜـٜٜ✿,ثٜٜــؕؕـٜٜـٜٜ✿,ژٜٜ✿,ذٜٜ,✿آ,ئٜٜــؕؕـٜٜـٜٜ✿,.,_",
"ضَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,َصَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,قـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَ,فَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,َغَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,عَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَ,هَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,َخَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,حَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَ,جَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,َشَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,سَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَ,یَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,َبَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,لَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَ,اَِ,نَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,َتَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,مَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَ,چَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,َظَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,طَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَ,زَِ,رَِ,دَِ,پَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,َوًَ,کَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,گـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَ,ثَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,َژَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـ,ذَِ,آ,ئـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَِـَ,.,_",
"ضٜٜــؕؕـٜٜـٜٜ✿ٜٜـٜٜـٜٜـ,صٜٜــؕؕـٜٜـٜٜ✿ٜٜـٜٜـٜٜـ,قٜٜــؕؕـٜٜـٜٜ✿ٜٜـٜٜـٜٜـ,فٜٜــؕؕـٜٜـٜٜ✿ٜٜـٜٜـٜٜـ,غــؕؕـٜٜـٜٜ✿ٜٜـٜٜـٜٜـ,عٜٜــؕؕـٜٜـٜٜ✿ٜٜـٜٜـٜٜـ,هٜٜــؕؕـٜٜـٜٜ✿ٜٜـٜٜـٜٜـ,خــؕؕـٜٜـٜٜ✿ٜٜـٜٜـٜٜـ,حٜٜــؕؕـٜٜـٜٜ✿ٜٜـٜٜـٜٜـ,جــؕؕـٜٜـٜٜ✿ٜٜـٜٜـٜٜـ,شــؕؕـٜٜـٜٜ✿ٜٜـٜٜـٜٜـ,سٜٜــؕؕـٜٜـٜٜ✿ٜٜـٜٜـٜٜـ,یٜٜــؕؕـٜٜـٜٜ✿ٜٜـٜٜـٜٜـ,بــؕؕـٜٜـٜٜ✿ٜٜـٜٜـٜٜـ,لــؕؕـٜٜـٜٜ✿ٜٜـٜٜـٜٜـ,ٜٜا,نٜٜــؕؕـٜٜـٜٜ✿ٜٜـٜٜـٜٜـ,تٜٜــؕؕـٜٜـٜٜ✿ٜٜـٜٜـٜٜـ,مــؕؕـٜٜـٜٜ✿ٜٜـٜٜـٜٜـ,چٜٜــؕؕـٜٜـٜٜ✿ٜٜـٜٜـٜٜـ,ظٜٜــؕؕـٜٜـٜٜ✿ٜٜـٜٜـٜٜـ,طــؕؕـٜٜـٜٜ✿ٜٜـٜٜـٜٜـ,زٜٜ✿,ٜٜرؕ✿,دٜٜ,پـٜٜــؕؕـٜٜـٜٜ✿ٜٜـٜٜـٜٜـ,وٜٜ,کٜٜــؕؕـٜٜـٜٜ✿ٜٜـٜٜـٜٜـ,گٜٜــؕؕـٜٜـٜٜ✿ٜٜـٜٜـٜٜـ,ثٜٜــؕؕـٜٜـٜٜ✿ٜٜـٜٜـٜٜـ,ژٜٜ✿,ذٜٜ,✿آ,ئٜٜــؕؕـٜٜـٜٜ✿ٜٜـٜٜـٜٜـ,.,_",
"ضـٰٖـۘۘـــٍٰـ,صـٰٖـۘۘـــٍٰـ,قـٰٖـۘۘـــٍٰـ,فـٰٖـۘۘـــٍٰـ,غـٰٖـۘۘـــٍٰـ,عـٰٖـۘۘـــٍٰـ,هـٰٖـۘۘـــٍٰـ,خـٰٖـۘۘـــٍٰـ,حـٰٖـۘۘـــٍٰـ,جـٰٖـۘۘـــٍٰـ,شـٰٖـۘۘـــٍٰـ,سـٰٖـۘۘـــٍٰـ,یـٰٖـۘۘـــٍٰـ,بـٰٖـۘۘـــٍٰـ,لـٰٖـۘۘـــٍٰـ,ا,نـٰٖـۘۘـــٍٰـ,تـٰٖـۘۘـــٍٰـ,مـٰٖـۘۘـــٍٰـ,چـٰٖـۘۘـــٍٰـ,ظـٰٖـۘۘـــٍٰـ,طـٰٖـۘۘـــٍٰـ,زٰٖ,رٰٖ,دٰٖ,پـٰٖـۘۘـــٍٰـ,و়়,لـٰٖـۘۘـــٍٰـ,گـٰٖـۘۘـــٍٰـ,ثـٰٖـۘۘـــٍٰ,ژٰٖ,ذۘۘ,آ়,ئـٰٖـۘۘـــٍٰـ,.,_",
"ضـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,صـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,قـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,فـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,,غـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,عـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,هـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,خـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,حـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,جـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,شـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,سـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,یـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,بـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,لـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,ا͜͝,نـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,تـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,مـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,چـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,ظـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,طـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,͜͝ز❁۠۠,❁ر۠۠,❁د۠۠,پـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,❁۠۠و,کـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,گـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,ثـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,❁ژ۠۠,❁ذ۠۠,❁۠۠آ,ئـ͜͝ـ͜͝ـ͜͝ـ❁۠۠,.,_",
"ضـ͜͝ـ۪ٜـ۪ٜ❀,صـ͜͝ـ۪ٜـ۪ٜ❀,قـ͜͝ـ۪ٜـ۪ٜ❀,فـ͜͝ـ۪ٜـ۪ٜ❀,غـ͜͝ـ۪ٜـ۪ٜ,عـ͜͝ـ۪ٜـ۪ٜ❀,هـ͜͝ـ۪ٜـ۪ٜ❀,خـ͜͝ـ۪ٜـ۪ٜ❀,حـ͜͝ـ۪ٜـ۪ٜ❀,جـ͜͝ـ۪ٜـ۪ٜ,شـ͜͝ـ۪ٜـ۪ٜ❀,سـ͜͝ـ۪ٜـ۪ٜ❀,یـ͜͝ـ۪ٜـ۪ٜ❀,بـ͜͝ـ۪ٜـ۪ٜ❀,لـ͜͝ـ۪ٜـ۪ٜ❀,❀ا❀,نـ͜͝ـ۪ٜـ۪ٜ❀,تـ͜͝ـ۪ٜـ۪ٜ❀,مـ͜͝ـ۪ٜـ۪ٜ❀,چـ͜͝ـ۪ٜـ۪ٜ❀,ظـ͜͝ـ۪ٜـ۪ٜ❀,طـ͜͝ـ۪ٜـ۪ٜ❀,۪ٜز❀,۪ٜر❀,۪ٜ❀د,پـ͜͝ـ۪ٜـ۪ٜ❀,و❀,کـ͜͝ـ۪ٜـ۪ٜ❀,گـ͜͝ـ۪ٜـ۪ٜ❀,ثـ͜͝ـ۪ٜـ۪ٜ❀,ژ❀,ذ۪ٜ❀,͜͝ـ۪ٜ❀آ,ئـ͜͝ـ۪ٜـ۪ٜ❀,.,_",
"ضـ℘ू,صـٰٰـۘۘ↭ٖٓ,قــٜ۪◌͜͡✾ـ,فــ℘ू,غـٜ۪◌͜͡✾,عـ℘ू,هـ℘ू,خـٰٰـۘۘ↭ٖٓ,حـٜ۪◌͜͡✾ـ,جـ℘ू,شـٰٰـۘۘ↭ٖٓ,سـٜ۪◌͜͡✾,یــ℘ू,بــ℘ू,لـٜ۪◌͜͡✾,ا℘ू,نـٰٰـۘۘ↭ٖٓ,تـٜ۪◌͜͡✾,مـ℘ू,چـ℘ू,ظـٰٰـۘۘ↭ٖٓ,طـٜ۪◌͜͡✾ـ,زُّ'℘ू,رٰٰ℘ू,ٜ۪◌د͜͡✾,پـ℘ू,ـٰٰوُّ,ڪـٜ۪◌͜͡✾,گـ℘ू,ثـٰٰـۘۘ↭ٖٓ,ژٜ۪◌͜͡✾,ذًَ℘ू,℘ूآ,ئـٰٰـۘۘ↭ٖٓ,.,_",
"ضـ͜͝ـ۪ٜـ۪ٜ❀,صـ͜͝ـ۪ٜـ۪ٜ❀,قـ͜͝ـ۪ٜـ۪ٜ❀,فـ͜͝ـ۪ٜـ۪ٜ❀,غـ͜͝ـ۪ٜـ۪ٜ,عـ͜͝ـ۪ٜـ۪ٜ❀,هـ͜͝ـ۪ٜـ۪ٜ❀,خـ͜͝ـ۪ٜـ۪ٜ❀,حـ͜͝ـ۪ٜـ۪ٜ❀,جـ͜͝ـ۪ٜـ۪ٜ,شـ͜͝ـ۪ٜـ۪ٜ❀,سـ͜͝ـ۪ٜـ۪ٜ❀,یـ͜͝ـ۪ٜـ۪ٜ❀,بـ͜͝ـ۪ٜـ۪ٜ❀,لـ͜͝ـ۪ٜـ۪ٜ❀,❀ا❀,نـ͜͝ـ۪ٜـ۪ٜ❀,تـ͜͝ـ۪ٜـ۪ٜ❀,مـ͜͝ـ۪ٜـ۪ٜ❀,چـ͜͝ـ۪ٜـ۪ٜ❀,ظـ͜͝ـ۪ٜـ۪ٜ❀,طـ͜͝ـ۪ٜـ۪ٜ❀,۪ٜز❀,۪ٜر❀,۪ٜ❀د,پـ͜͝ـ۪ٜـ۪ٜ❀,و❀,کـ͜͝ـ۪ٜـ۪ٜ❀,گـ͜͝ـ۪ٜـ۪ٜ❀,ثـ͜͝ـ۪ٜـ۪ٜ❀,ژ❀,ذ۪ٜ❀,͜͝ـ۪ٜ❀آ,ئـ͜͝ـ۪ٜـ۪ٜ❀,.,_",
"ضـैـ۪ٜـ۪ٜـ۪ٜ❀͜͡ــؒؔ,صـैـ۪ٜـ۪ٜـ۪ٜ❀͜͡ــؒؔ,قـैـ۪ٜـ۪ٜـ۪ٜ❀͜͡ــؒؔ,فـैـ۪ٜـ۪ٜـ۪ٜ❀͜͡ــؒؔ,غـैـ۪ٜـ۪ٜـ۪ٜ❀͜͡ــؒؔ,عـैـ۪ٜـ۪ٜـ۪ٜ❀͜͡ــؒؔ,هـैـ۪ٜـ۪ٜـ۪ٜ❀͜͡ــؒؔ,خـैـ۪ٜـ۪ٜـ۪ٜ❀͜͡ــ,ؒؔحैـ۪ٜـ۪ٜـ۪ٜ❀͜͡ــؒؔ,جـैـ۪ٜـ۪ٜـ۪ٜ❀͜͡ــؒؔ,شـैـ۪ٜـ۪ٜـ۪ٜ❀͜͡ــؒؔ,سـैـ۪ٜـ۪ٜـ۪ٜ❀͜͡ــؒؔ,یـैـ۪ٜـ۪ٜـ۪ٜ❀͜͡ــؒؔ,بـैـ۪ٜـ۪ٜـ۪ٜ❀͜͡ــؒؔ,لـैـ۪ٜـ۪ٜـ۪ٜ❀͜͡ــؒؔ,ैا'َّ,نـैـ۪ٜـ۪ٜـ۪ٜ❀͜͡ــؒؔ,تـैـ۪ٜـ۪ٜـ۪ٜ❀͜͡ــؒؔ,مـैـ۪ٜـ۪ٜـ۪ٜ❀͜͡ــؒؔ,چـैـ۪ٜـ۪ٜـ۪ٜ❀͜͡ــؒؔ,ظैـ۪ٜـ۪ٜـ۪ٜ❀͜͡ــؒؔ,طैـ۪ٜـ۪ٜـ۪ٜ❀͜͡ــؒؔ,ز۪ٜ❀,رؒؔ,❀'͜͡دَّ',پـैـ۪ٜـ۪ٜـ۪ٜ❀͜͡ــؒؔ,'وَّ'ै,ڪैـ۪ٜـ۪ٜـ۪ٜ❀͜͡ــؒؔ,گـैـ۪ٜـ۪ٜـ۪ٜ❀͜͡ــؒؔ,ثـैـ۪ٜـ۪ٜـ۪ٜ❀͜͡ــؒؔ,۪ٜ❀ژै,ذै,۪ٜ❀آ',ئـैـ۪ٜـ۪ٜـ۪ٜ❀͜͡ــؒؔ,.,_",
"ضـ͜͡ــؒؔـ͜͝ـ,صـ͜͡ــؒؔـ͜͝ـ,قـ͜͡ــؒؔـ͜͝ـ,فـ͜͡ــؒؔـ͜͝ـ,غـ͜͡ــؒؔـ͜͝ـ,عـ͜͡ــؒؔـ͜͝ـ,هـ͜͡ــؒؔـ͜͝ـ,خـ͜͡ــؒؔـ͜͝ـ,حـ͜͡ــؒؔـ͜͝ـ,جـ͜͡ــؒؔـ͜͝ـ,شـ͜͡ــؒؔـ͜͝ـ,سـ͜͡ــؒؔـ͜͝ـ,یـ͜͡ــؒؔـ͜͝ـ,بـ͜͡ــؒؔـ͜͝ـ,لـ͜͡ــؒؔـ͜͝ـ,اؒؔ,نـ͜͡ــؒؔـ͜͝ـ,تـ͜͡ــؒؔـ͜͝ـ,مـ͜͡ــؒؔـ͜͝ـ,چـ͜͡ــؒؔـ͜͝ـ,ظـ͜͡ــؒؔـ͜͝ـ,طـ͜͡ــؒؔـ͜͝ـ,❁'ز'۠۠,ر҉   ,❁'د۠۠,پـ͜͡ــؒؔـ͜͝ـ,'وۘۘ',کـ͜͡ــؒؔـ͜͝ـ,گـ͜͡ــؒؔـ͜͝ـ,ثـ͜͡ــؒؔـ͜͝ـ,❁'ژ۠۠,❁'د'۠۠,❁۠۠,آ,ئـ͜͡ــؒؔـ͜͝ـ,.,_",
"ضٰٖـٰٖ℘ـَ͜✾ـ,صٰٖـٰٖ℘ـَ͜✾ـ,قٰٖـٰٖ℘ـَ͜✾ـ,فٰٖـٰٖ℘ـَ͜✾ـ,غٰٖـٰٖ℘ـَ͜✾ـ,عٰٖـٰٖ℘ـَ͜✾ـ,هٰٖـٰٖ℘ـَ͜✾ـ,خٰٖـٰٖ℘ـَ͜✾ـ,حٰٖـٰٖ℘ـَ͜✾ـ,جٰٖـٰٖ℘ـَ͜✾ـ,شٰٖـٰٖ℘ـَ͜✾ـ,سٰٖـٰٖ℘ـَ͜✾ـ,یٰٖـٰٖ℘ـَ͜✾ـ,بٰٖـٰٖ℘ـَ͜✾ـ,لٰٖـٰٖ℘ـَ͜✾ـ,اٰٖـٰٖ℘ـَ͜✾ـ,نٰٖـٰٖ℘ـَ͜✾ـ,تٰٖـٰٖ℘ـَ͜✾ـ,مٰٖـٰٖ℘ـَ͜✾ـ,چٰٖـٰٖ℘ـَ͜✾ـ,ظٰٖـٰٖ℘ـَ͜✾ـ,طٰٖـٰٖ℘ـَ͜✾ـ,زٰٖـٰٖ℘ـَ͜✾ـ,رٰٖـٰٖ℘ـَ͜✾ـ,دٰٖـٰٖ℘ـَ͜✾ـ,پٰٖـٰٖ℘ـَ͜✾ـ,وٰٖـٰٖ℘ـَ͜✾ـ,کٰٖـٰٖ℘ـَ͜✾ـ,گٰٖـٰٖ℘ـَ͜✾ـ,ثٰٖـٰٖ℘ـَ͜✾ـ,ژٰٖـٰٖ℘ـَ͜✾ـ,ذٰٖـٰٖ℘ـَ͜✾ـ,آٰٖـٰٖ℘ـَ͜✾ـ,ئٰٖـٰٖ℘ـَ͜✾ـ,.ٰٖـٰٖ℘ـَ͜✾ـ,_",
"ض❈ۣۣـ🍁ـ,ص❈ۣۣـ🍁ـ,ق❈ۣۣـ🍁ـ,ف❈ۣۣـ🍁ـ,غ❈ۣۣـ🍁ـ,ع❈ۣۣـ🍁ـ,ه❈ۣۣـ🍁ـ,خ❈ۣۣـ🍁ـ,ح❈ۣۣـ🍁ـ,ج❈ۣۣـ🍁ـ,ش❈ۣۣـ🍁ـ,س❈ۣۣـ🍁ـ,ی❈ۣۣـ🍁ـ,ب❈ۣۣـ🍁ـ,ل❈ۣۣـ🍁ـ,ا❈ۣۣـ🍁ـ,ن❈ۣۣـ🍁ـ,ت❈ۣۣـ🍁ـ,م❈ۣۣـ🍁ـ,چ❈ۣۣـ🍁ـ,ظ❈ۣۣـ🍁ـ,ط❈ۣۣـ🍁ـ,ز❈ۣۣـ🍁ـ,ر❈ۣۣـ🍁ـ,د❈ۣۣـ🍁ـ,پ❈ۣۣـ🍁ـ,و❈ۣۣـ🍁ـ,ک❈ۣۣـ🍁ـ,گ❈ۣۣـ🍁ـ,ث❈ۣۣـ🍁ـ,ژ❈ۣۣـ🍁ـ,ذ❈ۣۣـ🍁ـ,آ❈ۣۣـ🍁ـ,ئ❈ۣۣـ🍁ـ,.❈ۣۣـ🍁ـ,_",
"ضْஓ͜ঠৡ,صْஓ͜ঠৡ,قْஓ͜ঠৡ,فْஓ͜ঠৡ,غْஓ͜ঠৡ,عْஓ͜ঠৡ,هْஓ͜ঠৡ,خْஓ͜ঠৡ,حْஓ͜ঠৡ,جْஓ͜ঠৡ,شْஓ͜ঠৡ,سْஓ͜ঠৡ,یْஓ͜ঠৡ,بْஓ͜ঠৡ,لْஓ͜ঠৡ,اْஓ͜ঠৡ,نْஓ͜ঠৡ,تْஓ͜ঠৡ,مْஓ͜ঠৡ,چْஓ͜ঠৡ,ظْஓ͜ঠৡ,طْஓ͜ঠৡ,زْஓ͜ঠৡ,رْஓ͜ঠৡ,دْஓ͜ঠৡ,پْஓ͜ঠৡ,وْஓ͜ঠৡ,کْஓ͜ঠৡ,گْஓ͜ঠৡ,ثْஓ͜ঠৡ,ژْஓ͜ঠৡ,ذْஓ͜ঠৡ,آْஓ͜ঠৡ,ئْஓ͜ঠৡ,.ْஓ͜ঠৡ,_",
"ضـೄ,صـ۪۪ـؒؔـؒؔ◌͜͡◌,قـ۪۪ـؒؔـ۪۪,فـ͜͡ــؒؔـ͜͝ـ,غـೄ,عـ۪۪ـؒؔـ۪۪,هٍٖ❦,خـٜٓـٍٜـٜ٘ـ,حـٜ٘ـَٖ,جٍٍـٍٜــٍٍـٜ٘,͜͡∅شٍٜ۩,↜͜͡∅سٍٜ۩,یٜ٘,↭ِِبَٖ↜͜͡,لـٍٍـٍٜــٍٍـٜ٘∅,↜͜͡'اَُ'ِ,❦نٍٓ,تـــ۪۪ـؒؔــؒؔ◌͜͡◌,مـೄ,چــ۪۪ـؒؔـ۪۪,❀ظـؒؔ❀,طــَ͜✿ٰ,✧زٰٰ‌〆۪۪,✵ٍٓ ٍٖر,دٍٖ❦,پـٖٖـٖٖــَ͜✧,℘و'َ͜✿,کـٖٖـٖٖ‍℘,گـؒؔـٰٰ‌℘,❀ثـٜـؒؔ〆۪۪,ژٍٖ❦,✿ٰٰ‌ذ❀✵آٍٓ✵ٓ,ئـೄ,.,_",
"✮ًٍضـًٍـَؔ✯ًٍ,✮صًٍـًٍـَؔ✯ًٍ,✮قًٍـًٍـَؔ✯ًٍ,✮ًٍفـًٍـَؔ✯ًٍ,✮غًٍـًٍـَؔ✯,ًٍ✮عًٍـًٍـَؔ✯ًٍ,✮هًٍـًٍـَؔ✯ًٍ,✮خًٍـًٍـَؔ✯ًٍ,✮ًٍحـٜـًٍـَؔ✯ًٍ,✮جًٍـًٍـَؔ✯ًٍ,✮شًٍـًٍـَؔ✯ًٍ,✮سًٍـًٍـَؔ✯ًٍ,✮ًٍیــًٍـَؔ✯ًٍ,✮بـًٍـًٍـَؔ✯ًٍ,✮لـًٍـًٍـَؔ✯ًٍ,✮ًٍا✯ًٍ,✮نًٍـًٍـَؔ✯ًٍ,✮تًٍـًٍـَؔ✯ًٍ,✮مًٍـًٍـَؔ✯ًٍ,✮چًٍـًٍـَؔ✯ًٍ,✮ظًٍـًٍـَؔ✯ًٍ,✮ًٍطـًٍـَؔ✯ًٍ,زَؔ✯ًٍ,ًٍرَؔ✯ًٍ,✮ًٍد,َؔ✮پًٍـًٍـَؔ✯ًٍ,✯ًٍو,✮ًٍکـًٍـَؔ✯ًٍ,✮ًٍگـًٍـَؔ✯ًٍ,✮ًٍثــًٍـَؔ✯ًٍ,✮ژًٍ,✯ًٍذ,✮آًٍ✯ًٍ,✮ئـًٍـًٍـَؔ✯ًٍ,.,_",
"ضـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,صـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,قـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,فـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,غـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,عـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,هـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,خـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,حـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,جـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,شـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,سـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,یـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,بـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,لـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,✯اّّ✯,نـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,تـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,مـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,چـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,ظـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,طـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,✯زَّ'✯,✯ر✯,✯د✯,پـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,‌ົ້◌ฺฺ'‌ົ້و◌ฺฺ,ڪـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,گـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,ثـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,‌ົ້◌ฺฺژ,✯ذ✯,ಹ۪۪'آ'‌ົ້◌ฺฺಹ۪۪,ئـؒؔـؒؔـ۪۪ـؒؔـؒؔـ‌ົ້◌ฺฺಹ۪۪,.,_",
"ضـٰٖـۘۘـــٍٰـ,صـٰٖـۘۘـــٍٰـ,قـٰٖـۘۘـــٍٰـ,فـٰٖـۘۘـــٍٰـ,غـٰٖـۘۘـــٍٰـ,عـٰٖـۘۘـــٍٰـ,ه',خـٰٖـۘۘـــٍٰـ,حـٰٖـۘۘـــٍٰـ,جـٰٖـۘۘـــٍٰـ,شـٰٖـۘۘـــٍٰـ,سـٰٖـۘۘـــٍٰـ,یـٰٖـۘۘـــٍٰـ,بـٰٖـۘۘـــٍٰـ,لـٰٖـۘۘـــٍٰـ,ا,نـٰٖـۘۘـــٍٰـ,تـٰٖـۘۘـــٍٰـ,مـٰٖـۘۘـــٍٰـ,چـٰٖـۘۘـــٍٰـ,ظـٰٖـۘۘـــٍٰـ,طـٰٖـۘۘـــٍٰـ,ز,ر,د,پـٰٖـۘۘـــٍٰـ,و,ڪـٰٖـۘۘـــٍٰـ,گـٰٖـۘۘـــٍٰـ,ثـٰٖـۘۘـــٍٰـ,ژ,ذ,آ,ئـٰٖـۘۘـــٍٰـ,.,_",
"ضٰٓـؒؔـ۪۪ঊ۝,صٰٓـؒؔـ۪۪ঊ۝,قٰٓـؒؔـ۪۪ঊ۝,قٰٓـؒؔـ۪۪ঊ۝,غٰٓـؒؔـ۪۪ঊ۝,عٰٓـؒؔـ۪۪ঊ۝,هٰٓـؒؔـ۪۪ঊ۝,خٰٓـؒؔـ۪۪ঊ۝,ٰحٰٓـؒؔـ۪۪ঊ۝ٰٓ,جٰٓـؒؔـ۪۪ঊ۝,شٰٓـؒؔـ۪۪ঊ۝,سٰٓـؒؔـ۪۪ঊ۝,یٰٓـؒؔـ۪۪ঊ۝,بٰٓـؒؔـ۪۪ঊ۝,لٰٓـؒؔـ۪۪ঊ۝,اٰ۪,نٰٓـؒؔـ۪۪ঊ۝,تٰٓـؒؔـ۪۪ঊ۝,مٰٓـؒؔـ۪۪ঊ۝,چٰٓـؒؔـ۪۪ঊ۝,ظٰٓـؒؔـ۪۪ঊ۝,طٰٓـؒؔـ۪۪ঊ۝ٰٓ,زؓঊ,رٰٓ,۪۪دؓ,پٰٓـؒؔـ۪۪ঊ۝,وٰٓ,۪۪کٰٓـؒؔـ۪۪ঊ۝,گٰٓـؒؔـ۪۪ঊ۝,ثٰٓـؒؔـ۪۪ঊ۝,ؒؔژؓঊ,ذ۪۪ঊ,آٰٓ۝,ئٰٓـؒؔـ۪۪ঊ۝,.,_",
"ض۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,ص۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,ق۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,ف۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,غ۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,ع۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,ه۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,خ۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,ح۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,ج۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,ش۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,س۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,ی۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,ب۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,ل۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,ٗؔ✰͜͡ا℘ِِ,ن۪۟ــ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,ت۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,م۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,چ۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,ظ۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,ط۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,✰͜͡ز℘ِِ,ٗؔ✰ر͜͡℘ِِ,✰͜͡د℘ِِ,پ۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,۪ٜ✰و͜͡℘ِِ,ڪ۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,گ۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,ث۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,✰͜͡ژ℘ِِ,ٗؔ✰ذ͜͡℘ِِ,✰͜͡آ'℘ِِ,ئ۪۟ـ۟۟✶ًٍـ۟ـًٍـ۪۟ـ۟ـًٍــ۪۟ـ۟۟ـً۟ــٗؔـٗؔ✰͜͡℘ِِ,.,_",
"ضـ۪۪ইٌ,صـ۪۪ইٌ,قـ۪۪ইٌ,فّــٍ͜ـ়়,غــٍ͜ـ়়,ع়ۘـٖٖــ,,ۘۘهُِـۘۘ,,خـ়ـۘۘـٍٰ,حـْ₰ْۜ,جـْ₰ْۜ,شـْ ـْ₰,سّـ ـٍ͜ـ়়,یْۜـْ✤ْ,بـ̴̬℘̴̬ـ̴̬مـ̴̬℘,لـ̴̬ـ̴̬مـ,ا,نـ̴̬℘̴̬ـ̴, تـ̴̬℘̴̬ـ̴̬م̴̬,℘مـ̴̬ـ̴̬مـ℘,چــَؔ۝,ظــَؔ۝,ط়ـۘۘـٍٰ℘,زٌّ,رٌّ,دٌّ,پــٍ͜ـ়়و,ڪ়ۘ,گـٖٖـۘۘـۘۘـُِـۘۘ,ثــَ͜✿ٰٰ‌ᬼ✵,ژ,ذ,آ,ئــٜ۪✦ــٜ۪✦,.,_",
"ضؔؑـَؔـَؔ ـَؔ สฺฺŗــَؔ๛ٖؔ,صؔؑــَؔـَؔ ـَؔ สฺฺŗــَؔ๛ٖؔ,قؔؑــَؔـَؔ ـَؔ สฺฺŗــَؔ๛ٖؔ,❂ؔؑفــَؔـَؔ ـَؔ สฺฺŗــَؔ๛ٖؔ,غؔؑــَؔـَؔ ـَؔ สฺฺŗــَؔ๛ٖؔ,عـَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,هؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,خؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,حؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,جــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,شؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,سـَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,یؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,بؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,لؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,اสฺฺ,ؔؑنــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,ؔؑتــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,مؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,چؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,ظؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,طؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,❂زؔؑ ـَؔ ,رสฺฺŗ,❂ؔؑـَؔد۪๛ٖؔ,ؔؑپــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,❂وؔؑ ـَؔ,ڪؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,گؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,ثؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,สฺฺŗـذَؔ๛ٖؔ,❂آ,ئؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,.,_",
"ضــ ོꯨ҉ــؒؔ҉:ـــ,صــ ོꯨ҉ــؒؔ҉:ــــ,قــ ོꯨ҉ــؒؔ҉:ــــ,فــ ོꯨ҉ــؒؔ҉:ــــ,غــ ོꯨ҉ــؒؔ҉:ــــ,عــ ོꯨ҉ــؒؔ҉:ــــ,هــ ོꯨ҉ــؒؔ҉:ــــ,خــ ོꯨ҉ــؒؔ҉:ــــ,حــ ོꯨ҉ــؒؔ҉:ــــ,ج۪ٜــ ོꯨ҉ــؒؔ҉:ــــ,شــ ོꯨ҉ــؒؔ҉:ــــ,ســ ོꯨ҉ــؒؔ҉:ــــ,یــ ོꯨ҉ــؒؔ҉:ــــ,بــ ོꯨ҉ــؒؔ҉:ــــ,لــ ོꯨ҉ــؒؔ҉:ــــ,اــ ོꯨ҉ــؒؔ҉:ــــ,نــ ོꯨ҉ــؒؔ҉:ــــ,تــ ོꯨ҉ــؒؔ҉:ــــ,مــ ོꯨ҉ــؒؔ҉:ــــ,چــ ོꯨ҉ــؒؔ҉:ــــ,ظــ ོꯨ҉ــؒؔ҉:ــــ,طــ ོꯨ҉ــؒؔ҉:ــــ,زــ ོꯨ҉ــؒؔ҉:ــــ,رــ ོꯨ҉ــؒؔ҉:ــــ,دــ ོꯨ҉ــؒؔ҉:ــــ,پــ ོꯨ҉ــؒؔ҉:ــــ,وــ ོꯨ҉ــؒؔ҉:ــــ,کــ ོꯨ҉ــؒؔ҉:ــــ,گــ ོꯨ҉ــؒؔ҉:ــــ,ثــ ོꯨ҉ــؒؔ҉:ــــ,ژــ ོꯨ҉ــؒؔ҉:ــــ,ذــ ོꯨ҉ــؒؔ҉:ــــ,آ,ئ,.,_",
"ضؔؑـَؔـَؔ ـَؔ สฺฺŗــَؔ๛ٖؔ,صؔؑــَؔـَؔ ـَؔ สฺฺŗــَؔ๛ٖؔ,قؔؑــَؔـَؔ ـَؔ สฺฺŗــَؔ๛ٖؔ,❂ؔؑفــَؔـَؔ ـَؔ สฺฺŗــَؔ๛ٖؔ,غؔؑــَؔـَؔ ـَؔ สฺฺŗــَؔ๛ٖؔ,عـَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,هؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,خؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,حؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,جــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,شؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,سـَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,یؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,بؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,لؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,اสฺฺ,ؔؑنــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,ؔؑتــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,مؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,چؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,ظؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,طؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,❂زؔؑ ـَؔ ,رสฺฺŗ,❂ؔؑـَؔد۪๛ٖؔ,ؔؑپــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,❂وؔؑ ـَؔ,ڪؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,گؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,ثؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,สฺฺŗـذَؔ๛ٖؔ,❂آ,ئؔؑــَؔـَؔ ـَؔ สฺฺŗـَؔ๛ٖؔ,.,_",
"ضؔؑـَؔ ـؔؑـَؔ๛ٖؔ,ؔؑصـَؔ ـؔؑـَؔ๛ٖؔ,ؔؑقـَؔ ـؔؑـَؔ๛ٖؔ,فؔؑـَؔ ـؔؑـَؔ๛ٖؔ,ؔؑغـَؔ ـؔؑـَؔ๛ٖؔ,ؔؑعـَؔ ـؔؑـَؔ๛ٖؔ,ؔؑه۪๛ٖؔ,ؔؑخـَؔ ـؔؑـَؔ๛ٖؔ,حؔؑـَؔ ـؔؑـَؔ๛ٖؔ,جؔؑـَؔ ـؔؑـَؔ๛ٖؔ,ؔؑشـَؔ ـؔؑـَؔ๛ٖؔ,ؔؑسـَؔ ـؔؑـَؔ๛ٖؔ,ؔؑیـَؔ ـؔؑـَؔ๛ٖؔ,ؔؑبـَؔ ـؔؑـَؔ๛ٖؔ,ؔؑلـَؔ ـؔؑـَؔ๛ٖؔ,ا,ؔؑنـَؔ ـؔؑـَؔ๛ٖؔ,ؔؑتـَؔ ـؔؑـَؔ๛ٖؔ,مؔؑـَؔ ـؔؑـَؔ๛ٖؔ,ؔؑچـَؔ ـؔؑـَؔ๛ٖؔ,طؔؑـَؔ ـؔؑـَؔ๛ٖؔ,ؔؑظـَؔ ـؔؑـَؔ๛ٖؔ,ؔؑزَؔ,ر,د,پؔؑـَؔ ـؔؑـَؔ๛ٖؔ,و,کؔؑـَؔ ـؔؑـَؔ๛ٖؔ,گؔؑـَؔ ـؔؑـَؔ๛ٖؔ,ؔؑثـَؔ ـؔؑـَؔ๛ٖؔ,ژ,ذ,آ,ؔؑئـَؔ ـؔؑـَؔ๛ٖؔ,.,_",
"ضـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,صـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,قـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,فـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,غـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,عـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,ه➤,خـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,حـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,جـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,شـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,سـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,یـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,بـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,لـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,ا✺۠۠➤,نـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,تـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,مـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,چـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,ظـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,طـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,ز✺۠۠➤,ر✺۠۠➤,د✺۠۠➤,پـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,و✺۠۠➤,کـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,گـ͜͝ـ͜͝ـ͜͝ـ✺۠۠➤,ث✺۠۠➤,ژ✺۠۠➤,ذ✺۠۠➤,آ✺۠۠➤,ئ✺۠۠➤,.,_",
"ضٖـٖٗ⸭ـٖٖٗـٖٗ⸭ٖٗ,صٖـٖٗ⸭ـٖٗـٖٖٗـٖٗ⸭,قـٖٗ⸭ـٖٗـٖٖٗـٖٗ⸭,فٖـٖٗ⸭ـٖٗـٖٖٗـٖٗ⸭,غٖـٖٗ⸭ــٖٖٗـٖٗ⸭,عٖـٖٗ⸭ــٖٖٗـٖٗ⸭,هٖٗ⸭,خٖـٖٗ⸭ـٖٗـٖٖٗـٖٗ⸭,حـٖٗ⸭ــٖٖٗـٖٗ⸭,جـٖٗ⸭ــٖٖٗـٖٗ⸭,شٖـٖٗ⸭ـٖٗـٖٖٗـٖٗ⸭,سٖـٖٗ⸭ــٖٖٗـٖٗ⸭,یـٖٗ⸭ـٖٗـٖٖٗـٖٗ⸭,ٖبـٖٗ⸭ــٖٖٗـٖٗ⸭,ٖلـٖٗ⸭,ـٖٖٗـٖٗا⸭,ٖنـٖٗ⸭ٖٗـٖٖٗـٖٗ⸭,تٖـٖٗ⸭ـٖٖٗـٖٗ⸭,مٖـٖٗ⸭ـٖٗـٖٗ⸭,چـٖٗ⸭ـٖٖٗـٖٗ⸭,ظـٖٗ⸭ـٖٖٗـٖٗ⸭,طـٖٗ⸭ـٖٖٗـٖٗ⸭,ز⸭,ٖرٖٗ⸭,ٖٗ⸭ـٖٖٗـٖٗد⸭,پـٖٗ⸭ـٖٖٗـٖٗ⸭,⸭ـوٖٖٗـٖٗ⸭,ڪـٖٗ⸭ـٖٖٗـٖٗ⸭,گـٖٗ⸭ـٖٖٗـٖٗ⸭,ثـٖٗ⸭ـٖٖٗـٖٗ⸭,ٖٗژ⸭,ٖٗ⸭ـذٖٗ⸭,⸭آ⸭,ئـٖٖٗـٖٗ⸭ـٖٖٗـٖٗ⸭,.,_",
"ِِِِِِْْٰٰٰٰٰٰٖٖٖٖٖٖٖٖٖٖضـ۪ٜـٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡✦,ص۪ٜـ۪ٜـ۪ٜـٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡✦,۪ٜقـ۪ٜـ۪ٜـٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡✦,ف۪ٜـ۪ٜـ۪ٜـٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡✦,۪ٜغـ۪ٜـ۪ٜـٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡✦,عـ۪ٜـ۪ٜـٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡✦,هٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡✦,خ۪ٜـ۪ٜـ۪ٜـٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡✦,خ۪ٜـ۪ٜـ۪ٜـٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡✦,جـ۪ٜـ۪ٜـ۪ٜـٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡✦,ش۪ٜـ۪ٜـ۪ٜـٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡✦,سـ۪ٜـ۪ٜـ۪ٜـٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡✦,یـ۪ٜـ۪ٜـ۪ٜـٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡✦,بـ۪ٜـ۪ٜـ۪ٜـٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡✦,لـ۪ٜـ۪ٜـ۪ٜـٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡✦,۪ٜاٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡✦,نـ۪ٜـ۪ٜـ۪ٜـٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡✦,تـ۪ٜـ۪ٜـ۪ٜـٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡✦,م۪ٜـ۪ٜـٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡✦,چ۪ٜـ۪ٜـ۪ٜـٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡✦,ظ۪ٜـ۪ٜـ۪ٜـٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡✦,طـ۪ٜـ۪ٜـٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡✦,ٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡ز✦,رٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡✦,ٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡د✦,پ۪ٜـ۪ٜـ۪ٜـٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡✦,۪ٜـٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡و✦,ڪـ۪ٜـ۪ٜـ۪ٜـٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡✦,گ۪ٜـ۪ٜـ۪ٜـٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡✦,ث۪ٜـ۪ٜـ۪ٜـٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡✦,ٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡ژ✦,ذٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡✦,آٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡✦,ئـ۪ٜـ۪ٜـ۪ٜـٰٰٰٰٰٰٰٰٰٰٰٰٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪ٜ۪۪۪۪۪۪ٜٜٜٜٖٜٜٜٖٜٖٖٖٖٖٖٖ͜͡✦,.,_",
"ضـٍ͜ـ❉,صـٍ͜ــٍ͜❉,قـٍ͜ــٍ͜ــٍ͜❉,فـٍ͜ـ❉,غـٍ͜ــٍ͜ـ❉,عـٍ͜ــٍ͜ــٍ͜ـ❉,هـٍ͜ـ❉,خـٍ͜ــٍ͜❉,حـٍ͜ــٍ͜ــٍ͜❉,جـٍ͜ـ❉,شـٍ͜ــٍ͜❉,سـٍ͜ــٍ͜ــٍ͜❉,یـٍ͜ـ❉,بـٍ͜ــٍ͜❉,لـٍ͜ــٍ͜❉,ـٍ͜ــٍ͜ــٍ͜ا❉,نـٍ͜ـ❉,تـٍ͜ــٍ͜❉,مـٍ͜ــٍ͜ــٍ͜❉,چـٍ͜ـ❉,ظـٍ͜ــٍ͜❉,طـٍ͜ــٍ͜❉,زٍ͜❉,رٍ͜❉,دٍ͜❉,پـٍ͜ـ❉,وۘ❉,ڪـٍ͜ــٍ͜ــٍ͜❉,گـٍ͜ـ❉,ثـٍ͜ــٍ͜❉,ژً❉,ذٌ❉,آ❉,ئـٍ͜ـ❉,.,_",
"ضـْْـْْـْْ/ْْ,صـْْـْْـ,قْْـْْـْْـْْ/ْْ,فـْْـْْـ,ْْغـْْـْْـْْ/,عْْـْْـْْـْْ,هـْْـْْـْْ/,خْْـْْـْْـ,حْْـْْـْْـْْ/ْْ,جـْْـْْـْْ,شـْْـْْـْْ/ْْ,سـْْـْْـْْ,یـْْـْْـْْ/,بْْـْْـْْـ,لْْـْْـْْـْْ/ْْ,ـْْـْْـْْا,نـْْـْْـْْ/ْْ,تـْْـْْـْْ,مـْْـْْـْْ/ْْ,چْـْْـْْـ,ظْْـْْـْْـْْ/,طْْـْْـْْـْْ,زٌ/,ـْْر,ـْْـْْـدْْ/,پْْـْْـْْـ,ـْْـْْـْْو/ْْ,ڪْـْْـْْـْْ,گـْْـْْـْْ/,ثْْـْْـْْـْْ,ـْْـْْـژْْ/,ْْـْْـْْـذ,آْْ/ْْ,ئـْْـْْـْْـْْـْْ/ْْ,.,_",
"↜ضٍٍـُِ➲ِِனُِ,صـِْـَِ➲َِனِِ,↜ٍٍقـُِ➲ِِனُِ,فـِْـَِ➲َِனِِ↝,↜ٍٍغـُِ➲ِِனُِ,عـِْـَِ➲َِனِِ↝,↜ٍٍهـُِ➲ِِனُِ,خـِْـَِ➲َِனِِ↝,↜ٍٍحـُِ➲ِِனُِ,جـِْـَِ➲َِனِِ↝,↜ٍٍشـُِ➲ِِனُِ,سـِْـَِ➲َِனِِ↝,↜یٍٍـُِ➲ِِனُِ,بـِْـَِ➲َِனِِ↝,↜ٍٍلـُِ➲ِِனُِ,ِْاَِ➲َِனِِ↝,↜نٍٍـُِ➲ِِனُِ,تـِْـَِ➲َِனِِ↝,↜مٍٍـُِ➲ِِனُِ,چـِْـَِ➲َِனِِ↝,↜ظٍٍـُِ➲ِِனُِ,طـِْـَِ➲َِனِِ↝,↜ٍٍـزُِ➲ِِனُِ,ـِْـَِرِ➲َِனِِ↝,↜ٍٍـُِد➲ِِனُِ,پـِْـَِ➲َِனِِ↝,↜ٍٍـُِو➲ِِனُِ,ـِْـَِ➲َِனِِ↝,↜ٍٍڪـُِ➲ِِனُِ,گـِْـَِ➲َِனِِ↝,↜ثٍٍـُِ➲ِِனُِ,ـِْـژَِ➲َِனِِ↝,↜ٍٍـُِذ➲ِِனُِ,آَِ➲َِனِِ↝,↜ٍٍئـُِ➲ِِனُِ↝,.,_",
"ضـ̚͠ــ̵͠ـ̵͠◕̟͠₰̵͕◚̶̶₰͕͔ ,صـ̚͠ــ̵͠◕̟͠₰̵͕◚̶̶₰͕͔,قـ̚͠ــ̵͠ـ̵͠◕̟͠₰̵͕◚̶̶₰͕͔ ,فـ̚͠ــ̵͠◕̟͠₰̵͕◚̶̶₰͕͔,غـ̚͠ــ̵͠ـ̵͠◕̟͠₰̵͕◚̶̶₰͕͔ ,عـ̚͠ــ̵͠◕̟͠₰̵͕◚̶̶₰͕͔,هـ̚͠ــ̵͠ـ̵͠◕̟͠₰̵͕◚̶̶₰͕͔ ,خـ̚͠ــ̵͠◕̟͠₰̵͕◚̶̶₰͕͔,حـ̚͠ــ̵͠ـ̵͠◕̟͠₰̵͕◚̶̶₰͕͔ ,جـ̚͠ــ̵͠◕̟͠₰̵͕◚̶̶₰͕͔,شـ̚͠ــ̵͠ـ̵͠◕̟͠₰̵͕◚̶̶₰͕͔ ,سـ̚͠ــ̵͠◕̟͠₰̵͕◚̶̶₰͕͔,یـ̚͠ــ̵͠ـ̵͠◕̟͠₰̵͕◚̶̶₰͕͔ ,بـ̚͠ــ̵͠◕̟͠₰̵͕◚̶̶₰͕͔,لـ̚͠ــ̵͠ـ̵͠◕̟͠₰̵͕◚̶̶₰͕͔ ,ا✓,ن̚͠ــ̵͠◕̟͠₰̵͕◚̶̶₰͕͔,تـ̚͠ــ̵͠ـ̵͠◕̟͠₰̵͕◚̶̶₰͕͔ ,مـ̚͠ــ̵͠◕̟͠₰̵͕◚̶̶₰͕͔,چـ̚͠ــ̵͠ـ̵͠◕̟͠₰̵͕◚̶̶₰͕͔ ,ظـ̚͠ــ̵͠◕̟͠₰̵͕◚̶̶₰͕͔,طـ̚͠ــ̵͠ـ̵͠◕̟͠₰̵͕◚̶̶₰͕͔ ,̺ز◕̟͠₰̵͕◚̶̶₰͕͔,̚͠رـ̵͠ـ̵͠◕̟͠₰̵͕◚̶̶₰͕͔ ,د̵͠◕̟͠₰ ,پـ̚͠ــ̵͠ـ̵͠◕̟͠₰̵͕◚̶̶₰͕͔ ,ـ̚͠ــ̵͠و̺◕̟͠₰̵͕◚̶̶₰͕͔,ڪـ̚͠ــ̵͠ـ̵͠◕̟͠₰̵͕◚̶̶₰͕͔ ,گـ̚͠ــ̵͠◕̟͠₰̵͕◚̶̶₰͕͔,ثـ̚͠ــ̵͠ـ̵͠◕̟͠₰̵͕◚̶̶₰͕͔ ,ژ◕̟͠₰̵͕◚̶̶₰͕͔,ـ̚͠ـذـ̵͠ـ̵͠◕̟͠₰̵͕◚̶̶₰͕͔ ,آ✓,ئـ̚͠ــ̵͠◕̟͠₰̵͕◚̶̶₰͕͔,.,_",
"ضـٰٓـًً◑ِّ◑ًً, صـུـٜٜ◑ِّ◑ًً,قـٰٓـًً◑ِّ◑ًً, فـུـٜٜ◑ِّ◑ًً,غـٰٓـًً◑ِّ◑ًً, عـུـٜٜ◑ِّ◑ًً,هـٰٓـًً◑ِّ◑ًً, خـུـٜٜ◑ِّ◑ًً,حـٰٓـًً◑ِّ◑ًً, جـུـٜٜ◑ِّ◑ًً,شـٰٓـًً◑ِّ◑ًً, سـུـٜٜ◑ِّ◑ًً,یـٰٓـًً◑ِّ◑ًً, بـུـٜٜ◑ِّ◑ًً,لـٰٓـًً◑ِّ◑ًً, ا◑ِّ◑ًً,نـٰٓـًً◑ِّ◑ًً, تـུـٜٜ◑ِّ◑ًً,مـٰٓـًً◑ِّ◑ًً, چـུـٜٜ◑ِّ◑ًً,ظـٰٓـًً◑ِّ◑ًً, طـུـٜٜ◑ِّ◑ًً,ز◑ِّ◑ًً,رٜٜ◑ِّ◑ًً,د◑ِّ◑ًً, پـུـٜٜ◑ِّ◑ًً,وًً◑ِّ◑ًً, ڪـུـٜٜ◑ِّ◑ًً,گـٰٓـًً◑ِّ◑ًً, ثـུـٜٜ◑ِّ◑ًً,ژ◑ِّ◑ًً,ذٜٜ◑ِّ◑ًً,ا◑ِّ◑ًً, ئـུـٜٜ◑ِّ◑ًً,.,_",
"ضـ͜͡ـ͜͡✭,صـ͜͡ـ͜͡✭,قـ͜͡ـ͜͡ـ͜͡✭,فــ͜͡ـ͜͡✭,غـ͜͡ـ͜͡✭,عـ͜͡ـ͜͡✭,هـ͜͡ـ͜͡ـ͜͡✭,خــ͜͡ـ͜͡✭,حـ͜͡ـ͜͡✭,جـ͜͡ـ͜͡✭,شـ͜͡ـ͜͡ـ͜͡✭,ســ͜͡ـ͜͡✭,یـ͜͡ـ͜͡✭,بـ͜͡ـ͜͡✭,لـ͜͡ـ͜͡ـ͜͡✭,͜͡ا✭,نـ͜͡ـ͜͡✭,تـ͜͡ـ͜͡✭,مـ͜͡ـ͜͡ـ͜͡✭,چــ͜͡ـ͜͡✭,ظـ͜͡ـ͜͡✭,طـ͜͡ـ͜͡✭,ز͜͡✭,͜͡ر✭,͜͡د✭,پـ͜͡ـ͜͡✭,ـ͜͡و͜͡ـ͜͡✭,ڪــ͜͡ـ͜͡✭,گـ͜͡ـ͜͡✭,ـ͜͡ـ͜͡✭,ثـ͜͡ـ͜͡ـ͜͡✭,ـ͜͡ژ͜͡✭,ذ✭,آ✭,ئـ͜͡ـ͜͡ـ͜͡✭,.,_",
"ضـًٍـؒؔـؒؔ⸙ؒৡ✪,صـًٍـؒؔـؒؔ⸙ؒৡ✪,قـًٍـؒؔـؒؔ⸙ؒৡ✪,فـًٍـؒؔـؒؔ⸙ؒৡ✪,غـًٍـؒؔـؒؔ⸙ؒৡ✪,عـًٍـؒؔـؒؔ⸙ؒৡ✪,هـًٍـؒؔـؒؔ⸙ؒৡ✪,خـًٍـؒؔـؒؔ⸙ؒৡ✪,حـًٍـؒؔـؒؔ⸙ؒৡ✪,جـًٍـؒؔـؒؔ⸙ؒৡ✪,شـًٍـؒؔـؒؔ⸙ؒৡ✪,سـًٍـؒؔـؒؔ⸙ؒৡ✪,یـًٍـؒؔـؒؔ⸙ؒৡ✪,بـًٍـؒؔـؒؔ⸙ؒৡ✪,لـًٍـؒؔـؒؔ⸙ؒৡ✪,ا✪,نـًٍـؒؔـؒؔ⸙ؒৡ✪,تـًٍـؒؔـؒؔ⸙ؒৡ✪,مـًٍـؒؔـؒؔ⸙ؒৡ✪,چـًٍـؒؔـؒؔ⸙ؒৡ✪,ظـًٍـؒؔـؒؔ⸙ؒৡ✪,طـًٍـؒؔـؒؔ⸙ؒৡ✪,ز✪,ر✪,د✪,پـًٍـؒؔـؒؔ⸙ؒৡ✪,و✪,ڪـًٍـؒؔـؒؔ⸙ؒৡ✪,گـًٍـؒؔـؒؔ⸙ؒৡ✪,ثـًٍـؒؔـؒؔ⸙ؒৡ✪,ژ✪,ذ✪,آ✪,ئـًٍـؒؔـؒؔ⸙ؒৡ✪,.,_",
"ضـ◎۪۪❖ुؔ,صـ◎۪۪❖ुؔ,قـ◎۪۪❖ुؔ,فـ◎۪۪❖ुؔ,غـ◎۪۪❖ुؔ,عـ◎۪۪❖ुؔ,هـ◎۪۪❖ुؔ,خـ◎۪۪❖ुؔ,حـ◎۪۪❖ुؔ,جـ◎۪۪❖ु,شـ◎۪۪❖ु,سـ◎۪۪❖ु,یـ◎۪۪❖ु,بـ◎۪۪❖ु,لـ◎۪۪❖ु,ا◎۪۪❖ु,نـ◎۪۪❖ु,تـ◎۪۪❖ु,مـ◎۪۪❖ु,چـ◎۪۪❖ु,ظـ◎۪۪❖ु,طـ◎۪۪❖ु,ز◎۪۪❖ु,ر◎۪۪❖ु,د◎۪۪❖ु,پـ◎۪۪❖ु,و◎۪۪❖ु,ڪـ◎۪۪❖ु,گـ◎۪۪❖ु,ثـ◎۪۪❖ु,ژ◎۪۪❖ु,ذ◎۪۪❖ु,آ◎۪۪❖ु,ئـ◎۪۪❖ु,.,_",
"ض۪ٓـٌْ‌ٍٖـ۪ٓـٌْ‌ٍٖ,صــ۪ٓـٌْ‌ٍٖ,‌ قـ۪ٓـٌْ‌ٍٖـ۪ٓ,فـٌْ‌ٍٖـ۪ٓ,غـٌْ‌ٍٖـ۪ٓ,عـٌْ‌ٍٖـ۪ٓ,هـٌْ‌ٍٖـ۪ٓ,خـٌْ‌ٍٖـ۪ٓ,حـٌْ‌ٍٖـ۪ٓ,جـٌْ‌ٍٖـ۪ٓ,شـٌْ‌ٍٖـ۪ٓ,سـٌْ‌ٍٖـ۪ٓ,یـٌْ‌ٍٖـ۪ٓ,بـٌْ‌ٍٖـ۪ٓ,لـٌْ‌ٍٖـ۪ٓ,اٌْ‌ٍٖـ۪ٓ,نـٌْ‌ٍٖـ۪ٓ,تـٌْ‌ٍٖـ۪ٓ,مـٌْ‌ٍٖـ۪ٓ,چـٌْ‌ٍٖـ۪ٓ,ظـٌْ‌ٍٖـ۪ٓ,طـٌْ‌ٍٖـ۪ٓ,زुـ۪ٓ,رٌْ‌ٍٖـ۪ٓ,دुـ۪ٓ,پـٌْ‌ٍٖـ۪ٓ,وुـ۪ٓ,ڪـٌْ‌ٍٖـ۪ٓ,گـٌْ‌ٍٖـ۪ٓ,ثـٌْ‌ٍٖـ۪ٓ,ژुـ۪ٓ,ذـٌْ‌ٍٖـ۪ٓ,آुـ۪ٓ,ئـٌْ‌ٍٖـ۪ٓ,.,_",
"ضِْـِْ❉,ِْصـِْ❉,قِْـِْ❉,ِْفـِْ❉,غِْـِْ❉,ِْعـِْ❉,ِْهـِْ❉,ِْخـِْ❉,ِْحـِْ❉,ِْجـِْ❉,ِْشـِْ❉,ِْسـِْ❉,یِْـِْ❉,بِْـِْ❉,لِْـِْ❉,ِْاـِْ❉,نِْـِْ❉,ِْتـِْ❉,ِْمـِْ❉,ِْچـِْ❉,ِْظـِْ❉,طِْـِْ❉,زِْـِْ❉,رِْـِْ❉,ِْدـِْ❉,پِْـِْ❉,وِْـِْ❉,ِْکـِْ❉,ِْگـِْ❉,ِْثـِْ❉,ِْژـِْ❉,ِْذـِْ❉,ِْآـِْ❉,ِْئـِْ❉,.,_",
"[ِْـِْضـِْ❉ِْـِْ,[ِْـِْصـِْ❉ِْـِْ,[ِْـِْقـِْ❉ِْـِْ,[ِْـِْفـِْ❉ِْـِْ,[ِْـغِْـِْ❉ِْـِْ,[ِْـعِْـِْ❉ِْـِْ,[ِْـهِْـِْ❉ِْـِْ,[ِْـِْخـِْ❉ِْـِْ,[ِْـِْحـِْ❉ِْـِْ,[ِْـِْجـِْ❉ِْـِْ,[ِْـِْشـِْ❉ِْـِْ,[ِْـِْسـِْ❉ِْـِْ,[ِْـِْیـِْ❉ِْـِْ,[ِْـِْبـِْ❉ِْـِْ,[ِْـلِْـِْ❉ِْـِْ,[ِْـاِْـِْ❉ِْـِْ,[ِْـِْنـِْ❉ِْـِْ,[ِْـِْتـِْ❉ِْـِْ,[ِْـمِْـِْ❉ِْـِْ,[ِْـچِْـِْ❉ِْـِْ,[ِْـِْظـِْ❉ِْـِْ,[ِْـِْطـِْ❉ِْـِْ,[ِْـِْزـِْ❉ِْـِْ,[ِْـرِْـِْ❉ِْـِْ,[ِْـِْدـِْ❉ِْـِْ,[ِْـپِْـِْ❉ِْـِْ,[ِْـِْوـِِْْ❉ِْـِْ,[ِْـڪِْـِْ❉ِْـِْ,[ِْـگِْـِْ❉ِْـِْ,[ِْـِْثـِْ❉ِْـِْ,[ِْـِْژـِْ❉ِْـِْ,[ِْـذِْـِْ❉ِْـِْ,[ِْـآِْـِْ❉ِْـِْ,[ِْـِْئـِْ❉ِْـِْ,.,_",
"❅ضـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅صـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅قـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅فـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅غـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅عـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅هـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅خـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅حـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅جـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅شـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅سـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅یـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅بـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅لـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅اؒؔ❢,❅نـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅تـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅مـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅چـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅ظـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅طـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅ـ۪۪ـؒؔـزؒؔـ۪۪ـؒؔـؒؔ❢,❅ـ۪۪ـؒؔـؒؔرـ۪۪ـؒؔـؒؔ❢,❅ـ۪۪ـؒؔـدؒؔـ۪۪ـؒؔـؒؔ❢,❅پـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅ـ۪۪ـؒؔـؒؔوـ۪۪ـؒؔـؒؔ❢,❅ڪـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅گـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅ثـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,❅ـ۪۪ـؒؔـژؒؔـ۪۪ـؒؔـؒؔ❢,❅ـ۪۪ـؒؔـذؒؔـ۪۪ـؒؔـؒؔ❢,❅۪۪آؒؔ❢,❅ئـ۪۪ـؒؔـؒؔـ۪۪ـؒؔـؒؔ❢,.,_",
"ضٖؒـؒؔـٰٰـٖٖ,صٖؒـؒؔـٰٰـٖٖ,قٖؒـؒؔـٰٰـٖٖ,فٖؒـؒؔـٰٰـٖٖ,غٖؒـؒؔـٰٰـٖٖ,عٖؒـؒؔـٰٰـٖٖ,هٖؒـؒؔـٰٰـٖٖ,خٖؒـؒؔـٰٰـٖٖ,حٖؒـؒؔـٰٰـٖٖ,جٖؒـؒؔـٰٰـٖٖ,شٖؒـؒؔـٰٰـٖٖ,سٖؒـؒؔـٰٰـٖٖ,یٖؒـؒؔـٰٰـٖٖ,بٖؒـؒؔـٰٰـٖٖ,لٖؒـؒؔـٰٰـٖٖ,اٖؒـؒؔـٰٰـٖٖ,نٖؒـؒؔـٰٰـٖٖ,تٖؒـؒؔـٰٰـٖٖ,مٖؒـؒؔـٰٰـٖٖ,چٖؒـؒؔـٰٰـٖٖ,ظٖؒـؒؔـٰٰـٖٖ,طٖؒـؒؔـٰٰـٖٖ,زٖؒـؒؔـٰٰـٖٖ,رٖؒـؒؔـٰٰـٖٖ,دٖؒـؒؔـٰٰـٖٖ,پٖؒـؒؔـٰٰـٖٖ,وٖؒـؒؔـٰٰـٖٖ,کٖؒـؒؔـٰٰـٖٖ,گٖؒـؒؔـٰٰـٖٖ,ثٖؒـؒؔـٰٰـٖٖ,ژٖؒـؒؔـٰٰـٖٖ,ذٖؒـؒؔـٰٰـٖٖ,آٖؒـؒؔـٰٰـٖٖ,ئٖؒـؒؔـٰٰـٖٖ,.ٖؒـؒؔـٰٰـٖٖ,_"
}
FonTen = {
"ⓐ,ⓑ,ⓒ,ⓓ,ⓔ,ⓕ,ⓖ,ⓗ,ⓘ,ⓙ,ⓚ,ⓛ,ⓜ,ⓝ,ⓞ,ⓟ,ⓠ,ⓡ,ⓢ,ⓣ,ⓤ,ⓥ,ⓦ,ⓧ,ⓨ,ⓩ,ⓐ,ⓑ,ⓒ,ⓓ,ⓔ,ⓕ,ⓖ,ⓗ,ⓘ,ⓙ,ⓚ,ⓛ,ⓜ,ⓝ,ⓞ,ⓟ,ⓠ,ⓡ,ⓢ,ⓣ,ⓤ,ⓥ,ⓦ,ⓧ,ⓨ,ⓩ,⓪,➈,➇,➆,➅,➄,➃,➂,➁,➀,●,_",
"⒜,⒝,⒞,⒟,⒠,⒡,⒢,⒣,⒤,⒥,⒦,⒧,⒨,⒩,⒪,⒫,⒬,⒭,⒮,⒯,⒰,⒱,⒲,⒳,⒴,⒵,⒜,⒝,⒞,⒟,⒠,⒡,⒢,⒣,⒤,⒥,⒦,⒧,⒨,⒩,⒪,⒫,⒬,⒭,⒮,⒯,⒰,⒱,⒲,⒳,⒴,⒵,⓪,⑼,⑻,⑺,⑹,⑸,⑷,⑶,⑵,⑴,.,_",
"α,в,c,∂,є,ƒ,g,н,ι,נ,к,ℓ,м,η,σ,ρ,q,я,ѕ,т,υ,ν,ω,χ,у,z,α,в,c,∂,є,ƒ,g,н,ι,נ,к,ℓ,м,η,σ,ρ,q,я,ѕ,т,υ,ν,ω,χ,у,z,0,9,8,7,6,5,4,3,2,1,.,_",
"α,в,c,d,e,ғ,ɢ,н,ι,j,ĸ,l,м,ɴ,o,p,q,r,ѕ,т,υ,v,w,х,y,z,α,в,c,d,e,ғ,ɢ,н,ι,j,ĸ,l,м,ɴ,o,p,q,r,ѕ,т,υ,v,w,х,y,z,0,9,8,7,6,5,4,3,2,1,.,_",
"α,в,¢,đ,e,f,g,ħ,ı,נ,κ,ł,м,и,ø,ρ,q,я,š,т,υ,ν,ω,χ,ч,z,α,в,¢,đ,e,f,g,ħ,ı,נ,κ,ł,м,и,ø,ρ,q,я,š,т,υ,ν,ω,χ,ч,z,0,9,8,7,6,5,4,3,2,1,.,_",
"ą,ҍ,ç,ժ,ҽ,ƒ,ց,հ,ì,ʝ,ҟ,Ӏ,ʍ,ղ,օ,ք,զ,ɾ,ʂ,է,մ,ѵ,ա,×,վ,Հ,ą,ҍ,ç,ժ,ҽ,ƒ,ց,հ,ì,ʝ,ҟ,Ӏ,ʍ,ղ,օ,ք,զ,ɾ,ʂ,է,մ,ѵ,ա,×,վ,Հ,⊘,९,𝟠,7,Ϭ,Ƽ,५,Ӡ,ϩ,𝟙,.,_",		"ค,ც,८,ძ,૯,Բ,૭,Һ,ɿ,ʆ,қ,Ն,ɱ,Ո,૦,ƿ,ҩ,Ր,ς,੮,υ,౮,ω,૪,ע,ઽ,ค,ც,८,ძ,૯,Բ,૭,Һ,ɿ,ʆ,қ,Ն,ɱ,Ո,૦,ƿ,ҩ,Ր,ς,੮,υ,౮,ω,૪,ע,ઽ,0,9,8,7,6,5,4,3,2,1,.,_",
"α,ß,ς,d,ε,ƒ,g,h,ï,յ,κ,ﾚ,m,η,⊕,p,Ω,r,š,†,u,∀,ω,x,ψ,z,α,ß,ς,d,ε,ƒ,g,h,ï,յ,κ,ﾚ,m,η,⊕,p,Ω,r,š,†,u,∀,ω,x,ψ,z,0,9,8,7,6,5,4,3,2,1,.,_",
"ค,๒,ς,๔,є,Ŧ,ɠ,ђ,เ,ן,к,l,๓,ภ,๏,թ,ợ,г,ร,t,ย,v,ฬ,x,ץ,z,ค,๒,ς,๔,є,Ŧ,ɠ,ђ,เ,ן,к,l,๓,ภ,๏,թ,ợ,г,ร,t,ย,v,ฬ,x,ץ,z,0,9,8,7,6,5,4,3,2,1,.,_",
"ﾑ,乃,ζ,Ð,乇,ｷ,Ǥ,ん,ﾉ,ﾌ,ズ,ﾚ,ᄊ,刀,Ծ,ｱ,Q,尺,ㄎ,ｲ,Ц,Џ,Щ,ﾒ,ﾘ,乙,ﾑ,乃,ζ,Ð,乇,ｷ,Ǥ,ん,ﾉ,ﾌ,ズ,ﾚ,ᄊ,刀,Ծ,ｱ,q,尺,ㄎ,ｲ,Ц,Џ,Щ,ﾒ,ﾘ,乙,ᅙ,9,8,ᆨ,6,5,4,3,ᆯ,1,.,_",
"α,β,c,δ,ε,Ŧ,ĝ,h,ι,j,κ,l,ʍ,π,ø,ρ,φ,Ʀ,$,†,u,υ,ω,χ,ψ,z,α,β,c,δ,ε,Ŧ,ĝ,h,ι,j,κ,l,ʍ,π,ø,ρ,φ,Ʀ,$,†,u,υ,ω,χ,ψ,z,0,9,8,7,6,5,4,3,2,1,.,_",
"ձ,ъ,ƈ,ժ,ε,բ,ց,հ,ﻨ,յ,ĸ,l,ო,ռ,օ,թ,զ,г,ร,է,ս,ν,ա,×,ყ,২,ձ,ъ,ƈ,ժ,ε,բ,ց,հ,ﻨ,յ,ĸ,l,ო,ռ,օ,թ,զ,г,ร,է,ս,ν,ա,×,ყ,২,0,9,8,7,6,5,4,3,2,1,.,_",
"Λ,ɓ,¢,Ɗ,£,ƒ,ɢ,ɦ,ĩ,ʝ,Қ,Ł,ɱ,ה,ø,Ṗ,Ҩ,Ŕ,Ş,Ŧ,Ū,Ɣ,ω,Ж,¥,Ẑ,Λ,ɓ,¢,Ɗ,£,ƒ,ɢ,ɦ,ĩ,ʝ,Қ,Ł,ɱ,ה,ø,Ṗ,Ҩ,Ŕ,Ş,Ŧ,Ū,Ɣ,ω,Ж,¥,Ẑ,0,9,8,7,6,5,4,3,2,1,.,_",
"Λ,Б,Ͼ,Ð,Ξ,Ŧ,G,H,ł,J,К,Ł,M,Л,Ф,P,Ǫ,Я,S,T,U,V,Ш,Ж,Џ,Z,Λ,Б,Ͼ,Ð,Ξ,Ŧ,g,h,ł,j,К,Ł,m,Л,Ф,p,Ǫ,Я,s,t,u,v,Ш,Ж,Џ,z,0,9,8,7,6,5,4,3,2,1,.,_",
"ɐ,q,ɔ,p,ǝ,ɟ,ɓ,ɥ,ı,ſ,ʞ,ๅ,ɯ,u,o,d,b,ɹ,s,ʇ,n,ʌ,ʍ,x,ʎ,z,ɐ,q,ɔ,p,ǝ,ɟ,ɓ,ɥ,ı,ſ,ʞ,ๅ,ɯ,u,o,d,b,ɹ,s,ʇ,n,ʌ,ʍ,x,ʎ,z,0,9,8,7,6,5,4,3,2,1,.,_",
"ɒ,d,ɔ,b,ɘ,ʇ,ϱ,н,i,į,ʞ,l,м,и,o,q,p,я,ƨ,т,υ,v,w,x,γ,z,ɒ,d,ɔ,b,ɘ,ʇ,ϱ,н,i,į,ʞ,l,м,и,o,q,p,я,ƨ,т,υ,v,w,x,γ,z,0,9,8,7,6,5,4,3,2,1,.,_",
"A̴,̴B̴,̴C̴,̴D̴,̴E̴,̴F̴,̴G̴,̴H̴,̴I̴,̴J̴,̴K̴,̴L̴,̴M̴,̴N̴,̴O̴,̴P̴,̴Q̴,̴R̴,̴S̴,̴T̴,̴U̴,̴V̴,̴W̴,̴X̴,̴Y̴,̴Z̴,̴a̴,̴b̴,̴c̴,̴d̴,̴e̴,̴f̴,̴g̴,̴h̴,̴i̴,̴j̴,̴k̴,̴l̴,̴m̴,̴n̴,̴o̴,̴p̴,̴q̴,̴r̴,̴s̴,̴t̴,̴u̴,̴v̴,̴w̴,̴x̴,̴y̴,̴z̴,̴0̴,̴9̴,̴8̴,̴7̴,̴6̴,̴5̴,̴4̴,̴3̴,̴2̴,̴1̴,̴.̴,̴_̴",
"ⓐ,ⓑ,ⓒ,ⓓ,ⓔ,ⓕ,ⓖ,ⓗ,ⓘ,ⓙ,ⓚ,ⓛ,ⓜ,ⓝ,ⓞ,ⓟ,ⓠ,ⓡ,ⓢ,ⓣ,ⓤ,ⓥ,ⓦ,ⓧ,ⓨ,ⓩ,ⓐ,ⓑ,ⓒ,ⓓ,ⓔ,ⓕ,ⓖ,ⓗ,ⓘ,ⓙ,ⓚ,ⓛ,ⓜ,ⓝ,ⓞ,ⓟ,ⓠ,ⓡ,ⓢ,ⓣ,ⓤ,ⓥ,ⓦ,ⓧ,ⓨ,ⓩ,⓪,➈,➇,➆,➅,➄,➃,➂,➁,➀,●,_",
"⒜,⒝,⒞,⒟,⒠,⒡,⒢,⒣,⒤,⒥,⒦,⒧,⒨,⒩,⒪,⒫,⒬,⒭,⒮,⒯,⒰,⒱,⒲,⒳,⒴,⒵,⒜,⒝,⒞,⒟,⒠,⒡,⒢,⒣,⒤,⒥,⒦,⒧,⒨,⒩,⒪,⒫,⒬,⒭,⒮,⒯,⒰,⒱,⒲,⒳,⒴,⒵,⓪,⑼,⑻,⑺,⑹,⑸,⑷,⑶,⑵,⑴,.,_",
"α,в,c,∂,є,ƒ,g,н,ι,נ,к,ℓ,м,η,σ,ρ,q,я,ѕ,т,υ,ν,ω,χ,у,z,α,в,c,∂,є,ƒ,g,н,ι,נ,к,ℓ,м,η,σ,ρ,q,я,ѕ,т,υ,ν,ω,χ,у,z,0,9,8,7,6,5,4,3,2,1,.,_",
"α,в,c,ɗ,є,f,g,н,ι,נ,к,Ɩ,м,η,σ,ρ,q,я,ѕ,т,υ,ν,ω,x,у,z,α,в,c,ɗ,є,f,g,н,ι,נ,к,Ɩ,м,η,σ,ρ,q,я,ѕ,т,υ,ν,ω,x,у,z,0,9,8,7,6,5,4,3,2,1,.,_",
"α,в,c,d,e,ғ,ɢ,н,ι,j,ĸ,l,м,ɴ,o,p,q,r,ѕ,т,υ,v,w,х,y,z,α,в,c,d,e,ғ,ɢ,н,ι,j,ĸ,l,м,ɴ,o,p,q,r,ѕ,т,υ,v,w,х,y,z,0,9,8,7,6,5,4,3,2,1,.,_",
"α,Ⴆ,ƈ,ԃ,ҽ,ϝ,ɠ,ԋ,ι,ʝ,ƙ,ʅ,ɱ,ɳ,σ,ρ,ϙ,ɾ,ʂ,ƚ,υ,ʋ,ɯ,x,ყ,ȥ,α,Ⴆ,ƈ,ԃ,ҽ,ϝ,ɠ,ԋ,ι,ʝ,ƙ,ʅ,ɱ,ɳ,σ,ρ,ϙ,ɾ,ʂ,ƚ,υ,ʋ,ɯ,x,ყ,ȥ,0,9,8,7,6,5,4,3,2,1,.,_",
"α,в,¢,đ,e,f,g,ħ,ı,נ,κ,ł,м,и,ø,ρ,q,я,š,т,υ,ν,ω,χ,ч,z,α,в,¢,đ,e,f,g,ħ,ı,נ,κ,ł,м,и,ø,ρ,q,я,š,т,υ,ν,ω,χ,ч,z,0,9,8,7,6,5,4,3,2,1,.,_",
"ą,ɓ,ƈ,đ,ε,∱,ɠ,ɧ,ï,ʆ,ҡ,ℓ,ɱ,ŋ,σ,þ,ҩ,ŗ,ş,ŧ,ų,√,щ,х,γ,ẕ,ą,ɓ,ƈ,đ,ε,∱,ɠ,ɧ,ï,ʆ,ҡ,ℓ,ɱ,ŋ,σ,þ,ҩ,ŗ,ş,ŧ,ų,√,щ,х,γ,ẕ,0,9,8,7,6,5,4,3,2,1,.,_",
"ą,ҍ,ç,ժ,ҽ,ƒ,ց,հ,ì,ʝ,ҟ,Ӏ,ʍ,ղ,օ,ք,զ,ɾ,ʂ,է,մ,ѵ,ա,×,վ,Հ,ą,ҍ,ç,ժ,ҽ,ƒ,ց,հ,ì,ʝ,ҟ,Ӏ,ʍ,ղ,օ,ք,զ,ɾ,ʂ,է,մ,ѵ,ա,×,վ,Հ,⊘,९,𝟠,7,Ϭ,Ƽ,५,Ӡ,ϩ,𝟙,.,_",
"მ,ჩ,ƈ,ძ,ε,բ,ց,հ,ἶ,ʝ,ƙ,l,ო,ղ,օ,ր,գ,ɾ,ʂ,է,մ,ν,ω,ჯ,ყ,z,მ,ჩ,ƈ,ძ,ε,բ,ց,հ,ἶ,ʝ,ƙ,l,ო,ղ,օ,ր,գ,ɾ,ʂ,է,մ,ν,ω,ჯ,ყ,z,0,Գ,Ց,Դ,6,5,Վ,Յ,Զ,1,.,_",
"ค,ც,८,ძ,૯,Բ,૭,Һ,ɿ,ʆ,қ,Ն,ɱ,Ո,૦,ƿ,ҩ,Ր,ς,੮,υ,౮,ω,૪,ע,ઽ,ค,ც,८,ძ,૯,Բ,૭,Һ,ɿ,ʆ,қ,Ն,ɱ,Ո,૦,ƿ,ҩ,Ր,ς,੮,υ,౮,ω,૪,ע,ઽ,0,9,8,7,6,5,4,3,2,1,.,_",
"α,ß,ς,d,ε,ƒ,g,h,ï,յ,κ,ﾚ,m,η,⊕,p,Ω,r,š,†,u,∀,ω,x,ψ,z,α,ß,ς,d,ε,ƒ,g,h,ï,յ,κ,ﾚ,m,η,⊕,p,Ω,r,š,†,u,∀,ω,x,ψ,z,0,9,8,7,6,5,4,3,2,1,.,_",
"ª,b,¢,Þ,È,F,૬,ɧ,Î,j,Κ,Ļ,м,η,◊,Ƿ,ƍ,r,S,⊥,µ,√,w,×,ý,z,ª,b,¢,Þ,È,F,૬,ɧ,Î,j,Κ,Ļ,м,η,◊,Ƿ,ƍ,r,S,⊥,µ,√,w,×,ý,z,0,9,8,7,6,5,4,3,2,1,.,_",
"Δ,Ɓ,C,D,Σ,F,G,H,I,J,Ƙ,L,Μ,∏,Θ,Ƥ,Ⴓ,Γ,Ѕ,Ƭ,Ʊ,Ʋ,Ш,Ж,Ψ,Z,λ,ϐ,ς,d,ε,ғ,ɢ,н,ι,ϳ,κ,l,ϻ,π,σ,ρ,φ,г,s,τ,υ,v,ш,ϰ,ψ,z,0,9,8,7,6,5,4,3,2,1,.,_",
"ค,๒,ς,๔,є,Ŧ,ɠ,ђ,เ,ן,к,l,๓,ภ,๏,թ,ợ,г,ร,t,ย,v,ฬ,x,ץ,z,ค,๒,ς,๔,є,Ŧ,ɠ,ђ,เ,ן,к,l,๓,ภ,๏,թ,ợ,г,ร,t,ย,v,ฬ,x,ץ,z,0,9,8,7,6,5,4,3,2,1,.,_",
"Λ,ß,Ƈ,D,Ɛ,F,Ɠ,Ĥ,Ī,Ĵ,Ҡ,Ŀ,M,И,♡,Ṗ,Ҩ,Ŕ,S,Ƭ,Ʊ,Ѵ,Ѡ,Ӿ,Y,Z,Λ,ß,Ƈ,D,Ɛ,F,Ɠ,Ĥ,Ī,Ĵ,Ҡ,Ŀ,M,И,♡,Ṗ,Ҩ,Ŕ,S,Ƭ,Ʊ,Ѵ,Ѡ,Ӿ,Y,Z,0,9,8,7,6,5,4,3,2,1,.,_",
"ﾑ,乃,ζ,Ð,乇,ｷ,Ǥ,ん,ﾉ,ﾌ,ズ,ﾚ,ᄊ,刀,Ծ,ｱ,Q,尺,ㄎ,ｲ,Ц,Џ,Щ,ﾒ,ﾘ,乙,ﾑ,乃,ζ,Ð,乇,ｷ,Ǥ,ん,ﾉ,ﾌ,ズ,ﾚ,ᄊ,刀,Ծ,ｱ,q,尺,ㄎ,ｲ,Ц,Џ,Щ,ﾒ,ﾘ,乙,ᅙ,9,8,ᆨ,6,5,4,3,ᆯ,1,.,_",
"α,β,c,δ,ε,Ŧ,ĝ,h,ι,j,κ,l,ʍ,π,ø,ρ,φ,Ʀ,$,†,u,υ,ω,χ,ψ,z,α,β,c,δ,ε,Ŧ,ĝ,h,ι,j,κ,l,ʍ,π,ø,ρ,φ,Ʀ,$,†,u,υ,ω,χ,ψ,z,0,9,8,7,6,5,4,3,2,1,.,_",
"ค,๖,¢,໓,ē,f,ງ,h,i,ว,k,l,๓,ຖ,໐,p,๑,r,Ş,t,น,ง,ຟ,x,ฯ,ຊ,ค,๖,¢,໓,ē,f,ງ,h,i,ว,k,l,๓,ຖ,໐,p,๑,r,Ş,t,น,ง,ຟ,x,ฯ,ຊ,0,9,8,7,6,5,4,3,2,1,.,_",
"ձ,ъ,ƈ,ժ,ε,բ,ց,հ,ﻨ,յ,ĸ,l,ო,ռ,օ,թ,զ,г,ร,է,ս,ν,ա,×,ყ,২,ձ,ъ,ƈ,ժ,ε,բ,ց,հ,ﻨ,յ,ĸ,l,ო,ռ,օ,թ,զ,г,ร,է,ս,ν,ա,×,ყ,২,0,9,8,7,6,5,4,3,2,1,.,_",
"Â,ß,Ĉ,Ð,Є,Ŧ,Ǥ,Ħ,Ī,ʖ,Қ,Ŀ,♏,И,Ø,P,Ҩ,R,$,ƚ,Ц,V,Щ,X,￥,Ẕ,Â,ß,Ĉ,Ð,Є,Ŧ,Ǥ,Ħ,Ī,ʖ,Қ,Ŀ,♏,И,Ø,P,Ҩ,R,$,ƚ,Ц,V,Щ,X,￥,Ẕ,0,9,8,7,6,5,4,3,2,1,.,_",
"Λ,ɓ,¢,Ɗ,£,ƒ,ɢ,ɦ,ĩ,ʝ,Қ,Ł,ɱ,ה,ø,Ṗ,Ҩ,Ŕ,Ş,Ŧ,Ū,Ɣ,ω,Ж,¥,Ẑ,Λ,ɓ,¢,Ɗ,£,ƒ,ɢ,ɦ,ĩ,ʝ,Қ,Ł,ɱ,ה,ø,Ṗ,Ҩ,Ŕ,Ş,Ŧ,Ū,Ɣ,ω,Ж,¥,Ẑ,0,9,8,7,6,5,4,3,2,1,.,_",
"Λ,Б,Ͼ,Ð,Ξ,Ŧ,G,H,ł,J,К,Ł,M,Л,Ф,P,Ǫ,Я,S,T,U,V,Ш,Ж,Џ,Z,Λ,Б,Ͼ,Ð,Ξ,Ŧ,g,h,ł,j,К,Ł,m,Л,Ф,p,Ǫ,Я,s,t,u,v,Ш,Ж,Џ,z,0,9,8,7,6,5,4,3,2,1,.,_",
"Թ,Յ,Շ,Ժ,ȝ,Բ,Գ,ɧ,ɿ,ʝ,ƙ,ʅ,ʍ,Ռ,Ծ,ρ,φ,Ր,Տ,Ե,Մ,ע,ա,Ճ,Վ,Հ,Թ,Յ,Շ,Ժ,ȝ,Բ,Գ,ɧ,ɿ,ʝ,ƙ,ʅ,ʍ,Ռ,Ծ,ρ,φ,Ր,Տ,Ե,Մ,ע,ա,Ճ,Վ,Հ,0,9,8,7,6,5,4,3,2,1,.,_",
"Æ,þ,©,Ð,E,F,ζ,Ħ,Ї,¿,ズ,ᄂ,M,Ñ,Θ,Ƿ,Ø,Ґ,Š,τ,υ,¥,w,χ,y,շ,Æ,þ,©,Ð,E,F,ζ,Ħ,Ї,¿,ズ,ᄂ,M,Ñ,Θ,Ƿ,Ø,Ґ,Š,τ,υ,¥,w,χ,y,շ,0,9,8,7,6,5,4,3,2,1,.,_",
"ɐ,q,ɔ,p,ǝ,ɟ,ɓ,ɥ,ı,ſ,ʞ,ๅ,ɯ,u,o,d,b,ɹ,s,ʇ,n,ʌ,ʍ,x,ʎ,z,ɐ,q,ɔ,p,ǝ,ɟ,ɓ,ɥ,ı,ſ,ʞ,ๅ,ɯ,u,o,d,b,ɹ,s,ʇ,n,ʌ,ʍ,x,ʎ,z,0,9,8,7,6,5,4,3,2,1,.,_",
"ɒ,d,ɔ,b,ɘ,ʇ,ϱ,н,i,į,ʞ,l,м,и,o,q,p,я,ƨ,т,υ,v,w,x,γ,z,ɒ,d,ɔ,b,ɘ,ʇ,ϱ,н,i,į,ʞ,l,м,и,o,q,p,я,ƨ,т,υ,v,w,x,γ,z,0,9,8,7,6,5,4,3,2,1,.,_",
"4,8,C,D,3,F,9,H,!,J,K,1,M,N,0,P,Q,R,5,7,U,V,W,X,Y,2,4,8,C,D,3,F,9,H,!,J,K,1,M,N,0,P,Q,R,5,7,U,V,W,X,Y,2,0,9,8,7,6,5,4,3,2,1,.,_",
"Λ,M,X,ʎ,Z,ɐ,q,ɔ,p,ǝ,ɟ,ƃ,ɥ,ı,ɾ,ʞ,l,ա,u,o,d,b,ɹ,s,ʇ,n,ʌ,ʍ,x,ʎ,z,Λ,M,X,ʎ,Z,ɐ,q,ɔ,p,ǝ,ɟ,ƃ,ɥ,ı,ɾ,ʞ,l,ա,u,o,d,b,ɹ,s,ʇ,n,ʌ,ʍ,x,ʎ,z,0,9,8,7,6,5,4,3,2,1,.,‾",
"A̴,̴B̴,̴C̴,̴D̴,̴E̴,̴F̴,̴G̴,̴H̴,̴I̴,̴J̴,̴K̴,̴L̴,̴M̴,̴N̴,̴O̴,̴P̴,̴Q̴,̴R̴,̴S̴,̴T̴,̴U̴,̴V̴,̴W̴,̴X̴,̴Y̴,̴Z̴,̴a̴,̴b̴,̴c̴,̴d̴,̴e̴,̴f̴,̴g̴,̴h̴,̴i̴,̴j̴,̴k̴,̴l̴,̴m̴,̴n̴,̴o̴,̴p̴,̴q̴,̴r̴,̴s̴,̴t̴,̴u̴,̴v̴,̴w̴,̴x̴,̴y̴,̴z̴,̴0̴,̴9̴,̴8̴,̴7̴,̴6̴,̴5̴,̴4̴,̴3̴,̴2̴,̴1̴,̴.̴,̴_̴",
"A̱,̱Ḇ,̱C̱,̱Ḏ,̱E̱,̱F̱,̱G̱,̱H̱,̱I̱,̱J̱,̱Ḵ,̱Ḻ,̱M̱,̱Ṉ,̱O̱,̱P̱,̱Q̱,̱Ṟ,̱S̱,̱Ṯ,̱U̱,̱V̱,̱W̱,̱X̱,̱Y̱,̱Ẕ,̱a̱,̱ḇ,̱c̱,̱ḏ,̱e̱,̱f̱,̱g̱,̱ẖ,̱i̱,̱j̱,̱ḵ,̱ḻ,̱m̱,̱ṉ,̱o̱,̱p̱,̱q̱,̱ṟ,̱s̱,̱ṯ,̱u̱,̱v̱,̱w̱,̱x̱,̱y̱,̱ẕ,̱0̱,̱9̱,̱8̱,̱7̱,̱6̱,̱5̱,̱4̱,̱3̱,̱2̱,̱1̱,̱.̱,̱_̱",
"A̲,̲B̲,̲C̲,̲D̲,̲E̲,̲F̲,̲G̲,̲H̲,̲I̲,̲J̲,̲K̲,̲L̲,̲M̲,̲N̲,̲O̲,̲P̲,̲Q̲,̲R̲,̲S̲,̲T̲,̲U̲,̲V̲,̲W̲,̲X̲,̲Y̲,̲Z̲,̲a̲,̲b̲,̲c̲,̲d̲,̲e̲,̲f̲,̲g̲,̲h̲,̲i̲,̲j̲,̲k̲,̲l̲,̲m̲,̲n̲,̲o̲,̲p̲,̲q̲,̲r̲,̲s̲,̲t̲,̲u̲,̲v̲,̲w̲,̲x̲,̲y̲,̲z̲,̲0̲,̲9̲,̲8̲,̲7̲,̲6̲,̲5̲,̲4̲,̲3̲,̲2̲,̲1̲,̲.̲,̲_̲",
"Ā,̄B̄,̄C̄,̄D̄,̄Ē,̄F̄,̄Ḡ,̄H̄,̄Ī,̄J̄,̄K̄,̄L̄,̄M̄,̄N̄,̄Ō,̄P̄,̄Q̄,̄R̄,̄S̄,̄T̄,̄Ū,̄V̄,̄W̄,̄X̄,̄Ȳ,̄Z̄,̄ā,̄b̄,̄c̄,̄d̄,̄ē,̄f̄,̄ḡ,̄h̄,̄ī,̄j̄,̄k̄,̄l̄,̄m̄,̄n̄,̄ō,̄p̄,̄q̄,̄r̄,̄s̄,̄t̄,̄ū,̄v̄,̄w̄,̄x̄,̄ȳ,̄z̄,̄0̄,̄9̄,̄8̄,̄7̄,̄6̄,̄5̄,̄4̄,̄3̄,̄2̄,̄1̄,̄.̄,̄_̄",
"A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,0,9,8,7,6,5,4,3,2,1,.,_",
"a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,0,9,8,7,6,5,4,3,2,1,.,_",
"@,♭,ḉ,ⓓ,℮,ƒ,ℊ,ⓗ,ⓘ,נ,ⓚ,ℓ,ⓜ,η,ø,₪,ⓠ,ⓡ,﹩,т,ⓤ,√,ω,ж,૪,ℨ,@,♭,ḉ,ⓓ,℮,ƒ,ℊ,ⓗ,ⓘ,נ,ⓚ,ℓ,ⓜ,η,ø,₪,ⓠ,ⓡ,﹩,т,ⓤ,√,ω,ж,૪,ℨ,0,➈,➑,➐,➅,➄,➃,➌,➁,➊,.,_",
"@,♭,¢,ⅾ,ε,ƒ,ℊ,ℌ,ї,נ,к,ℓ,м,п,ø,ρ,ⓠ,ґ,﹩,⊥,ü,√,ω,ϰ,૪,ℨ,@,♭,¢,ⅾ,ε,ƒ,ℊ,ℌ,ї,נ,к,ℓ,м,п,ø,ρ,ⓠ,ґ,﹩,⊥,ü,√,ω,ϰ,૪,ℨ,0,9,8,7,6,5,4,3,2,1,.,_",
"α,♭,ḉ,∂,ℯ,ƒ,ℊ,ℌ,ї,ʝ,ḱ,ℓ,м,η,ø,₪,ⓠ,я,﹩,⊥,ц,ṽ,ω,ჯ,૪,ẕ,α,♭,ḉ,∂,ℯ,ƒ,ℊ,ℌ,ї,ʝ,ḱ,ℓ,м,η,ø,₪,ⓠ,я,﹩,⊥,ц,ṽ,ω,ჯ,૪,ẕ,0,9,8,7,6,5,4,3,2,1,.,_",
"@,ß,¢,ḓ,℮,ƒ,ℊ,ℌ,ї,נ,ḱ,ʟ,м,п,◎,₪,ⓠ,я,﹩,т,ʊ,♥️,ẘ,✄,૪,ℨ,@,ß,¢,ḓ,℮,ƒ,ℊ,ℌ,ї,נ,ḱ,ʟ,м,п,◎,₪,ⓠ,я,﹩,т,ʊ,♥️,ẘ,✄,૪,ℨ,0,9,8,7,6,5,4,3,2,1,.,_",
"@,ß,¢,ḓ,℮,ƒ,ℊ,н,ḯ,נ,к,ℓμ,п,☺️,₪,ⓠ,я,﹩,⊥,υ,ṽ,ω,✄,૪,ℨ,@,ß,¢,ḓ,℮,ƒ,ℊ,н,ḯ,נ,к,ℓμ,п,☺️,₪,ⓠ,я,﹩,⊥,υ,ṽ,ω,✄,૪,ℨ,0,9,8,7,6,5,4,3,2,1,.,_",
"@,ß,ḉ,ḓ,є,ƒ,ℊ,ℌ,ї,נ,ḱ,ʟ,ღ,η,◎,₪,ⓠ,я,﹩,⊥,ʊ,♥️,ω,ϰ,૪,ẕ,@,ß,ḉ,ḓ,є,ƒ,ℊ,ℌ,ї,נ,ḱ,ʟ,ღ,η,◎,₪,ⓠ,я,﹩,⊥,ʊ,♥️,ω,ϰ,૪,ẕ,0,9,8,7,6,5,4,3,2,1,.,_",
"@,ß,ḉ,∂,ε,ƒ,ℊ,ℌ,ї,נ,ḱ,ł,ღ,и,ø,₪,ⓠ,я,﹩,т,υ,√,ω,ჯ,૪,ẕ,@,ß,ḉ,∂,ε,ƒ,ℊ,ℌ,ї,נ,ḱ,ł,ღ,и,ø,₪,ⓠ,я,﹩,т,υ,√,ω,ჯ,૪,ẕ,0,9,8,7,6,5,4,3,2,1,.,_",
"α,♭,¢,∂,ε,ƒ,❡,н,ḯ,ʝ,ḱ,ʟ,μ,п,ø,ρ,ⓠ,ґ,﹩,т,υ,ṽ,ω,ж,૪,ẕ,α,♭,¢,∂,ε,ƒ,❡,н,ḯ,ʝ,ḱ,ʟ,μ,п,ø,ρ,ⓠ,ґ,﹩,т,υ,ṽ,ω,ж,૪,ẕ,0,9,8,7,6,5,4,3,2,1,.,_",
"α,♭,ḉ,∂,℮,ⓕ,ⓖ,н,ḯ,ʝ,ḱ,ℓ,м,п,ø,ⓟ,ⓠ,я,ⓢ,ⓣ,ⓤ,♥️,ⓦ,✄,ⓨ,ⓩ,α,♭,ḉ,∂,℮,ⓕ,ⓖ,н,ḯ,ʝ,ḱ,ℓ,м,п,ø,ⓟ,ⓠ,я,ⓢ,ⓣ,ⓤ,♥️,ⓦ,✄,ⓨ,ⓩ,0,➒,➑,➐,➏,➄,➍,➂,➁,➀,.,_",
"@,♭,ḉ,ḓ,є,ƒ,ⓖ,ℌ,ⓘ,נ,к,ⓛ,м,ⓝ,ø,₪,ⓠ,я,﹩,ⓣ,ʊ,√,ω,ჯ,૪,ⓩ,@,♭,ḉ,ḓ,є,ƒ,ⓖ,ℌ,ⓘ,נ,к,ⓛ,м,ⓝ,ø,₪,ⓠ,я,﹩,ⓣ,ʊ,√,ω,ჯ,૪,ⓩ,0,➒,➇,➆,➅,➄,➍,➌,➋,➀,.,_",
"α,♭,ⓒ,∂,є,ⓕ,ⓖ,ℌ,ḯ,ⓙ,ḱ,ł,ⓜ,и,ⓞ,ⓟ,ⓠ,ⓡ,ⓢ,⊥,ʊ,ⓥ,ⓦ,ж,ⓨ,ⓩ,α,♭,ⓒ,∂,є,ⓕ,ⓖ,ℌ,ḯ,ⓙ,ḱ,ł,ⓜ,и,ⓞ,ⓟ,ⓠ,ⓡ,ⓢ,⊥,ʊ,ⓥ,ⓦ,ж,ⓨ,ⓩ,0,➒,➑,➆,➅,➎,➍,➌,➁,➀,.,_",
"ⓐ,ß,ḉ,∂,℮,ⓕ,❡,ⓗ,ї,נ,ḱ,ł,μ,η,ø,ρ,ⓠ,я,﹩,ⓣ,ц,√,ⓦ,✖️,૪,ℨ,ⓐ,ß,ḉ,∂,℮,ⓕ,❡,ⓗ,ї,נ,ḱ,ł,μ,η,ø,ρ,ⓠ,я,﹩,ⓣ,ц,√,ⓦ,✖️,૪,ℨ,0,➒,➑,➐,➅,➄,➍,➂,➁,➊,.,_",
"α,ß,ⓒ,ⅾ,ℯ,ƒ,ℊ,ⓗ,ї,ʝ,к,ʟ,ⓜ,η,ⓞ,₪,ⓠ,ґ,﹩,т,υ,ⓥ,ⓦ,ж,ⓨ,ẕ,α,ß,ⓒ,ⅾ,ℯ,ƒ,ℊ,ⓗ,ї,ʝ,к,ʟ,ⓜ,η,ⓞ,₪,ⓠ,ґ,﹩,т,υ,ⓥ,ⓦ,ж,ⓨ,ẕ,0,➈,➇,➐,➅,➎,➍,➌,➁,➊,.,_",
"@,♭,ḉ,ⅾ,є,ⓕ,❡,н,ḯ,נ,ⓚ,ⓛ,м,ⓝ,☺️,ⓟ,ⓠ,я,ⓢ,⊥,υ,♥️,ẘ,ϰ,૪,ⓩ,@,♭,ḉ,ⅾ,є,ⓕ,❡,н,ḯ,נ,ⓚ,ⓛ,м,ⓝ,☺️,ⓟ,ⓠ,я,ⓢ,⊥,υ,♥️,ẘ,ϰ,૪,ⓩ,0,➒,➑,➆,➅,➄,➃,➂,➁,➀,.,_",
"ⓐ,♭,ḉ,ⅾ,є,ƒ,ℊ,ℌ,ḯ,ʝ,ḱ,ł,μ,η,ø,ⓟ,ⓠ,ґ,ⓢ,т,ⓤ,√,ⓦ,✖️,ⓨ,ẕ,ⓐ,♭,ḉ,ⅾ,є,ƒ,ℊ,ℌ,ḯ,ʝ,ḱ,ł,μ,η,ø,ⓟ,ⓠ,ґ,ⓢ,т,ⓤ,√,ⓦ,✖️,ⓨ,ẕ,0,➈,➇,➐,➅,➄,➃,➂,➁,➀,.,_",
"ձ,ъƈ,ժ,ε,բ,ց,հ,ﻨ,յ,ĸ,l,ო,ռ,օ,թ,զ,г,ร,է,ս,ν,ա,×,ყ,২,ձ,ъƈ,ժ,ε,բ,ց,հ,ﻨ,յ,ĸ,l,ო,ռ,օ,թ,զ,г,ร,է,ս,ν,ա,×,ყ,২,0,9,8,7,6,5,4,3,2,1,.,_",
"λ,ϐ,ς,d,ε,ғ,ϑ,ɢ,н,ι,ϳ,κ,l,ϻ,π,σ,ρ,φ,г,s,τ,υ,v,ш,ϰ,ψ,z,λ,ϐ,ς,d,ε,ғ,ϑ,ɢ,н,ι,ϳ,κ,l,ϻ,π,σ,ρ,φ,г,s,τ,υ,v,ш,ϰ,ψ,z,0,9,8,7,6,5,4,3,2,1,.,_",
"ค,๒,ς,๔,є,Ŧ,ɠ,ђ,เ,ן,к,l,๓,ภ,๏,թ,ợ,г,ร,t,ย,v,ฬ,x,ץ,z,ค,๒,ς,๔,є,Ŧ,ɠ,ђ,เ,ן,к,l,๓,ภ,๏,թ,ợ,г,ร,t,ย,v,ฬ,x,ץ,z,0,9,8,7,6,5,4,3,2,1,.,_",
"მ,ჩ,ƈძ,ε,բ,ց,հ,ἶ,ʝ,ƙ,l,ო,ղ,օ,ր,գ,ɾ,ʂ,է,մ,ν,ω,ჯ,ყ,z,მ,ჩ,ƈძ,ε,բ,ց,հ,ἶ,ʝ,ƙ,l,ო,ղ,օ,ր,գ,ɾ,ʂ,է,մ,ν,ω,ჯ,ყ,z,0,Գ,Ց,Դ,6,5,Վ,Յ,Զ,1,.,_",
"ค,ც,८,ძ,૯,Բ,૭,Һ,ɿ,ʆ,қ,Ն,ɱ,Ո,૦,ƿ,ҩ,Ր,ς,੮,υ,౮,ω,૪,ע,ઽ,ค,ც,८,ძ,૯,Բ,૭,Һ,ɿ,ʆ,қ,Ն,ɱ,Ո,૦,ƿ,ҩ,Ր,ς,੮,υ,౮,ω,૪,ע,ઽ,0,9,8,7,6,5,4,3,2,1,.,_",
"Λ,Б,Ͼ,Ð,Ξ,Ŧ,g,h,ł,j,К,Ł,m,Л,Ф,p,Ǫ,Я,s,t,u,v,Ш,Ж,Џ,z,Λ,Б,Ͼ,Ð,Ξ,Ŧ,g,h,ł,j,К,Ł,m,Л,Ф,p,Ǫ,Я,s,t,u,v,Ш,Ж,Џ,z,0,9,8,7,6,5,4,3,2,1,.,_",
"λ,ß,Ȼ,ɖ,ε,ʃ,Ģ,ħ,ί,ĵ,κ,ι,ɱ,ɴ,Θ,ρ,ƣ,ર,Ș,τ,Ʋ,ν,ώ,Χ,ϓ,Հ,λ,ß,Ȼ,ɖ,ε,ʃ,Ģ,ħ,ί,ĵ,κ,ι,ɱ,ɴ,Θ,ρ,ƣ,ર,Ș,τ,Ʋ,ν,ώ,Χ,ϓ,Հ,0,9,8,7,6,5,4,3,2,1,.,_",
"ª,b,¢,Þ,È,F,૬,ɧ,Î,j,Κ,Ļ,м,η,◊,Ƿ,ƍ,r,S,⊥,µ,√,w,×,ý,z,ª,b,¢,Þ,È,F,૬,ɧ,Î,j,Κ,Ļ,м,η,◊,Ƿ,ƍ,r,S,⊥,µ,√,w,×,ý,z,0,9,8,7,6,5,4,3,2,1,.,_",
"Թ,Յ,Շ,Ժ,ȝ,Բ,Գ,ɧ,ɿ,ʝ,ƙ,ʅ,ʍ,Ռ,Ծ,ρ,φ,Ր,Տ,Ե,Մ,ע,ա,Ճ,Վ,Հ,Թ,Յ,Շ,Ժ,ȝ,Բ,Գ,ɧ,ɿ,ʝ,ƙ,ʅ,ʍ,Ռ,Ծ,ρ,φ,Ր,Տ,Ե,Մ,ע,ա,Ճ,Վ,Հ,0,9,8,7,6,5,4,3,2,1,.,_",
"Λ,Ϧ,ㄈ,Ð,Ɛ,F,Ɠ,н,ɪ,ﾌ,Қ,Ł,௱,Л,Ø,þ,Ҩ,尺,ら,Ť,Ц,Ɣ,Ɯ,χ,Ϥ,Ẕ,Λ,Ϧ,ㄈ,Ð,Ɛ,F,Ɠ,н,ɪ,ﾌ,Қ,Ł,௱,Л,Ø,þ,Ҩ,尺,ら,Ť,Ц,Ɣ,Ɯ,χ,Ϥ,Ẕ,0,9,8,7,6,5,4,3,2,1,.,_",
"Ǟ,в,ट,D,ę,բ,g,৸,i,j,κ,l,ɱ,П,Φ,Р,q,Я,s,Ʈ,Ц,v,Щ,ж,ყ,ւ,Ǟ,в,ट,D,ę,բ,g,৸,i,j,κ,l,ɱ,П,Φ,Р,q,Я,s,Ʈ,Ц,v,Щ,ж,ყ,ւ,0,9,8,7,6,5,4,3,2,1,.,_",
"ɒ,d,ɔ,b,ɘ,ʇ,ϱ,н,i,į,ʞ,l,м,и,o,q,p,я,ƨ,т,υ,v,w,x,γ,z,ɒ,d,ɔ,b,ɘ,ʇ,ϱ,н,i,į,ʞ,l,м,и,o,q,p,я,ƨ,т,υ,v,w,x,γ,z,0,9,8,7,6,5,4,3,2,1,.,_",
"Æ,þ,©,Ð,E,F,ζ,Ħ,Ї,¿,ズ,ᄂ,M,Ñ,Θ,Ƿ,Ø,Ґ,Š,τ,υ,¥,w,χ,y,շ,Æ,þ,©,Ð,E,F,ζ,Ħ,Ї,¿,ズ,ᄂ,M,Ñ,Θ,Ƿ,Ø,Ґ,Š,τ,υ,¥,w,χ,y,շ,0,9,8,7,6,5,4,3,2,1,.,_",
"ª,ß,¢,ð,€,f,g,h,¡,j,k,|,m,ñ,¤,Þ,q,®,$,t,µ,v,w,×,ÿ,z,ª,ß,¢,ð,€,f,g,h,¡,j,k,|,m,ñ,¤,Þ,q,®,$,t,µ,v,w,×,ÿ,z,0,9,8,7,6,5,4,3,2,1,.,_",
"ɐ,q,ɔ,p,ǝ,ɟ,ɓ,ɥ,ı,ſ,ʞ,ๅ,ɯ,u,o,d,b,ɹ,s,ʇ,n,ʌ,ʍ,x,ʎ,z,ɐ,q,ɔ,p,ǝ,ɟ,ɓ,ɥ,ı,ſ,ʞ,ๅ,ɯ,u,o,d,b,ɹ,s,ʇ,n,ʌ,ʍ,x,ʎ,z,0,9,8,7,6,5,4,3,2,1,.,_",
"⒜,⒝,⒞,⒟,⒠,⒡,⒢,⒣,⒤,⒥,⒦,⒧,⒨,⒩,⒪,⒫,⒬,⒭,⒮,⒯,⒰,⒱,⒲,⒳,⒴,⒵,⒜,⒝,⒞,⒟,⒠,⒡,⒢,⒣,⒤,⒥,⒦,⒧,⒨,⒩,⒪,⒫,⒬,⒭,⒮,⒯,⒰,⒱,⒲,⒳,⒴,⒵,⒪,⑼,⑻,⑺,⑹,⑸,⑷,⑶,⑵,⑴,.,_",
"ɑ,ʙ,c,ᴅ,є,ɻ,მ,ʜ,ι,ɿ,ĸ,г,w,и,o,ƅϭ,ʁ,ƨ,⊥,n,ʌ,ʍ,x,⑃,z,ɑ,ʙ,c,ᴅ,є,ɻ,მ,ʜ,ι,ɿ,ĸ,г,w,и,o,ƅϭ,ʁ,ƨ,⊥,n,ʌ,ʍ,x,⑃,z,0,9,8,7,6,5,4,3,2,1,.,_",
"4,8,C,D,3,F,9,H,!,J,K,1,M,N,0,P,Q,R,5,7,U,V,W,X,Y,2,4,8,C,D,3,F,9,H,!,J,K,1,M,N,0,P,Q,R,5,7,U,V,W,X,Y,2,0,9,8,7,6,5,4,3,2,1,.,_",
"Λ,ßƇ,D,Ɛ,F,Ɠ,Ĥ,Ī,Ĵ,Ҡ,Ŀ,M,И,♡,Ṗ,Ҩ,Ŕ,S,Ƭ,Ʊ,Ѵ,Ѡ,Ӿ,Y,Z,Λ,ßƇ,D,Ɛ,F,Ɠ,Ĥ,Ī,Ĵ,Ҡ,Ŀ,M,И,♡,Ṗ,Ҩ,Ŕ,S,Ƭ,Ʊ,Ѵ,Ѡ,Ӿ,Y,Z,0,9,8,7,6,5,4,3,2,1,.,_",
"α,в,¢,đ,e,f,g,ħ,ı,נ,κ,ł,м,и,ø,ρ,q,я,š,т,υ,ν,ω,χ,ч,z,α,в,¢,đ,e,f,g,ħ,ı,נ,κ,ł,м,и,ø,ρ,q,я,š,т,υ,ν,ω,χ,ч,z,0,9,8,7,6,5,4,3,2,1,.,_",
"α,в,c,ɔ,ε,ғ,ɢ,н,ı,נ,κ,ʟ,м,п,σ,ρ,ǫ,я,ƨ,т,υ,ν,ш,х,ч,z,α,в,c,ɔ,ε,ғ,ɢ,н,ı,נ,κ,ʟ,м,п,σ,ρ,ǫ,я,ƨ,т,υ,ν,ш,х,ч,z,0,9,8,7,6,5,4,3,2,1,.,_",
"【a】,【b】,【c】,【d】,【e】,【f】,【g】,【h】,【i】,【j】,【k】,【l】,【m】,【n】,【o】,【p】,【q】,【r】,【s】,【t】,【u】,【v】,【w】,【x】,【y】,【z】,【a】,【b】,【c】,【d】,【e】,【f】,【g】,【h】,【i】,【j】,【k】,【l】,【m】,【n】,【o】,【p】,【q】,【r】,【s】,【t】,【u】,【v】,【w】,【x】,【y】,【z】,【0】,【9】,【8】,【7】,【6】,【5】,【4】,【3】,【2】,【1】,.,_",
"[̲̲̅̅a̲̅,̲̅b̲̲̅,̅c̲̅,̲̅d̲̲̅,̅e̲̲̅,̅f̲̲̅,̅g̲̅,̲̅h̲̲̅,̅i̲̲̅,̅j̲̲̅,̅k̲̅,̲̅l̲̲̅,̅m̲̅,̲̅n̲̅,̲̅o̲̲̅,̅p̲̅,̲̅q̲̅,̲̅r̲̲̅,̅s̲̅,̲̅t̲̲̅,̅u̲̅,̲̅v̲̅,̲̅w̲̅,̲̅x̲̅,̲̅y̲̅,̲̅z̲̅,[̲̲̅̅a̲̅,̲̅b̲̲̅,̅c̲̅,̲̅d̲̲̅,̅e̲̲̅,̅f̲̲̅,̅g̲̅,̲̅h̲̲̅,̅i̲̲̅,̅j̲̲̅,̅k̲̅,̲̅l̲̲̅,̅m̲̅,̲̅n̲̅,̲̅o̲̲̅,̅p̲̅,̲̅q̲̅,̲̅r̲̲̅,̅s̲̅,̲̅t̲̲̅,̅u̲̅,̲̅v̲̅,̲̅w̲̅,̲̅x̲̅,̲̅y̲̅,̲̅z̲̅,̲̅0̲̅,̲̅9̲̲̅,̅8̲̅,̲̅7̲̅,̲̅6̲̅,̲̅5̲̅,̲̅4̲̅,̲̅3̲̲̅,̅2̲̲̅,̅1̲̲̅̅],.,_",
"[̺͆a̺͆͆,̺b̺͆͆,̺c̺͆,̺͆d̺͆,̺͆e̺͆,̺͆f̺͆͆,̺g̺͆,̺͆h̺͆,̺͆i̺͆,̺͆j̺͆,̺͆k̺͆,̺l̺͆͆,̺m̺͆͆,̺n̺͆͆,̺o̺͆,̺͆p̺͆͆,̺q̺͆͆,̺r̺͆͆,̺s̺͆͆,̺t̺͆͆,̺u̺͆͆,̺v̺͆͆,̺w̺͆,̺͆x̺͆,̺͆y̺͆,̺͆z̺,[̺͆a̺͆͆,̺b̺͆͆,̺c̺͆,̺͆d̺͆,̺͆e̺͆,̺͆f̺͆͆,̺g̺͆,̺͆h̺͆,̺͆i̺͆,̺͆j̺͆,̺͆k̺͆,̺l̺͆͆,̺m̺͆͆,̺n̺͆͆,̺o̺͆,̺͆p̺͆͆,̺q̺͆͆,̺r̺͆͆,̺s̺͆͆,̺t̺͆͆,̺u̺͆͆,̺v̺͆͆,̺w̺͆,̺͆x̺͆,̺͆y̺͆,̺͆z̺,̺͆͆0̺͆,̺͆9̺͆,̺͆8̺̺͆͆7̺͆,̺͆6̺͆,̺͆5̺͆,̺͆4̺͆,̺͆3̺͆,̺͆2̺͆,̺͆1̺͆],.,_",
"̛̭̰̃ã̛̰̭,̛̭̰̃b̛̰̭̃̃,̛̭̰c̛̛̰̭̃̃,̭̰d̛̰̭̃,̛̭̰̃ḛ̛̭̃̃,̛̭̰f̛̰̭̃̃,̛̭̰g̛̰̭̃̃,̛̭̰h̛̰̭̃,̛̭̰̃ḭ̛̛̭̃̃,̭̰j̛̰̭̃̃,̛̭̰k̛̰̭̃̃,̛̭̰l̛̰̭,̛̭̰̃m̛̰̭̃̃,̛̭̰ñ̛̛̰̭̃,̭̰ỡ̰̭̃,̛̭̰p̛̰̭̃,̛̭̰̃q̛̰̭̃̃,̛̭̰r̛̛̰̭̃̃,̭̰s̛̰̭,̛̭̰̃̃t̛̰̭̃,̛̭̰̃ữ̰̭̃,̛̭̰ṽ̛̰̭̃,̛̭̰w̛̛̰̭̃̃,̭̰x̛̰̭̃,̛̭̰̃ỹ̛̰̭̃,̛̭̰z̛̰̭̃̃,̛̛̭̰ã̛̰̭,̛̭̰̃b̛̰̭̃̃,̛̭̰c̛̛̰̭̃̃,̭̰d̛̰̭̃,̛̭̰̃ḛ̛̭̃̃,̛̭̰f̛̰̭̃̃,̛̭̰g̛̰̭̃̃,̛̭̰h̛̰̭̃,̛̭̰̃ḭ̛̛̭̃̃,̭̰j̛̰̭̃̃,̛̭̰k̛̰̭̃̃,̛̭̰l̛̰̭,̛̭̰̃m̛̰̭̃̃,̛̭̰ñ̛̛̰̭̃,̭̰ỡ̰̭̃,̛̭̰p̛̰̭̃,̛̭̰̃q̛̰̭̃̃,̛̭̰r̛̛̰̭̃̃,̭̰s̛̰̭,̛̭̰̃̃t̛̰̭̃,̛̭̰̃ữ̰̭̃,̛̭̰ṽ̛̰̭̃,̛̭̰w̛̛̰̭̃̃,̭̰x̛̰̭̃,̛̭̰̃ỹ̛̰̭̃,̛̭̰z̛̰̭̃̃,̛̭̰0̛̛̰̭̃̃,̭̰9̛̰̭̃̃,̛̭̰8̛̛̰̭̃̃,̭̰7̛̰̭̃̃,̛̭̰6̛̰̭̃̃,̛̭̰5̛̰̭̃,̛̭̰̃4̛̰̭̃,̛̭̰̃3̛̰̭̃̃,̛̭̰2̛̰̭̃̃,̛̭̰1̛̰̭̃,.,_",
"a,ะb,ะc,ะd,ะe,ะf,ะg,ะh,ะi,ะj,ะk,ะl,ะm,ะn,ะo,ะp,ะq,ะr,ะs,ะt,ะu,ะv,ะw,ะx,ะy,ะz,a,ะb,ะc,ะd,ะe,ะf,ะg,ะh,ะi,ะj,ะk,ะl,ะm,ะn,ะo,ะp,ะq,ะr,ะs,ะt,ะu,ะv,ะw,ะx,ะy,ะz,ะ0,ะ9,ะ8,ะ7,ะ6,ะ5,ะ4,ะ3,ะ2,ะ1ะ,.,_",
"̑ȃ,̑b̑,̑c̑,̑d̑,̑ȇ,̑f̑,̑g̑,̑h̑,̑ȋ,̑j̑,̑k̑,̑l̑,̑m̑,̑n̑,̑ȏ,̑p̑,̑q̑,̑ȓ,̑s̑,̑t̑,̑ȗ,̑v̑,̑w̑,̑x̑,̑y̑,̑z̑,̑ȃ,̑b̑,̑c̑,̑d̑,̑ȇ,̑f̑,̑g̑,̑h̑,̑ȋ,̑j̑,̑k̑,̑l̑,̑m̑,̑n̑,̑ȏ,̑p̑,̑q̑,̑ȓ,̑s̑,̑t̑,̑ȗ,̑v̑,̑w̑,̑x̑,̑y̑,̑z̑,̑0̑,̑9̑,̑8̑,̑7̑,̑6̑,̑5̑,̑4̑,̑3̑,̑2̑,̑1̑,.,_",
"~a,͜͝b,͜͝c,͜͝d,͜͝e,͜͝f,͜͝g,͜͝h,͜͝i,͜͝j,͜͝k,͜͝l,͜͝m,͜͝n,͜͝o,͜͝p,͜͝q,͜͝r,͜͝s,͜͝t,͜͝u,͜͝v,͜͝w,͜͝x,͜͝y,͜͝z,~a,͜͝b,͜͝c,͜͝d,͜͝e,͜͝f,͜͝g,͜͝h,͜͝i,͜͝j,͜͝k,͜͝l,͜͝m,͜͝n,͜͝o,͜͝p,͜͝q,͜͝r,͜͝s,͜͝t,͜͝u,͜͝v,͜͝w,͜͝x,͜͝y,͜͝z,͜͝0,͜͝9,͜͝8,͜͝7,͜͝6,͜͝5,͜͝4,͜͝3,͜͝2͜,͝1͜͝~,.,_",
"̤̈ä̤,̤̈b̤̈,̤̈c̤̈̈,̤d̤̈,̤̈ë̤,̤̈f̤̈,̤̈g̤̈̈,̤ḧ̤̈,̤ï̤̈,̤j̤̈,̤̈k̤̈̈,̤l̤̈,̤̈m̤̈,̤̈n̤̈,̤̈ö̤,̤̈p̤̈,̤̈q̤̈,̤̈r̤̈,̤̈s̤̈̈,̤ẗ̤̈,̤ṳ̈,̤̈v̤̈,̤̈ẅ̤,̤̈ẍ̤,̤̈ÿ̤,̤̈z̤̈,̤̈ä̤,̤̈b̤̈,̤̈c̤̈̈,̤d̤̈,̤̈ë̤,̤̈f̤̈,̤̈g̤̈̈,̤ḧ̤̈,̤ï̤̈,̤j̤̈,̤̈k̤̈̈,̤l̤̈,̤̈m̤̈,̤̈n̤̈,̤̈ö̤,̤̈p̤̈,̤̈q̤̈,̤̈r̤̈,̤̈s̤̈̈,̤ẗ̤̈,̤ṳ̈,̤̈v̤̈,̤̈ẅ̤,̤̈ẍ̤,̤̈ÿ̤,̤̈z̤̈,̤̈0̤̈,̤̈9̤̈,̤̈8̤̈,̤̈7̤̈,̤̈6̤̈,̤̈5̤̈,̤̈4̤̈,̤̈3̤̈,̤̈2̤̈̈,̤1̤̈,.,_",
"≋̮̑ȃ̮,̮̑b̮̑,̮̑c̮̑,̮̑d̮̑,̮̑ȇ̮,̮̑f̮̑,̮̑g̮̑,̮̑ḫ̑,̮̑ȋ̮,̮̑j̮̑,̮̑k̮̑,̮̑l̮̑,̮̑m̮̑,̮̑n̮̑,̮̑ȏ̮,̮̑p̮̑,̮̑q̮̑,̮̑r̮,̮̑̑s̮,̮̑̑t̮,̮̑̑u̮,̮̑̑v̮̑,̮̑w̮̑,̮̑x̮̑,̮̑y̮̑,̮̑z̮̑,≋̮̑ȃ̮,̮̑b̮̑,̮̑c̮̑,̮̑d̮̑,̮̑ȇ̮,̮̑f̮̑,̮̑g̮̑,̮̑ḫ̑,̮̑ȋ̮,̮̑j̮̑,̮̑k̮̑,̮̑l̮̑,̮̑m̮̑,̮̑n̮̑,̮̑ȏ̮,̮̑p̮̑,̮̑q̮̑,̮̑r̮,̮̑̑s̮,̮̑̑t̮,̮̑̑u̮,̮̑̑v̮̑,̮̑w̮̑,̮̑x̮̑,̮̑y̮̑,̮̑z̮̑,̮̑0̮̑,̮̑9̮̑,̮̑8̮̑,̮̑7̮̑,̮̑6̮̑,̮̑5̮̑,̮̑4̮̑,̮̑3̮̑,̮̑2̮̑,̮̑1̮̑≋,.,_",
"a̮,̮b̮̮,c̮̮,d̮̮,e̮̮,f̮̮,g̮̮,ḫ̮,i̮,j̮̮,k̮̮,l̮,̮m̮,̮n̮̮,o̮,̮p̮̮,q̮̮,r̮̮,s̮,̮t̮̮,u̮̮,v̮̮,w̮̮,x̮̮,y̮̮,z̮̮,a̮,̮b̮̮,c̮̮,d̮̮,e̮̮,f̮̮,g̮̮,ḫ̮i,̮̮,j̮̮,k̮̮,l̮,̮m̮,̮n̮̮,o̮,̮p̮̮,q̮̮,r̮̮,s̮,̮t̮̮,u̮̮,v̮̮,w̮̮,x̮̮,y̮̮,z̮̮,0̮̮,9̮̮,8̮̮,7̮̮,6̮̮,5̮̮,4̮̮,3̮̮,2̮̮,1̮,.,_",
"A̲,̲B̲,̲C̲,̲D̲,̲E̲,̲F̲,̲G̲,̲H̲,̲I̲,̲J̲,̲K̲,̲L̲,̲M̲,̲N̲,̲O̲,̲P̲,̲Q̲,̲R̲,̲S̲,̲T̲,̲U̲,̲V̲,̲W̲,̲X̲,̲Y̲,̲Z̲,̲a̲,̲b̲,̲c̲,̲d̲,̲e̲,̲f̲,̲g̲,̲h̲,̲i̲,̲j̲,̲k̲,̲l̲,̲m̲,̲n̲,̲o̲,̲p̲,̲q̲,̲r̲,̲s̲,̲t̲,̲u̲,̲v̲,̲w̲,̲x̲,̲y̲,̲z̲,̲0̲,̲9̲,̲8̲,̲7̲,̲6̲,̲5̲,̲4̲,̲3̲,̲2̲,̲1̲,̲.̲,̲_̲",
"Â,ß,Ĉ,Ð,Є,Ŧ,Ǥ,Ħ,Ī,ʖ,Қ,Ŀ,♏,И,Ø,P,Ҩ,R,$,ƚ,Ц,V,Щ,X,￥,Ẕ,Â,ß,Ĉ,Ð,Є,Ŧ,Ǥ,Ħ,Ī,ʖ,Қ,Ŀ,♏,И,Ø,P,Ҩ,R,$,ƚ,Ц,V,Щ,X,￥,Ẕ,0,9,8,7,6,5,4,3,2,1,.,_",
}