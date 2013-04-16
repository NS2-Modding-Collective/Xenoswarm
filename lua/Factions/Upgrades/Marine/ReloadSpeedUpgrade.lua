//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________
						
class 'ReloadSpeedUpgrade' (FactionsUpgrade)

// Define these statically so we can easily access them without instantiating too.
ReloadSpeedUpgrade.cost = { 100, 200, 400, 600, 600 }                              			// Cost of the upgrade in xp
ReloadSpeedUpgrade.upgradeName = "reloadspeed"                     							// Text code of the upgrade if using it via console
ReloadSpeedUpgrade.upgradeTitle = "Reload Speed Upgrade"               						// Title of the upgrade, e.g. Submachine Gun
ReloadSpeedUpgrade.upgradeDesc = "Upgrade your reload speed"								// Description of the upgrade
ReloadSpeedUpgrade.upgradeTechId = kTechId.Speed1											// TechId of the upgrade, default is kTechId.Move cause its the first entry
ReloadSpeedUpgrade.teamType = kFactionsUpgradeTeamType.MarineTeam						// Team Type

function ReloadSpeedUpgrade:Initialize()

	FactionsUpgrade.Initialize(self)

	self.cost = ReloadSpeedUpgrade.cost
	self.upgradeName = ReloadSpeedUpgrade.upgradeName
	self.upgradeTitle = ReloadSpeedUpgrade.upgradeTitle
	self.upgradeDesc = ReloadSpeedUpgrade.upgradeDesc
	self.upgradeTechId = ReloadSpeedUpgrade.upgradeTechId
	
end

function ReloadSpeedUpgrade:GetClassName()
	return "ReloadSpeedUpgrade"
end

function ReloadSpeedUpgrade:OnAdd(player)
	if HasMixin(player, "WeaponUpgrade") then
		player:UpdateReloadSpeedLevel(self:GetCurrentLevel())
		player:SendDirectMessage("Reload Speed Upgraded to level " .. self:GetCurrentLevel() .. ".")
		local reloadSpeedBoost = math.round(self:GetCurrentLevel()*ReloadSpeedMixin.reloadSpeedBoostPerLevel / ReloadSpeedMixin.baseReloadSpeed * 100)
		player:SendDirectMessage("You will reload " .. reloadSpeedBoost .. "% faster")
	end
end