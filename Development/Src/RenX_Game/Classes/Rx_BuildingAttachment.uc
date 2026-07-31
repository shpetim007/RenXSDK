class Rx_BuildingAttachment extends Actor
implements(RxIfc_TargetedSubstitution)
implements(RxIfc_Targetable)
implements(RxIfc_TargetedDescription);

var const string            SpawnName;
var const string            SocketPattern;  // What is matched to see if this attachment is spawned on a socket
var Rx_Building_Internals   OwnerBuilding;
var bool                    bDamageParent;  // if true any damage this attachment takes is applied to the owning building
var bool 					bTakeRadiusDamage;
var bool                    bHealParent;    // if true any healing this attachment takes is applied to the owning building
var bool                    bAttachmentDebug;
var bool                    bSpawnOnClient;

var float LightCullRange, MeshCullRange;
var bool bLightCull;

replication
{
   if ( bNetInitial && Role==ROLE_Authority )
	  OwnerBuilding;
}

simulated function Init( Rx_Building_Internals inBuilding, optional name SocketName )
{
	SetOwner(inBuilding);
	OwnerBuilding = inBuilding;
	bAttachmentDebug = OwnerBuilding.bBuildingDebug;
}

simulated function SetMeshCulled(bool NewCulled)
{
	local MeshComponent MeshComp;

	ForEach ComponentList(class'MeshComponent', MeshComp)
	{
		MeshComp.SetHidden(NewCulled);
	}
}

simulated function SetLightCulled(bool NewCulled)
{
	local LightComponent Light;

	bLightCull = NewCulled;

	ForEach ComponentList(class'LightComponent', Light)
	{
		if(Light.bEnabled != !NewCulled)
			Light.SetEnabled(!NewCulled);
	}
}

simulated function Actor GetActualActorTarget()
{
	return OwnerBuilding;
}
simulated function bool ShouldSubstitute()
{
	return true;
}

event TakeDamage( int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser )
{
	if ( bDamageParent )
	{
		OwnerBuilding.TakeDamage(DamageAmount,EventInstigator,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);
	}		
}

simulated function TakeRadiusDamage
(
	Controller			InstigatedBy,
	float				BaseDamage,
	float				DamageRadius,
	class<DamageType>	DamageType,
	float				Momentum,
	vector				HurtOrigin,
	bool				bFullDamage,
	Actor               DamageCauser,
	optional float      DamageFalloffExponent=1.f
)
{
	if (bTakeRadiusDamage)
	{
		super.TakeRadiusDamage(InstigatedBy, BaseDamage, DamageRadius, DamageType, Momentum, HurtOrigin, bFullDamage, DamageCauser, DamageFalloffExponent);
	}
}

simulated function byte GetTeamNum() 
{
	if (OwnerBuilding != none && OwnerBuilding.BuildingVisuals != none)
		return OwnerBuilding.BuildingVisuals.GetTeamNum();
	else if (OwnerBuilding != none)
		return OwnerBuilding.GetTeamNum();
	else 
		return super.GetTeamNum();
}

simulated function float getBuildingHealthPct()
{
	if (OwnerBuilding != none)
	{
		if(OwnerBuilding.GetMaxArmor() <= 0) return float(OwnerBuilding.GetHealth()) / float(OwnerBuilding.GetMaxHealth());	
			
		if(OwnerBuilding.GetMaxArmor() > 0) return float(OwnerBuilding.GetHealth()) / float(OwnerBuilding.GetTrueMaxHealth()); //Used to visually display a full bar. 
	
	}
	else return -1;
}

simulated function float getBuildingHealthMaxPct()
{
	if (OwnerBuilding != none)
	{
			if(OwnerBuilding.GetMaxArmor() <= 0) return float(OwnerBuilding.GetMaxHealth() - OwnerBuilding.GetMaxArmor()) / float(OwnerBuilding.GetMaxHealth());	
			
			if(OwnerBuilding.GetMaxArmor() > 0) return 1.0f ; //Used to visually display a full bar. 
	}
	else return -1;
}

simulated function float getBuildingArmorPct()
{
	if (OwnerBuilding != none)
	{
		return float(OwnerBuilding.GetArmor()) / float(OwnerBuilding.GetMaxArmor());
	}
	else return -1;
}

simulated function string GetHumanReadableName()
{
	if (OwnerBuilding != none && OwnerBuilding.BuildingVisuals != none)
	{
		return OwnerBuilding.BuildingVisuals.GetHumanReadableName();
	}
	else return super.GetHumanReadableName();
}

event bool HealDamage( int Amount, Controller Healer, class<DamageType> DamageType )
{
	if ( bHealParent )
	{
		return OwnerBuilding.HealDamage(Amount,Healer,DamageType);
	}
	return false;
}

/*-------------------------------------------*/
/*BEGIN TARGET INTERFACE [RxIfc_Targetable]*/
/*------------------------------------------*/
//Health
simulated function int GetTargetHealth() {return OwnerBuilding != None ? OwnerBuilding.GetHealth() : 1; } //Return the current health of this target
simulated function int GetTargetHealthMax() {return OwnerBuilding != None ? OwnerBuilding.GetMaxHealth() : 1;} //Return the current health of this target

//Armour 
simulated function int GetTargetArmour() {return OwnerBuilding != None ? OwnerBuilding.GetArmor() : 1;} // Get the current Armour of the target
simulated function int GetTargetArmourMax() {return OwnerBuilding != None ? OwnerBuilding.GetMaxArmor() : 1 ;} // Get the current Armour of the target 
simulated function bool GetHasResistance() {return false;} //If this unit has any kind of resistance

/*Get Health/Armour Percents*/
simulated function float GetTargetHealthPct() {return OwnerBuilding != None ? float(OwnerBuilding.GetHealth()) / max(1,float(OwnerBuilding.GetTrueMaxHealth())) : 1.0f;}
simulated function float GetTargetArmourPct() {return OwnerBuilding != None ? float(OwnerBuilding.GetArmor()) / max(1,float(OwnerBuilding.GetMaxArmor())) : 1.0f;}
simulated function float GetTargetMaxHealthPct() {return OwnerBuilding != None ? GetBuildingHealthMaxPct() : 1.0f ;} //Everything together (Basically Health and armour)

/*Get what we're actually looking at*/
simulated function Actor GetActualTarget() {return OwnerBuilding;} //Should return 'self' most of the time, save for things that should return something else (like building internals should return the actual building)

/*Booleans*/
simulated function bool GetUseBuildingArmour(){return OwnerBuilding.GetMaxArmor() > 0;} //Stupid legacy function to determine if we use building armour when drawing. 
simulated function bool GetShouldShowHealth(){return true;} //If we need to draw health on this 
simulated function bool AlwaysTargetable() {return false;} //Targetable no matter what range they're at
simulated function bool GetIsInteractable(PlayerController PC) {return false;} //Are we ever interactable?
simulated function bool GetCurrentlyInteractable(PlayerController RxPC) {return false;} //Are we interactable right now? 
simulated function bool GetIsValidLocalTarget(Controller PC) {return true;} //Are we a valid target for our local playercontroller?  (Buildings are always valid to look at (maybe stealthed buildings aren't?))
simulated function bool HasDestroyedState() {return true;} //Do we have a destroyed state where we won't have health, but can't come back? (Buildings in particular have this)
simulated function bool UseDefaultBBox() {return false;} //We're big AF so don't use our bounding box 
simulated function bool IsStickyTarget() {return false;} //Does our target box 'stick' even after we're untargeted for awhile 

//Spotting
simulated function bool IsSpottable() {return true;}
simulated function bool IsCommandSpottable() {return false;} 

simulated function bool IsSpyTarget(){return false;} //Do we use spy mechanics? IE: our bounding box will show up friendly to the enemy [.... There are no spy Refineries...... Or are there?]

/* Text related */

simulated function string GetTargetName() {return GetHumanReadableName();} //Get our targeted name 
simulated function string GetInteractText(Controller C, string BindKey) {return "";} //Get the text for our interaction 
simulated function string GetTargetedDescription(PlayerController PlayerPerspectiv) {return OwnerBuilding.GetTargetedDescription(PlayerPerspectiv);} //Get any special description we might have when targeted 

//Actions
simulated function SetTargeted(bool bTargeted) ; //Function to say what to do when you're targeted client-side 

/*----------------------------------------*/
/*END TARGET INTERFACE [RxIfc_Targetable]*/
/*---------------------------------------*/

simulated function SetAllCollision(bool bEnable)
{
	if(bEnable)
	{	
		SetCollisionType(COLLIDE_BLOCKALL);
		SetCollision(true,true); 
	}
	else
	{
		SetCollisionType(COLLIDE_NoCollision);
		SetCollision(false,false); 
	}
	
}

static function bool GetAllowedToSpawn(Actor Spawner)
{
	return true; 
}

DefaultProperties
{
	TickGroup=TG_DuringAsyncWork
	bDamageParent   		= True
	bTakeRadiusDamage 		= True
	bHealParent     		= True
	bAlwaysRelevant     	= True
	bOnlyDirtyReplication 	= True
	NetUpdateFrequency  	= 10
	bSpawnOnClient          = False

	// 0 range disables this feature
	// for optimization, this feature is handled in internals
	LightCullRange = 0
	MeshCullRange = 0
}
