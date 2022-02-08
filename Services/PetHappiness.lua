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

--[[
    
--]]
local function EnergizeEvent(amount)
    local validAmounts = {8, 10, 17, 35}
    for k, v in pairs(validAmounts) do
        if v == amount then 
            return AddPoints(amount)
        end
    end
    return SetMaxPoints()
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
    -- print(timestamp, subevent, _, sourceGUID, sourceName, destGUID, destName)
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

function PHT:HappinessEvent()
    -- Happiness value 1-3 (1 = Unhappy, 2 = Content, 3 = Happy)
    local happiness = GetPetHappiness()
    local happinessPoints = ({0, 350, 750})[happiness]

    -- Logic for when HappinessLevel is increased
    if happiness > PHTCDB.Pet.HappinessLevel then
        PHTCDB.Pet.HappinessLevel = happiness
        if PHTCDB.Benchmark.LatestMax ~= nil then
            PHTCDB.Benchmark.LatestMin = time()
            print(PHTCDB.Benchmark.LatestMax - PHTCDB.Benchmark.LatestMin)
        end

        -- Assuming the UNIT_HAPPINESS event fires within
        -- a feeding-tick we can assume that the offset 
        -- between happinessPoints and minimum-happiness
        -- cant be greater than 35.
        if PHTCDB.Pet.HappinessPoints > (happinessPoints + 35) then
            PHTCDB.Pet.HappinessPoints = happinessPoints
        end
    end

    -- Logic for when HappinessLevel is decreased
    if happiness < PHTCDB.Pet.HappinessLevel then
        PHTCDB.Pet.HappinessLevel = happiness

        -- Also assuming that UNIT_HAPPINESS should fire
        -- after the CLEU event that would allow us to
        -- detect things such as Death and/or Dismissal.
        -- We can assume that current happinessPoints should
        -- NOT be higher than minumum + 349.
        if PHTCDB.Pet.HappinessPoints > (happinessPoints + 349) then
            PHTCDB.Pet.HappinessPoints = happinessPoints + 349
        end
    end
end

function PHT:StartIdleTimer()
    IdleTimer = C_Timer.NewTicker(
        7.2,
        function()
            if not UnitExists("pet") then return end
            -- Start benchmark:
            if PHTCDB.Pet.HappinessPoints == 1050 then
                print("Setting benchmark to: ".. time())
                PHTCDB.Benchmark = {}
                PHTCDB.Benchmark.LatestMax = time()
            end

            DeductPoints(1)
        end
    )
end
