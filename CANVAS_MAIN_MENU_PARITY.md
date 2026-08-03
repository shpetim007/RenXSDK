# Canvas Main Menu Parity Checklist

Scope: replace `Rx_GFXFrontEnd` and its `Rx_GFxFrontEnd_*` Scaleform views with Canvas. Visual references are in `UDKGame/Screenshots/Win64`.

Legend: `[x]` implemented, `[-]` partial, `[ ]` not yet migrated.

## Shared shell

- [-] Full-screen front-end presentation: Canvas shell, mouse cursor, keyboard navigation, and exit confirmation exist; match the reference's horizontal top navigation, logo treatment, background visibility, profile, release/version, and subtitles.
- [x] Canvas input reaches the menu once per key press.
- [x] Direct IP text entry and `open <address>` action.
- [ ] Front-end error, version-out-of-date, download-progress, password, and confirmation dialogs (`Rx_GFXFrontEnd.uc`, `Rx_GFxFrontEnd_Dialog.uc`, `Rx_GFxFrontEnd_ExitDialog.uc`).
- [ ] Front-end music/Jukebox controls and profile/login presentation.

Reference: `main-menu-welcome-screen.jpg`.

## Multiplayer

Reference: `main-menu-multiplayer-online.jpg`; source: `Rx_GFxFrontEnd_Multiplayer.uc`.

- [ ] Online/local mode tabs.
- [-] Server query lifecycle: Canvas refresh, ping completion, incremental list updates, empty/loading/error states exist; local-query mode is still absent.
- [-] Scrollable server list: map name, server name, players, ping, lock marker, selected row exist; sorting, thumbnails, game mode, ranked/favourite markers remain.
- [x] Selected-server detail panel: map, player/time/mine/vehicle limits, crates, auto-balance, password, and ranked values.
- [-] Join selected server and a Canvas password prompt for locked servers; no failed-password/error handling yet.
- [-] Enter-IP join path (Canvas address entry supports IP/hostname and an optional query string; no separate validation yet).
- [ ] Browser filters: gameplay preset, player capacity, free slots, password, ranked, geographic regions, maps/game filters.
- [ ] Host flow: name/password/IP/max players, dedicated/autorestart/quickmatch/tracking, team controls, map/game rules, launch.

## Skirmish

Reference: `main-menu-skirmish-map.jpg`; source: `Rx_GFxFrontEnd_Skirmish.uc`.

- [-] Launch path (currently fixed CNC-Field/default bots only).
- [ ] Map/Game tabs and game-mode selector.
- [ ] Scrollable map list with map image and map metadata: size, style, recommended players, air vehicles, tech buildings, base defences.
- [ ] GDI/Nod bot class, tactic, attack strength, and count settings.
- [ ] Starting team and starting credits.
- [ ] Time, mine, and vehicle limit steppers.
- [ ] Friendly fire, repair buildings, base destruction, end-game pedestal, and time-limit-expiry checkboxes.
- [ ] Persist/reload `Rx_UIDataProvider_MapInfo` skirmish configuration and build the exact launch URL used by `LaunchSkirmishGame()`.

## Settings (shared with pause)

Reference: `pause-settings-video.jpg`, `pause-settings-audio.jpg`, `pause-settings-input.jpg`, `pause-settings-interface.jpg`; sources: `Rx_GFxFrontEnd_Settings.uc`, `Rx_GFxPauseMenu_SettingsMenu.uc`, `Rx_SystemSettingsHandler.uc`.

- [-] Shared Canvas component and tab layout exist.
- [x] Resolution, anti-aliasing, graphics bucket, brightness, FOV, FPS cap, VSync, motion blur, dynamic lights/shadows, ambient occlusion, PhysX.
- [-] Video remaining: screen mode, texture filtering/detail, detail/character/effects/shadow LOD, gore, light-environment/composite/directional lighting, bloom/DoF/threshold, lens flares, distortion/particle drop, static/dynamic decals, frame smoothing, D3D10/D3D9 MSAA.
- [-] Audio: SFX/music/ambiance/dialogue/EVA volume implemented.
- [ ] Audio remaining: OpenAL, hit sounds, autoplay, kill sound selection/preview, complete music playlist/player controls.
- [-] Input: mouse sensitivity/smoothing, invert Y, weapon hand, tank reverse, ADS/crouch/sprint toggles, team-name colors implemented.
- [ ] Input remaining: gamepad sensitivity and scrollable primary/secondary key-binding editor.
- [-] Interface: HUD scale and visibility flags, PT scene/menu, Canvas HUD, and radio list mode implemented.
- [ ] Interface remaining: beacon/crosshair selectors and custom radio command pages/bindings.
- [-] Canvas video Save and Reset Defaults actions plus an apply confirmation and 15-second resolution keep/revert prompt are implemented. Dropdown popup lists, slider dragging, full apply/back/discard behavior, and complete persistence parity remain.

## Extras and exit

Source: `Rx_GFxFrontEnd_Extras.uc`, `Rx_GFXFrontEnd.uc`.

- [-] About text/status exists.
- [ ] Credits/developer content, links, and all Extras actions.
- [-] Exit command exists.
- [ ] Exit confirmation dialog and cancel/focus behavior.

## Verification pass

- [ ] Compare 16:9, 16:10, ultrawide, and 720p/1080p/1440p layout against reference captures.
- [ ] Mouse hover/focus, keyboard/gamepad navigation, scrolling, disabled states, and tooltips.
- [ ] Verify no `Rx_GFxFrontEnd` movie starts from `Rx_Game_MainMenu.StartMatch()`.
