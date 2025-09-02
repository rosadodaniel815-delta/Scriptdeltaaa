local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local TOGGLE_KEY = Enum.KeyCode.G
local GHOST_DURATION = 5 -- segundos
local COOLDOWN = 10 -- segundos

local isGhost = false
local canUseAbility = true

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not canUseAbility then return end
    
    if input.KeyCode == TOGGLE_KEY then
        activateGhostMode()
    end
end)

function activateGhostMode()
    canUseAbility = false
    isGhost = true
    
    -- Guardar estado original de colisiones
    local originalCollision = {}
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            originalCollision[part] = part.CanCollide
            part.CanCollide = false
            part.Transparency = 0.5 -- Hacer semi-transparente
        end
    end
    
    -- Mostrar efecto visual
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(173, 216, 230)
    highlight.OutlineColor = Color3.fromRGB(0, 191, 255)
    highlight.Parent = character
    
    -- Temporizador para regresar a normal
    wait(GHOST_DURATION)
    
    -- Restaurar estado original
    for part, canCollide in pairs(originalCollision) do
        if part and part.Parent then
            part.CanCollide = canCollide
            part.Transparency = 0
        end
    end
    
    if highlight then
        highlight:Destroy()
    end
    
    isGhost = false
    
    -- Cooldown
    wait(COOLDOWN)
    canUseAbility = true
    print("Habilidad de fantasma disponible nuevamente")
end
