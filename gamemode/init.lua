AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "bothud.lua" )
AddCSLuaFile( "scoreboard.lua" )

include( "shared.lua" )
--include( "simple_nextbot.lua" )


local model = {"models/player/tfa_lwa_sucy_uni.mdl", "models/player/alyx.mdl", "models/player/barney.mdl", "models/player/breen.mdl", "models/player/charple.mdl", "models/player/p2_chell.mdl", "models/player/combine_soldier.mdl", "models/player/combine_super_soldier.mdl", "models/player/combine_soldier_prisonguard.mdl", "models/player/combine_soldier_prisonguard.mdl", "models/player/eli.mdl", "models/player/Group01/female_01.mdl", "models/player/Group01/female_02.mdl", "models/player/Group01/female_03.mdl", "models/player/Group01/female_04.mdl", "models/player/Group01/female_05.mdl", "models/player/Group01/female_06.mdl", "models/player/Group03/female_07.mdl", "models/player/Group03/male_01.mdl", "models/player/Group03/male_02.mdl", "models/player/Group03/male_03.mdl", "models/player/Group03/male_04.mdl", "models/player/Group03/male_05.mdl", "models/player/Group03/male_06.mdl", "models/player/Group03/male_07.mdl", "models/player/Group03/male_08.mdl", "models/player/Group03/male_09.mdl"}
roundstarttime = CurTime()
roundinprogress = false

timer.Create("passiveregen", 3, 0, function()
    local HUMANPLAYERS = player.GetHumans() 
    local ALIVEHUMANPLAYERS = {}
    local ALIVEBOTPLAYERS = {}
    for k,v in ipairs(HUMANPLAYERS) do
        if v:Alive() then
            table.insert(ALIVEHUMANPLAYERS, v)
        end
    end
    for k,v in ipairs(player.GetBots()) do
        if v:Alive() then
            table.insert(ALIVEBOTPLAYERS, v)
        end
    end
    for k,v in ipairs(ALIVEHUMANPLAYERS) do
        if v:Health() < 200 then
            v:SetHealth(v:Health() + 2)
        end
    end
    for k,v in ipairs(ALIVEBOTPLAYERS) do
        if v:Health() < 100 then
            v:SetHealth( math.Clamp(v:Health() + 10, 0, 100))
        end
    end
end)


function GM:PlayerInitialSpawn(ply)
    ply:SetModel(model[ math.random( #model )])
    ply:SetupHands()
    ply:Give("weapon_fists")
    ply:Give("weapon_medkit")
    ply:SuppressHint( "OpeningMenu" )
    ply:SuppressHint( "Annoy1" )
    ply:SuppressHint( "Annoy2" )
    ply:SuppressHint( "PhysgunFreeze ")
    ply:SuppressHint( "PhysgunUse" )
    ply:SuppressHint( "VehicleView" )
    ply:SetCollisionGroup(11)
    ply:GodEnable()
    ply:SetRenderMode( 1 )
    ply:SetColor(Color(255,255,255,100))
    timer.Simple(10, function() ply:GodDisable() ply:SetCollisionGroup(0) ply:SetColor(Color(255,255,255,255)) end)
    if ply:IsBot() then
        ply:SetMaxSpeed(450)
        ply:SetWalkSpeed(450)
        ply:SetRunSpeed(450)
        ply:Flashlight( true )
    end
    if roundinprogress == true then
        ply:Kill()
    end
end


function GM:PlayerDeathThink()
    return false
end

function GM:PlayerSpawn(ply)
    ply:SetModel(model[ math.random( #model )])
    ply:SetMaxHealth(100)
    ply:SetWalkSpeed(200)
    ply:SetRunSpeed(450)
    ply:SetMaxSpeed(450)
    ply:SetupHands()
    ply:Give("weapon_fists")
    ply:Give("weapon_medkit")
    ply:SetCollisionGroup(11)
    ply:UnSpectate()
    ply:GodEnable()
    ply:SetRenderMode( 1 )
    ply:SetColor(Color(255,255,255,100))
    ply:SetName("test")
    timer.Simple(10, function() ply:GodDisable() ply:SetCollisionGroup(0) ply:SetColor(Color(255,255,255,255)) end)
    if ply:IsBot() then
        ply:SetMaxSpeed(450)
        ply:SetWalkSpeed(450)
        ply:SetRunSpeed(450)
        ply:Flashlight( true )
    end
    if roundinprogress == true then
        ply:Kill()
    end
end



function GM:PlayerDeath(victim, inflictor, attacker)
    victim:Flashlight ( false )
    victim:StripWeapons()
    local PLAYERS = player.GetAll()
    local AlivePlayers = {}
    for k,v in ipairs(PLAYERS) do
        if v:Alive() then
            table.insert(AlivePlayers, v)
        end
    end
    if (#AlivePlayers == 1) then
        roundinprogress = false
        timer.Simple(20, function() roundinprogress = true print("late respawns off") end)
        timer.Simple(5, function() roundstarttime = CurTime() end)
        AlivePlayers[1]:SetNWInt("wins", AlivePlayers[1]:GetNWInt("wins") + 1)
        print(AlivePlayers[1]:Nick().. " wins!\nWin #"..AlivePlayers[1]:GetNWInt("wins").."\nRound time: "..math.Round((CurTime() - roundstarttime)/60, 1).." minutes")
        timer.Simple(5, (function() for k,v in ipairs(PLAYERS) do
            v:StripWeapons()
            v:Spawn()
            timer.Remove("respawntimer")
        end
        timer.Create("respawnwaves", 3, 3, function()
            local PLAYERS = player.GetAll()
            local deadplayers = {}
            for k,v in ipairs(PLAYERS) do
                if !v:Alive() or v:GetObserverMode() >= 1 then
                    table.insert(deadplayers, v)
                end
            end
            for k,v in ipairs(deadplayers) do
                v:Spawn()
            end
        end)
        timer.Start("respawnwaves")
        end))
    end

    timer.Simple(3, function()
        victim:Spectate(5)
        victim:SetObserverMode(5)
        victim:SpectateEntity(attacker)
        print(tostring(victim:Nick()).." is now spectating "..tostring(victim:GetObserverTarget()))
        timer.Create("respawntimer", 3000, 1, function()
            victim:Spawn()
         end)
        timer.Start("respawntimer")
    end)
end

gameevent.Listen("player_disconnect")
hook.Add("player_disconnect", "check_round_over_disconnect", function( data )
    print("disconnect hook fired!")
    timer.Simple(1, function() local PLAYERS = player.GetAll()
    local AlivePlayers = {}
    for k,v in ipairs(PLAYERS) do
        if v:Alive() and v:IsValid() then
            table.insert(AlivePlayers, v)
        end
    end 
    if (#AlivePlayers == 1) then
        roundinprogress = false
        timer.Simple(40, function() roundinprogress = true print("late respawns off") end)
        timer.Simple(5, function() roundstarttime = CurTime() end)
        AlivePlayers[1]:SetNWInt("wins", AlivePlayers[1]:GetNWInt("wins") + 1)
        print(AlivePlayers[1]:Nick().. " wins!\nWin #"..AlivePlayers[1]:GetNWInt("wins").."\nRound time: "..math.Round((CurTime() - roundstarttime)/60, 1).." minutes")
        timer.Simple(5, (function() for k,v in ipairs(PLAYERS) do
            v:StripWeapons()
            v:Spawn()
            timer.Remove("respawntimer")
        end
        timer.Create("respawnwaves", 3, 3, function()
            local PLAYERS = player.GetAll()
            local deadplayers = {}
            for k,v in ipairs(PLAYERS) do
                if !v:Alive() or v:GetObserverMode() >= 1 then
                    table.insert(deadplayers, v)
                end
            end
            for k,v in ipairs(deadplayers) do
                v:Spawn()
            end
        end)
        timer.Start("respawnwaves")

        timer.Simple(10, function() 
        local deadplayers = {}
        for k,v in ipairs(PLAYERS) do
            if !v:Alive() or v:GetObserverMode() >= 1 then
                table.insert(deadplayers, v)
            end
        end
        if #deadplayers >= 0 then
            for k,v in ipairs(deadplayers) do
                print("Server overcrowded! Unable to spawn "..v:Nick())
            end
        PrintMessage(HUD_PRINTCENTER, "Server overcrowded! Unable to spawn "..#deadplayers.." players")
        end
        end)
        end))
    end
end)
end)

timer.Destroy("HintSystem_OpeningMenu");
timer.Destroy("HintSystem_Annoy1");
timer.Destroy("HintSystem_Annoy2");

hook.Add( "KeyPress", "click_swap_spec_target", function( ply, key )
    local PLAYERS = player.GetAll()
    local SpecList = {}
    for k,v in ipairs(PLAYERS) do
        if v:Alive() then
            table.insert(SpecList, v)
        end
    end
	if (key == IN_ATTACK) and ply:GetObserverMode() >= 1 then
        ply:SpectateEntity(SpecList[ math.random( #SpecList )])
    end
end )

hook.Add( "KeyPress", "click_swap_spec_mode", function( ply, key )
    if (key == IN_ATTACK2) and ply:GetObserverMode() == 5 then
        ply:SetObserverMode(4)
    elseif (key == IN_ATTACK2) and ply:GetObserverMode() == 4 then
        ply:SetObserverMode(5)
    end
end )


--debug respawn self
-- hook.Add( "KeyPress", "debug_respawn_self", function( ply, key )
  --  if (key == IN_WALK) then
    --    ply:Spawn()
    -- end
-- end)    

hook.Add( "PlayerSwitchFlashlight", "BlockFlashLight", function( ply, enabled )
	return ply:Alive() -- this is the only way i can get the flashlight to work lmao
end )


print("init.lua loaded")