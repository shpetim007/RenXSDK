class Rx_Targetable_KActor extends UTKActor
	placeable
	implements (RxIfc_TargetedSubstitution)
	implements(RxIfc_Targetable); 

var(Health) bool bShowHealth; //Whether to show a target reticle with health
var(Health) int HealthMax;
var(Health) bool bReplicateHealthToAll;  
var(TeamInfo)	byte	TeamIndex; 

var SoundCue ExplosionSound;

var bool bExplodes, bDoFullDamage; 

enum Armor
{
	ARM_Infantry,
	ARM_Light,
	ARM_Heavy,
	ARM_Building,
	ARM_Aircraft,
	ARM_Kevlar,
	ARM_FLAK,
	ARM_None
};

var(Health) Armor ArmorType; 
var float	ExplosionDamage, ExplosionRadius;
var bool	bDamageThroughWalls; 

var class<DamageType> 	DamageTypeClass; 
var(Health) bool				bLightArmor; //Just means whether this will take damage from bullets and normal weapons or not
var(Health) bool				bTakeRadiusDamage; 
var(Health) bool				bCanHeal;  

var(Health) bool bCanTakeDamage;

var CameraAnim          ExplosionShake;
var float               InnerExplosionShakeRadius;
var float               OuterExplosionShakeRadius;
var float				ExplosionShakeScale;
var ParticleSystem      ExplosionEffect;
var bool				bExplodeOnImpact;
var float				ExplosionScale; 

var float                DamageMomentum;
var	bool                 bDamageAll;

var string ActorName; 
var float DamageSmokeThreshold; 

var repnotify bool bExploded;

var float			SavedDmg; //Hold damage for low-impactweapons


var	float	AntiAirAttentionPulseTime; //Time between pulling the attention of enemy Anti air 

var	float	HealPointMod;

var bool	bDrawLocation;

var int		VPReward; 

var(TargetingBox) Actor TargetedActor;

var PhysicalMaterial MeshPhysMat; //Our actual Physical Material (not Parent)

replication
{	
   if (bNetDirty)
      bExploded, TeamIndex, bDrawLocation, bCanTakeDamage;
}

simulated event ReplicatedEvent(name VarName)
{
	
	if (VarName == 'bExploded')
	{
		if(bExploded) 
		{
			PlayExplosionEffect();
			SimulatedCleanup(); 
		}
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
}

simulated function InitKActor(byte NewTeamIndex, optional Vector StartingVelocity, optional bool bWakeRigidBody = true)
{
	if(Role == ROLE_Authority)
		TeamIndex = NewTeamIndex; 

	if(bWakeRigidBody)
		StaticMeshComponent.WakeRigidBody();
	
	if(VSizeSq(StartingVelocity) != 0)
		ApplyImpulse(StartingVelocity, VSize(StartingVelocity), location); 
}


simulated function string GetHumanReadableName()
{
	return ActorName;
}

simulated function PlayExplosionEffect()
{

   if (WorldInfo.NetMode != NM_DedicatedServer)
   {
      if (ExplosionSound != none)
      {
         PlaySound(ExplosionSound, true,,false);
      }
      
      SpawnExplosionEmitter(Location, Rotation);
	  PlayCamerashakeAnim();
    }
}

simulated function SpawnExplosionEmitter(vector SpawnLocation, rotator SpawnRotation)
{
	local ParticleSystemComponent MyExplosionEmitter;
	
	MyExplosionEmitter = WorldInfo.MyEmitterPool.SpawnEmitter(ExplosionEffect, SpawnLocation, SpawnRotation);
	
	SetExplosionEffectParams(MyExplosionEmitter);
}  

simulated function SetExplosionEffectParams(ParticleSystemComponent PSC)
{
	PSC.SetScale(ExplosionScale);
} 

simulated function Explosion(optional Controller EventInstigator) //By default they explode with no instigator, but can be told what the explosion should belong to
{
	local Pawn P;  
	  
	if(bExploded) 
		return; //Don't double dip on explosions
	  
	bExploded = true; 
	if (WorldInfo.NetMode != NM_DedicatedServer) //This is literally the most worthless line ever for network play
		PlayExplosionEffect();

	if(bExplodes && !bDamageThroughWalls)
	{
		foreach VisibleCollidingActors(class'Pawn', P, ExplosionRadius, Location, false)
		{
			P.TakeRadiusDamage(EventInstigator, ExplosionDamage, ExplosionRadius, DamageTypeClass != none ? DamageTypeClass : class'UTDmgType_Burning', DamageMomentum, location, bDoFullDamage, self);
		}
	}
	else if(bExplodes && bDamageThroughWalls)
	{
		foreach CollidingActors(class'Pawn', P, ExplosionRadius, Location, false)
		{
			P.TakeRadiusDamage(EventInstigator, ExplosionDamage, ExplosionRadius, DamageTypeClass != none ? DamageTypeClass : class'UTDmgType_Burning', DamageMomentum, location, bDoFullDamage, self);
		}
	}
	
	if(Health > 0) Health = 0; //So that everything knows we're irrelevant now
		
	SetTimer(0.01f, false, 'ToDestroy');
}

function ToDestroy()
{
   Destroy();
}

function InstaKill(optional Controller EventInstigator)
{
	if(EventInstigator !=none) TakeDamage(Health+100,EventInstigator,location,location,DamageTypeClass);
	else
	{
		Health=0; 
		Explosion(); 
	}
	
}

//Do not take Radius Damage
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
	if(!bTakeRadiusDamage) return; 
	
	if(InstigatedBy != None 
			&& (InstigatedBy.GetTeamNum() == GetTeamNum() && InstigatedBy != InstigatorController  && GetTeamNum() != 255) 
			&& Rx_Weapon_DeployedActor(DamageCauser) == None) {
		return;
	}	
	if(Rx_Weapon_DeployedActor(DamageCauser) != None)
	{
		if(InstigatedBy != InstigatorController && DamageCauser.GetTeamNum() == GetTeamNum())
			return; // Beacons/C4 only damages the planter
	}
	if(Rx_Projectile(DamageCauser) != None && !Rx_Projectile(DamageCauser).isAirstrikeProjectile()) {
		if(WorldInfo.NetMode != NM_DedicatedServer 
					&& InstigatedBy != None && (Rx_Weapon(InstigatedBy.Pawn.Weapon) != None || Rx_Vehicle_Weapon(InstigatedBy.Pawn.Weapon) != None)) {	
			if(Health > 0 && GetTeamNum() != InstigatedBy.GetTeamNum() && UTPlayerController(InstigatedBy) != None && GetTeamNum() != 255) {
				Rx_Hud(UTPlayerController(InstigatedBy).myHud).ShowHitMarker();
			}

			if (Rx_Weapon_VoltAutoRifle(InstigatedBy.Pawn.Weapon) != None)
				Rx_Weapon_VoltAutoRifle(InstigatedBy.Pawn.Weapon).ServerALRadiusDamageCharged(self,HurtOrigin,bFullDamage,class'Rx_Projectile_VoltBolt'.static.GetChargePercentFromDamage(BaseDamage));
			else if(Rx_Weapon(InstigatedBy.Pawn.Weapon) != None) {
				Rx_Weapon(InstigatedBy.Pawn.Weapon).ServerALRadiusDamage(self,HurtOrigin,bFullDamage);
			} else {
				Rx_Vehicle_Weapon(InstigatedBy.Pawn.Weapon).ServerALRadiusDamage(self,HurtOrigin,bFullDamage, Rx_Projectile(DamageCauser).FMTag);
			}	
		} else if(ROLE == ROLE_Authority && AIController(InstigatedBy) != None) {
			super(Actor).TakeRadiusDamage(InstigatedBy,BaseDamage,DamageRadius,DamageType,Momentum,HurtOrigin,bFullDamage,DamageCauser,DamageFalloffExponent);
		}
	} else {
		super(Actor).TakeRadiusDamage(InstigatedBy,BaseDamage,DamageRadius,DamageType,Momentum,HurtOrigin,bFullDamage,DamageCauser,DamageFalloffExponent);
	}
	
}

//Do not allow healing of 'most' destroyable obstacles
function bool HealDamage(int Amount, Controller Healer, class<DamageType> DamageType)
{
local int HealthAmmount;
	local float Score;

	if (!bCanHeal || Health <= 0 || Amount <= 0 || Healer == None || Health >= HealthMax)
		return false;

	HealthAmmount = Min(Amount, HealthMax - Health);
	
	Health += HealthAmmount;
	
	// Give score to the healer (EDIT-Yosh: Only if it was legitimate damage, i.e from an enemy)
	if (HealthAmmount > 0 && Rx_PRI(Healer.PlayerReplicationInfo) != none)
	{
		Score = HealthAmmount * HealPointMod;
		Rx_PRI(Healer.PlayerReplicationInfo).AddScoreToPlayerAndTeam(Score);
		Rx_PRI(Healer.PlayerReplicationInfo).AddRepairPoints_P(HealthAmmount); //Add to amount of Pawn repair points this 
		
	}

	return true;
}


simulated event TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local float CurDmg;
	local int TempDmg;
	local class<Rx_DmgType> RXDT;
	
	if(!bCanTakeDamage || EventInstigator == None || EventInstigator.GetTeamNum() == GetTeamNum()) 
		return; 
	
	if (DamageAmount <= 0 || Health <= 0)
      return;
		
	RXDT=class<Rx_DmgType>(DamageType);
	
	if(RXDT == none) 
		return; 
	
	if ( DamageType != None )
	{
		
		CurDmg = ParseArmor(DamageAmount, RXDT);
		
		DamageAmount = int(ParseArmor(DamageAmount, RXDT));
		//`log(DamageAmount @ CurDmg);
		
	    if(DamageAmount < CurDmg)
	    {
	    	SavedDmg += CurDmg - Float(DamageAmount);	
	    }
	    
	    if (SavedDmg >= 1)
	    {
	    	DamageAmount += SavedDmg; 
	    	TempDmg = SavedDmg;
	    	SavedDmg -= Float(TempDmg);		   
	    }

		Health-=DamageAmount; 
		
		super(KActor).TakeDamage(DamageAmount,EventInstigator,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);
	}
	
	if (Health <= 0)
	{
		HandleDeath(EventInstigator);
		//`log(EventInstigator); 
	}
}

simulated function HandleDeath(Controller EventInstigator)
{
	if(Rx_Controller(EventInstigator) != None && GetTeamNum() != EventInstigator.GetTeamNum()) 
			Rx_Controller(EventInstigator).DisseminateVPString("["$ ActorName @ "Destroyed]&"$VPReward$"&"); 
		else
		if(Rx_Bot(EventInstigator) != None && GetTeamNum() != EventInstigator.GetTeamNum()) 
			Rx_Bot(EventInstigator).DisseminateVPString("["$ ActorName @ "Destroyed]&"$VPReward$"&"); 
		else
		if(Rx_Defence_Controller(EventInstigator) != none) //Just give defences VP, nothing else
		{
			Rx_Defence_Controller(EventInstigator).GiveVeterancy(default.VPReward);	
		}

		if(bExplodes)
			Explosion(EventInstigator);
		else
			DestroyMe(); 
}

function DestroyMe() {
   Destroy();	
}

simulated function int GetHealth() {
   return Health;
}

simulated function int GetMaxHealth() {
   return HealthMax;
}

simulated function PlayCamerashakeAnim()
{
	
   local UTPlayerController UTPC;
   local float Dist;

   foreach LocalPlayerControllers(class'UTPlayerController', UTPC)
   {
      Dist = VSizeSq(Location - UTPC.ViewTarget.Location);

      if (Dist < Square(OuterExplosionShakeRadius))
      {
         if (ExplosionShake != None)
         {
            ExplosionShakeScale = 1.5;
            if (Dist > Square(InnerExplosionShakeRadius))
            {
               ExplosionShakeScale -= (Sqrt(Dist) - InnerExplosionShakeRadius) / (OuterExplosionShakeRadius - InnerExplosionShakeRadius);
            }
            UTPC.PlayCameraAnim(ExplosionShake, ExplosionShakeScale);
         }
      }
   }
}

simulated function byte ScriptGetTeamNum()
{
	return TeamIndex;
}

simulated function byte GetTeamNum()
{
	return TeamIndex;
}

function DropToGround() {};
//function AddVelocity( vector NewVelocity, vector HitLocation, class<DamageType> damageType, optional TraceHitInfo HitInfo ) {}
function JumpOffPawn() {};
singular event BaseChange() {};
function SetMovementPhysics() {}; 

function float ParseArmor(float AdjustedDamage, class<Rx_DmgType> RXDT)
{
	switch(ArmorType)
		{
			//Heavy Vehicle Armour 
			case ARM_Heavy: 
			AdjustedDamage*=RXDT.static.VehicleDamageScalingFor(none);
			break; 
			//Light Vehicle Armour
			case ARM_Light: 
			AdjustedDamage*=RXDT.static.LightVehicleDamageScalingFor();
			break; 
			
			//Building armour 
			case ARM_Building: 
			AdjustedDamage*=RXDT.static.BuildingDamageScalingFor();
			break; 
			
			//Armourless infantry damage
			case ARM_Infantry: 
			AdjustedDamage*=RXDT.static.NoArmourDamageScalingFor();
			break; 
			case ARM_Aircraft: 
			AdjustedDamage*=RXDT.static.AircraftDamageScalingFor();
			break; 
			
			//Kevlar infantry armour 
			case ARM_KEVLAR: 
			AdjustedDamage*=RXDT.static.KevlarDamageScalingFor();
			break; 
			
			
			case ARM_FLAK: 
			AdjustedDamage*=RXDT.static.FLAKDamageScalingFor();
			break;
			
		}	
		return AdjustedDamage; 
}

simulated function SimulatedCleanup(){}; 

simulated function byte GetAntiTeamByte(byte ForTeam)
{
	 if(ForTeam == 0) return 1 ;
	 else 
	 if(ForTeam == 1) return 0 ;
	 else
	 return 255; 
}

simulated function Actor GetActualActorTarget(){return self;}
simulated function bool ShouldSubstitute(){return false;}

/*-------------------------------------------*/
/*BEGIN TARGET INTERFACE [RxIfc_Targetable]*/
/*------------------------------------------*/
//Health
simulated function int GetTargetHealth() {return GetHealth();} //Return the current health of this target
simulated function int GetTargetHealthMax() {return GetMaxHealth();} //Return the current health of this target

//Armour 
simulated function int GetTargetArmour() {return 0;} // Get the current Armour of the target
simulated function int GetTargetArmourMax() {return 0;} // Get the current Armour of the target 

/*Get Health/Armour Percents*/
simulated function float GetTargetHealthPct() {return (GetHealth()*1.0) / max(1.0, (GetMaxHealth()*1.0));}
simulated function float GetTargetArmourPct() {return 0;}
simulated function float GetTargetMaxHealthPct() {return 1.0f;} //Everything together (Basically Health and armour)
simulated function bool GetHasResistance() {return false;} //If this unit has any kind of resistance

/*Get what we're actually looking at*/
simulated function Actor GetActualTarget() {return self;} //Should return 'self' most of the time, save for things that should return something else (like building internals should return the actual building)

/*Booleans*/
simulated function bool GetUseBuildingArmour(){return false;} //Stupid legacy function to determine if we use building armour when drawing. 
simulated function bool GetShouldShowHealth(){return bShowHealth;} //If we need to draw health on this 
simulated function bool AlwaysTargetable() {return false;} //Targetable no matter what range they're at
simulated function bool GetIsInteractable(PlayerController PC) {return false;} //Are we ever interactable?
simulated function bool GetCurrentlyInteractable(PlayerController RxPC) {return false;} //Are we interactable right now? 
simulated function bool GetIsValidLocalTarget(Controller PC) {return true;} //Are we a valid target for our local playercontroller?  (Buildings are always valid to look at (maybe stealthed buildings aren't?))
simulated function bool HasDestroyedState() {return false;} //Do we have a destroyed state where we won't have health, but can't come back? (Buildings in particular have this)
simulated function bool UseDefaultBBox() {return false;} //We're big AF so don't use our bounding box 
simulated function bool IsStickyTarget() {return true;} //Does our target box 'stick' even after we're untargeted for awhile 

//Spotting
simulated function bool IsSpottable() {return true;}
simulated function bool IsCommandSpottable() {return false;} 

simulated function bool IsSpyTarget(){return false;} //Do we use spy mechanics? IE: our bounding box will show up friendly to the enemy [.... There are no spy Refineries...... Or are there?]

/* Text related */

simulated function string GetTargetName() {return GetHumanReadableName();} //Get our targeted name 
simulated function string GetInteractText(Controller C, string BindKey) {return "";} //Get the text for our interaction 
simulated function string GetTargetedDescription(PlayerController PlayerPerspectiv) {return "";} //Get any special description we might have when targeted 

//Actions
simulated function SetTargeted(bool bTargeted) ; //Function to say what to do when you're targeted client-side 

/*----------------------------------------*/
/*END TARGET INTERFACE [RxIfc_Targetable]*/
/*---------------------------------------*/

simulated function SetPhysicalCollisionProperties()
{
	local PhysicalMaterial PhysMat;
	PhysMat = MeshPhysMat == none ? GetKActorPhysMaterial() : MeshPhysMat;
	// cache effect info
	ImpactEffectInfo = PhysMat.FindPhysEffectInfo(EPMET_Impact);
	SlideEffectInfo = PhysMat.FindPhysEffectInfo(EPMET_Slide);
	
	if(ImpactEffectInfo.Effect != None)
	{
		ImpactEffectComponent = new(self) class'ParticleSystemComponent';
		//AttachComponent(ImpactEffectComponent);
		ImpactEffectComponent.bAutoActivate = FALSE;
		ImpactEffectComponent.SetTemplate(ImpactEffectInfo.Effect);
	}

	if(ImpactEffectInfo.Sound != None)
	{
		ImpactSoundComponent = new(self) class'AudioComponent';
		//AttachComponent(ImpactSoundComponent);
		ImpactSoundComponent.SoundCue = ImpactEffectInfo.Sound;

		ImpactSoundComponent2 = new(self) class'AudioComponent';
		//AttachComponent(ImpactSoundComponent2);
		ImpactSoundComponent2.SoundCue = ImpactEffectInfo.Sound;
	}

	if(SlideEffectInfo.Effect != None)
	{
		SlideEffectComponent = new(self) class'ParticleSystemComponent';
		//AttachComponent(SlideEffectComponent);
		SlideEffectComponent.bAutoActivate = FALSE;
		SlideEffectComponent.SetTemplate(SlideEffectInfo.Effect);
	}

	if(SlideEffectInfo.Sound != None)
	{
		SlideSoundComponent = new(self) class'AudioComponent';
		//AttachComponent(SlideSoundComponent);
		SlideSoundComponent.SoundCue = SlideEffectInfo.Sound;
	}
}

DefaultProperties
{

	Health=500

	HealthMax=500
	bReplicateHealthToAll = true; 
	HealPointMod=0.008;
	bHasHealth = false
	VPReward =+5
	 
	DamageSmokeThreshold=0.25
	
	ExplosionScale = 1.0f
	ExplosionSound=SoundCue'RX_SoundEffects.Vehicle.SC_Vehicle_Explode'
	ExplosionEffect=ParticleSystem'RX_FX_Munitions2.Particles.Explosions.P_Explosion_Vehicle_Air'
	ExplosionShake=CameraAnim'Envy_Effects.Camera_Shakes.C_VH_Death_Shake'
	InnerExplosionShakeRadius=150.0
	OuterExplosionShakeRadius=550.0
	ExplosionShakeScale=1.5
	
	bExplodes = false
	ExplosionDamage=0
	ExplosionRadius=1
	bDamageAll=false 
	DamageMomentum=10000
	DamageTypeClass=class'Rx_DmgType_GrenadeLauncher'

	ActorName = "Basic Object" 
	 
	bShowHealth=true

	begin object Name=StaticMeshComponent0
		StaticMesh=StaticMesh'RX_Deco_Rock.Mesh.SM_BasaltMain01'
	end object
}	