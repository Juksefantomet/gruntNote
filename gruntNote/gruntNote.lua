-- How to check ingame build for future ref
-- /run print((select(4, GetBuildInfo())))
-- keep your mods updated!
local jukseHelpText = 
[[
/gnote on - turns the addon on (default)
/gnote off - turns the addon off
/gnote show - displays the Grunt Note window with last known custom reminder
/gnote standard,x  - creates a standard alert with sound for x seconds
/gnote normal,x,msg - creates a standard alert with sound for x seconds and a custom message
/gnote advanced,x,msg - creates an extendable advanced alert with sound for x seconds and a custom message
*** IMPORTANT: avoid using comma in your reminder message ***
/gnote help - displays this window
]]

local firstRunAB = true
if firstRunAB == true then
	message('Grunt Note:\n  \n /gnote help \n')
	firstRunAB = false
end

local jukseGNOTEon = true
local jukseTempMsg = nil
local jukseReminderActive = false
local jukseDefaultAlert = false
local jukseTestVar = false
local juksesVarNoMsg = false
local jukseCurrent = 0
local jukseTotal = 9000000000
local f = CreateFrame("Frame")
local jukseFrame = FPreviewFrame or CreateFrame("ScrollFrame", "FPreviewFrame")
--local jukseTextHeader = jukseFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
local jukseTextHeader = jukseFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
local jukseTextBody = jukseFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
--local jukseButton = CreateFrame("Button", "jButts", mainframe)
local jukseButton = CreateFrame("Button", "jButton", jukseFrame)
local MyStatusBar = CreateFrame("StatusBar", nil, UIParent)

local function jukseStatusBar()
	--jukseRegion = MyStatusBar:CreateTitleRegion()
	--MyStatusBar:CreateTitleRegion()
	--MyStatusBar:EnableMouse(enable)
	--MyStatusBar:SetMovable(enable)
	--MyStatusBar:StartMoving()
	MyStatusBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	MyStatusBar:GetStatusBarTexture():SetHorizTile(false)
	MyStatusBar:SetMinMaxValues(0, 100)
	MyStatusBar:SetValue(100)
	MyStatusBar:SetWidth(200)
	MyStatusBar:SetHeight(25)
	--MyStatusBar:SetPoint("CENTER",UIParent,"CENTER")
	-- --MyStatusBar:SetPoint("TOP", 0, -50)
	MyStatusBar:SetPoint("TOP", 50, -50)
	--MyStatusBar:SetPoint("CENTER", 300, 300)
	MyStatusBar:SetStatusBarColor(0,1,0)
	--MyStatusBar:CreateFontString(["name" [, "layer" [, "inherits"]]]) 
	--FontString:SetText('|cff000000This text is black,|r |cffff0000while this text will be red.|r')
	MyStatusBar:Raise()
	MyStatusBar:Show()
end

local function testWindow(msg)
	--print("testwindow made")
	jukseFrame:SetScale(1)
	jukseFrame:ClearAllPoints()
	jukseFrame.bg = jukseFrame:CreateTexture(nil, "BACKGROUND")
	jukseFrame.bg:SetAllPoints(true)
	jukseFrame.bg:SetTexture(0, 0, 0, 0.5)
	jukseFrame:SetSize(600, 150) --width, heigth
	jukseFrame:SetBackdrop(StaticPopup1:GetBackdrop())
	jukseFrame:SetPoint("CENTER", UIParent)
	
	jukseButton:SetPoint("CENTER", jukseFrame, "BOTTOM", 0, 0)
	jukseButton:SetWidth(100)
	jukseButton:SetHeight(25)
	jukseButton:SetText("OK")
	jukseButton:SetNormalFontObject("GameFontNormal")
	jukseButton:SetNormalTexture("Interface/Buttons/UI-Panel-Button-Up")
	jukseButton:GetNormalTexture():SetTexCoord(0, 0.625, 0, 0.6875)
    jukseButton:SetHighlightTexture("Interface/Buttons/UI-Panel-Button-Highlight")
	jukseButton:GetHighlightTexture():SetTexCoord(0, 0.625, 0, 0.6875)
    jukseButton:SetPushedTexture("Interface/Buttons/UI-Panel-Button-Down")
	jukseButton:GetPushedTexture():SetTexCoord(0, 0.625, 0, 0.6875)
	jukseButton:SetScript("OnClick", function(self, button, down)
		--print("Clicked the save button")
		jukseFrame:Hide()
		MyStatusBar:Hide()
	end)
	jukseTextHeader:SetPoint("TOP")
	jukseTextHeader:SetText("GRUNT NOTE")
	jukseTextBody:SetPoint("CENTER")
	jukseTextBody:SetText(msg)
	jukseTextBody:SetJustifyH("LEFT")
	if msg ~= nil then
		if string.len(msg) > 32 then
			jukseFrame:SetSize(800, 150) --width, heigth
		end
	end
	jukseFrame:Show()
	--print("done!")
end

local function extendTheReminderJukse(msg)
	print("Extending timer with 5 minutes")
	jukseCurrent = 0
	jukseTotal = 300
	jukseReminderActive = true
	jukseGNOTEon = true
	jukseStatusBar()
end

local function jukseBoxInput(noteMsg)
	StaticPopupDialogs["JUKSES_CustomMessage"] = {
		text = noteMsg .. "\n \n" .. "Do you want to be reminded about this in 5 minutes?",
		button1 = "Extend",
		button2 = "Discard",
		OnAccept = function()
			extendTheReminderJukse(text)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
	}
	StaticPopup_Show("JUKSES_CustomMessage")
end

SLASH_gruntNote1 = '/gnote'
function SlashCmdList.gruntNote(msg, editbox)
	local command, arg1, arg2 = strsplit(",",msg)
	
	if command == 'on' then
		jukseGNOTEon = true
		print("gruntNote Turned ON");
	end
	if command == 'off' then
		jukseGNOTEon = false
		jukseDefaultAlert = false
		jukseTestVar = false
		MyStatusBar:Hide()
		print("gruntNote Turned OFF");
	end
	if command == 'standard' then
		jukseCurrent = 0
	    jukseTotal = tonumber(arg1)
		print("gruntNote reminder created with a custom interval of " .. arg1);
		jukseGNOTEon = true
		jukseDefaultAlert = true
		juksesVarNoMsg = true
		jukseStatusBar()
	end
	if command == 'normal' then
	    jukseCurrent = 0
		jukseTotal = tonumber(arg1)
		print("gruntNote reminder created with a custom interval of " .. arg1);
		jukseDefaultAlert = true
		jukseGNOTEon = true
		jukseTempMsg = arg2
		jukseStatusBar()
	end
	if command == 'advanced' then
		jukseCurrent = 0
	    jukseTotal = tonumber(arg1)
		jukseGNOTEon = true
		jukseTestVar = true
		jukseTempMsg = arg2
		jukseStatusBar()
	end
	if command == 'show' then
		PlaySoundFile("Interface\\AddOns\\gruntNote\\orc_huh.mp3", "Master")
		if jukseTempMsg == nil then
			testWindow("No reminders active!")
		elseif jukseTempMsg == jukseHelpText then
			testWindow("No reminders active!")
		else
			testWindow(jukseTempMsg)
		end
		jukseStatusBar()
	end
	if msg == 'help' then
		PlaySoundFile("Interface\\AddOns\\gruntNote\\orc_welcome.mp3", "Master")
		testWindow(jukseHelpText)
		--print("----------------------------------------")
		--print(jukseHelpText)
		--print("----------------------------------------")
		--print("Type /gnote on || /gnote off to start/stop")
		--print(" -- COMMAND EXAMPLE --")
		--print(" -  /gnote test2,5,Do not forget to farm leather for guildbank!  - ")
		--print(" -- COMMAND EXAMPLE END --")
		--print("Type /gnote new,10 - to initiate a 10 second general audio reminder")
		--print("Type /gnote tast,60 - to test a 60 second delayed audio reminder with message box!")
		--print("Type /gnote test2,3600 - for a 1 hour testbox with no sound!")
	end
end

local function onUpdate(self,elapsed)

	jukseCurrent = jukseCurrent + elapsed

    if jukseCurrent >= jukseTotal then
		if jukseGNOTEon == true then
			if WorldFrame:IsEventRegistered("CURSOR_UPDATE") ~= "cursor" then
				if jukseDefaultAlert == true then
					PlaySoundFile("Interface\\AddOns\\gruntNote\\orc_hello.mp3", "Master")
					if juksesVarNoMsg == true then
						message('Grunt Note: \n \n Reminding you of something!')
						juksesVarNoMsg = false
					else
						message(jukseTempMsg)
					end
					jukseTotal = 9000000000
					jukseCurrent = 0
					jukseDefaultAlert = false
					jukseGNOTEon = false
					MyStatusBar:Hide()
				end
				if jukseTestVar == true then
					PlaySoundFile("Interface\\AddOns\\gruntNote\\orc_hello.mp3", "Master")
					jukseBoxInput(jukseTempMsg)
					jukseTotal = 9000000000
					jukseCurrent = 0
					jukseTestVar = false
					jukseGNOTEon = false
					MyStatusBar:Hide()
				end
				if jukseReminderActive == true then
					PlaySoundFile("Interface\\AddOns\\gruntNote\\orc_hello.mp3", "Master")
					jukseBoxInput(jukseTempMsg)
					jukseTotal = 9000000000
					jukseCurrent = 0
					jukseReminderActive = false
					jukseGNOTEon = false
					MyStatusBar:Hide()
				end
			end
		end
		if jukseGNOTEon == false then
			--DEFAULT_CHAT_FRAME:AddMessage("Grunt Note is not active!")
		end
    end
end

local function jukseTest()
	if jukseGNOTEon == true then
		f:SetScript("OnUpdate", onUpdate)
	end
	if jukseGNOTEon == false then
		f:SetScript("OnUpdate", onUpdate)
	end
end

jukseTest()