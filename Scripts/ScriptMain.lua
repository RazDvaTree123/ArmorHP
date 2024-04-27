--------------------------------------------------------------------------------
-- INITIALIZATION
--------------------------------------------------------------------------------
local Armor = userMods.ToWString 'Адаптивная броня'
local wtChat
local valuedText = common.CreateValuedText()
local addonName = common.GetAddonName()
local ArmoreRepaireText = mainForm:GetChildUnchecked("ArmorRepairText", false)
local ArmoreText = ArmoreRepaireText:GetChildUnchecked("RepairText", false)
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
function ArmorCurrentHP(t)
    if t.unitId == avatar.GetId() then
    LogToChat('точка два')
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
                            LogToChat('точка один')
                        end
                    end
                end
        end
    end
end

function Init()
    mainForm:Show(true)
    common.RegisterEventHandler(MountRide, 'EVENT_UNIT_MOUNT_HEALTH_CHANGED')
    ArmoreText:Show(true)
end
--------------------------------------------------------------------------------
--common.RegisterEventHandler(Init, "EVENT_AVATAR_CREATED")
--------------------------------------------------------------------------------
if avatar.IsExist() then
    Init()
end
--------------------------------------------------------------------------------
