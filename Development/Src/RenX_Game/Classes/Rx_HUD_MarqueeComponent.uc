class Rx_HUD_MarqueeComponent extends Rx_HUD_Component ; 

struct MarqueeCard
{
    var MaterialInstanceConstant CardMIC;
    var Texture2D CardTex;  			
	var float TimeToLinger;
	var float TimeLingered	;
    var SoundCue InitialSound;
    var float PosX, PosY;
    var float FadeAlpha;
    var bool bFadingOut;
    var bool bInitialized;  								

structdefaultproperties
{
	TimeToLinger = 5.0;
    FadeAlpha = 1.0;					
}
};

var array<MarqueeCard> Marquees;
var float FadeSpeed;  
var float ScreenPositionY; 
var MaterialInstanceConstant ParentCardMIC; 

function Update(float DeltaTime, Rx_HUD HUD) 
{
	super.Update(DeltaTime, HUD);

    if(Marquees.Length > 0)
    {
        Marquees[0].TimeLingered+=DeltaTime; 

        if(Marquees[0].TimeLingered >= Marquees[0].TimeToLinger)
        {
            Marquees[0].FadeAlpha -= FadeSpeed*DeltaTime;
            Marquees[0].CardMIC.SetScalarParameterValue('MatAlpha', Marquees[0].FadeAlpha);
        }

        if(Marquees[0].FadeAlpha <= 0)
        {
            Marquees.Remove(0,1);

            if(Marquees.Length > 0)
                RenxHud.PlayerOwner.ClientPlaySound(Marquees[0].InitialSound); 
        }
    }
}

function Draw() {
    local float PosX, PosY; 
    local float ResY; //ResX 

    if(RenxHud == none)
        return; 

    if(Marquees.Length > 0)
    {
        //ResX = RenxHUD.SizeX / 1280.0;
        ResY = RenxHUD.SizeY / 720.0;

        PosX = (RenxHUD.SizeX * 0.5) - 500;
        PosY = ScreenPositionY * ResY; 

        RenXHud.Canvas.SetPos(PosX, PosY);
        //RenXHud.Canvas.DrawMaterialTile(Marquees[0].CardMIC, 1000, 148,1.0,1.0,1.0,1.0);
        RenXHud.Canvas.DrawMaterialTile(Marquees[0].CardMIC, 1000, 148,,,1.0,1.0);
    }
}

function CreateMarqueeCard(Texture2D NewTex, float LingerTimer, optional SoundCue CardSound)
{
    local MarqueeCard NewMarquee; 
    local MaterialInstanceConstant NewMIC;
    
    //Texture2D NewTex, 

    NewMIC = new(Outer) class'MaterialInstanceConstant';
    NewMIC.SetParent(ParentCardMIC);
    NewMIC.SetTextureParameterValue('CardTex', NewTex); 

    NewMarquee.CardMIC = NewMIC;
    NewMarquee.TimeToLinger = LingerTimer;
    NewMarquee.InitialSound = CardSound;

    Marquees.AddItem(NewMarquee); 

    if(Marquees.Length == 1) //We're the 1st thing in the array
    {
        RenxHud.PlayerOwner.ClientPlaySound(CardSound); 
    }
}

DefaultProperties
{

    FadeSpeed = 1.0
    ScreenPositionY = 64 //Based on 1280x720
    ParentCardMIC = MaterialInstanceConstant'RenxHUD.Cards.Mat_Marquee_INST'

}