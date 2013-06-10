//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Armory.lua

Script.Load("lua/Factions/Factions_TeamColoursMixin.lua")

local networkVars = {
}

AddMixinNetworkVars(TeamColoursMixin, networkVars)

// Team Colours
local overrideOnInitialized = Armory.OnInitialized
function Armory:OnInitialized()

	overrideOnInitialized(self)

	// Team Colours
	if GetGamerulesInfo():GetUsesMarineColours() then
		InitMixin(self, TeamColoursMixin)
		assert(HasMixin(self, "TeamColours"))
	end
	
	if Server and not HasMixin(self, "MapBlip") then
        InitMixin(self, MapBlipMixin)
    end
	
	self.isGhostStructure = false
	
end

function Armory:GetRequiresPower()
   return false
end

function Armory:GetCanBeUsedConstructed()
    return false
end    

Class_Reload("Armory", networkVars)