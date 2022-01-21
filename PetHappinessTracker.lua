--[[
    Local vars
--]]
local PHT = LibStub("AceAddon-3.0"):NewAddon("PetHappinessTracker")
local SharedMedia = LibStub("LibSharedMedia-3.0")
local frames = {}
local localizedClass, englishClass, classIndex = UnitClass("player")

--[[
    Addon init
--]]
function PHT:OnInitialize()
    if classIndex ~= 3 then
       return -- No need to init further for non-hunters.
    end
    PHTDB = PHTDB_DEFAULTS
    PHTCDB = PHTCDB_DEFAULTS
end

function PHT:OnEnable()
    PHT:CreateOptionsGUI()
    PHT:CreateMinimapIcon()
    PHT:CreateStatusFrame()
    PHT:StartIdleTimer()
end
