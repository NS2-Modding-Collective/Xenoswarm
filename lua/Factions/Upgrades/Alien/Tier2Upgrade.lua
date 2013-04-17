//________________________________
//
//   	NS2 Combat Mod     
//	Made by JimWest and MCMLXXXIV, 2012
//
//________________________________

// Alien Upgrades
						
class 'Tier2Upgrade' (FactionsUpgrade)

Tier2Upgrade.cost 				= { 250 }                          	// cost of the upgrade in xp
Tier2Upgrade.upgradeName		= "tier2"	                        // text code of the upgrade if using it via console
Tier2Upgrade.upgradeTitle 		= "Tier 2"       					// Title of the upgrade, e.g. Submachine Gun
Tier2Upgrade.upgradeDesc 		= "Get tier 2"             		// Description of the upgrade
Tier2Upgrade.upgradeTechId 		= kTechId.TwoHives  				// techId of the upgrade, default is kTechId.Move cause its the first 

function Tier2Upgrade:Initialize()

	FactionsAlienUpgrade.Initialize(self)
	
	self.cost = Tier2Upgrade.cost
	self.upgradeName = Tier2Upgrade.upgradeName
	self.upgradeTitle = Tier2Upgrade.upgradeTitle
	self.upgradeDesc = Tier2Upgrade.upgradeDesc
	self.upgradeTechId = Tier2Upgrade.upgradeTechId
	
end

function Tier2Upgrade:GetClassName()
	return "Tier2Upgrade"
end

function Tier2Upgrade:OnAdd(player)
	player:SendDirectMessage("Unlocked Tier 2 abilities!")
	player.
end