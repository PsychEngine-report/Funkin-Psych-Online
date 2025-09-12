package backend;

import openfl.utils.Assets;

#if desktop
import sys.io.File;
import sys.FileSystem;
#elseif mobile
import backend.io.PsychFile as File;
import backend.io.PsychFileSystem as FileSystem;
#end

class NoteSkinData {
	public static var noteSkins:Array<NoteSkinStructure> = [];
	public static var noteSkinArray:Array<String> = [];

	public static function reloadNoteSkins()
	{
		noteSkins = [];
		noteSkinArray = [];

		var directories:Array<Array<String>> = [[Paths.getLibraryPathForce('', 'shared'), '']];
		#if MODS_ALLOWED
		directories.push([Paths.mods(), '']);

		for (mod in Mods.parseList().enabled)
		{
			if(Mods.getGlobalMods().contains(mod))
				directories.push([Paths.mods(mod + '/'), mod]);
		}
		#end

		var skinsFinished:Array<String> = [];

		for (i in 0...directories.length) {
			var directory:String = directories[i][0] + 'images/noteSkins/list.txt';

			for (skin in CoolUtil.coolTextFile(directory)) {
				if(!noteSkinArray.contains(skin)) {
					noteSkins.push({
						skin: skin, 
						folder: directories[i][1], 
						url: online.mods.OnlineMods.getModURL(directories[i][1])
					});

					noteSkinArray.push(skin);
				}
			}
		}

		noteSkins.insert(0, {skin: ClientPrefs.defaultData.noteSkin, folder: ''}); //Default skin always comes first
		noteSkinArray.insert(0, ClientPrefs.defaultData.noteSkin);
	}

	public static function getCurrent(?player:Int = 0):NoteSkinStructure
	{
		var toReturn:NoteSkinStructure = null;
		
		if(player == -1)
			toReturn = NoteSkinData.noteSkins[NoteSkinData.noteSkinArray.indexOf(ClientPrefs.data.noteSkin)];
		else
			toReturn = NoteSkinData.noteSkins[NoteSkinData.noteSkinArray.indexOf(ClientPrefs.getNoteSkin(player))];

		if(toReturn == null)
			toReturn = NoteSkinData.noteSkins[0];

		return toReturn;
	}
}

typedef NoteSkinStructure = {
	var skin:String;
	var folder:String;
	@:optional var url:String;
}
