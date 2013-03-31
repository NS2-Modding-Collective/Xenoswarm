//________________________________
//
//   	NS2 Single-Player Mod   
//  	Made by JimWest, 2012
//
//________________________________

// Adpeted from them original Ns2 Bot

Script.Load("lua/FunctionContracts.lua")
Script.Load("lua/PathingUtility.lua")
Script.Load("lua/PathingMixin.lua")
Script.Load("lua/TargetCacheMixin.lua")

Script.Load("lua/ExtraEntitiesMod/npc/NpcMarineMixin.lua")
Script.Load("lua/ExtraEntitiesMod/npc/NpcSkulkMixin.lua")
Script.Load("lua/ExtraEntitiesMod/npc/NpcLerkMixin.lua")
Script.Load("lua/ExtraEntitiesMod/npc/NpcFadeMixin.lua")
Script.Load("lua/ExtraEntitiesMod/npc/NpcGorgeMixin.lua")
Script.Load("lua/ExtraEntitiesMod/npc/NpcOnosMixin.lua")

NpcMixin = CreateMixin( NpcMixin )
NpcMixin.type = "Npc"

NpcMixin.kPlayerFollowDistance = 3
NpcMixin.kMaxOrderDistance = 3

NpcMixin.kMinAttackGap = 0.6
NpcMixin.kJumpRange = 2

// update rates to increase performance
NpcMixin.kUpdateRate = 0.01
NpcMixin.kTargetUpdateRate = 0.5
NpcMixin.kRangeUpdateRate = 2



NpcMixin.expectedMixins =
{
}

NpcMixin.expectedCallbacks =
{
}


NpcMixin.optionalCallbacks =
{
}


NpcMixin.networkVars =  
{
}


function NpcMixin:__initmixin() 

    if Server then
        InitMixin(self, PathingMixin) 
        InitMixin(self, TargetCacheMixin) 
        
        self.active = false  
        if self.startsActive then
            self.active = true
        end
    
        if self.name1 then
            self:SetName(self.name1)
        end
        
        if self.team then
            self:SetTeamNumber(self.team)
        end
        
        table.insert(self:GetTeam().playerIds, self:GetId())
        self:DropToFloor()    
                
        // configure how targets are selected and validated
        //attacker, range, visibilityRequired, targetTypeList, filters, prioritizers
        self.targetSelector = TargetSelector():Init(
            self,
            40, 
            true,
            self:GetTargets(),
            //{self.FilterTarget(self)},
            { CloakTargetFilter(), self.FilterTarget(self)},
            //{ function(target) return target:isa("Player") end })
            { function(target) return target:isa("Player") end } )


        InitMixin(self, StaticTargetMixin)
        
        // special Mixins
        if self:isa("Marine") then
            InitMixin(self, NpcMarineMixin)   
        elseif self:isa("Skulk") then
            InitMixin(self, NpcSkulkMixin)
        elseif self:isa("Lerk") then
            InitMixin(self, NpcLerkMixin)
        elseif self:isa("Gorge") then
            InitMixin(self, NpcGorgeMixin)
        elseif self:isa("Fade") then
            InitMixin(self, NpcFadeMixin) 
        elseif self:isa("Onos") then
            InitMixin(self, NpcOnosMixin)      
        end

    end
    
end


function NpcMixin:GetTargets()

    local targets = {}
    if self:GetTeamNumber() == 1 then
        targets = {    
                kMarineStaticTargets, 
                kMarineMobileTargets}        
    else
        targets = {    
            kAlienStaticTargets, 
            kAlienMobileTargets}  
    end

    return targets
end


function NpcMixin:FilterTarget()
    local attacker = self
    return  function (target, targetPosition)
                // dont attack power points or team members
                return target:GetCanTakeDamage() and target:GetTeamNumber() ~= self:GetTeamNumber() and not target:isa("PowerPoint")
                    /*
                    local minePos = self:GetEngagementPoint()
                    local weapon = self:GetActiveWeapon()
                    if weapon then
                        minePos = weapon:GetEngagementPoint()
                    end
                    local targetPos = target:GetEngagementPoint()
                    
                    // Make sure we can see target
                    local filter = EntityFilterAll()
                    local trace = Shared.TraceRay(minePos, targetPos , CollisionRep.Damage, PhysicsMask.Bullets, filter)
                    return ((trace.entity == target) or not GetWallBetween(minePos, targetPos, target) or GetCanSeeEntity(self, target))
                    */
            end
            
end
    

function NpcMixin:Reset() 
    if self.startsActive then
        self.active = true
    else
        self.active = false
    end
end


function NpcMixin:OnKill()
end


function NpcMixin:OnLogicTrigger(player) 
    self.active = not self.active
end

// Brain of the npc
// 1. generate move
// 2. check special logic
// 3. check important events like health is low, getting attacked etc.
// 4. if no waypoint check if we get one
// 5. process the order, generate a forward move, shoot etc.Accept
// 6. send the move to OnProcessMove(move)
function NpcMixin:OnUpdate(deltaTime)
  
    if self.isaNpc then
        if Server then    
        
            // this will generate an input like a normal client so the bot can move
            //local updateOK = not self.timeLastUpdate or ((Shared.GetTime() - self.timeLastUpdate) > NpcMixin.kUpdateRate) 
            local updateOK = true
            self:GenerateMove(deltaTime)
            if self.active and updateOK and self:GetIsAlive() then
                self:AiSpecialLogic()
                // not working atm
                self:CheckImportantEvents() 
                self:ChooseOrder()
                self:ProcessOrder()         
                // Update order values for client
                self:UpdateOrderVariables()                                 
                self.timeLastUpdate = Shared.GetTime()
            end
            
            assert(self.move ~= nil)
            self:OnProcessMove(self.move)
        end
    else
        // controlled by a client, do nothing
    end

end

////////////////////////////////////////////////////////
//      Movement-Things
////////////////////////////////////////////////////////

function NpcMixin:GenerateMove(deltaTime)

    self.move = Move()    
    // keep the current yaw/pitch as default
    self.move.yaw = self:GetAngles().yaw
    self.move.pitch = self:GetAngles().pitch    
    self.move.time = deltaTime

end

function NpcMixin:AiSpecialLogic()
end

function NpcMixin:CheckImportantEvents()
end

function NpcMixin:ChooseOrder()

    // don't search for targets if neutral
    if self:GetTeam() ~= 0 then
        self:FindVisibleTarget()
    end
    
    order = self:GetCurrentOrder()
    // try to reach the mapWaypoint
    if not order and self.mapWaypoint then
        local waypoint = Shared.GetEntity(self.mapWaypoint)
        if waypoint then
            self:GiveOrder(kTechId.Move , waypoint:GetId(), waypoint:GetOrigin(), nil, true, true)
        end
    end   
    
    
end


function NpcMixin:ProcessOrder()

    self:UpdateWeaponMove()  
    local order = self:GetCurrentOrder() 
    if order then 
        local orderLocation = order:GetLocation()
        
        // Check for moving targets. This isn't done inside Order:GetLocation
        // so that human players don't have special information about invisible
        // targets just because they have an order to them.
        if (order:GetType() == kTechId.Attack) then
            local target = Shared.GetEntity(order:GetParam())
            if (target ~= nil) then
                orderLocation = target:GetEngagementPoint()
            end
        end
        
        self:MoveToPoint(orderLocation)
        
    end

end


function NpcMixin:UpdateOrderVariables()
    local order = self:GetCurrentOrder() 
    if order then
        self.orderPosition = Vector(order:GetLocation())
        self.orderType = order:GetType()   
    end
end

function NpcMixin:GoToNearbyEntity()
    return false
end


function NpcMixin:MoveRandomly()

    assert(self.move ~= nil)
    // Jump up and down crazily!
    if self.active and Shared.GetRandomInt(0, 100) <= 5 then
        self.move.commands = bit.bor(self.move.commands, Move.Jump)
    end
    
    return true
    
end

function NpcMixin:ChooseRandomDestination()

    assert(self.move ~= nil)
    // Go to nearest unbuilt tech point or nozzle
    local className = ConditionalValue(math.random() < .5, "TechPoint", "ResourcePoint")

    local ents = Shared.GetEntitiesWithClassname(className)
    
    if ents:GetSize() > 0 then 
    
        local index = math.floor(math.random() * ents:GetSize())
        
        local destination = ents:GetEntityAtIndex(index)
        
        self:GiveOrder(kTechId.Move, 0, destination:GetEngagementPoint(), nil, true, true)
        
        return true
        
    end
    
    return false
    
end

function NpcMixin:CheckCrouch(targetPosition)
end

function NpcMixin:MoveToPoint(toPoint)

    assert(self.move ~= nil)
    local order = self:GetCurrentOrder()
    toPoint = self:GetNextPoint(order, toPoint) or toPoint
    // Fill in move to get to specified point
    local diff = (toPoint - self:GetEyePos())
    local direction = GetNormalizedVector(diff)
        
    // Look at target (needed for moving and attacking)
    self.move.yaw   = GetYawFromVector(direction) - self:GetBaseViewAngles().yaw
    self.move.pitch = GetPitchFromVector(direction)
    
    local moved = false
    
    // Generate naive move towards point
    if not self.toClose and not self.inTargetRange then
        self.move.move.z = 1  
        moved = true
    elseif self.toClose then
        // test wheres place to go
        local startPoint = self:GetEyePos()
        local viewAngles = self:GetViewAngles() 
        local fowardCoords = viewAngles:GetCoords()
        local trace = Shared.TraceRay(startPoint, startPoint + (fowardCoords.zAxis * -5), CollisionRep.LOS, PhysicsMask.AllButPCs, EntityFilterOne(self))        
        if (trace.endPoint - startPoint):GetLength() >= 1 then
            // enough space, move back
            self.move.move.z = -1     
        else
            // move left or right (random)
            if math.random(1,2) == 1 then
                self.move.move.x = -1
            else
                self.move.move.x = 1
            end
        end
        
        if self:GetCanJump() and (self:GetOrigin() - toPoint):GetLengthXZ() < NpcMixin.kJumpRange then
            // sometimes jump (real players do that, too)
            if Shared.GetRandomInt(0, 80) <= 5 then
                self.move.commands = bit.bor(self.move.commands, Move.Jump)
            end
        end
        moved = true       
        
    else
        self:CheckCrouch(toPoint)
    end
    
    if moved and not self.target then
        self.targetSelector:AttackerMoved()
    end

end

function NpcMixin:OnOrderGiven()
    // delete old values
    self:ResetOrderParamters()
end

function NpcMixin:DeleteCurrentOrder()
    self:CompletedCurrentOrder()
end

function NpcMixin:OnOrderComplete(currentOrder)
    self:ResetOrderParamters()
end

function NpcMixin:ResetOrderParamters()
    local currentOrder = self:GetCurrentOrder()
    if currentOrder then
        if self.mapWaypoint == currentOrder:GetId() or self.mapWaypoint == currentOrder:GetParam() then
            self.mapWaypoint = nil
        end
        
        if currentOrder:GetParam() ~= self.target then
            self.target = nil
        end
    end
    
    self:ResetPath()

    self.toClose = false
    self.inTargetRange = false
    
end

////////////////////////////////////////////////////////
//      Attack-Things
////////////////////////////////////////////////////////

function NpcMixin:GetAttackDistance()

    if self.GetAttackDistanceOverride then
        return self:GetAttackDistanceOverride()
    else
        local activeWeapon = self:GetActiveWeapon()
        
        if activeWeapon then
            return math.min(activeWeapon:GetRange(), 40)
        end
    end
    
    return NpcMixin.kMinAttackGap
    
end

function NpcMixin:FindVisibleTarget()

    // Are there any visible enemy players or structures nearby?
    local success = false

    if not self.target and (not self.timeLastTargetCheck or (Shared.GetTime() - self.timeLastTargetCheck > NpcMixin.kTargetUpdateRate)) then 

        local target = self.targetSelector:AcquireTarget()
 
    /*
        local nearestTarget = nil
        local nearestTargetDistance = nil
        
        local targets = GetEntitiesWithMixinForTeamWithinRange("Live", GetEnemyTeamNumber(self:GetTeamNumber()), self:GetOrigin(), 60)
        for index, target in pairs(targets) do
        
            // for sp, dont attack power nodes
            if (not HasMixin(target, "PowerSourceMixin") and target:GetIsAlive() and target:GetIsVisible() and target:GetCanTakeDamage() and target ~= self ) then                     
                local minePos = self:GetEngagementPoint()
                local weapon = self:GetActiveWeapon()
                if weapon then
                    minePos = weapon:GetEngagementPoint()
                end
                local targetPos = target:GetEngagementPoint()
                
                // Make sure we can see target
                local filter = EntityFilterAll()
                local trace = Shared.TraceRay(minePos, targetPos , CollisionRep.Damage, PhysicsMask.Bullets, filter)
                if trace.entity == target or not GetWallBetween(minePos, targetPos, target) or GetCanSeeEntity(self, target) then  
            
                    // Prioritize players over non-players
                    local dist = (target:GetEngagementPoint() - self:GetModelOrigin()):GetLength()
                    
                    local newTarget = (not nearestTarget) or (target:isa("Player") and not nearestTarget:isa("Player"))
                    if not newTarget then
                    
                        if dist < nearestTargetDistance then
                            newTarget = not nearestTarget:isa("Player") or target:isa("Player")
                        end
                        
                    end
                    
                    if newTarget then
                    
                        nearestTarget = target
                        nearestTargetDistance = dist
                        
                    end
                    
                end
                
            end
            
        end
        
        self.target = nearestTarget
*/
        if target then
        
            self.target = target:GetId()
            
            local name = SafeClassName(target)
            if target:isa("Player") then
                name = target:GetName()
            end
            
            local engagementPoint = target:GetEngagementPoint()
            if self.EngagementPointOverride then
                engagementPoint = self:EngagementPointOverride(target) or engagementPoint
            end
            self:GiveOrder(kTechId.Attack, self.target, engagementPoint, nil, true, true)
            
            success = true
        end
        
        self.timeLastTargetCheck = Shared.GetTime()
        
    end
    
    return success
    
end


function NpcMixin:GetMinAttackGap() 

    if not self.minAttackGap then
        self.minAttackGap = NpcMixin.kMinAttackGap
    end 

    if (self:GetAttackDistance() > NpcMixin.kMinAttackGap) and (not self.timeLastRangeUpdate 
            or ((Shared.GetTime() -  self.timeLastRangeUpdate ) > NpcMixin.kRangeUpdateRate)) then
  
        // make it a bit random   
        if self:GetAttackDistance() > 10 then
            self.minAttackGap = math.random(4, 25)
        else
            self.minAttackGap = math.max(NpcMixin.kMinAttackGap, math.random(NpcMixin.kMinAttackGap, math.min(self:GetAttackDistance(), 8)))
        end
        
        self.timeLastRangeUpdate = Shared.GetTime()
    end   

    return self.minAttackGap 
    
end


function NpcMixin:CanAttackTarget(targetOrigin)
    return (targetOrigin - self:GetModelOrigin()):GetLength() < (self:GetAttackDistance() or 0)
end

function NpcMixin:UpdateWeaponMove()

    assert(self.move ~= nil)
    local order = self:GetCurrentOrder()             
    local activeWeapon = self:GetActiveWeapon()

    if order ~= nil then
        if (order:GetType() == kTechId.Attack) then
        
            local target = Shared.GetEntity(order:GetParam())
            if target then
                            
                // Attack target! TODO: We should have formal point where attack emanates from.
                local distToTarget = (target:GetEngagementPoint() - self:GetModelOrigin()):GetLength()
                local attackDist = self:GetAttackDistance()
                
                self.inTargetRange = false
                
                if activeWeapon and attackDist and (distToTarget < attackDist) then
 
                    // Make sure we can see target
                    local filter = EntityFilterTwo(self, activeWeapon)
                    local trace = Shared.TraceRay(self:GetEyePos(), target:GetEngagementPoint(), CollisionRep.Damage, PhysicsMask.Bullets, filter)
                    if trace.entity == target or (target:GetEngagementPoint() - trace.endPoint):GetLengthXZ() <= 2  then 
                        self.inTargetRange = true   
                        self:Attack(activeWeapon)                     
                    else
                        //Print("not in range")
                    end 
                    
                end
                
                // if its not a structure, dont come to close
                if HasMixin(target,"MobileTarget") and (distToTarget < self:GetMinAttackGap()) then
                    self.toClose = true
                else
                    self.toClose = false
                end  
            
            end  
        end
    else
        // if were a marine a have currently the pistol selected, switch back to rifle

    end
    
end

function NpcMixin:Attack(activeWeapon)
    assert(self.move ~= nil)
    if self.AttackOverride then
        self:AttackOverride(activeWeapon)
    else
        self.move.commands = bit.bor(self.move.commands, Move.PrimaryAttack)
    end        
end


function NpcMixin:OnTakeDamage(damage, attacker, doer, point)
    if Server then
        self.lastAttacker = attacker 
        local order = self:GetCurrentOrder()
        // if were getting attacked, attack back
        if not order or (order and (order:GetType() ~= kTechId.Attack or not Shared.GetEntity(order:GetParam()):isa("Player")) ) then
            self:GiveOrder(kTechId.Attack, attacker:GetId(), attacker:GetEngagementPoint(), nil, true, true)       
        end
    end
end


////////////////////////////////////////////////////////
//      Pathing-Things
////////////////////////////////////////////////////////


function NpcMixin:GetNextPoint(order, toPoint)
    if order:GetType() ~= kTechId.Attack or (not self.toClose and not self.inTargetRange) then
    //if order:GetType() ~= kTechId.Attack then
        // if its the same point, lets look if we can still move there
        if self.oldPoint and self.oldPoint == toPoint then
            // look if we're stucking
             

        else
            // delete current path cause its a new point           
            local location = GetGroundAt(self, toPoint, PhysicsMask.Movement)
            if self:GetIsFlying() then
                location = GetHoverAt(self, toPoint, EntityFilterOne(self))
            end
            if not self:GeneratePath(location) then
                // thers no path
                self:DeleteCurrentOrder()
            end  
        end  
                   
        self.oldPoint = toPoint 
            
        if self.points and #self.points ~= 0 then            

            if not self.index then
                self.index = 1
            end
            
            if self.index <= #self.points then
                toPoint = self.points[self.index]
                if self:CheckTargetReached(toPoint) then
                    // next point
                    self.index = self.index + 1
                end
            else
                // end point is reached
                self:DeleteCurrentOrder()
            end
        end
        
    end
    return toPoint
end


function NpcMixin:CheckTargetReached(endPoint)
    return (self:GetOrigin() - endPoint):GetLengthXZ() <= NpcMixin.kMaxOrderDistance 
end


function NpcMixin:GeneratePath(endPoint)
    self:ResetPath()
    self.points = GeneratePath(self:GetOrigin(), endPoint, false, 0.5, 2, self:GetIsFlying())
    if self.points and #self.points > 0 then
        return true
    else
        return false
    end
end

function NpcMixin:ResetPath()
    self.index = nil
    self.points = nil
    self.cursor = nil
end


if Server then

    function OnConsoleNpcActive(client)
        for i, npc in ipairs(GetEntitiesWithMixin("Npc")) do
            npc.active = true
        end
    end

    Event.Hook("Console_npc_active",  OnConsoleNpcActive)

end



