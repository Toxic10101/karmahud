/*---------------------------------------------------------
	Local file stuff.
---------------------------------------------------------*/
-- Don't touch this because it'll fuck shit up.
include( "sh_karmahud_config.lua" )

-- This is going to disable the default HUD shit, don't want something disabled? Set it to "false"
local HideOldHUDShit = {
	[ "DarkRP_LocalPlayerHUD" ] = true, -- This is the default DarkRP HUD.
	[ "CHUDAmmo" ] = true, -- This is the Sandbox Ammo HUD.
	[ "CHUDSecondaryAmmo" ] = true, -- This is also the Sandbox Ammo HUD.
	[ "CHUDHealth" ] = true, -- This is the Sandbox Health HUD.
	[ "CHUDBattery" ] = true, -- This is the Sandbox Armor HUD.
	[ "CHUDSuitPower" ] = true, -- This is the backup Sandbox Armor HUD.
}

hook.Add( "HUDShouldDraw", "KarmaHUD:HideOldShit", function( name )
	if HideOldHUDShit[ name ] then return false end -- If it's in the table, don't draw it.
end)

-- Ignore for now.
local H = 0
local W = ScrW() / 2

-- Now I'm going to create some fonts for your HUD.
surface.CreateFont( "KarmaHUD_Font1", { font = KarmaHUD.Config.MainFont, size = KarmaHUD.Config.Font1Size } )

-- Now I'll make your fucking laws toggle because you won't shut up about it.
local ShouldLawsHUDDrawCunt = true
local LawsHUDTimer = CurTime()
	hook.Add( "Think", "LawsOfTheLandToggle", function()
		if input.IsKeyDown( KarmaHUD.Config.LawsToggleButton ) and LawsHUDTimer < CurTime() then
			ShouldLawsHUDDrawCunt = !ShouldLawsHUDDrawCunt	
			Time = CurTime() + KarmaHUD.Config.LawsDelay -- This sets a delay so people can't spam it.
		end
	end)

/*---------------------------------------------------------
	HUDPaint.
---------------------------------------------------------*/
-- This is the start of the drawing shite.
hook.Add( "HUDPaint", "KarmaHUD:DrawHisShiteHUD", function()

	-- Draw the top bar you fucking want cunt.
	surface.SetDrawColor( KarmaHUD.Config.TopBarMainColor )	
	surface.DrawRect( 5, H + 5, ScrW() - 10, H + 30 )
	-- Outline to the bar
	surface.SetDrawColor( KarmaHUD.Config.OutlineMainBarColor  )
	surface.DrawOutlinedRect( 5, H + 3, ScrW() - 10, H + 33, 2) 
	
	-- Draw Server name.
	draw.SimpleText( KarmaHUD.Config.HUDServerName, "KarmaHUD_Font1", ScrW() - 50, H + 11, KarmaHUD.Config.HUDFontColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_RIGHT )

	-- Draw Players name.
	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( KarmaHUD.Config.NameIcon )
	surface.DrawTexturedRect( ScrW() * 0.01, ScrH() + 12, 16, 16 )
	draw.SimpleText( LocalPlayer():Nick(), "KarmaHUD_Font1", ScrW() * 0.022, H + 12, KarmaHUD.Config.HUDFontColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
		
	-- Draw Players health.
	surface.SetDrawColor( Color( 48, 48, 48 )  )
	surface.DrawRect( ScrW() * 0.13, H + 8, 165, 23  )
	
	surface.SetDrawColor( Color( 200, 50, 50, 230 )  )	
	surface.DrawRect( ScrW() * 0.13, H + 8, 165 / 100 * LocalPlayer():Health() <= 165 and 165 / 100 * LocalPlayer():Health() or 165, 23  )

	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial( KarmaHUD.Config.HealthIcon )
	surface.DrawTexturedRect( ScrW() * 0.133, H + 12, 16, 16)

	if LocalPlayer():Health() > 0 then
		draw.SimpleText(LocalPlayer():Health() .. "%", "KarmaHUD_Font1", ScrW() * 0.21, H + 11, KarmaHUD.Config.HUDFontColor, TEXT_ALIGN_RIGHT)
	else
		draw.SimpleText("0%", "KarmaHUD_Font1", ScrW() * 0.21, H + 11, KarmaHUD.Config.HUDFontColor, TEXT_ALIGN_RIGHT)
	end

	-- Armor
	surface.SetDrawColor( Color( 48, 48, 48 )  )
	surface.DrawRect( ScrW() * 0.22, H + 8, 165, 23  )
	
	surface.SetDrawColor( Color( 0, 0, 255 )  )
	surface.DrawRect( ScrW() * 0.22, H + 8, 165 / 100 * LocalPlayer():Armor() <= 165 and 165 / 100 * LocalPlayer():Armor() or 165, 23  )

	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial( KarmaHUD.Config.ArmorIcon )
	surface.DrawTexturedRect(ScrW() * 0.224, H + 11, 16, 16)
	draw.SimpleText(LocalPlayer():Armor() .. "%", "KarmaHUD_Font1", ScrW() * 0.28, H + 11, LocalPlayer():Armor() > 0 and KarmaHUD.Config.HUDFontColor or Color( 200, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)

	-- Job
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial( KarmaHUD.Config.JobIcon )
	surface.DrawTexturedRect(ScrW() * 0.35, H + 11, 16, 16)
	draw.SimpleText(LocalPlayer():getDarkRPVar("job"), "KarmaHUD_Font1", ScrW() * 0.363, H + 11, team.GetColor(LocalPlayer():Team()), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)

	-- Money
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial( KarmaHUD.Config.MoneyIcon )
	surface.DrawTexturedRect(ScrW() * 0.6, H + 11, 16, 16)
	draw.SimpleText(DarkRP.formatMoney(LocalPlayer():getDarkRPVar("money")).. " (+"..DarkRP.formatMoney(LocalPlayer():getDarkRPVar("salary"))..")", "KarmaHUD_Font1", ScrW() * 0.615, H + 11, KarmaHUD.Config.HUDFontColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		
	-- Players Rank
	local RankData = LocalPlayer():GetUserGroup() or "User"
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial( KarmaHUD.Config.RankIcon )
	surface.DrawTexturedRect(ScrW() * 0.72, H + 11, 16, 16)
	draw.SimpleText(RankData, "KarmaHUD_Font1", ScrW() * 0.735, H + 11, KarmaHUD.Config.HUDFontColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)			
		
	-- Gun License
	if LocalPlayer():getDarkRPVar("HasGunlicense") then
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial( KarmaHUD.Config.GunLicenseIcon )
		surface.DrawTexturedRect(ScrW() * 0.80, H + 11, 16, 16)
		draw.SimpleText("Licensed", "KarmaHUD_Font1", ScrW() * 0.815, H + 11, KarmaHUD.Config.HUDFontColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
	else
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial( KarmaHUD.Config.GunLicenseIcon )
		surface.DrawTexturedRect(ScrW() * 0.80, H + 11, 16, 16)
		draw.SimpleText("Not Licensed", "KarmaHUD_Font1", ScrW() * 0.815, H + 11, KarmaHUD.Config.HUDFontColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
	end

	-- WANTED
	if LocalPlayer():isWanted() then
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial( KarmaHUD.Config.WantedIcon )
		surface.DrawTexturedRect(ScrW() * 0.87, H + 12, 16, 16)
		draw.SimpleText("Wanted", "KarmaHUD_Font1", ScrW() * 0.89, H + 11, KarmaHUD.Config.WantedTextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
	else
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial( KarmaHUD.Config.WantedIcon )
		surface.DrawTexturedRect(ScrW() * 0.87, H + 11, 16, 16)
		draw.SimpleText("Not Wanted", "KarmaHUD_Font1", ScrW() * 0.89, H + 11, KarmaHUD.Config.HUDFontColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
	end
	
	-- Server stats, disable this is in config if you don't want it
	if LocalPlayer():isArrested() then return false end
	local fps = math.Round(1/RealFrameTime(), 0)

	surface.SetDrawColor( KarmaHUD.Config.StatsBGHUD )
	surface.DrawRect( 5, ScrH() - 90, 260, 50 )
	surface.SetDrawColor( KarmaHUD.Config.StatsBarHUD )
	surface.DrawRect( 5, ScrH() - 110, 260, 20)

	surface.SetMaterial( KarmaHUD.Config.AmmoIcon )
	surface.SetDrawColor(255, 255, 255)
	surface.DrawTexturedRect(3, ScrH() - 110, 20, 20)

	surface.SetDrawColor( KarmaHUD.Config.StatsOutlineHUD  )
	surface.DrawOutlinedRect( 5, ScrH() - 110, 260, 70, 2 )

	draw.SimpleText("Current Props: " .. LocalPlayer():GetCount( "props" ) .. " | " .. "Current Players: " .. #player.GetAll() .. "/" .. game.MaxPlayers(), "KarmaHUD_Font1", 135, ScrH() - 80, KarmaHUD.Config.HUDFontColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText("Your Ping: " .. LocalPlayer():Ping() .. " | " .. "Your FPS: " .. fps, "KarmaHUD_Font1", 130, ScrH() - 60, KarmaHUD.Config.HUDFontColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
	-- Weapon Name
	if IsValid(LocalPlayer():GetActiveWeapon()) then
		local wep = LocalPlayer():GetActiveWeapon()
		local wep_name = wep.PrintName or wep:GetPrintName() or wep:GetClass()
		draw.SimpleText(wep_name, "KarmaHUD_Font1", 70, ScrH() - 100, KarmaHUD.Config.HUDFontColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
		
	-- Amount of Ammo
	if IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():Clip1() > 0 then
		local mag_extra = LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType())
		local ammo = (math.max((LocalPlayer():GetActiveWeapon():Clip1()), 0)) .. " | " .. mag_extra
		if ammo then
			draw.SimpleText(ammo, "KarmaHUD_Font1", 220, ScrH() - 100, KarmaHUD.Config.HUDFontColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
		
	-- Laws of the land
	if ShouldLawsHUDDrawCunt then
			// Drawing UI for laws
			surface.SetDrawColor( KarmaHUD.Config.LawBarColor )
			surface.DrawRect(5, H + 40, ScrW() * 0.30, H + 20)
			surface.SetDrawColor( KarmaHUD.Config.LawBGColor )
			surface.DrawRect(5, H + 60, ScrW() * 0.30, ((#DarkRP.getLaws() * 26) + 1) -15)

			surface.SetDrawColor( KarmaHUD.Config.LawOutlineColor )
			surface.DrawOutlinedRect( 5, H + 40, ScrW() * 0.30, ((#DarkRP.getLaws() * 26) + 1)+5, 2 ) -- Outline

			local lastHeight = 0

			// These laws automatically update
			draw.SimpleText(DarkRP.getPhrase("laws_of_the_land"), "KarmaHUD_Font1", W / W + 10, H + 42, KarmaHUD.Config.HUDFontColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
			draw.SimpleText("Press F1 to toggle", "KarmaHUD_Font1", ScrW() * 0.22, H + 40, KarmaHUD.Config.HUDFontColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		for k,v in ipairs(DarkRP.getLaws()) do
			draw.SimpleText(string.format("%u. %s", k, v), "KarmaHUD_Font1", 10, 65 + lastHeight, KarmaHUD.Config.HUDFontColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
			lastHeight = lastHeight + (fn.ReverseArgs(string.gsub(v, "\n", "")) + 1) * 21
		end
	end
	
end)
