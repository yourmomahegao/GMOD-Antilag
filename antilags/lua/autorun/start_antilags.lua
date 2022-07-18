if SERVER then
	include( "server/sv_lags.lua" )
	AddCSLuaFile( "client/cl_lags.lua" )
end

if CLIENT then
	include( "client/cl_lags.lua" )
end

print( "Antilag loading done." )
print( "-----------------------" )