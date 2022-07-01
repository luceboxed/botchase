roundstarttime = CurTime()
win_posted_chat = false
function HUD()
    local client = LocalPlayer()

    if client:GetObserverMode() >= 1 then
        local PLAYERS = player.GetAll()
        local spectatetarget = client:GetObserverTarget()
        local AlivePLAYERS = {}
        for k,v in ipairs(PLAYERS) do
            if v:Alive() then
                table.insert(AlivePLAYERS, v)
            end
        end
        local SpecList = {}
        for k,v in ipairs(PLAYERS) do
            if v:GetObserverTarget() == spectatetarget then
                table.insert(SpecList, v)
            end
        end
        -- list other players who are also spectating
        if #SpecList > 0 then
            local SpecListString = ""
            for k,v in ipairs(SpecList) do
                SpecListString = SpecListString..v:Nick().."\n"
            end
            if spectatetarget:IsPlayer() then
                draw.SimpleText("Players spectating "..spectatetarget:Nick()..":", "DermaDefaultBold", ScrW()/ 4, ScrH()/4, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            else
                draw.SimpleText("Players spectating " ..tostring(client:GetObserverTarget()).. ":", "DermaDefaultBold", ScrW()/ 4, ScrH()/4, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
                draw.DrawText(SpecListString, "DermaDefault", ScrW()/4, ScrH()/4+10, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        hook.Add( "KeyPress", "click_update_spec_ui", function( ply, key )
            if (key == IN_ATTACK) and ply:GetObserverMode() >= 1 then
                local spectatetarget = client:GetObserverTarget()
            end
        end )
        draw.RoundedBox(0, 0, ScrH() - 70, 250, 100, Color(50, 50, 50, 200))
        draw.SimpleText("Health: "..spectatetarget:Health(), "DermaDefaultBold", 10, ScrH() - 40, Color(255, 255, 255, 255), 0, 0)
        draw.SimpleText("Speed: "..math.floor(math.abs(spectatetarget:GetVelocity():Length())), "DermaDefaultBold", 10, ScrH() - 50, Color(255, 255, 255, 255), 0, 0)
        draw.RoundedBox(0, 10, ScrH() - 25, math.Clamp(spectatetarget:Health(), 0, 100) * 2.2, 15, Color(0, 255, 0, 255))
        draw.RoundedBox(0, 10, ScrH() - 25, 100 * 2.25, 15, Color(0, 255, 0, 30))
        draw.RoundedBox(0, 10, ScrH()- 25, math.Clamp(spectatetarget:Health(), 0, 100) * 2.25, 15, Color(30, 255, 30, 255))
        draw.RoundedBox(0, 10, ScrH()- 25, math.Clamp(spectatetarget:Health() - 100, 0, 100) * 2.25, 15, Color(30, 30, 255, 60))
        
        if spectatetarget:IsPlayer() then
            draw.SimpleText(spectatetarget:Name(), "DermaDefaultBold", 10, ScrH() - 65, Color(255, 255, 255, 255), 0, 0)
        else
            draw.SimpleText(client:GetObserverTarget(), "DermaDefaultBold", 10, ScrH() - 65, Color(255, 255, 255, 255), 0, 0)
        end
    else client:Alive()
        draw.RoundedBox(0, 0, ScrH() - 50, 250, 50, Color(50, 50, 50, 200))
        draw.SimpleText("Health: "..client:Health(), "DermaDefaultBold", 10, ScrH() - 40, Color(255, 255, 255, 255), 0, 0)
        draw.SimpleText("Speed: "..math.floor(math.abs(client:GetVelocity():Length())), "DermaDefaultBold", 10, ScrH() - 50, Color(255, 255, 255, 255), 0, 0)
        -- debug vector
        -- draw.SimpleText(tostring(client:GetVelocity()[1]).." "..tostring(client:GetVelocity()[2]).." "..tostring(client:GetVelocity()[3]), "DermaDefaultBold", 10, ScrH() - 60, Color(255, 255, 255, 255), 0, 0)
        --list players who are spectating you
        local SpecList = {}
        for k,v in ipairs(player.GetAll()) do
            if v:GetObserverTarget() == client then
                table.insert(SpecList, v)
            end
        end
        if #SpecList > 0 then
            local SpecListString = ""
            for k,v in ipairs(SpecList) do
                SpecListString = SpecListString..v:Nick().."\n"
            end
            draw.SimpleText("Players spectating you:", "DermaDefaultBold", ScrW()/ 4, ScrH()/4, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.DrawText(SpecListString, "DermaDefault", ScrW()/4, ScrH()/4+10, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        draw.RoundedBox(0, 10, ScrH() - 25, math.Clamp(client:Health(), 0, 100) * 2.2, 15, Color(0, 255, 0, 255))
        draw.RoundedBox(0, 10, ScrH() - 25, 100 * 2.25, 15, Color(0, 255, 0, 30))
        draw.RoundedBox(0, 10, ScrH()- 25, math.Clamp(client:Health(), 0, 100) * 2.25, 15, Color(30, 255, 30, 255))
        draw.RoundedBox(0, 10, ScrH()- 25, math.Clamp(client:Health() - 100, 0, 100) * 2.25, 15, Color(30, 30, 255, 60))

        local PLAYERS = player.GetAll()
        local AlivePlayers = {}
        for k,v in ipairs(PLAYERS) do
            if v:Alive() then
                table.insert(AlivePlayers, v)
            end
        end
        if (player.GetCount() > 1) then
            if (#AlivePlayers == 1) then
                --broadcast win message
                timer.Simple(5, function() roundstarttime = CurTime() end)
                draw.DrawText(AlivePlayers[1]:Nick().. " wins!\nWin #"..AlivePlayers[1]:GetNWInt("wins").."\nRound time: "..math.Round((CurTime() - roundstarttime)/60, 1).." minutes", "DermaLarge", ScrW()/2, ScrH()/2, Color(255,255,255,255), TEXT_ALIGN_CENTER)
                if win_posted_chat == false then
                    chat.AddText(AlivePlayers[1]:Nick().. " wins!\nWin #"..AlivePlayers[1]:GetNWInt("wins").."\nRound time: "..math.Round((CurTime() - roundstarttime)/60, 1).." minutes")
                end
                win_posted_chat = true
                timer.Simple(7, function() win_posted_chat = false end)
            end
    end
    end
end
hook.Add("HUDPaint", "BotHud", HUD)

function HideHud(name)
    for k, v in pairs({"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"}) do
            if name == v then
                return false
            end
    end
end
hook.Add("HUDShouldDraw", "HideDefaultHud", HideHud)

print("HUD loaded")