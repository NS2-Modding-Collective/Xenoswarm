//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_UnlockUpgrade.lua

// Base class for all upgrades that unlock another upgrade

Script.Load("lua/Factions/BaseUpgrades/Factions_Upgrade.lua")
							
class 'FactionsDropUpgrade' (FactionsUpgrade)

FactionsDropUpgrade.upgradeType 	= kFactionsUpgradeTypes.Tech        	// the type of the upgrade
FactionsDropUpgrade.triggerType 	= kFactionsTriggerTypes.NoTrigger   	// how the upgrade is gonna be triggered
FactionsDropUpgrade.permanent		= false									// Controls whether you get the upgrade back when you respawn

function FactionsDropUpgrade:Initialize()

	FactionsUpgrade.Initialize(self)

	// This is a base class so never show it in the menu.
	if (self:GetClassName() == "FactionsDropUpgrade") then
		self.hideUpgrade = true
		self.baseUpgrade = true
	end
	self.upgradeType = FactionsDropUpgrade.upgradeType
	self.triggerType = FactionsDropUpgrade.triggerType
	self.permanent = FactionsDropUpgrade.permanent
	
end

function FactionsDropUpgrade:GetClassName()
	return "FactionsDropUpgrade"
end

// Give the weapon to the player when they buy the upgrade.
function FactionsDropUpgrade:OnAdd(player)

	local mapName = LookupTechData(self:GetUpgradeTechId(), kTechDataMapName)
	if mapName then
		local count = player:GetDropCount()
	
		for index = 1,count,1 do
			local origin = player:GetOrigin() + Vector(math.random() * 2 - 1, 0, math.random() * 2 - 1) 
			local values = { 
			    origin = origin,
				angles = player:GetAngles(),
				team = player:GetTeamNumber(),
				startsActive = true,
				}
			local ammoPack = Server.CreateEntity(mapName, values)
			ammoPack:SetTeamNumber(player:GetTeamNumber())
		end
	end

end