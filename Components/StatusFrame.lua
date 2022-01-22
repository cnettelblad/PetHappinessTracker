local PHT = LibStub("AceAddon-3.0"):GetAddon("PetHappinessTracker")
local AceGUI = LibStub("AceGUI-3.0")
local SharedMedia = LibStub("LibSharedMedia-3.0")
local StatusFrame

function PHT:CreateStatusFrame()
    StatusFrame = CreateFrame("Frame", "PetStatusFrame", PetFrame)
    StatusFrame:SetWidth(1)
    StatusFrame:SetHeight(1)
    StatusFrame:SetPoint("CENTER", 0, -50)
    for k,v in pairs(PHTDB) do
        print(k, v)
    end
    StatusFrame.text = StatusFrame:CreateFontString(nil, "ARTWORK", nil)
    StatusFrame.text:SetFont(
        PHTDB.Font.Path or SharedMedia:Fetch("font", PHTDB.Font.Handle),
        PHTDB.Font.Size,
        PHTDB.Font.Outline
    )
    StatusFrame.text:SetTextColor(
        PHTDB.Font.Color.r,
        PHTDB.Font.Color.g,
        PHTDB.Font.Color.b,
        PHTDB.Font.Color.a
    )
    StatusFrame.text:SetPoint("CENTER", 0, 0)
    StatusFrame.text:SetText(PHTCDB.Pet.HappinessPoints)
    -- StatusFrame:SetParent(PetFrame)
    StatusFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    StatusFrame:RegisterEvent("UNIT_HAPPINESS")

    StatusFrame:SetScript(
        "OnEvent",
        function(self, event)
            if event == "UNIT_HAPPINESS" then
                PHT:HappinessEvent()
            end
            PHT:CLEUEvent(CombatLogGetCurrentEventInfo())
        end
    )
end

function PHT:UpdateStatusFrame()
    -- print(PHTDB.Font.Path, PHTDB.Font.Size, PHTDB.Font.Outline)
    StatusFrame.text:SetFont(
        PHTDB.Font.Path or SharedMedia:Fetch("font", PHTDB.Font.Handle),
        PHTDB.Font.Size,
        PHTDB.Font.Outline
    )
    StatusFrame.text:SetTextColor(
        PHTDB.Font.Color.r,
        PHTDB.Font.Color.g,
        PHTDB.Font.Color.b,
        PHTDB.Font.Color.a
    )
    StatusFrame.text:SetText(PHTCDB.Pet.HappinessPoints)
end