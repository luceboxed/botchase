AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "bothud.lua" )
AddCSLuaFile( "scoreboard.lua" )

include( "shared.lua" )
include( "simple_nextbot.lua" )

print("hello world!")


local model = {"models/player/tfa_lwa_sucy_uni.mdl", "models/player/alyx.mdl", "models/player/barney.mdl", "models/player/breen.mdl", "models/player/charple.mdl", "models/player/p2_chell.mdl", "models/player/combine_soldier.mdl", "models/player/combine_super_soldier.mdl", "models/player/combine_soldier_prisonguard.mdl", "models/player/combine_soldier_prisonguard.mdl", "models/player/eli.mdl", "models/player/Group01/female_01.mdl", "models/player/Group01/female_02.mdl", "models/player/Group01/female_03.mdl", "models/player/Group01/female_04.mdl", "models/player/Group01/female_05.mdl", "models/player/Group01/female_06.mdl", "models/player/Group03/female_07.mdl", "models/player/Group03/male_01.mdl", "models/player/Group03/male_02.mdl", "models/player/Group03/male_03.mdl", "models/player/Group03/male_04.mdl", "models/player/Group03/male_05.mdl", "models/player/Group03/male_06.mdl", "models/player/Group03/male_07.mdl", "models/player/Group03/male_08.mdl", "models/player/Group03/male_09.mdl"}

function GM:PlayerInitialSpawn(ply)
    ply:SetMaxHealth(100)
    ply:SetWalkSpeed(200)
    ply:SetRunSpeed(400)
    ply:Give("weapon_fists")
    ply:Give("parkourmod")
    ply:SetupHands()
    ply:SuppressHint( "OpeningMenu" )
    ply:SuppressHint( "Annoy1" )
    ply:SuppressHint( "Annoy2" )
    ply:SuppressHint( "PhysgunFreeze ")
    ply:SuppressHint( "PhysgunUse" )
    ply:SuppressHint( "VehicleView" )
end

function GM:PlayerDeathThink()
    return false
end

function GM:PlayerSpawn(ply)
    ply:SetMaxHealth(100)
    ply:SetWalkSpeed(200)
    ply:SetRunSpeed(400)
    ply:Give("weapon_fists")
    ply:Give("parkourmod")
    ply:SetupHands()
    ply:SetModel(model[ math.random( #model )])
    ply:UnSpectate()
end

function GM:PlayerDeath(victim, inflictor, attacker)
    timer.Simple( 3, function()
        victim:Spectate(5)
        victim:SetObserverMode(5)
    end)
    timer.Simple( 11, function()
        victim:Spawn()
    end)
    
end

timer.Destroy("HintSystem_OpeningMenu");
timer.Destroy("HintSystem_Annoy1");
timer.Destroy("HintSystem_Annoy2");


hook.Add( "PlayerSwitchFlashlight", "BlockFlashLight", function( ply, enabled )
	return ply:Alive() -- this is the only way i can get the flashlight to work lmao
end )


