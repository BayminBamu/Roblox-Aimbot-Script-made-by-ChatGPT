local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local camera = game.Workspace.CurrentCamera
local runService = game:GetService("RunService")

-- Create GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 250, 0, 300)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)

local toggleButton = Instance.new("TextButton", mainFrame)
toggleButton.Size = UDim2.new(0, 200, 0, 50)
toggleButton.Position = UDim2.new(0.5, -100, 0, 10)
toggleButton.Text = "Enable Camera Lock"
toggleButton.BackgroundColor3 = Color3.new(0, 1, 0)

local teamCheckButton = Instance.new("TextButton", mainFrame)
teamCheckButton.Size = UDim2.new(0, 200, 0, 50)
teamCheckButton.Position = UDim2.new(0.5, -100, 0, 70)
teamCheckButton.Text = "Enable Team Check"
teamCheckButton.BackgroundColor3 = Color3.new(0, 1, 0)

local whitelistFrame = Instance.new("Frame", mainFrame)
whitelistFrame.Size = UDim2.new(0, 200, 0, 200)
whitelistFrame.Position = UDim2.new(0.5, -100, 0, 130)
whitelistFrame.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)

local whitelistTextBox = Instance.new("TextBox", whitelistFrame)
whitelistTextBox.Size = UDim2.new(1, 0, 0.2, 0)
whitelistTextBox.Position = UDim2.new(0, 0, 0, 0)
whitelistTextBox.PlaceholderText = "Enter player name"

local whitelistButton = Instance.new("TextButton", whitelistFrame)
whitelistButton.Size = UDim2.new(1, 0, 0.2, 0)
whitelistButton.Position = UDim2.new(0, 0, 0.2, 0)
whitelistButton.Text = "Add to Whitelist"
whitelistButton.BackgroundColor3 = Color3.new(0, 1, 0)

local whitelistMessage = Instance.new("TextLabel", whitelistFrame)
whitelistMessage.Size = UDim2.new(1, 0, 0.2, 0)
whitelistMessage.Position = UDim2.new(0, 0, 0.4, 0)
whitelistMessage.Text = ""
whitelistMessage.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)

local whitelistList = Instance.new("ScrollingFrame", whitelistFrame)
whitelistList.Size = UDim2.new(1, 0, 0.4, 0)
whitelistList.Position = UDim2.new(0, 0, 0.6, 0)
whitelistList.CanvasSize = UDim2.new(0, 0, 0, 0)
whitelistList.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)

local closeButton = Instance.new("TextButton", mainFrame)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 10)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.new(1, 0, 0)

local cameraLockEnabled = false
local teamCheckEnabled = false
local whitelist = {}

local dragging = false
local dragInput, mousePos, framePos

local function updateWhitelistList()
    whitelistList:ClearAllChildren()
    local yPos = 0
    for playerName, _ in pairs(whitelist) do
        local playerLabel = Instance.new("TextButton", whitelistList)
        playerLabel.Size = UDim2.new(1, 0, 0, 30)
        playerLabel.Position = UDim2.new(0, 0, 0, yPos)
        playerLabel.Text = playerName
        playerLabel.BackgroundColor3 = Color3.new(1, 1, 1)
        playerLabel.MouseButton1Click:Connect(function()
            whitelist[playerName] = nil
            updateWhitelistList()
        end)
        yPos = yPos + 30
    end
    whitelistList.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

local function getNearestPlayer()
    local nearestPlayer = nil
    local shortestDistance = math.huge

    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if (not teamCheckEnabled or (teamCheckEnabled and otherPlayer.Team ~= player.Team)) and (not whitelist[otherPlayer.Name]) then
                local distance = (player.Character.HumanoidRootPart.Position - otherPlayer.Character.HumanoidRootPart.Position).magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestPlayer = otherPlayer
                end
            end
        end
    end

    return nearestPlayer
end

local function getWhitelistedPlayer()
    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if whitelist[otherPlayer.Name] and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            return otherPlayer
        end
    end
    return nil
end

local function onRightMouseButtonDown()
    if cameraLockEnabled then
        local targetPlayer = getWhitelistedPlayer() or getNearestPlayer()
        if targetPlayer then
            camera.CameraType = Enum.CameraType.Scriptable
            camera.CFrame = CFrame.new(camera.CFrame.Position, targetPlayer.Character.HumanoidRootPart.Position)
        end
    end
end

local function onRightMouseButtonUp()
    if cameraLockEnabled then
        camera.CameraType = Enum.CameraType.Custom
    end
end

mouse.Button2Down:Connect(onRightMouseButtonDown)
mouse.Button2Up:Connect(onRightMouseButtonUp)

runService.RenderStepped:Connect(function()
    if cameraLockEnabled then
        local targetPlayer = getWhitelistedPlayer() or getNearestPlayer()
        if camera.CameraType == Enum.CameraType.Scriptable and targetPlayer then
            camera.CFrame = CFrame.new(player.Character.Head.Position, targetPlayer.Character.HumanoidRootPart.Position)
        end
    end
end)

toggleButton.MouseButton1Click:Connect(function()
    cameraLockEnabled = not cameraLockEnabled
    if cameraLockEnabled then
        toggleButton.Text = "Disable Camera Lock"
        toggleButton.BackgroundColor3 = Color3.new(1, 0, 0)
    else
        toggleButton.Text = "Enable Camera Lock"
        toggleButton.BackgroundColor3 = Color3.new(0, 1, 0)
    end
end)

teamCheckButton.MouseButton1Click:Connect(function()
    teamCheckEnabled = not teamCheckEnabled
    if teamCheckEnabled then
        teamCheckButton.Text = "Disable Team Check"
        teamCheckButton.BackgroundColor3 = Color3.new(1, 0, 0)
    else
        teamCheckButton.Text = "Enable Team Check"
        teamCheckButton.BackgroundColor3 = Color3.new(0, 1, 0)
    end
end)

whitelistButton.MouseButton1Click:Connect(function()
    local partialName = whitelistTextBox.Text:lower()
    local foundPlayer = false
    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer.Name:lower():find(partialName) or otherPlayer.DisplayName:lower():find(partialName) then
            whitelist[otherPlayer.Name] = true
            whitelistMessage.Text = "Player Found. Added to whitelist."
            foundPlayer = true
            break
        end
    end
    if not foundPlayer then
        whitelistMessage.Text = "Player not found. Please type again."
    end
    whitelistTextBox.Text = ""
    updateWhitelistList()
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    script:Destroy()
end)

-- Dragging functionality
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

function updateInput(input)
    local delta = input.Position - mousePos
    mainFrame.Position = UDim2.new(
        framePos.X.Scale,
        framePos.X.Offset + delta.X,
        framePos.Y.Scale,
        framePos.Y.Offset + delta.Y
    )
end
