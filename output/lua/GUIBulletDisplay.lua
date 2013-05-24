// ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// lua\GUIBulletDisplay.lua
//
// Created by: Max McGuire (max@unknownworlds.com)
//
// Displays the current number of bullets and clips for the ammo counter on a bullet weapon
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

Script.Load("lua/GUIScript.lua")
Script.Load("lua/Utility.lua")

class 'GUIBulletDisplay' (GUIScript)

function GUIBulletDisplay:Initialize()

    self.weaponClip     = 0
    self.weaponAmmo     = 0
    self.weaponClipSize = 50
	self.weaponMaxAmmo  = self.weaponClipSize * 4
    
    self.onDraw = 0
    self.onHolster = 0

    self.background = GUIManager:CreateGraphicItem()
    self.background:SetSize( Vector(256, 512, 0) )
    self.background:SetPosition( Vector(0, 0, 0))    
    self.background:SetTexture("ui/RifleDisplay.dds")
    self.background:SetIsVisible(true)

    // Slightly larger copy of the text for a glow effect
    self.ammoTextBg = GUIManager:CreateTextItem()
    self.ammoTextBg:SetFontName("fonts/MicrogrammaDMedExt_large.fnt")
    self.ammoTextBg:SetFontIsBold(true)
    self.ammoTextBg:SetFontSize(135)
    self.ammoTextBg:SetTextAlignmentX(GUIItem.Align_Center)
    self.ammoTextBg:SetTextAlignmentY(GUIItem.Align_Center)
    self.ammoTextBg:SetPosition(Vector(135, 88, 0))
    self.ammoTextBg:SetColor(Color(1, 1, 1, 0.25))

    // Text displaying the amount of ammo in the clip
    self.ammoText = GUIManager:CreateTextItem()
    self.ammoText:SetFontName("fonts/MicrogrammaDMedExt_large.fnt")
    self.ammoText:SetFontIsBold(true)
    self.ammoText:SetFontSize(120)
    self.ammoText:SetTextAlignmentX(GUIItem.Align_Center)
    self.ammoText:SetTextAlignmentY(GUIItem.Align_Center)
    self.ammoText:SetPosition(Vector(135, 88, 0))
    
    self.flashInOverlay = GUIManager:CreateGraphicItem()
    self.flashInOverlay:SetSize( Vector(256, 512, 0) )
    self.flashInOverlay:SetPosition( Vector(0, 0, 0))    
    self.flashInOverlay:SetColor(Color(1,1,1,0.7))
    
    self:CreateClipIndicators()
    
    // Force an update so our initial state is correct.
    self:Update(0)

end

function GUIBulletDisplay:CreateClipIndicators()

	for index, clipIndicator in ipairs(self.clip) do
		GUI.DestroyItem(self.clipIndicator)
	end

    // Create the indicators for the number of bullets in reserve.
    self.clipTop    = 400 - 256
    self.clipHeight = 69
    self.clipWidthMax = 21
    self.clipLeft = 70
    self.clipAreaWidth = 200 - self.clipLeft
    
    self.numClips = math.ceil(self.weaponMaxAmmo / self.weaponClipSize)
    self.clip = { }
    
    for i = 1,self.numClips do
        self.clip[i] = GUIManager:CreateGraphicItem()
        self.clip[i]:SetTexture("ui/RifleDisplay.dds")
        local clipWidth = math.min(self.numClips / self.clipAreaWidth, self.clipWidthMax)
        self.clip[i]:SetSize( Vector(clip, self.clipHeight, 0) )
        self.clip[i]:SetBlendTechnique( GUIItem.Add )
        local clipLeft = self.clipLeft + (i * self.clipAreaWidth / math.min(self.numClips - 1, 0))
        self.clip[i]:SetPosition(Vector( clipLeft, self.clipTop, 0))
    end
    
end

function GUIBulletDisplay:InitFlashInOverLay()

end

function GUIBulletDisplay:Update(deltaTime)

    PROFILE("GUIBulletDisplay:Update")
    
    // Update the ammo counter.
    
    local ammoFormat = string.format("%02d", self.weaponClip) 
    self.ammoText:SetText( ammoFormat )
    self.ammoTextBg:SetText( ammoFormat )
    
    // Update the reserve clip.
    
    local reserveMax      		= self.weaponMaxAmmo
    local reserve         		= self.weaponAmmo
    local reserveFraction 		= reserve / self.weaponClipSize

    for i=1,self.numClips do
        self:SetClipFraction( i, Math.Clamp(reserveFraction - i + 1, 0, 1) )
    end
    
    local flashInAlpha = self.flashInOverlay:GetColor().a
    
    if flashInAlpha > 0 then
    
        local alphaPerSecond = .5        
        flashInAlpha = Clamp(flashInAlpha - alphaPerSecond * deltaTime, 0, 1)
        self.flashInOverlay:SetColor(Color(1, 1, 1, flashInAlpha))
        
    end

end

function GUIBulletDisplay:SetClip(weaponClip)
    self.weaponClip = weaponClip
end

function GUIBulletDisplay:SetMaxAmmo(weaponMaxAmmo)
    self.weaponMaxAmmo = weaponMaxAmmo
    self:CreateClipIndicators()
end

function GUIBulletDisplay:SetClipSize(weaponClipSize)
    self.weaponClipSize = weaponClipSize
    self:CreateClipIndicators()
end

function GUIBulletDisplay:SetAmmo(weaponAmmo)
    self.weaponAmmo = weaponAmmo
end

function GUIBulletDisplay:SetClipFraction(clipIndex, fraction)

    local offset   = (1 - fraction) * self.clipHeight
    local position = Vector( self.clip[clipIndex]:GetPosition().x, self.clipTop + offset, 0 )
    local size     = self.clip[clipIndex]:GetSize()
    
    self.clip[clipIndex]:SetPosition( position )
    self.clip[clipIndex]:SetSize( Vector( size.x, fraction * self.clipHeight, 0 ) )
    self.clip[clipIndex]:SetTexturePixelCoordinates( position.x, position.y + 256, position.x + self.clipWidth, self.clipTop + self.clipHeight + 256 )

end