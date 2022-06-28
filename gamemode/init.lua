AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "bothud.lua" )
AddCSLuaFile( "scoreboard.lua" )

include( "shared.lua" )
print("hello world!")

function GM:PlayerSpawn(ply)
    ply:SetMaxHealth(100)
    ply:SetWalkSpeed(200)
    ply:SetRunSpeed(400)
    ply:Give("weapon_fists")
    ply:Give("parkourmod")
    ply:SetupHands()
end

hook.Add( "PlayerSwitchFlashlight", "BlockFlashLight", function( ply, enabled )
	return ply:Alive() -- this is the only way i can get the flashlight to work lmao
end )