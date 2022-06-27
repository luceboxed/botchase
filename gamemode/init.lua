AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "bothud.lua" )

include( "shared.lua" )
print("hello world!")

function GM:PlayerSpawn(ply)
    ply:SetMaxHealth(100)
    ply:Give("parkourmod")
    ply:Give("weapon_fists")
    ply:SetupHands()
end