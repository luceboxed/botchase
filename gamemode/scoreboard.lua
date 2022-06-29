local ScoreboardDerma = nil
local PlayerList = nil

function GM:ScoreboardShow()

if !IsValid(ScoreboardDerma) then
    ScoreboardDerma = vgui.Create("DFrame")
    ScoreboardDerma:SetSize(750, 500)
    ScoreboardDerma:SetPos(ScrW() / 2 - 325, ScrH() / 2 - 250)
    ScoreboardDerma:SetDraggable(false)
    ScoreboardDerma:ShowCloseButton(false)
    ScoreboardDerma.Paint = function()
        draw.RoundedBox(10, 0, 0, ScoreboardDerma:GetWide(), ScoreboardDerma:GetTall(), Color(50, 50, 50, 200))
    end

    local PlayerScrollPanel = vgui.Create("DScrollPanel", ScoreboardDerma)
    PlayerScrollPanel:SetSize(ScoreboardDerma:GetWide(), ScoreboardDerma:GetTall() - 20)
    PlayerScrollPanel:SetPos(0, 20)

    PlayerList = vgui.Create("DListLayout", PlayerScrollPanel)
    PlayerList:SetSize(PlayerScrollPanel:GetWide(), PlayerScrollPanel:GetTall())
    PlayerList:SetPos(0, 0)
end
    if IsValid(ScoreboardDerma) then
        PlayerList:Clear()
        ScoreboardDerma:SetTitle(GetHostName().." - "..player.GetCount().."/"..game.MaxPlayers().." players - Nextbot Survival -".." "..game.GetMap())
        local PLAYERS = player.GetAll()
        table.sort( PLAYERS, function ( a, b ) return a:Deaths() < b:Deaths() end )
        for k, v in pairs(PLAYERS) do
            local PlayerPanel = vgui.Create("DPanel", PlayerList)
            local Avatar = vgui.Create("AvatarImage", PlayerPanel)
            Avatar:SetSize(32, 32)
            Avatar:SetPlayer( v, 64)
            Avatar:SetPos(5, 5)
            PlayerPanel:SetSize(PlayerList:GetWide(), 50)
            PlayerPanel:SetPos(0, 0)
            PlayerPanel.Paint = function()
                draw.RoundedBox(0, 0, 0, PlayerPanel:GetWide(), PlayerPanel:GetTall(), Color(40, 40, 40, 200))  
                draw.RoundedBox(0, 0, 49, PlayerPanel:GetWide(), 1, Color(255, 255, 255, 255))

                draw.SimpleText(v:GetName(), "DermaDefault", 45, 10, Color(255,255,255))
                draw.SimpleText("Deaths: "..v:Deaths(), "DermaDefault", PlayerList:GetWide() - 20, 10, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
                draw.SimpleText(v:Ping().."ms", "DermaDefault", 75, 25, Color(255, 255, 255), TEXT_ALIGN_RIGHT)

                if !v:Alive() and v:GetObserverMode() <= 0 then
                    draw.RoundedBox(0, 0, 49, PlayerPanel:GetWide(), 1, Color(100, 0, 0, 255))
                    draw.RoundedBox(0, 0, 0, PlayerPanel:GetWide(), PlayerPanel:GetTall(), Color(50, 40, 40, 200))  
                    draw.SimpleText("DEAD", "DermaDefault", PlayerList:GetWide() / 2, 10, Color(255, 0, 0), TEXT_ALIGN_RIGHT)
                end

                if v:GetObserverMode() >= 1 then
                    draw.RoundedBox(0, 0, 49, PlayerPanel:GetWide(), 1, Color(200, 200, 200, 255))
                    draw.RoundedBox(0, 0, 0, PlayerPanel:GetWide(), PlayerPanel:GetTall(), Color(40, 40, 40, 200))  
                    draw.SimpleText("SPECTATOR", "DermaDefault", PlayerList:GetWide() / 2, 10, Color(200, 200, 200), TEXT_ALIGN_RIGHT)
                end

                end
                local addbutton = vgui.Create("DButton", PlayerPanel)
                addbutton:SetPos( PlayerList:GetWide() - 115, 25 )
                addbutton:SetSize( 100, 20 )
                addbutton:SetText( "Open Steam profile" )
                addbutton.DoClick = function()
                    v:ShowProfile()
            end
        end

        ScoreboardDerma:Show()
        ScoreboardDerma:MakePopup()
        ScoreboardDerma:SetKeyboardInputEnabled(false)
    end
end 
function GM:ScoreboardHide()
    if IsValid(ScoreboardDerma) then
        ScoreboardDerma:Hide()
    end
end

print("scoreboard loaded")