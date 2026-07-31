class Rx_Vehicle_APC_GDI_Wheel extends UDKVehicleWheel;

defaultproperties
{

    WheelRadius=24
    SuspensionTravel=30
    SuspensionSpeed=50
    bPoweredWheel=True
    BoneOffset=(X=0.0,Y=0.0,Z=0.0)
    SteerFactor=1.0
//    LongSlipFactor=250
//    LatSlipFactor=20000.0
//    HandbrakeLongSlipFactor=250.0
//    HandbrakeLatSlipFactor=1000.0
//    ParkedSlipFactor=1.75

    LongSlipFactor=2.0
    LatSlipFactor=60.0
    HandbrakeLongSlipFactor=1.0
    HandbrakeLatSlipFactor=60.0
    ParkedSlipFactor=1.5

    //if bSlipOnVehiclePush is set to true on this wheel, then change to these values while pushing another vehicle
    bSlipOnVehiclePush = true //Set to true on individual wheels, usually the front 2 and back 2 on both sides
    VPushLongSlip = 0.40
    VPushLatSlip = 60.0

    bUseMaterialSpecificEffects=false
    EffectDesiredSpinDir=1.0
}