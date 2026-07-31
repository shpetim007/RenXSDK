class TS_Weapon_Binoculars extends TS_Weapon_Scoped;

defaultproperties
{
	bScopeDetectsEnemies = true;

  	bUseClientAmmo = false
	bRefillonPromotion = false 
	
	bUseHandIKWhenRelax=false
	bByPassHandIK=true

	FadeTime=0.3
	
	CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_None'
	CrosshairDotMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_None'
	HudMaterial=Material'RX_WP_Binoculars.Materials.M_BinocularScope'

	CrossHairCoordinates=(U=256,V=64,UL=64,VL=64)
	IconCoordinates=(U=726,V=532,UL=165,VL=51)

	bDisplaycrosshair = true;

	bZoomedFireMode(0)=0
	bZoomedFireMode(1)=1

	FiringStatesArray(0)=Deployment
	FiringStatesArray(1)=Active

	FireInterval(0)=+1.0
	FireInterval(1)=+0.0

	MaxDesireability=0.0
	AIRating=+0.6
	CurrentRating=0.0
	RespawnTime=1.0
	InventoryGroup=3
	InventoryMovieGroup=17

	WeaponIconTexture=Texture2D'rx_wp_proxyc4.UI.T_WeaponIcon_ProximityC4'

	GroupWeight=1
	
	AmmoCount=1
	MaxAmmoCount=1
	ClipSize=1
	InitalNumClips=1

	EquipTime=0.5
//	//PutDownTime=0.7

	WeaponRange=12000.0

	WeaponFireTypes(0)=EWFT_Custom
	//WeaponFireTypes(1)=EWFT_Custom
	ShotCost(0)=1
	ShotCost(1)=1

	ThirdPersonWeaponPutDownAnim="H_M_Beacon_PutDown"
	ThirdPersonWeaponEquipAnim="H_M_Beacon_Equip"
	
	ReloadAnim3PName(0) = "H_M_Beacon_Equip"
	ReloadAnim3PName(1) = "H_M_Beacon_Equip"
	
	BackWeaponAttachmentClass = class'Rx_BackWeaponAttachment_Airstrike_GDI'

	PlayerViewOffset=(X=20.0,Y=0.0,Z=-4.0)

   	ArmsAnimSet=AnimSet'RX_WP_Binoculars.Anims.AS_Binoculars_Arms'

	// Weapon SkeletalMesh
	Begin Object class=AnimNodeSequence Name=MeshSequenceA
	End Object
	
	// Weapon SkeletalMesh
	Begin Object Name=FirstPersonMesh
		SkeletalMesh=SkeletalMesh'RX_WP_Binoculars.Mesh.SK_Binoculars_1P'
		AnimSets(0)=AnimSet'RX_WP_Binoculars.Anims.AS_Binoculars_1P'
		Animations=MeshSequenceA
		Scale=2.0
		FOV=50.0
	End Object
	
	// Weapon SkeletalMesh
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'RX_WP_Binoculars.Mesh.SK_Binoculars_Back'
		Scale=1.0
	End Object

	bInstantZoom = true

	NightVisionEffect=PostProcessChain'TS_WP_GaussRifle.PostProcess.PP_ScopeChain'
    NightVisionAnim=CameraAnim'RenX_AssetBase.PostProcess.C_InfraredVision'

    //For scope wallhack ability 
	TI_Attack=(Texture = Texture2D'RenXTargetSystem.T_NavMarker_Max_Red', U= 0, V = 0, UL = 64, VL = 64)
	ScanDistance = 250 //Meters (~52.5uu)
}