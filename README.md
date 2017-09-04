# GameDesign2017fa
CS4154: Analytics in Game Design repo

## Installation of HAXE

1. Download HAXE from: https://haxe.org/download/
 - I will be using version 3.4.2 on this tutorial

2. Install flixel through haxe
 - For Windows, open powershell and do the following:
 - `haxelib -notimeout install flixel`
 - `flixel 4.3.0`, `lime 2.9.1`, `openfl 3.6.1` should be installed

3. Install flixel-tools
 - `haxelib install flixel-tools`
 - `flixel-tools 1.4.1` should be installed

4. `haxelib -notimeout run flixel setip`
 - answer `y` to all the prompts and we will be using `[0] Sublime Text`
 - `flixel-demos 2.4.1`, `flixel-addons 2.5.0`, `flixel-templates 4.3.0`, `flixel-ui 2.2.0` should be installed

 5. Setup lime
  - `haxelib -notimeout run lime setup`
  - `hxcpp 3.4.64`, `lime-samples 4.0.1` should be installed

## Sublime Project Setup 

`Game.sublime-project` will be the project setup template file for this repo

### Mac
```
{
	"folders":
	[
		{
			"follow_symlinks": true,
			"name": "Game",
			"path": "<path to your project>/GameDesign2017fa/Game"
		},
		{
			"follow_symlinks": true,
			"name": "Flixel",
			"path": "/usr/local/lib/haxe/lib/flixel/4,3,0/"
		},
		{
			"follow_symlinks": true,
			"name": "Flixel Addons",
			"path": "/usr/local/lib/haxe/lib/flixel-addons/2,5,0/"
		},
		{
			"follow_symlinks": true,
			"name": "Haxe",
			"path": "/usr/local/lib/haxe/std"
		}
	]
}

```
### Windows 
``` 
{
	"folders":
	[
		{
			"follow_symlinks": true,
			"name": "Game",
			"path": "<path to your project>\\GameDesign2017fa/Game"
		},
		{
			"follow_symlinks": true,
			"name": "Flixel",
			"path": "C:\\HaxeToolkit\\haxe\\lib\\flixel/4,3,0/"
		},
		{
			"follow_symlinks": true,
			"name": "Flixel Addons",
			"path": "C:\\HaxeToolkit\\haxe\\lib\\flixel-addons/2,5,0/"
		},
		{
			"follow_symlinks": true,
			"name": "Haxe",
			"path": "C:\\HaxeToolkit\\haxe\\std"
		}
	]
}

```
