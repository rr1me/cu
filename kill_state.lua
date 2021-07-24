script_version('2.3')

local ini = require 'inicfg'
local ev = require 'lib.samp.events'

local color = 0xFFFFFFFF

cfgtable = {
	a = {b = ""},
  main = {
		acownstate = true,
    px = 389,
    py = 735,
    osk = true,
    osd = true,
    oskd = true,
    osdmg = true,
    osdmgpl = true,
    oskpl = true,
    maxkills = true,
    maxdmg = true,
		shots = true,
		hits = true,
		misses = true,
		accuracy = true,
		sr = 4,
		srt = false,
		ownstatewcolor = 0xffffffff,
		ownstatencolor = 0xffff7400,
		ownstatefont = 'arial',
		ownstatefontflag = 5,
		ownstatefontsize = 10,
		pluskill = true,
		pluskilltype = 1,
		pluskillcolortypef = 0,
		pluskillcolortypefvar = 'r',
		pkillcx = (select(1, getScreenResolution())/2)-100,
		pkillcy = (select(2, getScreenResolution())/2)-400,
		pkillcolor = 0xffff0000,
		pkilldisol = 0.02,
		pkilltud = 1,
		pkilltuu = 1,
		pkillup = 0.6,
		pkillfontflag = 5,
		pkillfont = 'arial',
		pkillfontsize = 50
  }
}

if not doesFileExist("moonloader/config/killstate.ini") then
  ini.save(cfgtable, "killstate.ini")
end

local cfg = ini.load({
    a = {
        b = "",
    },
}, "killstate.ini")

if cfg.main == nil then
	cfg = cfgtable
	ini.save(cfg, "killstate.ini")
else
	for k, v in pairs(cfgtable.main) do
		if cfg.main[k] == nil then
			cfg.main[k] = cfgtable.main[k]
			ini.save(cfg, "killstate.ini")
			cfg = ini.load({
			    a = {
			        b = "",
			    },
			}, "killstate.ini")
		end
	end
end

local img = require 'imgui'
img.ToggleButton = require('imgui_addons').ToggleButton
img.HotKey = require('imgui_addons').HotKey
img.Spinner = require('imgui_addons').Spinner
img.BufferingBar = require('imgui_addons').BufferingBar
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local dls = require('moonloader').download_status

local lanes = require('lanes').configure()

function apply_custom_style()
	img.SwitchContext()
	local style = img.GetStyle()
	local colors = style.Colors
	local clr = img.Col
	local ImVec4 = img.ImVec4
	local ImVec2 = img.ImVec2
	style.WindowPadding = ImVec2(10, 5)
	style.WindowRounding = 5.0
	style.FramePadding = ImVec2(3, 3)
	style.ItemSpacing = ImVec2(5.0, 4.0)
	style.ItemInnerSpacing = ImVec2(8, 6)
	style.IndentSpacing = 25.0
	style.ScrollbarSize = 15.0
	style.ScrollbarRounding = 9.0
	style.GrabMinSize = 5.0
	style.GrabRounding = 3.0
	colors[clr.Text] = ImVec4(0.80, 0.80, 0.83, 1.00)
	colors[clr.TextDisabled] = ImVec4(0.24, 0.23, 0.29, 1.00)
	colors[clr.WindowBg] = ImVec4(0.06, 0.05, 0.07, 1.00)
	colors[clr.ChildWindowBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
	colors[clr.PopupBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
	colors[clr.Border] = ImVec4(0.80, 0.80, 0.83, 0.88)
	colors[clr.BorderShadow] = ImVec4(0.92, 0.91, 0.88, 0.00)
	colors[clr.FrameBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
	colors[clr.FrameBgHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
	colors[clr.FrameBgActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
	colors[clr.TitleBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
	colors[clr.TitleBgCollapsed] = ImVec4(1.00, 0.98, 0.95, 0.75)
	colors[clr.TitleBgActive] = ImVec4(0.07, 0.07, 0.09, 1.00)
	colors[clr.MenuBarBg] = ImVec4(0.06, 0.05, 0.07, 1.00)
	colors[clr.ScrollbarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
	colors[clr.ScrollbarGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
	colors[clr.ScrollbarGrabHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
	colors[clr.ScrollbarGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
	colors[clr.CheckMark] = ImVec4(0.80, 0.80, 0.83, 0.31)
	colors[clr.SliderGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
	colors[clr.SliderGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
	colors[clr.Button] = ImVec4(0.10, 0.09, 0.12, 1.00)
	colors[clr.ButtonHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
	colors[clr.ButtonActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
	colors[clr.Header] = ImVec4(0.10, 0.09, 0.12, 1.00)
  colors[clr.HeaderHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
  colors[clr.HeaderActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
	colors[clr.ResizeGrip] = ImVec4(0.24, 0.23, 0.29, 1.00)
	colors[clr.ResizeGripHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
	colors[clr.ResizeGripActive] = ImVec4(0.76, 0.76, 0.78, 1.00)
	colors[clr.PlotLines] = ImVec4(0.40, 0.39, 0.38, 0.63)
	colors[clr.PlotLinesHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
	colors[clr.PlotHistogram] = ImVec4(0.40, 0.39, 0.38, 0.63)
	colors[clr.PlotHistogramHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
	colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
	colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
end
apply_custom_style()

function explode_argb(argb)
  local a = bit.band(bit.rshift(argb, 24), 0xFF)
  local r = bit.band(bit.rshift(argb, 16), 0xFF)
  local g = bit.band(bit.rshift(argb, 8), 0xFF)
  local b = bit.band(argb, 0xFF)
  return a, r, g, b
end

function argb2imvec4(a,r,g,b)
	c1 = 1/100*(r/255*100)
	c2 = 1/100*(g/255*100)
	c3 = 1/100*(b/255*100)
	c4 = 1/100*(a/255*100)
	return c1, c2, c3, c4
end

function img.CustomSelectable(label, textcolor, selcolor, selected)
	img.PushStyleColor(img.Col.Text, textcolor)
	img.PushStyleColor(img.Col.HeaderHovered, selcolor)
	if selected == nil then selected = false end
	if size == nil then size = img.ImVec2(0,0) end
	result = img.Selectable(label, selected)
	img.PopStyleColor(2)
	return result
end

function async_http_request(url, args, resolve, reject)
	canupdate = false
    local request_lane = lanes.gen('*', {package = {path = package.path, cpath = package.cpath}}, function()
        local requests = require 'socket.http'
        if not requests then
            return false, result
        end
        local ok, result = pcall(requests.request, url, args)
        if ok then
            return true, result
        else
            return false, result
        end
    end)
    if not reject then reject = function() end end
    lua_thread.create(function()
        local lh = request_lane()
        if not lh then
            return
        end
        while true do
            local status = lh.status
            if status == 'done' then
                local ok, result = lh[1], lh[2]
                if ok then resolve(result) else reject(result) end
                return
            elseif status == 'error' then
                return reject(lh[1])
            elseif status == 'killed' or status == 'cancelled' then
                return reject(status)
            end
            wait(1)
        end
    end)
	canupdate = true
end

function join_argb(a, r, g, b)
  local argb = b
  argb = bit.bor(argb, bit.lshift(g, 8))
  argb = bit.bor(argb, bit.lshift(r, 16))
  argb = bit.bor(argb, bit.lshift(a, 24))
  return argb
end

function argb2abgr(argb)
	local a,r,g,b = explode_argb(argb)
	return join_argb(a,b,g,r)
end

local ks = {}

local kl = img.ImBool(false)
local finds = img.ImBuffer(256)

local tdmg = 0
local dmgpl = 0
local maxdmg = 0
local kills = 0
local kpl = 0
local maxkills = 0
local deaths = 0
local font
local ownstatefontsize = img.ImInt(cfg.main.ownstatefontsize)
local ownstatefontflag = img.ImInt(cfg.main.ownstatefontflag)
local ownstatefont = img.ImBuffer(256)

local acownstate = img.ImBool(cfg.main.acownstate)
local osk = img.ImBool(cfg.main.osk)
local osd = img.ImBool(cfg.main.osd)
local oskd = img.ImBool(cfg.main.oskd)
local osdmg = img.ImBool(cfg.main.osdmg)
local osdmgpl = img.ImBool(cfg.main.osdmgpl)
local oskpl = img.ImBool(cfg.main.oskpl)
local osmk = img.ImBool(cfg.main.maxkills)
local osmd = img.ImBool(cfg.main.maxdmg)
local srt = img.ImBool(cfg.main.srt)

local ownstatewcolor = img.ImFloat4(img.ImColor(argb2abgr(cfg.main.ownstatewcolor)):GetFloat4())
local ownstatencolor = img.ImFloat4(img.ImColor(argb2abgr(cfg.main.ownstatencolor)):GetFloat4())
local wcol = bit.tohex(cfg.main.ownstatewcolor)
local ncol = bit.tohex(cfg.main.ownstatencolor)

local pluskill = img.ImBool(cfg.main.pluskill)
local pluskilltype = img.ImInt(cfg.main.pluskilltype)
local pluskillcolortypef = img.ImInt(cfg.main.pluskillcolortypef)
local pluskillcolortypefvar = cfg.main.pluskillcolortypefvar

local pkillcolor = img.ImFloat4(img.ImColor(argb2abgr(cfg.main.pkillcolor)):GetFloat4())
local pkilldisol = img.ImFloat(cfg.main.pkilldisol)
local pkilltud = img.ImFloat(cfg.main.pkilltud)
local pkilltuu = img.ImFloat(cfg.main.pkilltuu)
local pkillup = img.ImFloat(cfg.main.pkillup)
local pkillfontsize = img.ImInt(cfg.main.pkillfontsize)
local pkillfontflag = img.ImInt(cfg.main.pkillfontflag)
local pfont
local pkillfont = img.ImBuffer(256)
local st = os.clock()

local shots = img.ImBool(cfg.main.shots)
local hits = img.ImBool(cfg.main.hits)
local misses = img.ImBool(cfg.main.misses)
local accuracy = img.ImBool(cfg.main.accuracy)
local shotcount = 0
local hitcount = 0

local mc = 0.1428571428571429
local icc = {
	[0] = {x1 = mc, x2 = mc * 2, y1 = mc * 3, y2 = mc*4},
	[1] = {x1 = 0, x2 = mc, y1 = 0, y2 = mc},
	[2] = {x1 = mc*2, x2 = mc*4, y1 = mc*2, y2 = mc*3},
	[3] = {x1 = mc*4, x2 = mc*5, y1 = mc*4, y2 = mc*5},
	[4] = {x1 = mc*5, x2 = mc*6, y1 = 0, y2 = mc},
	[5] = {x1 = mc*5, x2 = mc*6, y1 = mc*5, y2 = mc*5},
	[6] = {x1 = mc*6, x2 = 1, y1 = mc, y2 = mc*2},
	[7] = {x1 = mc*3, x2 = mc*4, y1 = mc*5, y2 = mc*6},
	[8] = {x1 = mc*4, x2 = mc*5, y1 = mc*3, y2 = mc*4},
	[9] = {x1 = mc, x2 = mc*2, y1 = 0, y2 = mc},
	[10] = {x1 = mc, x2 = mc*2, y1 = mc*4, y2 = mc*5},
	[11] = {x1 = mc*4, x2 = mc*5, y1 = mc, y2 = mc*2},
	[12] = {x1 = mc*3, x2 = mc*4, y1 = mc*3, y2 = mc*4},
	[13] = {x1 = mc*2, x2 = mc*3, y1 = mc*4, y2 = mc*5},
	[14] = {x1 = mc*2, x2 = mc*3, y1 = mc*3, y2 = mc*4},
	[15] = {x1 = 0, x2 = mc, y1 = mc*4, y2 = mc*5},
	[16] = {x1 = mc*4, x2 = mc*5, y1 = 0, y2 = mc},
	[17] = {x1 = mc*5, x2 = mc*6, y1 = mc*4, y2 = mc*5},
	[18] = {x1 = mc*2, x2 = mc*3, y1 = mc*5, y2 = mc*6},
	[22] = {x1 = mc, x2 = mc*2, y1 = mc, y2 = mc*2},
	[23] = {x1 = mc*2, x2 = mc*3, y1 = mc*6, y2 = 1},
	[24] = {x1 = mc, x2 = mc*2, y1 = mc*2, y2 = mc*3},
	[25] = {x1 = 0, x2 = mc, y1 = mc, y2 = mc*2},
	[26] = {x1 = 0, x2 = mc, y1 = mc*6, y2 = 1},
	[27] = {x1 = mc, x2 = mc*2, y1 = mc*6, y2 = 1},
	[28] = {x1 = mc, x2 = mc*2, y1 = mc*5, y2 = mc*6},
	[29] = {x1 = mc*5, x2 = mc*6, y1 = mc*2, y2 = mc*3},
	[30] = {x1 = mc*6, x2 = 1, y1 = mc*3, y2 = mc*4},
	[31] = {x1 = 0, x2 = mc, y1 = mc*5, y2 = mc*6},
	[32] = {x1 = mc*3, x2 = mc*4, y1 = mc*6, y2 = 1},
	[33] = {x1 = mc*2, x2 = mc*3, y1 = 0, y2 = mc},
	[34] = {x1 = mc*6, x2 = 1, y1 = mc*2, y2 = mc*3},
	[35] = {x1 = mc*5, x2 = mc*6, y1 = mc*3, y2 = mc*4},
	[36] = {x1 = mc*4, x2 = mc*5, y1 = mc*2, y2 = mc*3},
	[37] = {x1 = mc*3, x2 = mc*4, y1 = mc, y2 = mc*2},
	[38] = {x1 = mc*5, x2 = mc*6, y1 = mc, y2 = mc*2},
	[39] = {x1 = mc*6, x2 = 1, y1 = 0, y2 = mc},
	[41] = {x1 = mc*4, x2 = mc*5, y1 = mc*5, y2 = mc*6},
	[42] = {x1 = 0, x2 = mc, y1 = mc*3, y2 = mc*4},
	[47] = {x1 = 0, x2 = mc, y1 = mc*2, y2 = mc*3},
	[49] = {x1 = mc*2, x2 = mc*3, y1 = mc, y2 = mc*2},
	[50] = {x1 = mc*3, x2 = mc*4, y1 = mc*4, y2 = mc*5},
	[51] = {x1 = mc*2, x2 = mc*3, y1 = mc*2, y2 = mc*3},
	[53] = {x1 = 0, x2 = mc, y1 = mc*2, y2 = mc*3},
	[54] = {x1 = mc*3, x2 = mc*4, y1 = 0, y2 = mc},
	[200] = {x1 = 0, x2 = mc, y1 = mc*2, y2 = mc*3},
	[201] = {x1 = 0, x2 = mc, y1 = mc*2, y2 = mc*3},
	[255] = {x1 = 0, x2 = mc, y1 = mc*2, y2 = mc*3}
}

local icons
local hist = img.ImBool(false)
local windows = {}
local coords = {
	x,y
}

local exfont = nil
function img.BeforeDrawFrame()
    if exfont == nil then
        exfont = img.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14)..'\\trebucbd.ttf', 16.0, nil, img.GetIO().Fonts:GetGlyphRangesCyrillic())
    end
end

function img.OnDrawFrame()
	img.SetNextWindowPos(img.ImVec2(img.GetIO().DisplaySize.x / 2, img.GetIO().DisplaySize.y / 2), img.Cond.FirstUseEver, img.ImVec2(0.5, 0.5))
	img.SetNextWindowSize(img.ImVec2(385, 300), img.Cond.FirstUseEver)
	img.Begin('Kill State by Eenz Hatte', kl, img.WindowFlags.NoCollapse)
	if img.Button(u8'Сбросить статистику') then
		img.OpenPopup('statistic')
	end
	if img.BeginPopup('statistic', 0) then
		if img.Button(u8'Личную') then
			tdmg = 0
			dmgpl = 0
			maxdmg = 0
			kills = 0
			kpl = 0
			maxkills = 0
			deaths = 0
			shotcount = 0
			hitcount = 0
			sampAddChatMessage('{A800FF}[Kill State by Eenz Hatte]{ffffff}Личная статистика сброшена.', 0xFFFFFFFF)
			img.CloseCurrentPopup()
		end
		if img.Button(u8'Общую') then
			ks = {}
			sampAddChatMessage('{A800FF}[Kill State by Eenz Hatte]{ffffff}Общая статистика сброшена.', 0xFFFFFFFF)
			img.CloseCurrentPopup()
		end
		if img.Button(u8'Всю') then
			ks = {}
			tdmg = 0
			dmgpl = 0
			maxdmg = 0
			kills = 0
			kpl = 0
			maxkills = 0
			deaths = 0
			shotcount = 0
			hitcount = 0
			sampAddChatMessage('{A800FF}[Kill State by Eenz Hatte]{ffffff}Вся статистика сброшена.', 0xFFFFFFFF)
			img.CloseCurrentPopup()
		end
		img.EndPopup()
	end
	_,id = sampGetPlayerIdByCharHandle(playerPed)
	a,r,g,b = explode_argb(sampGetPlayerColor(id))
	c1, c2, c3, c4 = argb2imvec4(a, r, g, b)
	img.SameLine()
	if img.Button(u8'Сортировка') then
		img.OpenPopup('sort')
	end
	if img.BeginPopup('sort', 0) then
		if img.RadioButton(u8'По алфавиту', cfg.main.sr == 1) then
			cfg.main.sr = 1
		end
		if img.RadioButton(u8'По убийствам', cfg.main.sr == 2) then
			cfg.main.sr = 2
		end
		if img.RadioButton(u8'По смертям', cfg.main.sr == 3) then
			cfg.main.sr = 3
		end
		if img.RadioButton(u8'По K/D', cfg.main.sr == 4) then
			cfg.main.sr = 4
		end
		img.Image(icons, img.ImVec2(10,10), img.ImVec2(.87,.59), img.ImVec2(.97,.69))
		img.SameLine()
		if img.ToggleButton('##1', srt) then
			cfg.main.srt = srt.v
		end
		img.SameLine()
		img.Image(icons, img.ImVec2(10,10), img.ImVec2(.87,.72), img.ImVec2(.97,.82))
		img.EndPopup()
	end
	img.SameLine()
	if img.Button(u8'Личная статистика') then
		img.OpenPopup('ownstate')
	end
	if img.BeginPopup('ownstate', 0) then
		img.Text(u8'Активация')
		img.SameLine()
		if img.ToggleButton('##1', acownstate) then
			cfg.main.acownstate = acownstate.v
		end
		img.SameLine()
		if img.Button(u8'Позиция текста', img.ImVec2(116, 20)) then
			kl.v = false
			lua_thread.create(crd)
		end
		img.Separator()
		img.PushItemWidth(165)
		img.InputText(u8'Шрифт', ownstatefont)
		if img.Button(u8'Применить шрифт', img.ImVec2(215, 20)) then
			cfg.main.ownstatefont = ownstatefont.v
			font = renderCreateFont(ownstatefont.v, cfg.main.ownstatefontsize, cfg.main.ownstatefontflag)
		end
		img.PushItemWidth(123)
		img.Text(u8'Текущий: '..cfg.main.ownstatefont)
		if img.InputInt(u8'Размер текста', ownstatefontsize) then
			ownstatefontsize.v = LimitInputInt(0, 300, ownstatefontsize.v)
			cfg.main.ownstatefontsize = ownstatefontsize.v
			font = renderCreateFont(cfg.main.ownstatefont, ownstatefontsize.v, cfg.main.ownstatefontflag)
		end
		if img.InputInt(u8'Флаг текста', ownstatefontflag) then
			ownstatefontflag.v = LimitInputInt(0, 300, ownstatefontflag.v)
			cfg.main.ownstatefontflag = ownstatefontflag.v
			font = renderCreateFont(cfg.main.ownstatefont, cfg.main.ownstatefontsize, ownstatefontflag.v)
		end
		img.PopItemWidth()
		img.Separator()
		if img.Checkbox(u8'Kills', osk) then
			cfg.main.osk = osk.v
		end
		img.SameLine(120)
		if img.Checkbox(u8'KD', oskd) then
			cfg.main.oskd = oskd.v
		end
		if img.Checkbox(u8'Deaths', osd) then
			cfg.main.osd = osd.v
		end
		img.SameLine(120)
		if img.Checkbox('Damage', osdmg) then
			cfg.main.osdmg = osdmg.v
		end
		if img.Checkbox(u8'Kills/life', oskpl) then
			cfg.main.oskpl = oskpl.v
		end
		img.SameLine(120)
		if img.Checkbox(u8'Dmg/life', osdmgpl) then
			cfg.main.osdmgpl = osdmgpl.v
		end
		if img.Checkbox('Kill streak', osmk) then
			cfg.main.maxkills = osmk.v
		end
		img.SameLine(120)
		if img.Checkbox('Max dmg/life', osmd) then
			cfg.main.maxdmg = osmd.v
		end
		if img.Checkbox('Shots', shots) then
			cfg.main.shots = shots.v
		end
		img.SameLine(120)
		if img.Checkbox('Hits', hits) then
			cfg.main.hits = hits.v
		end
		if img.Checkbox('Misses', misses) then
			cfg.main.misses = misses.v
		end
		img.SameLine(120)
		if img.Checkbox('Accuracy', accuracy) then
			cfg.main.accuracy = accuracy.v
		end
		img.Separator()
		if img.Button(u8'Цвета', img.ImVec2(105, 20)) then
			img.OpenPopup('colors')
		end
		if img.BeginPopup('colors') then
			img.PushItemWidth(145)
			img.Text(u8'Цвет слов')
			if img.ColorEdit4(u8'##oscolor', ownstatewcolor) then
				clr = img.ImColor.FromFloat4(ownstatewcolor.v[3], ownstatewcolor.v[2], ownstatewcolor.v[1], ownstatewcolor.v[4]):GetU32()
				cfg.main.ownstatewcolor = clr
				wcol = bit.tohex(cfg.main.ownstatewcolor)
			end
			img.Separator()
			img.Text(u8'Цвет цифр')
			if img.ColorEdit4(u8'##oscolor1', ownstatencolor) then
				clr = img.ImColor.FromFloat4(ownstatencolor.v[3], ownstatencolor.v[2], ownstatencolor.v[1], ownstatencolor.v[4]):GetU32()
				cfg.main.ownstatencolor = clr
				ncol = bit.tohex(cfg.main.ownstatencolor)
			end
			img.SameLine()
			if img.ImageButton(icons, img.ImVec2(10,10), img.ImVec2(.87,.59), img.ImVec2(.97,.69)) then
				cfg.main.ownstatencolor = cfg.main.ownstatewcolor
				ownstatencolor = img.ImFloat4(img.ImColor(argb2abgr(cfg.main.ownstatewcolor)):GetFloat4())
				ncol = bit.tohex(cfg.main.ownstatencolor)
			end
			if img.IsItemHovered() then
				img.BeginTooltip()
				img.Text(u8'Использовать цвет слов')
				img.EndTooltip()
			end
			img.PopItemWidth()
			img.EndPopup()
		end
		img.SameLine()
		if img.Button(u8'+KILL', img.ImVec2(105, 20)) then
			img.OpenPopup('pluskill')
		end
		if img.BeginPopup('pluskill', 0) then
			if img.Checkbox(u8'Активация', pluskill) then
				cfg.main.pluskill = pluskill.v
			end
			if pluskilltype.v == 1 then
				img.SameLine(212)
				if img.Button(u8'Позиция текста', img.ImVec2(117, 20)) then
					kl.v = false
					lua_thread.create(crdpkill)
				end
			end
			img.PushItemWidth(145)
			if img.Combo(u8'Формат', pluskilltype, 'printStyledString\0renderFontDrawText\0') then
				cfg.main.pluskilltype = pluskilltype.v
			end
			if pluskilltype.v == 0 and pluskill.v then
				if os.clock() - st >= cfg.main.pkilltud + 1 then
				  printStyledString('~'..cfg.main.pluskillcolortypefvar..'~~h~+KILL', cfg.main.pkilltud*1000, 7)
					st = os.clock()
				end
				if img.SliderFloat(u8'Задержка', pkilltud, 0.0, 10) then
					cfg.main.pkilltud = pkilltud.v
				end
				if img.Combo(u8'Цвет', pluskillcolortypef, u8'Красный\0Зелёный\0Синий\0Белый\0Жёлтный\0Фиолетовый\0Чёрный\0') then
					cfg.main.pluskillcolortypef = pluskillcolortypef.v
					if pluskillcolortypef.v == 0 then
						cfg.main.pluskillcolortypefvar = 'r'
					elseif pluskillcolortypef.v == 1 then
						cfg.main.pluskillcolortypefvar = 'g'
					elseif pluskillcolortypef.v == 2 then
						cfg.main.pluskillcolortypefvar = 'b'
					elseif pluskillcolortypef.v == 3 then
						cfg.main.pluskillcolortypefvar = 'w'
					elseif pluskillcolortypef.v == 4 then
						cfg.main.pluskillcolortypefvar = 'y'
					elseif pluskillcolortypef.v == 5 then
						cfg.main.pluskillcolortypefvar = 'p'
					elseif pluskillcolortypef.v == 6 then
						cfg.main.pluskillcolortypefvar = 'l'
					end
				end
			else
				if pluskill.v then pkillac = true end
				img.SameLine()
				if img.Button(u8'Применить шрифт', img.ImVec2(117, 20)) then
					cfg.main.pkillfont = pkillfont.v
					pfont = renderCreateFont(pkillfont.v, cfg.main.pkillfontsize, cfg.main.pkillfontflag)
				end
				img.InputText(u8'Шрифт. Текущий:'..cfg.main.pkillfont, pkillfont)
				if img.InputInt(u8'Размер текста', pkillfontsize) then
					pkillfontsize.v = LimitInputInt(0, 300, pkillfontsize.v)
					cfg.main.pkillfontsize = pkillfontsize.v
					pfont = renderCreateFont(cfg.main.pkillfont, pkillfontsize.v, cfg.main.pkillfontflag)
				end
				if img.InputInt(u8'Флаг текста', pkillfontflag) then
					pkillfontflag.v = LimitInputInt(0, 300, pkillfontflag.v)
					cfg.main.pkillfontflag = pkillfontflag.v
					pfont = renderCreateFont(cfg.main.pkillfont, cfg.main.pkillfontsize, pkillfontflag.v)
				end
				if img.SliderFloat(u8'Задержка растворения', pkilltud, 0.0, 10) then
					cfg.main.pkilltud = pkilltud.v
				end
				if img.SliderFloat(u8'Задержка поднятия', pkilltuu, 0.0, 10) then
					cfg.main.pkilltuu = pkilltuu.v
				end
				img.SameLine()
				if img.ImageButton(icons, img.ImVec2(10,10), img.ImVec2(.87,.59), img.ImVec2(.97,.69)) then
					cfg.main.pkilltuu = pkilltud.v
					pkilltuu.v = pkilltud.v
				end
				if img.IsItemHovered() then
					img.BeginTooltip()
					img.Text(u8'Использовать задержку растворения')
					img.EndTooltip()
				end
				if img.SliderFloat(u8'Интенсивность растворения', pkilldisol, 0.0, 0.03) then
					cfg.main.pkilldisol = pkilldisol.v
				end
				if img.SliderFloat(u8'Интенсивность поднятия', pkillup, 0.0, 3) then
					cfg.main.pkillup = pkillup.v
				end
				if img.ColorEdit4(u8'Цвет', pkillcolor) then
					clr = img.ImColor.FromFloat4(pkillcolor.v[3], pkillcolor.v[2], pkillcolor.v[1], pkillcolor.v[4]):GetU32()
					cfg.main.pkillcolor = clr
				end
			end
			img.PopItemWidth()
			img.EndPopup()
		end
		img.EndPopup()
	end
	img.InputText('Search', finds)
	img.Text('Nick')
	img.SameLine(200)
	img.Text('Kills')
	img.SameLine(260)
	img.Text('Deaths')
	img.SameLine(325)
	img.Text('K/D')
	img.Separator()

	if cfg.main.sr == 1 then
		table.sort(ks, function(a,b) if srt.v then return a.nick:lower() > b.nick:lower() else return a.nick:lower() < b.nick:lower() end end)
	elseif cfg.main.sr == 2 then
		table.sort(ks,
		function(a,b)
			if a.kills == b.kills then
				if a.deaths ~= b.deaths then
					if srt.v then return a.deaths > b.deaths else return a.deaths < b.deaths end
				else
					return a.nick:lower() < b.nick:lower()
				end
			else
				if srt.v then return a.kills < b.kills else return a.kills > b.kills end
			end
		end)
	elseif cfg.main.sr == 3 then
		table.sort(ks,
	  function(a,b)
			if a.deaths == b.deaths then
				if a.kills ~= b.kills then
					if srt.v then return a.kills < b.kills else return a.kills > b.kills end
				else
					return a.nick:lower() < b.nick:lower()
				end
			else
				if srt.v then return a.deaths < b.deaths else return a.deaths > b.deaths end
			end
		end)
	elseif cfg.main.sr == 4 then
		table.sort(ks,
		function(a,b)
			if a.kd ~= b.kd then
				if srt.v then return a.kd < b.kd else return a.kd > b.kd end
			else
				if a.kills ~= b.kills then
					if srt.v then return a.kills < b.kills else return a.kills > b.kills end
				elseif a.deaths ~= b.deaths then
					if srt.v then return a.deaths > b.deaths else return a.deaths < b.deaths end
				else
				  return a.nick:lower() < b.nick:lower()
			  end
			end
		end
	  )
	end

	for n, t in pairs(ks) do
		if windows[ks[n].nick] == nil then windows[ks[n].nick] = {ac = img.ImBool(false), showkills = img.ImBool(true), showdeaths = img.ImBool(true)} end
		v = ks[n].nick
		a,r,g,b = explode_argb(ks[n].col)
		c1, c2, c3, c4 = argb2imvec4(a, r, g, b)
		if v:lower():find(finds.v:lower()) and finds.v ~= '' then
			if img.CustomSelectable(u8(v)..'['..ks[n].id..']', img.ImVec4(c1, c2, c3, 1), img.ImVec4(0.26, 0.26, 0.28, 1.00), true) then
				img.OpenPopup(ks[n].nick)
			end
			img.SameLine(200)
			img.Text(tostring(ks[n].kills))
			img.SameLine(260)
			img.Text(tostring(ks[n].deaths))
			img.SameLine(325)
			img.Text(string.format("%.2f", tostring(ks[n].kd)))
			img.Separator()
		elseif finds.v == '' then
			if img.CustomSelectable(ks[n].nick..'['..ks[n].id..']', img.ImVec4(c1, c2, c3, 1), img.ImVec4(0.21, 0.21, 0.23, 1.00), true) then
				img.OpenPopup(ks[n].nick)
			end
			img.SameLine(200)
			img.Text(tostring(ks[n].kills))
			img.SameLine(260)
			img.Text(tostring(ks[n].deaths))
			img.SameLine(325)
			img.Text(string.format("%.2f", tostring(ks[n].kd)))
			img.Separator()
		end
		if img.BeginPopup(ks[n].nick, 0) then
			img.TextColored(img.ImVec4(c1, c2, c3, 1), ks[n].nick..'['..ks[n].id..']')
			img.Separator()
			img.Text(u8'Скопировать')
			if img.Button(u8'ID') then
				if ks[n].id ~= 'off' then
					img.SetClipboardText(tostring(ks[n].id))
					img.CloseCurrentPopup()
				else
					sampAddChatMessage('{A800FF}[Kill State by Eenz Hatte]{ffffff}Игрок вышел.')
				end
			end
			img.SameLine()
			if img.Button(u8'Ник') then
				img.SetClipboardText(tostring(ks[n].nick))
				img.CloseCurrentPopup()
			end
			img.SameLine()
			if img.Button(u8'Ник[ID]') then
				img.SetClipboardText(tostring(ks[n].nick..'['..ks[n].id..']'))
				img.CloseCurrentPopup()
			end
			if img.Button(u8'Ник[ID] и статистику') then
				img.SetClipboardText(tostring(ks[n].nick..'['..ks[n].id..'] | Kills:'..ks[n].kills..' | Deaths:'..ks[n].deaths..' | KD:'..string.format("%.2f", tostring(ks[n].kd))))
				img.CloseCurrentPopup()
			end
			img.Separator()
			if img.Button(u8'История', img.ImVec2(127, 20)) then
				windows[ks[n].nick].ac.v = not windows[ks[n].nick].ac.v
				math.randomseed(os.time())
				coords.x = math.random(7, 8)
				coords.x = '-0.'..coords.x..math.random(10)
				math.randomseed(os.time())
				coords.y = math.random(7, 8)
				coords.y = '0.'..coords.y..math.random(10)
			end
			img.EndPopup()
		end
	end
	historywindow()
	img.End()
end

function LimitInputInt(Min, Max, Value)
  if Value < Min then Value = Min end
  if Value > Max then Value = Max end
  return Value
end

function historywindow()
  for nick, t in pairs(windows) do
    if windows[nick].ac.v then
      for id, v1 in pairs(ks) do
        if ks[id].nick == nick then
          img.SetNextWindowPos(img.ImVec2(img.GetIO().DisplaySize.x / 2, img.GetIO().DisplaySize.y / 2), img.Cond.FirstUseEver, img.ImVec2(coords.x, coords.y))
          img.SetNextWindowSize(img.ImVec2(431, 300), img.Cond.FirstUseEver)
          img.Begin(nick..'['..ks[id].id..']', windows[nick].ac, img.WindowFlags.NoCollapse + img.WindowFlags.MenuBar)
          if img.BeginMenuBar() then
            if img.BeginMenu(u8'Сортировка') then
              img.Checkbox(u8'Показывать убийства', windows[nick].showkills)
              img.Checkbox(u8'Показывать смерти', windows[nick].showdeaths)
              img.EndMenu()
            end
            img.EndMenuBar()
          end
          img.Text(u8'Убийца')
          img.SameLine()
          img.SetCursorPosX((img.GetWindowWidth() - img.CalcTextSize(u8'Оружие').x) / 2)
          img.Text(u8'Оружие')
          img.SameLine()
          img.SetCursorPosX(img.GetWindowWidth() - img.CalcTextSize(u8'Убитый').x - 22)
          img.Text(u8'Убитый')
          img.Separator()
          img.PushFont(exfont)
          for n1, t1 in pairs(ks[id].history) do
            if (windows[nick].showkills.v and ks[id].nick == ks[id].history[n1].killer.nick) or (windows[nick].showdeaths.v and ks[id].nick == ks[id].history[n1].killed.nick) then
							if ks[id].history[n1].killer.nick ~= nil then
								a,r,g,b = explode_argb(ks[id].history[n1].killer.col)
								c1, c2, c3, c4 = argb2imvec4(a, r, g, b)
								img.TextColored(img.ImVec4(c1, c2, c3, 1), ks[id].history[n1].killer.nick)
							else
								img.Text(u8'Suicide')
							end
              img.SameLine()
              img.SetCursorPosX((img.GetWindowWidth() / 2) - 6)
              img.Image(icons, img.ImVec2(20, 20), img.ImVec2(icc[tonumber(ks[id].history[n1].weap)].x1, icc[tonumber(ks[id].history[n1].weap)].y1), img.ImVec2(icc[tonumber(ks[id].history[n1].weap)].x2, icc[tonumber(ks[id].history[n1].weap)].y2))
              img.SameLine()
              img.SetCursorPosX(img.GetWindowWidth() - img.CalcTextSize(ks[id].history[n1].killed.nick).x - 22)
							a,r,g,b = explode_argb(ks[id].history[n1].killed.col)
							c1, c2, c3, c4 = argb2imvec4(a, r, g, b)
							img.TextColored(img.ImVec4(c1, c2, c3, 1), ks[id].history[n1].killed.nick)
              img.Separator()
            end
          end
          img.PopFont()
          img.End()
        end
      end
    end
  end
end

local pkillacf = true
local coordY

function pkill()
  while true do wait(0)
    if pkillac then
      if pkillacf then
        coordY = cfg.main.pkillcy
        disol = 1
        timestart = os.clock()
        pkillacf = false
      end
      colwithdisol = img.ImColor.FromFloat4(pkillcolor.v[3], pkillcolor.v[2], pkillcolor.v[1], disol):GetU32()
      renderFontDrawText(pfont, '+KILL', cfg.main.pkillcx, coordY, colwithdisol)
			if os.clock() - timestart >= pkilltuu.v then
				coordY = coordY - pkillup.v
			end
      if pkilldisol.v > 0 then
        if os.clock() - timestart >= pkilltud.v and disol > 0 then
          disol = disol - pkilldisol.v
        elseif disol <= 0 then
					pkillacf = true
          pkillac = false
        end
			else
				if os.clock() - timestart >= pkilltud.v then
					pkillacf = true
					pkillac = false
				end
      end
    end
  end
end

function crd()
  while true do wait(0)
    sampSetCursorMode(3)
    cfg.main.px, cfg.main.py = getCursorPos()
		if not acownstate.v then
      renderFontDrawText(font, (osk.v and '{'..wcol..'}kills:{'..ncol..'}'..kills..'\n' or '')..(oskpl.v and '{'..wcol..'}kills/life:{'..ncol..'}'..kpl..'\n' or '')..(osmk.v and '{'..wcol..'}max kills/life:{'..ncol..'}'..maxkills..'\n' or '')..(osd.v and '{'..wcol..'}deaths:{'..ncol..'}'..deaths..'\n' or '')..(oskd.v and '{'..wcol..'}KD:{'..ncol..'}'..(kills/deaths == 1/0 and '{'..ncol..'}'..kills..'.00\n' or '')..(kills == 0 and '{'..ncol..'}0.00'..'\n' or '')..(kills > 0 and deaths > 0 and '{'..ncol..'}'..string.format("%.2f", kills/deaths)..'\n' or '') or '')..(osdmg.v and '{'..wcol..'}damage:{'..ncol..'}'..math.floor(tdmg)..'\n' or '')..(osdmgpl.v and '{'..wcol..'}dmg/life:{'..ncol..'}'..math.floor(dmgpl)..'\n' or '')..(osmd.v and '{'..wcol..'}max dmg/life:{'..ncol..'}'..math.floor(maxdmg)..'\n' or '')..(shots.v and '{'..wcol..'}shots:{'..ncol..'}'..shotcount..'\n' or '')..(hits.v and '{'..wcol..'}hits:{'..ncol..'}'..hitcount..'\n' or '')..(misses.v and '{'..wcol..'}misses:{'..ncol..'}'..shotcount - hitcount..'\n' or '')..(accuracy.v and '{'..wcol..'}accuracy:{'..ncol..'}'..(shotcount > 0 and ('%.2f'):format(hitcount/(shotcount/100)) or '0.00')..'%\n' or ''), cfg.main.px, cfg.main.py, 0xFFFFFFFF)
    end
		if isKeyJustPressed(1) then
			sampSetCursorMode(0)
			kl.v = true
			break
		end
	end
end

function crdpkill()
  while true do wait(0)
    sampSetCursorMode(3)
		pkillac = true
		pkillacf = true
		cfg.main.pkillcx, cfg.main.pkillcy = getCursorPos()
		if isKeyJustPressed(1) then
			sampSetCursorMode(0)
			kl.v = true
			break
		end
	end
end

function onScriptTerminate(script, quitGame)
	if script == thisScript() then
		ini.save(cfg, 'killstate.ini')
	end
end

function ev.onPlayerQuit(id, res)
	for n, t in pairs(ks) do
		if ks[n].id == id then
			ks[n].id = 'off'
		end
	end
end

function ev.onPlayerJoin(id, clist, isNPC, nick)
	for n, t in pairs(ks) do
		if ks[n].nick == nick and ks[n].id == 'off' then
			ks[n].id = id
		end
	end
end

function ev.onPlayerDeathNotification(killerId, killedId, reason)
	_,id = sampGetPlayerIdByCharHandle(playerPed)
	if killerId == id then
		kills = kills + 1
		kpl = kpl + 1
		if kpl > maxkills then
			maxkills = kpl
		end
		if pluskill.v then
			if pluskilltype.v == 0 then
			  lua_thread.create(function() wait(0) printStyledString('~'..cfg.main.pluskillcolortypefvar..'~~h~+KILL', cfg.main.pkilltud*1000, 7) end)
			else
				pkillac = true
				pkillacf = true
		  end
		end
	elseif killedId == id then
		dmgpl = 0
		kpl = 0
		deaths = deaths + 1
	end
	if not sampIsPlayerConnected(killerId) and not sampIsPlayerConnected(killedId) then return end
  if killerId ~= 65535 then knick = sampGetPlayerNickname(killerId) else knick = nil end
	knickd = sampGetPlayerNickname(killedId)
	kcol = sampGetPlayerColor(killerId)
	kcold = sampGetPlayerColor(killedId)
	if table.maxn(ks) == 0 then
		if knick ~= nil then
			table.insert(ks, {nick = knick, id = killerId, kills = 1, deaths = 0, kd = 1, col = kcol, history = {
				{
					killer = {
						nick = knick,
						col = kcol
					},
					killed = {
						nick = knickd,
						col = kcold,
					},
					weap = reason
				}
			}})
			table.insert(ks, {nick = knickd, id = killedId, kills = 0, deaths = 1, kd = 0, col = kcold, history = {
				{
					killer = {
						nick = knick,
						col = kcol
					},
					killed = {
						nick = knickd,
						col = kcold,
					},
					weap = reason
				}
			}})
		else
			table.insert(ks, {nick = knickd, id = killedId, kills = 0, deaths = 1, kd = 0, col = kcold, history = {
				{
					killer = {
						nick = nil,
						col = nil
					},
					killed = {
						nick = knickd,
						col = kcold,
					},
					weap = reason
				}
			}})
		end
	else
		if knick ~= nil then
			for n, t in pairs(ks) do
				if ks[n].nick ~= knick and n == table.maxn(ks) then
					table.insert(ks, {nick = knick, id = killerId, kills = 1, deaths = 0, kd = 1, col = kcol, history = {
						{
							killer = {
								nick = knick,
								col = kcol
							},
							killed = {
								nick = knickd,
								col = kcold,
							},
							weap = reason
						}
					}})
					break
				elseif ks[n].nick == knick then
					if ks[n].id ~= killerId then ks[n].id = killerId end
					if ks[n].col ~= kcol then ks[n].col = kcol end
					ks[n].kills = ks[n].kills + 1
					if ks[n].deaths ~= 0 then
						ks[n].kd = ks[n].kills/ks[n].deaths
					elseif ks[n].deaths == 0 then
						ks[n].kd = ks[n].kills
					end
					table.insert(ks[n].history, {
						killer = {
							nick = knick,
							col = kcol
						},
						killed = {
							nick = knickd,
							col = kcold,
						},
						weap = reason
					})
					break
				end
			end
			for n, t in pairs(ks) do
				if ks[n].nick ~= knickd and n == table.maxn(ks) then
					table.insert(ks, {nick = knickd, id = killedId, kills = 0, deaths = 1, kd = 0, col = kcold, history = {
						{
							killer = {
								nick = knick,
								col = kcol
							},
							killed = {
								nick = knickd,
								col = kcold,
							},
							weap = reason
						}
					}})
					break
				elseif ks[n].nick == knickd then
					if ks[n].id ~= killedId then ks[n].id = killedId end
					if ks[n].col ~= kcold then ks[n].col = kcold end
					ks[n].deaths = ks[n].deaths + 1
					if ks[n].kills ~= 0 then
						ks[n].kd = ks[n].kills/ks[n].deaths
					elseif ks[n].kills == 0 then
						ks[n].kd = 0
					end
					table.insert(ks[n].history, {
						killer = {
							nick = knick,
							col = kcol
						},
						killed = {
							nick = knickd,
							col = kcold,
						},
						weap = reason
					})
					break
				end
			end
		else
			for n, t in pairs(ks) do
				if ks[n].nick ~= knickd and n == table.maxn(ks) then
					table.insert(ks, {nick = knickd, id = killedId, kills = 0, deaths = 1, kd = 0, col = kcold, history = {
						{
							killer = {
								nick = nil,
								col = nil
							},
							killed = {
								nick = knickd,
								col = kcold,
							},
							weap = reason
						}
					}})
					break
				elseif ks[n].nick == knickd then
					if ks[n].id ~= killedId then ks[n].id = killedId end
					if ks[n].col ~= kcold then ks[n].col = kcold end
					ks[n].deaths = ks[n].deaths + 1
					if ks[n].kills ~= 0 then
						ks[n].kd = ks[n].kills/ks[n].deaths
					elseif ks[n].kills == 0 then
						ks[n].kd = 0
					end
					table.insert(ks[n].history, {
						killer = {
							nick = nil,
							col = nil
						},
						killed = {
							nick = knickd,
							col = kcold,
						},
						weap = reason
					})
					break
				end
			end
		end
	end
end

function ev.onSendBulletSync(d)
	if not sampIsPlayerPaused(playerId) then
		shotcount = shotcount + 1
	end
end

function ev.onSendGiveDamage(playerId, damage, weapon, bodyparts)
	if not sampIsPlayerPaused(playerId) then
		if weapon > 21 and weapon < 35 or weapon == 38 then
		  hitcount = hitcount + 1
		end
		if sampGetPlayerHealth(playerId) < damage then
			tdmg = tdmg + sampGetPlayerHealth(playerId)
			dmgpl = dmgpl + sampGetPlayerHealth(playerId)
		else
			tdmg = tdmg + damage
			dmgpl = dmgpl + damage
		end
		if dmgpl > maxdmg then
			maxdmg = dmgpl
		end
	end
end

--local connect

function main()
 	if not isSampLoaded() or not isSampfuncsLoaded() then return end
 	while not isSampAvailable() do wait(100) end
	lua_thread.create(pkill)
	ksv = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
	connect = nil
	downloadUrlToFile('https://raw.githubusercontent.com/rr1me/cu/main/ksv.json', ksv,
	function(id, status, p1, p2)
		if status == dls.STATUS_ENDDOWNLOADDATA then
			if doesFileExist(ksv) then
				local j = io.open(ksv, 'r')
				if j then
					local info = decodeJson(j:read('*a'))
					url = info.url
					version = info.version
					j:close()
					os.remove(ksv)
					--sampAddChatMessage(url.." "..version, -1)
					if version ~= nil and version > thisScript().version then
						sampAddChatMessage('{A800FF}[Kill State by Eenz Hatte]{ffffff}Текущая версия скрипта: '..thisScript().version..'. Требуется обновление.', color)
						downloadUrlToFile('https://raw.githubusercontent.com/rr1me/cu/main/kill_state.lua', thisScript().path,
						function(id, status, p1, p2)
							if status == dls.STATUS_ENDDOWNLOADDATA then
								sampAddChatMessage('{A800FF}[Kill State by Eenz Hatte]{ffffff}Скрипт обновлен до версии: '..version..'.', color)
								thisScript():reload()
							end
						end)
					elseif version ~= nil and version == thisScript().version then
						sampAddChatMessage('{A800FF}[Kill State by Eenz Hatte]{ffffff}Текущая версия скрипта: '..thisScript().version..', обновление не требуется. Активация: "/state".', color)
						connect = true
					else
						sampAddChatMessage('{A800FF}[Kill State by Eenz Hatte]{ffffff}Не удалось проверить обновление для скрипта.', color)
						connect = false
					end
				end
			end
		end
	end)
	if not doesFileExist('moonloader/config/icons.png') then
		while true do wait(0)
			if connect == false then
				sampAddChatMessage('{A800FF}[Kill State by Eenz Hatte]{ffffff}Не удалось скачать ресурсы, требуемые для работы скрипта.', color)
				sampAddChatMessage('{A800FF}[Kill State by Eenz Hatte]{ffffff}Перейди по ссылке "https://raw.githubusercontent.com/rr1me/cu/main/icons.png", скачай картинку,', color)
				sampAddChatMessage('{A800FF}[Kill State by Eenz Hatte]{ffffff}закинь ее по пути moonloader/config и перезагрузи скрипт.', color)
				sampAddChatMessage('{A800FF}[Kill State by Eenz Hatte]{ffffff}Выходить из игры необязательно.', color)
				sampAddChatMessage('{A800FF}[Kill State by Eenz Hatte]{ffffff}Чтобы скопировать ссылку, используй команду /copylink.', color)
				sampAddChatMessage('{A800FF}[Kill State by Eenz Hatte]{ffffff}Чтобы перезагрузить скрипт, используй команду /reloadscript.', color)
				sampRegisterChatCommand('copylink', function()
					setClipboardText('https://raw.githubusercontent.com/rr1me/cu/main/icons.png')
				end)
				sampRegisterChatCommand('reloadscript', function()
					thisScript():reload()
				end)
				wait(-1)
			elseif connect then
				downloadUrlToFile('https://raw.githubusercontent.com/rr1me/cu/main/icons.png', getWorkingDirectory()..'\\config\\icons.png',
				function(id, status, p1, p2)
					if status == dls.STATUS_ENDDOWNLOADDATA then
						icons = img.CreateTextureFromFile('moonloader/config/icons.png')
					end
				end)
				break
			end
		end
	else
		icons = img.CreateTextureFromFile('moonloader/config/icons.png')
	end
	sampRegisterChatCommand('state', function()
		kl.v = not kl.v
	end)
	x,y = getScreenResolution()
	pfont = renderCreateFont(cfg.main.pkillfont, cfg.main.pkillfontsize, cfg.main.pkillfontflag)
	font = renderCreateFont(cfg.main.ownstatefont, cfg.main.ownstatefontsize, cfg.main.ownstatefontflag)
	while true do wait(0)
		x,y = getScreenResolution()
		img.Process = kl.v
		if acownstate.v then
      renderFontDrawText(font, (osk.v and '{'..wcol..'}kills:{'..ncol..'}'..kills..'\n' or '')..(oskpl.v and '{'..wcol..'}kills/life:{'..ncol..'}'..kpl..'\n' or '')..(osmk.v and '{'..wcol..'}max kills/life:{'..ncol..'}'..maxkills..'\n' or '')..(osd.v and '{'..wcol..'}deaths:{'..ncol..'}'..deaths..'\n' or '')..(oskd.v and '{'..wcol..'}KD:{'..ncol..'}'..(kills/deaths == 1/0 and '{'..ncol..'}'..kills..'.00\n' or '')..(kills == 0 and '{'..ncol..'}0.00'..'\n' or '')..(kills > 0 and deaths > 0 and '{'..ncol..'}'..string.format("%.2f", kills/deaths)..'\n' or '') or '')..(osdmg.v and '{'..wcol..'}damage:{'..ncol..'}'..math.floor(tdmg)..'\n' or '')..(osdmgpl.v and '{'..wcol..'}dmg/life:{'..ncol..'}'..math.floor(dmgpl)..'\n' or '')..(osmd.v and '{'..wcol..'}max dmg/life:{'..ncol..'}'..math.floor(maxdmg)..'\n' or '')..(shots.v and '{'..wcol..'}shots:{'..ncol..'}'..shotcount..'\n' or '')..(hits.v and '{'..wcol..'}hits:{'..ncol..'}'..hitcount..'\n' or '')..(misses.v and '{'..wcol..'}misses:{'..ncol..'}'..shotcount - hitcount..'\n' or '')..(accuracy.v and '{'..wcol..'}accuracy:{'..ncol..'}'..(shotcount > 0 and ('%.2f'):format(hitcount/(shotcount/100)) or '0.00')..'%\n' or ''), cfg.main.px, cfg.main.py, 0xFFFFFFFF)
    end
	end
end
