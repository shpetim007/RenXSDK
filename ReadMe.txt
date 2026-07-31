EA has not endorsed and does not support this product.

**********************************
***** Finding problem assets *****
**********************************
Run "UDKgame.exe ContentAuditCommandlet" to get a list of assets with issues.
This will print a summery at the end of the task, but its main job is to tag assets
in the editor content browser. You can then look up these tags to find the broken assets.
The goal is to get all of these down to 0. There is whitelisting support if needed.

Some of the tags:

    Texture_NormalmapNonDXT1CompressionNoAlphaIsTrue
    Texture_LODBiasIsNegative
    Texture_NeverStream
    Texture_G8		(G8 textures are really expensive in terms of memory. G8 textures can usually be replaced by DXT1 with no loss of quality. )

    Material_MissingPhysicalMaterial 

    PhysAsset_MissingPhysicalMaterial 

    Particle_BadFixedRelativeBoundingBox
    Particle_MissingFixedRelativeBoundingBox 

    SoundCue_DiconnectedSoundNodes
    SoundCue_MoreThan3Waves
    SoundCue_HasMixerWithMoreThan2Children
    SoundCue_NoSoundClass
    SoundCue_IncorrectAmbientSoundClass 

    SoundWave_QualityHigherThan40 

    StaticMesh_WithMissingUVSets
    StaticMesh_WithBadUVSets
    StaticMesh_EmptySections 


*********************************
***** Remove Unused content *****
*********************************
Remove unused assets by running the MoveOutUnusedContent.bat

It will create 2 new folders,
UDKGame\CutdownPackages -Which is the package after the unused conetent is removed
UDKGame\NFSContent - (Not For Shipping Content) Which is the content that was removed, so we still have a copy.
Copy the UDKGame\CutdownPackages\UDKGame folder over the UDKGame folder to apply the changes.

Add new maps to the "WrangledContent.ini" config file.

*****Problem files
UDKGame\Content\Shared\UTExampleCrowd.upk - simply rename to something like UTExampleCrowd.upk.bck

**********************************
***** Cooking/packaging game *****
**********************************
Run the package.bat file

This will do 3 things.
1. Recompile all scripts in release mode and strip source.
2. Cooks all packages, which will create a folder called CookedPC with the result.
3. Creates the GameRelease folder and copy into it only the needed files for release. 

Both the cooking and copying will only do changed files.

Add new maps to the "UDKEngine.ini/DefaultEngineUDK.ini" config file under the [Engine.PackagesToAlwaysCook] section.

Packages used by most maps (like environment packages) should be added to the [Engine.StartupPackages] section. These
packages will be loaded on startup and always in memory, saving time unloading/reloading between maps. (Watch out for 32bit 
memory limit on the startup package size).

Any packages that are used by a map, and isnt in the StartupPackages, will be baked into the map package. So watch out
for commonly used packages, that could be bloating map sizes. Find used packages in a map with the 

To control which files get put into the release folder, use the Binaries\CookerSync.xml file.
It can be used to specify which files to include, which to exclude, and different files based on which tag/platform is used.
We are using the platform=PC tag=RenXSync


***********************************
***** Custom content/uncooked *****
***********************************
Uncooked data can be put in a subfolder of the "cookedPC\CustomContent" folder. Dont put it in the folder itself.
This can be used for usermade content that hasnt been cooked.
It can also be used for our maps which are uncooked.

****** TODO
Stop mobilematerials from being built.


*******************************************
***** Generate Report from GameStats  *****
*******************************************

udk.exe WriteGameStatsReport (gamestat file)
udk.exe WriteGameStatsReport ../../UDKGame/Stats/CNC-Canyon-PC-2424394/CNC-Canyon-PC-09-19.44.43.gamestats