-- nadal w fazie budowy i ulepszania

frame = CreateFrame("frame", "gmmh", UIParent)
bgm=false; --bool od gm on/off
bchat=false; --bool od znaczka <GM> on/off
bvis=false; --bool od niewidzialnosci on/off
bwhi=false; --bool od whispa on/off
login={};
hunt=false;
bahunt=false;

frame:RegisterEvent("PLAYER_REGEN_DISABLED");
frame:RegisterEvent("PLAYER_REGEN_ENABLED");
frame:RegisterEvent("PLAYER_ENTERING_WORLD");
frame:RegisterEvent("UI_ERROR_MESSAGE");
frame:RegisterEvent("CHAT_MSG_SYSTEM");
--frame:RegisterEvent("ADDON_LOADED"); -- Fired when saved variables are loaded
--frame:RegisterEvent("PLAYER_LOGOUT"); -- Fired when about to log out

function GMstat() --status all stanow
SendChatMessage(".gm", "GUILD");
SendChatMessage(".gm chat", "GUILD");
SendChatMessage(".gm visible", "GUILD");
SendChatMessage(".whispers", "GUILD");
end

-- funcje czastkowe dla manualnego zmieniania stanu oraz "semafororowe" funkcje dla zmieniania stanu z off na on i on na off
function gmmod(stat)
	if stat == true then SendChatMessage(".gm on", "GUILD"); SendSystemMessage("GM mode is ON"); end
	if stat == false then SendChatMessage(".gm off", "GUILD"); SendSystemMessage("GM mode is OFF"); hunt=false; end
end

function gmmode()
	if bgm then gmmod(false);
		else gmmod(true);
	end
end

function gmcha(stat)
	if stat == true then SendChatMessage(".gm chat on", "GUILD"); SendSystemMessage("GM Chat Badge is ON"); end
	if stat == false then SendChatMessage(".gm chat off", "GUILD"); SendSystemMessage("GM Chat Badge is OFF"); hunt=false; end
end

function gmchat()
	if bchat then gmcha(false);
		else gmcha(true);
	end
end

function gmvi(stat)
	if stat == true then SendChatMessage(".gm visi on", "GUILD"); SendSystemMessage("You are now visible."); hunt=false; end
	if stat == false then SendChatMessage(".gm visi off", "GUILD"); SendSystemMessage("You are now invisible."); end
end

function gmvis()
	if bvis then gmvi(false);
		else gmvi(true);
	end
end

function gmwhi(stat)
	if stat == true then SendChatMessage(".whis on", "GUILD"); end
	if stat == false then SendChatMessage(".whis off", "GUILD"); end
end

function gmwhis()
	if bwhi then gmwhi(false);
		else gmwhi(true);
	end
end

function gmon() --do polowania na hackerow
	gmmod(true);
	gmcha(true);
	gmvi(false);
	gmwhi(false);
	hunt=true;
end;

function gmoff() --total wylaczenie gmmode
	gmmod(false);
	gmcha(false);
	gmvi(true);
	gmwhi(true);
	hunt=false;
end;

--zbieranei eventow stanow komend
frame:SetScript("OnEvent", function(self, event, notice, ...)
	if notice == nil then notice=""; end
--	print(event);
--	test(notice);
--	if event == "ADDON_LOADED" then GMstat(); end
--	if event == "PLAYER_REGEN_DISABLED" then print("COMBAT"); end --enter CB
--	if event == "PLAYER_REGEN_ENABLED" then print("Leave CB"); end --leave CB
	if event == "UI_ERROR_MESSAGE" then
		if notice == "GM mode is ON" then bgm=true;
			elseif notice == "GM mode is OFF" then bgm=false;
			elseif notice == "GM Chat Badge is ON" then bchat=true;
			elseif notice == "GM Chat Badge is OFF" then bchat=false;
			elseif notice == "You are now visible." then bvis=true;
			elseif notice == "You are now invisible." then bvis=false;
		end
	end
	if event == "CHAT_MSG_SYSTEM" then
		if notice == "You are now visible." then bvis=true;
			elseif notice == "You are now invisible." then bvis=false;
			elseif notice == "Accepting Whisper: ON" then bwhi=true;
			elseif notice == "Accepting Whisper: OFF" then bwhi=false;
		end
		infohack(notice);
		infoapp(notice);
	end
end)
function info()
	DEFAULT_CHAT_FRAME:AddMessage('GM Macro Help', 0, 1, 0);
	DEFAULT_CHAT_FRAME:AddMessage('przydatne dodatkowe komendy dla GM i Dev', 0, 1, 0);
	DEFAULT_CHAT_FRAME:AddMessage('/gm lub /gmmh - z praaametrem "show" wlacza panel dodatkowy addonu, paramet "hide" ukrywa ', 0, 1, 0);	
	DEFAULT_CHAT_FRAME:AddMessage('/gmmode - zmienia z on <-> off  steruje tez stanem poprzez paramer on off czyli /gmmode on wlacza gmmode', 0, 1, 0);
	DEFAULT_CHAT_FRAME:AddMessage('/gmchar - analogicznie jak powyzsza tylko dla znaczka <blizz>', 0, 1, 0);
	DEFAULT_CHAT_FRAME:AddMessage('/gmvis - j.w. dla mozliwosci ukywania sie przed graczami on - widac off - nie widac', 0, 1, 0);
	DEFAULT_CHAT_FRAME:AddMessage('/gmwhis - j.w. dla wshipka // on - moga pisac off - nie moga', 0, 1, 0);
	DEFAULT_CHAT_FRAME:AddMessage('/hunt - specjalna komenda do polowania wlacza 4powyzsze komendy tak aby gm mogl ganiac za bugerem', 0, 1, 0);
	DEFAULT_CHAT_FRAME:AddMessage('gdy wpiszesz /hunt off - gm wejdze w tryb Gracza (bez gmmode blizzka, widoczny i z wlaczonym whisp)', 0, 1, 0);
	DEFAULT_CHAT_FRAME:AddMessage('/perm #nick #zaco - nie musze tluaczyc co to przyklad: /perm gracz sh i fh', 0, 1, 0);
	DEFAULT_CHAT_FRAME:AddMessage('/stat - ujawnia jakie ustawienia sa aktualnie', 0, 1, 0);
	DEFAULT_CHAT_FRAME:AddMessage('/app #nick dziala tak samo jak .app #nick lecz gdy wpiszemy bez paramertu to przesle nas do postaci do ktorej sie ostatnio summalismy', 0, 1, 0);
	DEFAULT_CHAT_FRAME:AddMessage('/tic (c/d/n/o) bez parametru wyswietla tickety online pozostale to c(ancel) id, d(elete) id, n(ame) nick, o(ffline)', 0, 1, 0);

end

-- sekcja slash komend czeka na zrobienie
SLASH_GM1, SLASH_GM2 = '/GM', '/GMMH';
local function gmmhslash(msg, editbox)
--	print(msg);
	if msg == "" then
		info();
	elseif msg == nil then
		info();
	elseif msg == "show" then 
		GMMHForm:Show();
	elseif msg == "hide" then 
		GMMHForm:Hide();
	else
		info();
	end
	hunt=false;
end
SlashCmdList["GM"] = gmmhslash;

SLASH_GMmode1 = '/gmmode';
local function gmmodeslash(msg, editbox)
--	print(msg);
	if msg == "" then
		gmmode();
	elseif msg == "on" then
		gmmod(true);
	elseif msg == "off" then
		gmmod(false);
	else
		SendSystemMessage("/gmmode (tylko 3 opcje on, off i zadna)");
	end
end
SlashCmdList["GMmode"] = gmmodeslash;

SLASH_GMchat1 = '/gmchat';
local function gmmodeslash(msg, editbox)
--	print(msg);
	if msg == "" then
		gmchat();
	elseif msg == "on" then
		gmcha(true);
	elseif msg == "off" then
		gmcha(false);
	else
		SendSystemMessage("/gmchat (tylko 3 opcje on, off i zadna)");
	end
end
SlashCmdList["GMchat"] = gmchatslash;

SLASH_GMvis1 = '/gmvis';
local function gmvisslash(msg, editbox)
--	print(msg);
	if msg == "" then
		gmvis();
	elseif msg == "on" then
		gmvi(true);
	elseif msg == "off" then
		gmvi(false);
	else
		SendSystemMessage("/gmvis (tylko 3 opcje on, off i zadna)");
	end
end
SlashCmdList["GMvis"] = gmvisslash;

SLASH_GMwhis1 = '/gmwhis';
local function gmwhisslash(msg, editbox)
--	print(msg);
	if msg == "" then
		gmwhis();
	elseif msg == "on" then
		gmwhi(true);
	elseif msg == "off" then
		gmwhi(false);
	else
		SendSystemMessage("/gmwhis (tylko 3 opcje on, off i zadna)");
	end
end
SlashCmdList["GMwhis"] = gmwhisslash;

SLASH_GMperm1 = '/perm';
local function GMperm(msg, editbox)
local login, note = msg:match("^(%S*)%s*(.-)$");
--	print("login:"..login);print("note:"..note);
	SendSystemMessage(".ban acc "..login.." -1 "..note.." ");
	SendChatMessage(".ban acc "..login.." -1 "..note.." ", "GUILD");
end
SlashCmdList["GMperm"] = GMperm;

SLASH_GMstat1 = '/stat';
local function GMstat1(msg, editbox)
	GMstat();
end
SlashCmdList["GMstat"] = GMstat1;

SLASH_GMhunt1 = '/hunt';
local function GMhunt(msg, editbox)
	if msg == "" then
		gmon();
	elseif msg == "off" then
		gmoff();
	else
		DEFAULT_CHAT_FRAME:AddMessage('wpisz:');
		SendSystemMessage('/hunt - wlacza tryb polowania na bugerow\ngmmode: on znaczek blizz:on widocznosc dla graczy:off wship:off');
		SendSystemMessage('/hunt off - zmienia stany podane wyzej na przeciwne :D');
	end
end
SlashCmdList["GMhunt"] = GMhunt;

function gmmh_init()
--	GMMHForm:Hide();
	DEFAULT_CHAT_FRAME:AddMessage("\nGM Macro Help 3.1 loaded\nwiecej info pod /gm /gmmh\n", 0, 1, 0, nil, true);
GMstat();
end

function app(login)
	SendChatMessage(".app "..login.." ", "GUILD");
end

function test(msg, editbox)
local ad1, ad2, ad3, ad4 = msg:match("^(%S*)%s*(%S*)%s*(.-)$");
	if ad1 == nil then ad1 = ""; end
	if ad2 == nil then ad2 = ""; end
	if ad3 == nil then ad3 = ""; end
	if ad4 == nil then ad4 = ""; end
	print("a1: "..ad1.." a2: "..ad2.." a3: "..ad3.." a4: "..ad4);
end

SLASH_GMapp1 = '/app';
local function GMapp(msg, editbox)
	if msg == "" then
		app(login);--print("login"..login);
	else
		app(msg);login=msg;--print("msg"..msg);
	end
end
SlashCmdList["GMapp"] = GMapp;

function infohack(msg, editbox)
local acc, info = msg:match("^(%S*)%s*(.-)$");
--	print("IH:"..info);
	if bahunt then if hunt==false then if info == "Possible cheater!" then gmon(); end end end
end

function infoapp(msg, editbox)
local info, acc = msg:match("^(%S*)%s*(.-)$");
	if info == "Appearing" then  
		local i1 = string.find( acc, "%[");
		local i2 = string.find( acc, "%]");
--		print("IH:"..info);
--		print("ACC:"..acc);
--		print("i1 "..i1.." i2 "..i2.." ");
		sub=string.sub(acc, (i1+1), (i2-1));
--		print("SUB:"..sub);
		login=sub;
	end
end

function ahunts(stat)
	if stat == true then bahunt=true; SendSystemMessage('auto hunt: ON');end
	if stat == false then bahunt=false; SendSystemMessage('auto hunt: OFF');end
end

function autohunt()
	if bahunt then ahunts(false);
		else ahunts(true);
	end
end

SLASH_Ahunt1 = '/ahunt';
local function Ahunt(msg, editbox)
	if msg == "" then
		autohunt();--print("login"..login);
	elseif msg == "off" then
		ahunts(false);
	elseif msg == "on" then
		ahunts(true);
	else
		SendSystemMessage("/ahunt (tylko 3 opcje on, off i zadna)");
	end
end
SlashCmdList["Ahunt"] = Ahunt;

SLASH_GMTic1 = '/tic';
local function GMtic(msg, editbox)
local comm, stan = msg:match("^(%S*)%s*(.-)$");
--	print("login:"..login);print("note:"..note);
--	SendSystemMessage(".ban acc "..login.." -1 "..note.." ");
--	SendChatMessage(".tic "..comm.." "..stan.." ", "GUILD");
	if comm == "" then
		SendChatMessage(".tic online", "GUILD");
	elseif comm == "d" then
		SendChatMessage(".tic del "..stan, "GUILD");
	elseif comm == "c" then
		SendChatMessage(".tic c "..stan, "GUILD");
	elseif comm == "n" then
		SendChatMessage(".tic name "..stan, "GUILD");
	elseif comm == "o" then
		SendChatMessage(".tic off", "GUILD");
	else
		SendChatMessage(".tic vi "..comm, "GUILD");
	end
end
SlashCmdList["GMTic"] = GMtic;
