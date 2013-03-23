// ======= Copyright (c) 2003-2013, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// lua\Shared_Modded.lua
//
//    Created by:   Andreas Urwalek (andi@unknownworlds.com)
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

Script.Load("lua/ModUtility.lua")

// Locale hooks first
Script.Load("lua/Locale/OverrideLocale.lua")

// Then any files that adjust values go before the rest.
Script.Load("lua/Factions/Factions_TechTreeConstants.lua")
Script.Load("lua/Factions/Factions_Globals.lua")
Script.Load("lua/Factions/Factions_Balance.lua")

// Extra Entities
Script.Load("lua/ExtraEntitiesMod/eem_Shared.lua")

// NPCs
Script.Load("lua/sp/npcs/NpcSkulk.lua")
Script.Load("lua/sp/npcs/NpcMarine.lua")
Script.Load("lua/sp/npcs/NpcMarineExo.lua")

Script.Load("lua/sp/npcs/NpcSpawnerMarine.lua")
Script.Load("lua/sp/npcs/NpcSpawnerMarineExo.lua")
Script.Load("lua/sp/npcs/NpcSpawnerSkulk.lua")

// Class overrides here
Script.Load("lua/Factions/Factions_NS2Gamerules.lua")
Script.Load("lua/Factions/Factions_PlayingTeam.lua")
Script.Load("lua/Factions/Factions_CommandStructure.lua")
Script.Load("lua/Factions/Factions_Player.lua")
Script.Load("lua/Factions/Factions_Marine.lua")
Script.Load("lua/Factions/Factions_MarineSpectator.lua")
Script.Load("lua/Factions/Factions_JetpackMarine.lua")

// Buildings
Script.Load("lua/Factions/Factions_Armory.lua")
Script.Load("lua/Factions/Factions_CommandStation.lua")
Script.Load("lua/Factions/Factions_Extractor.lua")

// Weapons
Script.Load("lua/Factions/Weapons/Factions_Pistol.lua")
Script.Load("lua/Factions/Weapons/Factions_Rifle.lua")
Script.Load("lua/Factions/Weapons/Factions_Shotgun.lua")
Script.Load("lua/Factions/Factions_Mine.lua")

// New classes here
Script.Load("lua/Factions/Factions_GenericGamerules.lua")
Script.Load("lua/Factions/Factions_CombatDeathmatchGamerules.lua")
Script.Load("lua/Factions/Factions_XpMixin.lua")
Script.Load("lua/Factions/Weapons/Factions_LightMachineGun.lua")

// TechData
Script.Load("lua/Factions/Factions_TechData.lua")

// NetworkMessages
Script.Load("lua/Factions/Factions_NetworkMessages.lua")