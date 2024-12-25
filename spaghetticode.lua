local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local ME = ReplicatedStorage.Events.ME

--// Cache
local rep = game.ReplicatedStorage
local player = game.Players.LocalPlayer
local char = player.Character
local pgui = player.PlayerGui
local status = player.Status
local plr = game.Players.LocalPlayer
local char = plr.Character
local pgui = plr.PlayerGui
local interf = pgui.Interface
local bt = interf.Battle
local main = bt.Main

local functiom checkfile(name, data)
	if not isfile(name) then
		writefile(name, data)
	end
end

checkfile("getup.wav", game:HttpGet("https://github.com/manythingsofthings/r2f-ps2kiryu-voice-mod/blob/main/files/getup.wav?raw=true"))

for i = 1, 8 do
	checkfile("hact" .. i .. ".wav", game:HttpGet("https://github.com/manythingsofthings/r2f-ps2kiryu-voice-mod/blob/main/files/hact" .. i .. ".wav?raw=true"))
	
	if i <= 2 then
		checkfile("knockback" .. i .. ".wav", game:HttpGet("https://github.com/manythingsofthings/r2f-ps2kiryu-voice-mod/blob/main/files/knockback" .. i .. ".wav?raw=true"))
		checkfile("heavy" .. i .. ".wav", game:HttpGet("https://github.com/manythingsofthings/r2f-ps2kiryu-voice-mod/blob/main/files/heavy" .. i .. ".wav?raw=true"))
		checkfile("hurt" .. i .. ".wav", game:HttpGet("https://github.com/manythingsofthings/r2f-ps2kiryu-voice-mod/blob/main/files/hurt" .. i .. ".wav?raw=true"))
		checkfile("light" .. i .. ".wav", game:HttpGet("https://github.com/manythingsofthings/r2f-ps2kiryu-voice-mod/blob/main/files/light" .. i .. ".wav?raw=true"))
		checkfile("rage" .. i .. ".wav", game:HttpGet("https://github.com/manythingsofthings/r2f-ps2kiryu-voice-mod/blob/main/files/rage" .. i .. ".wav?raw=true"))
		checkfile("taunt" .. i .. ".wav", game:HttpGet("https://github.com/manythingsofthings/r2f-ps2kiryu-voice-mod/blob/main/files/taunt" .. i .. ".wav?raw=true"))
	elseif i <= 3 then
		checkfile("heavy" .. i .. ".wav", game:HttpGet("https://github.com/manythingsofthings/r2f-ps2kiryu-voice-mod/blob/main/files/heavy" .. i .. ".wav?raw=true"))
		checkfile("hurt" .. i .. ".wav", game:HttpGet("https://github.com/manythingsofthings/r2f-ps2kiryu-voice-mod/blob/main/files/hurt" .. i .. ".wav?raw=true"))
		checkfile("light" .. i .. ".wav", game:HttpGet("https://github.com/manythingsofthings/r2f-ps2kiryu-voice-mod/blob/main/files/light" .. i .. ".wav?raw=true"))
		checkfile("rage" .. i .. ".wav", game:HttpGet("https://github.com/manythingsofthings/r2f-ps2kiryu-voice-mod/blob/main/files/rage" .. i .. ".wav?raw=true"))
		checkfile("taunt" .. i .. ".wav", game:HttpGet("https://github.com/manythingsofthings/r2f-ps2kiryu-voice-mod/blob/main/files/taunt" .. i .. ".wav?raw=true"))
	elseif i <= 5 then
		checkfile("heavy" .. i .. ".wav", game:HttpGet("https://github.com/manythingsofthings/r2f-ps2kiryu-voice-mod/blob/main/files/heavy" .. i .. ".wav?raw=true"))
		checkfile("hurt" .. i .. ".wav", game:HttpGet("https://github.com/manythingsofthings/r2f-ps2kiryu-voice-mod/blob/main/files/hurt" .. i .. ".wav?raw=true"))
		checkfile("light" .. i .. ".wav", game:HttpGet("https://github.com/manythingsofthings/r2f-ps2kiryu-voice-mod/blob/main/files/light" .. i .. ".wav?raw=true"))
	elseif i <= 6 then
		checkfile("hurt" .. i .. ".wav", game:HttpGet("https://github.com/manythingsofthings/r2f-ps2kiryu-voice-mod/blob/main/files/hurt" .. i .. ".wav?raw=true"))
		checkfile("light" .. i .. ".wav", game:HttpGet("https://github.com/manythingsofthings/r2f-ps2kiryu-voice-mod/blob/main/files/light" .. i .. ".wav?raw=true"))
	elseif i <= 7 then
		checkfile("hurt" .. i .. ".wav", game:HttpGet("https://github.com/manythingsofthings/r2f-ps2kiryu-voice-mod/blob/main/files/hurt" .. i .. ".wav?raw=true"))
	end
end

local function sendNotification(text, sound, color) --text function, sounds: tp, buzz, Gong, HeatDepleted
    local text1 = string.upper(text)
    if sound then
        pgui.Notify:Fire(text, sound)
    else
        pgui.Notify:Fire(text)
    end
    if color then
        for i, v in pairs(pgui.NotifyUI.Awards:GetChildren()) do
            if v.Name == "XPEx" and v.text == text1 then
                v.Text = text
                v.TextColor3 = color
            end
        end
    end
end

local function doingHact()
    return (char:FindFirstChild("Heated") and true or false)
end

local function playSound(sound)
	if char.Head:FindFirstChild("Voice") then
		char.Head.Voice:Destroy()		
	end		
    local soundclone = Instance.new("Sound")
    soundclone.Parent = char.Head
    soundclone.Name = "Voice"
    soundclone.SoundId = getsynasset(sound)
    soundclone.Volume = 0.7
    soundclone:Play()
    soundclone.Ended:Connect(
        function()
            game:GetService("Debris"):AddItem(soundclone)
        end
    )
end

local receivedsound

local HeatActionCD = false
char.ChildAdded:Connect(
    function(child)
        if child.Name == "Heated" and child:WaitForChild("Heating", 0.5).Value ~= char then
            local isThrowing = child:WaitForChild("Throwing", 0.5)
            if not isThrowing then
                if main.HeatMove.TextLabel.text ~= "Ultimate Essence " then
                    receivedsound = "hact" .. math.random(1, 8) .. ".wav"
                else
                	receivedsound = "taunt3.wav"
                end
                task.wait(.5)
                playSound(receivedsound)
            end
        end
        local HitCD = false
        if child.Name == "Hitstunned" and not char:FindFirstChild("Ragdolled") then
            if HitCD == false then
                HitCD = true
                receivedsound = "hurt" .. math.random(1, 7) .. ".wav"
                playSound(receivedsound)
                delay(
                    2,
                    function()
                        HitCD = false
                    end
                )
            end
        end
        if child.Name == "Ragdolled" then
            receivedsound = "knockback" .. math.random(1, 2) .. ".wav"
            playSound(receivedsound)
        end
        if child.Name == "ImaDea" then
            receivedsound = "knockback" .. math.random(1, 2) .. ".wav"
            playSound(receivedsound)
        end
    end
)

char.ChildRemoved:Connect(
    function(child)
        if child.Name == "Ragdolled" then
            wait(0.1)
            if not string.match(status.CurrentMove.Value.Name, "Getup") then
                receivedsound = "getup.wav"
                playSound(receivedsound)
            end
        end
    end
)

char.HumanoidRootPart.ChildAdded:Connect(
    function(child)
        if child.Name == "KnockOut" or child.Name == "KnockOutRare" then
            child.Volume = 0
        end
    end
)

local fakeTauntSound = rep.Sounds:FindFirstChild("Laugh"):Clone()
fakeTauntSound.Parent = rep.Sounds
fakeTauntSound.Name = "FakeLaugh"
fakeTauntSound.Volume.Value = 0
rep.Moves.Taunt.Sound.Value = "FakeLaugh"
rep.Moves.RushTaunt.Sound.Value = "FakeLaugh"
rep.Moves.GoonTaunt.Sound.Value = "FakeLaugh"
status.Taunting.Changed:Connect(
    function()
        if status.Taunting.Value == true and status.CurrentMove.Value.Name ~= "BeastTaunt" then
            receivedsound = "taunt" .. math.random(1, 3) .. ".wav"
            playSound(receivedsound)
        end
    end
)
local LightAttackCD = false
status.CurrentMove.Changed:Connect(
    function()
        if string.match(status.CurrentMove.Value.Name, "Attack") or string.match(status.CurrentMove.Value.Name, "Punch") then
            if LightAttackCD == false then
                LightAttackCD = true
                receivedsound = "light" .. math.random(1, 6) .. ".wav"
                playSound(receivedsound)
                delay(
                    0.35,
                    function()
                        LightAttackCD = false
                    end
                )
            end
        else
            if
                not string.match(status.CurrentMove.Value.Name, "Taunt") and
                    not string.match(status.CurrentMove.Value.Name, "Grab") and
                    not string.match(status.CurrentMove.Value.Name, "CounterHook")
             then
                receivedsound = "heavy" .. math.random(1, 5) .. ".wav"
                playSound(receivedsound)
            end
        end
    end
)
sendNotification("PS2 VOICE LOADED", nil, Color3.fromRGB(255, 255, 255))

status.cfh:GetPropertyChangedSignal("Value"):Connect(function()
	if status.cfh.Value then
		task.wait(.5)
		playSound("rage1.wav")
	end
end)

status.ChildAdded:Connect(function(c)
	if c.Name == "ANGRY" then
		receivedsound = "rage" .. math.random(1, 3) .. ".wav"
        playSound(receivedsound)
    end
end)
