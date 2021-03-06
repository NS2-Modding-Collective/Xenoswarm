//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_Balance.lua

// Game rules
kInitialTimeLeft = 25
kInitialTokenValue = 500

// Sprinting
SprintMixin.kMaxSprintTime = 7 // 1 sec
SprintMixin.kSprintRecoveryRate = .5 // 0.5 sec

// Spawning logic
kRespawnTimer = 8
kSpawnMaxRetries = 50
kSpawnMinDistance = 2
kSpawnMaxDistance = 70
kSpawnMaxVertical = 30
kSpawnProtectDelay = 0.1
kSpawnProtectTime = 2
kNanoShieldDamageReductionDamage = 0.1

// MARINE DAMAGE VALUES
kRifleDamage = 20
kRifleDamageType = kDamageType.Normal
SetCachedTechData(kTechId.Rifle, kTechDataDamageType, kRifleDamageType)
kRifleClipSize = 30

kLightMachineGunWeight = 0.05
kLightMachineGunDamage = 15
kLightMachineGunClipSize = 50
kLightMachineGunDamageType = kDamageType.Light
kLightMachineGunCost = 10

kPistolDamage = 30
kPistolDamageType = kDamageType.Normal
SetCachedTechData(kTechId.Pistol, kTechDataDamageType, kPistolDamageType)
kPistolClipSize = 8

kWelderDamagePerSecond = 60
kWelderDamageType = kDamageType.Flame
SetCachedTechData(kTechId.Welder, kTechDataDamageType, kWelderDamageType)
kWelderFireDelay = 0.2

kAxeDamage = 45
kAxeDamageType = kDamageType.Structural
SetCachedTechData(kTechId.Axe, kTechDataDamageType, kAxeDamageType)

kKnifeWeight = 0.05
kKnifeDamage = 65
kKnifeRange = 2 // Axe range is 1
kKnifeDamageType = kDamageType.Structural
kKnifeCost = 10

kSwordWeight = 0.05
kSwordDamage = 100
kSwordRange = 3
kSwordDamageType = kDamageType.Normal
kSwordCost = 10

kGrenadeLauncherGrenadeDamage = 100
kGrenadeLauncherClipSize = 4
kGrenadeLauncherGrenadeDamageRadius = 8
kGrenadeLifetime = 2.0

kShotgunDamage = 16
kShotgunClipSize = 5
kShotgunBulletsPerShot = 15
kShotgunRange = 40

kNadeLauncherClipSize = 4

kFlamethrowerDamage = 7.5
kFlamethrowerClipSize = 30

kBurnDamagePerStackPerSecond = 3
kFlamethrowerMaxStacks = 20
kFlamethrowerBurnDuration = 6
kFlamethrowerStackRate = 0.4
kFlameRadius = 1.8
kFlameDamageStackWeight = 0.5

kMinigunDamage = 25
kMinigunDamageType = kDamageType.Heavy
kMinigunClipSize = 250

kClawDamage = 50
kClawDamageType = kDamageType.Structural

kRailgunDamage = 50
kRailgunChargeDamage = 100
kRailgunDamageType = kDamageType.Puncture

kHandheldRailgunDamage = 50
kHandheldRailgunChargeDamage = 100
kHandheldRailgunDamageType = kDamageType.Puncture
kHandheldRailgunCost = 20
kHandheldRailgunWeight = kRifleWeight

kMineDamage = 150

// Player Health values
kInjuredPlayerMaxHealth = 3000
kInjuredPlayerMaxArmor = 1000
kInjuredPlayerInitialHealth = 2000
kInjuredPlayerInitialArmor = 500
kInjuredPlayerHealthDrainRate = 30
kInjuredPlayerHealthDrainInterval = 1.0

// Power points
kPowerPointHealth = 1000	
kPowerPointArmor = 400	
kPowerPointPointValue = 0

// Sentries
kSentryAttackBaseROF = .15
kSentryAttackRandROF = 0.0
kSentryAttackBulletsPerSalvo = 1
kConfusedSentryBaseROF = 2.0
kSentryDamage = 15

// Railgun Sentries
kRailgunSentryAttackBaseROF = 1.0
kRailgunSentryAttackRandROF = 0.0
kRailgunSentryAttackBulletsPerSalvo = 1
kConfusedSentryBaseROF = 2.0
kRailgunSentryDamage = 100
kNumRailgunSentriesPerPlayer = 1

// Building
kNumSentriesPerPlayer = 2
kSentryCost = 100
kSentryBuildTime = 3
kPhaseGateCost = 350
kPhaseGateBuildTime = 6
kNumPhasegatesPerPlayer = 1
kArmoryCost = 200
kArmoryBuildTime = 5
kNumArmoriesPerPlayer = 1
kObservatoryCost = 100
kObservatoryBuildTime = 7
kNumObservatoriesPerPlayer = 1

// Resupply
kResupplyInterval = 14

kWeapons1DamageScalar = 1.1
kWeapons2DamageScalar = 1.2
kWeapons3DamageScalar = 1.3

kNanoShieldDamageReductionDamage = 0.5

// The rate at which players gain XP for healing... relative to damage dealt.
kHealXpRate = 1
// Rate at which players gain XP for healing other players...
kPlayerHealXpRate = 0

// Xenoswarm-specific stuff
Hive.kDefenseNpcClass = Lerk.kMapName
Hive.kDefenseNpcAmount = 3
Hive.kDefenseNpcBaseDifficulty = 6

// EEM overrides here
kBaseNpcDamage = 0.1
kNpcDamageDifficultyIncrease = 0.025