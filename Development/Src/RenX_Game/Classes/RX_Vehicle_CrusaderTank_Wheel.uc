class Rx_Vehicle_CrusaderTank_Wheel extends UDKVehicleWheel;

defaultproperties
{
    WheelRadius=21
    SuspensionTravel=50
    SuspensionSpeed=200
    bPoweredWheel=True
    BoneOffset=(X=0.0,Y=0.0,Z=0.0)
    SteerFactor=1.0
    LongSlipFactor=1.90 //2.0
    LatSlipFactor=60.0
    HandbrakeLongSlipFactor=1.0
    HandbrakeLatSlipFactor=60.0
    ParkedSlipFactor=1.75

    //if bSlipOnVehiclePush is set to true on this wheel, then change to these values while pushing another vehicle
    bSlipOnVehiclePush = true //Set to true on individual wheels, usually the front 2 and back 2 on both sides
    VPushLongSlip = 0.80
    VPushLatSlip = 60.0

    bUseMaterialSpecificEffects=false
    EffectDesiredSpinDir=1.0
}