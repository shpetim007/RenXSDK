# Canvas HUD migration

The always-on Renegade X gameplay HUD can use either the original Scaleform
movies (`Rx_GFxHud` and `Rx_GFxGameinfoHud`) or `Rx_HUD_CanvasMain`, selected
through `[RenX_Game.Rx_HUD_Config] bUseCanvasHUD` in the RenegadeX config.
Only the selected implementation is initialized for a match.

Canvas positioning is configurable through `[RenX_Game.Rx_HUD_CanvasConfig]`.
Base settings can be refined by cumulative aspect-ratio, exact-resolution and
map-specific overrides. The configurable groups cover global scale and offset,
screen-edge safe zones, minimap scale, message scale, scoreboard scale and
tactical-overview scale.

## Canvas coverage

- Health, armour, stamina, weapon name and ammunition
- Veterancy rank and points
- Team scores, timer, credits, vehicle/mine limits and command points
- Compass and compact radar (friendlies and spotted enemies only)
- Chat, radio, EVA, admin, kill-feed and veterancy messages
- Gameplay tips, subtitles, spawn/countdown text and hit marker
- Vote, radio, commander, donate and help overlays
- Full scoreboard and tactical overview
- Survival wave/countdown information
- Native UDK console typing for global, team and private chat

The front end, pause/settings UI and purchase-terminal selection remain
independent screens. They were not converted as part of the always-on HUD
migration. The existing Canvas purchase terminal is unchanged.

## Validation

- Dual-HUD Win32 full UnrealScript compile: 0 errors
- Runtime selection: standalone `CNC-Field` initializes Canvas when
  `bUseCanvasHUD=true`
- Runtime selection: standalone `CNC-Field` initializes `Rx_GFxHud` when
  `bUseCanvasHUD=false`
- Layered runtime config: at 640x480 on `CNC-Field`, independent matching
  aspect-ratio, exact-resolution and map overrides composed as configured
- Win64 full UnrealScript compile: 0 errors
- Pre-existing compile warnings: 2, both for the missing
  `TS_HUD_Canvas.buildMenu.Materials.MI_Button_Simple` asset
- Runtime: standalone `CNC-Field`, windowed 640x480, low detail
- Runtime: Win64 dedicated `CNC-Field` server plus a windowed 640x480 client
- No `Rx_HUD_CanvasMain` script warnings in the final client/server run

Runtime logs and captures are in `UDKGame/Logs` and
`UDKGame/Screenshots/Win64` with the `CanvasHUD` prefix.

Original copies of edited pre-existing source files are under
`.codex-backup/CanvasHUD-20260725`.
