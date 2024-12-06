local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local camera = game.Workspace.CurrentCamera
local runService = game:GetService("RunService")

-- Redesigned GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0

local mainFrameCorner = Instance.new("UICorner", mainFrame)
mainFrameCorner.CornerRadius = UDim.new(0, 15)

-- Toggle Camera Lock Button
local toggleButton = Instance.new("TextButton", mainFrame)
toggleButton.Size = UDim2.new(0.9, 0, 0, 50)
toggleButton.Position = UDim2.new(0.05, 0, 0, 20)
toggleButton.Text = "Enable Camera Lock"
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 16

local toggleButtonCorner = Instance.new("UICorner", toggleButton)
toggleButtonCorner.CornerRadius = UDim.new(0, 10)

-- Toggle Team Check Button
local teamCheckButton = Instance.new("TextButton", mainFrame)
teamCheckButton.Size = UDim2.new(0.9, 0, 0, 50)
teamCheckButton.Position = UDim2.new(0.05, 0, 0, 80)
teamCheckButton.Text = "Enable Team Check"
teamCheckButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
teamCheckButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teamCheckButton.Font = Enum.Font.GothamBold
teamCheckButton.TextSize = 16

local teamCheckButtonCorner = Instance.new("UICorner", teamCheckButton)
teamCheckButtonCorner.CornerRadius = UDim.new(0, 10)

-- Whitelist Frame
local whitelistFrame = Instance.new("Frame", mainFrame)
whitelistFrame.Size = UDim2.new(0.9, 0, 0, 180)
whitelistFrame.Position = UDim2.new(0.05, 0, 0, 150)
whitelistFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local whitelistFrameCorner = Instance.new("UICorner", whitelistFrame)
whitelistFrameCorner.CornerRadius = UDim.new(0, 10)

local whitelistTextBox = Instance.new("TextBox", whitelistFrame)
whitelistTextBox.Size = UDim2.new(0.9, 0, 0, 30)
whitelistTextBox.Position = UDim2.new(0.05, 0, 0, 10)
whitelistTextBox.PlaceholderText = "Enter part of username or display name"
whitelistTextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
whitelistTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
whitelistTextBox.Font = Enum.Font.Gotham
whitelistTextBox.TextSize = 14

local whitelistTextBoxCorner = Instance.new("UICorner", whitelistTextBox)
whitelistTextBoxCorner.CornerRadius = UDim.new(0, 5)

local whitelistButton = Instance.new("TextButton", whitelistFrame)
whitelistButton.Size = UDim2.new(0.9, 0, 0, 30)
whitelistButton.Position = UDim2.new(0.05, 0, 0, 50)
whitelistButton.Text = "Add to Whitelist"
whitelistButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
whitelistButton.TextColor3 = Color3.fromRGB(255, 255, 255)
whitelistButton.Font = Enum.Font.GothamBold
whitelistButton.TextSize = 14

local whitelistButtonCorner = Instance.new("UICorner", whitelistButton)
whitelistButtonCorner.CornerRadius = UDim.new(0, 5)

local whitelistMessage = Instance.new("TextLabel", whitelistFrame)
whitelistMessage.Size = UDim2.new(0.9, 0, 0, 20)
whitelistMessage.Position = UDim2.new(0.05, 0, 0, 90)
whitelistMessage.Text = ""
whitelistMessage.BackgroundTransparency = 1
whitelistMessage.TextColor3 = Color3.fromRGB(255, 255, 255)
whitelistMessage.Font = Enum.Font.Gotham
whitelistMessage.TextSize = 14
whitelistMessage.TextXAlignment = Enum.TextXAlignment.Center

-- Scrolling Frame for Whitelist
local whitelistList = Instance.new("ScrollingFrame", whitelistFrame)
whitelistList.Size = UDim2.new(0.9, 0, 0, 60)
whitelistList.Position = UDim2.new(0.05, 0, 0, 120)
whitelistList.CanvasSize = UDim2.new(0, 0, 0, 0)
whitelistList.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
whitelistList.ScrollBarThickness = 6

local whitelistListCorner = Instance.new("UICorner", whitelistList)
whitelistListCorner.CornerRadius = UDim.new(0, 5)

-- Close Button
local closeButton = Instance.new("TextButton", mainFrame)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 10)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 16

local closeButtonCorner = Instance.new("UICorner", closeButton)
closeButtonCorner.CornerRadius = UDim.new(0, 5)

-- Variables
local cameraLockEnabled = false
local teamCheckEnabled = false
local whitelist = {}
local dragging = false
local dragInput, mousePos, framePos

-- Dragging Functionality
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
        local delta = input.Position - mousePos
        mainFrame.Position = UDim2.new(
            framePos.X.Scale,
            framePos.X.Offset + delta.X,
            framePos.Y.Scale,
            framePos.Y.Offset + delta.Y
        )
    end
end)

-- Update the Whitelist Display
local function updateWhitelistList()
    for _, child in pairs(whitelistList:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    local yPos = 0
    for playerName in pairs(whitelist) do
        local itemFrame = Instance.new("Frame", whitelistList)
        itemFrame.Size = UDim2.new(1, 0, 0, 25)
        itemFrame.Position = UDim2.new(0, 0, 0, yPos)
        itemFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)

        local itemLabel = Instance.new("TextLabel", itemFrame)
        itemLabel.Size = UDim2.new(0.7, 0, 1, 0)
        itemLabel.Position = UDim2.new(0, 5, 0, 0)
        itemLabel.Text = playerName
        itemLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        itemLabel.Font = Enum.Font.Gotham
        itemLabel.TextSize = 14
        itemLabel.BackgroundTransparency = 1
        itemLabel.TextXAlignment = Enum.TextXAlignment.Left

        local removeButton = Instance.new("TextButton", itemFrame)
        removeButton.Size = UDim2.new(0.2, 0, 0.8, 0)
        removeButton.Position = UDim2.new(0.75, 0, 0.1, 0)
        removeButton.Text = "X"
        removeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        removeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        removeButton.Font = Enum.Font.GothamBold
        removeButton.TextSize = 14

        removeButton.MouseButton1Click:Connect(function()
            whitelist[playerName] = nil
            updateWhitelistList()
        end)

        yPos = yPos + 30
    end

    whitelistList.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

-- Add Player to Whitelist (Partial Matches Allowed)
whitelistButton.MouseButton1Click:Connect(function()
    local input = whitelistTextBox.Text:lower()
    local foundPlayer = false

    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        local username = otherPlayer.Name:lower()
        local displayName = otherPlayer.DisplayName:lower()

        if username:find(input) or displayName:find(input) then
            whitelist[otherPlayer.Name] = true
            whitelistMessage.Text = "Added " .. otherPlayer.Name .. " to whitelist."
            foundPlayer = true
            break
        end
    end

    if not foundPlayer then
        whitelistMessage.Text = "Player not found. Try again."
    end

    whitelistTextBox.Text = ""
    updateWhitelistList()
end)

-- Close GUI
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Toggle Camera Lock
toggleButton.MouseButton1Click:Connect(function()
    cameraLockEnabled = not cameraLockEnabled
    toggleButton.Text = cameraLockEnabled and "Disable Camera Lock" or "Enable Camera Lock"
    toggleButton.BackgroundColor3 = cameraLockEnabled and Color3.fromRGB(170, 0, 0) or Color3.fromRGB(0, 170, 0)
end)

-- Toggle Team Check
teamCheckButton.MouseButton1Click:Connect(function()
    teamCheckEnabled = not teamCheckEnabled
    teamCheckButton.Text = teamCheckEnabled and "Disable Team Check" or "Enable Team Check"
    teamCheckButton.BackgroundColor3 = teamCheckEnabled and Color3.fromRGB(170, 0, 0) or Color3.fromRGB(0, 170, 0)
end)

-- Camera Lock Logic
local function getNearestPlayer()
    local nearestPlayer = nil
    local shortestDistance = math.huge
    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if (not teamCheckEnabled or (teamCheckEnabled and otherPlayer.Team ~= player.Team)) and (not whitelist[otherPlayer.Name]) then
                local distance = (player.Character.HumanoidRootPart.Position - otherPlayer.Character.HumanoidRootPart.Position).Magnitude
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

mouse.Button2Down:Connect(function()
    if cameraLockEnabled then
        local targetPlayer = getWhitelistedPlayer() or getNearestPlayer()
        if targetPlayer then
            camera.CameraType = Enum.CameraType.Scriptable
            camera.CFrame = CFrame.new(camera.CFrame.Position, targetPlayer.Character.HumanoidRootPart.Position)
        end
    end
end)

mouse.Button2Up:Connect(function()
    if cameraLockEnabled then
        camera.CameraType = Enum.CameraType.Custom
    end
end)

runService.RenderStepped:Connect(function()
    if cameraLockEnabled then
        local targetPlayer = getWhitelistedPlayer() or getNearestPlayer()
        if camera.CameraType == Enum.CameraType.Scriptable and targetPlayer then
            camera.CFrame = CFrame.new(player.Character.Head.Position, targetPlayer.Character.HumanoidRootPart.Position)
        end
    end
end)
