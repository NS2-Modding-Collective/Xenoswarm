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
Script.Load("lua/ProjectTitan/Titan_Globals.lua")
Script.Load("lua/ProjectTitan/Titan_Balance.lua")

// Extra Entities
Script.Load("lua/ExtraEntitiesMod/eem_Globals.lua")
Script.Load("lua/ExtraEntitiesMod/eem_Utility.lua")
Script.Load("lua/ExtraEntitiesMod/NS2Gamerules_hook.lua")
Script.Load("lua/ExtraEntitiesMod/TeleportTrigger.lua")
Script.Load("lua/ExtraEntitiesMod/FuncTrain.lua")
Script.Load("lua/ExtraEntitiesMod/FuncTrainWaypoint.lua")
Script.Load("lua/ExtraEntitiesMod/FuncMoveable.lua")
Script.Load("lua/ExtraEntitiesMod/FuncDoor.lua")
Script.Load("lua/ExtraEntitiesMod/PushTrigger.lua")
Script.Load("lua/ExtraEntitiesMod/PortalGunTeleport.lua")
Script.Load("lua/ExtraEntitiesMod/LogicTimer.lua")
Script.Load("lua/ExtraEntitiesMod/LogicMultiplier.lua")
Script.Load("lua/ExtraEntitiesMod/LogicWeldable.lua")
Script.Load("lua/ExtraEntitiesMod/LogicFunction.lua")
Script.Load("lua/ExtraEntitiesMod/LogicCounter.lua")
Script.Load("lua/ExtraEntitiesMod/LogicTrigger.lua")
Script.Load("lua/ExtraEntitiesMod/LogicLua.lua")
Script.Load("lua/ExtraEntitiesMod/MapSettings.lua")
Script.Load("lua/ExtraEntitiesMod/NobuildArea.lua")
Script.Load("lua/ExtraEntitiesMod/PortalGun.lua")

Script.Load("lua/ExtraEntitiesMod/eem_MovementModifier.lua")

// Class overrides here
Script.Load("lua/ProjectTitan/Titan_NS2Gamerules.lua")
Script.Load("lua/ProjectTitan/Titan_Marine.lua")
Script.Load("lua/ProjectTitan/Titan_Pistol.lua")
Script.Load("lua/ProjectTitan/Titan_Shotgun.lua")

// New classes here
Script.Load("lua/ProjectTitan/Titan_CombatDeathmatchGamerules.lua")