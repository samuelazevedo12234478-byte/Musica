-- [[ REQUISITOS E CONFIGURAÇÃO INICIAL ]]
local Player = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Evitar duplicação da GUI se o script for executado novamente
if CoreGui:FindFirstChild("MusicPlayerGUI") then
    CoreGui:FindFirstChild("MusicPlayerGUI"):Destroy()
end

-- [[ CRIAÇÃO DA INTERFACE (GUI) ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MusicPlayerGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Janela Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 220)
MainFrame.Position = UDim2.new(0.5, -160, 0.4, -110)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Compatibilidade simples para arrastar no Mobile/PC
MainFrame.Parent = ScreenGui

-- Cantos Arredondados
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Título da GUI
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "🎵 Radio ID Player"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Caixa de Texto para o ID
local IDInput = Instance.new("TextBox")
IDInput.Size = UDim2.new(0.8, 0, 0, 40)
IDInput.Position = UDim2.new(0.1, 0, 0.25, 0)
IDInput.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
IDInput.PlaceholderText = "Digite o ID da Música aqui..."
IDInput.Text = ""
IDInput.TextColor3 = Color3.fromRGB(255, 255, 255)
IDInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
IDInput.TextSize = 14
IDInput.Font = Enum.Font.Gotham
IDInput.ClearTextOnFocus = false
IDInput.Parent = MainFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 8)
InputCorner.Parent = IDInput

-- Botão Play
local PlayButton = Instance.new("TextButton")
PlayButton.Size = UDim2.new(0.35, 0, 0, 40)
PlayButton.Position = UDim2.new(0.1, 0, 0.5, 0)
PlayButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
PlayButton.Text = "Tocar"
PlayButton.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayButton.TextSize = 16
PlayButton.Font = Enum.Font.GothamBold
PlayButton.Parent = MainFrame

local PlayCorner = Instance.new("UICorner")
PlayCorner.CornerRadius = UDim.new(0, 8)
PlayCorner.Parent = PlayButton

-- Botão Parar
local StopButton = Instance.new("TextButton")
StopButton.Size = UDim2.new(0.35, 0, 0, 40)
StopButton.Position = UDim2.new(0.55, 0, 0.5, 0)
StopButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
StopButton.Text = "Parar"
StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StopButton.TextSize = 16
StopButton.Font = Enum.Font.GothamBold
StopButton.Parent = MainFrame

local StopCorner = Instance.new("UICorner")
StopCorner.CornerRadius = UDim.new(0, 8)
StopCorner.Parent = StopButton

-- Controle de Volume (Recurso Extra)
local VolumeLabel = Instance.new("TextLabel")
VolumeLabel.Size = UDim2.new(1, 0, 0, 30)
VolumeLabel.Position = UDim2.new(0, 0, 0.75, 0)
VolumeLabel.BackgroundTransparency = 1
VolumeLabel.Text = "Volume: 0.5"
VolumeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
VolumeLabel.TextSize = 12
VolumeLabel.Font = Enum.Font.Gotham
VolumeLabel.Parent = MainFrame

-- Botão Fechar [X]
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = MainFrame

-- [[ LÓGICA DO SCRIPT ]]

local currentSound = nil

-- Função para gerenciar o som com segurança
local function manageSound()
    if currentSound then
        currentSound:Destroy()
    end
    
    -- Cria o som anexado ao personagem para efeito 3D (ou na câmera local se preferir)
    local targetParent = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") or workspace.CurrentCamera
    
    currentSound = Instance.new("Sound")
    currentSound.Volume = 0.5
    currentSound.Looped = true
    currentSound.Parent = targetParent
end

-- Evento do Botão Tocar
PlayButton.MouseButton1Click:Connect(function()
    local rawId = IDInput.Text
    -- Filtra apenas os números do texto inserido
    local cleanId = string.gsub(rawId, "%D", "")
    
    if cleanId ~= "" then
        manageSound()
        currentSound.SoundId = "rbxassetid://" .. cleanId
        currentSound:Play()
        Title.Text = "🎵 Tocando ID: " .. cleanId
    else
        Title.Text = "❌ ID Inválido!"
        task.wait(1.5)
        Title.Text = "🎵 Radio ID Player"
    end
end)

-- Evento do Botão Parar
StopButton.MouseButton1Click:Connect(function()
    if currentSound then
        currentSound:Stop()
        Title.Text = "🎵 Música Parada"
        task.wait(1.5)
        Title.Text = "🎵 Radio ID Player"
    end
end)

-- Sistema de Volume Prático (Clica no texto para alternar entre 0.2, 0.5, 0.8 e 1.0)
VolumeLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if currentSound then
            if currentSound.Volume == 0.5 then
                currentSound.Volume = 0.8
            elseif currentSound.Volume == 0.8 then
                currentSound.Volume = 1.0
            elseif currentSound.Volume == 1.0 then
                currentSound.Volume = 0.2
            else
                currentSound.Volume = 0.5
            end
            VolumeLabel.Text = "Volume: " .. tostring(currentSound.Volume)
        end
    end
end)

-- Evento do Botão Fechar
CloseButton.MouseButton1Click:Connect(function()
    if currentSound then
        currentSound:Destroy()
    end
    ScreenGui:Destroy()
end)
