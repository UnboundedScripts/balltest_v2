-- A Welcome to the User 

print("--------------------")
print("Unbounded Scripts 🔛")
print("--------------------")

local Library = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))() --Load Fluent Library/s
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local HttpService = game:GetService("HttpService") --Define some required variables
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local http = game:GetService("HttpService")
local player = game.Players.LocalPlayer
local leaderstats = player:WaitForChild("leaderstats")
local wins = leaderstats:WaitForChild("Wins")
local previousValue = wins.Value or 0

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
    Farm = Window:AddTab({ Title = "Farm", Icon = "tractor" }),
    Teleports = Window:AddTab({ Title = "Teleports", Icon = "" }),
    Webhook = Window:AddTab({ Title = "Webhook", Icon = "webhook" }),
    Fun = Window:AddTab({Title = "Fun", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
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


--Function for the Webhook
local function SendMessageEMBED(url, embed)
    local response = request({
        Url = url,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = http:JSONEncode({
            embeds = {{
                title = embed.title,
                description = embed.description,
                color = embed.color,
                fields = embed.fields,
                footer = {text = embed.footer.text}
            }}
        })
    })
    print("The Webhook has been sent!")
end


--Add a input field for Webhook URL
local webhookUrl = ""
local Input = Tabs.Webhook:AddInput("Input", {
    Title = "Webhook URL",
    Description = "Enter your webhook URL ",
    Default = webhookUrl,
    Placeholder = "Enter Webhook URL",
    Numeric = false, --Only allow numbers
    Finished = true, --Only call callback when enter is pressed
    Callback = function(Value)
        webhookUrl = Value
        warn("The Webhook URL has be changed to:", webhookUrl)
    end
})

-- Add a button to the Webhook tab to send a test message
Tabs.Webhook:AddButton({
    Title = "Send Test Message",
    Description = "Sends a test message to the configured webhook",
    Callback = function()
        if webhookUrl ~= "" then
            SendMessageEMBED(webhookUrl, {
                title = "Test Message",
                description = "This is a test message from the ball test script!",
                color = 65280,
                fields = {},
                footer = {text = "If you can see this the connection is established!"}
            })
        else
            print("Webhook URL is not set.")
        end
    end
})


local Toggle = Tabs.Webhook:AddToggle("MyToggle", 
{
    Title = "Notify when new Win", 
    Description = "Sends a message to your webhook when you get a win",
    Default = false,
    Callback = function(state)
	if state then
	    -- Function to handle value changes
local function onWinsChanged(newValue)
    if newValue == previousValue + 1 then
        print("Wins increased by 1!")
        -- Send the webhook message
        if webhookUrl ~= "" then
            SendMessageEMBED(webhookUrl, {
                title = "Wins Update",
                description = "The wins have increased!",
                color = 65280,
                fields = {
                    {name = "Previous Wins", value = tostring(previousValue), inline = true},
                    {name = "Current Wins", value = tostring(newValue), inline = true}
                },
                footer = {text = "If you can see this, the connection is established!"}
            })
        end
    end
    -- Update the previous value
    previousValue = newValue
end

-- Connect the function to the Changed event
wins.Changed:Connect(onWinsChanged)
	else
	    print("Toggle Off")
        end
    end 
})