local VulnerabilityProtectionBuff = userMods.ToWString 'Пиролиз'
local wtChat
local valuedText = common.CreateValuedText()
local addonName = common.GetAddonName()
local dndOn = false
local OpenConfigButton
local Panel
local ButtonMain

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
        valuedText:SetClassVal("color", "LogColorYellow")
        valuedText:SetVal("text", text)
        valuedText:SetVal("addonName", userMods.ToWString("СС: "))
        wtChat:PushFrontValuedText(valuedText)
    end
end
local function PrepareTextures()
    ButtonMain = mainForm:GetChildUnchecked("Button", false)

    ButtonMain:Show(false)
end

local function SetConfigButton()
    ButtonMain:Show(true)

    DnD.Init(ButtonMain, nil, true)
    --
    --common.RegisterReactionHandler(OnClickButton, 'EVENT_ON_CONFIG_BUTTON_CLICK')
    --common.RegisterReactionHandler(OnRightClickButton, 'EVENT_ON_CONFIG_BUTTON_RIGHT_CLICK')
    --
    --common.RegisterEventHandler(OnAoPanelStart, 'AOPANEL_START')
end --



local function isEnemyPlayer(unitId)
  return object.IsEnemy(unitId) -- and  object.IsUnit(unitId) and unit.IsPlayer(unitId)
end
--------------------------------------------------------------------------------
local function onObjectBuffAdded(p)
    local BuffAddedInfo = object.GetBuffInfo(p.buffId)
    local BuffTimer = BuffAddedInfo.durationMs
    local TargetName = object.GetName(p.objectId)
    LogToChat('get timer and name')
  -- баф появился
end
--------------------------------------------------------------------------------
local function onEnemyPlayerSpawned(unitId)
  common.RegisterEventHandler(onObjectBuffAdded, 'EVENT_OBJECT_BUFF_ADDED', {
    objectId = unitId, -- buffName = VulnerabilityProtectionBuff
  })
end

local function onEnemyPlayerDespawned(unitId)
  common.UnRegisterEventHandler(onObjectBuffAdded, 'EVENT_OBJECT_BUFF_ADDED', {
    objectId = unitId, buffName = VulnerabilityProtectionBuff
  })
end
--------------------------------------------------------------------------------
local trackedUnits = {}

local function onUnitsChanged(p)
  for _, unitId in pairs(p.despawned) do
    if trackedUnits[unitId] then
      trackedUnits[unitId] = nil
      onEnemyPlayerDespawned(unitId)
    end
  end
  for _, unitId in pairs(p.spawned) do
    if not trackedUnits[unitId] and isEnemyPlayer(unitId) then
      trackedUnits[unitId] = true
      onEnemyPlayerSpawned(unitId)
    end
  end
end

local function Init()
  mainForm:Show(true)
  PrepareTextures()
  SetConfigButton()
  local units = avatar.IsExist() and avatar.GetUnitList()
  if units then
    for _, unitId in pairs(units) do
      if isEnemyPlayer(unitId) then
        trackedUnits[unitId] = true
        onEnemyPlayerSpawned(unitId)
      end
    end
  end
  common.RegisterEventHandler(onUnitsChanged, 'EVENT_UNITS_CHANGED')
end

Init()