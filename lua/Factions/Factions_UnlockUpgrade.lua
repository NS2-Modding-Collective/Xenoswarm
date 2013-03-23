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

Script.Load("lua/Factions/Factions_Upgrade.lua")
							
class 'FactionsUnlockUpgrade' (FactionsUpgrade)

FactionsUnlockUpgrade.hideUpgrade	= true									// Do not show in the buy menu
FactionsUnlockUpgrade.upgradeType 	= kFactionsUpgradeTypes.Tech        	// the type of the upgrade
FactionsUnlockUpgrade.triggerType 	= kFactionsTriggerTypes.NoTrigger   	// how the upgrade is gonna be triggered
FactionsUnlockUpgrade.levels 		= 1                                    	// if the upgrade has more than one lvl, like weapon or armor ups. Default is 1.
FactionsUnlockUpgrade.permanent		= true									// Controls whether you get the upgrade back when you respawn

function FactionsUnlockUpgrade:Initialize()

	FactionsUpgrade.Initialize(self)

	// This is a base class so never show it in the menu.
	if (self:GetClassName() == "FactionsUnlockUpgrade") then
		self.hideUpgrade = FactionsUnlockUpgrade.hideUpgrade
	end
	self.upgradeType = FactionsUnlockUpgrade.upgradeType
	self.triggerType = FactionsUnlockUpgrade.triggerType
	self.levels = FactionsUnlockUpgrade.levels
	self.permanent = FactionsUnlockUpgrade.permanent
	
end

function FactionsUnlockUpgrade:GetClassName()
	return "FactionsUnlockUpgrade"
end

// Override this function to specify which upgrade you're unlocking.
function FactionsUnlockUpgrade:GetUnlockUpgradeId()
	return nil
end

// TODO: Show something to the player?
function FactionsUnlockUpgrade:OnAdd(player)
	if self:GetUnlockUpgradeId() ~= nil then
		local unlockUpgradeId = self:GetUnlockUpgradeId()
		local unlockUpgrade = player:GetUpgradeById(unlockUpgradeId)
		player:SendDirectMessage("Unlocked " .. unlockUpgrade:GetUpgradeTitle() .. "!")
	end
end
