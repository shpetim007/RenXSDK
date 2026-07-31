class Rx_Vehicle_Artillery_Wheel extends UDKVehicleWheel;

defaultproperties
{
    WheelRadius=40
    SuspensionTravel=100
    SuspensionSpeed=100
    bPoweredWheel=True
    BoneOffset=(X=0.0,Y=0.0,Z=0.0)
    SteerFactor=0.0
    
//    LongSlipFactor=2.0
//    LatSlipFactor=2.75
//    HandbrakeLongSlipFactor=1.0
//    HandbrakeLatSlipFactor=1.0
//    ParkedSlipFactor=1.75
    
    LongSlipFactor=2.0 //15.0
    LatSlipFactor=0.4
    HandbrakeLongSlipFactor=15.0
    HandbrakeLatSlipFactor=0.5
    ParkedSlipFactor=1.75

    //if bSlipOnVehiclePush is set to true on this wheel, then change to these values while pushing another vehicle
    bSlipOnVehiclePush = true //Set to true on individual wheels, usually the front 2 and back 2 on both sides
    VPushLongSlip = 0.60 
    VPushLatSlip = 0.4
    
    bUseMaterialSpecificEffects=false
    EffectDesiredSpinDir=1.0
}