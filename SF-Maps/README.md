# SF Maps

Recreated Shining Force Series Maps

## Tiled basics article for SF-Maps

[Tiled Basics](https://github.com/ShiningForceRemade/SF-Maps/wiki/Tiled-Basics)

## Progress

[SF1 - 25% - click me for a breakdown](https://github.com/ShiningForceRemade/SF-Maps/tree/main/SF1)

SF2 - 0%

SFCD - 0%

## Tooling

Currently all the maps are going to be created in [Tiled](https://www.mapeditor.org/) [(latest download link)](https://github.com/mapeditor/tiled/releases).

Support and documentation will be written eventually on how to use Aseprite and Photoshop as well.

## Exporting Maps and Tilesets from tiled to Godot

1. Add the vendor/tiled-to-godot-export submodule to the Tiled extensions route (Instructions within the vendor/tiled-to-godot-export folder).

2. Before exporting, add to each tilemap and tileset a custom property called "projectRoot" (without the quotes).
   If you're following a similar repository layout to what I'm using this would be the custom path to be added in.
```shell
C:/Dev/ShiningForceRemadeRoot/ShiningForceRemade/
```

3. Export the tilesets then the tilemap.

4. Open the scene within godot to see your Tilemap.

NOTE: The maps in SF-Maps will only contain the actual tiles and map layout. Collison, interactions, Field Effect and others have to be added from within Godot for now.

