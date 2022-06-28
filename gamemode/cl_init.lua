include( "shared.lua" )
include( "bothud.lua" )
include( "scoreboard.lua" )

function GM:ContextMenuOpen()
    return false
end

function GM:SpawnMenuOpen()
    return true
end