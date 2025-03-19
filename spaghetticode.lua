--// Cache
luocal RPS = game.ReplicatedStorage
local Voice = RPS.Voices:FindFirstChild(_G.dodconfig.useVoice)
local player = game.Players.LocalPlayer
local character = player.Character
local pgui = player.PlayerGui
local status = player.Status
local plr = game.Players.LocalPlayer
local char = plr.Character
local pgui = plr.PlayerGui
local interf = pgui.Interface
local bt = interf.Battle
local main = bt.Main

if not getcustomasset then getcustomasset = getsynasset end

if not isfolder("ps2kiryu_voice") then
	makefolder("ps2kiryu_voice")
end

local function sendNotification(text, color, stroke, sound)
	local upper = string.upper(text)
	-- Fire the notification event
	if sound then
		pgui["Notify"]:Fire(text, sound)
	else
		pgui["Notify"]:Fire(text)
	end
	-- If color is not provided, default to white
	if not color then
		color = Color3.new(1, 1, 1)
	end

	if not stroke then
		stroke = Color3.new(0, 0, 0)
	end

	-- Listen for when a new child is added to NotifyUI.Awards
	for i, v in ipairs(pgui.NotifyUI.Awards:GetChildren()) do
		if v.Name == "XPEx" and v.Text == upper then
			v.Text = text
			v.TextColor3 = color
			v.TextStrokeColor3 = stroke
			v.Text = text
		end
	end
end

sendNotification("Loading PS2 voice…\n(This may take a while!)")

writefile("getup.wav", game:HttpGet("https://github.com/manythingsofthings/r2f-ps2kiryu-voice-mod/blob/main/files/getup.wav?raw=true"))

local filesToDownload = {
	{
		prefix = "hact",
		range = {
			1,
			12
		}
	},
	{
		prefix = "knockback",
		range = {
			1,
			2
		}
	},
	{
		prefix = "heavy",
		range = {
			1,
			5
		}
	},
	{
		prefix = "heavy",
		range = {
			9,
			15
		}
	},
	{
		prefix = "hurt",
		range = {
			1,
			7
		}
	},
	{
		prefix = "light",
		range = {
			1,
			13
		}
	},
	{
		prefix = "rage",
		range = {
			1,
			3
		}
	},
	{
		prefix = "taunt",
		range = {
			1,
			8
		}
	},
}

for _, file in ipairs(filesToDownload) do
	for i = file.range[1], file.range[2] do
		if not isfile("ps2kiryu_voice/" .. file.prefix .. i .. ".wav") then
			local url = "https://github.com/manythingsofthings/r2f-ps2kiryu-voice-mod/blob/main/files/" .. file.prefix .. i .. ".wav?raw=true"
			writefile("ps2kiryu_voice/" .. file.prefix .. i .. ".wav", game:HttpGet(url))
		end
	end
end

local function doingHact()
	return (character:FindFirstChild("Heated") and true or false)
end

local function playSound(sound)
	if char.Head:FindFirstChild("Voice") then
		if not string.match(sound, "rage") then
			char.Head.Voice:Destroy()		
		end
	end
	local soundclone = Instance.new("Sound")
	soundclone.Parent = character.Head
	soundclone.Name = "Voice"
	soundclone.SoundId = getcustomasset(sound)
	soundclone.Volume = .7
	for i = 4, 15 do
		if string.find(sound, "hact") then
			if i >= 9 and string.find(sound, "hact" .. i) then
				soundclone.Volume = .35
			end
		elseif string.find(sound, "knockback") then
			if i >= 3 and string.find(sound, "knockback" .. i) then
				soundclone.Volume = .35
			end
		elseif string.find(sound, "heavy") then
			if i >= 6 and string.find(sound, "heavy" .. i) then
				soundclone.Volume = .35
			end
		elseif string.find(sound, "hurt") then
			if i >= 8 and string.find(sound, "hurt" .. i) then
				soundclone.Volume = .35
			end
		elseif string.find(sound, "light") then
			if i >= 6 and string.find(sound, "light" .. i) then
				soundclone.Volume = .35
			end
		elseif string.find(sound, "rage") then
			if i >= 4 and string.find(sound, "rage" .. i) then
				soundclone.Volume = .35
			end
		elseif string.find(sound, "taunt") then
			if i >= 4 and string.find(sound, "taunt" .. i) then
				soundclone.Volume = .35
			end
		end
	end
	soundclone:Play()
	soundclone.Ended:Connect(
        function()
		game:GetService("Debris"):AddItem(soundclone)
	end)
end

local receivedsound

local HeatActionCD = false
char.ChildAdded:Connect(
    function(child)
	if child.Name == "Heated" and child:WaitForChild("Heating", 0.5).Value ~= character then
		local isThrowing = child:WaitForChild("Throwing", 0.5)
		if not isThrowing then
			if main.HeatMove.TextLabel.Text ~= "Ultimate Essence" then
				if math.random(1, 2) == 1 then
					receivedsound = "ps2kiryu_voice/hact" .. math.random(1, 12) .. ".wav"
				else
					if math.random(1, 2) == 1 then
						receivedsound = "ps2kiryu_voice/heavy" .. math.random(1, 5) .. ".wav"
					else
						receivedsound = "ps2kiryu_voice/heavy" .. math.random(9, 15) .. ".wav"
					end
				end
			else
				receivedsound = "ps2kiryu_voice/taunt3.wav"
			end
			task.wait(.25)
			playSound(receivedsound)
		else
			receivedsound = "ps2kiryu_voice/hact" .. math.random(1, 12) .. ".wav"
			task.wait(.15)
			playSound(receivedsound)
		end
	end
	local HitCD = false
	if child.Name == "Hitstunned" and not character:FindFirstChild("Ragdolled") then
		if HitCD == false then
			HitCD = true
			receivedsound = "ps2kiryu_voice/hurt" .. math.random(1, 7) .. ".wav"
			playSound(receivedsound)
			delay(2, function()
				HitCD = false
			end)
		end
	end
	if child.Name == "Ragdolled" then
		receivedsound = "ps2kiryu_voice/knockback" .. math.random(1, 2) .. ".wav"
		playSound(receivedsound)
	end
	if child.Name == "ImaDea" then
		receivedsound = "ps2kiryu_voice/knockback" .. math.random(1, 2) .. ".wav"
		playSound(receivedsound)
	end
end)

character.ChildRemoved:Connect(
    function(child)
	if child.Name == "Ragdolled" then
		task.wait(0.1)
		if not string.match(status.CurrentMove.Value.Name, "Getup") then
			receivedsound = "ps2kiryu_voice/getup.wav"
			playSound(receivedsound)
		end
	end
end)

character.HumanoidRootPart.ChildAdded:Connect(
    function(child)
	if child.Name == "KnockOut" or child.Name == "KnockOutRare" then
		child.Volume = 0
	end
end)

local fakeTauntSound = RPS.Sounds:FindFirstChild("Laugh"):Clone()
fakeTauntSound.Parent = RPS.Sounds
fakeTauntSound.Name = "FakeLaugh"
fakeTauntSound.Volume.Value = 0
RPS.Moves.Taunt.Sound.Value = "FakeLaugh"
RPS.Moves.DragonTaunt.Sound.Value = "FakeLaugh"
RPS.Moves.RushTaunt.Sound.Value = "FakeLaugh"
RPS.Moves.GoonTaunt.Sound.Value = "FakeLaugh"
status.Taunting.Changed:Connect(
    function()
	if status.Taunting.Value == true and status.CurrentMove.Value.Name ~= "BeastTaunt" then
		receivedsound = "ps2kiryu_voice/taunt" .. math.random(1, 7) .. ".wav"
		playSound(receivedsound)
	end
end)
local LightAttackCD = false
status.CurrentMove.Changed:Connect(
    function()
	if string.match(status.CurrentMove.Value.Name, "Attack") or string.match(status.CurrentMove.Value.Name, "Punch") then
		if LightAttackCD == false then
			LightAttackCD = true
			receivedsound = "ps2kiryu_voice/light" .. math.random(1, 13) .. ".wav"
			playSound(receivedsound)
			delay(0.35, function()
				LightAttackCD = false
			end)
		end
	else
		if not string.match(status.CurrentMove.Value.Name, "Taunt") and not string.match(status.CurrentMove.Value.Name, "Grab") and not string.match(status.CurrentMove.Value.Name, "CounterHook") then
			if math.random(1, 2) == 1 then
				receivedsound = "ps2kiryu_voice/heavy" .. math.random(1, 5) .. ".wav"
			else
				receivedsound = "ps2kiryu_voice/heavy" .. math.random(9, 15) .. ".wav"
			end
			playSound(receivedsound)
		end
	end
end)
sendNotification("VOICE LOADED", Color3.new(1, 0, 0), Color3.new(0, 0, 0), "HeatDepleted")

status.ChildAdded:Connect(function(c)
	if c.Name == "ANGRY" then
		receivedsound = "ps2kiryu_voice/rage" .. math.random(1, 3) .. ".wav"
		playSound(receivedsound)
	end
end)
