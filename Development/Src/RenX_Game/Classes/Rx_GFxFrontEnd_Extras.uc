//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Rx_GFxFrontEnd_Extras extends Rx_GFxFrontEnd_View;

var Rx_GFXFrontEnd MainFrontEnd;

var GFxClikWidget CreditScrollingList;
var GFxClikWidget CreditScrollBar;

var const array<string> CreditContent;

function OnViewLoaded(Rx_GFXFrontEnd FrontEnd)
{
	MainFrontEnd = FrontEnd;
  	ActionScriptVoid("validateNow");
}

function bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	local bool bWasHandled;

	`log("Rx_GFxFrontEnd_Extra::WidgetInitialized"@`showvar(WidgetName),true,'DevGFxUI');

	bWasHandled = false; 

	switch (WidgetName)
	{
		case 'CreditScrollingList':
			if (CreditScrollingList == none || CreditScrollingList != Widget) {
				CreditScrollingList = GFxClikWidget(Widget);
			}
            SetUpDataProvider(CreditScrollingList);
			CreditScrollingList.SetInt("rowCount", 11);
			bWasHandled = true;
			break;
		case 'CreditScrollBar':
			if (CreditScrollBar == none || CreditScrollBar != Widget) {
				CreditScrollBar = GFxClikWidget(Widget);
			}
			bWasHandled = true;
			break;
        default:
            break;
	}
	return bWasHandled;
}


function SetUpDataProvider(GFxClikWidget Widget)
{
	local GFxObject DataProvider;
	local int i;

	`log("Rx_GFxFrontEnd_Extras::SetupDataProvider"@Widget.GetString("name"),true,'DevGFxUI');


	DataProvider = CreateObject("scaleform.clik.data.DataProvider");
	switch(Widget)
	{
		case (CreditScrollingList):
			for (i=0; i < CreditContent.Length; i++) {
				DataProvider.SetElementString(i, CreditContent[i]);
			}
			break;
        default:
            return;
	}
    Widget.SetObject("dataProvider", DataProvider);
}
DefaultProperties
{

	SubWidgetBindings.Add((WidgetName="CreditScrollingList", WidgetClass=class'GFxClikWidget'))
	SubWidgetBindings.Add((WidgetName="CreditScrollBar", WidgetClass=class'GFxClikWidget'))

	CreditContent.Add("[ Project Lead and Sound Engineer ]")
	CreditContent.Add("Bilal Bakri")
	CreditContent.Add("")
	CreditContent.Add("[ Creative Director and Producer ]")
	CreditContent.Add("Waqas Iqbal")
	CreditContent.Add("")
	CreditContent.Add("")
	CreditContent.Add("[ Programmers ]")
	CreditContent.Add("")
	CreditContent.Add("Isa 'Handepsilon' Handoyo")
	CreditContent.Add("Eugen 'Pr0eX' Gerner")
	CreditContent.Add("Shahman 'Roxez' Teh")
	CreditContent.Add("Sarah 'NodSaibot' Evans")
	CreditContent.Add("Sean 'Yosh56' Nolan")
	CreditContent.Add("Mehmet Emre 'Mr.Grease' Yorulmaz")
	CreditContent.Add("Daniel 'RypeL' Boeckmann")
	CreditContent.Add("John 'Avalanche' Melton")
	CreditContent.Add("Tom 'halo2pac' Cables")
	CreditContent.Add("Joe 'coffeeburrito' Wakefield")
	CreditContent.Add("Jeroen 'Chaos_Alfa' Houttuin")
	CreditContent.Add("Wiebe 'GreaseMonk' Geertsma")
	CreditContent.Add("Zach 'triggerhippy' Gray")
	CreditContent.Add("Rob 'Schmitzenbergh' Smit")
	CreditContent.Add("Waldemar 'KrypTheBear' Meschalin")
	CreditContent.Add("Jessica 'Agent' James")
	CreditContent.Add("Craig 'ShrewdTactician' Emmott")
	CreditContent.Add("Mark 'AlienX' Phillips")
	CreditContent.Add("Randy 'SonnyX' von der Weide")
	CreditContent.Add("Daniil 'UsedC' Mitrofanov")
	CreditContent.Add("Gary 'SgtIgram' Uhlig")
	CreditContent.Add("Tristan 'Sumo' Pollard")
	CreditContent.Add("Tommy Ringo 'TRRDroid' Rehfeld")
	CreditContent.Add("Franklin Iheanacho")
	CreditContent.Add("Mike Geig")
	CreditContent.Add("'Kil'")
	CreditContent.Add("'one1'")
	CreditContent.Add("'nBab'")
	CreditContent.Add("'--nn'")
	CreditContent.Add("'HIHIHI'")
	CreditContent.Add("'Aut'")
	CreditContent.Add("")
	CreditContent.Add("")
	CreditContent.Add("[ General Artist ]")
	CreditContent.Add("")
	CreditContent.Add("Richard 'Ric' Jeffery")
	CreditContent.Add("Robin 'Nielsen' Nielsen")
	CreditContent.Add("Martin 'JeepRubi' Palko")
	CreditContent.Add("Martin 'tintin' Sanchez")
	CreditContent.Add("Sander 'ZixXer' Vereecken")
	CreditContent.Add("Evan 'HappyConscript' Brooks")
	CreditContent.Add("Matthew 'maty' McDonald")
	CreditContent.Add("Simon 'kenz3001' Mckenzie")
	CreditContent.Add("Ruud 'Ruud003' Gunnewiek")
	CreditContent.Add("Jos 'Henk' Vermeulen")
	CreditContent.Add("Florian 'Luhrian' T.")
	CreditContent.Add("Thom 'TK0104' Keuken")
	CreditContent.Add("Ettienne 'Xelus' Vorster")
	CreditContent.Add("Sam 'SMayhew' Mayhew")	
	CreditContent.Add("Christoph 'DaKuja' Heinrich")
	CreditContent.Add("Lorenzo 'Nexus51325' Cabassud")
	CreditContent.Add("Ethan 'Necroplasmic' Lane");
	CreditContent.Add("Ryan Wongwai")
	CreditContent.Add("Denis dos Santos")
	CreditContent.Add("Fedor Kurmazov")
	CreditContent.Add("'Njorl'")
	CreditContent.Add("")
	CreditContent.Add("")
	CreditContent.Add("[ Public Relations & Web Development ]")
	CreditContent.Add("")
	CreditContent.Add("Aaron 'Jam' Imming")
	CreditContent.Add("")
	CreditContent.Add("")
	CreditContent.Add("[ Web Development Assistant ]")
	CreditContent.Add("")
	CreditContent.Add("Remy 'Uncut' Lagerweij")
	CreditContent.Add("")
	CreditContent.Add("")
	CreditContent.Add("[ System Administrators ]")
	CreditContent.Add("")
	CreditContent.Add("David 'Speedy' Ellsworth")
	CreditContent.Add("Danny 'fffreak9999' Blake")
	CreditContent.Add("Bryan Kloosterboer")
	CreditContent.Add("'Cronus'")
	CreditContent.Add("'Genesis'")
	CreditContent.Add("")
	CreditContent.Add("")
	CreditContent.Add("[ Animators ]")
	CreditContent.Add("")
	CreditContent.Add("Kris 'PermaGrin' Ducote")
	CreditContent.Add("Paolo 'Sinfect' Damaso")
	CreditContent.Add("")
	CreditContent.Add("")
	CreditContent.Add("[ Contributing Artists ]")
	CreditContent.Add("")
	CreditContent.Add("Robert 'Killa' Baker")
	CreditContent.Add("Kevin 'DrGuppy' Butt")
	CreditContent.Add("Elizabeth 'tomato' Deacon")
	CreditContent.Add("Chris 'MightyBOB!' Kohl")
	CreditContent.Add("Shaun 'WNxKain' Slater")
	CreditContent.Add("Alexander 'Deathlink' Trautmann")
	CreditContent.Add("Craig 'Glacious' Cooper")
	CreditContent.Add("Bruno 'Bruni' Freitas")
	CreditContent.Add("Rafael Morais")
	CreditContent.Add("Shaikh Zhafri")
	CreditContent.Add("Cody Vogel")
	CreditContent.Add("Juan Villegas")
	CreditContent.Add("Jakub Janiak")
	CreditContent.Add("Jordan Brooker")
	CreditContent.Add("Benjamin Allen")
	CreditContent.Add("Daniel Kamentsky")
	CreditContent.Add("Nathan Elliott")
	CreditContent.Add("'KatzSmile'")
	CreditContent.Add("'Stoy79'")
	CreditContent.Add("'Tugodoomer'")
	CreditContent.Add("")
	CreditContent.Add("")
	CreditContent.Add("[ Motion Designer ]")
	CreditContent.Add("David Kashevsky")
	CreditContent.Add("")
	CreditContent.Add("")
	CreditContent.Add("[ Voice Actors ]")
	CreditContent.Add("")
	CreditContent.Add("Justin 'theGunrun' Ignacio")
	CreditContent.Add("Sonya Cerdan")
	CreditContent.Add("Ty Konzak")
	CreditContent.Add("CJ Williams")
	CreditContent.Add("")
	CreditContent.Add("")
	CreditContent.Add("[ Music & Sound Engineer ]")
	CreditContent.Add("")
	CreditContent.Add("Sebastian Aav")
	CreditContent.Add("Paul Curtis")
	CreditContent.Add("Niels van der Leest")
	CreditContent.Add("Adam Prack")
	CreditContent.Add("Maarten Bonder")
	CreditContent.Add("")
	CreditContent.Add("")
	CreditContent.Add("[ Trailers & Marketing ]")
	CreditContent.Add("")
	CreditContent.Add("Isaak 'Kraftsman' Kraft van Ermel")
	CreditContent.Add("Sinne Derooij")
	CreditContent.Add("")
	CreditContent.Add("")
	CreditContent.Add("[ Quality Assurance ]")
	CreditContent.Add("")
	CreditContent.Add("'MathDotPI'")
	CreditContent.Add("'RealLegendaryJ'")
	CreditContent.Add("")
	CreditContent.Add("")
	CreditContent.Add("[ Special Thanks ]")
	CreditContent.Add("")
	CreditContent.Add("Electronic Arts")
	CreditContent.Add("Epic Games")
	CreditContent.Add("Westwood Studios")
	CreditContent.Add("C&C Community")
	CreditContent.Add("UDK Community")
	CreditContent.Add("Renegade X Beta Testers")
	CreditContent.Add("Firestorm Alpha Testers")
	CreditContent.Add("W3D Hub")
	CreditContent.Add("Tiberian Sun: Reborn")
	CreditContent.Add("Tiberian Aftermath")
	CreditContent.Add("Emerald Prophecy")
	CreditContent.Add("Tiberian Genesis")
	CreditContent.Add("RG Community")
	CreditContent.Add("MPF Community")
	CreditContent.Add("CT Community")
	CreditContent.Add("FPI Community")
	CreditContent.Add("EKT Community")
	CreditContent.Add("AN Community")
	CreditContent.Add("Renegade X Modding Community")
	CreditContent.Add("Wiki Contributors")
	CreditContent.Add("Our loyal fans")
}