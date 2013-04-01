//________________________________
//
//   	NS2 Single-Player Mod   
//  	Made by JimWest, 2012
//
//________________________________

Script.Load("lua/FunctionContracts.lua")
Script.Load("lua/PathingUtility.lua")

NpcFadeMixin = CreateMixin( NpcFadeMixin )
NpcFadeMixin.type = "NpcFade"

NpcFadeMixin.expectedMixins =
{
    Npc = "Required to work"
}

NpcFadeMixin.expectedCallbacks =
{
}


NpcFadeMixin.networkVars =  
{
}


function NpcFadeMixin:__initmixin()   
end

// use shadow step sometimes
function NpcFadeMixin:AiSpecialLogic()
    local order = self:GetCurrentOrder()
    if order then
        // shadow step will bring you 8 miles forward
//        self:PressButton(Move.MovementModifier)
    end
end

function NpcFadeMixin:GetAttackDistanceOverride()
    return SwipeBlink.kRange
end

function NpcFadeMixin:CheckImportantEvents()
end





