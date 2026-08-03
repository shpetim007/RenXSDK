/**
 * Shared native settings view used by both the front-end and the Canvas pause
 * menu.  Values are applied to Rx_SystemSettingsHandler immediately so there
 * is no Scaleform-specific settings state to keep in sync.
 */
class Rx_HUD_CanvasSettings extends Rx_Hud_Component;

enum ECanvasSettingsTab { CST_Video, CST_Audio, CST_Input, CST_Interface };
var ECanvasSettingsTab ActiveTab;
var int SelectedRow;
var int RowScroll;
var Rx_SystemSettingsHandler Settings;
var array<string> Resolutions;
var array<string> AntiAliasingOptions;
var int CurrentResolutionIndex;
var int CurrentAAIndex;
var bool bVideoDirty;
var int DialogState; // 0 none, 1 apply video, 2 keep resolution, 3 reset video
var string PreviousResolution;
var bool bPreviousFullscreen;
var float ResolutionDeadline;
var string StatusText;
var Color AccentColor, TextColor, MutedTextColor, PanelColor;

function InitSettings(Rx_HUD HUD)
{
	if(Settings == None)
	{
		Settings = HUD.WorldInfo.Spawn(class'Rx_SystemSettingsHandler');
		Settings.PopulateSystemSettings();
		Resolutions = Settings.GetAvailableResolutions();
		CurrentResolutionIndex = Resolutions.Find(Settings.GetCurrentResolution());
		if(CurrentResolutionIndex < 0) CurrentResolutionIndex = 0;
		AntiAliasingOptions = class'Rx_GFxFrontEnd_Settings'.default.ListAA;
		CurrentAAIndex = Clamp(Settings.CurrentAAType,0,AntiAliasingOptions.Length-1);
	}
}

function Update(float DeltaTime, Rx_HUD HUD)
{
	Super.Update(DeltaTime, HUD);
	if(Settings == None) InitSettings(HUD);
	if(DialogState == 2 && HUD.WorldInfo.TimeSeconds >= ResolutionDeadline)
	{
		RevertResolution();
		DialogState=0;
		StatusText="Resolution reverted.";
	}
}

function RenderSettings(float X, float Y, float W, float H, float Scale)
{
	local int i, Count, LastRow; local float RowHeight;
	Canvas.SetDrawColor(PanelColor.R, PanelColor.G, PanelColor.B, 235);
	Canvas.SetPos(X,Y); Canvas.DrawRect(W,H);
	DrawTabs(X,Y,W,Scale);
	Count = RowCount();
	RowHeight=GetRowHeight(H,Scale);
	LastRow=Min(Count,RowScroll+MaxVisibleRows());
	for(i=RowScroll;i<LastRow;i++) DrawRow(i, RowLabel(i), RowValue(i), X+42*Scale, Y+82*Scale+(i-RowScroll)*RowHeight, W-84*Scale, Scale, i==SelectedRow);
	if(Count>MaxVisibleRows()) DrawTextAt(string(RowScroll+1)$"-"$string(LastRow)$" OF "$string(Count),X+W-130*Scale,Y+62*Scale,MutedTextColor,0.48*Scale);
	if(ActiveTab == CST_Video)
	{
		DrawButton("SAVE",X+42*Scale,Y+H-78*Scale,150*Scale,42*Scale,Scale);
		DrawButton("RESET DEFAULTS",X+205*Scale,Y+H-78*Scale,220*Scale,42*Scale,Scale);
	}
	DrawTextAt((ActiveTab==CST_Video && bVideoDirty) ? "CLICK SAVE TO APPLY VIDEO CHANGES" : "LEFT / RIGHT TO CHANGE    •    ENTER TO TOGGLE    •    TAB TO SWITCH SECTION", X+42*Scale,Y+H-33*Scale,MutedTextColor,0.62*Scale);
	if(StatusText != "") DrawTextAt(StatusText,X+W-330*Scale,Y+H-33*Scale,AccentColor,0.62*Scale);
	if(DialogState != 0) RenderDialog(X,Y,W,H,Scale);
}

function DrawTabs(float X,float Y,float W,float Scale)
{
	local array<string> Tabs;
	local int i;
	Tabs.AddItem("VIDEO"); Tabs.AddItem("AUDIO"); Tabs.AddItem("INPUT"); Tabs.AddItem("INTERFACE");
	for(i=0;i<Tabs.Length;i++)
		DrawTextAt(Tabs[i], X+35*Scale+i*(W-70*Scale)/4, Y+18*Scale, i==ActiveTab ? AccentColor : TextColor, 0.76*Scale);
}

function DrawRow(int Row,string Label,string Value,float X,float Y,float W,float Scale,bool bSelected)
{
	if(bSelected)
	{
		Canvas.SetDrawColor(AccentColor.R,AccentColor.G,AccentColor.B,50);
		Canvas.SetPos(X-10*Scale,Y-5*Scale); Canvas.DrawRect(W,39*Scale);
	}
	DrawTextAt(Label,X,Y,TextColor,0.76*Scale);
	if(IsCheckboxRow(Row))
	{
		Canvas.SetDrawColor(bSelected ? AccentColor.R : MutedTextColor.R,bSelected ? AccentColor.G : MutedTextColor.G,bSelected ? AccentColor.B : MutedTextColor.B,255);
		Canvas.SetPos(X+W*0.57,Y+2*Scale); Canvas.DrawRect(18*Scale,18*Scale);
		if(Value=="ON") { Canvas.SetDrawColor(5,15,25,255); Canvas.SetPos(X+W*0.57+4*Scale,Y+6*Scale); Canvas.DrawRect(10*Scale,10*Scale); }
		DrawTextAt(Value,X+W*0.57+28*Scale,Y,bSelected ? AccentColor : MutedTextColor,0.76*Scale);
	}
	else DrawTextAt(Value,X+W*0.57,Y, bSelected ? AccentColor : MutedTextColor,0.76*Scale);
}

function DrawButton(string Label,float X,float Y,float W,float H,float Scale)
{
	Canvas.SetDrawColor(18,31,39,255); Canvas.SetPos(X,Y); Canvas.DrawRect(W,H);
	Canvas.SetDrawColor(AccentColor.R,AccentColor.G,AccentColor.B,255); Canvas.SetPos(X,Y); Canvas.DrawRect(3*Scale,H);
	DrawTextAt(Label,X+13*Scale,Y+8*Scale,AccentColor,0.66*Scale);
}

function RenderDialog(float X,float Y,float W,float H,float Scale)
{
	local float PX,PY,PW,PH, Remaining;
	PX=X+W*0.20; PY=Y+H*0.30; PW=W*0.60; PH=155*Scale;
	Canvas.SetDrawColor(0,0,0,175); Canvas.SetPos(X,Y); Canvas.DrawRect(W,H);
	Canvas.SetDrawColor(4,15,25,255); Canvas.SetPos(PX,PY); Canvas.DrawRect(PW,PH);
	Canvas.SetDrawColor(AccentColor.R,AccentColor.G,AccentColor.B,255); Canvas.SetPos(PX,PY); Canvas.DrawRect(PW,4*Scale);
	if(DialogState == 1)
	{
		DrawTextAt("APPLY VIDEO SETTINGS?",PX+20*Scale,PY+20*Scale,AccentColor,0.78*Scale);
		DrawTextAt("Apply your pending video settings now?",PX+20*Scale,PY+57*Scale,TextColor,0.60*Scale);
		DrawTextAt("YES: ENTER     NO: ESCAPE",PX+20*Scale,PY+113*Scale,MutedTextColor,0.55*Scale);
	}
	else if(DialogState == 2)
	{
		Remaining=FMax(0,ResolutionDeadline-RenxHud.WorldInfo.TimeSeconds);
		DrawTextAt("KEEP THIS RESOLUTION?",PX+20*Scale,PY+20*Scale,AccentColor,0.78*Scale);
		DrawTextAt("The previous resolution will be restored in " $ int(Remaining+0.99) $ " seconds.",PX+20*Scale,PY+57*Scale,TextColor,0.60*Scale);
		DrawTextAt("KEEP: ENTER     REVERT: ESCAPE",PX+20*Scale,PY+113*Scale,MutedTextColor,0.55*Scale);
	}
	else
	{
		DrawTextAt("RESET VIDEO DEFAULTS?",PX+20*Scale,PY+20*Scale,AccentColor,0.78*Scale);
		DrawTextAt("Restore the Canvas video options to their defaults?",PX+20*Scale,PY+57*Scale,TextColor,0.60*Scale);
		DrawTextAt("RESET: ENTER     CANCEL: ESCAPE",PX+20*Scale,PY+113*Scale,MutedTextColor,0.55*Scale);
	}
}

function DrawTextAt(string Text,float X,float Y,Color DrawColor,float Scale)
{
	Canvas.SetDrawColor(DrawColor.R,DrawColor.G,DrawColor.B,DrawColor.A);
	Canvas.SetPos(X,Y); Canvas.DrawText(Text,false,Scale,Scale);
}

function int RowCount()
{
	switch(ActiveTab)
	{
		case CST_Video: return 12;
		case CST_Audio: return 5;
		case CST_Input: return 9;
		case CST_Interface: return 10;
	}
	return 0;
}

function string RowLabel(int Row)
{
	switch(ActiveTab)
	{
		case CST_Video:
			switch(Row) { case 0:return "SCREEN RESOLUTION"; case 1:return "ANTI-ALIASING"; case 2:return "GRAPHICS PRESET"; case 3:return "BRIGHTNESS"; case 4:return "FIELD OF VIEW"; case 5:return "FRAME RATE CAP"; case 6:return "V-SYNC"; case 7:return "MOTION BLUR"; case 8:return "DYNAMIC LIGHTS"; case 9:return "DYNAMIC SHADOWS"; case 10:return "AMBIENT OCCLUSION"; case 11:return "HARDWARE PHYSX"; }
		case CST_Audio:
			switch(Row) { case 0:return "SFX VOLUME"; case 1:return "MUSIC VOLUME"; case 2:return "AMBIANCE VOLUME"; case 3:return "DIALOGUE VOLUME"; case 4:return "E.V.A. VOLUME"; }
		case CST_Input:
			switch(Row) { case 0:return "MOUSE SENSITIVITY"; case 1:return "MOUSE SMOOTHING"; case 2:return "INVERT Y AXIS"; case 3:return "TANK REVERSE"; case 4:return "TOGGLE ADS"; case 5:return "TOGGLE CROUCH"; case 6:return "TOGGLE SPRINT"; case 7:return "WEAPON HAND"; case 8:return "TEAM NAME COLORS"; }
		case CST_Interface:
			switch(Row) { case 0:return "HUD SCALE"; case 1:return "MINIMAP"; case 2:return "GAME INFO"; case 3:return "TEAM INFO"; case 4:return "PERSONAL INFO"; case 5:return "SCORE PANEL"; case 6:return "DISABLE PT SCENE"; case 7:return "CANVAS GAME HUD"; case 8:return "CANVAS PURCHASE MENU"; case 9:return "RADIO COMMAND LIST"; }
	}
	return "";
}

function string RowValue(int Row)
{
	if(Settings == None) return "";
	switch(ActiveTab)
	{
		case CST_Video:
			switch(Row) { case 0:return Resolutions.Length>0 ? Resolutions[CurrentResolutionIndex] : Settings.GetCurrentResolution(); case 1:return AntiAliasingOptions.Length>0 ? AntiAliasingOptions[CurrentAAIndex] : "DEFAULT"; case 2:return PresetName(Settings.GraphicsPresetLevel); case 3:return string(int(Settings.GetGammaSettings()*20))$"%"; case 4:return string(int(Settings.GetFOV())); case 5:return string(int(Settings.GetFPSSetting())); case 6:return BoolText(Settings.UseVsync); case 7:return BoolText(Settings.MotionBlur); case 8:return BoolText(Settings.DynamicLights); case 9:return BoolText(Settings.DynamicShadows); case 10:return BoolText(Settings.AmbientOcclusion); case 11:return BoolText(!Settings.GetDisablePhysXHardwareSupport()); }
		case CST_Audio:
			switch(Row) { case 0:return Percent(Settings.SFXVolume); case 1:return Percent(Settings.MusicVolume); case 2:return Percent(Settings.AmbientVolume); case 3:return Percent(Settings.CharacterVolume); case 4:return Percent(Settings.AnnouncerVolume); }
		case CST_Input:
			switch(Row) { case 0:return string(int(Settings.GetMouseSensitivity())); case 1:return BoolText(Settings.GetEnableMouseSmoothing()); case 2:return BoolText(Settings.GetInvertYAxis()); case 3:return BoolText(Settings.GetToggleTankReverse()); case 4:return BoolText(Settings.GetToggleADS()); case 5:return BoolText(Settings.GetToggleCrouch()); case 6:return BoolText(Settings.GetToggleSprint()); case 7:return Settings.GetWeaponHand()==0 ? "LEFT" : "RIGHT"; case 8:return BoolText(Settings.GetNicknamesUseTeamColors()); }
		case CST_Interface:
			switch(Row) { case 0:return string(int(Settings.HUDScale))$"%"; case 1:return BoolText(Settings.bMinimap); case 2:return BoolText(Settings.bGameInfo); case 3:return BoolText(Settings.bTeamInfo); case 4:return BoolText(Settings.bPersonalInfo); case 5:return BoolText(Settings.bScorePanel); case 6:return BoolText(Settings.bDisablePTScene); case 7:return BoolText(class'Rx_HUD_Config'.default.bUseCanvasHUD); case 8:return BoolText(Settings.SelectedPTMenu); case 9:return Settings.RadioCommand==0 ? "DEFAULT" : (Settings.RadioCommand==1 ? "CLASSIC" : "CUSTOM"); }
	}
	return "";
}

function string BoolText(bool bValue) { return bValue ? "ON" : "OFF"; }
function string Percent(float Value) { return string(int(Value*100))$"%"; }
function string PresetName(int Value)
{
	switch(Value) { case 1:return "MINIMUM"; case 2:return "LOW"; case 3:return "MEDIUM"; case 4:return "HIGH"; case 5:return "VERY HIGH"; case 6:return "ULTRA"; }
	return "CUSTOM";
}

function OnKeyPress(name Key)
{
	local string KeyText;
	KeyText=Caps(string(Key));
	if(DialogState != 0)
	{
		if(KeyText=="ENTER" || KeyText=="SPACEBAR") ConfirmDialog();
		else if(KeyText=="ESCAPE" || KeyText=="BACKSPACE") CancelDialog();
		return;
	}
	if(KeyText=="TAB") { ActiveTab=ECanvasSettingsTab((int(ActiveTab)+1)%4); SelectedRow=0; RowScroll=0; return; }
	if(KeyText=="UP") { SelectedRow=(SelectedRow+RowCount()-1)%RowCount(); EnsureSelectedVisible(); return; }
	if(KeyText=="DOWN") { SelectedRow=(SelectedRow+1)%RowCount(); EnsureSelectedVisible(); return; }
	if(KeyText=="LEFT") { ChangeSelected(-1); return; }
	if(KeyText=="RIGHT") { ChangeSelected(1); return; }
	if((KeyText=="ENTER" || KeyText=="SPACEBAR") && IsCheckboxRow(SelectedRow)) { ChangeSelected(1); return; }
}

function bool IsCheckboxRow(int Row)
{
	switch(ActiveTab)
	{
		case CST_Video: return Row>=6;
		case CST_Audio: return false;
		case CST_Input: return Row>=1 && Row!=7;
		case CST_Interface: return Row>=1 && Row!=9;
	}
	return false;
}

function ChangeSelected(int Direction)
{
	local float Value;
	if(Settings == None) return;
	switch(ActiveTab)
	{
		case CST_Video:
			bVideoDirty=true;
			switch(SelectedRow) { case 0: ChangeResolution(Direction); break; case 1: ChangeAntiAliasing(Direction); break; case 2: Settings.SetSettingBucket(byte(Clamp(Settings.GraphicsPresetLevel+Direction,0,6))); break; case 3: Settings.SetGammaSettings(FClamp(Settings.GetGammaSettings()+Direction*0.05,0.5,2.0)); break; case 4: Settings.SetFOV(FClamp(Settings.GetFOV()+Direction*5,70,120)); break; case 5:Settings.SetFPSSetting(FClamp(Settings.GetFPSSetting()+Direction*5,30,240)); break; case 6: ToggleScaleBool("UseVsync",Settings.UseVsync); break; case 7: ToggleScaleBool("MotionBlur",Settings.MotionBlur); break; case 8: ToggleScaleBool("DynamicLights",Settings.DynamicLights); break; case 9: ToggleScaleBool("DynamicShadows",Settings.DynamicShadows); break; case 10: Settings.SetAmbientOcclusion(!Settings.AmbientOcclusion); break; case 11: Settings.SetDisablePhysXHardwareSupport(!Settings.GetDisablePhysXHardwareSupport()); break; }
			break;
		case CST_Audio:
			switch(SelectedRow) { case 0: Value=FClamp(Settings.SFXVolume+Direction*0.05,0,1); Settings.SFXVolume=Value; SetVolume("SFX",Value); break; case 1: Value=FClamp(Settings.MusicVolume+Direction*0.05,0,1); Settings.MusicVolume=Value; SetVolume("Music",Value); break; case 2: Value=FClamp(Settings.AmbientVolume+Direction*0.05,0,1); Settings.AmbientVolume=Value; SetVolume("Ambient",Value); break; case 3: Value=FClamp(Settings.CharacterVolume+Direction*0.05,0,1); Settings.CharacterVolume=Value; SetVolume("Character",Value); break; case 4: Value=FClamp(Settings.AnnouncerVolume+Direction*0.05,0,1); Settings.AnnouncerVolume=Value; SetVolume("Announcer",Value); break; } Settings.SaveConfig(); break;
		case CST_Input:
			switch(SelectedRow) { case 0: Settings.SetMouseSensitivity(FClamp(Settings.GetMouseSensitivity()+Direction,1,20)); break; case 1: Settings.SetEnableMouseSmoothing(!Settings.GetEnableMouseSmoothing()); break; case 2: Settings.SetInvertYAxis(!Settings.GetInvertYAxis()); break; case 3: Settings.SetToggleTankReverse(!Settings.GetToggleTankReverse()); break; case 4: Settings.SetToggleADS(!Settings.GetToggleADS()); break; case 5: Settings.SetToggleCrouch(!Settings.GetToggleCrouch()); break; case 6: Settings.SetToggleSprint(!Settings.GetToggleSprint()); break; case 7: Settings.SetWeaponHand((Settings.GetWeaponHand()+1)%2); break; case 8: Settings.SetNicknamesUseTeamColors(!Settings.GetNicknamesUseTeamColors()); break; } break;
		case CST_Interface:
			switch(SelectedRow) { case 0: Settings.HUDScale=FClamp(Settings.HUDScale+Direction*5,50,150); Settings.SaveConfig(); break; case 1:Settings.bMinimap=!Settings.bMinimap; break; case 2:Settings.bGameInfo=!Settings.bGameInfo; break; case 3:Settings.bTeamInfo=!Settings.bTeamInfo; break; case 4:Settings.bPersonalInfo=!Settings.bPersonalInfo; break; case 5:Settings.bScorePanel=!Settings.bScorePanel; break; case 6:Settings.bDisablePTScene=!Settings.bDisablePTScene; break; case 7:class'Rx_HUD_Config'.default.bUseCanvasHUD=!class'Rx_HUD_Config'.default.bUseCanvasHUD; class'Rx_HUD_Config'.static.StaticSaveConfig(); RenxHud.bUsingCanvasHUD=class'Rx_HUD_Config'.default.bUseCanvasHUD; return; case 8:Settings.SelectedPTMenu=!Settings.SelectedPTMenu; break; case 9:Settings.SetRadioCommand((Settings.RadioCommand+1)%3); return; } Settings.SaveConfig(); break;
	}
}

function ToggleScaleBool(string SettingName,bool bCurrent) { ConsoleCommand("SCALE SET " $ SettingName $ " " $ (!bCurrent)); Settings.PopulateSystemSettings(); }
function SetVolume(string Group,float Value) { Rx_Controller(RenxHud.PlayerOwner).SetAudioGroupVolume(name(Group),Value); }
function ChangeResolution(int Direction)
{
	if(Resolutions.Length == 0) return;
	CurrentResolutionIndex=(CurrentResolutionIndex+Direction+Resolutions.Length)%Resolutions.Length;
}
function ChangeAntiAliasing(int Direction)
{
	local int Index;
	if(AntiAliasingOptions.Length == 0) return;
	Index=(CurrentAAIndex+Direction+AntiAliasingOptions.Length)%AntiAliasingOptions.Length;
	CurrentAAIndex=Index;
	Settings.SetAntiAliasing(AntiAliasingOptions[Index]);
}
function int MaxVisibleRows()
{
	if(ActiveTab==CST_Video || ActiveTab==CST_Input || ActiveTab==CST_Interface) return 8;
	return RowCount();
}

function float GetRowHeight(float H,float Scale) { return FMin(48*Scale,(H-(ActiveTab==CST_Video ? 180 : 125)*Scale)/MaxVisibleRows()); }

function EnsureSelectedVisible()
{
	if(SelectedRow<RowScroll) RowScroll=SelectedRow;
	if(SelectedRow>=RowScroll+MaxVisibleRows()) RowScroll=SelectedRow-MaxVisibleRows()+1;
}

function HandleLeftClick(int MouseX,int MouseY,float X,float Y,float W,float H,float Scale)
{
	local int Tab, Row; local float RowHeight;
	if(DialogState != 0)
	{
		if(MouseY >= Y+H*0.30 && MouseY <= Y+H*0.30+155*Scale && MouseX >= X+W*0.20 && MouseX <= X+W*0.80) ConfirmDialog();
		return;
	}
	if(MouseY>=Y && MouseY<=Y+60*Scale)
	{
		Tab=int((MouseX-X)/(W/4));
		if(Tab>=0 && Tab<4) { ActiveTab=ECanvasSettingsTab(Tab); SelectedRow=0; RowScroll=0; }
		return;
	}
	RowHeight=GetRowHeight(H,Scale);
	if(ActiveTab==CST_Video && MouseY>=Y+H-82*Scale && MouseY<=Y+H-30*Scale)
	{
		if(MouseX>=X+42*Scale && MouseX<=X+192*Scale) { RequestSaveVideo(); return; }
		if(MouseX>=X+205*Scale && MouseX<=X+425*Scale) { DialogState=3; return; }
	}
	Row=RowScroll+int((MouseY-(Y+82*Scale))/RowHeight);
	if(Row>=0 && Row<RowCount())
	{
		SelectedRow=Row;
		// A row click only selects it. Checkbox state changes only when its
		// checkbox/value area is clicked, matching the Scaleform interaction.
		if(IsCheckboxRow(Row) && MouseX>=X+W*0.57)
			ChangeSelected(1);
	}
}

function RequestSaveVideo()
{
	if(!bVideoDirty) { StatusText="No pending video changes."; return; }
	DialogState=1;
}

function ConfirmDialog()
{
	if(DialogState == 1) ApplyVideoChanges();
	else if(DialogState == 2)
	{
		Settings.SaveConfig();
		bVideoDirty=false; DialogState=0; StatusText="Resolution kept.";
	}
	else if(DialogState == 3) ResetVideoDefaults();
}

function CancelDialog()
{
	if(DialogState == 2) { RevertResolution(); StatusText="Resolution reverted."; }
	DialogState=0;
}

function ApplyVideoChanges()
{
	local string Resolution, Mode;
	if(Resolutions.Length > 0 && Resolutions[CurrentResolutionIndex] != Settings.GetCurrentResolution())
	{
		PreviousResolution=Settings.GetCurrentResolution();
		bPreviousFullscreen=Settings.IsFullScreen();
		Resolution=Resolutions[CurrentResolutionIndex];
		Mode=Settings.IsFullScreen() ? "f" : "w";
		ConsoleCommand("setres " $ Resolution $ Mode);
		Settings.ResX=int(Left(Resolution,Len(Resolution)-Len(Split(Resolution,"x",false))));
		Settings.ResY=int(Split(Resolution,"x",true));
		ResolutionDeadline=RenxHud.WorldInfo.TimeSeconds+15.0;
		DialogState=2;
		return;
	}
	Settings.SaveConfig(); bVideoDirty=false; DialogState=0; StatusText="Video settings saved.";
}

function RevertResolution()
{
	if(PreviousResolution == "") return;
	ConsoleCommand("setres " $ PreviousResolution $ (bPreviousFullscreen ? "f" : "w"));
	Settings.ResX=int(Left(PreviousResolution,Len(PreviousResolution)-Len(Split(PreviousResolution,"x",false))));
	Settings.ResY=int(Split(PreviousResolution,"x",true));
	CurrentResolutionIndex=Resolutions.Find(PreviousResolution);
	bVideoDirty=false;
}

function ResetVideoDefaults()
{
	Settings.SetSettingBucket(3);
	Settings.SetAntiAliasing("Off"); CurrentAAIndex=0;
	Settings.SetGammaSettings(1.0);
	Settings.SetFOV(90); Settings.SetFPSSetting(60);
	if(Settings.UseVsync) ToggleScaleBool("UseVsync",true);
	if(!Settings.MotionBlur) ToggleScaleBool("MotionBlur",false);
	if(!Settings.DynamicLights) ToggleScaleBool("DynamicLights",false);
	if(!Settings.DynamicShadows) ToggleScaleBool("DynamicShadows",false);
	if(Settings.AmbientOcclusion) Settings.SetAmbientOcclusion(false);
	if(Settings.GetDisablePhysXHardwareSupport()) Settings.SetDisablePhysXHardwareSupport(false);
	CurrentResolutionIndex=Resolutions.Find("1920x1080");
	if(CurrentResolutionIndex < 0) CurrentResolutionIndex=0;
	bVideoDirty=true; DialogState=0; StatusText="Video defaults selected. Press SAVE to apply.";
}

DefaultProperties
{
	AccentColor=(R=240,G=35,B=30,A=255)
	TextColor=(R=220,G=240,B=245,A=255)
	MutedTextColor=(R=135,G=190,B=210,A=255)
	PanelColor=(R=4,G=15,B=25,A=240)
}
