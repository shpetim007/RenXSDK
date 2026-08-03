# Canvas Pause Menu Parity Checklist

Scope: replace `Rx_GFxPauseMenu` and subviews with Canvas. Visual references are in `UDKGame/Screenshots/Win64`.

Legend: `[x]` implemented, `[-]` partial, `[ ]` not yet migrated.

## Shared pause shell

Reference: all `pause-*.jpg`; source: `Rx_GFxPauseMenu.uc`.

- [-] Full-screen Canvas overlay, top/bottom navigation, cursor, pause/unpause, and input capture exist.
- [x] Escape alternates pause state once per press.
- [ ] Match reference title/subtitle, server name/message, disabled state, selected-state animation, fade, and responsive layout exactly.
- [ ] End-of-match behavior and scoreboard handoff.
- [ ] Verify no `Rx_GFxPauseMenu` or fade Scaleform movie starts when Canvas HUD is enabled.

## Scoreboard

Source: `Rx_GFxPauseMenu_Scoreboard.uc`.

- [-] Canvas player/score list exists.
- [ ] Full legacy columns, team grouping/totals, sort order, scroll behavior, MVP/status indicators, and chat integration.

## How to Play

Reference: `pause-how-to-play.jpg`.

- [-] Canvas information cards cover base, teams, economy, terminals, characters, and items.
- [ ] Match visual hierarchy, illustrations/icons, full text, panel layout, and responsive scaling from the reference.

## Chat

Source: `Rx_GFxPauseMenu_ChatMenu.uc`; color source: `Rx_HUD.Message()`.

- [-] Persistent Canvas history, All/Private tabs, player list, selected-player PM filter, and public/private chat launch are implemented.
- [ ] Scrollbar, mouse-wheel/page scrolling, message wrapping, timestamps, unread indicators, and live-bottom behavior.
- [ ] Ensure all public/team/host/private/admin color and formatting cases match the HUD/Scaleform output.
- [ ] Chat input field, editing/cancel behavior, and private-recipient selection ergonomics.

## Donate credits

Reference: `pause-donate-credits.jpg`; source: `Rx_GFxPauseMenu_DonateMenu.uc`.

- [-] Team-player list, current credits, amount entry, donate-to-player/team/all-team actions exist.
- [ ] Mouse player selection, amount validation/error messaging, disabled actions, scroll behavior, and post-donation feedback.

## Direct actions

- [x] Suicide executes `suicide`.
- [x] Change Teams executes `changeteam`.
- [x] Resume closes Canvas pause.
- [-] Exit disconnects; confirmation and any return-to-menu rules remain.
- [x] Vote omitted by design; it is dead/unimplemented legacy UI.

## Settings

Reference: four `pause-settings-*.jpg`; source: `Rx_GFxPauseMenu_SettingsMenu.uc`.

- [-] Uses the shared Canvas settings component listed in `CANVAS_MAIN_MENU_PARITY.md`.
- [ ] Complete each outstanding Settings item there before declaring either main-menu or pause Settings parity.
- [ ] Add pause-specific Back/Apply behavior and video-apply confirmation where needed.

## Verification pass

- [ ] Test in standalone, listen server, client, spectator, and match-over states.
- [ ] Test Esc, mouse, keyboard, gamepad, scrollbar/wheel, focus changes, and chat typing.
- [ ] Confirm opening/closing pause does not leave movement disabled, cursor active, firing held, or a Scaleform movie alive.
