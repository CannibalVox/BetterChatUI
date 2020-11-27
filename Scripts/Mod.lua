local betterUIMod = GameMain:GetMod("CanVox.BetterUI");
local debug = true
betterUIMod.markedUpChat = betterUIMod.markedUpChat or false

function betterUIMod:OnRender(dt)
    local talkUIExists = CS.Wnd_JianghuTalk.Instance ~= nil
        and CS.Wnd_JianghuTalk.Instance.UIInfo ~= nil
    
    if betterUIMod.TalkUI then 
        if talkUIExists ~= betterUIMod.markedUpChat then 
            if talkUIExists then 
                betterUIMod.markedUpChat = true 
                betterUIMod.TalkUI:MarkUp(CS.Wnd_JianghuTalk.Instance.UIInfo)
            elseif debug then 
                betterUIMod.markedUpChat = false 
            end
        else
            betterUIMod.TalkUI:OnRender(CS.Wnd_JianghuTalk.Instance.UIInfo, dt)
        end
    end
end
