--[[
    Local vars
--]]
local PHT = LibStub("AceAddon-3.0"):NewAddon("PetHappinessTracker")
local SharedMedia = LibStub("LibSharedMedia-3.0")
local localizedClass, englishClass, classIndex = UnitClass("player")

--[[
    Addon init
--]]
function PHT:OnInitialize()
    PHTDB = PHTDB_DEFAULTS

    if classIndex ~= 3 then return end
    -- Hunter specific initialization
    PHTCDB = PHTCDB_DEFAULTS
end

function PHT:OnEnable()
    PHT:CreateOptionsGUI()
    PHT:CreateMinimapIcon()

    if classIndex ~= 3 then return end
    -- The following only runs if the player is hunter
    PHT:CreateStatusFrame()
    PHT:StartIdleTimer()
end
