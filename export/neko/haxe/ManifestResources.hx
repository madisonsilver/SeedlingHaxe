package;

import haxe.io.Bytes;
import haxe.io.Path;
import lime.utils.AssetBundle;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import lime.utils.Assets;

#if sys
import sys.FileSystem;
#end

#if disable_preloader_assets
@:dox(hide) class ManifestResources {
	public static var preloadLibraries:Array<Dynamic>;
	public static var preloadLibraryNames:Array<String>;
	public static var rootPath:String;

	public static function init (config:Dynamic):Void {
		preloadLibraries = new Array ();
		preloadLibraryNames = new Array ();
	}
}
#else
@:access(lime.utils.Assets)


@:keep @:dox(hide) class ManifestResources {


	public static var preloadLibraries:Array<AssetLibrary>;
	public static var preloadLibraryNames:Array<String>;
	public static var rootPath:String;


	public static function init (config:Dynamic):Void {

		preloadLibraries = new Array ();
		preloadLibraryNames = new Array ();

		rootPath = null;

		if (config != null && Reflect.hasField (config, "rootPath")) {

			rootPath = Reflect.field (config, "rootPath");

			if(!StringTools.endsWith (rootPath, "/")) {

				rootPath += "/";

			}

		}

		if (rootPath == null) {

			#if (ios || tvos || webassembly)
			rootPath = "assets/";
			#elseif android
			rootPath = "";
			#elseif (console || sys)
			rootPath = lime.system.System.applicationDirectory;
			#else
			rootPath = "./";
			#end

		}

		#if (openfl && !flash && !display)
		
		#end

		var data, manifest, library, bundle;

		Assets.libraryPaths["default"] = rootPath + "manifest/default.json";
		

		library = Assets.getLibrary ("default");
		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("default");
		

	}


}

#if !display
#if flash

@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_arrow_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_arrowtrap_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_bar_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_barstool_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_beamtower_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_bed_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_blizzard_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_bluestone_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_bluestonewall_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_bluestonewalldark_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_blurregion_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_blurregion2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_blurregion2clear_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_bob_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_bobboss1_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_bobboss2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_bobboss3_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_bobbossweapons_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_bobsoldier_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_body_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_bodywall_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_bomb_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_bombpusher_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_bonetorch_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_bonetorch2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_bosskey_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_bosskey1_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_bosskey2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_bosskey3_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_bosskey4_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_bosslock_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_bosslock1_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_bosslock2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_bosslock3_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_bosslock4_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_bosstotem_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_bosstotemparts_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_bosstotemshot_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_breakablerock_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_breakablerockghost_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_brick_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_brickpole_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_brickwell_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_building_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_building1_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_building1mask_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_building2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_building2mask_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_building3_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_building3mask_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_building4_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_building4mask_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_building5_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_building5mask_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_building6_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_building6mask_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_building7_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_building7mask_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_building8_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_building8mask_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_buildingmask_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_bulb_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_burnabletree_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_burnabletreeburn_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_button_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_buttonroom_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_cactus_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_cave_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_chest_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_cliff_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_cliffside_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_cliffsidemaskl_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_cliffsidemasklu_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_cliffsidemaskr_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_cliffsidemaskru_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_cliffsidemasku_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_cliffstairs_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_coin_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_conch_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_cover_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_crusher_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_darkshield_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_darksuit_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_darktile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_darktrap_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_deathray_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_deathrayshot_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_dirt_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_dresser_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_drill_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_droplet_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_dungeonspire_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_dungeontile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_enemies_zip extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_explosion_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_explosion_strip9_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_fallrock_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_fallrocklarge_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_feather_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_finalboss_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_finaldoor_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_fire_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_firepickup_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_firewand_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_firewandpickup_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_firewandshot_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_flyer_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_forestoverworld_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_foresttile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_frozenboss_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_fuchtile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_ghostspear_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_ghostspearstab_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_ghostsword_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_ghostswordpickup_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_ghosttile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_ghosttilestep_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_grass_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_grasslock_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_grenade_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_health_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_healthpickup_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_help_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_ice_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_iceblast_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_icetrap_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_iceturret_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_icewall_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_icewalllit_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_igneouslava_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_igneoustile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_inventory_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_inventoryitems_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_inventoryitemsside_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_inventoryitemstotem_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_jellyfish_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_lamesword_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_lava_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_lava2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_lavaball_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_lavaboss_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_lavachain_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_lavarunner_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_lavatrap_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_lavatraptongue_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_light_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_lightboss_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_lightbossshot_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_lightbosstotem_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_lightpole_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_littlestones_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_lock_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_logo_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_logo2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_magicallock_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_magicallockfire_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_menuarrow_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_moonrock_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_moonrockpile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_musicby_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_npcs_adnancharacter_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_npcs_adnancharacterpic_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_npcs_bobboss1pic_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_npcs_bobboss2pic_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_npcs_bobboss3pic_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_npcs_forestcharacter_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_npcs_forestcharacterpic_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_npcs_hermit_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_npcs_hermitpic_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_npcs_introcharacter_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_npcs_introcharacterpic_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_npcs_karlore_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_npcs_karlorepic_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_npcs_oracle_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_npcs_oraclepic_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_npcs_owlpic_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_npcs_rekcahdam_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_npcs_rekcahdampic_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_npcs_sensei_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_npcs_senseipic_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_npcs_talk_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_npcs_watcher_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_npcs_watcherpic_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_npcs_witch_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_npcs_witchpic_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_npcs_yeti_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_npcs_yetipic_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_octologo_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_oddtile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_oddtilewall_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_openbridge_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_opentree_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_opentreemask_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_oraclestatue_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_orb_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_overweapon_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_pit_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_pitshadow_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_pixel_logo_large_gif extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_pixel_logo_large_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_pixel_logo_medium_gif extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_pixel_logo_medium_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_planttorch_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_playerlight_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_pod_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_podbody_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_pole_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_portal_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_promos_gif extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_promos_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_pulser_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_puncher_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_pushableblock_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_pushableblockfire_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_rackemmap_162wx158h_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_rock_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_rock2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_rock3_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_rock4_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_rockfall_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_rocklock_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_rocktile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_rockytile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_ropepulley_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_ruinedpillar_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_sandtrap_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_seal_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_seed_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_seedbloody_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_shield_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_shieldboss_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_shieldlock_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_shieldlocknorm_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_shieldstatue_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_shieldtile_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_shore_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_shrum_old_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_shrum_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_shrumblue_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_shrumdark_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_sign_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_slash_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_slashdark_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_slashhit_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_snow_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_snowhill_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_snowhillmask_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_spinner_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_spinningaxe_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_spinningaxered_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_squishle_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_stairs_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_statues_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_stick_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_stone_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_sword_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_sworddark_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_tank_gif extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_tank_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_tentacle_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_tentaclebeast_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_tentaclebeastmask_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_torch_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_torchpickup_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_totem_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_tree_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_tree2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_treebare_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_treegrow_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_treelarge_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_treelargemask_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_turret_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_turretspit_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_wallflyer_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_wand_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_wandlock_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_wandpickup_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_wandshot_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_water_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_water2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_water3_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_waterfall_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_waterfallspray_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_whirlpool_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_whirlpool_empty_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_wire_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_wood_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_woodtree_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_graphics_woodwalk_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_960x960water_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_building1_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon1_1_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon1_2_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon1_3_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon1_4_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon1_5_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon1_6_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon1_7_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon1_8_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon1_9_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon1_entrance_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon2_1_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon2_2_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon2_3_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon2_4_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon2_5_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon2_6_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon2_7_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon2_entrance_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon3_1_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon3_10_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon3_11_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon3_2_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon3_3_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon3_4_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon3_5_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon3_6_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon3_7_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon3_8_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon3_9_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon3_entrance_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon3_levelchecker_exe extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon4_1_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon4_2_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon4_3_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon4_4_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon4_boss_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon4_entrance_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon4_levelchecker_exe extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon5_1_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon5_10_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon5_11_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon5_2_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon5_3_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon5_4_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon5_5_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon5_6_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon5_7_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon5_8_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon5_9_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon5_boss_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon5_deadboss_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon5_entrance_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon6_1_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon6_10_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon6_2_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon6_3_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon6_4_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon6_5_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon6_6_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon6_7_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon6_8_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon6_9_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon6_boss_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon6_entrance_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon7_1_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon7_10_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon7_11_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon7_12_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon7_2_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon7_3_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon7_4_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon7_5_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon7_6_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon7_7_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon7_8_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon7_9_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon7_boss_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon7_entrance_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon8_1_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon8_10_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon8_11_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon8_12_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon8_2_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon8_3_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon8_4_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon8_5_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon8_6_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon8_7_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon8_8_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon8_9_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon8_entrance_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_dungeon8_towerbase_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_end_1_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_end_2_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_end_3_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_end_4_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_end_boss_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_island_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_levelchecker_cpp extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_overworld_barhouse_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_overworld_blandashurmin_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_overworld_d6entrance_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_overworld_d7entrance_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_overworld_fallhole_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_overworld_fallhole1_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_overworld_finalboss_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_overworld_house_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_overworld_intree_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_overworld_levelchecker_exe extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_overworld_mountain_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_overworld_mountain1_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_overworld_region1_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_overworld_region2_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_overworld_region3_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_overworld_region4_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_overworld_region5_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_overworld_region6_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_overworld_treelarge_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_overworld_waterfallcave_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_overworld_witchhut_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_overworld_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_overworldextended extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_levels_overworldn_oel extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_a_warrior_s_journey_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_arcticwind_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_arrowhit_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_arrowlaunch_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_bigenemyhit_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_bigenemyhop_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_biglock_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_bigrockhit_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_chest_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_cold_blooded_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_downstairs_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_drill_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_enemyfall_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_enemyhop_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_energybeam_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_energypulse_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_explosion_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_fight_me_like_a_boss_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_fireattack_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_found_it__mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_groundhit_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_groundhit2_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_how_to_lose_your_shadow_101_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_hurt_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_in_the_beginning_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_lava_is_hot_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_lavaclap_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_lavapunch_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_light_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_metalhit_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_monstersplash_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_my_first_dungeon_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_my_life_s_purpose_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_mysterious_magic_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_nextroom_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_of_the_puzzle_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_one_piece_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_playerfall_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_pop_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_punch_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_pushrock_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_rockcrumble_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_shrumcrappytestloop_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_smallenemydie_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_smallenemyhit_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_splash1_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_splash2_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_stuck_in_the_forest_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_swim_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_switch_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_sword1_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_sword2_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_sword3_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_text_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_the_key_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_the_sky_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_the_watcher_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_treeburning_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_unapproved_boss4beam_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_unapproved_boss4beam2_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_unapproved_boss4die_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_unapproved_boss4die2_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_unapproved_boss4shoot_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_unapproved_boss4start_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_unapproved_boss4walk_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_unapproved_boss5die_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_unapproved_boss5rise_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_unapproved_boss6die_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_unapproved_boss6move_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_unapproved_boss6move1_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_unapproved_boss6move2_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_unapproved_crusher_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_unapproved_enemychomp_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_unapproved_ropecut_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_unapproved_stab1_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_unapproved_stab2_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_unapproved_stab3_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_unapproved_teleport_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_unapproved_textnext_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_unapproved_turretfire_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_unapproved_turreticefire_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_upstairs_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_wandfire_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_wandfizzle_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_warriors_don_t_sleep_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_wind_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_sound_yes__master_mp3 extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__manifest_default_json extends null { }


#elseif (desktop || cpp)




#else



#end

#if (openfl && !flash)

#if html5

#else

#end

#end
#end

#end