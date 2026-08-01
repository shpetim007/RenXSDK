# Renegade X Canvas HUD

This source patch adds a native UE3 Canvas HUD alongside the original
Scaleform gameplay HUD. The Canvas implementation includes the normal player
HUD, minimap, tactical map, scoreboard, messages, votes, death/spectator
presentation, endgame UI, and the Survival wave extension. Scaleform
front-end, pause, settings, and purchase-terminal screens remain unchanged.

## Select the gameplay HUD

The distributed default is in `UDKGame\Config\DefaultRenegadeX.ini`:

```ini
[RenX_Game.Rx_HUD_Config]
bUseCanvasHUD=true
```

Set `bUseCanvasHUD=false` to use the original Scaleform/GFx gameplay HUD.
The selection is read when the HUD is created, normally on map load.

An existing SDK install may already have a generated
`UDKGame\Config\UDKRenegadeX.ini`. Change the same setting there for a local
test, or regenerate the UDK config files after changing the distributed
default.

## Customize the Canvas HUD

Canvas layout settings live under `[RenX_Game.Rx_HUD_CanvasConfig]`. The base
values affect every resolution and map:

```ini
[RenX_Game.Rx_HUD_CanvasConfig]
BaseGlobalScale=1.0
BaseHorizontalOffset=0.0
BaseVerticalOffset=0.0
BaseHorizontalSafeZone=0.0
BaseVerticalSafeZone=0.0
BaseMinimapScale=1.0
BaseMessageScale=1.0
BaseScoreboardScale=1.0
BaseOverviewScale=1.0
```

Scale values are multipliers. Offsets and safe zones use reference pixels at
1280x720 and scale with screen height. Positive offsets move the HUD right or
down. Safe zones move edge-anchored UI inward.

Overrides are layered in this order: matching aspect ratio, exact resolution,
then map. All matching entries are cumulative. A missing or zero multiplier
means "do not change this multiplier"; offsets and safe zones are additive.

```ini
+AspectRatioOverrides=(ProfileName="Ultrawide",MinAspectRatio=2.20,MaxAspectRatio=4.00,GlobalScale=0.92,HorizontalSafeZone=24.0)
+ResolutionOverrides=(ProfileName="Small 720p",ResolutionX=1280,ResolutionY=720,MessageScale=0.92,ScoreboardScale=0.95)
+MapOverrides=(ProfileName="Field",MapName="CNC-Field",MinimapScale=1.05,HorizontalOffset=0.0,VerticalOffset=0.0)
```

Put settings intended for everyone in `DefaultRenegadeX.ini`, using the `+`
prefix shown above for array entries. Put local tuning in the generated
`UDKGame\Config\UDKRenegadeX.ini`; in that generated file, omit the `+` prefix
(`AspectRatioOverrides=(...)`). An already-generated local config may need to
be updated or regenerated before new defaults take effect. Layout is resolved
again when the screen resolution or map changes.

## Install

1. Back up the target SDK.
2. Extract this ZIP beside the target `RenXSDK` folder and merge/overwrite the
   included files. The archive already has `RenXSDK` as its root.
3. Delete these stale compiled script packages if present:

   - `RenXSDK\UDKGame\Script\RenX_Game.u`
   - `RenXSDK\UDKGame\Script\RenX_Coop.u`
   - `RenXSDK\UDKGame\Script\RenX_Extra.u`
   - `RenXSDK\UDKGame\Script\RenX_ExampleMutators.u`

4. From the target `RenXSDK` folder, rebuild:

   ```powershell
   .\Binaries\Win64\UDK.exe make -unattended -nopause
   ```

Do **not** delete the GFx/Scaleform classes or `.upk` assets. They are required
by the original gameplay HUD and by non-gameplay menus. This patch is intended
for the same Renegade X SDK revision because `Rx_HUD.uc` and
`Rx_Controller.uc` are whole-file replacements.
