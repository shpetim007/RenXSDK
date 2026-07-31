class Rx_Projectile_SnowThrower extends Rx_Projectile_Spray;

var	class<Rx_StatModifierInfo> StatEffectClass; 

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    local Rx_Pawn P;
    local Rx_Controller C;
    local Rx_Bot B;

    super.ProcessTouch(Other, HitLocation, HitNormal);

    if (Role >= ROLE_Authority)
    {
        P = Rx_Pawn(Other);

        if (P == None) return;
        if (P.IsSameTeam(Instigator))
            return;
        C = Rx_Controller(P.Controller);
        B = Rx_Bot(P.Controller);
		if(StatEffectClass.default.bEffectStackable)
		{
			if (C != None)
				C.AddActiveModifierStack(StatEffectClass);
			
			if (B != None) 
				B.AddActiveModifierStack(StatEffectClass);
		}
		else
		{
			if (C != None)
				C.AddActiveModifier(StatEffectClass);
		
			if (B != None) 
				B.AddActiveModifier(StatEffectClass);
		}
    }
}

DefaultProperties
{

    ProjFlightTemplate=ParticleSystem'RX_WP_ChemicalThrower.Effects.FX_Snow'
    
    ProjExplosionTemplate=ParticleSystem'RX_WP_ChemicalThrower.Effects.FX_Snow_Explode'
  
    ImpactEffects(0)=(MaterialType=Dirt, ParticleTemplate=ParticleSystem'RX_WP_ChemicalThrower.Effects.FX_Snow_Explode',Sound=none)
    ImpactEffects(1)=(MaterialType=Stone, ParticleTemplate=ParticleSystem'RX_WP_ChemicalThrower.Effects.FX_Snow_Explode',Sound=none)
	ImpactEffects(2)=(MaterialType=Concrete, ParticleTemplate=ParticleSystem'RX_WP_ChemicalThrower.Effects.FX_Snow_Explode',Sound=none)
    ImpactEffects(3)=(MaterialType=Metal, ParticleTemplate=ParticleSystem'RX_WP_ChemicalThrower.Effects.FX_Snow_Explode',Sound=none)
    ImpactEffects(4)=(MaterialType=Glass, ParticleTemplate=ParticleSystem'RX_WP_ChemicalThrower.Effects.FX_Snow_Explode',Sound=none)
    ImpactEffects(5)=(MaterialType=Wood, ParticleTemplate=ParticleSystem'RX_WP_ChemicalThrower.Effects.FX_Snow_Explode',Sound=none)
    ImpactEffects(6)=(MaterialType=Water, ParticleTemplate=ParticleSystem'RX_WP_ChemicalThrower.Effects.FX_Snow_Explode',Sound=none)
    ImpactEffects(7)=(MaterialType=Liquid, ParticleTemplate=ParticleSystem'RX_WP_ChemicalThrower.Effects.FX_Snow_Explode',Sound=none)
	ImpactEffects(8)=(MaterialType=Flesh, ParticleTemplate=ParticleSystem'RX_WP_ChemicalThrower.Effects.FX_Snow_Explode',Sound=none)
	ImpactEffects(9)=(MaterialType=TiberiumGround, ParticleTemplate=ParticleSystem'RX_WP_ChemicalThrower.Effects.FX_Snow_Explode',Sound=none)
	ImpactEffects(10)=(MaterialType=TiberiumCrystal, ParticleTemplate=ParticleSystem'RX_WP_ChemicalThrower.Effects.FX_Snow_Explode',Sound=none)
	ImpactEffects(11)=(MaterialType=TiberiumGroundBlue, ParticleTemplate=ParticleSystem'RX_WP_ChemicalThrower.Effects.FX_Snow_Explode',Sound=none)
	ImpactEffects(12)=(MaterialType=TiberiumCrystalBlue, ParticleTemplate=ParticleSystem'RX_WP_ChemicalThrower.Effects.FX_Snow_Explode',Sound=none)
	ImpactEffects(13)=(MaterialType=Mud, ParticleTemplate=ParticleSystem'RX_WP_ChemicalThrower.Effects.FX_Snow_Explode',Sound=none)
	ImpactEffects(14)=(MaterialType=WhiteSand, ParticleTemplate=ParticleSystem'RX_WP_ChemicalThrower.Effects.FX_Snow_Explode',Sound=none)
	ImpactEffects(15)=(MaterialType=YellowSand, ParticleTemplate=ParticleSystem'RX_WP_ChemicalThrower.Effects.FX_Snow_Explode',Sound=none)
	ImpactEffects(16)=(MaterialType=Grass, ParticleTemplate=ParticleSystem'RX_WP_ChemicalThrower.Effects.FX_Snow_Explode',Sound=none)
	ImpactEffects(17)=(MaterialType=Snow, ParticleTemplate=ParticleSystem'RX_WP_ChemicalThrower.Effects.FX_Snow_Explode',Sound=none)
	ImpactEffects(18)=(MaterialType=SnowStone, ParticleTemplate=ParticleSystem'RX_WP_ChemicalThrower.Effects.FX_Snow_Explode',Sound=none)
   
    MyDamageType=class'Rx_DmgType_SnowThrower'
	StatEffectClass = class'Rx_StatModifierInfo_ColdDebuffGrenade'

    DrawScale= 1.0f
    bCollideComplex=true
    Speed=2000 //2000
    MaxSpeed=2000 //2000
    AccelRate=0
    LifeSpan=0.7
    Damage=0 //13.2
    DamageRadius=0 //50 //150 //Needs no damage radius. Use SprayRadii vector to make he spray more shapes
	HeadShotDamageMult=1.10//1.2//1.0 //1.3
    MomentumTransfer=1
	
	MaxSprayRadii = (X=5,Y=5,Z=5) //You're THIS big in the end 
	MinSprayRadii =  (X=5,Y=5,Z=5) //You're this big to start with 
    
    bWaitForEffects=true
    bWaitForEffectsAtEndOfLifetime=true
    bAttachExplosionToVehicles=true
    bSuppressExplosionFX=True // Do not spawn hit effect in mid air
    
    ProjectileLightClass=none
    ExplosionLightClass=none
}
