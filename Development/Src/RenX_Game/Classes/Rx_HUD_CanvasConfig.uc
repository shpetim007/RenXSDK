/**
 * Layered layout configuration for the Canvas gameplay HUD.
 *
 * Order: base values, matching aspect-ratio entries, exact-resolution
 * entries, then matching map entries. Multipliers are cumulative and offsets
 * are additive. A zero multiplier in an override means "leave unchanged".
 */
class Rx_HUD_CanvasConfig extends Object
	config(RenegadeX);

struct CanvasHUDLayoutOverride
{
	var string ProfileName;
	var float MinAspectRatio;
	var float MaxAspectRatio;
	var int ResolutionX;
	var int ResolutionY;
	var string MapName;
	var float GlobalScale;
	var float HorizontalOffset;
	var float VerticalOffset;
	var float HorizontalSafeZone;
	var float VerticalSafeZone;
	var float MinimapScale;
	var float MessageScale;
	var float ScoreboardScale;
	var float OverviewScale;
};

var config float BaseGlobalScale;
var config float BaseHorizontalOffset;
var config float BaseVerticalOffset;
var config float BaseHorizontalSafeZone;
var config float BaseVerticalSafeZone;
var config float BaseMinimapScale;
var config float BaseMessageScale;
var config float BaseScoreboardScale;
var config float BaseOverviewScale;

var config array<CanvasHUDLayoutOverride> AspectRatioOverrides;
var config array<CanvasHUDLayoutOverride> ResolutionOverrides;
var config array<CanvasHUDLayoutOverride> MapOverrides;

static final function ApplyOverride(
	CanvasHUDLayoutOverride LayoutOverride,
	out float GlobalScale,
	out float HorizontalOffset,
	out float VerticalOffset,
	out float HorizontalSafeZone,
	out float VerticalSafeZone,
	out float MinimapScale,
	out float MessageScale,
	out float ScoreboardScale,
	out float OverviewScale)
{
	if(LayoutOverride.GlobalScale > 0)
		GlobalScale *= LayoutOverride.GlobalScale;
	HorizontalOffset += LayoutOverride.HorizontalOffset;
	VerticalOffset += LayoutOverride.VerticalOffset;
	HorizontalSafeZone += LayoutOverride.HorizontalSafeZone;
	VerticalSafeZone += LayoutOverride.VerticalSafeZone;
	if(LayoutOverride.MinimapScale > 0)
		MinimapScale *= LayoutOverride.MinimapScale;
	if(LayoutOverride.MessageScale > 0)
		MessageScale *= LayoutOverride.MessageScale;
	if(LayoutOverride.ScoreboardScale > 0)
		ScoreboardScale *= LayoutOverride.ScoreboardScale;
	if(LayoutOverride.OverviewScale > 0)
		OverviewScale *= LayoutOverride.OverviewScale;
}

static final function ResolveLayout(
	int ScreenWidth,
	int ScreenHeight,
	string CurrentMapName,
	out float GlobalScale,
	out float HorizontalOffset,
	out float VerticalOffset,
	out float HorizontalSafeZone,
	out float VerticalSafeZone,
	out float MinimapScale,
	out float MessageScale,
	out float ScoreboardScale,
	out float OverviewScale)
{
	local int i;
	local float AspectRatio;
	local CanvasHUDLayoutOverride LayoutOverride;

	GlobalScale = default.BaseGlobalScale > 0 ? default.BaseGlobalScale : 1.0;
	HorizontalOffset = default.BaseHorizontalOffset;
	VerticalOffset = default.BaseVerticalOffset;
	HorizontalSafeZone = FMax(0, default.BaseHorizontalSafeZone);
	VerticalSafeZone = FMax(0, default.BaseVerticalSafeZone);
	MinimapScale = default.BaseMinimapScale > 0 ? default.BaseMinimapScale : 1.0;
	MessageScale = default.BaseMessageScale > 0 ? default.BaseMessageScale : 1.0;
	ScoreboardScale = default.BaseScoreboardScale > 0 ? default.BaseScoreboardScale : 1.0;
	OverviewScale = default.BaseOverviewScale > 0 ? default.BaseOverviewScale : 1.0;

	AspectRatio = ScreenHeight > 0 ? float(ScreenWidth) / float(ScreenHeight) : 1.0;
	for(i = 0; i < default.AspectRatioOverrides.Length; ++i)
	{
		LayoutOverride = default.AspectRatioOverrides[i];
		if((LayoutOverride.MinAspectRatio <= 0 || AspectRatio >= LayoutOverride.MinAspectRatio)
			&& (LayoutOverride.MaxAspectRatio <= 0 || AspectRatio <= LayoutOverride.MaxAspectRatio))
		{
			ApplyOverride(LayoutOverride, GlobalScale, HorizontalOffset, VerticalOffset,
				HorizontalSafeZone, VerticalSafeZone, MinimapScale, MessageScale,
				ScoreboardScale, OverviewScale);
		}
	}

	for(i = 0; i < default.ResolutionOverrides.Length; ++i)
	{
		LayoutOverride = default.ResolutionOverrides[i];
		if(LayoutOverride.ResolutionX == ScreenWidth && LayoutOverride.ResolutionY == ScreenHeight)
		{
			ApplyOverride(LayoutOverride, GlobalScale, HorizontalOffset, VerticalOffset,
				HorizontalSafeZone, VerticalSafeZone, MinimapScale, MessageScale,
				ScoreboardScale, OverviewScale);
		}
	}

	for(i = 0; i < default.MapOverrides.Length; ++i)
	{
		LayoutOverride = default.MapOverrides[i];
		if(LayoutOverride.MapName != "" && Caps(LayoutOverride.MapName) == Caps(CurrentMapName))
		{
			ApplyOverride(LayoutOverride, GlobalScale, HorizontalOffset, VerticalOffset,
				HorizontalSafeZone, VerticalSafeZone, MinimapScale, MessageScale,
				ScoreboardScale, OverviewScale);
		}
	}

	GlobalScale = FClamp(GlobalScale, 0.5, 2.0);
	MinimapScale = FClamp(MinimapScale, 0.5, 2.0);
	MessageScale = FClamp(MessageScale, 0.5, 2.0);
	ScoreboardScale = FClamp(ScoreboardScale, 0.5, 1.5);
	OverviewScale = FClamp(OverviewScale, 0.5, 1.25);
}
