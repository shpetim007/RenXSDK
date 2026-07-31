class OG_Weapon_TiberiumAutoRifle extends Rx_Weapon_TiberiumAutoRifle;


defaultproperties
{
		
	//-------------- Recoil
	RecoilDelay = 0.02
	MinRecoil = 0.0		//90.0
	MaxRecoil = 0.0		//140.0
	MaxTotalRecoil = 0.0	//5000.0
	RecoilYawModifier = 0.5 // will be a random value between 0 and this value for every shot
	RecoilInterpSpeed = 15.0
	RecoilDeclinePct = 0.4
	RecoilDeclineSpeed = 3.0
	MaxSpread = 0.0
	RecoilSpreadIncreasePerShot = 0.00075
	RecoilSpreadDeclineSpeed = 0.1
	RecoilSpreadDecreaseDelay = 0.3
	RecoilSpreadCrosshairScaling = 2000;

	EquipTime=2.0
	
	ClipSize = 50
	InitalNumClips = 5
	MaxClips = 5
	bHasInfiniteAmmo = false

	bIronSightCapable = false
	
	
	/** one1: Added. */
	BackWeaponAttachmentClass = class'OG_BackWeaponAttachment_TiberiumAutoRifle'
	
}