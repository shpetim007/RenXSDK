/**
 *
 * Copyright 1998-2015 Epic Games, Inc. All Rights Reserved.
 */

class UDKVehicleWheel extends SVehicleWheel
	native;

/** if set, this wheel should use material specific effects defined by the UDKVehicle that owns it */
var bool bUseMaterialSpecificEffects;

/** old particle component left when switching materials so that it doesn't get abruptly cut off */
var ParticleSystemComponent OldWheelParticleComp;

/** if non-zero, only activate the wheel effect when SpinVel's sign is the same as this property */
var float EffectDesiredSpinDir;

/** If true, when vehicle dies, turn off this wheel. */
var bool bDisableWheelOnDeath;

var bool bConsiderForWeightResistance; // If true, RX_Vehicle Weight Resistance is applied to this wheel when it comes off the ground
var bool bSlipOnVehiclePush; // If true, RX_Vehicle Weight Resistance is applied to this wheel when it comes off the ground
var float VPushLongSlip, VPushLatSlip; //Slip Values while pushing other vehicles

/** 
  * Called to update wheel particle effect if bUseMaterialSpecificEffects=true and material being driven on changes.
  * Passed in NewTemplate is selected from the OwnerVehicle's WheelParticleEffects array 
  */
event SetParticleEffect(UDKVehicle OwnerVehicle, ParticleSystem NewTemplate)
{
	// if another old component is still playing, its time to die is up, kill it
	if (OldWheelParticleComp != None)
	{
		OwnerVehicle.DetachComponent(OldWheelParticleComp);
	}
	// copy the current component
	OldWheelParticleComp = WheelParticleComp;
	WheelParticleComp = new(self) WheelPSCClass(OldWheelParticleComp);

	// set the particle effect on the new component and attach it
	WheelParticleComp.SetTemplate(NewTemplate);
	OwnerVehicle.AttachComponent(WheelParticleComp);

	// set the old one to die out and notify us when it does
	if (OldWheelParticleComp.Template == None)
	{
		OwnerVehicle.DetachComponent(OldWheelParticleComp);
		OldWheelParticleComp = None;
	}
	else
	{
		OldWheelParticleComp.OnSystemFinished = OldEffectFinished;
		OldWheelParticleComp.DeactivateSystem();
	}
}

/**  
  * Called when OldWheelParticleComponent is finished
  */
function OldEffectFinished(ParticleSystemComponent PSystem)
{
	PSystem.Owner.DetachComponent(PSystem);
	if (PSystem == OldWheelParticleComp)
	{
		OldWheelParticleComp = None;
	}
}

cpptext
{
	/** @return whether this wheel should have a particle component attached to it */
	virtual UBOOL WantsParticleComponent();
}

defaultproperties
{
	WheelPSCClass=class'UDKParticleSystemComponent'
	bCollidesPawns=TRUE
	bConsiderForWeightResistance = true
}
