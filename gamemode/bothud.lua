function HUD()
    local client = LocalPlayer()

    if !client:Alive() then
        local spectatetarget = client:GetObserverTarget()
        draw.RoundedBox(0, 0, ScrH() - 60, 250, 60, Color(50, 50, 50, 200))
        draw.SimpleText(spectatetarget:Name(), "DermaDefaultBold", 10, ScrH() - 55, Color(255, 255, 255, 255), 0, 0)
        draw.SimpleText("Health: "..spectatetarget:Health(), "DermaDefaultBold", 10, ScrH() - 40, Color(255, 255, 255, 255), 0, 0)
        draw.RoundedBox(0, 10, ScrH() - 25, math.Clamp(spectatetarget:Health(), 0, 100) * 2.2, 15, Color(0, 255, 0, 255))
        draw.RoundedBox(0, 10, ScrH() - 25, 100 * 2.25, 15, Color(0, 255, 0, 30))
        draw.RoundedBox(0, 10, ScrH()- 25, math.Clamp(spectatetarget:Health(), 0, 100) * 2.25, 5, Color(30, 255, 30, 255))
    end
    if client:Alive() then
    draw.RoundedBox(0, 0, ScrH() - 50, 250, 50, Color(50, 50, 50, 200))
    draw.SimpleText("Health: "..client:Health(), "DermaDefaultBold", 10, ScrH() - 40, Color(255, 255, 255, 255), 0, 0)
    draw.RoundedBox(0, 10, ScrH() - 25, math.Clamp(client:Health(), 0, 100) * 2.2, 15, Color(0, 255, 0, 255))
    draw.RoundedBox(0, 10, ScrH() - 25, 100 * 2.25, 15, Color(0, 255, 0, 30))
    draw.RoundedBox(0, 10, ScrH()- 25, math.Clamp(client:Health(), 0, 100) * 2.25, 5, Color(30, 255, 30, 255))
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