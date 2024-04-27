--------------------------------------------------------------------------------
-- INITIALIZATION
--------------------------------------------------------------------------------
local Armor = userMods.ToWString '���������� �����'
local wtChat
local valuedText = common.CreateValuedText()
local addonName = common.GetAddonName()
local ArmoreRepaireText
local ArmoreRepaireText = mainForm:GetChildUnchecked("RepairText", false)

local function LogToChat(text)
  if not wtChat then
      wtChat = stateMainForm:GetChildUnchecked("ChatLog", false)
      wtChat = wtChat:GetChildUnchecked("Container", true)
      local formatVT = "<html fontname='AllodsFantasy' fontsize='14' shadow='1'><rs class='color'><r name='addonName'/><r name='text'/></rs></html>"
      valuedText:SetFormat(userMods.ToWString(formatVT))
  end

  if wtChat and wtChat.PushFrontValuedText then
      if not common.IsWString(text) then
          text = userMods.ToWString(text)
      end

      valuedText:ClearValues()
      valuedText:SetClassVal("color", "LogColorRed")
      valuedText:SetVal("text", text)
      valuedText:SetVal("addonName", userMods.ToWString("123: "))
      wtChat:PushFrontValuedText(valuedText)
  end
end

function MountRide(p)
    if p.unitId == avatar.GetId() then
        local activeId = mount.GetActive()
            if activeId then
            local mountInfo = mount.GetInfo( activeId )
                if mountInfo then
                    if  Armor == mountInfo.name then
                        if mountInfo.currentLevelStats.health/2 > p.health then
                          ArmoreRepaireText:Show(true)
                        end
                        if mountInfo.currentLevelStats.health/2 < p.health then
                          ArmoreRepaireText:Show(false)
                        end
                    end
                end
        end
    end
end

function Mount(s)
  ArmoreRepaireText:Show(false)
end
function Init()
    mainForm:Show(true)
    common.RegisterEventHandler(MountRide, 'EVENT_UNIT_MOUNT_HEALTH_CHANGED')
    common.RegisterEventHandler(Mount, 'EVENT_ACTIVE_MOUNT_CHANGED')
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
if avatar.IsExist() then
    Init()
end
--------------------------------------------------------------------------------
