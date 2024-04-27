--------------------------------------------------------------------------------
-- INITIALIZATION
--------------------------------------------------------------------------------
local wtChat
local valuedText = common.CreateValuedText()
local addonName = common.GetAddonName()

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

function Init()
    common.RegisterEventHandler(onUnitsChanged, 'EVENT_ACTIVE_MOUNT_CHANGED')
end
--------------------------------------------------------------------------------
--common.RegisterEventHandler(Init, "EVENT_AVATAR_CREATED")
--------------------------------------------------------------------------------
if avatar.IsExist() then
    Init()
end
--------------------------------------------------------------------------------
