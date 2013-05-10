//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_XenoswarmGamerules.lua

Script.Load("lua/Factions/Factions_GenericGamerules.lua")

class 'XenoswarmGamerules' (GenericGamerules)

XenoswarmGamerules.kMapName = "xenoswarm_gamerules"

local kGameEndCheckInterval = 0.75
local kMaxDifficulty = 10

local networkVars =
{
	timeLeft = "time",
	difficulty = "integer (0 to " .. kMaxDifficulty .. ")",
}

if Server then

	function XenoswarmGamerules:OnCreate()
	
		self.isMarinevsMarine = false
		self.isCompetitive = false
		self.isClassBased = true
		self.isCombatRules = true
		self.isFactionsMovement = true
		self.usesMarineColours = true
		self.usesAlienColours = false
		self.lightsStartOff = false
		self.powerPointsTakeDamage = false
		self.factionsGameType = kFactionsGameType.Xenoswarm
	
		GenericGamerules.OnCreate(self)
		
	end

	function XenoswarmGamerules:GetGameModeName()
		return "Xenoswarm"
	end
	
	function XenoswarmGamerules:GetGameModeText()
		return { "Defend your command station against waves of marauding enemies!" }
	end

	local overrideResetGame = GenericGamerules.ResetGame
	function XenoswarmGamerules:ResetGame()
		
		overrideResetGame(self)
		
		self.timeLeft = kInitialTimeLeft
		
		// Lock the command chairs
		self:LockCommandChairs()
		self.difficulty = self.team1:GetNumPlayersWithAnyClass()
		
	end
	
	// Override the game start condition. The games should start when both teams have players.
	function XenoswarmGamerules:CheckGameStart()

		if self:GetGameState() == kGameState.NotStarted or self:GetGameState() == kGameState.PreGame then
			
			// Start pre-game when both teams have players or when once side does if cheats are enabled
			local team1Players = self.team1:GetNumPlayersWithAnyClass()
				
			if (team1Players > 0) then
				
				if self:GetGameState() == kGameState.NotStarted then
					self:SetGameState(kGameState.PreGame)
				end
					
			elseif self:GetGameState() == kGameState.PreGame then
				self:SetGameState(kGameState.NotStarted)
			end
				
		end
        
    end
	
	function XenoswarmGamerules:CheckGameEnd()
    
        if self:GetGameStarted() and self.timeGameEnded == nil and not Shared.GetCheatsEnabled() and not self.preventGameEnd then
        
            if self.timeLastGameEndCheck == nil or (Shared.GetTime() > self.timeLastGameEndCheck + kGameEndCheckInterval) then
            
                local team1Lost = self.team1:GetHasTeamLost()
                local team1Won = self.team1:GetHasTeamWon()
                
                local team1Players = self.team1:GetNumPlayers()
                
                if (team1Lost and team1Won) then
                    self:DrawGame()
                elseif team1Lost then
                    self:EndGame(self.team2)
                elseif team1Won then
                    self:EndGame(self.team1)
                end
                
                self.timeLastGameEndCheck = Shared.GetTime()
                
            end
            
        end
        
    end

end

function XenoswarmGamerules:GetDifficulty()

	return self.difficulty

end

function XenoswarmGamerules:SetDifficulty(newDifficulty)

	self.difficulty = newDifficulty
	kNPCDamageModifier = 0.1 + (0.05 * self.difficulty)
	SendGlobalChatMessage("Difficulty set to " .. self.difficulty .. " / " .. kMaxDifficulty)

end

function XenoswarmGamerules:IncreaseDifficulty()

	local newDifficulty = self:GetDifficulty() + 1
	self:SetDifficulty(newDifficulty)

end

function XenoswarmGamerules:DecreaseDifficulty()

	local newDifficulty = self:GetDifficulty() - 1
	self:SetDifficulty(newDifficulty)

end

function XenoswarmGamerules:JoinTeam(player, newTeamNumber, force)
	
	local oldTeamNumber = player:GetTeamNumber()
	
	local success, newPlayer = GenericGamerules.JoinTeam(self, player, newTeamNumber, force)
	
	if success then
	
		// Adjust the difficulty if a player joins or leaves team 1
		Print("oldTeamNumber: " .. oldTeamNumber .. " newTeamNumber " .. newTeamNumber)
		if oldTeamNumber ~= kTeam1Index and newTeamNumber == kTeam1Index then
			// Increase the difficulty.
			self:IncreaseDifficulty()
		elseif oldTeamNumber == kTeam1Index and newTeamNumber ~= kTeam1Index then
			self:DecreaseDifficulty()
		end
		
	end

end

// We definitely need to add some more logic here.
function XenoswarmGamerules:OnClientDisconnect(client)
	GenericGamerules.OnClientDisconnect(self, client)
end

function XenoswarmGamerules:ResetDifficulty()

	self:SetDifficulty(0)

end

// Enforce unbalanced teams!
function XenoswarmGamerules:GetCanJoinTeamNumber(teamNumber)

	if teamNumber == kTeam1Index then
		return true
	else
		return false
	end

end

Shared.LinkClassToMap("XenoswarmGamerules", XenoswarmGamerules.kMapName, networkVars)