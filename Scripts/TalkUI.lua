local betterUIMod = GameMain:GetMod("CanVox.BetterUI");
local jianghuMgr = GameMain:GetMod("JianghuMgr")

betterUIMod.TalkUI = betterUIMod.TalkUI or {}
local TalkUI = betterUIMod.TalkUI

function OnShowTalkUI(context)
    
end

function TalkUI:RemoveByName(baseUI, name)
    local child = baseUI:GetChild(name)
    if child then
        baseUI:RemoveChild(child)
    end
end

function TalkUI:BaseItem(itemList)
    local storyPane = itemList:AddItemFromPool()
    storyPane.data5 = nil
    storyPane.m_expandButton.visible = false 
    storyPane.m_n26.visible = false
    storyPane.m_title.x = storyPane.m_title.x - 30
    return storyPane
end

function TalkUI:AddMysteryItem(itemList)
    local storyPane = self:BaseItem(itemList)
    storyPane.title = XT("隐秘")
    storyPane.m_Mode.selectedIndex = 3
    storyPane.m_n21:RemoveChildrenToPool()
    storyPane.m_n21.x = storyPane.m_n21.x - 15

    self.mysteries = {
        list = {},
        map = {},
    }

    for i=1,3 do 
        local mysteryItem = storyPane.m_n21:AddItemFromPool()
        mysteryItem.title = "???"
        mysteryItem.data5 = nil
        mysteryItem.name = "canvox.mystery"..i

        self.mysteries.list[i] = mysteryItem
        self.mysteries.map[mysteryItem.name] = i
    end

    return storyPane
end

function TalkUI:AddTracesItem(itemList)
    local storyPane = self:BaseItem(itemList)
    storyPane.title = XT("行踪")
    storyPane.m_Mode.selectedIndex = 4
    storyPane.m_n22.text = "???"
    storyPane.m_n22.data5 = nil
    storyPane.m_n22.x = storyPane.m_n22.x - 15
    storyPane.m_n22.name = "canvox.traces"
    self.traces = storyPane.m_n22

    return storyPane
end

function TalkUI:AddPersonalityItem(itemList)
    local storyPane = self:BaseItem(itemList)
    storyPane.title = XT("性格")
    storyPane.m_Mode.selectedIndex = 4
    storyPane.m_n22.text = "???"
    storyPane.m_n22.data5 = nil 
    storyPane.m_n22.x = storyPane.m_n22.x - 15
    storyPane.m_n22.name = "canvox.personality"
    self.personality = storyPane.m_n22
    
    return storyPane
end

function TalkUI:AddWeaknessItem(itemList)
    local storyPane = self:BaseItem(itemList)
    storyPane.title = XT("弱点")
    storyPane.m_Mode.selectedIndex = 3
    storyPane.m_n21:RemoveChildrenToPool()
    storyPane.m_n21.x = storyPane.m_n21.x - 15
    storyPane.m_n21.y = storyPane.m_n21.y - 2
    self.weaknesses = {
        list = {},
        map = {},
    }
    
    for i=1,3 do 
        local weakness = storyPane.m_n21:AddItemFromPool()
        weakness.title = "???"
        weakness.data5 = nil
        weakness.name = "canvox.weakness"..i 

        self.weaknesses.list[i] = weakness 
        self.weaknesses.map[weakness.name] = i
    end

    return storyPane
end

function TalkUI:AddSecretKnowledgeItem(itemList)
    local storyPane = self:BaseItem(itemList)
    storyPane.title = XT("绝学")
    storyPane.m_Mode.selectedIndex = 4
    storyPane.m_n22.text = "???"
    storyPane.m_n22.data5 = nil 
    storyPane.m_n22.x = storyPane.m_n22.x - 15 
    storyPane.m_n22.name = "canvox.esoterica"

    self.esoterica = storyPane.m_n22

    return storyPane
end

function TalkUI:AddFavoritesItem(itemList)
    local storyPane = self:BaseItem(itemList)
    storyPane.title = XT("心仪之物")
    storyPane.data5 = nil
    storyPane.m_Mode.selectedIndex = 2
    storyPane.m_n20:RemoveChildrenToPool()
    storyPane.m_n20.x = storyPane.m_n20.x - 15

    self.favorites = {
        list = {},
        map = {},
    }

    for i=1,4 do 
        local favorite = storyPane.m_n20:AddItemFromPool()
        favorite.tooltips = "???"
        favorite.icon = "res/sprs/ui/icon_what"

        favorite.m_icon.color = CS.UnityEngine.Color(1, 1, 1, 1)
        favorite:SetSize(25, 30)

        favorite.data5 = nil
        favorite.name = "canvox.favorite"..i

        self.favorites.list[i] = favorite 
        self.favorites.map[favorite.name] = i 
    end

    return storyPane
end

function TalkUI:AddHatesItem(itemList)
    local storyPane = self:BaseItem(itemList)
    storyPane.title = XT("厌恶之物")
    storyPane.data5 = nil
    storyPane.m_Mode.selectedIndex = 2
    storyPane.m_n20:RemoveChildrenToPool()
    storyPane.m_n20.x = storyPane.m_n20.x - 15

    self.hates = {
        list = {},
        map = {},
    }

    for i=1,4 do 
        local hate = storyPane.m_n20:AddItemFromPool()
        hate.tooltips = "???"
        hate.icon = "res/sprs/ui/icon_what"

        hate.m_icon.color = CS.UnityEngine.Color(1, 1, 1, 1)
        hate:SetSize(25, 30)

        hate.data5 = nil
        hate.name = "canvox.hate"..i 

        self.hates.list[i] = hate 
        self.hates.map[hate.name] = i
    end

    return storyPane
end

function TalkUI:AddTreasuresItem(itemList)
    local storyPane = self:BaseItem(itemList)
    storyPane.title = XT("随身宝物")
    storyPane.data5 = nil
    storyPane.m_Mode.selectedIndex = 2
    storyPane.m_n20:RemoveChildrenToPool()
    storyPane.m_n20.x = storyPane.m_n20.x - 15

    self.treasures = {
        list = {},
        map = {},
    }

    for i=1,5 do 
        local treasure = storyPane.m_n20:AddItemFromPool()
        treasure.tooltips = "???"
        treasure.icon = "res/sprs/ui/icon_what"

        treasure.m_icon.color = CS.UnityEngine.Color(1, 1, 1, 1)
        treasure:SetSize(25, 30)

        treasure.data5 = nil
        treasure.name = "canvox.treasure"..i 

        self.treasures.list[i] = treasure 
        self.treasures.map[treasure.name] = i 
    end

    return storyPane
end

function TalkUI:MarkUp(baseUI)
    local bodyAbilitiesFrame = UIPackage.CreateObjectFromURL("ui://0xrxw6g7abgt52ow4m");

    --Attach a frame for secrets to the left side of the UI
    local secretsFrame = bodyAbilitiesFrame:GetChild("n90")
    secretsFrame:SetSize(210, 315)
    secretsFrame.x = -200
    secretsFrame.y = -7
    secretsFrame.name = "secretsFrameBG"
    self:RemoveByName(baseUI, "secretsFrameBG")

    local topLoop = bodyAbilitiesFrame:GetChild("n91")
    topLoop.x = -10
    topLoop.y = 45
    topLoop.name = "secretsFrameTopLoop"
    self:RemoveByName(baseUI, "secretsFrameTopLoop")

    local bottomLoop = bodyAbilitiesFrame:GetChild("n92")
    bottomLoop.x = -10
    bottomLoop.y = 235
    bottomLoop.name = "secretsFrameBottomLoop"
    self:RemoveByName(baseUI, "secretsFrameBottomLoop")

    local secretsNamePlate = bodyAbilitiesFrame:GetChild("n93")
    secretsNamePlate.x = -160
    secretsNamePlate.y = 15
    secretsNamePlate.name = "secretsFrameTitle"
    self:RemoveByName(baseUI, "secretsFrameTitle")

    local secretsTitle = secretsNamePlate:GetChild("title")
    secretsTitle.text = "Held Secrets"

    -- Add Unknown: ### label and list of known secrets
    local unknownSecretCount = UIPackage.CreateObjectFromURL("ui://0xrxw6g7nd594l")
    unknownSecretCount.x = -160
    unknownSecretCount.y = 40
    unknownSecretCount:SetSize(145, 30)
    unknownSecretCount.text = "Unknown: 7"
    unknownSecretCount.name = "unknownSecretCount"
    self:RemoveByName(baseUI, "unknownSecretCount")

    local unknownSecretFormat = unknownSecretCount:GetTextField().textFormat
    unknownSecretFormat.italic = true
    unknownSecretFormat.bold = true 
    unknownSecretFormat.size = 16
    unknownSecretFormat.color = CS.UnityEngine.Color(0.5,0.5,0.5,1)
    unknownSecretCount:GetTextField().textFormat = unknownSecretFormat

    local cusList = UIPackage.CreateObjectFromURL("ui://0xrxw6g7m8j0ovnz")
    
    local secretList = cusList:GetChild("list")
    secretList.defaultItem = "ui://0xrxw6g7gebq2l"
    secretList.x = -180
    secretList.y = 60
    secretList.name = "secretList"
    self:RemoveByName(baseUI, "secretList")
    secretList:SetSize(165, 230)

    for i=0,100 do
        local otherItem = secretList:AddItemFromPool()
        otherItem:SetSize(90, 18)
        local itemTitle = otherItem:GetChild("title")
        itemTitle.text = "Personality: Huo Sun"
        itemTitle:SetSize(90, 18)
        itemTitle.x = itemTitle.x + 5
    end

    local personalCusList = UIPackage.CreateObjectFromURL("ui://0xrxw6g7m8j0ovnz").m_list
    personalCusList.x = 40
    personalCusList.y = 308
    personalCusList.defaultItem = "ui://0xrxw6g7kzxt2ovu7"
    personalCusList:SetSize(250, 140)

    self:AddMysteryItem(personalCusList)
    self:AddTracesItem(personalCusList)
    self:AddWeaknessItem(personalCusList)
    self:AddTreasuresItem(personalCusList)

    local personalCusList2 = UIPackage.CreateObjectFromURL("ui://0xrxw6g7m8j0ovnz").m_list
    personalCusList2.x = 275
    personalCusList2.y = 308
    personalCusList2.defaultItem = "ui://0xrxw6g7kzxt2ovu7"
    personalCusList2:SetSize(230, 160)

    self:AddPersonalityItem(personalCusList2)
    self:AddSecretKnowledgeItem(personalCusList2)
    self:AddFavoritesItem(personalCusList2)
    self:AddHatesItem(personalCusList2)

    local messageBoxTips = UIPackage.CreateObjectFromURL("ui://0xrxw6g7ic0m35")
    
    local personalInfoBG = messageBoxTips.m_n56
    personalInfoBG.x = 0
    personalInfoBG.y = 303
    personalInfoBG:SetSize(485, 140)

    local personalInfoRightLoop = messageBoxTips.m_n63
    personalInfoRightLoop.x = 462
    personalInfoRightLoop.y = 290

    local personalInfoLeftLoop = messageBoxTips.m_n62 
    personalInfoLeftLoop.x = 35
    personalInfoLeftLoop.y = 290

    -- Attach new UI elements
    baseUI:AddChildAt(secretsFrame, 0)
    baseUI:AddChild(topLoop)
    baseUI:AddChild(bottomLoop)
    baseUI:AddChild(secretsNamePlate)
    baseUI:AddChild(unknownSecretCount)
    baseUI:AddChild(secretList)
    baseUI:AddChild(personalInfoBG)
    baseUI:AddChild(personalInfoLeftLoop)
    baseUI:AddChild(personalInfoRightLoop)
    baseUI:AddChild(personalCusList)
    baseUI:AddChild(personalCusList2)

    -- Hook up show/unshow events 
    baseUI.displayObject.onAddedToStage:Add(OnShowTalkUI)
    --baseUI.displayObject.onRemovedFromStage:Add(OnObjectEvent)

    -- The show event for this chat has already been triggered
    -- so manually launch the handler 
    OnShowTalkUI({
        type = "onAddedToStage",
        sender = baseUI,
    })
end
