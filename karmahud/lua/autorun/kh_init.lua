/*---------------------------------------------------------
	Local file stuff.
---------------------------------------------------------*/
-- This is all the stuff that makes the addon load.
KarmaHUD = {}
KarmaHUD.Config = {}

print( "[KarmaHUD] Loading the addon..." )

if SERVER then
	print( "[KarmaHUD] Loading Serverside..." )
	--
	include( "sh_karmahud_config.lua" )
	AddCSLuaFile( "sh_karmahud_config.lua" )
	--
	AddCSLuaFile( "karmahud/client/cl_karmahud.lua" )
	--
	print( "[KarmaHUD] Loaded Serverside." )
end

if CLIENT then
	print( "[KarmaHUD] Loading Clientside..." )
	--
	include( "sh_karmahud_config.lua" )
	--
	include( "karmahud/client/cl_karmahud.lua" )
	--
	print( "[KarmaHUD] Loaded Clientside." )
end

print( "[KarmaHUD] Loaded the addon." )
	