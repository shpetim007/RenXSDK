# Renegade X Canvas HUD

This source patch replaces the always-visible Scaleform gameplay HUD with a
native UE3 Canvas HUD. It includes the normal player HUD, minimap, tactical
map, scoreboard, messages, votes, death/spectator presentation, endgame UI,
and the Survival wave extension. Scaleform front-end, pause, settings, and
purchase-terminal screens remain unchanged.

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

Do **not** delete the GFx/Scaleform classes or `.upk` assets; non-gameplay
menus still require them. This patch is intended for the same Renegade X SDK
revision because `Rx_HUD.uc` and `Rx_Controller.uc` are whole-file
replacements.
