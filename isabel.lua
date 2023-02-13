-- FFI
ffi.cdef[[
	typedef void* (__cdecl* tCreateInterface)(const char* name, int* returnCode);
    typedef int(__fastcall* clantag_t)(const char*, const char*);
	void* GetProcAddress(void* hModule, const char* lpProcName);
    void* GetModuleHandleA(const char* lpModuleName);
]]



-- Vars
local xhair_font = draw.CreateFont("Verdana",12, 2000) 
local Font3 = draw.CreateFont("Yold Anglican", 24, 20)
local Font33 = draw.CreateFont("Yold Anglican", 32, 20)
local Font4 = draw.CreateFont("Tahoma", 18, 20)
local Font44 = draw.CreateFont("Tahoma", 32, 20)
local renderer = {}
local screenW, screenH = draw.GetScreenSize()
local EbaHook_Var_RL = false
local EbaHook_Screen_X, EbaHook_Screen_Y = draw.GetScreenSize()
local ragebot_accuracy_weapon = gui.Reference("Ragebot", "Accuracy", "Weapon")
local baim = 1
local awtggl = true
local fonto = draw.CreateFont("segoe ui", 30, 1000   )
local fn_change_clantag = mem.FindPattern("engine.dll", "53 56 57 8B DA 8B F9 FF 15")
local set_clantag = ffi.cast("clantag_t", fn_change_clantag)
local localplayer, localplayerindex, listen, GetPlayerIndexByUserID, g_curtime = entities.GetLocalPlayer, client.GetLocalPlayerIndex, client.AllowListener, client.GetPlayerIndexByUserID, globals.CurTime
----------------------------------------------------------------------------how2get weapon id??--------------------------------------------
local function get_weapon_class()
    local weapon_id = entities.GetLocalPlayer():GetWeaponID();

    if weapon_id == 11 or weapon_id == 38 then
        return "asniper";
    elseif weapon_id == 1 or weapon_id == 64 then
        return "hpistol";
    elseif weapon_id == 14 or weapon_id == 28 then
        return "lmg";
    elseif weapon_id == 2 or weapon_id == 3 or weapon_id == 4 or weapon_id == 30 or weapon_id == 32 or weapon_id == 36 or weapon_id == 61 or weapon_id == 63 then
        return "pistol";
    elseif weapon_id == 7 or weapon_id == 8 or weapon_id == 10 or weapon_id == 13 or weapon_id == 16 or weapon_id == 39 or weapon_id == 60 then
        return "rifle";
    elseif weapon_id == 40 then
        return "scout";
    elseif weapon_id == 17 or weapon_id == 19 or weapon_id == 23 or weapon_id == 24 or weapon_id == 26 or weapon_id == 33 or weapon_id == 34 then
        return "smg";
    elseif weapon_id == 25 or weapon_id == 27 or weapon_id == 29 or weapon_id == 35 then
        return "shotgun";
    elseif weapon_id == 9 then
        return "sniper";
    elseif weapon_id == 31 then
        return "zeus";
    end

    return "shared";
end
---------------------------------------------------------------------------------------------------------------------------------------------
local function menu_weapon(var)
    local wp = string.match(var, [["(.+)"]])
    local wp = string.lower(wp)
    if wp == "heavy pistol" then
        return "hpistol"
    elseif wp == "auto sniper" then
        return "asniper"
    elseif wp == "submachine gun" then
        return "smg"
    elseif wp == "light machine gun" then
        return "lmg"
    else
        return wp
    end
end

local clantag_anim = {
    "                  ",
    "                 i",
    "                is",
    "               isa",
    "              isab",
    "             isabe",
    "            isabel",
    "           isabelh",
    "          isabelho",
    "         isabelhoo",
    "        isabelhook",
    "       isabelhook ",
    "      isabelhook  ",
    "     isabelhook   ",
    "    isabelhook    ",
    "   isabelhook     ",
    "  isabelhook      ",
    " isabelhook       ",
    "isabelhook        ",
    "sabelhook         ",
    "abelhook          ",
    "belhook           ",
    "elhook            ",
    "lhook             ",
    "hook              ",
    "ook               ",
    "ok                ",
    "k                 "
}

-- Gui
local EbaHook_Tab                                             = gui.Tab(gui.Reference("Settings"), "EbaHook_tab", "isabelhook")
local EbaHook_Tab_GroupBox_Main                               = gui.Groupbox(EbaHook_Tab, "Main", 16, 16, 296, 100 )
local EbaHook_Tab_GroupBox_Main_Toggler                       = gui.Checkbox( EbaHook_Tab_GroupBox_Main, "EbaHook_toggler", "MT", 0 )
EbaHook_Tab_GroupBox_Main_Toggler:SetDescription("Bind this on key")
local EbaHook_Tab_GroupBox_Main_BAIM_Toggler                  = gui.Keybox( EbaHook_Tab_GroupBox_Main, "EbaHook_BAIM_toggler", "BAIM Toggle", 0 )
local EbaHook_Tab_GroupBox_Main_JWalk                         = gui.Keybox( EbaHook_Tab_GroupBox_Main, "EbaHook_Jwalk", "Jitter Walk", 0 )
local EbaHook_Tab_GroupBox_Main_AW_Toggler                    = gui.Keybox( EbaHook_Tab_GroupBox_Main, "EbaHook_AW_toggler", "AW Toggle", 0 )
local EbaHook_Tab_GroupBox_Main_Inverter                      = gui.Keybox( EbaHook_Tab_GroupBox_Main, "EbaHook_Inverter", "AA Inverter", 0 )
local EbaHook_Tab_GroupBox_Main_DFOV_Checkbox                 = gui.Checkbox( EbaHook_Tab_GroupBox_Main, "EbaHook_indicators_DFOV", "Dynamic FOV", 0 )
local EbaHook_Tab_GroupBox_Main_DFOV_Min_Slider               = gui.Slider( EbaHook_Tab_GroupBox_Main, "EbaHook_indicators_Min_DFOV", "Minimum FOV", 5, 0, 30 )
local EbaHook_Tab_GroupBox_Main_DFOV_Max_Slider               = gui.Slider( EbaHook_Tab_GroupBox_Main, "EbaHook_indicators_Max_DFOV", "Maximum FOV", 20, 0, 30 )




local EbaHook_Tab_GroupBox_Indicators                         = gui.Groupbox(EbaHook_Tab, "Indicators", 328, 16, 296, 100 )
local testo  = gui.Combobox( EbaHook_Tab_GroupBox_Indicators, "testo", "Watermark type", "isabelhook", "onetapv2", "metamod" )
local EbaHook_Tab_GroupBox_Main_Indicators_WmarkColor         = gui.ColorPicker( EbaHook_Tab_GroupBox_Indicators, "EbaHook_Tab_GroupBox_Main_Indicators_WmarkColor", "Isabelook watermark Color", 152, 25, 25, 255 )
local EbaHook_Tab_GroupBox_Main_Indicators_otv2WmarkColor         = gui.ColorPicker( EbaHook_Tab_GroupBox_Indicators, "EbaHook_Tab_GroupBox_Main_Indicators_otv2WmarkColor", "OTV2 watermark Color", 152, 25, 25, 255 )
local EbaHook_Tab_GroupBox_Main_Indicators_metamodWmarkColor         = gui.ColorPicker( EbaHook_Tab_GroupBox_Indicators, "EbaHook_Tab_GroupBox_Main_Indicators_metamodWmarkColor", "Metamod watermark Color", 152, 25, 25, 255 )
local EbaHook_Tab_GroupBox_Main_Indicators_Multibox           = gui.Multibox( EbaHook_Tab_GroupBox_Indicators, "Indicators")
EbaHook_Tab_GroupBox_Main_Indicators_Multibox:SetDescription("Enables indicators")
local EbaHook_Tab_GroupBox_Main_Indicators_Position_Selector  = gui.Combobox( EbaHook_Tab_GroupBox_Indicators, "EbaHook_Tab_GroupBox_Main_Indicators_Position_Selector", "Indicators type", "isabelhook", "NyaHook", "NyaHook under crosshair", "Skeet", "finlandhook" )
local indcolor_nyahook         = gui.ColorPicker( EbaHook_Tab_GroupBox_Indicators, "indcolor_nyahook", "NyaHook Indicator Color", 255, 255, 255, 255 )
local indcolor_nyahook1         = gui.ColorPicker( EbaHook_Tab_GroupBox_Indicators, "indcolor_nyahook1", "NyaHook under xhair Indicator Color", 255, 255, 255, 255 )
local indcolor_skeet        = gui.ColorPicker( EbaHook_Tab_GroupBox_Indicators, "indcolor_skeet", "Skeet / finlandhook Indicator Color", 152, 204, 0, 255 )
local cute         = gui.ColorPicker( EbaHook_Tab_GroupBox_Indicators, "cute", "Cute under crosshair type indicator color", 255, 255, 255, 255 )
local ARROWTYPE = gui.Combobox( EbaHook_Tab_GroupBox_Indicators, "arrowtype", "Arrow Type", "1", "2", "3", "4" )
local ArrowX = gui.Slider(EbaHook_Tab_GroupBox_Indicators, "ArrowX", "Arrow X Pos", 15, 0, screenW)
local arrowc         = gui.ColorPicker( EbaHook_Tab_GroupBox_Indicators, "arrowc", "Arrow color", 255, 255, 255, 255 )
local EbaHook_Tab_GroupBox_Main_Indicators_RL_Checkbox        = gui.Checkbox( EbaHook_Tab_GroupBox_Main_Indicators_Multibox, "EbaHook_indicators_RL", "MT", 0 )
local EbaHook_Tab_GroupBox_Main_Indicators_FOV_Checkbox       = gui.Checkbox( EbaHook_Tab_GroupBox_Main_Indicators_Multibox, "EbaHook_indicators_FOV", "FOV", 0 )
local EbaHook_Tab_GroupBox_Main_Indicators_DMG_Checkbox       = gui.Checkbox( EbaHook_Tab_GroupBox_Main_Indicators_Multibox, "EbaHook_indicators_DMG", "Minimum Damage", 0 )
local EbaHook_Tab_GroupBox_Main_Indicators_BAIM_Checkbox      = gui.Checkbox( EbaHook_Tab_GroupBox_Main_Indicators_Multibox, "EbaHook_indicators_BAIM", "BAIM", 0 )
local EbaHook_Tab_GroupBox_Main_Indicators_AW_Checkbox        = gui.Checkbox( EbaHook_Tab_GroupBox_Main_Indicators_Multibox, "EbaHook_indicators_AW", "Auto Wall", 0 )  
local EbaHook_Tab_GroupBox_Main_Indicators_Resolver_Checkbox  = gui.Checkbox( EbaHook_Tab_GroupBox_Main_Indicators_Multibox, "EbaHook_indicators_Resolver", "Resolver", 0 )
local EbaHook_Tab_GroupBox_Main_Indicators_AA_Checkbox        = gui.Checkbox( EbaHook_Tab_GroupBox_Main_Indicators_Multibox, "EbaHook_indicators_AA", "Anti Aim", 0 )
local EbaHook_Tab_GroupBox_Main_Indicators_1_Font_Slider      = gui.Slider( EbaHook_Tab_GroupBox_Indicators, "EbaHook_Tab_GroupBox_Main_Indicators_1_Font_Slider", "Font size for 1 preset", 25, 5, 50 )
local EbaHook_Tab_GroupBox_Main_Indicators_2_Font_Slider      = gui.Slider( EbaHook_Tab_GroupBox_Indicators, "EbaHook_Tab_GroupBox_Main_Indicators_2_Font_Slider", "Font size for 2 preset", 15, 5, 50 )
local EbaHook_Tab_GroupBox_Main_Indicators_3_Font_Slider      = gui.Slider( EbaHook_Tab_GroupBox_Indicators, "EbaHook_Tab_GroupBox_Main_Indicators_3_Font_Slider", "Font size for 3 preset", 30, 5, 50 )
local EbaHook_Tab_GroupBox_Main_Indicators_X_Slider           = gui.Slider( EbaHook_Tab_GroupBox_Indicators, "EbaHook_indicators_X_Slider", "X", 15, 0, EbaHook_Screen_X )
local EbaHook_Tab_GroupBox_Main_Indicators_Y_Slider           = gui.Slider( EbaHook_Tab_GroupBox_Indicators, "EbaHook_indicators_Y_Slider", "Y", EbaHook_Screen_Y / 1.7, 0, EbaHook_Screen_Y )
local EbaHook_Tab_GroupBox_Main_Indicators_X_Offset           = gui.Slider( EbaHook_Tab_GroupBox_Indicators, "EbaHook_indicators_X_Offset", "X Offset", 0, 15, 45 )
local EbaHook_Tab_GroupBox_Main_Indicators_Y_Offset           = gui.Slider( EbaHook_Tab_GroupBox_Indicators, "EbaHook_indicators_Y_Offset", "Y Offset", 0, 0, 30 )


local EbaHook_Tab_GroupBox_Misc                               = gui.Groupbox(EbaHook_Tab, "Miscellaneous", 328, 684, 296, 100 )
local EbaHook_Tab_GroupBox_Main_CT                            = gui.Checkbox( EbaHook_Tab_GroupBox_Misc, "EbaHook_CT", "Clantag", 0 )
local Left_Key = gui.Keybox(EbaHook_Tab_GroupBox_Misc, "left_key", "Left manual", 0)
local Right_Key = gui.Keybox(EbaHook_Tab_GroupBox_Misc, "right_key", "Right manual", 0)
local font = draw.CreateFont("Verdana", 25, 25)
local font1 = draw.CreateFont("Verdana", 35, 35)
local font2 = draw.CreateFont("Bahnschrift", 13)
local toggled = false
local toggled_left = false
local toggled_right = false
local toggled_back = false

local function keys()

    if EbaHook_Tab_GroupBox_Main_Inverter:GetValue() ~= 0 then
        if input.IsButtonPressed(EbaHook_Tab_GroupBox_Main_Inverter:GetValue()) then
            toggled = not toggled
        end
    end
    if Left_Key:GetValue() ~= 0 then
        if input.IsButtonPressed(Left_Key:GetValue()) then
            toggled_left = not toggled_left
            toggled_right = false
        end
    end
    if Right_Key:GetValue() ~= 0 then
        if input.IsButtonPressed(Right_Key:GetValue()) then
            toggled_right = not toggled_right
            toggled_left = false
        end
    end
    end

local function drawHook()
    keys()
end



local function createMoveHook(cmd)

      if toggled_left then
        gui.SetValue("rbot.antiaim.base", 110)
      elseif toggled_right then
        gui.SetValue("rbot.antiaim.base", -110)
		else gui.SetValue("rbot.antiaim.base", 0)
      end
end

callbacks.Register("CreateMove", createMoveHook)
callbacks.Register("Draw", drawHook);



local function colorlock()
indcolor_nyahook:SetInvisible(true)
indcolor_nyahook1:SetInvisible(true)
indcolor_skeet:SetInvisible(true)
cute:SetInvisible(true)
if EbaHook_Tab_GroupBox_Main_Indicators_Position_Selector:GetValue() == 0 then
	indcolor_nyahook:SetInvisible(true)
	indcolor_nyahook1:SetInvisible(true)
	indcolor_skeet:SetInvisible(true)
	cute:SetInvisible(false)
elseif EbaHook_Tab_GroupBox_Main_Indicators_Position_Selector:GetValue() == 1 then
	indcolor_nyahook1:SetInvisible(false)
	indcolor_nyahook1:SetInvisible(true)
	indcolor_skeet:SetInvisible(true)
	cute:SetInvisible(true)
elseif EbaHook_Tab_GroupBox_Main_Indicators_Position_Selector:GetValue() == 2 then 
	indcolor_nyahook:SetInvisible(true)
	indcolor_nyahook1:SetInvisible(false)
	indcolor_skeet:SetInvisible(true)
	cute:SetInvisible(true)
elseif EbaHook_Tab_GroupBox_Main_Indicators_Position_Selector:GetValue() == 3 then 
	indcolor_nyahook:SetInvisible(true)
	indcolor_nyahook1:SetInvisible(true)
	indcolor_skeet:SetInvisible(false)
	cute:SetInvisible(true)
elseif EbaHook_Tab_GroupBox_Main_Indicators_Position_Selector:GetValue() == 4 then 
	indcolor_nyahook:SetInvisible(true)
	indcolor_nyahook1:SetInvisible(true)
	indcolor_skeet:SetInvisible(false)
	cute:SetInvisible(true)
end 
end
callbacks.Register("Draw", colorlock)

local function wmcolorlock()
EbaHook_Tab_GroupBox_Main_Indicators_WmarkColor:SetInvisible(true)
EbaHook_Tab_GroupBox_Main_Indicators_otv2WmarkColor:SetInvisible(true)
EbaHook_Tab_GroupBox_Main_Indicators_metamodWmarkColor:SetInvisible(true)
if testo:GetValue() == 0 then
	EbaHook_Tab_GroupBox_Main_Indicators_WmarkColor:SetInvisible(false)
	EbaHook_Tab_GroupBox_Main_Indicators_otv2WmarkColor:SetInvisible(true)
	EbaHook_Tab_GroupBox_Main_Indicators_metamodWmarkColor:SetInvisible(true)
elseif testo:GetValue() == 1 then
	EbaHook_Tab_GroupBox_Main_Indicators_WmarkColor:SetInvisible(true)
	EbaHook_Tab_GroupBox_Main_Indicators_otv2WmarkColor:SetInvisible(false)
	EbaHook_Tab_GroupBox_Main_Indicators_metamodWmarkColor:SetInvisible(true)
elseif testo:GetValue() == 2 then 
	EbaHook_Tab_GroupBox_Main_Indicators_WmarkColor:SetInvisible(true)
	EbaHook_Tab_GroupBox_Main_Indicators_otv2WmarkColor:SetInvisible(true)
	EbaHook_Tab_GroupBox_Main_Indicators_metamodWmarkColor:SetInvisible(false)
end 
end
callbacks.Register("Draw", wmcolorlock)


function resetXY()
    EbaHook_Tab_GroupBox_Main_Indicators_X_Slider:SetValue(15)
    EbaHook_Tab_GroupBox_Main_Indicators_X_Offset:SetValue(15)
    EbaHook_Tab_GroupBox_Main_Indicators_Y_Slider:SetValue(EbaHook_Screen_Y / 1.7)
    EbaHook_Tab_GroupBox_Main_Indicators_Y_Offset:SetValue(0)  
end

-- Draw
local EbaHook_Font = draw.CreateFont("Verdana", 25, 1000)
local arrowfont = draw.CreateFont("Verdana", 32, 1000)
local EbaHook_Font_2 = draw.CreateFont("Verdana", 15, 1000)
local fizcord_watermark_font = draw.CreateFont( "Arial", 16 )
local din_pro_keybind = draw.CreateFont( "Arial", 15 )

local function Update_Fonts()
    EbaHook_Font = 0
    EbaHook_Font_2 = 0
	fonto = 0
    EbaHook_Font = draw.CreateFont("Verdana", EbaHook_Tab_GroupBox_Main_Indicators_1_Font_Slider:GetValue(), 1000)
    EbaHook_Font_2 = draw.CreateFont("Verdana", EbaHook_Tab_GroupBox_Main_Indicators_2_Font_Slider:GetValue(), 1000)
	fonto = draw.CreateFont("segoe ui", EbaHook_Tab_GroupBox_Main_Indicators_3_Font_Slider:GetValue(), 1000   )
end
local EbaHook_Tab_GroupBox_Main_Indicators_UpdFonts           = gui.Button( EbaHook_Tab_GroupBox_Indicators, "Update Fonts", Update_Fonts )
local EbaHook_Tab_GroupBox_Main_Indicators_ResetPos           = gui.Button( EbaHook_Tab_GroupBox_Indicators, "Reset X/Y", resetXY )
function math.round(exact, quantum)
    local quant,frac = math.modf(exact/quantum)
    return quantum * (quant + (frac > 0.5 and 1 or 0))
end
local EbaHook_Tab_GroupBox_ViewModel                          = gui.Groupbox(EbaHook_Tab, "ViewModel", 16, 500, 296, 100 )
local EbaHook_Tab_GroupBox_ViewModel_SC                       = gui.Checkbox( EbaHook_Tab_GroupBox_ViewModel, "EbaHook_Tab_GroupBox_ViewModel_SC", "Sniper Crosshair", 0 )
local EbaHook_Tab_GroupBox_ViewModel_X                        = gui.Slider( EbaHook_Tab_GroupBox_ViewModel, "EbaHook_Tab_GroupBox_ViewModel_X", "X", 2, -20, 20 )
local EbaHook_Tab_GroupBox_ViewModel_Y                        = gui.Slider( EbaHook_Tab_GroupBox_ViewModel, "EbaHook_Tab_GroupBox_ViewModel_Y", "Y", -2, -20, 20 )
local EbaHook_Tab_GroupBox_ViewModel_Z                        = gui.Slider( EbaHook_Tab_GroupBox_ViewModel, "EbaHook_Tab_GroupBox_ViewModel_Z", "Z", -2, -20, 20 )
local EbaHook_Tab_GroupBox_ViewModel_FOV                      = gui.Slider( EbaHook_Tab_GroupBox_ViewModel, "EbaHook_Tab_GroupBox_ViewModel_FOV", "ViewModel FOV", 54, 40, 90 )
local EbaHook_Tab_GroupBox_ViewModel_ViewFOV                  = gui.Slider( EbaHook_Tab_GroupBox_ViewModel, "EbaHook_Tab_GroupBox_ViewModel_ViewFOV", "View FOV", 90, 50, 120 )
local EbaHook_Tab_GroupBox_ViewModel_ARatio                   = gui.Slider( EbaHook_Tab_GroupBox_ViewModel, "EbaHook_Tab_GroupBox_ViewModel_ARatio", "Aspect Ratio", 100, 1, 199)


local function get_LP()
    return entities.GetLocalPlayer()
end

local Clantag = function()
    
    if EbaHook_Tab_GroupBox_Main_CT:GetValue() then
        local curtime = math.floor(globals.CurTime() * 2.3);
        if old_time ~= curtime then
            set_clantag(clantag_anim[curtime % #clantag_anim+1], clantag_anim[curtime % #clantag_anim+1]);
        end
        old_time = curtime;
        clantagset = 1;
    else
        if clantagset == 1 then
            clantagset = 0;
            set_clantag("", "");
        end
    end
    
end


local function get_gsIndicators()
    local gsIndicators = {}
    local EbaHook_Indicators_Index = 1
	local r, g, b, a = indcolor_skeet:GetValue()
	if not entities.GetLocalPlayer() or not entities.GetLocalPlayer():IsAlive() then return end
    -- DMG
    if EbaHook_Tab_GroupBox_Main_Indicators_DMG_Checkbox:GetValue() and gui.GetValue("rbot.master") then
        local weapon = menu_weapon(ragebot_accuracy_weapon:GetValue())
        if weapon ~= "knife" then
            local mindmg = gui.GetValue("rbot.accuracy.weapon." .. weapon .. ".mindmg")
            draw.indicator(255,255,255, 255,  gui.GetValue("rbot.accuracy.weapon." .. get_weapon_class(lc) .. ".mindmg"))
            EbaHook_Indicators_Index = EbaHook_Indicators_Index + 1 
        end
        
    end

    if EbaHook_Tab_GroupBox_Main_Indicators_RL_Checkbox:GetValue() and gui.GetValue("rbot.aim.enable") then
        draw.indicator(r, g, b, a, "MT")
        EbaHook_Indicators_Index = EbaHook_Indicators_Index + 1
    end

    -- FOV
    if EbaHook_Tab_GroupBox_Main_Indicators_FOV_Checkbox:GetValue() and gui.GetValue("rbot.master") then
        draw.indicator(r, g, b, a, 'FOV:' .. ' ' ..gui.GetValue( "rbot.aim.target.fov" ) .. '°')
        EbaHook_Indicators_Index = EbaHook_Indicators_Index + 1 
    end

    if EbaHook_Tab_GroupBox_Main_Indicators_AA_Checkbox:GetValue() then
        draw.SetFont( fonto )
		local body_yaw = math.max(-60, math.min(60, math.round((entities.GetLocalPlayer():GetPropFloat( "m_flPoseParameter", "11") or 0)*120-60+0.5, 1)))
       draw.indicator(r, g, b, a, 'FAKE:' .. ' ' ..  math.abs(body_yaw) .. '°')
		 EbaHook_Indicators_Index = EbaHook_Indicators_Index + 1 
	end
	
	if EbaHook_Tab_GroupBox_Main_Indicators_Resolver_Checkbox:GetValue() and gui.GetValue("rbot.accuracy.posadj.resolver") and gui.GetValue("rbot.master") then
        draw.indicator(r, g, b, a, gui.GetValue( 'rbot.accuracy.posadj.resolver' ) and 'R:ON')
		elseif EbaHook_Tab_GroupBox_Main_Indicators_Resolver_Checkbox:GetValue() and gui.GetValue("rbot.master") then
		draw.indicator(r, g, b, a, 'R:OFF')
        EbaHook_Indicators_Index = EbaHook_Indicators_Index + 1
    end
	
    -- Rage / Legit

	
    if baim%2 == 0 and EbaHook_Tab_GroupBox_Main_Indicators_BAIM_Checkbox:GetValue() then
        draw.indicator(r, g, b, a, "BAIM")
        EbaHook_Indicators_Index = EbaHook_Indicators_Index + 1 
    end

    if EbaHook_Tab_GroupBox_Main_Indicators_AW_Checkbox:GetValue() then
        local weapon = menu_weapon(ragebot_accuracy_weapon:GetValue())
        if weapon ~= "knife" then
            local awall = gui.GetValue("rbot.hitscan.mode." .. weapon .. ".autowall")
            if awtggl and gui.GetValue("rbot.master") then
                draw.indicator(r, g, b, a, "AW")
                EbaHook_Indicators_Index = EbaHook_Indicators_Index + 1 
            end
        end
    end
	if input.IsButtonDown( gui.GetValue("rbot.antiaim.extra.fakecrouchkey") ) then 
        draw.indicator(r, g, b, a, "DUCK")
        EbaHook_Indicators_Index = EbaHook_Indicators_Index + 1 
    end
    -- AA
    if EbaHook_Tab_GroupBox_Main_Indicators_AA_Checkbox:GetValue() then
			if toggled_left then
				draw.indicator(r, g, b, a, "MANUAL LEFT")
				EbaHook_Indicators_Index = EbaHook_Indicators_Index + 1 
			end

			if toggled_right then
				draw.indicator(r, g, b, a, "MANUAL RIGHT")
				EbaHook_Indicators_Index = EbaHook_Indicators_Index + 1 
			end
end
return gsIndicators
end

local function get_finland()
    local finland = {}
    local EbaHook_Indicators_Index = 1
	local r, g, b, a = indcolor_skeet:GetValue()
	if not entities.GetLocalPlayer() or not entities.GetLocalPlayer():IsAlive() then return end
	
	    if EbaHook_Tab_GroupBox_Main_Indicators_AA_Checkbox:GetValue() then
        local Desync_Side = "None"
        local invrtr = false
        if gui.GetValue("rbot.antiaim.base.rotation") > 0 and gui.GetValue("rbot.antiaim.base.lby") < 0 then 
            Desync_Side = "->"
			draw.indicator(r, g, b, a, "R:LEFT")
            invrtr = true
        elseif gui.GetValue("rbot.antiaim.base.rotation") < 0 and gui.GetValue("rbot.antiaim.base.lby") > 0 then
            Desync_Side = "<-"
            invrtr = false
			draw.indicator(r, g, b, a, "R:RIGHT")
        elseif gui.GetValue("rbot.antiaim.base.rotation") < 0 and gui.GetValue("rbot.antiaim.base.lby") == 0 then
            Desync_Side = "<-"
            invrtr = false
			draw.indicator(r, g, b, a, "R:RIGHT")
        elseif gui.GetValue("rbot.antiaim.base.rotation") > 0 and gui.GetValue("rbot.antiaim.base.lby") == 0 then
            Desync_Side = "->"
            invrtr = true
			draw.indicator(r, g, b, a, "R:LEFT")
		end
	end
	
    -- DMG
    if EbaHook_Tab_GroupBox_Main_Indicators_DMG_Checkbox:GetValue() and gui.GetValue("rbot.master") then
        local weapon = menu_weapon(ragebot_accuracy_weapon:GetValue())
        if weapon ~= "knife" then
            local mindmg = gui.GetValue("rbot.accuracy.weapon." .. weapon .. ".mindmg")
            draw.indicator(255,255,255, 255,  gui.GetValue("rbot.accuracy.weapon." .. get_weapon_class(lc) .. ".mindmg"))
            EbaHook_Indicators_Index = EbaHook_Indicators_Index + 1 
        end
        
    end

    -- FOV
    if EbaHook_Tab_GroupBox_Main_Indicators_FOV_Checkbox:GetValue() and gui.GetValue("rbot.master") then
        draw.indicator(r, g, b, a, 'FOV:' .. ' ' ..gui.GetValue( "rbot.aim.target.fov" ))
        EbaHook_Indicators_Index = EbaHook_Indicators_Index + 1 
    end
	
	if EbaHook_Tab_GroupBox_Main_Indicators_RL_Checkbox:GetValue() and gui.GetValue("rbot.aim.enable") then
        draw.indicator(r, g, b, a, "MT")
        EbaHook_Indicators_Index = EbaHook_Indicators_Index + 1
    end

	
	if EbaHook_Tab_GroupBox_Main_Indicators_Resolver_Checkbox:GetValue() and gui.GetValue("rbot.accuracy.posadj.resolver") and gui.GetValue("rbot.master") then
        draw.indicator(r, g, b, a, gui.GetValue( 'rbot.accuracy.posadj.resolver' ) and 'R:ON')
		elseif EbaHook_Tab_GroupBox_Main_Indicators_Resolver_Checkbox:GetValue() and gui.GetValue("rbot.master") then
		draw.indicator(r, g, b, a, 'R:OFF')
        EbaHook_Indicators_Index = EbaHook_Indicators_Index + 1
    end
	

	
    if baim%2 == 0 and EbaHook_Tab_GroupBox_Main_Indicators_BAIM_Checkbox:GetValue() then
        draw.indicator(r, g, b, a, "BAIM")
        EbaHook_Indicators_Index = EbaHook_Indicators_Index + 1 
    end
	
	if input.IsButtonDown( gui.GetValue("rbot.antiaim.extra.fakecrouchkey") ) then 
        draw.indicator(r, g, b, a, "DUCK")
        EbaHook_Indicators_Index = EbaHook_Indicators_Index + 1 
    end
    -- AWALL
    if EbaHook_Tab_GroupBox_Main_Indicators_AW_Checkbox:GetValue() then
        local weapon = menu_weapon(ragebot_accuracy_weapon:GetValue())
        if weapon ~= "knife" then
            local awall = gui.GetValue("rbot.hitscan.mode." .. weapon .. ".autowall")
            if awtggl and gui.GetValue("rbot.master") then
			draw.SetFont(xhair_font)
			draw.TextShadow(screenW / 2 - 28, screenH / 2 + 14 , 'AUTOWALL', {r, g, b, a}, xhair_font)
			EbaHook_Indicators_Index = EbaHook_Indicators_Index + 1 
		end
	end
	
		if toggled_left then
			draw.indicator(r, g, b, a, "MANUAL LEFT")
			EbaHook_Indicators_Index = EbaHook_Indicators_Index + 1 
		end
		if toggled_right then
			draw.indicator(r, g, b, a, "MANUAL RIGHT")
			EbaHook_Indicators_Index = EbaHook_Indicators_Index + 1 
		end
	
	
	
end
return finland
end

local function arrow()

    if not entities.GetLocalPlayer() or not entities.GetLocalPlayer():IsAlive() then return end

    if not gui.GetValue( "rbot.master" ) then return end
	local r, g, b, a = arrowc:GetValue()
    draw.SetFont( Font3 )
 
     
            if gui.GetValue("rbot.antiaim.base.rotation") < 0 and gui.GetValue("rbot.antiaim.base.lby") == 0 or gui.GetValue("rbot.antiaim.base.rotation") < 0 and gui.GetValue("rbot.antiaim.base.lby") > 0 then

                if ARROWTYPE:GetValue() == 0 then

                    renderer.outline_text(screenW / 2 + 50 + ArrowX:GetValue(), screenH / 2 - 8, "-", {r, g, b, a}, Font3)
 

                elseif ARROWTYPE:GetValue() == 1 then
					draw.SetFont(Font33)

                    draw.Color(r, g, b, a)
                    draw.TextShadow(screenW / 2 + 50 + ArrowX:GetValue(), screenH / 2 - 14, "⮚")

                elseif ARROWTYPE:GetValue() == 2 then

                    draw.SetFont( Font44 )
                    draw.Color(r, g, b, a)
                    draw.TextShadow(screenW / 2 + 50 + ArrowX:GetValue(),screenH / 2 - 12, "›")

                elseif ARROWTYPE:GetValue() == 3 then
 
                    draw.Color(r, g, b, a)
                    draw.Triangle(screenW / 2 + 25 + ArrowX:GetValue(), screenH / 2 - 4 , screenW / 2 + 44 + ArrowX:GetValue(), screenH / 2, screenW / 2 + 25 + ArrowX:GetValue(), screenH / 2 + 4)
                    
 

                end
                
 
            elseif gui.GetValue("rbot.antiaim.base.rotation") > 0 and gui.GetValue("rbot.antiaim.base.lby") == 0 or gui.GetValue("rbot.antiaim.base.rotation") > 0 and gui.GetValue("rbot.antiaim.base.lby") < 0 then

                if ARROWTYPE:GetValue() == 0 then

                    renderer.outline_text(screenW / 2 - 65 - ArrowX:GetValue(), screenH / 2 - 8, "-", {r, g, b, a}, Font3)
 
    
                elseif ARROWTYPE:GetValue() == 1 then
						draw.SetFont( Font33 )
                        draw.Color(r, g, b, a)
                        draw.TextShadow(screenW / 2 - 65 - ArrowX:GetValue(), screenH / 2 - 14, "⮘")
                elseif ARROWTYPE:GetValue() == 2 then
                        draw.SetFont( Font44 )
                        draw.Color(r, g, b, a)
                        draw.TextShadow(screenW / 2 - 60 - ArrowX:GetValue(),screenH / 2 - 12, "‹")
                elseif ARROWTYPE:GetValue() == 3 then
 
                 draw.Color(r, g, b, a)
                 draw.Triangle(screenW / 2 - 25 - ArrowX:GetValue(), screenH / 2 + 4, screenW / 2 - 25 - ArrowX:GetValue(), screenH / 2 - 4,  screenW / 2 - 44 - ArrowX:GetValue(), screenH / 2)
                 

                end

                
              
                
            end
        end
    
    callbacks.Register("Draw", "semiragehelper", arrow)

local function get_Indicators()
    local Indicators = {}
    local EbaHook_Indicators_Index = 1
    -- Rage / Legit
    if EbaHook_Tab_GroupBox_Main_Indicators_RL_Checkbox:GetValue() and gui.GetValue("rbot.aim.enable") then
        Indicators[EbaHook_Indicators_Index] = "MT"
        EbaHook_Indicators_Index = EbaHook_Indicators_Index + 1
    end

    -- FOV
    if EbaHook_Tab_GroupBox_Main_Indicators_FOV_Checkbox:GetValue() and gui.GetValue("rbot.master") then
        Indicators[EbaHook_Indicators_Index] = "FOV: ".. gui.GetValue("rbot.aim.target.fov")
        EbaHook_Indicators_Index = EbaHook_Indicators_Index + 1 
    end

    -- DMG
    if EbaHook_Tab_GroupBox_Main_Indicators_DMG_Checkbox:GetValue() and gui.GetValue("rbot.master") then
        local weapon = menu_weapon(ragebot_accuracy_weapon:GetValue())
        if weapon ~= "knife" then
            local mindmg = gui.GetValue("rbot.accuracy.weapon." .. weapon .. ".mindmg")
            Indicators[EbaHook_Indicators_Index] = "DMG: "..mindmg
            EbaHook_Indicators_Index = EbaHook_Indicators_Index + 1 
        end
        
    end
    
    -- AWALL
    if EbaHook_Tab_GroupBox_Main_Indicators_AW_Checkbox:GetValue() then
        local weapon = menu_weapon(ragebot_accuracy_weapon:GetValue())
        if weapon ~= "knife" then
            local awall = gui.GetValue("rbot.hitscan.mode." .. weapon .. ".autowall")
            if awtggl and gui.GetValue("rbot.master") then
                Indicators[EbaHook_Indicators_Index] = "AW"
                EbaHook_Indicators_Index = EbaHook_Indicators_Index + 1 
            end
        end
    end
    
    -- BAIM
    if baim%2 == 0 and EbaHook_Tab_GroupBox_Main_Indicators_BAIM_Checkbox:GetValue() then
        Indicators[EbaHook_Indicators_Index] = "BAIM"
        EbaHook_Indicators_Index = EbaHook_Indicators_Index + 1 
    end
	
	if input.IsButtonDown( gui.GetValue("rbot.antiaim.extra.fakecrouchkey") ) then 
        Indicators[EbaHook_Indicators_Index] = "DUCK"
        EbaHook_Indicators_Index = EbaHook_Indicators_Index + 1 
    end

    -- Resolver
    if EbaHook_Tab_GroupBox_Main_Indicators_Resolver_Checkbox:GetValue() and gui.GetValue("rbot.accuracy.posadj.resolver") and gui.GetValue("rbot.master") then
        Indicators[EbaHook_Indicators_Index] = "Resolver"
        EbaHook_Indicators_Index = EbaHook_Indicators_Index + 1
    end
	if EbaHook_Tab_GroupBox_Main_Indicators_AA_Checkbox:GetValue() then
		if toggled_left then
        Indicators[EbaHook_Indicators_Index] = "Manual Left"
        EbaHook_Indicators_Index = EbaHook_Indicators_Index + 1
		end
		
		if toggled_right then
        Indicators[EbaHook_Indicators_Index] = "Manual Right"
        EbaHook_Indicators_Index = EbaHook_Indicators_Index + 1
		end
	end
	return Indicators
	end


local function get_underxhair()
    local Indicators = {}
    local EbaHook_Indicators_Index = 1
	local r, g, b, a = cute:GetValue()
	draw.SetFont(xhair_font)
    ballchunks = 1
	if not entities.GetLocalPlayer() or not entities.GetLocalPlayer():IsAlive() then return end
	
	    if EbaHook_Tab_GroupBox_Main_Indicators_RL_Checkbox:GetValue() and gui.GetValue("rbot.aim.enable") then
		draw.TextShadow(screenW / 2 - 26, screenH / 2 + (14*ballchunks) , 'AUTOFIRE', {r, g, b, a}, xhair_font)
		ballchunks = ballchunks + 1
		end
		if EbaHook_Tab_GroupBox_Main_Indicators_DMG_Checkbox:GetValue() and gui.GetValue("rbot.master") then
		local weapon = menu_weapon(ragebot_accuracy_weapon:GetValue())
		if weapon ~= "knife" then
			local mindmg = gui.GetValue("rbot.accuracy.weapon." .. weapon .. ".mindmg")
			if mindmg <= 99 and mindmg > 9 then
			draw.TextShadow(screenW / 2 - 6.3, screenH / 2 + (14*ballchunks) ,   gui.GetValue("rbot.accuracy.weapon." .. get_weapon_class(lc) .. ".mindmg"), {255,255,255, 255}, xhair_font)
			ballchunks = ballchunks + 1
			elseif mindmg > 99 then
			draw.TextShadow(screenW / 2 - 9, screenH / 2 + (14*ballchunks) ,   gui.GetValue("rbot.accuracy.weapon." .. get_weapon_class(lc) .. ".mindmg"), {255,255,255, 255}, xhair_font)
			ballchunks = ballchunks + 1
			elseif mindmg < 10 then
			draw.TextShadow(screenW / 2 - 3, screenH / 2 + (14*ballchunks) ,   gui.GetValue("rbot.accuracy.weapon." .. get_weapon_class(lc) .. ".mindmg"), {255,255,255, 255}, xhair_font)
			ballchunks = ballchunks + 1
			end
		end
		end
		
		
		if EbaHook_Tab_GroupBox_Main_Indicators_FOV_Checkbox:GetValue() and gui.GetValue("rbot.master") then
			draw.TextShadow(screenW / 2 - 21, screenH / 2 + (14*ballchunks) , 'FOV: ' .. gui.GetValue( "rbot.aim.target.fov" ) .. '°', {r, g, b, a}, xhair_font)
			ballchunks = ballchunks + 1
		end

    if EbaHook_Tab_GroupBox_Main_Indicators_AW_Checkbox:GetValue() then
        local weapon = menu_weapon(ragebot_accuracy_weapon:GetValue())
        if weapon ~= "knife" then
            local awall = gui.GetValue("rbot.hitscan.mode." .. weapon .. ".autowall")
            if awtggl and gui.GetValue("rbot.master") then
			draw.TextShadow(screenW / 2 - 28, screenH / 2 + (14*ballchunks) , 'AUTOWALL', {r, g, b, a}, xhair_font)
			ballchunks = ballchunks + 1
		end
	end
	end

		if baim%2 == 0 and EbaHook_Tab_GroupBox_Main_Indicators_BAIM_Checkbox:GetValue() then
			draw.TextShadow(screenW / 2 - 14, screenH / 2 + (14*ballchunks) , 'BAIM', {r, g, b, a}, xhair_font)
			ballchunks = ballchunks + 1
		end

		if input.IsButtonDown( gui.GetValue("rbot.antiaim.extra.fakecrouchkey") ) then 
			draw.TextShadow(screenW / 2 - 14, screenH / 2 + (14*ballchunks) , 'DUCK', {r, g, b, a}, xhair_font)
			ballchunks = ballchunks + 1
		end

   return Indicators
end





local function draw_Indicators(Indicators)

    if EbaHook_Tab_GroupBox_Main_Indicators_Position_Selector:GetValue() == 0 then
        EbaHook_Tab_GroupBox_Main_Indicators_X_Slider:SetInvisible(true)
        EbaHook_Tab_GroupBox_Main_Indicators_X_Offset:SetInvisible(true)
        EbaHook_Tab_GroupBox_Main_Indicators_Y_Slider:SetInvisible(true)
        EbaHook_Tab_GroupBox_Main_Indicators_Y_Offset:SetInvisible(true)
    elseif EbaHook_Tab_GroupBox_Main_Indicators_Position_Selector:GetValue() == 1 then
        EbaHook_Tab_GroupBox_Main_Indicators_X_Slider:SetInvisible(false)
        EbaHook_Tab_GroupBox_Main_Indicators_X_Offset:SetInvisible(true)
        EbaHook_Tab_GroupBox_Main_Indicators_Y_Slider:SetInvisible(false)
        EbaHook_Tab_GroupBox_Main_Indicators_Y_Offset:SetInvisible(true)
	elseif EbaHook_Tab_GroupBox_Main_Indicators_Position_Selector:GetValue() == 2 then
        EbaHook_Tab_GroupBox_Main_Indicators_X_Slider:SetInvisible(true)
        EbaHook_Tab_GroupBox_Main_Indicators_X_Offset:SetInvisible(false)
        EbaHook_Tab_GroupBox_Main_Indicators_Y_Slider:SetInvisible(true)
        EbaHook_Tab_GroupBox_Main_Indicators_Y_Offset:SetInvisible(false)
    elseif EbaHook_Tab_GroupBox_Main_Indicators_Position_Selector:GetValue() == 3 then
        EbaHook_Tab_GroupBox_Main_Indicators_X_Slider:SetInvisible(false)
        EbaHook_Tab_GroupBox_Main_Indicators_X_Offset:SetInvisible(true)
        EbaHook_Tab_GroupBox_Main_Indicators_Y_Slider:SetInvisible(false)
        EbaHook_Tab_GroupBox_Main_Indicators_Y_Offset:SetInvisible(true)
	elseif EbaHook_Tab_GroupBox_Main_Indicators_Position_Selector:GetValue() == 4 then
        EbaHook_Tab_GroupBox_Main_Indicators_X_Slider:SetInvisible(true)
        EbaHook_Tab_GroupBox_Main_Indicators_X_Offset:SetInvisible(true)
        EbaHook_Tab_GroupBox_Main_Indicators_Y_Slider:SetInvisible(true)
        EbaHook_Tab_GroupBox_Main_Indicators_Y_Offset:SetInvisible(true)
    end

    if engine.GetServerIP() ~= nil then
        if get_LP() ~= nil then
            if Indicators ~= nil then
                if EbaHook_Tab_GroupBox_Main_Indicators_Position_Selector:GetValue() == 1 then
                    for index in pairs(Indicators) do
						local r, g, b, a = indcolor_nyahook:GetValue()
						draw.Color(r, g, b, a)
                        draw.SetFont(EbaHook_Font)
                        draw.TextShadow(EbaHook_Tab_GroupBox_Main_Indicators_X_Slider:GetValue(), EbaHook_Tab_GroupBox_Main_Indicators_Y_Slider:GetValue() + (index * 25), Indicators[index])
                    end
                elseif EbaHook_Tab_GroupBox_Main_Indicators_Position_Selector:GetValue() == 2 then
                    for index in pairs(Indicators) do
						local r, g, b, a = indcolor_nyahook1:GetValue()
						draw.Color(r, g, b, a)
                        draw.SetFont(EbaHook_Font_2)
                        draw.TextShadow(EbaHook_Screen_X/2 - 15 + EbaHook_Tab_GroupBox_Main_Indicators_X_Offset:GetValue(), EbaHook_Screen_Y/2 - 15 + EbaHook_Tab_GroupBox_Main_Indicators_Y_Offset:GetValue() + (index * 15), Indicators[index])
                    end
                elseif EbaHook_Tab_GroupBox_Main_Indicators_Position_Selector:GetValue() == 0 then
                    for index in pairs(Indicators) do
						local r, g, b, a = cute:GetValue()
						draw.Color(r, g, b, a)
                        draw.SetFont(xhair_font)
						
                    end
                end
            end
        end
    end
end


local function draw_gsIndicators(gsIndicators)

	if EbaHook_Tab_GroupBox_Main_Indicators_Position_Selector:GetValue() == 3 then
        EbaHook_Tab_GroupBox_Main_Indicators_X_Slider:SetInvisible(false)
        EbaHook_Tab_GroupBox_Main_Indicators_X_Offset:SetInvisible(true)
        EbaHook_Tab_GroupBox_Main_Indicators_Y_Slider:SetInvisible(false)
        EbaHook_Tab_GroupBox_Main_Indicators_Y_Offset:SetInvisible(true)
    end
	
	    if engine.GetServerIP() ~= nil then
        if get_LP() ~= nil then
            if gsIndicators ~= nil then
				if EbaHook_Tab_GroupBox_Main_Indicators_Position_Selector:GetValue() == 3 then
                    for index in pairs(gsIndicators) do
                        draw.SetFont(fonto)
                        draw.TextShadow(EbaHook_Tab_GroupBox_Main_Indicators_X_Slider:GetValue(), EbaHook_Tab_GroupBox_Main_Indicators_Y_Slider:GetValue() + (index * 25), gsIndicators[index])
                    end
				end
			end
		end
	end
end

local function draw_finland(finland)

	if EbaHook_Tab_GroupBox_Main_Indicators_Position_Selector:GetValue() == 4 then
        EbaHook_Tab_GroupBox_Main_Indicators_X_Slider:SetInvisible(false)
        EbaHook_Tab_GroupBox_Main_Indicators_X_Offset:SetInvisible(true)
        EbaHook_Tab_GroupBox_Main_Indicators_Y_Slider:SetInvisible(false)
        EbaHook_Tab_GroupBox_Main_Indicators_Y_Offset:SetInvisible(true)
    end
	
	    if engine.GetServerIP() ~= nil then
        if get_LP() ~= nil then
            if finland ~= nil then
				if EbaHook_Tab_GroupBox_Main_Indicators_Position_Selector:GetValue() == 4 then
                    for index in pairs(finland) do
                        draw.SetFont(fonto)
                        draw.TextShadow(EbaHook_Tab_GroupBox_Main_Indicators_X_Slider:GetValue(), EbaHook_Tab_GroupBox_Main_Indicators_Y_Slider:GetValue() + (index * 25), finland[index])
                    end
				end
			end
		end
	end
end

local function draw_cutexhair(underxhair)

	if EbaHook_Tab_GroupBox_Main_Indicators_Position_Selector:GetValue() == 0 then
        EbaHook_Tab_GroupBox_Main_Indicators_X_Slider:SetInvisible(true)
        EbaHook_Tab_GroupBox_Main_Indicators_X_Offset:SetInvisible(false)
        EbaHook_Tab_GroupBox_Main_Indicators_Y_Slider:SetInvisible(true)
        EbaHook_Tab_GroupBox_Main_Indicators_Y_Offset:SetInvisible(false)
    end
	
	    if engine.GetServerIP() ~= nil then
        if get_LP() ~= nil then
            if underxhair ~= nil then
				if EbaHook_Tab_GroupBox_Main_Indicators_Position_Selector:GetValue() == 0 then
                    for index in pairs(underxhair) do
						local r, g, b, a = cute:GetValue()
						draw.Color(r, g, b, a)
                        draw.SetFont(xhair_font)
						draw.TextShadow(EbaHook_Screen_X/2 - 15 + EbaHook_Tab_GroupBox_Main_Indicators_X_Offset:GetValue(), EbaHook_Screen_Y/2 - 15 + EbaHook_Tab_GroupBox_Main_Indicators_Y_Offset:GetValue() + (index * 15), underxhair[index])
                    end
				end
			end
		end
	end
end

local function main()
    if(engine.GetServerIP() ~= nil) then
        if get_LP():GetPropInt("m_iTeamNum") == 2 or get_LP():GetPropInt("m_iTeamNum") == 3 then
            Clantag()
        end
    end

    local Indicators = get_Indicators()
    draw_Indicators(Indicators)
	if EbaHook_Tab_GroupBox_Main_Indicators_Position_Selector:GetValue() == 3 then
		local gsIndicators = get_gsIndicators()
		draw_gsIndicators(gsIndicators)
    end
	if EbaHook_Tab_GroupBox_Main_Indicators_Position_Selector:GetValue() == 0 then
		local underxhair = get_underxhair()
		draw_cutexhair(underxhair)
    end
	if EbaHook_Tab_GroupBox_Main_Indicators_Position_Selector:GetValue() == 4 then
		local finland = get_finland()
		draw_finland(finland)
    end
    if EbaHook_Tab_GroupBox_Main_Toggler:GetValue() then
        gui.SetValue( "rbot.aim.enable", 1 )
    else
        gui.SetValue( "rbot.aim.enable", 0 )
    end

end

local viewangles;

local function dynamicfov_logic()
    local pLocal = entities.GetLocalPlayer()
    
    if not EbaHook_Tab_GroupBox_Main_DFOV_Checkbox:GetValue() then return end
    if not pLocal then return end
    if not pLocal:GetAbsOrigin() then return end
    
    local dynamicfov_new_fov = gui.GetValue("rbot.aim.target.fov")
    local players = entities.FindByClass("CCSPlayer")
    local enemy_players = {}
    
    local min_fov = EbaHook_Tab_GroupBox_Main_DFOV_Min_Slider:GetValue()
    local max_fov = EbaHook_Tab_GroupBox_Main_DFOV_Max_Slider:GetValue()
    
    if min_fov > max_fov then
    local store_min_fov = min_fov
    min_fov = max_fov
    max_fov = store_min_fov
    end
    
    for i = 1, #players do
    if players[i]:GetPropInt("m_iTeamNum") ~= entities.GetLocalPlayer():GetPropInt("m_iTeamNum") and not players[i]:IsDormant() and players[i]:IsAlive() then
    table.insert(enemy_players, players[i])
    end
    end
    
    if #enemy_players ~= 0 then
    local own_hitbox = pLocal:GetHitboxPosition(0)
    local own_x, own_y, own_z = own_hitbox.x, own_hitbox.y, own_hitbox.z
    local own_pitch, own_yaw = viewangles.pitch, viewangles.yaw
    closest_enemy = nil
    local closest_distance = math.huge
    
    for i = 1, #enemy_players do
    local enemy = enemy_players[i]
    local enemy_x, enemy_y, enemy_z = enemy:GetHitboxPosition(0).x, enemy:GetHitboxPosition(0).y, enemy:GetHitboxPosition(0).z
    local x = enemy_x - own_x
    local y = enemy_y - own_y
    local z = enemy_z - own_z
    
    local yaw = (math.atan2(y, x) * 180 / math.pi)
    local pitch = -(math.atan2(z, math.sqrt(math.pow(x, 2) + math.pow(y, 2))) * 180 / math.pi)
    
                local yaw_dif = math.abs(own_yaw % 360 - yaw % 360) % 360
                local pitch_dif = math.abs(own_pitch - pitch) % 360
    
                if yaw_dif > 180 then
                    yaw_dif = 360 - yaw_dif
                end
    
                local real_dif = math.sqrt(math.pow(yaw_dif, 2) + math.pow(pitch_dif, 2))
    
                if closest_distance > real_dif then
                    closest_distance = real_dif
                    closest_enemy = enemy
                end
    end
    
    if closest_enemy ~= nil then
    local closest_enemy_x, closest_enemy_y, closest_enemy_z = closest_enemy:GetHitboxPosition(0).x, closest_enemy:GetHitboxPosition(0).y, closest_enemy:GetHitboxPosition(0).z
                local real_distance = math.sqrt(math.pow(own_x - closest_enemy_x, 2) + math.pow(own_y - closest_enemy_y, 2) + math.pow(own_z - closest_enemy_z, 2))
    
                dynamicfov_new_fov = max_fov - ((max_fov - min_fov) * (real_distance - 250) / 1000)
    end
    if (dynamicfov_new_fov > max_fov) then
                dynamicfov_new_fov = max_fov
            elseif dynamicfov_new_fov < min_fov then
                dynamicfov_new_fov = min_fov
            end
    
            dynamicfov_new_fov = math.floor(dynamicfov_new_fov + 0.5)
    
            if (dynamicfov_new_fov > closest_distance) then
                bool_in_fov = true
            else
                bool_in_fov = false
            end
        else
            dynamicfov_new_fov = min_fov
            bool_in_fov = false
        end
    
        if dynamicfov_new_fov ~= old_fov then
            gui.SetValue("rbot.aim.target.fov", dynamicfov_new_fov)
        end
end
    
callbacks.Register("Draw", "dynfov", dynamicfov_logic)

callbacks.Register("CreateMove", function(cmd)
    viewangles = cmd:GetViewAngles()
    end)

function OnlybaimEnable()
    baimshared = gui.GetValue("rbot.hitscan.points.shared.scale")
    baimzeus = gui.GetValue("rbot.hitscan.points.zeus.scale")
    baimauto = gui.GetValue("rbot.hitscan.points.asniper.scale")
    baimsniper = gui.GetValue("rbot.hitscan.points.sniper.scale")
    baimpistol = gui.GetValue("rbot.hitscan.points.pistol.scale")
    baimrevolver = gui.GetValue("rbot.hitscan.points.hpistol.scale")
    baimsmg = gui.GetValue("rbot.hitscan.points.smg.scale")
    baimrifle = gui.GetValue("rbot.hitscan.points.rifle.scale")
    baimshotgun = gui.GetValue("rbot.hitscan.points.shotgun.scale")
    baimscout = gui.GetValue("rbot.hitscan.points.scout.scale")
    baimlmg = gui.GetValue("rbot.hitscan.points.lmg.scale")
    
    gui.Command('rbot.hitscan.points.shared.scale 0 3 0 3 4 0 0 0')
    gui.Command('rbot.hitscan.points.zeus.scale 0 3 0 3 4 0 0 0')
    gui.Command('rbot.hitscan.points.asniper.scale 0 3 0 3 4 0 0 0')
    gui.Command('rbot.hitscan.points.sniper.scale 0 3 0 3 4 0 0 0')
    gui.Command('rbot.hitscan.points.pistol.scale 0 3 0 3 4 0 0 0')
    gui.Command('rbot.hitscan.points.hpistol.scale 0 3 0 3 4 0 0 0')
    gui.Command('rbot.hitscan.points.smg.scale 0 3 0 3 4 0 0 0')
    gui.Command('rbot.hitscan.points.rifle.scale 0 3 0 3 4 0 0 0')
    gui.Command('rbot.hitscan.points.shotgun.scale 0 3 0 3 4 0 0 0')
    gui.Command('rbot.hitscan.points.scout.scale 0 3 0 3 4 0 0 0')
    gui.Command('rbot.hitscan.points.lmg.scale  0 3 0 3 4 0 0 0')
    gui.SetValue( "rbot.hitscan.mode.shared.bodyaim.force", true )
    gui.SetValue( "rbot.hitscan.mode.zeus.bodyaim.force", true )
    gui.SetValue( "rbot.hitscan.mode.asniper.bodyaim.force", true )
    gui.SetValue( "rbot.hitscan.mode.sniper.bodyaim.force", true )
    gui.SetValue( "rbot.hitscan.mode.pistol.bodyaim.force", true )
    gui.SetValue( "rbot.hitscan.mode.hpistol.bodyaim.force", true )
    gui.SetValue( "rbot.hitscan.mode.smg.bodyaim.force", true )
    gui.SetValue( "rbot.hitscan.mode.rifle.bodyaim.force", true )
    gui.SetValue( "rbot.hitscan.mode.shotgun.bodyaim.force", true )
    gui.SetValue( "rbot.hitscan.mode.scout.bodyaim.force", true )
    gui.SetValue( "rbot.hitscan.mode.lmg.bodyaim.force", true )

end
    
function OnlybaimDisable()
    gui.Command('rbot.hitscan.points.shared.scale ' ..baimshared)
    gui.Command('rbot.hitscan.points.zeus.scale ' ..baimzeus)
    gui.Command('rbot.hitscan.points.asniper.scale ' ..baimauto)
    gui.Command('rbot.hitscan.points.sniper.scale ' ..baimsniper)
    gui.Command('rbot.hitscan.points.pistol.scale ' ..baimpistol)
    gui.Command('rbot.hitscan.points.hpistol.scale ' ..baimrevolver)
    gui.Command('rbot.hitscan.points.smg.scale ' ..baimsmg)
    gui.Command('rbot.hitscan.points.rifle.scale ' ..baimrifle)
    gui.Command('rbot.hitscan.points.shotgun.scale ' ..baimshotgun)
    gui.Command('rbot.hitscan.points.scout.scale ' ..baimscout)
    gui.Command('rbot.hitscan.points.lmg.scale ' ..baimlmg)
    gui.SetValue( "rbot.hitscan.mode.shared.bodyaim.force", false )
    gui.SetValue( "rbot.hitscan.mode.zeus.bodyaim.force", false )
    gui.SetValue( "rbot.hitscan.mode.asniper.bodyaim.force", false )
    gui.SetValue( "rbot.hitscan.mode.sniper.bodyaim.force", false )
    gui.SetValue( "rbot.hitscan.mode.pistol.bodyaim.force", false )
    gui.SetValue( "rbot.hitscan.mode.hpistol.bodyaim.force", false )
    gui.SetValue( "rbot.hitscan.mode.smg.bodyaim.force", false )
    gui.SetValue( "rbot.hitscan.mode.rifle.bodyaim.force", false )
    gui.SetValue( "rbot.hitscan.mode.shotgun.bodyaim.force", false )
    gui.SetValue( "rbot.hitscan.mode.scout.bodyaim.force", false )
    gui.SetValue( "rbot.hitscan.mode.lmg.bodyaim.force", false )
end
    
    
function BaimOnKey()
    if EbaHook_Tab_GroupBox_Main_BAIM_Toggler:GetValue() == 0 then return end
        if(input.IsButtonPressed(EbaHook_Tab_GroupBox_Main_BAIM_Toggler:GetValue())) then
            baim = baim + 1;
        elseif(input.IsButtonDown) then
        -- do nothing
        end
        if(input.IsButtonReleased(EbaHook_Tab_GroupBox_Main_BAIM_Toggler:GetValue())) then
                if (baim%2 == 0) then
                        OnlybaimEnable()
                        baim = 0;
                elseif (baim%2 == 1) then
                        OnlybaimDisable()
                        baim = 1;
                end
              
        end 
        
end
callbacks.Register( "Draw", "BaimOnKey", BaimOnKey )

function InvertOnKey()
    if EbaHook_Tab_GroupBox_Main_Inverter:GetValue() ~= 0 then
    if input.IsButtonPressed(EbaHook_Tab_GroupBox_Main_Inverter:GetValue()) then
        gui.SetValue( "rbot.antiaim.base.rotation", -gui.GetValue( "rbot.antiaim.base.rotation" ) )
        gui.SetValue( "rbot.antiaim.base.lby", -gui.GetValue( "rbot.antiaim.base.lby" ) )
    end
end
end

callbacks.Register("Draw", "InvertOnKey", InvertOnKey)

function JitterWalk()
    if EbaHook_Tab_GroupBox_Main_JWalk:GetValue() ~= 0 then
    if input.IsButtonDown(EbaHook_Tab_GroupBox_Main_JWalk:GetValue()) then
        gui.SetValue( "rbot.antiaim.base.rotation", -gui.GetValue( "rbot.antiaim.base.rotation" ) )
        gui.SetValue( "rbot.antiaim.base.lby", -gui.GetValue( "rbot.antiaim.base.lby" ) )
    end
end
end

callbacks.Register("Draw", "JitterWalk", JitterWalk)

function AWallOnKey()
    if EbaHook_Tab_GroupBox_Main_AW_Toggler:GetValue() ~= 0 then
    if input.IsButtonPressed(EbaHook_Tab_GroupBox_Main_AW_Toggler:GetValue()) then
        awtggl = not awtggl
    end
    if awtggl then   
        gui.SetValue( "rbot.hitscan.mode.shared.autowall", 1)
        gui.SetValue( "rbot.hitscan.mode.zeus.autowall", 1)
        gui.SetValue( "rbot.hitscan.mode.asniper.autowall", 1)
        gui.SetValue( "rbot.hitscan.mode.hpistol.autowall", 1)
        gui.SetValue( "rbot.hitscan.mode.lmg.autowall", 1)
        gui.SetValue( "rbot.hitscan.mode.pistol.autowall", 1)
        gui.SetValue( "rbot.hitscan.mode.shotgun.autowall", 1)
        gui.SetValue( "rbot.hitscan.mode.smg.autowall", 1)
        gui.SetValue( "rbot.hitscan.mode.scout.autowall", 1)
        gui.SetValue( "rbot.hitscan.mode.sniper.autowall", 1)
        gui.SetValue( "rbot.hitscan.mode.rifle.autowall", 1)
    else
        gui.SetValue( "rbot.hitscan.mode.shared.autowall", 0)
        gui.SetValue( "rbot.hitscan.mode.zeus.autowall", 0)
        gui.SetValue( "rbot.hitscan.mode.asniper.autowall", 0)
        gui.SetValue( "rbot.hitscan.mode.hpistol.autowall", 0)
        gui.SetValue( "rbot.hitscan.mode.lmg.autowall", 0)
        gui.SetValue( "rbot.hitscan.mode.pistol.autowall", 0)
        gui.SetValue( "rbot.hitscan.mode.shotgun.autowall", 0)
        gui.SetValue( "rbot.hitscan.mode.smg.autowall", 0)
        gui.SetValue( "rbot.hitscan.mode.scout.autowall", 0)
        gui.SetValue( "rbot.hitscan.mode.sniper.autowall", 0)
        gui.SetValue( "rbot.hitscan.mode.rifle.autowall", 0)
        end
    end
end

callbacks.Register("Draw", "AWallOnKey", AWallOnKey)

callbacks.Register("Draw", main)
callbacks.Register("Draw", draw_Indicators)



-- Unlock Inventory Access
panorama.RunScript([[
	LoadoutAPI.IsLoadoutAllowed = () => {
		return true;
	};
]])

-- Viewmodel
a=0;
i = 0;
callbacks.Register("Draw", function(event)
    client.SetConVar("viewmodel_offset_x", EbaHook_Tab_GroupBox_ViewModel_X:GetValue(), true)
    client.SetConVar("viewmodel_offset_z", EbaHook_Tab_GroupBox_ViewModel_Z:GetValue(), true)
    client.SetConVar("viewmodel_offset_y", EbaHook_Tab_GroupBox_ViewModel_Y:GetValue(), true)   
    gui.SetValue("esp.local.viewmodelfov", EbaHook_Tab_GroupBox_ViewModel_FOV:GetValue()) 
    gui.SetValue("esp.local.fov", EbaHook_Tab_GroupBox_ViewModel_ViewFOV:GetValue()) 
    
end)

callbacks.Register('Draw', function()
	if not EbaHook_Tab_GroupBox_ViewModel_SC:GetValue()  then
		if not EbaHook_Tab_GroupBox_ViewModel_SC:GetValue() and client.GetConVar('weapon_debug_spread_show') == '3' then
			client.SetConVar('weapon_debug_spread_show', 0, true)
			return
		end
		return
	end

    if(engine.GetServerIP() ~= nil) then
        if get_LP():GetWeaponType() == 5 and get_LP():GetPropBool("m_bIsScoped") == false then
            client.SetConVar('weapon_debug_spread_show', 3, true)
        else
            client.SetConVar('weapon_debug_spread_show', 0, true)
        end	
    end
	
end)

local aspect_ratio_table = {};
 
 
 
local function gcd(m, n) while m ~= 0 do m, n = math.fmod(n, m), m; end return n end

local function set_aspect_ratio(aspect_ratio_multiplier)
local screen_width, screen_height = draw.GetScreenSize(); local aspectratio_value = (screen_width*aspect_ratio_multiplier)/screen_height;
if aspect_ratio_multiplier == 1  then aspectratio_value = 0; end
client.SetConVar( "r_aspectratio", tonumber(aspectratio_value), true); end

local function on_aspect_ratio_changed()
local screen_width, screen_height = draw.GetScreenSize();
for i=1, 200 do local i2=i*0.01; i2 = 2 - i2; local divisor = gcd(screen_width*i2, screen_height); if screen_width*i2/divisor < 100 or i2 == 1 then aspect_ratio_table = screen_width*i2/divisor .. ":" .. screen_height/divisor; end end
local aspect_ratio = EbaHook_Tab_GroupBox_ViewModel_ARatio:GetValue()*0.01; aspect_ratio = 2 - aspect_ratio; set_aspect_ratio(aspect_ratio); end
callbacks.Register('Draw', "does shit" ,on_aspect_ratio_changed)


-- Watermark

local realtimefps = 21
local realtimeping = 21
local player_name = "isabelhook"
local separator = "  |  "
local awmark = "aimware"
local font = draw.CreateFont('verdana', 12, 400);
local function firstwater()
	if (testo:GetValue() ~= 0) then
        return
    end
    if testo:GetValue() == 0 then
	
		local screen_w, screen_h = draw.GetScreenSize();
		
		local playerResources = entities.GetPlayerResources();

		if(engine.GetServerIP() ~= nil) then
			if globals.RealTime() - realtimeping > 0.5 then
				if (engine.GetServerIP() == "loopback") then
					server = "localhost"
				elseif string.find(engine.GetServerIP(), "A") then
					server = "valve"
				else
					server = engine.GetServerIP()
				end
				delay = 'delay: ' .. playerResources:GetPropInt("m_iPing", get_LP():GetIndex()) .. 'ms';
				tick = math.floor( 1.0 / globals.TickInterval() ) .. ' tick';
				tickrealtimepingcountping = globals.RealTime()
			end
		end

		if (get_LP() ~= nil) then
			
			fizcord_watermark_text = player_name .. separator .. server .. separator .. delay .. separator .. tick;
		else
			fizcord_watermark_text = player_name .. separator .. awmark;
		end
		if(engine.GetServerIP() ~= nil) then
			draw.SetScissorRect(screen_w - draw.GetTextSize(fizcord_watermark_text)-11, 10,draw.GetTextSize(fizcord_watermark_text)-2,80);
			draw.SetFont( fizcord_watermark_font )
			draw.Color(EbaHook_Tab_GroupBox_Main_Indicators_WmarkColor:GetValue())
			draw.ShadowRect(screen_w - draw.GetTextSize(fizcord_watermark_text)-31, 10, screen_w - 10,13,20)
			draw.FilledRect( screen_w - draw.GetTextSize(fizcord_watermark_text)-31, 10, screen_w - 10, 13  )
			draw.Color(255,255,255,255);
			draw.Text( screen_w - draw.GetTextSize(fizcord_watermark_text) - 20, 20, fizcord_watermark_text )
		end
			draw.SetScissorRect(0, 0, draw.GetScreenSize());
end
end
callbacks.Register('Draw' ,firstwater)
local function secondwater()
	if (testo:GetValue() ~= 1) then
        return
    end
	if testo:GetValue() == 1 then
    local lp = entities.GetLocalPlayer();
    local playerResources = entities.GetPlayerResources();

    -- do not edit above

    local divider = ' | ';
    local cheatName = "isabelhook"
    local indexlp = client.GetLocalPlayerIndex()
    local userName = client.GetPlayerNameByIndex(indexlp);
    
    -- Do not edit below
    local delay;
    local tick;
  
    if (lp ~= nil) then
        delay = 'delay: ' .. playerResources:GetPropInt("m_iPing", lp:GetIndex()) .. 'ms';
        tick = math.floor(lp:GetProp("localdata", "m_nTickBase") + 0x20)*2 .. 'tick';
    end
    local watermarkText = cheatName .. divider .. "aimware" ;
    if (delay ~= nil) then
        watermarkText = watermarkText .. divider .. delay .. divider;
    end
    if (tick ~= nil) then
        watermarkText = watermarkText .. tick;
    end 
	if(engine.GetServerIP() ~= nil) then
    draw.SetFont(font);
    local w, h = draw.GetTextSize(watermarkText);
    local weightPadding, heightPadding = 20, 15;
    local watermarkWidth = weightPadding + w;
    local start_x, start_y = draw.GetScreenSize();
    start_x, start_y = start_x - watermarkWidth - 20, start_y * 0.0125;
    draw.Color(55, 55, 55, 255);
    draw.FilledRect(start_x + 7, start_y, start_x + watermarkWidth +5, start_y -5 + h + heightPadding + 7);

    
		
    draw.Color(255,255,255,255);
    draw.Text(start_x + weightPadding / 2+6, start_y + heightPadding / 2 - 1, watermarkText );


    draw.Color(EbaHook_Tab_GroupBox_Main_Indicators_otv2WmarkColor:GetValue())
    draw.FilledRect(start_x+7, start_y, start_x + watermarkWidth +5 , start_y -4);
	end
	end
end
callbacks.Register('Draw', secondwater)
---------------------------------------------------------------------------------------------------------------------------------------------------------

 -----------------------------------------------------------renderer functions-------------------------------------------------------------------------
 
 
local function _color(r, g, b, a)
    local r = math.min(255, math.max(0, r))
    local g = math.min(255, math.max(0, g or r))
    local b = math.min(255, math.max(0, b or g or r))
    local a = math.min(255, math.max(0, a or 255))
    return r, g, b, a
end
local gradient_texture_a =
draw.CreateTexture(
    common.RasterizeSVG(
    [[<defs><linearGradient id="a" x1="100%" y1="0%" x2="0%" y2="0%"><stop offset="0%" style="stop-color:rgb(255,255,255); stop-opacity:0" /><stop offset="100%" style="stop-color:rgb(255,255,255); stop-opacity:1" /></linearGradient></defs><rect width="500" height="500" style="fill:url(#a)" /></svg>]]
)
)

local gradient_texture_b =
draw.CreateTexture(
    common.RasterizeSVG(
    [[<defs><linearGradient id="c" x1="0%" y1="100%" x2="0%" y2="0%"><stop offset="0%" style="stop-color:rgb(255,255,255); stop-opacity:0" /><stop offset="100%" style="stop-color:rgb(255,255,255); stop-opacity:1" /></linearGradient></defs><rect width="500" height="500" style="fill:url(#c)" /></svg>]]
)
)

function draw.gradient(xa, ya, xb, yb, ca, cb, ltr)
local r, g, b, a = _color(ca[1], ca[2], ca[3], ca[4])
local r2, g2, b2, a2 = _color(cb[1], cb[2], cb[3], cb[4])

local texture = ltr and gradient_texture_a or gradient_texture_b

local t = (a ~= 255 or a2 ~= 255)
draw.Color(r, g, b, a)
draw.SetTexture(t and texture or nil)
draw.FilledRect(xa, ya, xb, yb)

draw.Color(r2, g2, b2, a2)
local set_texture = not t and draw.SetTexture(texture)
draw.FilledRect(xb, yb, xa, ya)
draw.SetTexture(nil)
end

function math.round(exact, quantum)
    local quant,frac = math.modf(exact/quantum)
    return quantum * (quant + (frac > 0.5 and 1 or 0))
end
local function _round(number, precision)
    local mult = 10 ^ (precision or 0)
    return math.floor(number * mult + 0.5) / mult
end

renderer.text = function(x,y,string, col, font)
   
    draw.Color( col[1], col[2], col[3], col[4] )
    draw.SetFont( font )
    draw.Text( x, y, string )

end
 
renderer.outline_text = function(x,y, string, col, font) 

    draw.SetFont( font )
    draw.Color(0,0,0,255)
    draw.Text(x + 1, y + 1,string) 
    draw.Text(x - 1, y - 1,string) 
    draw.Text(x + 1, y - 1,string) 
    draw.Text(x - 1, y + 1,string) 

    draw.Color(col[1], col[2], col[3], col[4])
    draw.Text(x, y,string) 
    

end
 

renderer.rectangle = function(x, y, w, h, clr, fill, radius)
    local alpha = 255
    if clr[4] then
        alpha = clr[4]
    end
    draw.Color(clr[1], clr[2], clr[3], alpha)
    if fill then
        draw.FilledRect(x, y, x + w, y + h)
    else
        draw.OutlinedRect(x, y, x + w, y + h)
    end
    if fill == "s" then
        draw.ShadowRect(x, y, x + w, y + h, radius)
    end
end

renderer.gradient = function(x, y, w, h, clr, clr1, vertical)
    local r, g, b, a = clr1[1], clr1[2], clr1[3], clr1[4]
    local r1, g1, b1, a1 = clr[1], clr[2], clr[3], clr[4]

    if a and a1 == nil then
        a, a1 = 255, 255
    end

    if vertical then
        if clr[4] ~= 0 then
            if a1 and a ~= 255 then
                for i = 0, w do
                    renderer.rectangle(x, y + w - i, w, 1, {r1, g1, b1, i / w * a1}, true)
                end
            else
                renderer.rectangle(x, y, w, h, {r1, g1, b1, a1}, true)
            end
        end
        if a2 ~= 0 then
            for i = 0, h do
                renderer.rectangle(x, y + i, w, 1, {r, g, b, i / h * a}, true)
            end
        end
    else
        if clr[4] ~= 0 then
            if a1 and a ~= 255 then
                for i = 0, w do
                    renderer.rectangle(x + w - i, y, 1, h, {r1, g1, b1, i / w * a1}, true)
                end
            else
                renderer.rectangle(x, y, w, h, {r1, g1, b1, a1}, true)
            end
        end
        if a2 ~= 0 then
            for i = 0, w do
                renderer.rectangle(x + i, y, 1, h, {r, g, b, i / w * a}, true)
            end
        end
    end
end
 renderer.rect = function(x, y, w, h, col)
    draw.Color(col[1], col[2], col[3], col[4]);
    draw.FilledRect(x, y, x + w, y + h);
end



 
 
 --DON't TOUCH BELOW OR UR INDICATORS WILL BREAK
  local indicator = {{}}
  function draw.indicator(r,g,b,a, string)
    local new = {}
    local add = indicator[1]
	local x = EbaHook_Tab_GroupBox_Main_Indicators_X_Slider:GetValue()
	local y = EbaHook_Tab_GroupBox_Main_Indicators_Y_Slider:GetValue()	

    new.y = y / 1.4105 - #add * 35

    local i = #add + 1
    add[i] = {}

    setmetatable(add[i], new)
    new.__index = new
    new.r, new.g, new.b, new.a = _color(r,g,b,a )
    new.string = string or ""

    return new.y
end


callbacks.Register(
    "Draw",
    function()
        local temp = {}
        local add = indicator[1]
        local _x = draw.GetScreenSize()
        local x = EbaHook_Tab_GroupBox_Main_Indicators_X_Slider:GetValue()
		local y = EbaHook_Tab_GroupBox_Main_Indicators_Y_Slider:GetValue()
        local c = 0

        draw.SetFont(fonto)

        add.y = _round(y - #temp * 35)

        for i = 1, #add do
            temp[#temp + 1] = add[i]
        end

        for i = 1, #temp do
            local _i = temp[i]

            local w, h = draw.GetTextSize(_i.string)
            local xa = _round(x + w * 0.45)
            local ya = add.y - 6
            local xb = add.y + 25
--                                                               255 = _i.a (useless info xd)
            draw.gradient(x, ya, xa, xb, {c, c, c, c}, {c, c, c, 255 * 0.3}, true)
            draw.gradient(xa, ya, x + w * 0.9, xb, {c, c, c, 255 * 0.3}, {c, c, c, c}, true)

            draw.Color (_i.r, _i.g, _i.b, 255)
            draw.TextShadow(x + 1, add.y + 1.5, _i.string)

            add.y = add.y + 35
        end

        indicator[1] = {}
    end
)






if testo:GetValue() == 0 then
local ffi = ffi
local function a(b, c, d, e)
    local f = gui.Reference("menu")
    return (function()
        local g = {}
        local h, i, j, k, l, m, n, o, p, q, r, s, t, u
        local v = {__index = {Drag = function(self, ...)
                    local w, x = self:GetValue()
                    local y, z = g.drag(w, x, ...)
                    if w ~= y or x ~= z then
                        self:SetValue(y, z)
                    end
                    return y, z
                end, SetValue = function(self, w, x)
                    local p, q = draw.GetScreenSize()
                    self.x:SetValue(w / p * self.res)
                    self.y:SetValue(x / q * self.res)
                end, GetValue = function(self)
                    local p, q = draw.GetScreenSize()
                    return math.floor(self.x:GetValue() / self.res * p), math.floor(self.y:GetValue() / self.res * q)
                end}}
        function g.new(x, A, B, C, D)
            local D = D or 10000
            local p, q = draw.GetScreenSize()
            local A = A ~= "" and A .. "." or A
            local E = gui.Slider(x, A .. "x", "Position x", B / p * D, 0, D)
            local F = gui.Slider(x, A .. "y", "Position y", C / q * D, 0, D)
            E:SetInvisible(true)
            F:SetInvisible(true)
            return setmetatable({x = E, y = F, res = D}, v)
        end
        function g.drag(w, x, G, H, I)
            if globals.FrameCount() ~= h then
                i = f:IsActive()
                l, m = j, k
                j, k = input.GetMousePos()
                o = n
                n = input.IsButtonDown(1) == true
                s = r
                r = {}
                u = t
                t = false
                p, q = draw.GetScreenSize()
            end
            if i and o ~= nil then
                if (not o or u) and n and l > w and m > x and l < w + G and m < x + H then
                    t = true
                    w, x = w + j - l, x + k - m
                    if not I then
                        w = math.max(0, math.min(p - G, w))
                        x = math.max(0, math.min(q - H, x))
                    end
                end
            end
            table.insert(r, {w, x, G, H})
            return w, x, G, H
        end
        return g
    end)().new(b, c, d, e)
end
do
    ffi.cdef [[
    typedef void* (__cdecl* tCreateInterface)(const char* name, int* returnCode);
    void* GetProcAddress(void* hModule, const char* lpProcName);
    void* GetModuleHandleA(const char* lpModuleName);
    ]]
    function mem.CreateInterface(J, K)
        return ffi.cast("tCreateInterface", ffi.C.GetProcAddress(ffi.C.GetModuleHandleA(J), "CreateInterface"))(K, ffi.new("int*"))
    end
end
do
    local L =
        draw.CreateTexture(
        common.RasterizeSVG(
            [[<defs><linearGradient id="b" x1="100%" y1="0%" x2="0%" y2="0%"><stop offset="0%" style="stop-color:rgb(255,255,255); stop-opacity:0" /><stop offset="100%" style="stop-color:rgb(255,255,255); stop-opacity:1" /></linearGradient></defs><rect width="500" height="500" style="fill:url(#b)" /></svg>]]
        )
    )
    local M =
        draw.CreateTexture(
        common.RasterizeSVG(
            [[<defs><linearGradient id="a" x1="0%" y1="100%" x2="0%" y2="0%"><stop offset="0%" style="stop-color:rgb(255,255,255); stop-opacity:0" /><stop offset="100%" style="stop-color:rgb(255,255,255); stop-opacity:1" /></linearGradient></defs><rect width="500" height="500" style="fill:url(#a)" /></svg>]]
        )
    )
    function draw.FilledRectFade(N, O, P, Q, R)
        local S = R and L or M
        draw.SetTexture(S)
        draw.FilledRect(math.floor(N), math.floor(O), math.floor(P), math.floor(Q))
        draw.SetTexture(nil)
    end
end
do
    function math.clamp(T, U, V)
        return T > V and V or T < U and U or T
    end
end
local W = gui.Reference("Misc", "General", "Extra")
local X = gui.Checkbox(W, "so.rainbow", "Rainbow", 0)
X:SetInvisible(true)
local a1 = draw.CreateFont("verdana", 12)
local a2 = {watermark = 0}
local a3 = {
    watermark = function()
        local a4 = mem.FindPattern("engine.dll", "FF E1")
        local a5 = ffi.cast("uint32_t(__fastcall*)(unsigned int, unsigned int, const char*)", a4)
        local a6 = ffi.cast("uint32_t(__fastcall*)(unsigned int, unsigned int, uint32_t, const char*)", a4)
        local a7 = ffi.cast("uint32_t**", ffi.cast("uint32_t", mem.FindPattern("engine.dll", "FF 15 ?? ?? ?? ?? A3 ?? ?? ?? ?? EB 05")) + 2)[0][0]
        local a8 = ffi.cast("uint32_t**", ffi.cast("uint32_t", mem.FindPattern("engine.dll", "FF 15 ?? ?? ?? ?? 85 C0 74 0B")) + 2)[0][0]
        local a9 = function(aa, ab, ac)
            local ad = ffi.typeof(ac)
            return function(...)
                return ffi.cast(ad, a4)(a6(a7, 0, a5(a8, 0, aa), ab), 0, ...)
            end
        end
        local ae = a9("user32.dll", "EnumDisplaySettingsA", "int(__fastcall*)(unsigned int, unsigned int, unsigned int, unsigned long, void*)")
        local af = ffi.new("struct { char pad_0[120]; unsigned long dmDisplayFrequency; char pad_2[32]; }[1]")
        ae(0, 4294967295, af[0])
        callbacks.Register(
            "Draw",
            function()
                local ag = globals.FrameTime() * 8
                local s, h, c, b = EbaHook_Tab_GroupBox_Main_Indicators_metamodWmarkColor:GetValue()
                local ah = entities.GetLocalPlayer()
                local ai = os.date("%X")
                local aj = "isabelhook"
                local ak = ah and ah:GetName() or client.GetConVar("name")
                local al = (" %s | %s | %s"):format(aj, ak, ai)
                if ah then
                    local am = entities.GetPlayerResources():GetPropInt("m_iPing", ah:GetIndex())
                    local an = (" | delay: %dms"):format(am)
                    al = (" %s | %s%s | %s"):format(aj, ak, an, ai)
                end
                draw.SetFont(a1)
                local ao, ap = draw.GetScreenSize()
                local i, x = 18, draw.GetTextSize(al) + 8
                local y, z = ao, 10 + 25 * 0
                y = y - x - 10
                a2.watermark = math.clamp(a2.watermark + (testo:GetValue() == 2 and ag or -ag), 0, 1)
				if(engine.GetServerIP() ~= nil) then
                draw.SetScissorRect(y + x - x * a2.watermark, z, x, i * 3)
                    draw.Color(s, h, c)
                    draw.FilledRect(y, z, y + x, z + 2)
               
                draw.Color(17, 17, 17, b)
                draw.FilledRect(y, z + 2, y + x, z + i)
                draw.Color(255, 255, 255)
                draw.Text(y + 4, z + 4, al)
                local al = ("ISABELHOOK STAFF $$$"):format(tonumber(af[0].dmDisplayFrequency))
                local i, x = 18, draw.GetTextSize(al) + 8
                local y, z = ao, 10 + 25 * 1
                y = y - x - 10
                draw.Color(0, 0, 0, 0)
                draw.FilledRectFade(y, z + i, y + x / 2, z + i + 1, true)
                draw.FilledRectFade(y + x, z + i + 1, y + x / 2, z + i, true)
                draw.FilledRectFade(y + x / 2, z + i + 1, y, z + i, true)
                draw.FilledRectFade(y + x / 2, z + i, y + x, z + i + 1, true)
                draw.Color(17, 17, 17, b)
				end
                draw.SetScissorRect(0, 0, ao, ap)
            end
        )
    end
}
a3.watermark()
end
local function slidershow()
EbaHook_Tab_GroupBox_Main_Indicators_1_Font_Slider:SetInvisible(true)
EbaHook_Tab_GroupBox_Main_Indicators_2_Font_Slider:SetInvisible(true)
EbaHook_Tab_GroupBox_Main_Indicators_3_Font_Slider:SetInvisible(true)
if EbaHook_Tab_GroupBox_Main_Indicators_Position_Selector:GetValue() == 0 then
	EbaHook_Tab_GroupBox_Main_Indicators_1_Font_Slider:SetInvisible(true)
	EbaHook_Tab_GroupBox_Main_Indicators_2_Font_Slider:SetInvisible(true)
	EbaHook_Tab_GroupBox_Main_Indicators_3_Font_Slider:SetInvisible(true)
elseif EbaHook_Tab_GroupBox_Main_Indicators_Position_Selector:GetValue() == 1 then
	EbaHook_Tab_GroupBox_Main_Indicators_1_Font_Slider:SetInvisible(false)
	EbaHook_Tab_GroupBox_Main_Indicators_2_Font_Slider:SetInvisible(true)
	EbaHook_Tab_GroupBox_Main_Indicators_3_Font_Slider:SetInvisible(true)
elseif EbaHook_Tab_GroupBox_Main_Indicators_Position_Selector:GetValue() == 2 then 
	EbaHook_Tab_GroupBox_Main_Indicators_1_Font_Slider:SetInvisible(true)
	EbaHook_Tab_GroupBox_Main_Indicators_2_Font_Slider:SetInvisible(false)
	EbaHook_Tab_GroupBox_Main_Indicators_3_Font_Slider:SetInvisible(true)
elseif EbaHook_Tab_GroupBox_Main_Indicators_Position_Selector:GetValue() == 3 then 
	EbaHook_Tab_GroupBox_Main_Indicators_1_Font_Slider:SetInvisible(true)
	EbaHook_Tab_GroupBox_Main_Indicators_2_Font_Slider:SetInvisible(true)
	EbaHook_Tab_GroupBox_Main_Indicators_3_Font_Slider:SetInvisible(false)
elseif EbaHook_Tab_GroupBox_Main_Indicators_Position_Selector:GetValue() == 4 then 
	EbaHook_Tab_GroupBox_Main_Indicators_1_Font_Slider:SetInvisible(true)
	EbaHook_Tab_GroupBox_Main_Indicators_2_Font_Slider:SetInvisible(true)
	EbaHook_Tab_GroupBox_Main_Indicators_3_Font_Slider:SetInvisible(false)
end 
end
callbacks.Register("Draw", slidershow)

local a,b,c,d,e,f=25,660,0,0,300,60;
local g=draw.CreateFont("Verdana",13,400)
local i=gui.Checkbox(EbaHook_Tab_GroupBox_Misc,"speccheckbox","Compact Spectator List",false)
i:SetDescription("See who is spectating you. Upper left side of the screen.")
local j=gui.Slider(EbaHook_Tab_GroupBox_Misc,"specslider","Font Size",13,5,25)
local k=gui.Button(EbaHook_Tab_GroupBox_Misc,"Apply Font",function()g=draw.CreateFont("Verdana",j:GetValue(),400)
end)
j:SetDescription("Choose a font size.")
local l=gui.ColorPicker(i,"speccolor","Color",255,255,255,255)
k:SetWidth(265)
local function m()local n={}local o=entities.GetLocalPlayer()if i:GetValue()then if o~=nil then local p=entities.FindByClass("CCSPlayer")for q=1,#p do local p=p[q]if p~=o and p:GetHealth()<=0 then local r=p:GetName()if p:GetPropEntity("m_hObserverTarget")~=nil then local s=p:GetIndex()if r~="GOTV"and s~=1 then local t=p:GetPropEntity("m_hObserverTarget")if t:IsPlayer()then local u=t:GetIndex()local v=client.GetLocalPlayerIndex()if o:IsAlive()then if u==v then table.insert(n,p)end end end end end end end end end;return n end;local function w(n)local x=false;for y,p in pairs(n)do x=true;draw.SetFont(g)draw.Color(l:GetValue())draw.Text(a-23,b-550-120+y*12,p:GetName())end end;local function z(A)local B,C=draw.GetTextSize(keytext)local D=5+A*15;local f=f+A*15 end;callbacks.Register("Draw",function()local n=m()z(#n)w(n)end)

 


