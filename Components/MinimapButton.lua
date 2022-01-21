local PHT = LibStub("AceAddon-3.0"):GetAddon("PetHappinessTracker")
local minimapIcon = LibStub("LibDBIcon-1.0")

function PHT:CreateMinimapIcon()
    if not LibStub:GetLibrary("LibDataBroker-1.1", true) then return end
    local MinimapLDB = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("PetHappinessTracker", {
        type = "launcher",
        text = "Pet Happiness Tracker",
        icon = "Interface\\Icons\\ability_hunter_pet_ravager",
        OnClick = function(self, button)
            PHT:ToggleOptionsGUI()
        end,
        OnTooltipShow = function(tooltip)
            tooltip:AddLine("|cFFffffffPet Happiness Tracker|r")

            if 	attunelocal_brokerlabel ~= nil then
                tooltip:AddLine(" ")
                tooltip:AddLine("|cffffd100"..attunelocal_brokerlabel..":|r |cFFffffff"..attunelocal_brokervalue.."|r")
            end

            tooltip:AddLine(" ")
            tooltip:AddLine("|cffffd100Left click to|r Open settings", 0.2, 1, 0.2)
        end,
    })

    minimapIcon:Register("PHTMinimapIcon", MinimapLDB, nil)
end