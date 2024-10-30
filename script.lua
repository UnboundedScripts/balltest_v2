-- A Welcome to the User 

print("--------------------")
print("Unbounded Scripts 🔛")
print("--------------------")

local Library = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))() --Load Fluent Library/s
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({  
    Title = "ball test",
    SubTitle = "by rhuda21 ",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

-- Fluent provides Lucide Icons, they are optional
local Tabs = {  --Where Tabs Are defined
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
    Webhook = Window:AddTab({ Title = "Webhook", Icon = "webhook" }),
    Farm = Window:AddTab({ Title = "Farm", Icon = "tractor" }),
    Teleports = Window:AddTab({ Title = "Teleports", Icon = "" }),
    Fun = Window:AddTab({Title = "Fun", Icon = "" }),
}

Tabs.Main:AddButton({
    Title = "Kill Script",
    Description = "Closes the script out",
    Callback = function()
        Fluent:Destroy()
    end
})

local Slider = Tabs.Main:AddSlider("Slider", 
{
    Title = "Walkspeed",
    Description = "Adjust your walking speed",
    Default = 11,
    Min = 10,
    Max = 100,
    Rounding = 1,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = (Value)
    end
})

local Slider = Tabs.Main:AddSlider("Slider", 
{
    Title = "JumpPower",
    Description = "Adjust your jump power, how high you can go",
    Default = 2,
    Min = 0,
    Max = 200,
    Rounding = 1,
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        
        -- Wait for the character to be fully loaded
        character:WaitForChild("HumanoidRootPart")
        local humanoid = character:WaitForChild("Humanoid")

        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = Value
            print("JumpPower set to:", Value)
        else
            print("Humanoid not found!")
        end
    end
})



local ToggleKick = Tabs.Main:AddToggle("MyToggle", 
{
    Title = "Kick when New Player joins", 
    Description = "Removes you from the game if a new player joins",
    Default = false,
    Callback = function(state)
        if state then
            local Players = game:GetService("Players")
            Players.PlayerAdded:Connect(function(newPlayer)
                -- Wait to ensure new player has loaded in
                task.wait(1)
                -- Get all current players
                local currentPlayers = Players:GetPlayers()
                -- If there is more than one player kick you
                if #currentPlayers > 1 then
                    local playerToKick = currentPlayers[1]
                    playerToKick:Kick("A new player has joined, so you have been kicked.")
                end
            end)
        else
            print("Kick is Off")
        end
    end 
})

local ToggleAutofarm = Tabs.Farm:AddToggle("MyToggle", 
{
    Title = "Autofarm Wins", 
    Description = "Automatically wins for you, ⚠ NOTE THERE IS COOLDOWN BY SERVER EVERY 3 MINS",
    Default = false,
    Callback = function(state)
        autofarm = state
        if autofarm then
            spawn(function()
                while autofarm do
                    local x = 0
                    local y = 1000
                    local z = 0
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
                    task.wait(1)
                end
            end)
        else
            print("Autofarm is Off")
        end
    end 
})

Tabs.Teleports:AddButton({
    Title = "Teleport to ball tower",
    Description = "Takes you inside of the tower where the balls are",
    Callback = function()
        local Teleport = game:GetService("TeleportService")
        x = 50
        y = 50
        z = 50
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(x,y,z)
    end
})

Tabs.Teleports:AddButton({
    Title = "Teleport to Jim",
    Description = "Takes you directly into the bossfight",
    Callback = function()
        local Teleport = game:GetService("TeleportService")
        local GameID = 82584166303511
        local Players = game.Players.LocalPlayer
        Teleport:Teleport(GameID,Players)
    end
})

Tabs.Teleports:AddButton({
    Title = "Rejoin current server",
    Description = "Reconnect you back into this server",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")

        local function rejoinserver()
            local Player = Players.LocalPlayer
            local placeId = game.PlaceId
            local jobId = game.JobId
            TeleportService:TeleportToPlaceInstance(placeId, jobId, player)
        end
        rejoinserver()
    end
})

