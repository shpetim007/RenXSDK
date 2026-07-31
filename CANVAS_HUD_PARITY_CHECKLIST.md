# Renegade X Canvas HUD parity checklist

Reference screenshots: `UDKGame/Screenshots/Win64/comparison`

Implementation strategy: batch source changes first, then compile and perform
runtime comparison passes to minimize UDK startup/build cycles.

## 0. Integration safety

- [x] Preserve the user-updated `Rx_Controller.uc`, `Rx_GFxMinimap.uc`, and
  `Rx_GFxOverviewMap.uc` before editing.
- [x] Rebase Canvas message, respawn, chat, vote, and startup routing onto the
  updated controller.
- [x] Keep the legacy GFx map classes as data/behavior references; do not start
  them for the gameplay HUD.

## 1. Shared Canvas map renderer

- [x] Read `Rx_MapInfo.MapTexture`, `MapCenter`, `MapExtent`,
  `MinimapCurrentZoom`, `MinimapNormalZoom`, `MinimapScale`, and
  `OverviewScale`.
- [x] Provide consistent world-to-map conversion for every map.
- [x] Support north-up overview rendering and player-rotated minimap rendering.
- [x] Share actor visibility, team color, stealth, spotted-enemy, squad-marker
  hooks, and vehicle-icon rules between both map modes.

## 2. Bottom-left minimap

- [x] Move the minimap to the bottom-left.
- [x] Draw the actual zoomed-in map texture rather than a blank radar panel.
- [x] Draw player, friendly infantry, friendly vehicles, spotted enemies,
  radar objectives, beacons, buildings, tech buildings, and squad-marker hooks.
- [x] Use actor/vehicle-specific minimap icon textures when available.
- [x] Integrate compass headings and player rotation.
- [x] Scale and clip cleanly at 640x480; widescreen still needs a runtime pass.

## 3. Full overview map (`M`)

- [x] Draw the full north-up map texture using true map coordinates.
- [x] Draw player, unit, vehicle, radar objective, beacon, building, and
  tech-building markers.
- [x] Keep only capturable Silo artwork on the map itself, with
  GDI/Nod/unowned coloring and no health bar.
- [x] Move significant base buildings into one bottom row: GDI left, Nod
  right, with authored icons, health/armor, gray destroyed state, and revival
  timer.
- [x] Add the team player table with Player, credits, Class, and Vehicle.
- [x] Add side-by-side Character Overview and Vehicle Overview catalogs with
  live per-class counts.
- [x] Prevent the live 3D scene from visually competing with the overview.

## 4. Active scoreboard (`Tab`)

- [x] Separate GDI and Nod into distinct columns.
- [x] Sort players by score.
- [x] Show score, kills, deaths, vehicle kills, and ping.
- [x] Highlight the local player.
- [x] Show commander/veterancy state, team totals, and player counts.
- [x] Show team building survival totals and harvester state.
- [x] Show map information (server and mode still pending).
- [x] Cap each team column to prevent overlap (pagination/scrolling pending).
- [x] Add team-tinted roster surfaces, team scores, alternating row bands,
  local-player highlighting, and class/vehicle columns.

## 5. Main HUD layout and visual hierarchy

- [x] Restore a compact, combat-safe Renegade X layout.
- [x] Move team score and match timer into the bottom-center command strip
  (retains the top position at 640p to protect the compact status layout).
- [x] Restore distinct GDI/Nod styling and existing HUD textures/icons.
- [x] Reduce oversized generic panels and protect the center combat view.
- [x] Keep all elements resolution-aware; verified at 1920x1080 and 640x480.

## 6. Player status and veterancy

- [x] Restore health and armor presentation; intentionally omit stamina because
  Renegade X does not use it in the normal player HUD.
- [x] Show the full Recruit/Recruit I/Recruit II through Heroic promotion state,
  current/required VP, and native rank artwork.
- [x] Show character/class identity.
- [x] Show revealed state and critical-health feedback (additional damage-over-
  time effects pending).

## 7. Weapon, inventory, and abilities

- [x] Draw weapon artwork, name, magazine, reserve, and infinite-ammo state
  (infantry alternate ammo pending).
- [x] Draw weapon reload and ability recharge progress.
- [x] Draw a compact weapon-selection list (cameos and usage tips pending).
- [x] Draw ability charges, cooldown, visibility state, authored ability art,
  and team-colored recharge presentation.
- [x] Draw replicated mine, remote C4, proxy C4, and deployed-defense counts
  (beacon/grenade-specific counters pending).

## 8. Vehicle HUD

- [x] Draw vehicle health and driver health (vehicles use one health pool).
- [x] Draw primary/alternate vehicle ammo and reload state (heat-specific
  presentation pending).
- [x] Draw passenger/seat occupancy.
- [x] Draw lock/bound and boost/stamina state (vehicle abilities pending).

## 9. Building and team-status strip

- [x] Draw GDI/Nod building cells with health, armor, and authored building
  icon artwork where resolution permits.
- [x] Show destroyed and revival-timer states (disabled state pending).
- [x] Show harvester state.
- [x] Integrate team score, team player counts, match state, and timer.

## 10. Messages, vote, and announcements

- [x] Split the kill/event feed from chat/EVA/admin messages.
- [x] Restore rich segmented colors, wrapping, fading, and minimum lifetimes:
  team chat uses the complete team color, global chat colors only the sender,
  radio/Q-spot reports persist for at least seven seconds, and killer/victim
  names retain their individual team colors.
- [x] Restore vote title, counts, threshold, bound-key prompts, and timer.
- [x] Add team-accented vote framing and separate yes/no progress bars.
- [x] Route building/game announcements into the Canvas event feed.

## 11. Death, respawn, and spectator presentation

- [x] Route death reason and killer into the event feed.
- [x] Show ready/waiting state and respawn countdown (selected class pending).
- [x] Hide living-player HUD elements while dead.
- [x] Restore spectator instructions and observed-player information.

## 12. Endgame scoreboard

- [x] Show winner, victory reason, team rosters, and final building totals.
- [x] Show commander, MVP, offense, defense, and support awards.
- [x] Show final aggregate building state (individual state/duration pending).
- [x] Keep the Canvas message feed visible at endgame.
- [x] Show map-vote list, vote counts, next map, and countdown
  (selected/loading emphasis pending).

## 13. Validation

- [x] Full Win64 UnrealScript build: 0 errors and only the two pre-existing
  `Rx_Hud_Button` missing-material warnings.
- [x] Standalone smoke test at windowed 640x480 low detail.
- [x] Dedicated server/client test at windowed 640x480 low detail.
- [ ] Capture normal HUD, `Tab`, `M`, death/respawn, vote, vehicle, and endgame.
- [ ] Compare captures against every `old_` reference screenshot.
- [x] Capture and inspect normal HUD, `Tab`, and `M` at 640x480.
- [x] Capture and inspect the normal HUD and `M` overview at 1920x1080.
- [x] Confirm all test UDK processes are closed.

## 14. Art-parity and map-calibration pass

- [x] Replace generic square actor/building fallbacks with round blips while
  preserving authored vehicle and player textures.
- [x] Recreate the legacy Scaleform minimap calibration from
  `MinimapScale / MinimapCurrentZoom`; the minimap is now properly zoomed in.
- [x] Apply the authored overview zoom to both terrain and marker coordinates,
  eliminating the terrain/blip scale mismatch.
- [x] Replace the blanket teal border with subdued neutral framing and explicit
  GDI/Nod accent lines.
- [x] Restore a bottom-center score/timer command block at normal resolutions.
- [x] Make the building strip responsive so it does not collide with player and
  weapon panels at either 1920x1080 or 640x480.
- [x] Full and incremental Win64 builds: 0 errors; only the two pre-existing
  `Rx_Hud_Button` missing-material warnings.
- [x] Runtime logs contain no Canvas HUD/map script warnings and all UDK test
  processes were closed.

## 15. Rich scoreboard, artwork, and message pass

- [x] Preserve the legacy HUD's `<font color>` spans and render them as native
  Canvas text runs instead of flattening them to white.
- [x] Give chat, Q-spot/radio, and kill-feed channels readable minimum
  lifetimes independent of short engine `LocalMessage` defaults.
- [x] Render authored overview-map building symbols while keeping the compact
  minimap's round blips.
- [x] Add authored building and ability textures to their normal HUD widgets.
- [x] Capture and inspect the richer scoreboard and overview at 1920x1080 and
  the normal responsive HUD at 640x480.
- [x] Final Win64 build: 0 errors and only the two pre-existing
  `Rx_Hud_Button` missing-material warnings.
- [x] No Canvas HUD/map runtime warnings; all UDK processes closed.

## 16. Focused minimap and tactical-map parity

- [x] Remove the minimap's circular material trim and clip the authored map
  texture to the complete square panel at the legacy player-centered zoom.
- [x] Replace the exposed rotating raw-texture edge with UDK's calibrated map
  material, overscanned beyond the square diagonal with compensated zoom so
  neither its circle mask nor a tile boundary enters the visible minimap.
- [x] Verify the square remains fully covered before and after a large player
  yaw change.
- [x] Remove all building markers from the minimap; retain only player/pawn and
  vehicle markers.
- [x] Reduce minimap player, pawn, and vehicle marker sizes.
- [x] Correct authored vehicle-icon orientation while preserving the already
  calibrated marker positions and travel direction.
- [x] Apply the final tactical-map actor calibration: 90 degrees clockwise
  from the prior half-turn pass, matching the authored overview texture.
- [x] Add a player-facing direction chevron and N/S/W/E labels to the tactical
  map edges.
- [x] Remove base-building icons/health bars from the tactical-map overlay.
- [x] Keep only the capturable Silo on the tactical map, colored yellow for
  GDI, red for Nod, or bright silver while unowned.
- [x] Increase tactical-map vehicle marker brightness without changing the
  minimap palette.
- [x] Restore the bottom GDI/Nod building row, destroyed gray treatment,
  zeroed health/armor bars, and rebuild countdown.
- [x] Exclude the Airstrip's linked Air Tower actor so Nod receives one
  vehicle-factory cell instead of an extra inherited wrench cell.
- [x] Restore the Team Player, Character Overview, and Vehicle Overview
  tables and their legacy columns/catalog counts.
- [x] Compile the complete Win64 script set with 0 errors and only the two
  pre-existing `Rx_Hud_Button` material warnings.
- [x] Capture and inspect both the normal minimap and `M` overview at the
  requested windowed 640x480 resolution.

## 17. Normal player HUD data and lower layout

- [x] Add team mine count/limit, vehicle count/limit, player credits, and
  commander points/maximum in a four-row block above the minimap.
- [x] Compact that four-row block and remove its background entirely, leaving
  only icons and text.
- [x] Place promotion state, VP requirement, native promotion icon, health, and
  white armor bars immediately to the right of the minimap.
- [x] Left-align the promotion text and icon, remove the promotion-area panel,
  and retain the existing backing only behind health/armor.
- [x] Remove the stamina row and unrelated personal explosive-count text from
  the normal status panel.
- [x] Replace normal building health bars with icon-only state: white while
  active, gray while destroyed/rebuilding, and red below 20 percent health.
- [x] Restore the bottom sequence of GDI buildings, GDI score/player count,
  match state/timer, Nod score/player count, and Nod buildings.
- [x] Compile with 0 errors and only the two pre-existing `Rx_Hud_Button`
  material warnings.
- [x] Capture and inspect the collision-free normal HUD at 640x480.
- [x] Remove the non-functional GDI/Nod accent bar from the bottom edge of the
  minimap without changing the tactical overview frame.

Latest captures:

- `UDKGame/Screenshots/Win64/CanvasHUD_parity_normal.bmp`
- `UDKGame/Screenshots/Win64/CanvasHUD_parity_scoreboard.bmp`
- `UDKGame/Screenshots/Win64/CanvasHUD_parity_overview.bmp`

Second-pass captures:

- `UDKGame/Screenshots/Win64/CanvasHUD_parity_pass2_normal.bmp`
- `UDKGame/Screenshots/Win64/CanvasHUD_parity_pass2_scoreboard.bmp`
- `UDKGame/Screenshots/Win64/CanvasHUD_parity_pass2_overview.bmp`
- `UDKGame/Screenshots/Win64/CanvasHUD_parity_pass2_endgame.bmp`

Third-pass captures:

- `UDKGame/Screenshots/Win64/CanvasHUD_parity_pass3_normal.bmp`
- `UDKGame/Screenshots/Win64/CanvasHUD_parity_pass3_death.bmp`
- `UDKGame/Screenshots/Win64/CanvasHUD_parity_pass3_vehicle_harvester.bmp`
- `UDKGame/Screenshots/Win64/CanvasHUD_parity_pass3_network_normal.bmp`
- `UDKGame/Screenshots/Win64/CanvasHUD_parity_pass3_network_scoreboard.bmp`
- `UDKGame/Screenshots/Win64/CanvasHUD_parity_pass3_network_overview.bmp`

Third-pass network logs:

- `UDKGame/Logs/CanvasHUDParityPass3ServerFinal.log`
- `UDKGame/Logs/CanvasHUDParityPass3ClientFinal.log`

Art-parity captures and logs:

- `UDKGame/Screenshots/Win64/CanvasHUD_artpass_overview_1080.bmp`
- `UDKGame/Screenshots/Win64/CanvasHUD_artpass_normal_640.bmp`
- `UDKGame/Logs/CanvasHUDArt1080.log`
- `UDKGame/Logs/CanvasHUDArt640Final.log`
- `UDKGame/Logs/CanvasHUDArtBuildVerified.log`

Rich-art captures and logs:

- `UDKGame/Screenshots/Win64/CanvasHUD_rich_scoreboard_1080.bmp`
- `UDKGame/Screenshots/Win64/CanvasHUD_building_art_overview_1080.bmp`
- `UDKGame/Screenshots/Win64/CanvasHUD_rich_normal_640.bmp`
- `UDKGame/Logs/CanvasHUDRichArtValidation.log`
- `UDKGame/Logs/CanvasHUDRichArt640.log`
- `UDKGame/Logs/CanvasHUDRichArtBuildVerified.log`

Focused map-parity captures and logs:

- `UDKGame/Screenshots/Win64/ScreenShot00039.bmp` (square minimap, 640x480)
- `UDKGame/Screenshots/Win64/ScreenShot00040.bmp` (tactical map, 640x480)
- `UDKGame/Screenshots/Win64/ScreenShot00043.bmp` (corrected terrain, 640x480)
- `UDKGame/Screenshots/Win64/ScreenShot00044.bmp` (rotated/compass map, 640x480)
- `UDKGame/Screenshots/Win64/ScreenShot00045.bmp` (final rotation/brightness)
- `UDKGame/Logs/CanvasHUDMapParityFinal640.log`
- `UDKGame/Logs/CanvasHUDMapParityFinalBuild`
- `UDKGame/Logs/CanvasHUDMapCompass640.log`
- `UDKGame/Logs/CanvasHUDMapCompassBuild`
- `UDKGame/Logs/CanvasHUDMapFinalRotation640.log`
- `UDKGame/Logs/CanvasHUDMapFinalRotationBuild`

Normal player-HUD capture and logs:

- `UDKGame/Screenshots/Win64/ScreenShot00046.bmp`
- `UDKGame/Logs/CanvasHUDNormalData640Final.log`
- `UDKGame/Logs/CanvasHUDNormalDataBuild2`
- `UDKGame/Logs/CanvasHUDMinorPlayerFixesFinalBuild`

Minimap edge-removal captures and logs:

- `UDKGame/Screenshots/Win64/ScreenShot00051.bmp` (initial heading)
- `UDKGame/Screenshots/Win64/ScreenShot00052.bmp` (after large yaw change)
- `UDKGame/Logs/CanvasHUDMinimapOverscan640.log`
- `UDKGame/Logs/CanvasHUDMinimapOverscanBuild`

## Normal HUD polish pass — 2026-07-26

- [x] Rotate the minimap terrain and marker coordinate spaces 90 degrees
  clockwise as one unit.
- [x] Reduce local-player, infantry, and vehicle minimap marker sizes.
- [x] Use filtered legacy blip textures for marker fallbacks instead of stepped
  procedural squares.
- [x] Brighten GDI, Nod, and neutral vehicle markers on the minimap.
- [x] Treat the active Q-spot list as authoritative so spotted enemy vehicles
  remain visible even when their ordinary stealth/radar checks would hide them.
- [x] Enlarge mine, vehicle, credit, and commander-point icons/text above the
  minimap while keeping the element background transparent.
- [x] Enlarge veterancy state and VP text, and show `MAX VP` rather than an
  increasing point count at Heroic.
- [x] Remove the outer background/accent panel around health and armor.
- [x] Clamp general notification messages (crate pickups, missile warnings,
  and similar channel-2 notices) to 2.5–4 seconds without changing chat,
  radio/Q-spot, or kill-feed timing.
- [x] Remove the weapon background/accent panel.
- [x] Preserve weapon and vehicle-weapon icon aspect ratios.
- [x] Compile with 0 errors and only the two pre-existing `Rx_Hud_Button`
  missing-material warnings.
- [x] Launch CNC-Field at 640x480 in windowed DX9/low-detail mode and inspect
  the normal HUD.

Latest validation capture:

- `UDKGame/Screenshots/Win64/ScreenShot00054.bmp`

## Code-only HUD refinement — 2026-07-26

- [x] Make the M-key tactical overview an exclusive HUD layer.
- [x] Suppress Canvas messages, radio/taunt text, targeting overlays, player
  names, marquees, reticle/weapon overlays, play-area announcements, command
  text, spectator prompts, and the small score panel while the overview is open.
- [x] Replace the minimap marker-position path with the original
  `Rx_GFxMinimap` player-relative `IconMatrix` math.
- [x] Keep minimap marker placement independent of `MapYaw` and
  `UTMapInfo.UpdateHUDLocation` so marker positions receive exactly one
  rotation transform.
- [x] Enumerate `WorldInfo.PawnList` directly for player and vehicle markers;
  retain the radar-interface iterator only for non-pawn deployables/beacons.
- [x] Increase resource-counter row spacing, icon sizes, and text sizes.
- [x] Replace continuous health and armor bars with 20-section glowing bars.
- [x] Render depleted health/armor sections gray; use yellow health below
  50 percent and red health below 10 percent.
- [x] Remove the word `PLAYERS` from the normal HUD team counts.
- [x] Complete static brace/draw-path checks without launching UDK or the game.

Validation note:

- This pass was intentionally code-only at the user's request. It has not been
  compiled or runtime-tested yet.

## Weapon wheel and message hierarchy — 2026-07-26

- [x] Replace the owned-weapon name list with a Canvas icon carousel.
- [x] Show up to seven owned weapons around the current selection and keep the
  equipped weapon centered, enlarged, and highlighted as the player swaps.
- [x] Stack equipped-weapon information as icon, weapon name, then
  clip/reserve ammunition.
- [x] Display `999` as the reserve value for infinite-ammunition weapons.
- [x] Preserve every weapon icon's native aspect ratio.
- [x] Add a dedicated green host/game-message channel at the top-left.
- [x] Route `Special`, `System`, host-originated `Say`, `CTEXT`, and default
  `ClientMessage`/`Event` traffic—including credit donations—to that stream.
- [x] Position EVA beneath host/game messages and limit it to two rendered rows.
- [x] Position chat/radio beneath EVA and the kill/event feed beneath chat.
- [x] Increase retained message capacity so separate streams do not evict one
  another before reaching their row limits.
- [x] Complete static delimiter and routing checks without starting, stopping,
  or interacting with the user's running UDK process.

Validation note:

- Win64 full UnrealScript compile passed with 0 errors and the same two
  pre-existing `Rx_Hud_Button` missing-material warnings.
- Runtime testing was intentionally not performed.

## Map, minimap, carousel, and glow refinement — 2026-07-26

- [x] Enlarge the tactical-map terrain by 18 percent inside its existing frame.
- [x] Scale tactical-map terrain and marker coordinates together so Silo,
  vehicle, and player positions remain registered.
- [x] Shift active GDI building artwork from orange toward yellow-gold.
- [x] Rotate only minimap vehicle icon artwork 90 degrees counterclockwise by
  removing its previous quarter-turn offset.
- [x] Remove the same 90-degree vehicle-art offset from both minimap and big
  map while preserving every marker-position transform.
- [x] Brighten GDI, Nod, neutral, player, vehicle, infantry, beacon, and
  deployable minimap marker tints.
- [x] Convert the weapon carousel from horizontal to vertical.
- [x] Keep the equipped weapon centered and substantially larger than
  background carousel icons.
- [x] Add a wider low-alpha glow bleed and a brighter near-edge halo to live
  health and armor segments.
- [x] Complete static delimiter and targeted draw-path checks without building
  or launching the game.

Validation note:

- Win64 full UnrealScript compile passed with 0 errors and the same two
  pre-existing `Rx_Hud_Button` missing-material warnings.
- Runtime testing remains pending.

## Tactical layout, marker highlights, and font rendering — 2026-07-26

- [x] Expand the M-key tactical map to approximately two thirds of the screen
  width, within the available screen-height limit.
- [x] Let the three left-side tactical tables become narrower to make room for
  the larger map.
- [x] Increase the tactical terrain crop while scaling terrain and marker
  coordinates together.
- [x] Remove the rotating minimap's legacy zoom factor from big-map marker
  placement so the overview terrain and markers use the same authored scale.
- [x] Raise GDI, Nod, neutral, squad, local-player, infantry, and vehicle
  marker tints to near-full luminance on both maps.
- [x] Add a larger translucent marker pass behind map icons to provide a
  bright highlight without changing marker centers or vehicle orientation.
- [x] Move the vertical weapon carousel to the right edge above the equipped
  weapon text.
- [x] Render the equipped weapon only in the large weapon block; show only
  the other owned weapons in the cyclic vertical carousel.
- [x] Enlarge the equipped weapon and carousel icon presentation.
- [x] Supply `FontRenderInfo` to Canvas text draws, enabling the
  `SimpleElementPixelShader.usf` distance-field font path (including its
  anti-aliasing and glow parameters) when the HUD font supports distance
  fields.
- [x] Replace filtered infantry blip textures with layered solid Canvas dots
  so friendly and visible enemy markers remain bright at fractional,
  low-resolution screen positions.
- [x] Enlarge the mine and vehicle counter icons above the minimap and preserve
  their authored aspect ratios.
- [x] Drive the normal bottom-row building red-warning state from armor below
  20 percent rather than health below 20 percent.
- [x] Complete static delimiter and targeted transform/draw-path checks.

Validation note:

- Win64 full UnrealScript compile passed with 0 errors and the same two
  pre-existing `Rx_Hud_Button` missing-material warnings.
- Runtime testing was not performed.

## Canvas performance pass — 2026-07-26

- [x] Replace each three-layer, 39-rectangle infantry dot with one solid
  six-triangle hexagon submitted through `Canvas.DrawTris`.
- [x] Preserve bright team coloring and per-frame marker positions while
  refreshing radar-list membership four times per second.
- [x] Collapse per-segment health/armor glow into two shared glow passes,
  reducing two full bars from 120 rectangles to 44.
- [x] Parse message color markup once when the message arrives.
- [x] Render short cached color runs as complete spans instead of submitting
  every word separately.
- [x] Cache building membership for one second while reading live
  health/armor/destruction state every frame.
- [x] Cache weapon membership for 0.35 seconds while keeping the equipped
  weapon selection and ammunition live.
- [x] Refresh normal-HUD team counts and tactical overview count tables twice
  per second.
- [x] Refresh scoreboard membership and sorting four times per second.
- [x] Complete a full Win64 UnrealScript compile with 0 errors and only the two
  pre-existing `Rx_Hud_Button` missing-material warnings.

Validation note:

- No runtime process was launched for this performance pass.
