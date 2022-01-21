local PHT = LibStub("AceAddon-3.0"):GetAddon("PetHappinessTracker")
local AceGUI = LibStub("AceGUI-3.0")
local SharedMedia = LibStub("LibSharedMedia-3.0")
local OptionsFrame
local AppearanceFrame

local function CreateOptionsFrame()
    OptionsFrame = AceGUI:Create("Frame", "PHT_Options_Frame")
    OptionsFrame:SetTitle("Pet Happiness Tracker")

    OptionsFrame:SetStatusText("Created by |cFFffffffCarls|r @ Gehennas (Twitch: CarlVonSweden)")
    
    OptionsFrame:SetHeight(400)
    OptionsFrame:SetWidth(600)
    OptionsFrame:EnableResize(false)
    OptionsFrame.frame:SetFrameStrata("HIGH")
    -- OptionsFrame:Hide()
end

local function CreateOptionsFrameHeading()
    local heading = AceGUI:Create("Heading")
    heading:SetText("Appearance")
    heading.width = "fill"
    OptionsFrame:AddChild(heading)
end

local function CreateFontFamilyDropdown()
    local FontFamilyDropdown = AceGUI:Create("Dropdown")
    FontFamilyDropdown:SetLabel("Font")

    -- List all the Shared Media fonts
    for k, v in pairs(SharedMedia:List("font")) do
        FontFamilyDropdown:AddItem(v, v)
    end

    -- Show default font
    FontFamilyDropdown:SetValue(PHTDB.Font.Handle)

    FontFamilyDropdown:SetCallback(
        "OnValueChanged",
        function(widget, event, value)
            PHTDB.Font.Handle = value
            PHTDB.Font.Path = SharedMedia:Fetch("font", value)
            PHT:UpdateStatusFrame()
        end
    )

    return FontFamilyDropdown
end

local function CreateFontSizeSlider()
    local FontSizeSlider = AceGUI:Create("Slider")
    FontSizeSlider:SetLabel("Size")
    FontSizeSlider:SetSliderValues(6, 64, 1)
    FontSizeSlider:SetValue(PHTDB.Font.Size)
    FontSizeSlider:SetCallback(
        "OnValueChanged",
        function(widget, event, value)
            PHTDB.Font.Size = value
            PHT:UpdateStatusFrame()
        end
    )

    return FontSizeSlider
end

local function CreateFontOutlineDropdown()
    local options = {
        ["Monochrome"] = "MONOCHROME",
        ["Monochrome Outline"] = "MONOCHROME, OUTLINE",
        ["Monochrome Thick Outline"] = "MONOCHROME, THICKOUTLINE",
        ["None"] = "",
        ["Outline"] = "OUTLINE",
        ["Thick Outline"] = "THICKOUTLINE"
    }

    FontOutlineDropdown = AceGUI:Create("Dropdown")
    FontOutlineDropdown:SetLabel("Outline")

    for k, v in pairs(options) do
        FontOutlineDropdown:AddItem(v, k)
    end

    FontOutlineDropdown:SetValue(PHTDB.Font.Outline)

    FontOutlineDropdown:SetCallback(
        "OnValueChanged",
        function(widget, event, value)
            PHTDB.Font.Outline = value
            PHT:UpdateStatusFrame()
        end
    )
    return FontOutlineDropdown
end

local function CreateFontColorPicker()
    local FontColorPicker = AceGUI:Create("ColorPicker")
    FontColorPicker:SetLabel("Color")
    FontColorPicker:SetHasAlpha(true)
    FontColorPicker:SetColor(
        PHTDB.Font.Color.r,
        PHTDB.Font.Color.g,
        PHTDB.Font.Color.b,
        PHTDB.Font.Color.a
    )

    FontColorPicker:SetCallback(
        "OnValueConfirmed",
        function(widget, event, r, g, b, a)
            PHTDB.Font.Color.r = r
            PHTDB.Font.Color.g = g
            PHTDB.Font.Color.b = b
            PHTDB.Font.Color.a = a
            r = string.format('%02x', r * 255)
            g = string.format('%02x', g * 255)
            b = string.format('%02x', b * 255)
            a = string.format('%02x', a * 255)
            print('|c'..a..r..g..b..'Hex: '..r..g..b..a..'|r')
            PHTDB.Font.Color.hex = (r..g..b):upper()
            PHT:UpdateStatusFrame()
        end
    )
    return FontColorPicker
end

local function CreateFontSettingsGroup()
    local FontGroup = AceGUI:Create("InlineGroup")
    FontGroup:SetLayout("flow")
    FontGroup:SetTitle("Font Settings")
    FontGroup.width = "fill"

    FontGroup:AddChild(CreateFontFamilyDropdown())
    FontGroup:AddChild(CreateFontSizeSlider())
    FontGroup:AddChild(CreateFontOutlineDropdown())
    FontGroup:AddChild(CreateFontColorPicker())
    OptionsFrame:AddChild(FontGroup)
end

local function CreateColorpicker()
    local picker = AceGUI:Create("ColorPicker")
    picker:SetLabel("Select font color")
    picker:Show()
    OptionsFrame:AddChild(picker)
end

function PHT:CreateOptionsGUI()
    -- Create the options parent frame
    CreateOptionsFrame()
    CreateOptionsFrameHeading()
    CreateFontSettingsGroup()
end

function PHT:ToggleOptionsGUI()
    OptionsFrame:Show()
end