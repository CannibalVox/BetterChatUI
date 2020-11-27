local betterUIMod = GameMain:GetMod("CanVox.BetterUI");

betterUIMod.TalkUI = betterUIMod.TalkUI or {}
local TalkUI = betterUIMod.TalkUI

function TalkUI:NewChatText(text)
    print("TEXT")
    print(text)
    if not text then
        return
    end

    self:RefreshJianghu()
end

function TalkUI:SetSupplementUIVisible(isVisible) 
    TalkUI.secretsFrame.visible = isVisible
    TalkUI.topLoop.visible = isVisible
    TalkUI.bottomLoop.visible = isVisible
    TalkUI.secretsNamePlate.visible = isVisible
    TalkUI.unknownSecretCount.visible = isVisible
    TalkUI.secretList.visible = isVisible
    TalkUI.personalInfoBG.visible = isVisible
    TalkUI.personalInfoLeftLoop.visible = isVisible
    TalkUI.personalInfoRightLoop.visible = isVisible
    TalkUI.personalCusList.visible = isVisible
    TalkUI.personalCusList2.visible = isVisible
end

function TalkUI:RefreshJianghu()
    local targetName = CS.Wnd_JianghuTalk.Instance.UIInfo.m_leftNpcName.text

    local npcs = World.map.Things:GetActiveNpcs()

    local foundNpc = nil 
    for i=1,npcs.Count do 
        if npcs[i]:GetName() == targetName then 
            foundNpc = npcs[i]
            break
        end
    end
    
    local jianghuData = nil 
    local npcData = nil

    if foundNpc ~= nil then 
        jianghuData = JianghuMgr:GetJHNpcDataBySeed(foundNpc.JiangHuSeed)
        npcData = JianghuMgr:GetKnowNpcData(foundNpc.JiangHuSeed)
    end

    local hasJianghuData = jianghuData ~= nil and npcData ~= nil

    self:SetSupplementUIVisible(hasJianghuData)

    if not hasJianghuData then 
        return
    end

    for i=1,4 do 
        if jianghuData.LikeItems and i <= jianghuData.LikeItems.Count then 
            self.favorites.list[i].visible = true 

            if npcData:IsKnowInfo(CS.XiaWorld.g_emJHNpcDataType.__CastFrom(1+i)) then
                local favoriteDef = ThingMgr:GetDef(g_emThingType.Item, jianghuData.LikeItems[i-1])
                self.favorites.list[i].tooltips = favoriteDef.ThingName
                self.favorites.list[i].icon = favoriteDef.TexPath
                self.favorites.list[i].m_icon.color = favoriteDef.Color
            else
                self.favorites.list[i].tooltips = "???"
                self.favorites.list[i].icon = "res/sprs/ui/icon_what"
                self.favorites.list[i].m_icon.color = CS.UnityEngine.Color.white
            end
        else 
            self.favorites.list[i].visible = false 
        end
    end

    for i=1,4 do 
        if jianghuData.HateItems and i <= jianghuData.HateItems.Count then 
            self.hates.list[i].visible = true 

            if npcData:IsKnowInfo(CS.XiaWorld.g_emJHNpcDataType.__CastFrom(5+i)) then
                local hateDef = ThingMgr:GetDef(g_emThingType.Item, jianghuData.HateItems[i-1])
                self.hates.list[i].tooltips = hateDef.ThingName
                self.hates.list[i].icon = hateDef.TexPath
                self.hates.list[i].m_icon.color = hateDef.Color
            else
                self.hates.list[i].tooltips = "???"
                self.hates.list[i].icon = "res/sprs/ui/icon_what"
                self.hates.list[i].m_icon.color = CS.UnityEngine.Color.white
            end
        else
            self.hates.list[i].visible = false 
        end
    end

    for i=1,5 do 
        if jianghuData.Carry and i <= jianghuData.Carry.Count then
            if npcData:CheckKnowKey("CarryRemove"..(i-1)) then
                -- Don't show treasures that have been lost
                self.treasures.list[i].visible = false 
            else
                self.treasures.list[i].visible = true 

                if npcData:IsKnowInfo(CS.XiaWorld.g_emJHNpcDataType.__CastFrom(9+i)) then
                    local treasureDef = jianghuData.Carry[i-1]

                    if treasureDef.ThingType == 1 then 
                        self.treasures.list[i].tooltips = XT("独门秘籍")
                        self.treasures.list[i].icon = "res/Sprs/object/object_miji01"
                        self.treasures.list[i].m_icon.color = CS.UnityEngine.Color.white
                    else
                        self.treasures.list[i].tooltips = treasureDef.ThingName 
                        self.treasures.list[i].icon = treasureDef.TexPath
                        self.treasures.list[i].m_icon.color = treasureDef.Color 
                    end
                else
                    self.treasures.list[i].tooltips = "???"
                    self.treasures.list[i].icon = "res/sprs/ui/icon_what"
                    self.treasures.list[i].m_icon.color = CS.UnityEngine.Color.white
                end
            end
        else
            self.treasures.list[i].visible = false 
        end
    end

    for i=1,3 do 
        if jianghuData.Hobby and i <= jianghuData.Hobby.Count then 
            self.weaknesses.list[i].visible = true 

            if npcData:IsKnowInfo(CS.XiaWorld.g_emJHNpcDataType.__CastFrom(15+i)) then 
                local hobbyDef = JianghuMgr:GetHobby(jianghuData.Hobby[i-1])
                self.weaknesses.list[i].title = hobbyDef.Title 
                self.weaknesses.list[i].tooltips = hobbyDef:GetHobbyTxt(jianghuData)
            else
                self.weaknesses.list[i].title = "???"
                self.weaknesses.list[i].tooltips = ""
            end
        elseif i == 1 then 
            self.weaknesses.list[i].visible = true 
            self.weaknesses.list[i].title = "None"
        else
            self.weaknesses.list[i].visible = false 
        end
    end

    for i=1,3 do
        if jianghuData.Secret and i <= jianghuData.Secret.Count then
            self.mysteries.list[i].visible = true 

            if npcData:IsKnowInfo(CS.XiaWorld.g_emJHNpcDataType.__CastFrom(18+i)) then
                self.mysteries.list[i].title = JianghuMgr:GetClueTitle(jianghuData.Secret[i-1])
                self.mysteries.list[i].tooltips = JianghuMgr:GetClueTypeName(jianghuData.Secret[i-1])
            else
                self.mysteries.list[i].title = "???"
                self.mysteries.list[i].tooltips = ""
            end
        elseif i == 1 then 
            self.mysteries.list[i].visible = true 
            self.mysteries.list[i].title = "None"
        else
            self.mysteries.list[i].visible = false 
        end
    end

    if jianghuData.Feature ~= CS.XiaWorld.g_emJHNpc_Feature.None then 
        if npcData:IsKnowInfo(CS.XiaWorld.g_emJHNpcDataType.Feature) then 
            self.personality.text = GameDefine.JHFeatureTxts[jianghuData.Feature]
        else
            self.personality.text = "???"
        end
    else
        self.personality.text = XT("无")
    end

    if npcData:IsKnowInfo(CS.XiaWorld.g_emJHNpcDataType.Track) then 
        self.traces.text = PlacesMgr:GetPlaceDef(npcData.place).DisplayName
    else
        self.traces.text = "???"
    end

    if not jianghuData.Esoterica then 
        self.esoterica.text = XT("无")
    else 
        if npcData:IsKnowInfo(CS.XiaWorld.g_emJHNpcDataType.Esoterica) then
            local esotericaDef = nil 
            
            if jianghuData.Esoterica.Name then 
                esotericaDef = EsotericaMgr:GetEsotericaDef(jianghuData.Esoterica.Name, true)
            end

            if esotericaDef then 
                self.esoterica.text = esotericaDef.DisplayName 
            elseif jianghuData.Esoterica.Type == CS.XiaWorld.g_emEsotericaType.None then 
                self.esoterica.text = XT("无")
            else
                self.esoterica.text = GameDefine.GetEsotericaTypeStr(jianghuData.Esoterica.Type)..XT("之法")
            end
        else
            self.esoterica.text = "???"
        end
    end
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
    self.secretsFrame = bodyAbilitiesFrame:GetChild("n90")
    self.secretsFrame:SetSize(210, 315)
    self.secretsFrame.x = -200
    self.secretsFrame.y = -7
    self.secretsFrame.name = "secretsFrameBG"
    self:RemoveByName(baseUI, "secretsFrameBG")

    self.topLoop = bodyAbilitiesFrame:GetChild("n91")
    self.topLoop.x = -10
    self.topLoop.y = 45
    self.topLoop.name = "secretsFrameTopLoop"
    self:RemoveByName(baseUI, "secretsFrameTopLoop")

    self.bottomLoop = bodyAbilitiesFrame:GetChild("n92")
    self.bottomLoop.x = -10
    self.bottomLoop.y = 235
    self.bottomLoop.name = "secretsFrameBottomLoop"
    self:RemoveByName(baseUI, "secretsFrameBottomLoop")

    self.secretsNamePlate = bodyAbilitiesFrame:GetChild("n93")
    self.secretsNamePlate.x = -160
    self.secretsNamePlate.y = 15
    self.secretsNamePlate.name = "secretsFrameTitle"
    self:RemoveByName(baseUI, "secretsFrameTitle")

    local secretsTitle = self.secretsNamePlate:GetChild("title")
    secretsTitle.text = "Held Secrets"

    -- Add Unknown: ### label and list of known secrets
    self.unknownSecretCount = UIPackage.CreateObjectFromURL("ui://0xrxw6g7nd594l")
    self.unknownSecretCount.x = -160
    self.unknownSecretCount.y = 40
    self.unknownSecretCount:SetSize(145, 30)
    self.unknownSecretCount.text = "Unknown: 7"
    self.unknownSecretCount.name = "unknownSecretCount"
    self:RemoveByName(baseUI, "unknownSecretCount")

    local unknownSecretFormat = self.unknownSecretCount:GetTextField().textFormat
    unknownSecretFormat.italic = true
    unknownSecretFormat.bold = true 
    unknownSecretFormat.size = 16
    unknownSecretFormat.color = CS.UnityEngine.Color(0.5,0.5,0.5,1)
    self.unknownSecretCount:GetTextField().textFormat = unknownSecretFormat

    local cusList = UIPackage.CreateObjectFromURL("ui://0xrxw6g7m8j0ovnz")
    
    self.secretList = cusList:GetChild("list")
    self.secretList.defaultItem = "ui://0xrxw6g7gebq2l"
    self.secretList.x = -180
    self.secretList.y = 60
    self.secretList.name = "secretList"
    self:RemoveByName(baseUI, "secretList")
    self.secretList:SetSize(165, 230)

    for i=0,100 do
        local otherItem = self.secretList:AddItemFromPool()
        otherItem:SetSize(90, 18)
        local itemTitle = otherItem:GetChild("title")
        itemTitle.text = "Personality: Huo Sun"
        itemTitle:SetSize(90, 18)
        itemTitle.x = itemTitle.x + 5
    end

    self.personalCusList = UIPackage.CreateObjectFromURL("ui://0xrxw6g7m8j0ovnz").m_list
    self.personalCusList.x = 40
    self.personalCusList.y = 308
    self.personalCusList.defaultItem = "ui://0xrxw6g7kzxt2ovu7"
    self.personalCusList:SetSize(250, 140)

    self:AddMysteryItem(self.personalCusList)
    self:AddTracesItem(self.personalCusList)
    self:AddWeaknessItem(self.personalCusList)
    self:AddTreasuresItem(self.personalCusList)

    self.personalCusList2 = UIPackage.CreateObjectFromURL("ui://0xrxw6g7m8j0ovnz").m_list
    self.personalCusList2.x = 275
    self.personalCusList2.y = 308
    self.personalCusList2.defaultItem = "ui://0xrxw6g7kzxt2ovu7"
    self.personalCusList2:SetSize(230, 160)

    self:AddPersonalityItem(self.personalCusList2)
    self:AddSecretKnowledgeItem(self.personalCusList2)
    self:AddFavoritesItem(self.personalCusList2)
    self:AddHatesItem(self.personalCusList2)

    local messageBoxTips = UIPackage.CreateObjectFromURL("ui://0xrxw6g7ic0m35")
    
    self.personalInfoBG = messageBoxTips.m_n56
    self.personalInfoBG.x = 0
    self.personalInfoBG.y = 303
    self.personalInfoBG:SetSize(485, 140)

    self.personalInfoRightLoop = messageBoxTips.m_n63
    self.personalInfoRightLoop.x = 462
    self.personalInfoRightLoop.y = 290

    self.personalInfoLeftLoop = messageBoxTips.m_n62 
    self.personalInfoLeftLoop.x = 35
    self.personalInfoLeftLoop.y = 290

    -- Attach new UI elements
    baseUI:AddChildAt(self.secretsFrame, 0)
    baseUI:AddChild(self.topLoop)
    baseUI:AddChild(self.bottomLoop)
    baseUI:AddChild(self.secretsNamePlate)
    baseUI:AddChild(self.unknownSecretCount)
    baseUI:AddChild(self.secretList)
    baseUI:AddChild(self.personalInfoBG)
    baseUI:AddChild(self.personalInfoLeftLoop)
    baseUI:AddChild(self.personalInfoRightLoop)
    baseUI:AddChild(self.personalCusList)
    baseUI:AddChild(self.personalCusList2)

    -- Hook up show/unshow events 
    baseUI.displayObject.onAddedToStage:Add(
        function()
            self.UIIsVisible = true
            self:RefreshJianghu()
        end)
    baseUI.displayObject.onRemovedFromStage:Add(
        function()
            self.UIIsVisible = false 
        end)
    local val = self
    baseUI.m_n89.onClick:Add(
        function(ctx)
            TalkUI:OnChatClick(baseUI)
        end)
    baseUI.m_n91.onClick:Add(
        function(ctx)
            self:OnChatClick(baseUI)
        end)    

    -- The show event for this chat has already been triggered
    -- so manually launch the handler 
    self.UIIsVisible = true 
    self.MessageTimer = 0
    self.LastChatText = ""
    self.WaitingOnText = true
    self.TextLocked = false
    self:RefreshJianghu()
end

function TalkUI:OnChatClick(baseUI)
    local currentText = baseUI.m_txt.text
    if self.WaitingOnText and currentText then 
        self:NewChatText(currentText)
    else
        self.WaitingOnText = true 
    end
    self.LastChatText = currentText
    self.TextLocked = true
end

function TalkUI:OnRender(baseUI, dt)
    if not betterUIMod.TalkUI.UIIsVisible or not self.WaitingOnText then 
        return 
    end

    self.MessageTimer = self.MessageTimer + dt 
    if self.MessageTimer < 0.1 then 
        return 
    end
        
    self.MessageTimer = 0
    local currentText = baseUI.m_txt.text
    if currentText == self.LastChatText and not self.TextLocked then
        self.WaitingOnText = false 
        self:NewChatText(currentText)
        return
    elseif currentText ~= self.LastChatText and self.TextLocked then
        self.TextLocked = false
    end
    
    self.LastChatText = currentText
end
