local PHT = LibStub("AceAddon-3.0"):GetAddon("PetHappinessTracker")
local IdleTimer

local function AddPoints(amount)
    PHTCDB.Pet.HappinessPoints = math.min(
        1050,
        PHTCDB.Pet.HappinessPoints + amount
    )
    PHT:UpdateStatusFrame()
end

local function DeductPoints(amount)
    print("Deducting "..amount.." points")
    PHTCDB.Pet.HappinessPoints = math.max(
        0,
        PHTCDB.Pet.HappinessPoints - amount
    )
    PHT:UpdateStatusFrame()
end

local function SetMaxPoints()
    PHTCDB.Pet.HappinessPoints = 1050
    PHT:UpdateStatusFrame()
end

local function EnergizeEvent(amount)
    local validAmounts = {
        8,  -- Lowest possible
        10, -- Kibbler's bits
        17, -- Medium (low-level) food
        35  -- Maximum level food
    }
    for k, v in pairs(validAmounts) do
        if v == amount then 
            AddPoints(amount)
            return
        end
    end
    --[[
        If the above numbers aren't matched
        it means that the pet reached maximum
        happiness.
    --]]
    SetMaxPoints()
end

function PHT:CLEUEvent(
    timestamp,
    subevent,
    _,
    sourceGUID,
    sourceName,
    sourceFlags,
    sourceRaidFlags,
    destGUID,
    destName,
    destFlags,
    destRaidFlags,
    ...
)
    -- No need to run when pet isn't affected
    if not UnitExists("pet") or destGUID ~= UnitGUID("pet") then 
        return 
    end
    print(timestamp, subevent, _, sourceGUID, sourceName, destGUID, destName)
    -- Feeding events
    if (subevent == "SPELL_PERIODIC_ENERGIZE" or subevent == "SPELL_ENERGIZE") then
        local amount = select(4, ...)
        return EnergizeEvent(amount)
    end

    -- Pet death (Ignores Steam Tonk)
    if subevent == "UNIT_DIED" and destName ~= "Steam Tonk" then
        return DeductPoints(350)
    end

    -- Pet Dismiss
    if subevent == "SPELL_DRAIN" and sourceName == UnitName("player") then 
        return DeductPoints(50)
    end
end

function PHT:StartIdleTimer()
    IdleTimer = C_Timer.NewTicker(
        7.2,
        function()
            if not UnitExists("pet") then return end 
            DeductPoints(1)
        end
    )
end
